Return-Path: <linux-kernel-owner+w=401wt.eu-S1752334AbYFSUQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbYFSUQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 16:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbYFSUQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 16:16:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48187 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbYFSUQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 16:16:51 -0400
Subject: Re: [PATCH 10/10] sched: rt: dont stop the period timer when there
	are tasks wanting to run
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Daniel K." <dk@uw.no>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <485ABD3A.9090704@uw.no>
References: <20080619122218.971447669@chello.nl>
	 <20080619123314.398446193@chello.nl>  <485ABD3A.9090704@uw.no>
Content-Type: text/plain
Date: Thu, 19 Jun 2008 22:16:17 +0200
Message-Id: <1213906578.3223.113.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-19 at 20:10 +0000, Daniel K. wrote:
> Peter Zijlstra wrote:
> > When a runnable group failed to get any runtime within a period it would be
> > found idle and the period timer would be stopped.
> > 
> > So if the group ever gets throttled, it will never wake up again.
> > 
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Reported-by: "Daniel K." <dk@uw.no>
> Tested-by: Daniel K. <dk@uw.no>
> 
> I think this should go into .26 as well, due to the non-intuitiveness
> of the knobs that cause this if they are fiddled with in the wrong way.

Sounds reasonable, Ingo?

> > ---
> >  kernel/sched_rt.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > Index: linux-2.6/kernel/sched_rt.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/sched_rt.c
> > +++ linux-2.6/kernel/sched_rt.c
> > @@ -408,7 +408,8 @@ static int do_sched_rt_period_timer(stru
> >  			if (rt_rq->rt_time || rt_rq->rt_nr_running)
> >  				idle = 0;
> >  			spin_unlock(&rt_rq->rt_runtime_lock);
> > -		}
> > +		} else if (rt_rq->rt_nr_running)
> > +			idle = 0;
> >  
> >  		if (enqueue)
> >  			sched_rt_rq_enqueue(rt_rq);
> > 
> 

