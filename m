Return-Path: <linux-kernel-owner+w=401wt.eu-S1760059AbYCCRdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760059AbYCCRdE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:33:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759778AbYCCRQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:16:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759736AbYCCRQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:16:20 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 52/52] merge smp_callin
Date: Mon,  3 Mar 2008 14:13:20 -0300
Message-Id: <1204564400-17636-53-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204564400-17636-52-git-send-email-gcosta@redhat.com>
References: <1204564400-17636-1-git-send-email-gcosta@redhat.com>
 <1204564400-17636-2-git-send-email-gcosta@redhat.com>
 <1204564400-17636-3-git-send-email-gcosta@redhat.com>
 <1204564400-17636-4-git-send-email-gcosta@redhat.com>
 <1204564400-17636-5-git-send-email-gcosta@redhat.com>
 <1204564400-17636-6-git-send-email-gcosta@redhat.com>
 <1204564400-17636-7-git-send-email-gcosta@redhat.com>
 <1204564400-17636-8-git-send-email-gcosta@redhat.com>
 <1204564400-17636-9-git-send-email-gcosta@redhat.com>
 <1204564400-17636-10-git-send-email-gcosta@redhat.com>
 <1204564400-17636-11-git-send-email-gcosta@redhat.com>
 <1204564400-17636-12-git-send-email-gcosta@redhat.com>
 <1204564400-17636-13-git-send-email-gcosta@redhat.com>
 <1204564400-17636-14-git-send-email-gcosta@redhat.com>
 <1204564400-17636-15-git-send-email-gcosta@redhat.com>
 <1204564400-17636-16-git-send-email-gcosta@redhat.com>
 <1204564400-17636-17-git-send-email-gcosta@redhat.com>
 <1204564400-17636-18-git-send-email-gcosta@redhat.com>
 <1204564400-17636-19-git-send-email-gcosta@redhat.com>
 <1204564400-17636-20-git-send-email-gcosta@redhat.com>
 <1204564400-17636-21-git-send-email-gcosta@redhat.com>
 <1204564400-17636-22-git-send-email-gcosta@redhat.com>
 <1204564400-17636-23-git-send-email-gcosta@redhat.com>
 <1204564400-17636-24-git-send-email-gcosta@redhat.com>
 <1204564400-17636-25-git-send-email-gcosta@redhat.com>
 <1204564400-17636-26-git-send-email-gcosta@redhat.com>
 <1204564400-17636-27-git-send-email-gcosta@redhat.com>
 <1204564400-17636-28-git-send-email-gcosta@redhat.com>
 <1204564400-17636-29-git-send-email-gcosta@redhat.com>
 <1204564400-17636-30-git-send-email-gcosta@redhat.com>
 <1204564400-17636-31-git-send-email-gcosta@redhat.com>
 <1204564400-17636-32-git-send-email-gcosta@redhat.com>
 <1204564400-17636-33-git-send-email-gcosta@redhat.com>
 <1204564400-17636-34-git-send-email-gcosta@redhat.com>
 <1204564400-17636-35-git-send-email-gcosta@redhat.com>
 <1204564400-17636-36-git-send-email-gcosta@redhat.com>
 <1204564400-17636-37-git-send-email-gcosta@redhat.com>
 <1204564400-17636-38-git-send-email-gcosta@redhat.com>
 <1204564400-17636-39-git-send-email-gcosta@redhat.com>
 <1204564400-17636-40-git-send-email-gcosta@redhat.com>
 <1204564400-17636-41-git-send-email-gcosta@redhat.com>
 <1204564400-17636-42-git-send-email-gcosta@redhat.com>
 <1204564400-17636-43-git-send-email-gcosta@redhat.com>
 <1204564400-17636-44-git-send-email-gcosta@redhat.com>
 <1204564400-17636-45-git-send-email-gcosta@redhat.com>
 <1204564400-17636-46-git-send-email-gcosta@redhat.com>
 <1204564400-17636-47-git-send-email-gcosta@redhat.com>
 <1204564400-17636-48-git-send-email-gcosta@redhat.com>
 <1204564400-17636-49-git-send-email-gcosta@redhat.com>
 <1204564400-17636-50-git-send-email-gcosta@redhat.com>
 <1204564400-17636-51-git-send-email-gcosta@redhat.com>
 <1204564400-17636-52-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

