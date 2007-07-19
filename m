Return-Path: <linux-kernel-owner+w=401wt.eu-S937534AbXGSKNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937534AbXGSKNm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755476AbXGSJzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:55:42 -0400
Received: from ns.suse.de ([195.135.220.2]:35399 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759202AbXGSJzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:55:22 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: tglx@linutronix.de, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [32/58] x86_64: time.c white space wreckage cleanup
Message-Id: <20070719095518.009CA14E0B@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:55:17 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/time.c |   88 +++++++++++++++++++++++-----------------------
 1 file changed, 44 insertions(+), 44 deletions(-)

Index: linux/arch/x86_64/kernel/time.c
===================================================================
--- linux.orig/arch/x86_64/kernel/time.c
+++ linux/arch/x86_64/kernel/time.c
@@ -220,7 +220,7 @@ unsigned long read_persistent_clock(void
 	/*
 	 * We know that x86-64 always uses BCD format, no need to check the
 	 * config register.
- 	 */
+	 */
 
 	BCD_TO_BIN(sec);
 	BCD_TO_BIN(min);
@@ -233,11 +233,11 @@ unsigned long read_persistent_clock(void
 		BCD_TO_BIN(century);
 		year += century * 100;
 		printk(KERN_INFO "Extended CMOS year: %d\n", century * 100);
-	} else { 
+	} else {
 		/*
 		 * x86-64 systems only exists since 2002.
 		 * This will work up to Dec 31, 2100
-	 	 */
+		 */
 		year += 2000;
 	}
 
@@ -249,45 +249,45 @@ unsigned long read_persistent_clock(void
 #define TICK_COUNT 100000000
 static unsigned int __init tsc_calibrate_cpu_khz(void)
 {
-       int tsc_start, tsc_now;
-       int i, no_ctr_free;
-       unsigned long evntsel3 = 0, pmc3 = 0, pmc_now = 0;
-       unsigned long flags;
-
-       for (i = 0; i < 4; i++)
-               if (avail_to_resrv_perfctr_nmi_bit(i))
-                       break;
-       no_ctr_free = (i == 4);
-       if (no_ctr_free) {
-               i = 3;
-               rdmsrl(MSR_K7_EVNTSEL3, evntsel3);
-               wrmsrl(MSR_K7_EVNTSEL3, 0);
-               rdmsrl(MSR_K7_PERFCTR3, pmc3);
-       } else {
-               reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i);
-               reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
-       }
-       local_irq_save(flags);
-       /* start meauring cycles, incrementing from 0 */
-       wrmsrl(MSR_K7_PERFCTR0 + i, 0);
-       wrmsrl(MSR_K7_EVNTSEL0 + i, 1 << 22 | 3 << 16 | 0x76);
-       rdtscl(tsc_start);
-       do {
-               rdmsrl(MSR_K7_PERFCTR0 + i, pmc_now);
-               tsc_now = get_cycles_sync();
-       } while ((tsc_now - tsc_start) < TICK_COUNT);
-
-       local_irq_restore(flags);
-       if (no_ctr_free) {
-               wrmsrl(MSR_K7_EVNTSEL3, 0);
-               wrmsrl(MSR_K7_PERFCTR3, pmc3);
-               wrmsrl(MSR_K7_EVNTSEL3, evntsel3);
-       } else {
-               release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
-               release_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
-       }
+	int tsc_start, tsc_now;
+	int i, no_ctr_free;
+	unsigned long evntsel3 = 0, pmc3 = 0, pmc_now = 0;
+	unsigned long flags;
+
+	for (i = 0; i < 4; i++)
+		if (avail_to_resrv_perfctr_nmi_bit(i))
+			break;
+	no_ctr_free = (i == 4);
+	if (no_ctr_free) {
+		i = 3;
+		rdmsrl(MSR_K7_EVNTSEL3, evntsel3);
+		wrmsrl(MSR_K7_EVNTSEL3, 0);
+		rdmsrl(MSR_K7_PERFCTR3, pmc3);
+	} else {
+		reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i);
+		reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
+	}
+	local_irq_save(flags);
+	/* start meauring cycles, incrementing from 0 */
+	wrmsrl(MSR_K7_PERFCTR0 + i, 0);
+	wrmsrl(MSR_K7_EVNTSEL0 + i, 1 << 22 | 3 << 16 | 0x76);
+	rdtscl(tsc_start);
+	do {
+		rdmsrl(MSR_K7_PERFCTR0 + i, pmc_now);
+		tsc_now = get_cycles_sync();
+	} while ((tsc_now - tsc_start) < TICK_COUNT);
+
+	local_irq_restore(flags);
+	if (no_ctr_free) {
+		wrmsrl(MSR_K7_EVNTSEL3, 0);
+		wrmsrl(MSR_K7_PERFCTR3, pmc3);
+		wrmsrl(MSR_K7_EVNTSEL3, evntsel3);
+	} else {
+		release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
+		release_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
+	}
 
-       return pmc_now * tsc_khz / (tsc_now - tsc_start);
+	return pmc_now * tsc_khz / (tsc_now - tsc_start);
 }
 
 /*
@@ -315,7 +315,7 @@ static unsigned int __init pit_calibrate
 	end = get_cycles_sync();
 
 	spin_unlock_irqrestore(&i8253_lock, flags);
-	
+
 	return (end - start) / 50;
 }
 
@@ -360,7 +360,7 @@ static struct irqaction irq0 = {
 	.handler	= timer_interrupt,
 	.flags		= IRQF_DISABLED | IRQF_IRQPOLL,
 	.mask		= CPU_MASK_NONE,
-	.name 		= "timer"
+	.name		= "timer"
 };
 
 void __init time_init(void)
@@ -373,7 +373,7 @@ void __init time_init(void)
 
 	if (hpet_use_timer) {
 		/* set tick_nsec to use the proper rate for HPET */
-	  	tick_nsec = TICK_NSEC_HPET;
+		tick_nsec = TICK_NSEC_HPET;
 		tsc_khz = hpet_calibrate_tsc();
 		timename = "HPET";
 	} else {
