Return-Path: <linux-kernel-owner+w=401wt.eu-S933313AbYCSU3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933313AbYCSU3E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:29:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757364AbYCSTjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:39:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757306AbYCSTjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:39:13 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 63/79] [PATCH] change boot_cpu_id to boot_cpu_physical_apicid
Date: Wed, 19 Mar 2008 14:25:58 -0300
Message-Id: <12059478583657-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059478541232-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com> <12059476802159-git-send-email-gcosta@redhat.com> <12059476844196-git-send-email-gcosta@redhat.com> <12059476883852-git-send-email-gcosta@redhat.com> <12059476932397-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com> <1205947702588-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com> <12059477102394-git-send-email-gcosta@redhat.com> <12059477143205-git-send-email-gcosta@redhat.com> <1205947719906-git-send-email-gcosta@redhat.com> <12059477234148-git-send-email-gcosta@redhat.com> <12059477273855-git-send-email-gcosta@redhat.com> <1205947732309-git-send-email-gcosta@redhat.com> <12059477371787-git-send-email-gcosta@redhat.com> <12059477421707-git-send-email-gcosta@redhat.com> <12059477472416-git-send-email-gcosta@redhat.com> <12059477521176-git-send!
 -email-gcosta@redhat.com> <12059477561937-git-send-email-gcosta@redhat
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

This is to match i386. The former name was cuter,
but the current is more meaningful and more general,
since cpu_id can be a logical id.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/apic_64.c    |   13 +++++++------
 arch/x86/kernel/mpparse_64.c |   12 ++++++------
 arch/x86/kernel/smpboot_64.c |   18 ++++++++++--------
 arch/x86/mm/k8topology_64.c  |    7 ++++---
 include/asm-x86/apic.h       |    1 -
 include/asm-x86/smp.h        |    3 +++
 include/asm-x86/smp_32.h     |    5 -----
 include/asm-x86/smp_64.h     |    4 ----
 8 files changed, 30 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 8a47579..868ec1d 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -431,7 +431,8 @@ void __cpuinit check_boot_apic_timer_broadcast(void)
 	lapic_clockevent.features |= CLOCK_EVT_FEAT_DUMMY;
 
 	local_irq_enable();
-	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_FORCE, &boot_cpu_id);
+	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_FORCE,
+			   &boot_cpu_physical_apicid);
 	local_irq_disable();
 }
 
@@ -857,7 +858,7 @@ static int __init detect_init_APIC(void)
 	}
 
 	mp_lapic_addr = APIC_DEFAULT_PHYS_BASE;
-	boot_cpu_id = 0;
+	boot_cpu_physical_apicid = 0;
 	return 0;
 }
 
@@ -882,7 +883,7 @@ void __init early_init_lapic_mapping(void)
 	 * Fetch the APIC ID of the BSP in case we have a
 	 * default configuration (or the MP table is broken).
 	 */
-	boot_cpu_id = GET_APIC_ID(apic_read(APIC_ID));
+	boot_cpu_physical_apicid = GET_APIC_ID(apic_read(APIC_ID));
 }
 
 /**
@@ -909,7 +910,7 @@ void __init init_apic_mappings(void)
 	 * Fetch the APIC ID of the BSP in case we have a
 	 * default configuration (or the MP table is broken).
 	 */
-	boot_cpu_id = GET_APIC_ID(apic_read(APIC_ID));
+	boot_cpu_physical_apicid = GET_APIC_ID(apic_read(APIC_ID));
 }
 
 /*
@@ -930,8 +931,8 @@ int __init APIC_init_uniprocessor(void)
 
 	verify_local_APIC();
 
-	phys_cpu_present_map = physid_mask_of_physid(boot_cpu_id);
-	apic_write(APIC_ID, SET_APIC_ID(boot_cpu_id));
+	phys_cpu_present_map = physid_mask_of_physid(boot_cpu_physical_apicid);
+	apic_write(APIC_ID, SET_APIC_ID(boot_cpu_physical_apicid));
 
 	setup_local_APIC();
 
diff --git a/arch/x86/kernel/mpparse_64.c b/arch/x86/kernel/mpparse_64.c
index 03ef1a8..20a345d 100644
--- a/arch/x86/kernel/mpparse_64.c
+++ b/arch/x86/kernel/mpparse_64.c
@@ -59,8 +59,8 @@ unsigned long mp_lapic_addr = 0;
 
 
 /* Processor that is doing the boot up */
