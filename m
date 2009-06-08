Return-Path: <linux-kernel-owner+w=401wt.eu-S1755167AbZFHKcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbZFHKcm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 06:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755021AbZFHKcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 06:32:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:41689 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754985AbZFHKcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 06:32:23 -0400
Date: Mon, 8 Jun 2009 10:31:50 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Clean up x86 boot messages
Message-ID: <tip-1123e3ad73697d64ad99f0104bbe49f8b52d7d65@git.kernel.org>
Git-Commit-ID: 1123e3ad73697d64ad99f0104bbe49f8b52d7d65
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 08 Jun 2009 10:31:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1123e3ad73697d64ad99f0104bbe49f8b52d7d65
Gitweb:     http://git.kernel.org/tip/1123e3ad73697d64ad99f0104bbe49f8b52d7d65
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 29 May 2009 11:25:09 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 8 Jun 2009 12:29:30 +0200

perf_counter: Clean up x86 boot messages

Standardize and tidy up all the messages we print during
perfcounter initialization.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |   46 ++++++++++++++++++-----------------
 1 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 71590e0..0339d19 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -1298,23 +1298,22 @@ static int intel_pmu_init(void)
 	if (version < 2)
 		return -ENODEV;
 
-	x86_pmu = intel_pmu;
-	x86_pmu.version = version;
-	x86_pmu.num_counters = eax.split.num_counters;
+	x86_pmu				= intel_pmu;
+	x86_pmu.version			= version;
+	x86_pmu.num_counters		= eax.split.num_counters;
+	x86_pmu.counter_bits		= eax.split.bit_width;
+	x86_pmu.counter_mask		= (1ULL << eax.split.bit_width) - 1;
 
 	/*
 	 * Quirk: v2 perfmon does not report fixed-purpose counters, so
 	 * assume at least 3 counters:
 	 */
-	x86_pmu.num_counters_fixed = max((int)edx.split.num_counters_fixed, 3);
-
-	x86_pmu.counter_bits = eax.split.bit_width;
-	x86_pmu.counter_mask = (1ULL << eax.split.bit_width) - 1;
+	x86_pmu.num_counters_fixed	= max((int)edx.split.num_counters_fixed, 3);
 
 	rdmsrl(MSR_CORE_PERF_GLOBAL_CTRL, x86_pmu.intel_ctrl);
 
 	/*
-	 * Nehalem:
+	 * Install the hw-cache-events table:
 	 */
 	switch (boot_cpu_data.x86_model) {
 	case 17:
@@ -1322,7 +1321,7 @@ static int intel_pmu_init(void)
 		sizeof(u64)*PERF_COUNT_HW_CACHE_MAX*
 			PERF_COUNT_HW_CACHE_OP_MAX*PERF_COUNT_HW_CACHE_RESULT_MAX);
 
-		pr_info("... installed Core2 event tables\n");
+		pr_cont("Core2 events, ");
 		break;
 	default:
 	case 26:
@@ -1330,14 +1329,14 @@ static int intel_pmu_init(void)
 		sizeof(u64)*PERF_COUNT_HW_CACHE_MAX*
 			PERF_COUNT_HW_CACHE_OP_MAX*PERF_COUNT_HW_CACHE_RESULT_MAX);
 
-		pr_info("... installed Nehalem/Corei7 event tables\n");
+		pr_cont("Nehalem/Corei7 events, ");
 		break;
 	case 28:
 		memcpy(hw_cache_event_ids, atom_hw_cache_event_ids,
 		sizeof(u64)*PERF_COUNT_HW_CACHE_MAX*
 			PERF_COUNT_HW_CACHE_OP_MAX*PERF_COUNT_HW_CACHE_RESULT_MAX);
 
-		pr_info("... installed Atom event tables\n");
+		pr_cont("Atom events, ");
 		break;
 	}
 	return 0;
@@ -1353,6 +1352,8 @@ void __init init_hw_perf_counters(void)
 {
 	int err;
 
+	pr_info("Performance Counters: ");
+
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_INTEL:
 		err = intel_pmu_init();
@@ -1363,14 +1364,13 @@ void __init init_hw_perf_counters(void)
 	default:
 		return;
 	}
-	if (err != 0)
+	if (err != 0) {
+		pr_cont("no PMU driver, software counters only.\n");
 		return;
+	}
 
-	pr_info("%s Performance Monitoring support detected.\n", x86_pmu.name);
-	pr_info("... version:         %d\n", x86_pmu.version);
-	pr_info("... bit width:       %d\n", x86_pmu.counter_bits);
+	pr_cont("%s PMU driver.\n", x86_pmu.name);
 
-	pr_info("... num counters:    %d\n", x86_pmu.num_counters);
 	if (x86_pmu.num_counters > X86_PMC_MAX_GENERIC) {
 		x86_pmu.num_counters = X86_PMC_MAX_GENERIC;
 		WARN(1, KERN_ERR "hw perf counters %d > max(%d), clipping!",
@@ -1379,23 +1379,25 @@ void __init init_hw_perf_counters(void)
 	perf_counter_mask = (1 << x86_pmu.num_counters) - 1;
 	perf_max_counters = x86_pmu.num_counters;
 
-	pr_info("... value mask:      %016Lx\n", x86_pmu.counter_mask);
-	pr_info("... max period:      %016Lx\n", x86_pmu.max_period);
-
 	if (x86_pmu.num_counters_fixed > X86_PMC_MAX_FIXED) {
 		x86_pmu.num_counters_fixed = X86_PMC_MAX_FIXED;
 		WARN(1, KERN_ERR "hw perf counters fixed %d > max(%d), clipping!",
 		     x86_pmu.num_counters_fixed, X86_PMC_MAX_FIXED);
 	}
-	pr_info("... fixed counters:  %d\n", x86_pmu.num_counters_fixed);
 
 	perf_counter_mask |=
 		((1LL << x86_pmu.num_counters_fixed)-1) << X86_PMC_IDX_FIXED;
 
-	pr_info("... counter mask:    %016Lx\n", perf_counter_mask);
-
 	perf_counters_lapic_init();
 	register_die_notifier(&perf_counter_nmi_notifier);
+
+	pr_info("... version:                 %d\n",     x86_pmu.version);
+	pr_info("... bit width:               %d\n",     x86_pmu.counter_bits);
+	pr_info("... generic counters:        %d\n",     x86_pmu.num_counters);
+	pr_info("... value mask:              %016Lx\n", x86_pmu.counter_mask);
+	pr_info("... max period:              %016Lx\n", x86_pmu.max_period);
+	pr_info("... fixed-purpose counters:  %d\n",     x86_pmu.num_counters_fixed);
+	pr_info("... counter mask:            %016Lx\n", perf_counter_mask);
 }
 
 static inline void x86_pmu_read(struct perf_counter *counter)
