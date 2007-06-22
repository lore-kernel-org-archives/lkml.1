Return-Path: <linux-kernel-owner+w=401wt.eu-S1759689AbXFVWCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759689AbXFVWCz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 18:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754061AbXFVWCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 18:02:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53285 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209AbXFVWCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 18:02:47 -0400
Date: Sat, 23 Jun 2007 00:02:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: [patch] CFS scheduler, -v18
Message-ID: <20070622220202.GA16872@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
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


i'm pleased to announce release -v18 of the CFS scheduler patchset.

The rolled-up CFS patch against today's -git kernel, v2.6.22-rc5, 
v2.6.22-rc4-mm2, v2.6.21.5 or v2.6.20.14 can be downloaded from the 
usual place:

   http://people.redhat.com/mingo/cfs-scheduler/

The biggest change in -v18 are various performance related improvements. 
Thomas Gleixner has eliminated expensive 64-bit divisions by converting 
the arithmetics to scaled math (without impacting the quality of 
calculations). Srivatsa Vaddagiri and Dmitry Adamushko have continued 
the abstraction and cleanup work. Srivatsa Vaddagiri and Christoph 
Lameter fixed the NUMA balancing bug reported by Paul McKenney. There 
were also a good number of other refinements to the CFS code. (No 
reproducible behavioral regressions were reported against -v17 so far, 
so the 'behavioral' bits are mostly unchanged.)
 
Changes since -v17:

 - implement scaled math speedups for CFS. (Thomas Gleixner)

 - lots of core code updates, cleanups and streamlining.
   (Srivatsa Vaddagiri, Dmitry Adamushko, me.)

 - bugfix: fix NUMA balancing. (Srivatsa Vaddagiri, Christoph Lameter,
   Paul E. McKenney)

 - feature: SCHED_IDLE now also implies block-scheduler (CFQ)
   idle-IO-priority. (suggested by Thomas Sattler, picked up from -ck)

 - build fix for ppc32. (reported, tested and confirmed fixed by
   Art Haas)

 - ARM fix. (reported and debugged by Thomas Gleixner)

 - cleanup: implemented idle_sched_class in kernel/sched_idletask.c as a
   way to separate out rq->idle handling out of the core scheduler. This
   made a good deal of idle-task related special-cases go away.

 - debug: make the sysctls safer by introducing high and low limits.

 - cleanup: move some of the debug counters to under CONFIG_SCHEDSTATS.

 - speedup: various micro-optimizations

 - various other small updates.

As usual, any sort of feedback, bugreport, fix and suggestion is more 
than welcome!
   
	Ingo