smp_callin() looks like the same between i386 and x86_64,
and it is merged in a common file

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot.c    |  110 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/smpboot_32.c |   89 ----------------------------------
 arch/x86/kernel/smpboot_64.c |  102 +--------------------------------------
 include/asm-x86/smp.h        |    3 +
 4 files changed, 114 insertions(+), 190 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index b13b9d5..e0830bb 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -11,6 +11,11 @@
 #include <asm/cpu.h>
 #include <asm/numa.h>
 
+#ifdef CONFIG_X86_32
+#include <mach_apic.h>
+#include <mach_wakecpu.h>
+#endif
+
 /* Number of siblings per CPU package */
 int smp_num_siblings = 1;
 EXPORT_SYMBOL(smp_num_siblings);
@@ -151,6 +156,111 @@ void __init smp_alloc_memory(void)
 }
 #endif
 
+#ifdef CONFIG_X86_64
+static inline void wait_for_init_deassert(atomic_t *deassert)
+{
+	while (!atomic_read(deassert))
+		cpu_relax();
+	return;
+}
+#define smp_callin_clear_local_apic() do {} while (0)
+#define map_cpu_to_logical_apicid() do {} while (0)
+#else
+extern void map_cpu_to_logical_apicid(void);
+#endif
+
+atomic_t init_deasserted __cpuinitdata;
+extern void smp_store_cpu_info(int cpuid);
+
+/*
+ * Report back to the Boot Processor.
+ * Running on AP.
+ */
+void __cpuinit smp_callin(void)
+{
+	int cpuid, phys_id;
+	unsigned long timeout;
+
+	/*
+	 * If waken up by an INIT in an 82489DX configuration
+	 * we may get here before an INIT-deassert IPI reaches
+	 * our local APIC.  We have to wait for the IPI or we'll
+	 * lock up on an APIC access.
+	 */
+	wait_for_init_deassert(&init_deasserted);
+
+	/*
+	 * (This works even if the APIC is not enabled.)
+	 */
+	phys_id = GET_APIC_ID(apic_read(APIC_ID));
+	cpuid = smp_processor_id();
+	if (cpu_isset(cpuid, cpu_callin_map)) {
+		panic("smp_callin: phys CPU#%d, CPU#%d already present??\n",
+					phys_id, cpuid);
+	}
+	Dprintk("CPU#%d (phys ID: %d) waiting for CALLOUT\n", cpuid, phys_id);
+
+	/*
+	 * STARTUP IPIs are fragile beasts as they might sometimes
+	 * trigger some glue motherboard logic. Complete APIC bus
+	 * silence for 1 second, this overestimates the time the
+	 * boot CPU is spending to send the up to 2 STARTUP IPIs
+	 * by a factor of two. This should be enough.
+	 */
+
+	/*
+	 * Waiting 2s total for startup (udelay is not yet working)
+	 */
+	timeout = jiffies + 2*HZ;
+	while (time_before(jiffies, timeout)) {
+		/*
+		 * Has the boot CPU finished it's STARTUP sequence?
+		 */
+		if (cpu_isset(cpuid, cpu_callout_map))
+			break;
+		cpu_relax();
+	}
+
+	if (!time_before(jiffies, timeout)) {
+		panic("%s: CPU%d started up but did not get a callout!\n",
+		      __func__, cpuid);
+	}
+
+	/*
+	 * the boot CPU has finished the init stage and is spinning
+	 * on callin_map until we finish. We are free to set up this
+	 * CPU, first the APIC. (this is probably redundant on most
+	 * boards)
+	 */
+
+	Dprintk("CALLIN, before setup_local_APIC().\n");
+	smp_callin_clear_local_apic();
+	setup_local_APIC();
+	end_local_APIC_setup();
+	map_cpu_to_logical_apicid();
+
+	/*
+	 * Get our bogomips.
+	 *
+	 * Need to enable IRQs because it can take longer and then
+	 * the NMI watchdog might kill us.
+	 */
+	local_irq_enable();
+	calibrate_delay();
+	local_irq_disable();
+	Dprintk("Stack at about %p\n", &cpuid);
+
+	/*
+	 * Save our processor parameters
+	 */
+	smp_store_cpu_info(cpuid);
+
+	/*
+	 * Allow the master to continue.
+	 */
+	cpu_set(cpuid, cpu_callin_map);
+}
+
 #ifdef CONFIG_HOTPLUG_CPU
 void remove_siblinginfo(int cpu)
 {
diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index adad1ad..0bc78a5 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -140,95 +140,6 @@ valid_k7:
 	;
 }
 
