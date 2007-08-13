Return-Path: <linux-kernel-owner+w=401wt.eu-S973402AbXHMQsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S973402AbXHMQsn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S971767AbXHMQFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 12:05:22 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:56160 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S971824AbXHMQFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 12:05:13 -0400
X-Originating-Ip: 72.143.66.27
Date: Mon, 13 Aug 2007 11:54:42 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
cc: surya.prabhakar@wipro.com, mingo@redhat.com, yaku@css1.kbnes.nec.co.jp,
       kisimoto@css1.kbnes.nec.co.jp, zab@redhat.com,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [KJ] replacing kmalloc with kzalloc in io_apic.c
In-Reply-To: <200708131518.20580.m.kozlowski@tuxland.pl>
Message-ID: <Pine.LNX.4.64.0708131153190.4382@localhost.localdomain>
References: <1186993881.3175.15.camel@bluegenie> <200708131518.20580.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.541, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	SARE_SUB_OBFU_Z 0.26)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2007, Mariusz Kozlowski wrote:

> > Hi,
> >    Replacing kmalloc with kzalloc and cleaning up memset in
> > arch/i386/kernel/io_apic.c
> >
> >
> > Signed-off-by: Surya Prabhakar <surya.prabhakar@wipro.com>
> > ---
> >
> > diff --git a/arch/i386/kernel/io_apic.c b/arch/i386/kernel/io_apic.c
> > index 4b8a8da..1329615 100644
> > --- a/arch/i386/kernel/io_apic.c
> > +++ b/arch/i386/kernel/io_apic.c
> > @@ -690,14 +690,12 @@ static int __init balanced_irq_init(void)
> >  		physical_balance = 1;
> >
> >  	for_each_online_cpu(i) {
> > -		irq_cpu_data[i].irq_delta = kmalloc(sizeof(unsigned long) * NR_IRQS,
> > GFP_KERNEL); -		irq_cpu_data[i].last_irq = kmalloc(sizeof(unsigned long) *
> > NR_IRQS, GFP_KERNEL); +		irq_cpu_data[i].irq_delta =
> > kzalloc(sizeof(unsigned long) * NR_IRQS, GFP_KERNEL);
> > +		irq_cpu_data[i].last_irq = kzalloc(sizeof(unsigned long) * NR_IRQS,
> > GFP_KERNEL); if (irq_cpu_data[i].irq_delta == NULL ||
> > irq_cpu_data[i].last_irq == NULL) { printk(KERN_ERR "balanced_irq_init: out
> > of memory");
> >  			goto failed;
> >  		}
> > -		memset(irq_cpu_data[i].irq_delta,0,sizeof(unsigned long) * NR_IRQS);
> > -		memset(irq_cpu_data[i].last_irq,0,sizeof(unsigned long) * NR_IRQS);
> >  	}
> >
> >  	printk(KERN_INFO "Starting balanced_irq\n");
>
> How about using kcalloc here?
>
> i.e.
> ...
> ... = kcalloc(NR_IRQS, sizeof(unsigned long), GFP_KERNEL);
> ...

from my days submitting numerous patches of this type, i can recall
that in cases like the above, it's a judgment call -- use kzalloc to
get the zeroing, or use kcalloc to get the array-flavoured behaviour.
what a shame you can't have both at the same time.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
