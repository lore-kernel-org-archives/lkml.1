Return-Path: <linux-kernel-owner+w=401wt.eu-S1756798AbZD2K52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbZD2K52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 06:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754168AbZD2Kva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 06:51:30 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:23631
	"EHLO WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754932AbZD2KvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 06:51:05 -0400
X-BigFish: VPS1(zzzz1202hzzz32i62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KIUZGQ-01-7AE-01
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 20/29] x86/perfcounters: consistent use of type int for counter index
Date: Wed, 29 Apr 2009 12:47:17 +0200
Message-ID: <1241002046-8832-21-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 29 Apr 2009 10:50:49.0539 (UTC) FILETIME=[5BBC8930:01C9C8B8]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The type of counter index is sometimes implemented as unsigned
int. This patch changes this to have a consistent usage of int.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_counter.c |    8 ++++----
 include/linux/perf_counter.h       |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index f7fd4a3..d8beebe 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -459,7 +459,7 @@ static void hw_perf_disable(int idx, u64 config)
 
 static inline void
 __pmc_fixed_disable(struct perf_counter *counter,
-		    struct hw_perf_counter *hwc, unsigned int __idx)
+		    struct hw_perf_counter *hwc, int __idx)
 {
 	int idx = __idx - X86_PMC_IDX_FIXED;
 	u64 ctrl_val, mask;
@@ -474,7 +474,7 @@ __pmc_fixed_disable(struct perf_counter *counter,
 
 static inline void
 __x86_pmu_disable(struct perf_counter *counter,
-		  struct hw_perf_counter *hwc, unsigned int idx)
+		  struct hw_perf_counter *hwc, int idx)
 {
 	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL))
 		__pmc_fixed_disable(counter, hwc, idx);
@@ -523,7 +523,7 @@ x86_perf_counter_set_period(struct perf_counter *counter,
 
 static inline void
 __pmc_fixed_enable(struct perf_counter *counter,
-		   struct hw_perf_counter *hwc, unsigned int __idx)
+		   struct hw_perf_counter *hwc, int __idx)
 {
 	int idx = __idx - X86_PMC_IDX_FIXED;
 	u64 ctrl_val, bits, mask;
@@ -691,7 +691,7 @@ static void x86_pmu_disable(struct perf_counter *counter)
 {
 	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
 	struct hw_perf_counter *hwc = &counter->hw;
-	unsigned int idx = hwc->idx;
+	int idx = hwc->idx;
 
 	/*
 	 * Must be done before we disable, otherwise the nmi handler
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index c3db52d..41aed42 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -318,7 +318,7 @@ struct hw_perf_counter {
 			unsigned long			config_base;
 			unsigned long			counter_base;
 			int				nmi;
-			unsigned int			idx;
+			int				idx;
 		};
 		union { /* software */
 			atomic64_t			count;
-- 
1.6.1.3