-unsigned int boot_cpu_id = -1U;
-EXPORT_SYMBOL(boot_cpu_id);
+unsigned int boot_cpu_physical_apicid = -1U;
+EXPORT_SYMBOL(boot_cpu_physical_apicid);
 
 /* Internal processor count */
 unsigned int num_processors;
@@ -107,7 +107,7 @@ static void __cpuinit MP_processor_info(struct mpc_config_processor *m)
 	}
 	if (m->mpc_cpuflag & CPU_BOOTPROCESSOR) {
 		bootup_cpu = " (Bootup-CPU)";
-		boot_cpu_id = m->mpc_apicid;
+		boot_cpu_physical_apicid = m->mpc_apicid;
 	}
 
 	printk(KERN_INFO "Processor #%d%s\n", m->mpc_apicid, bootup_cpu);
@@ -665,8 +665,8 @@ void __init mp_register_lapic_address(u64 address)
 {
 	mp_lapic_addr = (unsigned long) address;
 	set_fixmap_nocache(FIX_APIC_BASE, mp_lapic_addr);
-	if (boot_cpu_id == -1U)
-		boot_cpu_id = GET_APIC_ID(apic_read(APIC_ID));
+	if (boot_cpu_physical_apicid == -1U)
+		boot_cpu_physical_apicid  = GET_APIC_ID(apic_read(APIC_ID));
 }
 
 void __cpuinit mp_register_lapic (u8 id, u8 enabled)
@@ -674,7 +674,7 @@ void __cpuinit mp_register_lapic (u8 id, u8 enabled)
 	struct mpc_config_processor processor;
 	int			boot_cpu = 0;
 	
-	if (id == boot_cpu_id)
+	if (id == boot_cpu_physical_apicid)
 		boot_cpu = 1;
 
 	processor.mpc_type = MP_PROCESSOR;
diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index 7ec9621..420ae4a 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -602,7 +602,8 @@ static __init void disable_smp(void)
 	cpu_present_map = cpumask_of_cpu(0);
 	cpu_possible_map = cpumask_of_cpu(0);
 	if (smp_found_config)
-		phys_cpu_present_map = physid_mask_of_physid(boot_cpu_id);
+		phys_cpu_present_map =
+				physid_mask_of_physid(boot_cpu_physical_apicid);
 	else
 		phys_cpu_present_map = physid_mask_of_physid(0);
 	cpu_set(0, per_cpu(cpu_sibling_map, 0));
@@ -637,9 +638,10 @@ static int __init smp_sanity_check(unsigned max_cpus)
 	 * Should not be necessary because the MP table should list the boot
 	 * CPU too, but we do it for the sake of robustness anyway.
 	 */
