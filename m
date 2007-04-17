Return-Path: <linux-kernel-owner+w=401wt.eu-S1751784AbXDQHC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbXDQHC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 03:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbXDQHC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 03:02:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35948 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784AbXDQHCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 03:02:25 -0400
Date: Tue, 17 Apr 2007 09:01:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [patch] CFS (Completely Fair Scheduler), v2
Message-ID: <20070417070132.GA27261@elte.hu>
References: <20070416220715.GA4071@elte.hu> <200704170053.58611.gene.heskett@gmail.com> <20070417061849.GA12385@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070417061849.GA12385@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> ok - fortunately the delta between -v2-rc0 and -v2-final is pretty 
> small. One difference is the child-runs-first fix. To restore the 
> parent-runs-first logic, do this:
> 
> 	echo 0 > /proc/sys/kernel/sched_child_runs_first
> 
> does this make any difference?

ok, i've got something better to test: i separated the delta out into a 
more finegrained stack of 3 patches. You can pick them up from:

 http://redhat.com/~mingo/cfs-scheduler/older/sched-cfs-v2-rc0.patch
 http://redhat.com/~mingo/cfs-scheduler/older/sched-cfs-v2-rc0-preempt-fix.patch
 http://redhat.com/~mingo/cfs-scheduler/older/sched-cfs-v2-rc0-child-runs-first.patch
 http://redhat.com/~mingo/cfs-scheduler/older/sched-cfs-v2-rc0-misc.patch

i test-built and test-booted all 4 steps of this. The baseline -v2-rc0 
patch should be the one that works - you might want to double-check it, 
just to be sure. One of the other 3 patches ontop of this baseline 
causes the regression on your desktop. My current bet is on preempt-fix, 
so i have put that one first. The other one would be the second patch, 
child-runs-first. The misc patch should have no effect on behavior - but 
i've included it for completeness. (and i was wrong about the 'nice 
fix', it is not in this delta)

	Ingo
