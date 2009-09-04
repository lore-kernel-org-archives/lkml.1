Return-Path: <linux-kernel-owner+w=401wt.eu-S933680AbZIDKZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933680AbZIDKZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 06:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933664AbZIDKZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 06:25:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:48648 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933645AbZIDKZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 06:25:54 -0400
Date: Fri, 4 Sep 2009 10:25:18 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, ego@in.ibm.com, hpa@zytor.com,
       mingo@redhat.com, andreas.herrmann3@amd.com, a.p.zijlstra@chello.nl,
       balbir@in.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: balbir@in.ibm.com, mingo@redhat.com, hpa@zytor.com, ego@in.ibm.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       andreas.herrmann3@amd.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/balancing] sched: Clean up topology.h
Message-ID: <tip-47734f89be0614b5acbd6a532390f9c72f019648@git.kernel.org>
Git-Commit-ID: 47734f89be0614b5acbd6a532390f9c72f019648
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 04 Sep 2009 10:25:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  47734f89be0614b5acbd6a532390f9c72f019648
Gitweb:     http://git.kernel.org/tip/47734f89be0614b5acbd6a532390f9c72f019648
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 4 Sep 2009 11:21:24 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 4 Sep 2009 11:52:53 +0200

sched: Clean up topology.h

Re-organize the flag settings so that it's visible at a glance
which sched-domains flags are set and which not.

With the new balancer code we'll need to re-tune these details
anyway, so make it cleaner to make fewer mistakes down the
road ;-)

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/topology.h |   47 +++++++-----
 include/linux/topology.h        |  169 +++++++++++++++++++++++----------------
 2 files changed, 129 insertions(+), 87 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 066ef59..be29eb8 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -129,25 +129,34 @@ extern unsigned long node_remap_size[];
 #endif
 
 /* sched_domains SD_NODE_INIT for NUMA machines */
-#define SD_NODE_INIT (struct sched_domain) {		\
-	.min_interval		= 8,			\
-	.max_interval		= 32,			\
-	.busy_factor		= 32,			\
-	.imbalance_pct		= 125,			\
-	.cache_nice_tries	= SD_CACHE_NICE_TRIES,	\
-	.busy_idx		= 3,			\
-	.idle_idx		= SD_IDLE_IDX,		\
-	.newidle_idx		= SD_NEWIDLE_IDX,	\
-	.wake_idx		= 1,			\
-	.forkexec_idx		= SD_FORKEXEC_IDX,	\
-	.flags			= SD_LOAD_BALANCE	\
-				| SD_BALANCE_EXEC	\
-				| SD_BALANCE_FORK	\
-				| SD_WAKE_AFFINE	\
-				| SD_WAKE_BALANCE	\
-				| SD_SERIALIZE,		\
-	.last_balance		= jiffies,		\
-	.balance_interval	= 1,			\
+#define SD_NODE_INIT (struct sched_domain) {				\
+	.min_interval		= 8,					\
+	.max_interval		= 32,					\
+	.busy_factor		= 32,					\
+	.imbalance_pct		= 125,					\
+	.cache_nice_tries	= SD_CACHE_NICE_TRIES,			\
+	.busy_idx		= 3,					\
+	.idle_idx		= SD_IDLE_IDX,				\
+	.newidle_idx		= SD_NEWIDLE_IDX,			\
+	.wake_idx		= 1,					\
+	.forkexec_idx		= SD_FORKEXEC_IDX,			\
+									\
+	.flags			= 1*SD_LOAD_BALANCE			\
+				| 0*SD_BALANCE_NEWIDLE			\
+				| 1*SD_BALANCE_EXEC			\
+				| 1*SD_BALANCE_FORK			\
+				| 0*SD_WAKE_IDLE			\
+				| 1*SD_WAKE_AFFINE			\
+				| 1*SD_WAKE_BALANCE			\
+				| 0*SD_SHARE_CPUPOWER			\
+				| 0*SD_POWERSAVINGS_BALANCE		\
+				| 0*SD_SHARE_PKG_RESOURCES		\
+				| 1*SD_SERIALIZE			\
+				| 0*SD_WAKE_IDLE_FAR			\
+				| 0*SD_PREFER_SIBLING			\
+				,					\
+	.last_balance		= jiffies,				\
+	.balance_interval	= 1,					\
 }
 
 #ifdef CONFIG_X86_64_ACPI_NUMA
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 6203ae5..fe2c032 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -85,21 +85,29 @@ int arch_update_cpu_topology(void);
 #define ARCH_HAS_SCHED_WAKE_IDLE
 /* Common values for SMT siblings */
 #ifndef SD_SIBLING_INIT
