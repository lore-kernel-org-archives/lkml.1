Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936AbZHPUGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbZHPUGE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 16:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755882AbZHPUGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 16:06:03 -0400
Received: from www.tglx.de ([62.245.132.106]:34745 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755880AbZHPUGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 16:06:02 -0400
Date: Sun, 16 Aug 2009 22:05:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Michael Buesch <mb@bu3sch.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: Threaded interrupt handlers broken?
In-Reply-To: <200908161951.13988.mb@bu3sch.de>
Message-ID: <alpine.LFD.2.00.0908162201220.2782@localhost.localdomain>
References: <200908161153.14081.mb@bu3sch.de> <200908161546.46328.mb@bu3sch.de> <alpine.LFD.2.00.0908161601570.2782@localhost.localdomain> <200908161951.13988.mb@bu3sch.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Aug 2009, Michael Buesch wrote:
> On Sunday 16 August 2009 16:25:13 Thomas Gleixner wrote:
> > On Sun, 16 Aug 2009, Michael Buesch wrote:
> > > On Sunday 16 August 2009 15:22:29 Thomas Gleixner wrote:
> > >
> > > > > +		if (0&&unlikely(desc->status & IRQ_DISABLED)) {
> > > > 
> > > > So the interrupt is marked disabled. How do you setup the handler
> > > > ?  And what does the primary handler do ? Can you post your driver
> > > > code please?
> > > 
> > > This patch converts the b43 driver to threaded interrupts:
> > > http://bu3sch.de/patches/wireless-testing/20090816-1535/patches/002-b43-threaded-irq-handler.patch
> > 
> > On the first glance this looks not too bad. the unlocked access to the
> > irq status registers looks a bit scary, but that is not relevant for
> > the problem at hand.
> 
> Yeah it does ;)
> 
> > > It kind of works with this hack applied to kernel/irq/manage.c
> > 
> > Hmm. Is the interrupt of the device shared ?
> 
> It's registered as shared, but on my machine it is not shared with anything else.
> 
> > If yes, what's the other 
> > device on that interrupt line ? what puzzles me is the fact that the
> > IRQ_DISABLED flag is set. Is there anything unusual in dmesg ?
> 
> Here's my current kernel log with the two patches applied:
> http://bu3sch.de/misc/dmesg

Hmm. Nothing interesting AFAICT, but it would be really interesting to
find out why the IRQ_DISABLED flag is set.

Can you add some debug into disable_irq() e.g. WARN_ON(irq ==
BC43_IRQ_NR); so we can see what disables that interrupt.

Thanks,

	tglx