-static atomic_t init_deasserted;
-
-static void __cpuinit smp_callin(void)
-{
-	int cpuid, phys_id;
-	unsigned long timeout;
-
-	/*
-	 * If waken up by an INIT in an 82489DX configuration
-	 * we may get here before an INIT-deassert IPI reaches
-	 * our local APIC.  We have to wait for the IPI or we'll
-	 * lock up on an APIC access.
-	 */
-	wait_for_init_deassert(&init_deasserted);
-
-	/*
-	 * (This works even if the APIC is not enabled.)
-	 */
-	phys_id = GET_APIC_ID(apic_read(APIC_ID));
-	cpuid = smp_processor_id();
-	if (cpu_isset(cpuid, cpu_callin_map)) {
-		printk("huh, phys CPU#%d, CPU#%d already present??\n",
-					phys_id, cpuid);
-		BUG();
-	}
-	Dprintk("CPU#%d (phys ID: %d) waiting for CALLOUT\n", cpuid, phys_id);
-
-	/*
-	 * STARTUP IPIs are fragile beasts as they might sometimes
-	 * trigger some glue motherboard logic. Complete APIC bus
-	 * silence for 1 second, this overestimates the time the
-	 * boot CPU is spending to send the up to 2 STARTUP IPIs
-	 * by a factor of two. This should be enough.
-	 */
-
-	/*
-	 * Waiting 2s total for startup (udelay is not yet working)
-	 */
-	timeout = jiffies + 2*HZ;
-	while (time_before(jiffies, timeout)) {
-		/*
-		 * Has the boot CPU finished it's STARTUP sequence?
-		 */
-		if (cpu_isset(cpuid, cpu_callout_map))
-			break;
-		cpu_relax();
-	}
-
-	if (!time_before(jiffies, timeout)) {
-		printk("BUG: CPU%d started up but did not get a callout!\n",
-			cpuid);
-		BUG();
-	}
-
-	/*
-	 * the boot CPU has finished the init stage and is spinning
-	 * on callin_map until we finish. We are free to set up this
-	 * CPU, first the APIC. (this is probably redundant on most
-	 * boards)
-	 */
-
-	Dprintk("CALLIN, before setup_local_APIC().\n");
-	smp_callin_clear_local_apic();
-	setup_local_APIC();
-	end_local_APIC_setup();
-	map_cpu_to_logical_apicid();
-
-	/*
-	 * Get our bogomips.
-	 *
-	 * Need to enable IRQs because it can take longer and then
-	 * the NMI watchdog might kill us.
-	 */
-	local_irq_enable();
-	calibrate_delay();
-	local_irq_disable();
-	Dprintk("Stack at about %p\n",&cpuid);
-
-	/*
-	 * Save our processor parameters
-	 */
-	smp_store_cpu_info(cpuid);
-
-	/*
-	 * Allow the master to continue.
-	 */
-	cpu_set(cpuid, cpu_callin_map);
-}
-
 static int cpucount;
 
 /*
diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index b6a5da5..b59da62 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -90,7 +90,7 @@ struct task_struct *idle_thread_array[NR_CPUS] __cpuinitdata ;
  * a given CPU
  */
 
-static void __cpuinit smp_store_cpu_info(int id)
+void __cpuinit smp_store_cpu_info(int id)
 {
 	struct cpuinfo_x86 *c = &cpu_data(id);
 
@@ -100,106 +100,6 @@ static void __cpuinit smp_store_cpu_info(int id)
 	print_cpu_info(c);
 }
 
