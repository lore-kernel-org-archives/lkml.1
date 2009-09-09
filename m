Return-Path: <linux-kernel-owner+w=401wt.eu-S1753596AbZIIPjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbZIIPjr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 11:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753590AbZIIPjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 11:39:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:54945 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585AbZIIPjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 11:39:43 -0400
Date: Wed, 9 Sep 2009 15:37:21 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1252486344.28645.18.camel@marge.simson.net>
References: <1252486344.28645.18.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Re-tune the scheduler latency defaults to decrease worst-case latencies
Message-ID: <tip-172e082a9111ea504ee34cbba26284a5ebdc53a7@git.kernel.org>
Git-Commit-ID: 172e082a9111ea504ee34cbba26284a5ebdc53a7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 09 Sep 2009 15:37:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  172e082a9111ea504ee34cbba26284a5ebdc53a7
Gitweb:     http://git.kernel.org/tip/172e082a9111ea504ee34cbba26284a5ebdc53a7
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Wed, 9 Sep 2009 15:41:37 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Sep 2009 17:30:06 +0200

sched: Re-tune the scheduler latency defaults to decrease worst-case latencies

Reduce the latency target from 20 msecs to 5 msecs.

Why? Larger latencies increase spread, which is good for scaling,
but bad for worst case latency.

We still have the ilog(nr_cpus) rule to scale up on bigger
server boxes.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1252486344.28645.18.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched_fair.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index af325a3..26fadb4 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -24,7 +24,7 @@
 
 /*
  * Targeted preemption latency for CPU-bound tasks:
- * (default: 20ms * (1 + ilog(ncpus)), units: nanoseconds)
+ * (default: 5ms * (1 + ilog(ncpus)), units: nanoseconds)
  *
  * NOTE: this latency value is not the same as the concept of
  * 'timeslice length' - timeslices in CFS are of variable length
@@ -34,13 +34,13 @@
  * (to see the precise effective timeslice length of your workload,
  *  run vmstat and monitor the context-switches (cs) field)
  */
-unsigned int sysctl_sched_latency = 20000000ULL;
+unsigned int sysctl_sched_latency = 5000000ULL;
 
 /*
  * Minimal preemption granularity for CPU-bound tasks:
- * (default: 4 msec * (1 + ilog(ncpus)), units: nanoseconds)
+ * (default: 1 msec * (1 + ilog(ncpus)), units: nanoseconds)
  */
-unsigned int sysctl_sched_min_granularity = 4000000ULL;
+unsigned int sysctl_sched_min_granularity = 1000000ULL;
 
 /*
  * is kept at sysctl_sched_latency / sysctl_sched_min_granularity
@@ -63,13 +63,13 @@ unsigned int __read_mostly sysctl_sched_compat_yield;
 
 /*
  * SCHED_OTHER wake-up granularity.
- * (default: 5 msec * (1 + ilog(ncpus)), units: nanoseconds)
+ * (default: 1 msec * (1 + ilog(ncpus)), units: nanoseconds)
  *
  * This option delays the preemption effects of decoupled workloads
  * and reduces their over-scheduling. Synchronous workloads will still
  * have immediate wakeup/sleep latencies.
  */
-unsigned int sysctl_sched_wakeup_granularity = 5000000UL;
+unsigned int sysctl_sched_wakeup_granularity = 1000000UL;
 
 const_debug unsigned int sysctl_sched_migration_cost = 500000UL;
 