-	if (!physid_isset(boot_cpu_id, phys_cpu_present_map)) {
-		printk(KERN_NOTICE "weird, boot CPU (#%d) not listed by the BIOS.\n",
-								 boot_cpu_id);
+	if (!physid_isset(boot_cpu_physical_apicid, phys_cpu_present_map)) {
+		printk(KERN_NOTICE
+			"weird, boot CPU (#%d) not listed by the BIOS.\n",
+			boot_cpu_physical_apicid);
 		physid_set(hard_smp_processor_id(), phys_cpu_present_map);
 	}
 
@@ -648,7 +650,7 @@ static int __init smp_sanity_check(unsigned max_cpus)
 	 */
 	if (!cpu_has_apic) {
 		printk(KERN_ERR "BIOS bug, local APIC #%d not detected!...\n",
-			boot_cpu_id);
+			boot_cpu_physical_apicid);
 		printk(KERN_ERR "... forcing use of dummy APIC emulation. (tell your hw vendor)\n");
 		nr_ioapics = 0;
 		return -1;
@@ -709,9 +711,9 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 		enable_IO_APIC();
 	end_local_APIC_setup();
 
-	if (GET_APIC_ID(apic_read(APIC_ID)) != boot_cpu_id) {
+	if (GET_APIC_ID(apic_read(APIC_ID)) != boot_cpu_physical_apicid) {
 		panic("Boot APIC ID in local APIC unexpected (%d vs %d)",
-		      GET_APIC_ID(apic_read(APIC_ID)), boot_cpu_id);
+		     GET_APIC_ID(apic_read(APIC_ID)), boot_cpu_physical_apicid);
 		/* Or can we switch back to PIC here? */
 	}
 
@@ -756,7 +758,7 @@ int __cpuinit native_cpu_up(unsigned int cpu)
 
 	Dprintk("++++++++++++++++++++=_---CPU UP  %u\n", cpu);
 
-	if (apicid == BAD_APICID || apicid == boot_cpu_id ||
+	if (apicid == BAD_APICID || apicid == boot_cpu_physical_apicid ||
 	    !physid_isset(apicid, phys_cpu_present_map)) {
 		printk("__cpu_up: bad cpu %d\n", cpu);
 		return -EINVAL;
diff --git a/arch/x86/mm/k8topology_64.c b/arch/x86/mm/k8topology_64.c
index be72dd2..1f249f1 100644
--- a/arch/x86/mm/k8topology_64.c
+++ b/arch/x86/mm/k8topology_64.c
@@ -205,9 +205,10 @@ int __init k8_scan_nodes(unsigned long start, unsigned long end)
 	apicid_base = 0;
 	/* need to get boot_cpu_id early for system with apicid lifting */
 	early_get_boot_cpu_id();
-	if (boot_cpu_id > 0) {
-		printk(KERN_INFO "BSP APIC ID: %02x\n", boot_cpu_id);
-		apicid_base = boot_cpu_id;
+	if (boot_cpu_physical_apicid > 0) {
+		printk(KERN_INFO "BSP APIC ID: %02x\n",
+				 boot_cpu_physical_apicid);
+		apicid_base = boot_cpu_physical_apicid;
 	}
 
 	for (i = 0; i < 8; i++) {
diff --git a/include/asm-x86/apic.h b/include/asm-x86/apic.h
index 534af84..95676b6 100644
--- a/include/asm-x86/apic.h
+++ b/include/asm-x86/apic.h
@@ -44,7 +44,6 @@ extern int apic_runs_main_timer;
 extern int ioapic_force;
 extern int disable_apic;
 extern int disable_apic_timer;
-extern unsigned boot_cpu_id;
 
 /*
  * Basic functions accessing APICs.
diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index 78ef16d..2ad2f4f 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -109,6 +109,9 @@ extern void prefill_possible_map(void);
 extern unsigned long setup_trampoline(void);
 
 void smp_store_cpu_info(int id);
+#define cpu_physical_id(cpu)	per_cpu(x86_cpu_to_apicid, cpu)
+#else
+#define cpu_physical_id(cpu)		boot_cpu_physical_apicid
 #endif
 
 #ifdef CONFIG_X86_32
diff --git a/include/asm-x86/smp_32.h b/include/asm-x86/smp_32.h
index 478f556..f861d04 100644
--- a/include/asm-x86/smp_32.h
+++ b/include/asm-x86/smp_32.h
@@ -30,8 +30,6 @@ extern void zap_low_mappings (void);
 DECLARE_PER_CPU(int, cpu_number);
 #define raw_smp_processor_id() (x86_read_percpu(cpu_number))
 
-#define cpu_physical_id(cpu)	per_cpu(x86_cpu_to_apicid, cpu)
-
 extern int safe_smp_processor_id(void);
 
 /* We don't mark CPUs online until __cpu_up(), so we need another measure */
@@ -41,10 +39,7 @@ static inline int num_booting_cpus(void)
 }
 
 #else /* CONFIG_SMP */
-
 #define safe_smp_processor_id()		0
-#define cpu_physical_id(cpu)		boot_cpu_physical_apicid
-
 #endif /* !CONFIG_SMP */
 
 #ifdef CONFIG_X86_LOCAL_APIC
diff --git a/include/asm-x86/smp_64.h b/include/asm-x86/smp_64.h
index be870a4..fd709cb 100644
--- a/include/asm-x86/smp_64.h
+++ b/include/asm-x86/smp_64.h
@@ -22,7 +22,6 @@ extern int smp_call_function_mask(cpumask_t mask, void (*func)(void *),
 #ifdef CONFIG_SMP
 
 #define raw_smp_processor_id()	read_pda(cpunumber)
-#define cpu_physical_id(cpu)	per_cpu(x86_cpu_to_apicid, cpu)
 
 #define stack_smp_processor_id()					\
 	({								\
@@ -41,9 +40,6 @@ static inline int num_booting_cpus(void)
 }
 
 #else /* CONFIG_SMP */
-
-extern unsigned int boot_cpu_id;
-#define cpu_physical_id(cpu)	boot_cpu_id
 #define stack_smp_processor_id() 0
 
 #endif /* !CONFIG_SMP */
-- 
1.5.0.6

