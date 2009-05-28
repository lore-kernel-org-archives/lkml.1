Return-Path: <linux-kernel-owner+w=401wt.eu-S1761227AbZE1M7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761227AbZE1M7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 08:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757351AbZE1M7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 08:59:22 -0400
Received: from www.tglx.de ([62.245.132.106]:38191 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756839AbZE1M7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 08:59:21 -0400
Date: Thu, 28 May 2009 14:53:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Paul Mundt <lethal@linux-sh.org>
cc: Peter Zijlstra <peterz@infradead.org>, Daniel Walker <dwalker@fifo99.com>,
       Linus Walleij <linus.ml.walleij@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: Re: [PATCH] sched: Support current clocksource handling in fallback
 sched_clock().
In-Reply-To: <20090528124207.GA28830@linux-sh.org>
Message-ID: <alpine.LFD.2.00.0905281450480.3397@localhost.localdomain>
References: <1243348681.23657.14.camel@twins> <alpine.LFD.2.00.0905262209160.1762@localhost.localdomain> <20090526230855.GA27218@linux-sh.org> <alpine.LFD.2.00.0905270140030.1762@localhost.localdomain> <20090527001543.GA8493@linux-sh.org>
 <1243441525.28705.19.camel@desktop> <20090528091936.GA27545@linux-sh.org> <1243503281.23657.80.camel@twins> <20090528110902.GA27884@linux-sh.org> <alpine.LFD.2.00.0905281417500.3397@localhost.localdomain> <20090528124207.GA28830@linux-sh.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 May 2009, Paul Mundt wrote:

> On Thu, May 28, 2009 at 02:22:17PM +0200, Thomas Gleixner wrote:
> > On Thu, 28 May 2009, Paul Mundt wrote:
> > > @@ -437,10 +441,19 @@ void clocksource_unregister(struct clocksource *cs)
> > >  	unsigned long flags;
> > >  
> > >  	spin_lock_irqsave(&clocksource_lock, flags);
> > > +
> > > +	if (sched_clocksource == cs) {
> > > +		printk(KERN_WARNING "Refusing to unregister "
> > > +		       "scheduler clocksource %s", cs->name);
> > 
> >   Hmm, isn't that dangerous ? The clocksource might be in a module or
> >   in kmalloced memory which is going to be freed.
> > 
> Perhaps the saner thing to do is see if select_clocksource() manages to
> find something suitable, otherwise switch back to jiffies..

That makes sense. The scheduler should be able handle that, if not ... :)
 
Thanks,

	tglx
