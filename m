Return-Path: <linux-kernel-owner+w=401wt.eu-S1760205AbZD2LHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760205AbZD2LHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 07:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756546AbZD2LGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 07:06:17 -0400
Received: from wa4ehsobe002.messaging.microsoft.com ([216.32.181.12]:6296 "EHLO
	WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759558AbZD2LGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 07:06:15 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-WSS-ID: 0KIUZGT-03-8M5-01
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 18/29] x86/perfcounters: rename cpuc->active_mask
Date: Wed, 29 Apr 2009 12:47:15 +0200
Message-ID: <1241002046-8832-19-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 29 Apr 2009 10:50:49.0539 (UTC) FILETIME=[5BBC8930:01C9C8B8]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to have a consistent naming scheme with cpuc->used.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_counter.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 3f3ae47..9ec51a6 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -29,9 +29,9 @@ static u64 perf_counter_mask __read_mostly;
 struct cpu_hw_counters {
 	struct perf_counter	*counters[X86_PMC_IDX_MAX];
 	unsigned long		used[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
+	unsigned long		active[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	unsigned long		interrupts;
 	u64			throttle_ctrl;
-	unsigned long		active_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	int			enabled;
 };
 
@@ -334,7 +334,7 @@ static u64 amd_pmu_save_disable_all(void)
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 		u64 val;
 
-		if (!test_bit(idx, cpuc->active_mask))
+		if (!test_bit(idx, cpuc->active))
 			continue;
 		rdmsrl(MSR_K7_EVNTSEL0 + idx, val);
 		if (!(val & ARCH_PERFMON_EVENTSEL0_ENABLE))
@@ -376,7 +376,7 @@ static void amd_pmu_restore_all(u64 ctrl)
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 		u64 val;
 
-		if (!test_bit(idx, cpuc->active_mask))
+		if (!test_bit(idx, cpuc->active))
 			continue;
 		rdmsrl(MSR_K7_EVNTSEL0 + idx, val);
 		if (val & ARCH_PERFMON_EVENTSEL0_ENABLE)
@@ -424,7 +424,7 @@ static void amd_pmu_enable_counter(int idx, u64 config)
 {
 	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
 
-	set_bit(idx, cpuc->active_mask);
+	set_bit(idx, cpuc->active);
 	if (cpuc->enabled)
 		config |= ARCH_PERFMON_EVENTSEL0_ENABLE;
 
@@ -448,7 +448,7 @@ static void amd_pmu_disable_counter(int idx, u64 config)
 {
 	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
 
-	clear_bit(idx, cpuc->active_mask);
+	clear_bit(idx, cpuc->active);
 	wrmsrl(MSR_K7_EVNTSEL0 + idx, config);
 
 }
-- 
1.6.1.3


