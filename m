Return-Path: <linux-kernel-owner+w=401wt.eu-S1756186AbYGRLHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186AbYGRLHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 07:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbYGRLHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 07:07:33 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:59324 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbYGRLHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 07:07:33 -0400
Subject: Re: [PATCH] sched: do not stop ticks when cpu is not idle
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: eric miao <eric.y.miao@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Jack Ren <jack.ren@marvell.com>, Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
In-Reply-To: <20080718105424.GA22268@elte.hu>
References: <f17812d70807172341u92270fdvc80e72cc5599c56f@mail.gmail.com>
	 <20080718102446.GV6875@elte.hu>  <20080718105424.GA22268@elte.hu>
Content-Type: text/plain
Date: Fri, 18 Jul 2008 13:08:03 +0200
Message-Id: <1216379283.28405.19.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-18 at 12:54 +0200, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -4446,7 +4446,8 @@ need_resched_nonpreemptible:
> >  		rq->nr_switches++;
> >  		rq->curr = next;
> >  		++*switch_count;
> > -
> > +		if (rq->curr != rq->idle)
> > +			tick_nohz_restart_sched_tick();
> >  		context_switch(rq, prev, next); /* unlocks the rq */
> 
> hm, one problem i can see is lock dependencies. This code is executed 
> with the rq lock while tick_nohz_restart_sched_tick() takes hr locks => 
> not good. So i havent applied this just yet - this needs to be solved 
> differently.

Actually, that should work these days...

Also, I assume Eric actually tested this with lockdep enabled (right,
Eric?) and that'll shout - or rather, lockup hard in this case - if you
got it wrong.

