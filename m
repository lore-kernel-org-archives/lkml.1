Return-Path: <linux-kernel-owner+w=401wt.eu-S1161413AbXD1P0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161413AbXD1P0P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 11:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161430AbXD1P0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 11:26:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47915 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161413AbXD1P0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 11:26:13 -0400
Date: Sat, 28 Apr 2007 17:25:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       Kasper Sandberg <lkml@metanurb.dk>, buddabrod <buddabrod@gmail.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: [patch] CFS scheduler, -v7
Message-ID: <20070428152539.GA21601@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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


i'm pleased to announce release -v7 of the CFS scheduler patchset. (The 
main goal of CFS is to implement "desktop scheduling" with as high 
quality as technically possible.)

The CFS patch against v2.6.21 (or against v2.6.20.8) can be downloaded 
from the usual place:

    http://redhat.com/~mingo/cfs-scheduler/

-v6 got lots of nice feedback and the -v5 list of regressions has shrunk 
considerably. The most user-visible change in -v7 should be a fix for an 
interactivity problem that should/could explain the 'audio skipping' 
problem reported by Kasper Sandberg. (which was the only main regression 
reported against -v6. Please re-report regressions, if any.)

the rate of change is moderate:

    15 files changed, 150 insertions(+), 124 deletions(-)

half of that code-flux is due to the removal of the X auto-renice patch 
and most of the rest is debugging related. It seems the CFS codebase is 
slowly starting to settle down. (-v7 has been test-built and test-booted 
on i686 and x86_64 UP and SMP systems.)

Changes since -v6:

 - speedup: cache rb_leftmost better (Srivatsa Vaddagiri)

 - bugfix: handle Priority Inheritance properly (Thomas Gleixner)

 - interactivity fix: tighten up arithmetics some more.

 - feature removal: remove the X auto-renicing feature, CONFIG_BOOST_X.

 - debugging feature: introduce the sched_sleep_history_max_ns tunable
   to modify sleep-history handling.

 - debugging feature: /proc/<PID>/sched file contains various useful
   scheduler statistics about every task.

 - debugging feature: track the maximum amount of time a task has been
   waiting to get on the CPU, the maximum amount of time it was blocked
   involuntarily and the maximum amount of time it was sleeping
   voluntarily.

As usual, any sort of feedback, bugreport, fix and suggestion is more 
than welcome,

	Ingo
