Return-Path: <linux-kernel-owner+w=401wt.eu-S1760092AbZD2NL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760092AbZD2NL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759123AbZD2NHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:07:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:44652 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759093AbZD2NHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:07:47 -0400
Date: Wed, 29 Apr 2009 13:07:06 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, robert.richter@amd.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, robert.richter@amd.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1241002046-8832-21-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-21-git-send-email-robert.richter@amd.com>
Subject: [tip:perfcounters/core] perf_counter, x86: consistent use of type int for counter index
Message-ID: <tip-6f00cada07bb5da7f751929d3173494dcc5446cc@git.kernel.org>
Git-Commit-ID: 6f00cada07bb5da7f751929d3173494dcc5446cc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 13:07:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6f00cada07bb5da7f751929d3173494dcc5446cc
Gitweb:     http://git.kernel.org/tip/6f00cada07bb5da7f751929d3173494dcc5446cc
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 29 Apr 2009 12:47:17 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 14:51:10 +0200

perf_counter, x86: consistent use of type int for counter index

The type of counter index is sometimes implemented as unsigned
int. This patch changes this to have a consistent usage of int.

[ Impact: cleanup ]

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Paul Mackerras <paulus@samba.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1241002046-8832-21-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
