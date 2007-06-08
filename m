Return-Path: <linux-kernel-owner+w=401wt.eu-S970137AbXFHT7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970137AbXFHT7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 15:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750795AbXFHT73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 15:59:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60296 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbXFHT72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 15:59:28 -0400
Date: Fri, 8 Jun 2007 21:58:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: [patch] CFS scheduler, -v16
Message-ID: <20070608195840.GA14928@elte.hu>
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

i'm pleased to announce release -v16 of the CFS scheduler patchset.

The rolled-up CFS patch against v2.6.22-rc4, v2.6.22-rc4-mm2, v2.6.21.4 
or v2.6.20.13 can be downloaded from the usual place:

     http://people.redhat.com/mingo/cfs-scheduler/

-v16 includes smaller fixes. Continued work on precise /proc CPU 
accounting of both SCHED_OTHER and RT tasks by Dmitry Adamushko and 
Balbir Singh. Reniced tasks should now disturb nice-0 tasks even less. 
Also, i have changed SCHED_BATCH back to its current mainline meaning 
and have added a SCHED_IDLEPRIO instead (first introduced by Con Kolivas 
in staircase/RSDL/SD).
 
Changes since -v15:

 - more /proc CPU stats accounting improvements (Dmitry Adamushko, 
   Balbir Singh)

 - fix SCHED_BATCH (reported by Con Kolivas)

 - update_load_fair() - use 64-bit arithmetics (Dmitry Adamushko)

 - fix RT->NORMAL accounting issue raised by Srivatsa Vaddagiri: have 
   correct exec_start stamping. (Dmitry Adamushko)

 - check for negative deltas in task_sched_runtime() (Dmitry Adamushko)

 - check for large forward-jumping sched_clock()

 - cleanup: remove task_struct :: last_ran (Dmitry Adamushko)

 - /proc/sched_debug printk fixes (Andrew Morton)

 - add SCHED_IDLEPRIO

 - consolidate the granularity settings and make them scale together

 - improve /proc/sched_debug output

 - remove the yield workarounds - the default seems to be working now.

 - introduce lower and upper limits for the granularity tunables. 
   Setting them to zero accidentally broke nice levels.

 - various small fixes/cleanups

As usual, any sort of feedback, bugreport, fix and suggestion is more 
than welcome!
 
	Ingo
