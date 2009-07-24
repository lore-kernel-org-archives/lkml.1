Return-Path: <linux-kernel-owner+w=401wt.eu-S1752936AbZGXOrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbZGXOrG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 10:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752745AbZGXOrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 10:47:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56325 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbZGXOrE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 10:47:04 -0400
Subject: Re: report a bug about sched_rt
From: Peter Zijlstra <peterz@infradead.org>
To: sen wang <wangsen.linux@gmail.com>
Cc: mingo@elte.hu, akpm@linux-foundation.org, kernel@kolivas.org,
       npiggin@suse.de, arjan@infradead.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <454c71700907240724u76b970e5y5af0fc114cc92f83@mail.gmail.com>
References: <454c71700907240357l61f5c4fajaca73db0fba7db8@mail.gmail.com>
	 <1248437670.6987.26.camel@twins>
	 <454c71700907240604h4673f117j8ed58b9f2ee54798@mail.gmail.com>
	 <1248441290.6987.52.camel@twins>
	 <454c71700907240626w127fd890ufa91ef90cbcaaa@mail.gmail.com>
	 <1248442415.6987.56.camel@twins>
	 <454c71700907240644h7469e2a5sfcb57f202a2e184d@mail.gmail.com>
	 <1248443656.6987.61.camel@twins>
	 <454c71700907240724u76b970e5y5af0fc114cc92f83@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 24 Jul 2009 16:48:30 +0200
Message-Id: <1248446910.6987.111.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-24 at 22:24 +0800, sen wang wrote:

> > No, but the 1 group is the trivial case of many groups. Changing the
> > semantics for the trivial case is inconsistent at best, and confusing at
> > worst.

> yes! 1 group is the trivial case ,but you can't say it is useless. and
> in some system
> it is important!
> I have read across the schedule codes and tried this way,it work:
> static struct task_struct *pick_next_task_rt(struct rq *rq)
> { ...
>        if (rt_rq_throttled(rt_rq)&& rq->cfs.nr_running)
>                return NULL;
> ....
> }

That might work in the current implementation, but like I already
explained, its not consistent with the multi-group case. Also, people
are working on making it a proper EDF scheduled CBS, it won't
generalize.

> > How is it my problem when you design your system wrong?
> 
> my system is good. but there is no rules what the idle task will do,so.
> people always write codes in idle task with the assume: no any running
> task in the system.
> and people also always write codes in rt task with the assume: if I am
> in running state
> ,system will not idle.
> 
> so what i said above is some like theory,but I don't like the word “theory".
> I call it people's common sense.
> 
> but the behavior of the  throttled RT group is changed from people's
> common sense,so don't say people's common sense is wrong. OK?

There are plenty of examples where common sense utterly fails, the one
that comes to mind is Probability Theory.

> > If you want your 1 RT group to not get throttled, disable the throttle,
> > or adjust it to fit the parameters of your workload. If you don't want
> > idle to have latency impact on your RT tasks, fix your idle behaviour.
> >
> 
> 1 RT is important to me. But I also have fair task, so  throttled is
> also important to me.
> and don't say : idle have latency impact on RT tasks. It is too
> ludicrous Why we make   intended latency impact by ourselves,by wrong
> idle task?

Yes, configurable idle tasks are nothing new. If you care about wakeup
latency then idle=poll is preferred (it sucks for power saving, but such
is life).

On your embedded board you seem to have a particularly aggressive idle
function wrt power savings, which would result in rather large wake from
idle latencies, regardless of the bandwidth throttle, so what is the
problem?

If you're using the bandwidth throttle to control your RT tasks so as
not to starve your SCHED_OTHER tasks, then I will call your system ill
designed.