-#define SD_SIBLING_INIT (struct sched_domain) {		\
-	.min_interval		= 1,			\
-	.max_interval		= 2,			\
-	.busy_factor		= 64,			\
-	.imbalance_pct		= 110,			\
-	.flags			= SD_LOAD_BALANCE	\
-				| SD_BALANCE_NEWIDLE	\
-				| SD_BALANCE_FORK	\
-				| SD_BALANCE_EXEC	\
-				| SD_WAKE_AFFINE	\
-				| SD_WAKE_BALANCE	\
-				| SD_SHARE_CPUPOWER,	\
-	.last_balance		= jiffies,		\
-	.balance_interval	= 1,			\
-	.smt_gain		= 1178,	/* 15% */	\
+#define SD_SIBLING_INIT (struct sched_domain) {				\
+	.min_interval		= 1,					\
+	.max_interval		= 2,					\
+	.busy_factor		= 64,					\
+	.imbalance_pct		= 110,					\
+									\
+	.flags			= 1*SD_LOAD_BALANCE			\
+				| 1*SD_BALANCE_NEWIDLE			\
+				| 1*SD_BALANCE_EXEC			\
+				| 1*SD_BALANCE_FORK			\
+				| 0*SD_WAKE_IDLE			\
+				| 1*SD_WAKE_AFFINE			\
+				| 1*SD_WAKE_BALANCE			\
+				| 1*SD_SHARE_CPUPOWER			\
+				| 0*SD_POWERSAVINGS_BALANCE		\
+				| 0*SD_SHARE_PKG_RESOURCES		\
+				| 0*SD_SERIALIZE			\
+				| 0*SD_WAKE_IDLE_FAR			\
+				| 0*SD_PREFER_SIBLING			\
+				,					\
+	.last_balance		= jiffies,				\
+	.balance_interval	= 1,					\
+	.smt_gain		= 1178,	/* 15% */			\
 }
 #endif
 #endif /* CONFIG_SCHED_SMT */
@@ -107,69 +115,94 @@ int arch_update_cpu_topology(void);
 #ifdef CONFIG_SCHED_MC
 /* Common values for MC siblings. for now mostly derived from SD_CPU_INIT */
 #ifndef SD_MC_INIT
-#define SD_MC_INIT (struct sched_domain) {		\
-	.min_interval		= 1,			\
-	.max_interval		= 4,			\
-	.busy_factor		= 64,			\
-	.imbalance_pct		= 125,			\
-	.cache_nice_tries	= 1,			\
-	.busy_idx		= 2,			\
-	.wake_idx		= 1,			\
-	.forkexec_idx		= 1,			\
-	.flags			= SD_LOAD_BALANCE	\
-				| SD_BALANCE_FORK	\
-				| SD_BALANCE_EXEC	\
-				| SD_WAKE_AFFINE	\
-				| SD_WAKE_BALANCE	\
-				| SD_SHARE_PKG_RESOURCES\
-				| sd_balance_for_mc_power()\
-				| sd_power_saving_flags(),\
-	.last_balance		= jiffies,		\
-	.balance_interval	= 1,			\
+#define SD_MC_INIT (struct sched_domain) {				\
+	.min_interval		= 1,					\
+	.max_interval		= 4,					\
+	.busy_factor		= 64,					\
+	.imbalance_pct		= 125,					\
+	.cache_nice_tries	= 1,					\
+	.busy_idx		= 2,					\
+	.wake_idx		= 1,					\
+	.forkexec_idx		= 1,					\
+									\
+	.flags			= 1*SD_LOAD_BALANCE			\
+				| 0*SD_BALANCE_NEWIDLE			\
+				| 1*SD_BALANCE_EXEC			\
+				| 1*SD_BALANCE_FORK			\
+				| 0*SD_WAKE_IDLE			\
+				| 1*SD_WAKE_AFFINE			\
+				| 1*SD_WAKE_BALANCE			\
+				| 0*SD_SHARE_CPUPOWER			\
+				| 1*SD_SHARE_PKG_RESOURCES		\
+				| 0*SD_SERIALIZE			\
+				| 0*SD_WAKE_IDLE_FAR			\
+				| sd_balance_for_mc_power()		\
+				| sd_power_saving_flags()		\
+				,					\
+	.last_balance		= jiffies,				\
+	.balance_interval	= 1,					\
 }
 #endif
 #endif /* CONFIG_SCHED_MC */
 
 /* Common values for CPUs */
 #ifndef SD_CPU_INIT
