Return-Path: <linux-kernel-owner+w=401wt.eu-S1756447AbZFCIrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447AbZFCIrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 04:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753783AbZFCIqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 04:46:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:44938 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754259AbZFCIqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 04:46:48 -0400
Date: Wed, 3 Jun 2009 08:46:09 GMT
From: tip-bot for Yong Wang <yong.y.wang@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, yong.y.wang@intel.com,
       yong.y.wang@linux.intel.com, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, yong.y.wang@intel.com, yong.y.wang@linux.intel.com,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <20090603051255.GA2791@ywang-moblin2.bj.intel.com>
References: <20090603051255.GA2791@ywang-moblin2.bj.intel.com>
Subject: [tip:perfcounters/core] perf_counter/x86: Remove the IRQ (non-NMI) handling bits
Message-ID: <tip-a32881066e58346f2901afe0ebdfbf0c562877e5@git.kernel.org>
Git-Commit-ID: a32881066e58346f2901afe0ebdfbf0c562877e5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 03 Jun 2009 08:46:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a32881066e58346f2901afe0ebdfbf0c562877e5
Gitweb:     http://git.kernel.org/tip/a32881066e58346f2901afe0ebdfbf0c562877e5
Author:     Yong Wang <yong.y.wang@linux.intel.com>
AuthorDate: Wed, 3 Jun 2009 13:12:55 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 3 Jun 2009 09:53:34 +0200

perf_counter/x86: Remove the IRQ (non-NMI) handling bits

Remove the IRQ (non-NMI) handling bits as NMI will be used always.

Signed-off-by: Yong Wang <yong.y.wang@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <20090603051255.GA2791@ywang-moblin2.bj.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/entry_arch.h  |    1 -
 arch/x86/include/asm/hw_irq.h      |    1 -
 arch/x86/include/asm/irq_vectors.h |    5 -----
 arch/x86/kernel/cpu/perf_counter.c |   21 ++++++---------------
 arch/x86/kernel/entry_64.S         |    2 --
 arch/x86/kernel/irqinit_32.c       |    1 -
 arch/x86/kernel/irqinit_64.c       |    1 -
 7 files changed, 6 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/entry_arch.h b/arch/x86/include/asm/entry_arch.h
index fe24d28..d750a10 100644
--- a/arch/x86/include/asm/entry_arch.h
+++ b/arch/x86/include/asm/entry_arch.h
@@ -49,7 +49,6 @@ BUILD_INTERRUPT(error_interrupt,ERROR_APIC_VECTOR)
 BUILD_INTERRUPT(spurious_interrupt,SPURIOUS_APIC_VECTOR)
 
 #ifdef CONFIG_PERF_COUNTERS
-BUILD_INTERRUPT(perf_counter_interrupt, LOCAL_PERF_VECTOR)
 BUILD_INTERRUPT(perf_pending_interrupt, LOCAL_PENDING_VECTOR)
 #endif
 
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 7309c0a..4b4921d 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -29,7 +29,6 @@
 extern void apic_timer_interrupt(void);
 extern void generic_interrupt(void);
 extern void error_interrupt(void);
-extern void perf_counter_interrupt(void);
 extern void perf_pending_interrupt(void);
 
 extern void spurious_interrupt(void);
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 545bb81..4492e19 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -107,11 +107,6 @@
 #define LOCAL_TIMER_VECTOR		0xef
 
 /*
- * Performance monitoring interrupt vector:
- */
-#define LOCAL_PERF_VECTOR		0xee
-
-/*
  * Generic system vector for platform specific use
  */
 #define GENERIC_INTERRUPT_VECTOR	0xed
diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index e16e8c1..12cc05e 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -40,7 +40,7 @@ struct cpu_hw_counters {
 struct x86_pmu {
 	const char	*name;
 	int		version;
-	int		(*handle_irq)(struct pt_regs *, int);
+	int		(*handle_irq)(struct pt_regs *);
 	void		(*disable_all)(void);
 	void		(*enable_all)(void);
 	void		(*enable)(struct hw_perf_counter *, int);
@@ -755,7 +755,7 @@ static void intel_pmu_reset(void)
  * This handler is triggered by the local APIC, so the APIC IRQ handling
  * rules apply:
  */
-static int intel_pmu_handle_irq(struct pt_regs *regs, int nmi)
+static int intel_pmu_handle_irq(struct pt_regs *regs)
 {
 	struct cpu_hw_counters *cpuc;
 	struct cpu_hw_counters;
@@ -794,7 +794,7 @@ again:
 		if (!intel_pmu_save_and_restart(counter))
 			continue;
 
-		if (perf_counter_overflow(counter, nmi, regs, 0))
+		if (perf_counter_overflow(counter, 1, regs, 0))
 			intel_pmu_disable_counter(&counter->hw, bit);
 	}
 
@@ -812,7 +812,7 @@ again:
 	return 1;
 }
 
-static int amd_pmu_handle_irq(struct pt_regs *regs, int nmi)
+static int amd_pmu_handle_irq(struct pt_regs *regs)
 {
 	int cpu, idx, handled = 0;
 	struct cpu_hw_counters *cpuc;
@@ -840,22 +840,13 @@ static int amd_pmu_handle_irq(struct pt_regs *regs, int nmi)
 		if (!x86_perf_counter_set_period(counter, hwc, idx))
 			continue;
 
-		if (perf_counter_overflow(counter, nmi, regs, 0))
+		if (perf_counter_overflow(counter, 1, regs, 0))
 			amd_pmu_disable_counter(hwc, idx);
 	}
 
 	return handled;
 }
 
-void smp_perf_counter_interrupt(struct pt_regs *regs)
-{
-	irq_enter();
-	apic_write(APIC_LVTPC, LOCAL_PERF_VECTOR);
-	ack_APIC_irq();
-	x86_pmu.handle_irq(regs, 0);
-	irq_exit();
-}
-
 void smp_perf_pending_interrupt(struct pt_regs *regs)
 {
 	irq_enter();
@@ -910,7 +901,7 @@ perf_counter_nmi_handler(struct notifier_block *self,
 	 * If the first NMI handles both, the latter will be empty and daze
 	 * the CPU.
 	 */
-	x86_pmu.handle_irq(regs, 1);
+	x86_pmu.handle_irq(regs);
 
 	return NOTIFY_STOP;
 }
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 8910046..7985c01 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1026,8 +1026,6 @@ apicinterrupt SPURIOUS_APIC_VECTOR \
 	spurious_interrupt smp_spurious_interrupt
 
 #ifdef CONFIG_PERF_COUNTERS
-apicinterrupt LOCAL_PERF_VECTOR \
-	perf_counter_interrupt smp_perf_counter_interrupt
 apicinterrupt LOCAL_PENDING_VECTOR \
 	perf_pending_interrupt smp_perf_pending_interrupt
 #endif
diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit_32.c
index 3190a6b..205bdd8 100644
--- a/arch/x86/kernel/irqinit_32.c
+++ b/arch/x86/kernel/irqinit_32.c
@@ -165,7 +165,6 @@ static void __init apic_intr_init(void)
 	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
 	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
 # ifdef CONFIG_PERF_COUNTERS
-	alloc_intr_gate(LOCAL_PERF_VECTOR, perf_counter_interrupt);
 	alloc_intr_gate(LOCAL_PENDING_VECTOR, perf_pending_interrupt);
 # endif
 
diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
index 53ceb26..fa6ef69 100644
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -155,7 +155,6 @@ static void __init apic_intr_init(void)
 
 	/* Performance monitoring interrupt: */
 #ifdef CONFIG_PERF_COUNTERS
-	alloc_intr_gate(LOCAL_PERF_VECTOR, perf_counter_interrupt);
 	alloc_intr_gate(LOCAL_PENDING_VECTOR, perf_pending_interrupt);
 #endif
 }
