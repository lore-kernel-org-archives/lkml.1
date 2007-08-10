Return-Path: <linux-kernel-owner+w=401wt.eu-S1759519AbXHJHKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759519AbXHJHKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 03:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbXHJHKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 03:10:05 -0400
Received: from mx12.go2.pl ([193.17.41.142]:38946 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752537AbXHJHKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 03:10:03 -0400
Date: Fri, 10 Aug 2007 09:10:38 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Marcin =?iso-8859-2?Q?=A6lusarz?= <marcin.slusarz@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jean-Baptiste Vignaud <vignaud@xandmail.fr>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       shemminger <shemminger@linux-foundation.org>,
       linux-net <linux-net@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch (testing)] Re: 2.6.20->2.6.21 - networking dies after random time
Message-ID: <20070810071038.GA1764@ff.dom.local>
References: <20070806070300.GA4509@elte.hu> <4bacf17f0708070046o14403089v8376a4544f72fec3@mail.gmail.com> <20070807082321.GB2120@ff.dom.local> <4bacf17f0708070237w19d184b3p7f74b53612edb9a6@mail.gmail.com> <20070807095246.GB3223@ff.dom.local> <20070807121339.GA3946@ff.dom.local> <4bacf17f0708080409t116b5c84ye60dff7da51d0fdf@mail.gmail.com> <20070808114243.GC2426@ff.dom.local> <20070809091919.GB2423@ff.dom.local> <4bacf17f0708092333n17e0ba19jf2c769531610868d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4bacf17f0708092333n17e0ba19jf2c769531610868d@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2007 at 08:33:27AM +0200, Marcin ¦lusarz wrote:
> 2007/8/9, Jarek Poplawski <jarkao2@o2.pl>:
...
> > diff -Nurp 2.6.23-rc1-/kernel/irq/chip.c 2.6.23-rc1/kernel/irq/chip.c
> > --- 2.6.23-rc1-/kernel/irq/chip.c       2007-07-09 01:32:17.000000000 +0200
> > +++ 2.6.23-rc1/kernel/irq/chip.c        2007-08-08 20:49:07.000000000 +0200
> > @@ -389,12 +389,19 @@ handle_fasteoi_irq(unsigned int irq, str
> >         unsigned int cpu = smp_processor_id();
> >         struct irqaction *action;
> >         irqreturn_t action_ret;
> > +       int edge = 0;
> >
...
> NETDEV WATCHDOG: eth0: transmit timed out
> eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=351.
> eth0: Resetting the 8390 t=4295229000...<6>NETDEV WATCHDOG: eth0:
> transmit timed out
> eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=718.
> eth0: Resetting the 8390 t=4295230000...<6>NETDEV WATCHDOG: eth0:
> transmit timed out
> eth0: Tx timed out, lost interrupt? TSR=0x3, ISR=0x3, t=874.
> etc...

So, we still have to wait for the exact explanation...

Thanks very much Marcin!

I think, there is this one possible for your testing yet?:
Subject: [patch] genirq: temporary fix for level-triggered IRQ resend
Date: Wed, 8 Aug 2007 13:00:37 +0200

If it's not a great problem it would be interesting to try this with
different CONFIG_HZ too e.g. you could start with 100 (I guess, you
tested very similar thing in 2.6.23-rc2 with 1000(?) already).

Jean-Baptiste: you can skip/break testing of this 'experimental'
patch, too.

Regards,
Jarek P.
