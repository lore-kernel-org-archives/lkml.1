Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783Ab0A2J2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783Ab0A2J2h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 04:28:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756550Ab0A2J2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 04:28:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:57414 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756409Ab0A2J2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 04:28:20 -0500
Date: Fri, 29 Jan 2010 09:27:48 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100122155535.688730371@chello.nl>
References: <20100122155535.688730371@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_event: x86: Reduce some overly long lines with some MACROs
Message-ID: <tip-8433be1184e4f22c37d4b8ed36cde529a47882f4@git.kernel.org>
Git-Commit-ID: 8433be1184e4f22c37d4b8ed36cde529a47882f4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 29 Jan 2010 09:27:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8433be1184e4f22c37d4b8ed36cde529a47882f4
Gitweb:     http://git.kernel.org/tip/8433be1184e4f22c37d4b8ed36cde529a47882f4
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 22 Jan 2010 15:38:26 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 Jan 2010 09:01:38 +0100

perf_event: x86: Reduce some overly long lines with some MACROs

Introduce INTEL_EVENT_CONSTRAINT and FIXED_EVENT_CONSTRAINT to reduce
some line length and typing work.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <20100122155535.688730371@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |   68 ++++++++++++++++++++-----------------
 1 files changed, 37 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 921bbf7..4d1ed10 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -97,6 +97,12 @@ struct cpu_hw_events {
 	.cmask = (m),			\
 }
 
+#define INTEL_EVENT_CONSTRAINT(c, n)	\
+	EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK)
+
+#define FIXED_EVENT_CONSTRAINT(c, n)	\
+	EVENT_CONSTRAINT(c, n, INTEL_ARCH_FIXED_MASK)
+
 #define EVENT_CONSTRAINT_END \
 	EVENT_CONSTRAINT(0, 0, 0)
 
@@ -192,12 +198,12 @@ static u64 p6_pmu_raw_event(u64 hw_event)
 
 static struct event_constraint intel_p6_event_constraints[] =
 {
-	EVENT_CONSTRAINT(0xc1, 0x1, INTEL_ARCH_EVENT_MASK),	/* FLOPS */
-	EVENT_CONSTRAINT(0x10, 0x1, INTEL_ARCH_EVENT_MASK),	/* FP_COMP_OPS_EXE */
-	EVENT_CONSTRAINT(0x11, 0x1, INTEL_ARCH_EVENT_MASK),	/* FP_ASSIST */
-	EVENT_CONSTRAINT(0x12, 0x2, INTEL_ARCH_EVENT_MASK),	/* MUL */
-	EVENT_CONSTRAINT(0x13, 0x2, INTEL_ARCH_EVENT_MASK),	/* DIV */
-	EVENT_CONSTRAINT(0x14, 0x1, INTEL_ARCH_EVENT_MASK),	/* CYCLES_DIV_BUSY */
+	INTEL_EVENT_CONSTRAINT(0xc1, 0x1),	/* FLOPS */
+	INTEL_EVENT_CONSTRAINT(0x10, 0x1),	/* FP_COMP_OPS_EXE */
+	INTEL_EVENT_CONSTRAINT(0x11, 0x1),	/* FP_ASSIST */
+	INTEL_EVENT_CONSTRAINT(0x12, 0x2),	/* MUL */
+	INTEL_EVENT_CONSTRAINT(0x13, 0x2),	/* DIV */
+	INTEL_EVENT_CONSTRAINT(0x14, 0x1),	/* CYCLES_DIV_BUSY */
 	EVENT_CONSTRAINT_END
 };
 
