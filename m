Return-Path: <linux-kernel-owner+w=401wt.eu-S1755557Ab0AVP7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab0AVP7m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 10:59:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489Ab0AVP7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 10:59:35 -0500
Received: from casper.infradead.org ([85.118.1.10]:38263 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435Ab0AVP7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 10:59:33 -0500
Message-Id: <20100122155535.688730371@chello.nl>
References: <20100122155044.391857484@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 22 Jan 2010 16:50:50 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: eranian@google.com, fweisbec@gmail.com, paulus@samba.org, mingo@elte.hu,
       davem@davemloft.net, robert.richter@amd.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 06/10] perf_event: x86: Reduce some overly long lines with some MACROs
Content-Disposition: inline; filename=perf-event_constraint.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce INTEL_EVENT_CONSTRAINT and FIXED_EVENT_CONSTRAINT to reduce
some line length and typing work.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 arch/x86/kernel/cpu/perf_event.c |   68 +++++++++++++++++++++------------------
 1 file changed, 37 insertions(+), 31 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -98,6 +98,12 @@ struct cpu_hw_events {
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
 
@@ -193,12 +199,12 @@ static u64 p6_pmu_raw_event(u64 hw_event
 
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
 
@@ -218,41 +224,41 @@ static const u64 intel_perfmon_event_map
 
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
 

-- 

