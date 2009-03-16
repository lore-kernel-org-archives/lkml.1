Return-Path: <linux-kernel-owner+w=401wt.eu-S1754432AbZCPLzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432AbZCPLzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 07:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbZCPLzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 07:55:32 -0400
Received: from support.balabit.hu ([195.70.41.86]:41032 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751340AbZCPLzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 07:55:31 -0400
Subject: Re: [patch] Re: scheduler oddity [bug?]
From: Balazs Scheidler <bazsi@balabit.hu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Willy Tarreau <w@1wt.eu>
In-Reply-To: <20090315185719.GD19737@elte.hu>
References: <1236605870.6515.5.camel@marge.simson.net>
	 <1236606389.8389.518.camel@laptop>
	 <1236607083.5980.8.camel@marge.simson.net>
	 <1236607890.6168.7.camel@marge.simson.net>
	 <1236609711.8389.583.camel@laptop>
	 <1236612649.6019.38.camel@marge.simson.net>
	 <1236615158.8389.705.camel@laptop>
	 <1236619694.5998.9.camel@marge.simson.net>
	 <1237125227.6919.1.camel@bzorp.balabit>
	 <1237137414.5980.2.camel@marge.simson.net> <20090315185719.GD19737@elte.hu>
Content-Type: text/plain
Date: Mon, 16 Mar 2009 12:55:23 +0100
Message-Id: <1237204523.18422.38.camel@bzorp.balabit>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-15 at 19:57 +0100, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > On Sun, 2009-03-15 at 14:53 +0100, Balazs Scheidler wrote:
> > > On Mon, 2009-03-09 at 18:28 +0100, Mike Galbraith wrote:
> > > > On Mon, 2009-03-09 at 17:12 +0100, Peter Zijlstra wrote:
> > > > > On Mon, 2009-03-09 at 16:30 +0100, Mike Galbraith wrote:
> > > > > > +static void put_prev_task(struct rq *rq, struct task_struct *prev)
> > > > > > +{
> > > > > > +       if (prev->state == TASK_RUNNING) {
> > > > > > +               u64 runtime = prev->se.sum_exec_runtime;
> > > > > > +
> > > > > > +               runtime -= prev->se.prev_sum_exec_runtime;
> > > > > > +               runtime = min_t(u64, runtime, 2*sysctl_sched_migration_cost);
> > > > > > +
> > > > > > +               /*
> > > > > > +                * In order to avoid avg_overlap growing stale when we are
> > > > > > +                * indeed overlapping and hence not getting put to sleep, grow
> > > > > > +                * the avg_overlap on preemption.
> > > > > > +                */
> > > > > > +               update_avg(&prev->se.avg_overlap, runtime);
> > > > > > +       }
> > > > > > +       prev->sched_class->put_prev_task(rq, prev);
> > > > > > +}
> > > > > 
> > > > > Right, so we both found it worked quite well, I'm still slightly puzzled
> > > > > but it.
> > > > > 
> > > > > If something gets preempted a lot and will therefore have short runtimes
> > > > > it will be seen as sync even though it might not at all be.
> > > > 
> > > > Yes, and the netperf on 2 CPUs with shared cache numbers show that's
> > > > happening.  It just so happens that in the non-shared case, netperf's
> > > > cache pain far outweighs the benefit of having more CPU available :-/
> > > 
> > > Any news on this? I haven't seen a patch that was actually integrated,
> > > or I just missed something?
> > 
> > It's in tip, as df1c99d416500da8d26a4d78777467c53ee7689e.
> 
> testable via:
> 
>   http://people.redhat.com/mingo/tip.git/README
> 
> Balazs, could you please try it?

Sure I'll try, although not today as my first son was born yesterday,
and I have a lot of things to do, but hopefully I can give a spin
tomorrow.


-- 
Bazsi


