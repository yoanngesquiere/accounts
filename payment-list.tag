<person>
    <p each={payments}>
        {amount}
    </p>
    <form onsubmit={add_payment}>
        <input name="payment_amount">
        <input type="submit" value="Add a payment" />
    </form>

    var self = this

    this.payments = this.parent.payments || [];

    add_payment() {
        if(parseFloat(this.payment_amount.value)) {
            this.payments.push({ amount: parseFloat(this.payment_amount.value) });
            this.payment_amount.value = "";
            this.parent.parent.update();
        }
    }

    update_total() {
        var total = 0;
        for(i=0; i<this.payments.length; i++) {
            total = total + this.payments[i].amount;
        }
        this.parent.setTotal(total);
    }

    update_due() {
        persons = this.parent.parent.personList;
        nbPersons = persons.length;
        totalAmount = 0;
        for(i=0; i<nbPersons; i++) {
            payments = persons[i].payments;
            for(j=0; j<payments.length; j++) {
                totalAmount = totalAmount + payments[j].amount;
            }
        }
        var part = (totalAmount / nbPersons);
        this.parent.setPart(part);
        this.parent.updateDue();
    }


    this.on('update', function(){
        if (this.parent.parent) {
            this.update_total();
            this.update_due();
        }
    });
</person>

<payment-list>
    <table class="table">
        <thead>
            <tr>
                <td each={personList}>
                    {name}
                </td>
                <td>
                    <form onsubmit={add_person}>
                        <input name="person_name">
                        <input type="submit" value="Add a person" />
                    </form>
                </td>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td each={personList}>
                    <person name="person"></person>
                </td>
            </tr>
            <tr>
                <td each={personList}>
                    <p>TOTAL: {total}</p>
                    <p>{amountDueLabel}: {due}</p>
                </td>
            </tr>
        </tbody>
    </table>

    var self = this;
    this.part = 0;
    this.personList = []



    Person(name) {
        var self = this;

        this.part = 0;
        this.name = name;
        this.payments = [];
        this.due = 0;
        this.total = 0;
        this.amountDueLabel = "Amount owed";

        updateDue() {
            this.due = this.part - this.total;
            this.amountDueLabel = "Amount owed";
            if (this.due < 0) {
                this.due = -this.due;
                this.amountDueLabel = "Amount to receive";
            }
            this.due = this.due.toFixed(2);
        }

        setPart(part) {
            this.part = part;
        }

        setTotal(total) {
            this.total = total;
        }
    }

    add_person() {
        var person = new this.Person(this.person_name.value);
        this.personList.push(person);
        this.person_name.value = "";
    }

</payment-list>