-#define SD_CPU_INIT (struct sched_domain) {		\
-	.min_interval		= 1,			\
-	.max_interval		= 4,			\
-	.busy_factor		= 64,			\
-	.imbalance_pct		= 125,			\
-	.cache_nice_tries	= 1,			\
-	.busy_idx		= 2,			\
-	.idle_idx		= 1,			\
-	.newidle_idx		= 2,			\
-	.wake_idx		= 1,			\
-	.forkexec_idx		= 1,			\
-	.flags			= SD_LOAD_BALANCE	\
-				| SD_BALANCE_EXEC	\
-				| SD_BALANCE_FORK	\
-				| SD_WAKE_AFFINE	\
-				| SD_WAKE_BALANCE	\
-				| sd_balance_for_package_power()\
-				| sd_power_saving_flags(),\
-	.last_balance		= jiffies,		\
-	.balance_interval	= 1,			\
+#define SD_CPU_INIT (struct sched_domain) {				\
+	.min_interval		= 1,					\
+	.max_interval		= 4,					\
+	.busy_factor		= 64,					\
+	.imbalance_pct		= 125,					\
+	.cache_nice_tries	= 1,					\
+	.busy_idx		= 2,					\
+	.idle_idx		= 1,					\
+	.newidle_idx		= 2,					\
+	.wake_idx		= 1,					\
+	.forkexec_idx		= 1,					\
+									\
+	.flags			= 1*SD_LOAD_BALANCE			\
+				| 0*SD_BALANCE_NEWIDLE			\
+				| 1*SD_BALANCE_EXEC			\
+				| 1*SD_BALANCE_FORK			\
+				| 0*SD_WAKE_IDLE			\
+				| 0*SD_WAKE_AFFINE			\
+				| 1*SD_WAKE_BALANCE			\
+				| 0*SD_SHARE_CPUPOWER			\
+				| 0*SD_SHARE_PKG_RESOURCES		\
+				| 0*SD_SERIALIZE			\
+				| 0*SD_WAKE_IDLE_FAR			\
+				| sd_balance_for_package_power()	\
+				| sd_power_saving_flags()		\
+				,					\
+	.last_balance		= jiffies,				\
+	.balance_interval	= 1,					\
 }
 #endif
 
 /* sched_domains SD_ALLNODES_INIT for NUMA machines */
-#define SD_ALLNODES_INIT (struct sched_domain) {	\
-	.min_interval		= 64,			\
-	.max_interval		= 64*num_online_cpus(),	\
-	.busy_factor		= 128,			\
-	.imbalance_pct		= 133,			\
-	.cache_nice_tries	= 1,			\
-	.busy_idx		= 3,			\
-	.idle_idx		= 3,			\
-	.flags			= SD_LOAD_BALANCE	\
-				| SD_BALANCE_NEWIDLE	\
-				| SD_WAKE_AFFINE	\
-				| SD_SERIALIZE,		\
-	.last_balance		= jiffies,		\
-	.balance_interval	= 64,			\
+#define SD_ALLNODES_INIT (struct sched_domain) {			\
+	.min_interval		= 64,					\
+	.max_interval		= 64*num_online_cpus(),			\
+	.busy_factor		= 128,					\
+	.imbalance_pct		= 133,					\
+	.cache_nice_tries	= 1,					\
+	.busy_idx		= 3,					\
+	.idle_idx		= 3,					\
+	.flags			= 1*SD_LOAD_BALANCE			\
+				| 1*SD_BALANCE_NEWIDLE			\
+				| 0*SD_BALANCE_EXEC			\
+				| 0*SD_BALANCE_FORK			\
+				| 0*SD_WAKE_IDLE			\
+				| 1*SD_WAKE_AFFINE			\
+				| 0*SD_WAKE_BALANCE			\
+				| 0*SD_SHARE_CPUPOWER			\
+				| 0*SD_POWERSAVINGS_BALANCE		\
+				| 0*SD_SHARE_PKG_RESOURCES		\
+				| 1*SD_SERIALIZE			\
+				| 0*SD_WAKE_IDLE_FAR			\
+				| 0*SD_PREFER_SIBLING			\
+				,					\
+	.last_balance		= jiffies,				\
+	.balance_interval	= 64,					\
 }
 
 #ifdef CONFIG_NUMA
