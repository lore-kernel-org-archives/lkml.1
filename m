Return-Path: <linux-kernel-owner+w=401wt.eu-S1752866AbZIIJSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbZIIJSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 05:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbZIIJSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 05:18:45 -0400
Received: from mail.gmx.net ([213.165.64.20]:36918 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752792AbZIIJSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 05:18:44 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/zeXVpzRfziTgucyjYMANGOvmM6PD+nT+0dRydjj
	jl7a5o776ux68B
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1252486954.7746.173.camel@twins>
References: <20090906205952.GA6516@elte.hu>
	 <20090907094953.GP18599@kernel.dk> <20090907115750.GW18599@kernel.dk>
	 <20090907141458.GD24507@elte.hu> <20090907173846.GB18599@kernel.dk>
	 <20090907204458.GJ18599@kernel.dk> <20090908091304.GQ18599@kernel.dk>
	 <1252423398.7746.97.camel@twins> <20090908203409.GJ18599@kernel.dk>
	 <20090909061308.GA28109@elte.hu>
	 <1252486344.28645.18.camel@marge.simson.net>
	 <1252486954.7746.173.camel@twins>
Content-Type: text/plain
Date: Wed, 09 Sep 2009 11:18:43 +0200
Message-Id: <1252487923.9621.5.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-09 at 11:02 +0200, Peter Zijlstra wrote:
> On Wed, 2009-09-09 at 10:52 +0200, Mike Galbraith wrote:
> > @@ -1502,7 +1502,8 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int sync)
> >          */
> >         if (sched_feat(LAST_BUDDY) && likely(se->on_rq && curr != rq->idle))
> >                 set_last_buddy(se);
> > -       set_next_buddy(pse);
> > +       if (sched_feat(NEXT_BUDDY))
> > +               set_next_buddy(pse);
> >  
> >         /*
> >          * We can come here with TIF_NEED_RESCHED already set from new task
> 
> You might want to test stuff like sysbench again, iirc we went on a
> cache-trashing rampage without buddies.
> 
> Our goal is not to excel at any one load but to not suck at any one
> load.

Oh absolutely.  I wouldn't want buddies disabled by default, I only
added the buddy knob to test effects on fork/exec.

I only posted to patch to give Jens something canned to try out.

	-Mike

