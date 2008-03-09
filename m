Return-Path: <linux-kernel-owner+w=401wt.eu-S1757257AbYCIRSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257AbYCIRSV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 13:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbYCIRRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 13:17:06 -0400
Received: from viefep32-int.chello.at ([62.179.121.50]:44382 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990AbYCIRRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 13:17:05 -0400
Message-Id: <20080309170928.118626000@chello.nl>
References: <20080309170850.256853000@chello.nl>
User-Agent: quilt/0.45-1
Date: Sun, 09 Mar 2008 18:09:00 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Mike Galbraith <efault@gmx.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC/PATCH 10/17] sched: remove sysctl_sched_batch_wakeup_granularity
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

Index: linux-2.6-2/include/linux/sched.h
===================================================================
--- linux-2.6-2.orig/include/linux/sched.h
+++ linux-2.6-2/include/linux/sched.h
@@ -1539,7 +1539,6 @@ extern void sched_idle_next(void);
 extern unsigned int sysctl_sched_latency;
 extern unsigned int sysctl_sched_min_granularity;
 extern unsigned int sysctl_sched_wakeup_granularity;
-extern unsigned int sysctl_sched_batch_wakeup_granularity;
 extern unsigned int sysctl_sched_child_runs_first;
 extern unsigned int sysctl_sched_features;
 extern unsigned int sysctl_sched_migration_cost;
Index: linux-2.6-2/kernel/sched_fair.c
===================================================================
--- linux-2.6-2.orig/kernel/sched_fair.c
+++ linux-2.6-2/kernel/sched_fair.c
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
Index: linux-2.6-2/kernel/sysctl.c
===================================================================
--- linux-2.6-2.orig/kernel/sysctl.c
+++ linux-2.6-2/kernel/sysctl.c
@@ -271,17 +271,6 @@ static struct ctl_table kern_table[] = {
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
Index: linux-2.6-2/kernel/sched_debug.c
===================================================================
--- linux-2.6-2.orig/kernel/sched_debug.c
+++ linux-2.6-2/kernel/sched_debug.c
@@ -214,7 +214,6 @@ static int sched_debug_show(struct seq_f
 	PN(sysctl_sched_latency);
 	PN(sysctl_sched_min_granularity);
 	PN(sysctl_sched_wakeup_granularity);
-	PN(sysctl_sched_batch_wakeup_granularity);
 	PN(sysctl_sched_child_runs_first);
 	P(sysctl_sched_features);
 #undef PN
Index: linux-2.6-2/kernel/sched.c
===================================================================
--- linux-2.6-2.orig/kernel/sched.c
+++ linux-2.6-2/kernel/sched.c
@@ -5702,7 +5702,6 @@ static inline void sched_init_granularit
 		sysctl_sched_latency = limit;
 
 	sysctl_sched_wakeup_granularity *= factor;
-	sysctl_sched_batch_wakeup_granularity *= factor;
 }
 
 #ifdef CONFIG_SMP

--

