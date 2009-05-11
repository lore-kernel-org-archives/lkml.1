Return-Path: <linux-kernel-owner+w=401wt.eu-S1758577AbZEKKMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577AbZEKKMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 06:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758217AbZEKKLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 06:11:52 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:52411 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758138AbZEKKLu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 06:11:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=En7qOzBKLYYrKNpMz7Hj6hWtnMUHwYdmLDUWeeM0hHg8C+aiFZ3MkLEvkXfiaZJVmW
         /3PotCuW5xPszXA1cboP/YzajuwSyaqoiAkbQhwlJ4bcsMehjUF/JUn+5u7+RLLi1oAX
         yof0wj4uWzwA1HMg4si1uHcyJgObKfoSG9IGs=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0905081102060.14384@venus.araneidae.co.uk>
References: <Pine.LNX.4.64.0905060829580.24668@venus.araneidae.co.uk> 
	<20090506102202.73d6045d@hyperion.delvare> <Pine.LNX.4.64.0905081102060.14384@venus.araneidae.co.uk>
From: =?GB2312?B?0sHU8w==?= <wxc200@gmail.com>
Date: Mon, 11 May 2009 18:11:35 +0800
Message-ID: <fd6b62c10905110311w6350828tf90d9c699b73fe30@mail.gmail.com>
Subject: Re: [PATCH 2.6.29.2] PXA I2C: Define log level for i2c PXA error 
	report
To: Michael Abbott <michael@araneidae.co.uk>
Cc: Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/11 Michael Abbott <michael@araneidae.co.uk>
>
> On Wed, 6 May 2009, Jean Delvare wrote:
> > On Wed, 6 May 2009 08:32:09 +0100 (BST), Michael Abbott wrote:
> > > All the i2c pxa error messages should probably be KERN_DEBUG
> > >
> > > At least, all the printk messages should have a log level specfied,
> > > and KERN_DEBUG seems appropriate.
> > >
> > > Signed-off-by: Michael Abbott <michael.abbott@diamond.ac.uk>
> > > ---
> > >  drivers/i2c/busses/i2c-pxa.c |    8 ++++----
> > >  1 files changed, 4 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
> > > index bdb1f75..8cb9160 100644
> > > --- a/drivers/i2c/busses/i2c-pxa.c
> > > +++ b/drivers/i2c/busses/i2c-pxa.c
> > > @@ -210,11 +210,11 @@ static irqreturn_t i2c_pxa_handler(int this_irq, void *dev_id);
> > >  static void i2c_pxa_scream_blue_murder(struct pxa_i2c *i2c, const char *why)
> > >  {
> > >     unsigned int i;
> > > -   printk("i2c: error: %s\n", why);
> > > -   printk("i2c: msg_num: %d msg_idx: %d msg_ptr: %d\n",
> > > +   printk(KERN_DEBUG "i2c: error: %s\n", why);
> > > +   printk(KERN_DEBUG "i2c: msg_num: %d msg_idx: %d msg_ptr: %d\n",
> > >             i2c->msg_num, i2c->msg_idx, i2c->msg_ptr);
> > > -   printk("i2c: ICR: %08x ISR: %08x\n"
> > > -          "i2c: log: ", readl(_ICR(i2c)), readl(_ISR(i2c)));
> > > +   printk(KERN_DEBUG "i2c: ICR: %08x ISR: %08x\n"
> > > +          KERN_DEBUG "i2c: log: ", readl(_ICR(i2c)), readl(_ISR(i2c)));
> > >     for (i = 0; i < i2c->irqlogidx; i++)
> > >             printk("[%08x:%08x] ", i2c->isrlog[i], i2c->icrlog[i]);
> > >     printk("\n");
> >
> > Already fixed in Linus' tree:
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=154d22b04ae1741c5fcfd5d747b813a9a279abff#patch4
>
> Now this is very odd.  I'd assumed the error messages I was getting were
> just noise, but the commit you point me to uses KERN_ERR instead -- and so
> I get a brief storm of these messages on boot on my target:
>
> [   20.667923] i2c: error: exhausted retries
> [   20.671962] i2c: msg_num: 0 msg_idx: -2000 msg_ptr: 0
> [   20.677113] i2c: ICR: 000007e0 ISR: 00000002
> [   20.677128] i2c: log: [00000446:000007e0]
>
> This is repeated nine times in total with exactly the same numbers.  Any
> thoughts as to what this means?  Other than these messages on startup my
> I2C sensors seem to work perfectly well.
If all error messages seem like "exhausted retries",not "timeout or
master error",there maybe some operation conflicts,and i2c controller
cannot succeed operateing after max times retry.  And which mode do
your i2c work?  Poll or Interrupt?

thanks
--wxc200

> --
> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
