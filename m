Return-Path: <linux-kernel-owner+w=401wt.eu-S1757648AbYBRKBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648AbYBRKBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 05:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756667AbYBRJ71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 04:59:27 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:30593 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753722AbYBRJ7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 04:59:23 -0500
Message-Id: <20080218095625.340366000@chello.nl>
References: <20080218095535.629736000@chello.nl>
User-Agent: quilt/0.45-1
Date: Mon, 18 Feb 2008 10:55:40 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       dhaval@linux.vnet.ibm.com, tong.n.li@intel.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 5/7] sched: remove sysctl_sched_batch_wakeup_granularity
Content-Disposition: inline; filename=sched-fair-remove-batch-wakeup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Its unused,.. toss it!

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |    1 -
 kernel/sched.c        |    1 -
 kernel/sched_debug.c  |    1 -
 kernel/sched_fair.c   |   10 ----------
 kernel/sysctl.c       |   11 -----------
 5 files changed, 24 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1526,7 +1526,6 @@ extern void sched_idle_next(void);
 extern unsigned int sysctl_sched_latency;
 extern unsigned int sysctl_sched_min_granularity;
 extern unsigned int sysctl_sched_wakeup_granularity;
-extern unsigned int sysctl_sched_batch_wakeup_granularity;
 extern unsigned int sysctl_sched_child_runs_first;
 extern unsigned int sysctl_sched_features;
 extern unsigned int sysctl_sched_migration_cost;
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -62,16 +62,6 @@ const_debug unsigned int sysctl_sched_ch
 unsigned int __read_mostly sysctl_sched_compat_yield;
 
 /*
- * SCHED_BATCH wake-up granularity.
- * (default: 10 msec * (1 + ilog(ncpus)), units: nanoseconds)
- *
- * This option delays the preemption effects of decoupled workloads
- * and reduces their over-scheduling. Synchronous workloads will still
- * have immediate wakeup/sleep latencies.
- */
-unsigned int sysctl_sched_batch_wakeup_granularity = 10000000UL;
-
-/*
  * SCHED_OTHER wake-up granularity.
  * (default: 10 msec * (1 + ilog(ncpus)), units: nanoseconds)
  *
Index: linux-2.6/kernel/sysctl.c
===================================================================
--- linux-2.6.orig/kernel/sysctl.c
+++ linux-2.6/kernel/sysctl.c
@@ -270,17 +270,6 @@ static struct ctl_table kern_table[] = {
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "sched_batch_wakeup_granularity_ns",
-		.data		= &sysctl_sched_batch_wakeup_granularity,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
-		.extra1		= &min_wakeup_granularity_ns,
-		.extra2		= &max_wakeup_granularity_ns,
-	},
-	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "sched_child_runs_first",
 		.data		= &sysctl_sched_child_runs_first,
 		.maxlen		= sizeof(unsigned int),
Index: linux-2.6/kernel/sched_debug.c
===================================================================
--- linux-2.6.orig/kernel/sched_debug.c
+++ linux-2.6/kernel/sched_debug.c
@@ -214,7 +214,6 @@ static int sched_debug_show(struct seq_f
 	PN(sysctl_sched_latency);
 	PN(sysctl_sched_min_granularity);
 	PN(sysctl_sched_wakeup_granularity);
-	PN(sysctl_sched_batch_wakeup_granularity);
 	PN(sysctl_sched_child_runs_first);
 	P(sysctl_sched_features);
 #undef PN
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -5381,7 +5381,6 @@ static inline void sched_init_granularit
 		sysctl_sched_latency = limit;
 
 	sysctl_sched_wakeup_granularity *= factor;
-	sysctl_sched_batch_wakeup_granularity *= factor;
 }
 
 #ifdef CONFIG_SMP

--