-static inline void wait_for_init_deassert(atomic_t *deassert)
-{
-	while (!atomic_read(deassert))
-		cpu_relax();
-	return;
-}
-#define smp_callin_clear_local_apic() do {} while (0)
-#define map_cpu_to_logical_apicid() do {} while (0)
-
-static atomic_t init_deasserted __cpuinitdata;
-
-/*
- * Report back to the Boot Processor.
- * Running on AP.
- */
-void __cpuinit smp_callin(void)
-{
-	int cpuid, phys_id;
-	unsigned long timeout;
-
-	/*
-	 * If waken up by an INIT in an 82489DX configuration
-	 * we may get here before an INIT-deassert IPI reaches
-	 * our local APIC.  We have to wait for the IPI or we'll
-	 * lock up on an APIC access.
-	 */
-	wait_for_init_deassert(&init_deasserted);
-
-	/*
-	 * (This works even if the APIC is not enabled.)
-	 */
-	phys_id = GET_APIC_ID(apic_read(APIC_ID));
-	cpuid = smp_processor_id();
-	if (cpu_isset(cpuid, cpu_callin_map)) {
-		panic("smp_callin: phys CPU#%d, CPU#%d already present??\n",
-					phys_id, cpuid);
-	}
-	Dprintk("CPU#%d (phys ID: %d) waiting for CALLOUT\n", cpuid, phys_id);
-
-	/*
-	 * STARTUP IPIs are fragile beasts as they might sometimes
-	 * trigger some glue motherboard logic. Complete APIC bus
-	 * silence for 1 second, this overestimates the time the
-	 * boot CPU is spending to send the up to 2 STARTUP IPIs
-	 * by a factor of two. This should be enough.
-	 */
-
-	/*
-	 * Waiting 2s total for startup (udelay is not yet working)
-	 */
-	timeout = jiffies + 2*HZ;
-	while (time_before(jiffies, timeout)) {
-		/*
-		 * Has the boot CPU finished it's STARTUP sequence?
-		 */
-		if (cpu_isset(cpuid, cpu_callout_map))
-			break;
-		cpu_relax();
-	}
-
-	if (!time_before(jiffies, timeout)) {
-		panic("smp_callin: CPU%d started up but did not get a callout!\n",
-			cpuid);
-	}
-
-	/*
-	 * the boot CPU has finished the init stage and is spinning
-	 * on callin_map until we finish. We are free to set up this
-	 * CPU, first the APIC. (this is probably redundant on most
-	 * boards)
-	 */
-
-	Dprintk("CALLIN, before setup_local_APIC().\n");
-	smp_callin_clear_local_apic();
-	setup_local_APIC();
-	end_local_APIC_setup();
-	map_cpu_to_logical_apicid();
-
-	/*
-	 * Get our bogomips.
- 	 *
- 	 * Need to enable IRQs because it can take longer and then
-	 * the NMI watchdog might kill us.
-	 */
-	local_irq_enable();
-	calibrate_delay();
-	local_irq_disable();
-	Dprintk("Stack at about %p\n",&cpuid);
-
-	/*
-	 * Save our processor parameters
-	 */
- 	smp_store_cpu_info(cpuid);
-
-	/*
-	 * Allow the master to continue.
-	 */
-	cpu_set(cpuid, cpu_callin_map);
-}
-
 /*
  * Setup code on secondary processor (after comming out of the trampoline)
  */
diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index 513c857..821716c 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -3,11 +3,13 @@
 #ifndef __ASSEMBLY__
 #include <linux/cpumask.h>
 #include <linux/init.h>
+#include <asm/atomic.h>
 
 extern cpumask_t cpu_callout_map;
 
 extern int smp_num_siblings;
 extern unsigned int num_processors;
+extern atomic_t init_deasserted;
 
 /*
  * Trampoline 80x86 program as an array.
@@ -99,6 +101,7 @@ extern void cpu_uninit(void);
 extern void remove_siblinginfo(int cpu);
 #endif
 
+extern void smp_callin(void);
 extern void smp_alloc_memory(void);
 extern void lock_ipi_call_lock(void);
 extern void unlock_ipi_call_lock(void);
-- 
1.5.0.6

