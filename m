Return-Path: <linux-kernel-owner+w=401wt.eu-S1758680AbXHBQIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680AbXHBQIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 12:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756097AbXHBQId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 12:08:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57408 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755102AbXHBQIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 12:08:32 -0400
Date: Thu, 2 Aug 2007 18:08:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [git pull request] scheduler updates
Message-ID: <20070802160825.GA18710@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest scheduler git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

these are all low-risk sched.o and task_struct debloating patches:

   text    data     bss     dec     hex filename
  37033    3066      20   40119    9cb7 sched.o.debug.before
  34840    3066      20   37926    9426 sched.o.debug.after

   text    data     bss     dec     hex filename
  28997    2726      16   31739    7bfb sched.o.before
  27991    2726      16   30733    780d sched.o.after

1006 bytes of code off in the nondebug case (this also speeds things up) 
and 2193 bytes of code off in the debug case. The size of sched.o is now 
1k smaller than it was before CFS on SMP, and within 1k of its old size 
on UP. (Further reduction is possible, there is another patch that 
shaves off another 500 bytes but it needs some more testing.)

also a nice smpnice cleanup/simplification from Peter Williams.

built and booted on x86-32 and x86-64, built allnoconfig and 
allyesconfig, and for good measure it also passed 38 iterations of 'make 
randconfig; make -j vmlinux' builds without any failure.

Thanks!

	Ingo

------------------->

Ingo Molnar (10):
      sched: remove cache_hot_time
      sched: calc_delta_mine(): use fixed limit
      sched: uninline calc_delta_mine()
      sched: uninline inc/dec_nr_running()
      sched: ->task_new cleanup
      sched: move load-calculation functions
      sched: add schedstat_set() API
      sched: use schedstat_set() API
      sched: reduce debug code
      sched: reduce task_struct size

Peter Williams (1):
      sched: tidy up left over smpnice code

 include/linux/sched.h    |   24 +++--
 include/linux/topology.h |    1 
 kernel/sched.c           |  193 +++++++++++++++++++++++------------------------
 kernel/sched_debug.c     |   22 +++--
 kernel/sched_fair.c      |   21 +----
 kernel/sched_rt.c        |   14 ---
 kernel/sched_stats.h     |    2 
 7 files changed, 134 insertions(+), 143 deletions(-)
