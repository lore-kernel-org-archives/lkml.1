Return-Path: <linux-kernel-owner+w=401wt.eu-S1759983AbZKLC1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759983AbZKLC1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 21:27:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759936AbZKLC1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 21:27:07 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:50742 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759928AbZKLC1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 21:27:06 -0500
Message-ID: <4AFB721E.8070203@ct.jp.nec.com>
Date: Thu, 12 Nov 2009 11:25:34 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf_event, x86: Annotate init functions and data
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Annotate init functions and data with __init and __initconst.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/cpu/perf_event.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 2e20bca..bd87430 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -245,7 +245,7 @@ static u64 __read_mostly hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX];
 
-static const u64 nehalem_hw_cache_event_ids
+static __initconst u64 nehalem_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
@@ -336,7 +336,7 @@ static const u64 nehalem_hw_cache_event_ids
  },
 };
 
-static const u64 core2_hw_cache_event_ids
+static __initconst u64 core2_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
@@ -427,7 +427,7 @@ static const u64 core2_hw_cache_event_ids
  },
 };
 
-static const u64 atom_hw_cache_event_ids
+static __initconst u64 atom_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
@@ -536,7 +536,7 @@ static u64 intel_pmu_raw_event(u64 hw_event)
 	return hw_event & CORE_EVNTSEL_MASK;
 }
 
-static const u64 amd_hw_cache_event_ids
+static __initconst u64 amd_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
@@ -1964,7 +1964,7 @@ static __read_mostly struct notifier_block perf_event_nmi_notifier = {
 	.priority		= 1
 };
 
-static struct x86_pmu p6_pmu = {
+static __initconst struct x86_pmu p6_pmu = {
 	.name			= "p6",
 	.handle_irq		= p6_pmu_handle_irq,
 	.disable_all		= p6_pmu_disable_all,
@@ -1992,7 +1992,7 @@ static struct x86_pmu p6_pmu = {
 	.get_event_idx		= intel_get_event_idx,
 };
 
-static struct x86_pmu intel_pmu = {
+static __initconst struct x86_pmu intel_pmu = {
 	.name			= "Intel",
 	.handle_irq		= intel_pmu_handle_irq,
 	.disable_all		= intel_pmu_disable_all,
@@ -2016,7 +2016,7 @@ static struct x86_pmu intel_pmu = {
 	.get_event_idx		= intel_get_event_idx,
 };
 
-static struct x86_pmu amd_pmu = {
+static __initconst struct x86_pmu amd_pmu = {
 	.name			= "AMD",
 	.handle_irq		= amd_pmu_handle_irq,
 	.disable_all		= amd_pmu_disable_all,
@@ -2037,7 +2037,7 @@ static struct x86_pmu amd_pmu = {
 	.get_event_idx		= gen_get_event_idx,
 };
 
-static int p6_pmu_init(void)
+static __init int p6_pmu_init(void)
 {
 	switch (boot_cpu_data.x86_model) {
 	case 1:
@@ -2071,7 +2071,7 @@ static int p6_pmu_init(void)
 	return 0;
 }
 
-static int intel_pmu_init(void)
+static __init int intel_pmu_init(void)
 {
 	union cpuid10_edx edx;
 	union cpuid10_eax eax;
@@ -2144,7 +2144,7 @@ static int intel_pmu_init(void)
 	return 0;
 }
 
-static int amd_pmu_init(void)
+static __init int amd_pmu_init(void)
 {
 	/* Performance-monitoring supported from K7 and later: */
 	if (boot_cpu_data.x86 < 6)
-- 
1.6.3.3

