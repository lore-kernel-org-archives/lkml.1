Return-Path: <linux-kernel-owner+w=401wt.eu-S1760566AbYFXQV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760566AbYFXQV7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 12:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757658AbYFXQUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 12:20:30 -0400
Received: from gv-out-0910.google.com ([216.239.58.188]:13272 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbYFXQU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 12:20:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition
         :message-id;
        b=O5grvCkyrJz/p+s/TPBMEx62I/cqhGYkfYeyaI9LeznTPWKpUqzOA4n8pi2laQIjk8
         Nw83eV/HP1adj7iGlJfUb0xEVq3LlYVLpQyucfjjS/ADAKFRYhD1VvIyhqEgM4MVtZgY
         7+YaRC/FTnL/5M6Yy64CUKxPW0RkWZipJ48/M=
References: <20080624161624.124913675@gmail.com>>
User-Agent: quilt/0.46-1
Date: Thu, 01 Jan 1970 03:00:01 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, macro@linux-mips.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, linux-kernel@vger.kernel.org
Subject: [patch 1/5] x86: perfctr-watchdog.c - coding style cleanup
Content-Disposition: inline; filename=perfctr-watchdog-coding-style
Message-ID: <48611ec1.2234440a.679b.1a7d@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just some code beautification. Nothing else.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/cpu/perfctr-watchdog.c
====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perfctr-watchdog.c	2008-06-21 13:21:54.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/cpu/perfctr-watchdog.c	2008-06-21 19:08:17.000000000 +0400
@@ -1,11 +1,15 @@
-/* local apic based NMI watchdog for various CPUs.
-   This file also handles reservation of performance counters for coordination
-   with other users (like oprofile).
-
-   Note that these events normally don't tick when the CPU idles. This means
-   the frequency varies with CPU load.
-
-   Original code for K7/P6 written by Keith Owens */
+/*
+ * local apic based NMI watchdog for various CPUs.
+ *
+ * This file also handles reservation of performance counters for coordination
+ * with other users (like oprofile).
+ *
+ * Note that these events normally don't tick when the CPU idles. This means
+ * the frequency varies with CPU load.
+ *
+ * Original code for K7/P6 written by Keith Owens
+ *
+ */
 
 #include <linux/percpu.h>
 #include <linux/module.h>
@@ -36,12 +40,16 @@ struct wd_ops {
 
 static const struct wd_ops *wd_ops;
 
-/* this number is calculated from Intel's MSR_P4_CRU_ESCR5 register and it's
- * offset from MSR_P4_BSU_ESCR0.  It will be the max for all platforms (for now)
+/*
+ * this number is calculated from Intel's MSR_P4_CRU_ESCR5 register and it's
+ * offset from MSR_P4_BSU_ESCR0.
+ *
+ * It will be the max for all platforms (for now)
  */
 #define NMI_MAX_COUNTER_BITS 66
 
-/* perfctr_nmi_owner tracks the ownership of the perfctr registers:
+/*
+ * perfctr_nmi_owner tracks the ownership of the perfctr registers:
  * evtsel_nmi_owner tracks the ownership of the event selection
  * - different performance counters/ event selection may be reserved for
  *   different subsystems this reservation system just tries to coordinate
@@ -73,8 +81,10 @@ static inline unsigned int nmi_perfctr_m
 	return 0;
 }
 
-/* converts an msr to an appropriate reservation bit */
-/* returns the bit offset of the event selection register */
+/*
+ * converts an msr to an appropriate reservation bit
+ * returns the bit offset of the event selection register
+ */
 static inline unsigned int nmi_evntsel_msr_to_bit(unsigned int msr)
 {
 	/* returns the bit offset of the event selection register */
@@ -114,6 +124,7 @@ int avail_to_resrv_perfctr_nmi(unsigned 
 
 	return (!test_bit(counter, perfctr_nmi_owner));
 }
+EXPORT_SYMBOL(avail_to_resrv_perfctr_nmi_bit);
 
 int reserve_perfctr_nmi(unsigned int msr)
 {
@@ -128,6 +139,7 @@ int reserve_perfctr_nmi(unsigned int msr
 		return 1;
 	return 0;
 }
+EXPORT_SYMBOL(reserve_perfctr_nmi);
 
 void release_perfctr_nmi(unsigned int msr)
 {
@@ -140,6 +152,7 @@ void release_perfctr_nmi(unsigned int ms
 
 	clear_bit(counter, perfctr_nmi_owner);
 }
+EXPORT_SYMBOL(release_perfctr_nmi);
 
 int reserve_evntsel_nmi(unsigned int msr)
 {
@@ -154,6 +167,7 @@ int reserve_evntsel_nmi(unsigned int msr
 		return 1;
 	return 0;
 }
+EXPORT_SYMBOL(reserve_evntsel_nmi);
 
 void release_evntsel_nmi(unsigned int msr)
 {
@@ -166,11 +180,6 @@ void release_evntsel_nmi(unsigned int ms
 
 	clear_bit(counter, evntsel_nmi_owner);
 }
-
-EXPORT_SYMBOL(avail_to_resrv_perfctr_nmi_bit);
-EXPORT_SYMBOL(reserve_perfctr_nmi);
-EXPORT_SYMBOL(release_perfctr_nmi);
-EXPORT_SYMBOL(reserve_evntsel_nmi);
 EXPORT_SYMBOL(release_evntsel_nmi);
 
 void disable_lapic_nmi_watchdog(void)
@@ -234,8 +243,8 @@ static unsigned int adjust_for_32bit_ctr
 	return retval;
 }
 
-static void
-write_watchdog_counter(unsigned int perfctr_msr, const char *descr, unsigned nmi_hz)
+static void write_watchdog_counter(unsigned int perfctr_msr,
+				const char *descr, unsigned nmi_hz)
 {
 	u64 count = (u64)cpu_khz * 1000;
 
@@ -246,7 +255,7 @@ write_watchdog_counter(unsigned int perf
 }
 
 static void write_watchdog_counter32(unsigned int perfctr_msr,
-		const char *descr, unsigned nmi_hz)
+				const char *descr, unsigned nmi_hz)
 {
 	u64 count = (u64)cpu_khz * 1000;
 
@@ -256,9 +265,10 @@ static void write_watchdog_counter32(uns
 	wrmsr(perfctr_msr, (u32)(-count), 0);
 }
 
-/* AMD K7/K8/Family10h/Family11h support. AMD keeps this interface
-   nicely stable so there is not much variety */
-
+/*
+ * AMD K7/K8/Family10h/Family11h support.
+ * AMD keeps this interface nicely stable so there is not much variety
+ */
 #define K7_EVNTSEL_ENABLE	(1 << 22)
 #define K7_EVNTSEL_INT		(1 << 20)
 #define K7_EVNTSEL_OS		(1 << 17)
@@ -291,7 +301,7 @@ static int setup_k7_watchdog(unsigned nm
 
 	wd->perfctr_msr = perfctr_msr;
 	wd->evntsel_msr = evntsel_msr;
-	wd->cccr_msr = 0;  //unused
+	wd->cccr_msr = 0;  /* unused */
 	return 1;
 }
 
@@ -327,18 +337,19 @@ static void single_msr_rearm(struct nmi_
 }
 
 static const struct wd_ops k7_wd_ops = {
-	.reserve = single_msr_reserve,
-	.unreserve = single_msr_unreserve,
-	.setup = setup_k7_watchdog,
-	.rearm = single_msr_rearm,
-	.stop = single_msr_stop_watchdog,
-	.perfctr = MSR_K7_PERFCTR0,
-	.evntsel = MSR_K7_EVNTSEL0,
-	.checkbit = 1ULL<<47,
+	.reserve	= single_msr_reserve,
+	.unreserve	= single_msr_unreserve,
+	.setup		= setup_k7_watchdog,
+	.rearm		= single_msr_rearm,
+	.stop		= single_msr_stop_watchdog,
+	.perfctr	= MSR_K7_PERFCTR0,
+	.evntsel	= MSR_K7_EVNTSEL0,
+	.checkbit	= 1ULL << 47,
 };
 
-/* Intel Model 6 (PPro+,P2,P3,P-M,Core1) */
-
+/*
+ * Intel Model 6 (PPro+,P2,P3,P-M,Core1)
+ */
 #define P6_EVNTSEL0_ENABLE	(1 << 22)
 #define P6_EVNTSEL_INT		(1 << 20)
 #define P6_EVNTSEL_OS		(1 << 17)
@@ -374,52 +385,58 @@ static int setup_p6_watchdog(unsigned nm
 
 	wd->perfctr_msr = perfctr_msr;
 	wd->evntsel_msr = evntsel_msr;
-	wd->cccr_msr = 0;  //unused
+	wd->cccr_msr = 0;  /* unused */
 	return 1;
 }
 
 static void p6_rearm(struct nmi_watchdog_ctlblk *wd, unsigned nmi_hz)
 {
-	/* P6 based Pentium M need to re-unmask
+	/*
+	 * P6 based Pentium M need to re-unmask
 	 * the apic vector but it doesn't hurt
 	 * other P6 variant.
-	 * ArchPerfom/Core Duo also needs this */
+	 * ArchPerfom/Core Duo also needs this
+	 */
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
+
 	/* P6/ARCH_PERFMON has 32 bit counter write */
 	write_watchdog_counter32(wd->perfctr_msr, NULL,nmi_hz);
 }
 
 static const struct wd_ops p6_wd_ops = {
-	.reserve = single_msr_reserve,
-	.unreserve = single_msr_unreserve,
-	.setup = setup_p6_watchdog,
-	.rearm = p6_rearm,
-	.stop = single_msr_stop_watchdog,
-	.perfctr = MSR_P6_PERFCTR0,
-	.evntsel = MSR_P6_EVNTSEL0,
-	.checkbit = 1ULL<<39,
+	.reserve	= single_msr_reserve,
+	.unreserve	= single_msr_unreserve,
+	.setup		= setup_p6_watchdog,
+	.rearm		= p6_rearm,
+	.stop		= single_msr_stop_watchdog,
+	.perfctr	= MSR_P6_PERFCTR0,
+	.evntsel	= MSR_P6_EVNTSEL0,
+	.checkbit	= 1ULL << 39,
 };
 
-/* Intel P4 performance counters. By far the most complicated of all. */
-
-#define MSR_P4_MISC_ENABLE_PERF_AVAIL	(1<<7)
-#define P4_ESCR_EVENT_SELECT(N)	((N)<<25)
-#define P4_ESCR_OS		(1<<3)
-#define P4_ESCR_USR		(1<<2)
-#define P4_CCCR_OVF_PMI0	(1<<26)
-#define P4_CCCR_OVF_PMI1	(1<<27)
-#define P4_CCCR_THRESHOLD(N)	((N)<<20)
-#define P4_CCCR_COMPLEMENT	(1<<19)
-#define P4_CCCR_COMPARE		(1<<18)
-#define P4_CCCR_REQUIRED	(3<<16)
-#define P4_CCCR_ESCR_SELECT(N)	((N)<<13)
-#define P4_CCCR_ENABLE		(1<<12)
-#define P4_CCCR_OVF 		(1<<31)
-
-/* Set up IQ_COUNTER0 to behave like a clock, by having IQ_CCCR0 filter
-   CRU_ESCR0 (with any non-null event selector) through a complemented
-   max threshold. [IA32-Vol3, Section 14.9.9] */
+/*
+ * Intel P4 performance counters.
+ * By far the most complicated of all.
+ */
+#define MSR_P4_MISC_ENABLE_PERF_AVAIL	(1 << 7)
+#define P4_ESCR_EVENT_SELECT(N)	((N) << 25)
+#define P4_ESCR_OS		(1 << 3)
+#define P4_ESCR_USR		(1 << 2)
+#define P4_CCCR_OVF_PMI0	(1 << 26)
+#define P4_CCCR_OVF_PMI1	(1 << 27)
+#define P4_CCCR_THRESHOLD(N)	((N) << 20)
+#define P4_CCCR_COMPLEMENT	(1 << 19)
+#define P4_CCCR_COMPARE		(1 << 18)
+#define P4_CCCR_REQUIRED	(3 << 16)
+#define P4_CCCR_ESCR_SELECT(N)	((N) << 13)
+#define P4_CCCR_ENABLE		(1 << 12)
+#define P4_CCCR_OVF 		(1 << 31)
 
+/*
+ * Set up IQ_COUNTER0 to behave like a clock, by having IQ_CCCR0 filter
+ * CRU_ESCR0 (with any non-null event selector) through a complemented
+ * max threshold. [IA32-Vol3, Section 14.9.9]
+ */
 static int setup_p4_watchdog(unsigned nmi_hz)
 {
 	unsigned int perfctr_msr, evntsel_msr, cccr_msr;
@@ -444,7 +461,8 @@ static int setup_p4_watchdog(unsigned nm
 #endif
 		ht_num = 0;
 
-	/* performance counters are shared resources
+	/*
+	 * performance counters are shared resources
 	 * assign each hyperthread its own set
 	 * (re-use the ESCR0 register, seems safe
 	 * and keeps the cccr_val the same)
@@ -542,20 +560,21 @@ static void p4_rearm(struct nmi_watchdog
 }
 
 static const struct wd_ops p4_wd_ops = {
-	.reserve = p4_reserve,
-	.unreserve = p4_unreserve,
-	.setup = setup_p4_watchdog,
-	.rearm = p4_rearm,
-	.stop = stop_p4_watchdog,
+	.reserve	= p4_reserve,
+	.unreserve	= p4_unreserve,
+	.setup		= setup_p4_watchdog,
+	.rearm		= p4_rearm,
+	.stop		= stop_p4_watchdog,
 	/* RED-PEN this is wrong for the other sibling */
-	.perfctr = MSR_P4_BPU_PERFCTR0,
-	.evntsel = MSR_P4_BSU_ESCR0,
-	.checkbit = 1ULL<<39,
+	.perfctr	= MSR_P4_BPU_PERFCTR0,
+	.evntsel	= MSR_P4_BSU_ESCR0,
+	.checkbit	= 1ULL << 39,
 };
 
-/* Watchdog using the Intel architected PerfMon. Used for Core2 and hopefully
-   all future Intel CPUs. */
-
+/*
+ * Watchdog using the Intel architected PerfMon.
+ * Used for Core2 and hopefully all future Intel CPUs.
+ */
 #define ARCH_PERFMON_NMI_EVENT_SEL	ARCH_PERFMON_UNHALTED_CORE_CYCLES_SEL
 #define ARCH_PERFMON_NMI_EVENT_UMASK	ARCH_PERFMON_UNHALTED_CORE_CYCLES_UMASK
 
@@ -601,19 +620,19 @@ static int setup_intel_arch_watchdog(uns
 
 	wd->perfctr_msr = perfctr_msr;
 	wd->evntsel_msr = evntsel_msr;
-	wd->cccr_msr = 0;  //unused
+	wd->cccr_msr = 0;  /* unused */
 	intel_arch_wd_ops.checkbit = 1ULL << (eax.split.bit_width - 1);
 	return 1;
 }
 
 static struct wd_ops intel_arch_wd_ops __read_mostly = {
-	.reserve = single_msr_reserve,
-	.unreserve = single_msr_unreserve,
-	.setup = setup_intel_arch_watchdog,
-	.rearm = p6_rearm,
-	.stop = single_msr_stop_watchdog,
-	.perfctr = MSR_ARCH_PERFMON_PERFCTR1,
-	.evntsel = MSR_ARCH_PERFMON_EVENTSEL1,
+	.reserve	= single_msr_reserve,
+	.unreserve	= single_msr_unreserve,
+	.setup		= setup_intel_arch_watchdog,
+	.rearm		= p6_rearm,
+	.stop		= single_msr_stop_watchdog,
+	.perfctr	= MSR_ARCH_PERFMON_PERFCTR1,
+	.evntsel	= MSR_ARCH_PERFMON_EVENTSEL1,
 };
 
 static void probe_nmi_watchdog(void)
@@ -626,8 +645,10 @@ static void probe_nmi_watchdog(void)
 		wd_ops = &k7_wd_ops;
 		break;
 	case X86_VENDOR_INTEL:
-		/* Work around Core Duo (Yonah) errata AE49 where perfctr1
-		   doesn't have a working enable bit. */
+		/*
+		 * Work around Core Duo (Yonah) errata AE49 where perfctr1
+		 * doesn't have a working enable bit.
+		 */
 		if (boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model == 14) {
 			intel_arch_wd_ops.perfctr = MSR_ARCH_PERFMON_PERFCTR0;
 			intel_arch_wd_ops.evntsel = MSR_ARCH_PERFMON_EVENTSEL0;
@@ -638,7 +659,7 @@ static void probe_nmi_watchdog(void)
 		}
 		switch (boot_cpu_data.x86) {
 		case 6:
-			if (boot_cpu_data.x86_model > 0xd)
+			if (boot_cpu_data.x86_model > 13)
 				return;
 
 			wd_ops = &p6_wd_ops;
@@ -699,10 +720,11 @@ int lapic_wd_event(unsigned nmi_hz)
 {
 	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
 	u64 ctr;
+
 	rdmsrl(wd->perfctr_msr, ctr);
-	if (ctr & wd_ops->checkbit) { /* perfctr still running? */
+	if (ctr & wd_ops->checkbit) /* perfctr still running? */
 		return 0;
-	}
+
 	wd_ops->rearm(wd, nmi_hz);
 	return 1;
 }

-- 
