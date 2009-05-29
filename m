Return-Path: <linux-kernel-owner+w=401wt.eu-S1759878AbZE2NP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759878AbZE2NP4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 09:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759666AbZE2NPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 09:15:43 -0400
Received: from www.tglx.de ([62.245.132.106]:59406 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759600AbZE2NPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 09:15:42 -0400
Date: Fri, 29 May 2009 15:15:26 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
cc: linux-kernel@vger.kernel.org, Rob van der Heij <rvdheij@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>
Subject: Re: [patch 1/2] idle profile hits with NOHZ
In-Reply-To: <20090529145614.77694e20@skybase>
Message-ID: <alpine.LFD.2.00.0905291514470.3397@localhost.localdomain>
References: <20090528150447.152019714@de.ibm.com> <20090528150502.044210490@de.ibm.com> <alpine.LFD.2.00.0905282204130.3397@localhost.localdomain> <20090529145614.77694e20@skybase>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 May 2009, Martin Schwidefsky wrote:
> On Thu, 28 May 2009 22:19:44 +0200 (CEST)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Thu, 28 May 2009, Martin Schwidefsky wrote:
> > > --- quilt-2.6.orig/kernel/time/tick-sched.c
> > > +++ quilt-2.6/kernel/time/tick-sched.c
> > > @@ -166,6 +166,7 @@ static void tick_nohz_stop_idle(int cpu)
> > >  		ts->idle_lastupdate = now;
> > >  		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
> > >  		ts->idle_active = 0;
> > > +		ts->idle_pc = profile_pc(get_irq_regs());
> > 
> >   Hmm, tick_nohz_stop_idle() is called from
> >   tick_nohz_restart_sched_tick() as well in the context of the idle
> >   task.
> > 
> >   I think there is no guarantee that get_irq_regs() will return
> >   anything useful in thread context.
> > 
> >   So get_irq_regs() might return a NULL pointer which will explode
> >   some of the profile_pc() implementations. If not it can still feed
> >   total nonsense to the profile_hits() call.
> 
> Drat, but if it is called from idle we should be able to just skip the
> assignment to ts->idle_pc, no? Then a simple in_interrupt() test is
> missing.

That should do the trick.

Thanks,

	tglx
