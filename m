Return-Path: <linux-kernel-owner+w=401wt.eu-S1030967AbXDWC4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030967AbXDWC4t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 22:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030969AbXDWC4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 22:56:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46995 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030967AbXDWC4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 22:56:48 -0400
Date: Mon, 23 Apr 2007 04:55:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch] CFS scheduler, -v5
Message-ID: <20070423025553.GA10407@elte.hu>
References: <20070420140457.GA14017@elte.hu> <20070423011229.GA20367@elte.hu> <20070423012509.GA25162@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423012509.GA25162@wotan.suse.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <npiggin@suse.de> wrote:

> > the biggest user-visible change in -v5 are various interactivity 
> > improvements (especially under higher load) to fix reported 
> > regressions, and an improved way of handling nice levels. There's 
> > also a new sys_sched_yield_to() syscall implementation for i686 and 
> > x86_64.
> > 
> > All known regressions have been fixed. (knock on wood)
> 
> I think the granularity is still much too low. Why not increase it to 
> something more reasonable as a default?

note that CFS's "granularity" value is not directly comparable to 
"timeslice length":

> [ Note: while CFS's default preemption granularity is currently set to
>   5 msecs, this value does not directly transform into timeslices: for 
>   example two CPU-intense tasks will have effective timeslices of 10 
>   msecs with this setting. ]

also, i just checked SD: 0.46 defaults to 8 msecs rr_interval (on 1 CPU 
systems), which is lower than the 10 msecs effective timeslice length 
CVS-v5 achieves on two CPU-bound tasks.

(in -v6 i'll scale the granularity up a bit with the number of CPUs, 
like SD does. That should get the right result on larger SMP boxes too.)

while i agree it's a tad too finegrained still, I agree with Con's 
choice: rather err on the side of being too finegrained and lose some 
small amount of throughput on cache-intense workloads like compile jobs, 
than err on the side of being visibly too choppy for users on the 
desktop.

	Ingo
