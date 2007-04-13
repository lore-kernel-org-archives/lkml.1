Return-Path: <linux-kernel-owner+w=401wt.eu-S1030880AbXDMXSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030880AbXDMXSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 19:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030885AbXDMXSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 19:18:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51632 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030882AbXDMXSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 19:18:23 -0400
Date: Sat, 14 Apr 2007 01:18:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070413231809.GA15894@elte.hu>
References: <20070413202100.GA9957@elte.hu> <20070413223131.GA1642@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070413223131.GA1642@1wt.eu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Willy Tarreau <w@1wt.eu> wrote:

> >    central tunable:
> > 
> >          /proc/sys/kernel/sched_granularity_ns
> > 
> >    which can be used to tune the scheduler from 'desktop' (low
> >    latencies) to 'server' (good batching) workloads. It defaults to a
> >    setting suitable for desktop workloads. SCHED_BATCH is handled by the
> >    CFS scheduler module too.
> 
> I find this useful, but to be fair with Mike and Con, they both have 
> proposed similar tuning knobs in the past and you said you did not 
> want to add that complexity for admins. [...]

yeah. [ Note that what i opposed in the past was mostly the 'export all 
the zillion of sched.c knobs to /sys and let people mess with them' kind 
of patches which did exist and still exist. A _single_ knob, which 
represents basically the totality of parameters within sched_fair.c is 
less of a problem. I dont think i ever objected to this knob within 
staircase/SD. (If i did then i was dead wrong.) ]

> [...] People can sometimes be demotivated by seeing their proposals 
> finally used by people who first rejected them. And since both Mike 
> and Con both have done a wonderful job in that area, we need their 
> experience and continued active participation more than ever.

very much so! Both Con and Mike has contributed regularly to upstream 
sched.c:

 $ git-log kernel/sched.c | grep 'by: Con Kolivas' 1 | wc -l
 19

 $ git-log kernel/sched.c | grep 'by: Mike' | wc -l
 6

and i'd very much like both counts to increase steadily in the future 
too :)

> >  - reworked/sanitized SMP load-balancing: the runqueue-walking
> >    assumptions are gone from the load-balancing code now, and 
> >    iterators of the scheduling modules are used. The balancing code 
> >    got quite a bit simpler as a result.
> 
> Will this have any impact on NUMA/HT/multi-core/etc... ?

it will inevitably have some sort of effect - and if it's negative, i'll 
try to fix it.

I got rid of the explicit cache-hot tracking code and replaced it with a 
more natural pure 'pick the next-to-run task first, that is likely the 
most cache-cold one' logic. That just derives naturally from the rbtree 
approach.

> > the core scheduler got smaller by more than 700 lines:
> 
> Well done !

thanks :)

	Ingo
