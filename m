Return-Path: <linux-kernel-owner+w=401wt.eu-S1761842AbXGFODQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761842AbXGFODQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 10:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbXGFODF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 10:03:05 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:44533 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbXGFODE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 10:03:04 -0400
X-Originating-Ip: 72.143.66.27
Date: Fri, 6 Jul 2007 10:00:36 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] I386: Deactivate the test for the dead CONFIG_BALANCED_IRQ_DEBUG
 variable.
In-Reply-To: <468E49DE.1000100@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.0707060957390.27008@localhost.localdomain>
References: <Pine.LNX.4.64.0707060844280.23613@localhost.localdomain>
 <468E49DE.1000100@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jul 2007, Stefan Richter wrote:

> Robert P. J. Day wrote:
> > --- a/arch/i386/kernel/io_apic.c
> > +++ b/arch/i386/kernel/io_apic.c
> > @@ -353,7 +353,7 @@ static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t cpumask)
> >  # include <linux/slab.h>		/* kmalloc() */
> >  # include <linux/timer.h>	/* time_after() */
> >
> > -#ifdef CONFIG_BALANCED_IRQ_DEBUG
> > +#if 0 /* debug IRQ balancing */
> >  #  define TDprintk(x...) do { printk("<%ld:%s:%d>: ", jiffies, __FILE__, __LINE__); printk(x); } while (0)
> >  #  define Dprintk(x...) do { TDprintk(x); } while (0)
> >  # else
>
> Regarding the Subject:  Perhaps it's not of type "dead (K)config
> variable"in the strict sense but rather of the type "local macro
> whose name was unbefittingly taken from CONFIG_ namespace".
>
> BTW, when I suggested the "#if 0" to you, I forgot that some
> developers might be interested in compiling their kernel with
> -DCONFIG_BALANCED_IRQ_DEBUG injected via the commandline. But we'll
> hear from them if that's the case.
>
> On the other hand, these debug macros seem to be very old.  I'll
> have a closer look with qgit/git-blame later today.  Maybe it's time
> to remove them now.

ok, why don't i leave all that in your capable hands?  typically, when
i describe a CONFIG_ prefixed variable as "dead", it's because it's
not being set *anywhere* in the tree -- not in a Kconfig file or a
header file or a source file or a Makefile.

so i'm not just checking for its existence in a Kconfig file.  i
learned that lesson.  :-)

rday

p.s.  and i've bitched and moaned about this before, but anyone who
deliberately names their debugging variables with a "CONFIG_" prefix
*deserves* to have their builds break.  :-P

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