@@ -217,41 +223,41 @@ static const u64 intel_perfmon_event_map[] =
 
 static struct event_constraint intel_core_event_constraints[] =
 {
-	EVENT_CONSTRAINT(0xc0, (0x3|(1ULL<<32)), INTEL_ARCH_FIXED_MASK), /* INSTRUCTIONS_RETIRED */
-	EVENT_CONSTRAINT(0x3c, (0x3|(1ULL<<33)), INTEL_ARCH_FIXED_MASK), /* UNHALTED_CORE_CYCLES */
-	EVENT_CONSTRAINT(0x10, 0x1, INTEL_ARCH_EVENT_MASK), /* FP_COMP_OPS_EXE */
-	EVENT_CONSTRAINT(0x11, 0x2, INTEL_ARCH_EVENT_MASK), /* FP_ASSIST */
-	EVENT_CONSTRAINT(0x12, 0x2, INTEL_ARCH_EVENT_MASK), /* MUL */
-	EVENT_CONSTRAINT(0x13, 0x2, INTEL_ARCH_EVENT_MASK), /* DIV */
-	EVENT_CONSTRAINT(0x14, 0x1, INTEL_ARCH_EVENT_MASK), /* CYCLES_DIV_BUSY */
-	EVENT_CONSTRAINT(0x18, 0x1, INTEL_ARCH_EVENT_MASK), /* IDLE_DURING_DIV */
-	EVENT_CONSTRAINT(0x19, 0x2, INTEL_ARCH_EVENT_MASK), /* DELAYED_BYPASS */
-	EVENT_CONSTRAINT(0xa1, 0x1, INTEL_ARCH_EVENT_MASK), /* RS_UOPS_DISPATCH_CYCLES */
-	EVENT_CONSTRAINT(0xcb, 0x1, INTEL_ARCH_EVENT_MASK), /* MEM_LOAD_RETIRED */
+	FIXED_EVENT_CONSTRAINT(0xc0, (0x3|(1ULL<<32))), /* INSTRUCTIONS_RETIRED */
+	FIXED_EVENT_CONSTRAINT(0x3c, (0x3|(1ULL<<33))), /* UNHALTED_CORE_CYCLES */
+	INTEL_EVENT_CONSTRAINT(0x10, 0x1), /* FP_COMP_OPS_EXE */
+	INTEL_EVENT_CONSTRAINT(0x11, 0x2), /* FP_ASSIST */
+	INTEL_EVENT_CONSTRAINT(0x12, 0x2), /* MUL */
+	INTEL_EVENT_CONSTRAINT(0x13, 0x2), /* DIV */
+	INTEL_EVENT_CONSTRAINT(0x14, 0x1), /* CYCLES_DIV_BUSY */
+	INTEL_EVENT_CONSTRAINT(0x18, 0x1), /* IDLE_DURING_DIV */
+	INTEL_EVENT_CONSTRAINT(0x19, 0x2), /* DELAYED_BYPASS */
+	INTEL_EVENT_CONSTRAINT(0xa1, 0x1), /* RS_UOPS_DISPATCH_CYCLES */
+	INTEL_EVENT_CONSTRAINT(0xcb, 0x1), /* MEM_LOAD_RETIRED */
 	EVENT_CONSTRAINT_END
 };
 
 static struct event_constraint intel_nehalem_event_constraints[] =
 {
-	EVENT_CONSTRAINT(0xc0, (0x3|(1ULL<<32)), INTEL_ARCH_FIXED_MASK), /* INSTRUCTIONS_RETIRED */
-	EVENT_CONSTRAINT(0x3c, (0x3|(1ULL<<33)), INTEL_ARCH_FIXED_MASK), /* UNHALTED_CORE_CYCLES */
-	EVENT_CONSTRAINT(0x40, 0x3, INTEL_ARCH_EVENT_MASK), /* L1D_CACHE_LD */
-	EVENT_CONSTRAINT(0x41, 0x3, INTEL_ARCH_EVENT_MASK), /* L1D_CACHE_ST */
-	EVENT_CONSTRAINT(0x42, 0x3, INTEL_ARCH_EVENT_MASK), /* L1D_CACHE_LOCK */
-	EVENT_CONSTRAINT(0x43, 0x3, INTEL_ARCH_EVENT_MASK), /* L1D_ALL_REF */
-	EVENT_CONSTRAINT(0x4e, 0x3, INTEL_ARCH_EVENT_MASK), /* L1D_PREFETCH */
-	EVENT_CONSTRAINT(0x4c, 0x3, INTEL_ARCH_EVENT_MASK), /* LOAD_HIT_PRE */
-	EVENT_CONSTRAINT(0x51, 0x3, INTEL_ARCH_EVENT_MASK), /* L1D */
-	EVENT_CONSTRAINT(0x52, 0x3, INTEL_ARCH_EVENT_MASK), /* L1D_CACHE_PREFETCH_LOCK_FB_HIT */
-	EVENT_CONSTRAINT(0x53, 0x3, INTEL_ARCH_EVENT_MASK), /* L1D_CACHE_LOCK_FB_HIT */
-	EVENT_CONSTRAINT(0xc5, 0x3, INTEL_ARCH_EVENT_MASK), /* CACHE_LOCK_CYCLES */
+	FIXED_EVENT_CONSTRAINT(0xc0, (0x3|(1ULL<<32))), /* INSTRUCTIONS_RETIRED */
+	FIXED_EVENT_CONSTRAINT(0x3c, (0x3|(1ULL<<33))), /* UNHALTED_CORE_CYCLES */
+	INTEL_EVENT_CONSTRAINT(0x40, 0x3), /* L1D_CACHE_LD */
+	INTEL_EVENT_CONSTRAINT(0x41, 0x3), /* L1D_CACHE_ST */
+	INTEL_EVENT_CONSTRAINT(0x42, 0x3), /* L1D_CACHE_LOCK */
+	INTEL_EVENT_CONSTRAINT(0x43, 0x3), /* L1D_ALL_REF */
+	INTEL_EVENT_CONSTRAINT(0x4e, 0x3), /* L1D_PREFETCH */
+	INTEL_EVENT_CONSTRAINT(0x4c, 0x3), /* LOAD_HIT_PRE */
+	INTEL_EVENT_CONSTRAINT(0x51, 0x3), /* L1D */
+	INTEL_EVENT_CONSTRAINT(0x52, 0x3), /* L1D_CACHE_PREFETCH_LOCK_FB_HIT */
+	INTEL_EVENT_CONSTRAINT(0x53, 0x3), /* L1D_CACHE_LOCK_FB_HIT */
+	INTEL_EVENT_CONSTRAINT(0xc5, 0x3), /* CACHE_LOCK_CYCLES */
 	EVENT_CONSTRAINT_END
 };
 
 static struct event_constraint intel_gen_event_constraints[] =
 {
-	EVENT_CONSTRAINT(0xc0, (0x3|(1ULL<<32)), INTEL_ARCH_FIXED_MASK), /* INSTRUCTIONS_RETIRED */
-	EVENT_CONSTRAINT(0x3c, (0x3|(1ULL<<33)), INTEL_ARCH_FIXED_MASK), /* UNHALTED_CORE_CYCLES */
+	FIXED_EVENT_CONSTRAINT(0xc0, (0x3|(1ULL<<32))), /* INSTRUCTIONS_RETIRED */
+	FIXED_EVENT_CONSTRAINT(0x3c, (0x3|(1ULL<<33))), /* UNHALTED_CORE_CYCLES */
 	EVENT_CONSTRAINT_END
 };
 
