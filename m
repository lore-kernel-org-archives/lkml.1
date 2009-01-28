Return-Path: <linux-kernel-owner+w=401wt.eu-S1758833AbZA1XsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758833AbZA1XsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757547AbZA1Xnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:43:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:37404 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758172AbZA1Xnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:43:43 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 007/114] x86: rename 'genapic' to 'apic'
Date: Wed, 28 Jan 2009 23:41:13 +0000
Message-Id: <1233186180-29883-8-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:43:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename genapic-> to apic-> references because in a future chagne we'll
open-code all the indirect calls (instead of obscuring them via macros),
so we want this reference to be as short as possible.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/genapic.h                   |    2 +-
 arch/x86/include/asm/mach-default/mach_apic.h    |   22 +++---
 arch/x86/include/asm/mach-default/mach_apicdef.h |    6 +-
 arch/x86/include/asm/mach-default/mach_ipi.h     |    8 +-
 arch/x86/include/asm/mach-generic/mach_apic.h    |   70 ++++++++++----------
 arch/x86/include/asm/mach-generic/mach_apicdef.h |    4 +-
 arch/x86/include/asm/mach-generic/mach_ipi.h     |    6 +-
 arch/x86/include/asm/mach-generic/mach_wakecpu.h |   24 +++---
 arch/x86/kernel/es7000_32.c                      |    6 +-
 arch/x86/kernel/genapic_64.c                     |   16 ++--
 arch/x86/kernel/io_apic.c                        |   80 +++++++++++-----------
 arch/x86/kernel/numaq_32.c                       |    2 +-
 arch/x86/kernel/setup.c                          |    2 +-
 arch/x86/mach-generic/es7000.c                   |   12 ++--
 arch/x86/mach-generic/probe.c                    |   24 +++---
 15 files changed, 142 insertions(+), 142 deletions(-)
 rewrite arch/x86/include/asm/mach-generic/mach_apic.h (86%)
 rewrite arch/x86/include/asm/mach-generic/mach_wakecpu.h (75%)

diff --git a/arch/x86/include/asm/genapic.h b/arch/x86/include/asm/genapic.h
index c27efde..3970da3 100644
--- a/arch/x86/include/asm/genapic.h
+++ b/arch/x86/include/asm/genapic.h
@@ -94,7 +94,7 @@ struct genapic {
 	void (*inquire_remote_apic)(int apicid);
 };
 
-extern struct genapic *genapic;
+extern struct genapic *apic;
 
 #ifdef CONFIG_X86_32
 
diff --git a/arch/x86/include/asm/mach-default/mach_apic.h b/arch/x86/include/asm/mach-default/mach_apic.h
index cc09cbb..2448b92 100644
--- a/arch/x86/include/asm/mach-default/mach_apic.h
+++ b/arch/x86/include/asm/mach-default/mach_apic.h
@@ -22,18 +22,18 @@ static inline const struct cpumask *target_cpus(void)
 
 #ifdef CONFIG_X86_64
 #include <asm/genapic.h>
-#define INT_DELIVERY_MODE (genapic->int_delivery_mode)
-#define INT_DEST_MODE (genapic->int_dest_mode)
-#define TARGET_CPUS	  (genapic->target_cpus())
-#define apic_id_registered (genapic->apic_id_registered)
-#define init_apic_ldr (genapic->init_apic_ldr)
-#define cpu_mask_to_apicid (genapic->cpu_mask_to_apicid)
-#define cpu_mask_to_apicid_and (genapic->cpu_mask_to_apicid_and)
-#define phys_pkg_id	(genapic->phys_pkg_id)
-#define vector_allocation_domain    (genapic->vector_allocation_domain)
+#define INT_DELIVERY_MODE (apic->int_delivery_mode)
+#define INT_DEST_MODE (apic->int_dest_mode)
+#define TARGET_CPUS	  (apic->target_cpus())
+#define apic_id_registered (apic->apic_id_registered)
+#define init_apic_ldr (apic->init_apic_ldr)
+#define cpu_mask_to_apicid (apic->cpu_mask_to_apicid)
+#define cpu_mask_to_apicid_and (apic->cpu_mask_to_apicid_and)
+#define phys_pkg_id	(apic->phys_pkg_id)
+#define vector_allocation_domain    (apic->vector_allocation_domain)
 #define read_apic_id()  (GET_APIC_ID(apic_read(APIC_ID)))
-#define send_IPI_self (genapic->send_IPI_self)
-#define wakeup_secondary_cpu (genapic->wakeup_cpu)
+#define send_IPI_self (apic->send_IPI_self)
+#define wakeup_secondary_cpu (apic->wakeup_cpu)
 extern void setup_apic_routing(void);
 #else
 #define INT_DELIVERY_MODE dest_LowestPrio
diff --git a/arch/x86/include/asm/mach-default/mach_apicdef.h b/arch/x86/include/asm/mach-default/mach_apicdef.h
index 5317993..b4dcc09 100644
--- a/arch/x86/include/asm/mach-default/mach_apicdef.h
+++ b/arch/x86/include/asm/mach-default/mach_apicdef.h
@@ -4,9 +4,9 @@
 #include <asm/apic.h>
 
 #ifdef CONFIG_X86_64
-#define	APIC_ID_MASK		(genapic->apic_id_mask)
-#define GET_APIC_ID(x)		(genapic->get_apic_id(x))
-#define	SET_APIC_ID(x)		(genapic->set_apic_id(x))
+#define	APIC_ID_MASK		(apic->apic_id_mask)
+#define GET_APIC_ID(x)		(apic->get_apic_id(x))
+#define	SET_APIC_ID(x)		(apic->set_apic_id(x))
 #else
 #define		APIC_ID_MASK		(0xF<<24)
 static inline unsigned get_apic_id(unsigned long x) 
diff --git a/arch/x86/include/asm/mach-default/mach_ipi.h b/arch/x86/include/asm/mach-default/mach_ipi.h
index 191312d..0893996 100644
--- a/arch/x86/include/asm/mach-default/mach_ipi.h
+++ b/arch/x86/include/asm/mach-default/mach_ipi.h
@@ -12,8 +12,8 @@ extern int no_broadcast;
 
 #ifdef CONFIG_X86_64
 #include <asm/genapic.h>
-#define send_IPI_mask (genapic->send_IPI_mask)
-#define send_IPI_mask_allbutself (genapic->send_IPI_mask_allbutself)
+#define send_IPI_mask (apic->send_IPI_mask)
+#define send_IPI_mask_allbutself (apic->send_IPI_mask_allbutself)
 #else
 static inline void send_IPI_mask(const struct cpumask *mask, int vector)
 {
@@ -39,8 +39,8 @@ static inline void __local_send_IPI_all(int vector)
 }
 
 #ifdef CONFIG_X86_64
-#define send_IPI_allbutself (genapic->send_IPI_allbutself)
-#define send_IPI_all (genapic->send_IPI_all)
+#define send_IPI_allbutself (apic->send_IPI_allbutself)
+#define send_IPI_all (apic->send_IPI_all)
 #else
 static inline void send_IPI_allbutself(int vector)
 {
diff --git a/arch/x86/include/asm/mach-generic/mach_apic.h b/arch/x86/include/asm/mach-generic/mach_apic.h
dissimilarity index 86%
index 48553e9..59972d9 100644
--- a/arch/x86/include/asm/mach-generic/mach_apic.h
+++ b/arch/x86/include/asm/mach-generic/mach_apic.h
@@ -1,35 +1,35 @@
-#ifndef _ASM_X86_MACH_GENERIC_MACH_APIC_H
-#define _ASM_X86_MACH_GENERIC_MACH_APIC_H
-
-#include <asm/genapic.h>
-
-#define esr_disable (genapic->ESR_DISABLE)
-#define NO_BALANCE_IRQ (genapic->no_balance_irq)
-#define INT_DELIVERY_MODE (genapic->int_delivery_mode)
-#define INT_DEST_MODE (genapic->int_dest_mode)
-#undef APIC_DEST_LOGICAL
-#define APIC_DEST_LOGICAL (genapic->apic_destination_logical)
-#define TARGET_CPUS	  (genapic->target_cpus())
-#define apic_id_registered (genapic->apic_id_registered)
-#define init_apic_ldr (genapic->init_apic_ldr)
-#define ioapic_phys_id_map (genapic->ioapic_phys_id_map)
-#define setup_apic_routing (genapic->setup_apic_routing)
-#define multi_timer_check (genapic->multi_timer_check)
-#define apicid_to_node (genapic->apicid_to_node)
-#define cpu_to_logical_apicid (genapic->cpu_to_logical_apicid) 
-#define cpu_present_to_apicid (genapic->cpu_present_to_apicid)
-#define apicid_to_cpu_present (genapic->apicid_to_cpu_present)
-#define setup_portio_remap (genapic->setup_portio_remap)
-#define check_apicid_present (genapic->check_apicid_present)
-#define check_phys_apicid_present (genapic->check_phys_apicid_present)
-#define check_apicid_used (genapic->check_apicid_used)
-#define cpu_mask_to_apicid (genapic->cpu_mask_to_apicid)
-#define cpu_mask_to_apicid_and (genapic->cpu_mask_to_apicid_and)
-#define vector_allocation_domain (genapic->vector_allocation_domain)
-#define enable_apic_mode (genapic->enable_apic_mode)
-#define phys_pkg_id (genapic->phys_pkg_id)
-#define wakeup_secondary_cpu (genapic->wakeup_cpu)
-
-extern void generic_bigsmp_probe(void);
-
-#endif /* _ASM_X86_MACH_GENERIC_MACH_APIC_H */
+#ifndef _ASM_X86_MACH_GENERIC_MACH_APIC_H
+#define _ASM_X86_MACH_GENERIC_MACH_APIC_H
+
+#include <asm/genapic.h>
+
+#define esr_disable (apic->ESR_DISABLE)
+#define NO_BALANCE_IRQ (apic->no_balance_irq)
+#define INT_DELIVERY_MODE (apic->int_delivery_mode)
+#define INT_DEST_MODE (apic->int_dest_mode)
+#undef APIC_DEST_LOGICAL
+#define APIC_DEST_LOGICAL (apic->apic_destination_logical)
+#define TARGET_CPUS	  (apic->target_cpus())
+#define apic_id_registered (apic->apic_id_registered)
+#define init_apic_ldr (apic->init_apic_ldr)
+#define ioapic_phys_id_map (apic->ioapic_phys_id_map)
+#define setup_apic_routing (apic->setup_apic_routing)
+#define multi_timer_check (apic->multi_timer_check)
+#define apicid_to_node (apic->apicid_to_node)
+#define cpu_to_logical_apicid (apic->cpu_to_logical_apicid) 
+#define cpu_present_to_apicid (apic->cpu_present_to_apicid)
+#define apicid_to_cpu_present (apic->apicid_to_cpu_present)
+#define setup_portio_remap (apic->setup_portio_remap)
+#define check_apicid_present (apic->check_apicid_present)
+#define check_phys_apicid_present (apic->check_phys_apicid_present)
+#define check_apicid_used (apic->check_apicid_used)
+#define cpu_mask_to_apicid (apic->cpu_mask_to_apicid)
+#define cpu_mask_to_apicid_and (apic->cpu_mask_to_apicid_and)
+#define vector_allocation_domain (apic->vector_allocation_domain)
+#define enable_apic_mode (apic->enable_apic_mode)
+#define phys_pkg_id (apic->phys_pkg_id)
+#define wakeup_secondary_cpu (apic->wakeup_cpu)
+
+extern void generic_bigsmp_probe(void);
+
+#endif /* _ASM_X86_MACH_GENERIC_MACH_APIC_H */
diff --git a/arch/x86/include/asm/mach-generic/mach_apicdef.h b/arch/x86/include/asm/mach-generic/mach_apicdef.h
index 68041f3..acc9add 100644
--- a/arch/x86/include/asm/mach-generic/mach_apicdef.h
+++ b/arch/x86/include/asm/mach-generic/mach_apicdef.h
@@ -4,8 +4,8 @@
 #ifndef APIC_DEFINITION
 #include <asm/genapic.h>
 
-#define GET_APIC_ID (genapic->get_apic_id)
-#define APIC_ID_MASK (genapic->apic_id_mask)
+#define GET_APIC_ID (apic->get_apic_id)
+#define APIC_ID_MASK (apic->apic_id_mask)
 #endif
 
 #endif /* _ASM_X86_MACH_GENERIC_MACH_APICDEF_H */
diff --git a/arch/x86/include/asm/mach-generic/mach_ipi.h b/arch/x86/include/asm/mach-generic/mach_ipi.h
index ffd637e..75e54bd 100644
--- a/arch/x86/include/asm/mach-generic/mach_ipi.h
+++ b/arch/x86/include/asm/mach-generic/mach_ipi.h
@@ -3,8 +3,8 @@
 
 #include <asm/genapic.h>
 
-#define send_IPI_mask (genapic->send_IPI_mask)
-#define send_IPI_allbutself (genapic->send_IPI_allbutself)
-#define send_IPI_all (genapic->send_IPI_all)
+#define send_IPI_mask (apic->send_IPI_mask)
+#define send_IPI_allbutself (apic->send_IPI_allbutself)
+#define send_IPI_all (apic->send_IPI_all)
 
 #endif /* _ASM_X86_MACH_GENERIC_MACH_IPI_H */
diff --git a/arch/x86/include/asm/mach-generic/mach_wakecpu.h b/arch/x86/include/asm/mach-generic/mach_wakecpu.h
dissimilarity index 75%
index 1ab16b1..22006bb 100644
--- a/arch/x86/include/asm/mach-generic/mach_wakecpu.h
+++ b/arch/x86/include/asm/mach-generic/mach_wakecpu.h
@@ -1,12 +1,12 @@
-#ifndef _ASM_X86_MACH_GENERIC_MACH_WAKECPU_H
-#define _ASM_X86_MACH_GENERIC_MACH_WAKECPU_H
-
-#define TRAMPOLINE_PHYS_LOW (genapic->trampoline_phys_low)
-#define TRAMPOLINE_PHYS_HIGH (genapic->trampoline_phys_high)
-#define wait_for_init_deassert (genapic->wait_for_init_deassert)
-#define smp_callin_clear_local_apic (genapic->smp_callin_clear_local_apic)
-#define store_NMI_vector (genapic->store_NMI_vector)
-#define restore_NMI_vector (genapic->restore_NMI_vector)
-#define inquire_remote_apic (genapic->inquire_remote_apic)
-
-#endif /* _ASM_X86_MACH_GENERIC_MACH_APIC_H */
+#ifndef _ASM_X86_MACH_GENERIC_MACH_WAKECPU_H
+#define _ASM_X86_MACH_GENERIC_MACH_WAKECPU_H
+
+#define TRAMPOLINE_PHYS_LOW (apic->trampoline_phys_low)
+#define TRAMPOLINE_PHYS_HIGH (apic->trampoline_phys_high)
+#define wait_for_init_deassert (apic->wait_for_init_deassert)
+#define smp_callin_clear_local_apic (apic->smp_callin_clear_local_apic)
+#define store_NMI_vector (apic->store_NMI_vector)
+#define restore_NMI_vector (apic->restore_NMI_vector)
+#define inquire_remote_apic (apic->inquire_remote_apic)
+
+#endif /* _ASM_X86_MACH_GENERIC_MACH_APIC_H */
diff --git a/arch/x86/kernel/es7000_32.c b/arch/x86/kernel/es7000_32.c
index 53699c9..20a2a43 100644
--- a/arch/x86/kernel/es7000_32.c
+++ b/arch/x86/kernel/es7000_32.c
@@ -188,14 +188,14 @@ static void noop_wait_for_deassert(atomic_t *deassert_not_used)
 
 static int __init es7000_update_genapic(void)
 {
-	genapic->wakeup_cpu = wakeup_secondary_cpu_via_mip;
+	apic->wakeup_cpu = wakeup_secondary_cpu_via_mip;
 
 	/* MPENTIUMIII */
 	if (boot_cpu_data.x86 == 6 &&
 	    (boot_cpu_data.x86_model >= 7 || boot_cpu_data.x86_model <= 11)) {
 		es7000_update_genapic_to_cluster();
-		genapic->wait_for_init_deassert = noop_wait_for_deassert;
-		genapic->wakeup_cpu = wakeup_secondary_cpu_via_mip;
+		apic->wait_for_init_deassert = noop_wait_for_deassert;
+		apic->wakeup_cpu = wakeup_secondary_cpu_via_mip;
 	}
 
 	return 0;
diff --git a/arch/x86/kernel/genapic_64.c b/arch/x86/kernel/genapic_64.c
index e656c27..2b98638 100644
--- a/arch/x86/kernel/genapic_64.c
+++ b/arch/x86/kernel/genapic_64.c
@@ -29,7 +29,7 @@ extern struct genapic apic_x2xpic_uv_x;
 extern struct genapic apic_x2apic_phys;
 extern struct genapic apic_x2apic_cluster;
 
-struct genapic __read_mostly *genapic = &apic_flat;
+struct genapic __read_mostly *apic = &apic_flat;
 
 static struct genapic *apic_probe[] __initdata = {
 #ifdef CONFIG_X86_UV
@@ -46,15 +46,15 @@ static struct genapic *apic_probe[] __initdata = {
  */
 void __init setup_apic_routing(void)
 {
-	if (genapic == &apic_x2apic_phys || genapic == &apic_x2apic_cluster) {
+	if (apic == &apic_x2apic_phys || apic == &apic_x2apic_cluster) {
 		if (!intr_remapping_enabled)
-			genapic = &apic_flat;
+			apic = &apic_flat;
 	}
 
-	if (genapic == &apic_flat) {
+	if (apic == &apic_flat) {
 		if (max_physical_apicid >= 8)
-			genapic = &apic_physflat;
-		printk(KERN_INFO "Setting APIC routing to %s\n", genapic->name);
+			apic = &apic_physflat;
+		printk(KERN_INFO "Setting APIC routing to %s\n", apic->name);
 	}
 
 	if (x86_quirks->update_genapic)
@@ -74,9 +74,9 @@ int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 
 	for (i = 0; apic_probe[i]; ++i) {
 		if (apic_probe[i]->acpi_madt_oem_check(oem_id, oem_table_id)) {
-			genapic = apic_probe[i];
+			apic = apic_probe[i];
 			printk(KERN_INFO "Setting APIC routing to %s.\n",
-				genapic->name);
+				apic->name);
 			return 1;
 		}
 	}
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index bfb7d73..7283234 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -1486,7 +1486,7 @@ static void ioapic_register_intr(int irq, struct irq_desc *desc, unsigned long t
 					      handle_edge_irq, "edge");
 }
 
-static int setup_ioapic_entry(int apic, int irq,
+static int setup_ioapic_entry(int apic_id, int irq,
 			      struct IO_APIC_route_entry *entry,
 			      unsigned int destination, int trigger,
 			      int polarity, int vector)
@@ -1498,18 +1498,18 @@ static int setup_ioapic_entry(int apic, int irq,
 
 #ifdef CONFIG_INTR_REMAP
 	if (intr_remapping_enabled) {
-		struct intel_iommu *iommu = map_ioapic_to_ir(apic);
+		struct intel_iommu *iommu = map_ioapic_to_ir(apic_id);
 		struct irte irte;
 		struct IR_IO_APIC_route_entry *ir_entry =
 			(struct IR_IO_APIC_route_entry *) entry;
 		int index;
 
 		if (!iommu)
-			panic("No mapping iommu for ioapic %d\n", apic);
+			panic("No mapping iommu for ioapic %d\n", apic_id);
 
 		index = alloc_irte(iommu, irq, 1);
 		if (index < 0)
-			panic("Failed to allocate IRTE for ioapic %d\n", apic);
+			panic("Failed to allocate IRTE for ioapic %d\n", apic_id);
 
 		memset(&irte, 0, sizeof(irte));
 
@@ -1547,7 +1547,7 @@ static int setup_ioapic_entry(int apic, int irq,
 	return 0;
 }
 
-static void setup_IO_APIC_irq(int apic, int pin, unsigned int irq, struct irq_desc *desc,
+static void setup_IO_APIC_irq(int apic_id, int pin, unsigned int irq, struct irq_desc *desc,
 			      int trigger, int polarity)
 {
 	struct irq_cfg *cfg;
@@ -1567,14 +1567,14 @@ static void setup_IO_APIC_irq(int apic, int pin, unsigned int irq, struct irq_de
 	apic_printk(APIC_VERBOSE,KERN_DEBUG
 		    "IOAPIC[%d]: Set routing entry (%d-%d -> 0x%x -> "
 		    "IRQ %d Mode:%i Active:%i)\n",
-		    apic, mp_ioapics[apic].apicid, pin, cfg->vector,
+		    apic_id, mp_ioapics[apic_id].apicid, pin, cfg->vector,
 		    irq, trigger, polarity);
 
 
-	if (setup_ioapic_entry(mp_ioapics[apic].apicid, irq, &entry,
+	if (setup_ioapic_entry(mp_ioapics[apic_id].apicid, irq, &entry,
 			       dest, trigger, polarity, cfg->vector)) {
 		printk("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
-		       mp_ioapics[apic].apicid, pin);
+		       mp_ioapics[apic_id].apicid, pin);
 		__clear_irq_vector(irq, cfg);
 		return;
 	}
@@ -1583,12 +1583,12 @@ static void setup_IO_APIC_irq(int apic, int pin, unsigned int irq, struct irq_de
 	if (irq < NR_IRQS_LEGACY)
 		disable_8259A_irq(irq);
 
-	ioapic_write_entry(apic, pin, entry);
+	ioapic_write_entry(apic_id, pin, entry);
 }
 
 static void __init setup_IO_APIC_irqs(void)
 {
-	int apic, pin, idx, irq;
+	int apic_id, pin, idx, irq;
 	int notcon = 0;
 	struct irq_desc *desc;
 	struct irq_cfg *cfg;
@@ -1596,19 +1596,19 @@ static void __init setup_IO_APIC_irqs(void)
 
 	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
 
-	for (apic = 0; apic < nr_ioapics; apic++) {
-		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
+	for (apic_id = 0; apic_id < nr_ioapics; apic_id++) {
+		for (pin = 0; pin < nr_ioapic_registers[apic_id]; pin++) {
 
-			idx = find_irq_entry(apic, pin, mp_INT);
+			idx = find_irq_entry(apic_id, pin, mp_INT);
 			if (idx == -1) {
 				if (!notcon) {
 					notcon = 1;
 					apic_printk(APIC_VERBOSE,
 						KERN_DEBUG " %d-%d",
-						mp_ioapics[apic].apicid, pin);
+						mp_ioapics[apic_id].apicid, pin);
 				} else
 					apic_printk(APIC_VERBOSE, " %d-%d",
-						mp_ioapics[apic].apicid, pin);
+						mp_ioapics[apic_id].apicid, pin);
 				continue;
 			}
 			if (notcon) {
@@ -1617,9 +1617,9 @@ static void __init setup_IO_APIC_irqs(void)
 				notcon = 0;
 			}
 
-			irq = pin_2_irq(idx, apic, pin);
+			irq = pin_2_irq(idx, apic_id, pin);
 #ifdef CONFIG_X86_32
-			if (multi_timer_check(apic, irq))
+			if (multi_timer_check(apic_id, irq))
 				continue;
 #endif
 			desc = irq_to_desc_alloc_cpu(irq, cpu);
@@ -1628,9 +1628,9 @@ static void __init setup_IO_APIC_irqs(void)
 				continue;
 			}
 			cfg = desc->chip_data;
-			add_pin_to_irq_cpu(cfg, cpu, apic, pin);
+			add_pin_to_irq_cpu(cfg, cpu, apic_id, pin);
 
-			setup_IO_APIC_irq(apic, pin, irq, desc,
+			setup_IO_APIC_irq(apic_id, pin, irq, desc,
 					irq_trigger(idx), irq_polarity(idx));
 		}
 	}
@@ -1643,7 +1643,7 @@ static void __init setup_IO_APIC_irqs(void)
 /*
  * Set up the timer pin, possibly with the 8259A-master behind.
  */
-static void __init setup_timer_IRQ0_pin(unsigned int apic, unsigned int pin,
+static void __init setup_timer_IRQ0_pin(unsigned int apic_id, unsigned int pin,
 					int vector)
 {
 	struct IO_APIC_route_entry entry;
@@ -1676,7 +1676,7 @@ static void __init setup_timer_IRQ0_pin(unsigned int apic, unsigned int pin,
 	/*
 	 * Add it to the IO-APIC irq-routing table:
 	 */
-	ioapic_write_entry(apic, pin, entry);
+	ioapic_write_entry(apic_id, pin, entry);
 }
 
 
@@ -2089,7 +2089,7 @@ static void __init setup_ioapic_ids_from_mpc(void)
 {
 	union IO_APIC_reg_00 reg_00;
 	physid_mask_t phys_id_present_map;
-	int apic;
+	int apic_id;
 	int i;
 	unsigned char old_id;
 	unsigned long flags;
@@ -2113,21 +2113,21 @@ static void __init setup_ioapic_ids_from_mpc(void)
 	/*
 	 * Set the IOAPIC ID to the value stored in the MPC table.
 	 */
-	for (apic = 0; apic < nr_ioapics; apic++) {
+	for (apic_id = 0; apic_id < nr_ioapics; apic_id++) {
 
 		/* Read the register 0 value */
 		spin_lock_irqsave(&ioapic_lock, flags);
-		reg_00.raw = io_apic_read(apic, 0);
+		reg_00.raw = io_apic_read(apic_id, 0);
 		spin_unlock_irqrestore(&ioapic_lock, flags);
 
-		old_id = mp_ioapics[apic].apicid;
+		old_id = mp_ioapics[apic_id].apicid;
 
-		if (mp_ioapics[apic].apicid >= get_physical_broadcast()) {
+		if (mp_ioapics[apic_id].apicid >= get_physical_broadcast()) {
 			printk(KERN_ERR "BIOS bug, IO-APIC#%d ID is %d in the MPC table!...\n",
-				apic, mp_ioapics[apic].apicid);
+				apic_id, mp_ioapics[apic_id].apicid);
 			printk(KERN_ERR "... fixing up to %d. (tell your hw vendor)\n",
 				reg_00.bits.ID);
-			mp_ioapics[apic].apicid = reg_00.bits.ID;
+			mp_ioapics[apic_id].apicid = reg_00.bits.ID;
 		}
 
 		/*
@@ -2136,9 +2136,9 @@ static void __init setup_ioapic_ids_from_mpc(void)
 		 * 'stuck on smp_invalidate_needed IPI wait' messages.
 		 */
 		if (check_apicid_used(phys_id_present_map,
-					mp_ioapics[apic].apicid)) {
+					mp_ioapics[apic_id].apicid)) {
 			printk(KERN_ERR "BIOS bug, IO-APIC#%d ID %d is already used!...\n",
-				apic, mp_ioapics[apic].apicid);
+				apic_id, mp_ioapics[apic_id].apicid);
 			for (i = 0; i < get_physical_broadcast(); i++)
 				if (!physid_isset(i, phys_id_present_map))
 					break;
@@ -2147,13 +2147,13 @@ static void __init setup_ioapic_ids_from_mpc(void)
 			printk(KERN_ERR "... fixing up to %d. (tell your hw vendor)\n",
 				i);
 			physid_set(i, phys_id_present_map);
-			mp_ioapics[apic].apicid = i;
+			mp_ioapics[apic_id].apicid = i;
 		} else {
 			physid_mask_t tmp;
-			tmp = apicid_to_cpu_present(mp_ioapics[apic].apicid);
+			tmp = apicid_to_cpu_present(mp_ioapics[apic_id].apicid);
 			apic_printk(APIC_VERBOSE, "Setting %d in the "
 					"phys_id_present_map\n",
-					mp_ioapics[apic].apicid);
+					mp_ioapics[apic_id].apicid);
 			physids_or(phys_id_present_map, phys_id_present_map, tmp);
 		}
 
@@ -2162,11 +2162,11 @@ static void __init setup_ioapic_ids_from_mpc(void)
 		 * We need to adjust the IRQ routing table
 		 * if the ID changed.
 		 */
-		if (old_id != mp_ioapics[apic].apicid)
+		if (old_id != mp_ioapics[apic_id].apicid)
 			for (i = 0; i < mp_irq_entries; i++)
 				if (mp_irqs[i].dstapic == old_id)
 					mp_irqs[i].dstapic
-						= mp_ioapics[apic].apicid;
+						= mp_ioapics[apic_id].apicid;
 
 		/*
 		 * Read the right value from the MPC table and
@@ -2174,20 +2174,20 @@ static void __init setup_ioapic_ids_from_mpc(void)
 		 */
 		apic_printk(APIC_VERBOSE, KERN_INFO
 			"...changing IO-APIC physical APIC ID to %d ...",
-			mp_ioapics[apic].apicid);
+			mp_ioapics[apic_id].apicid);
 
-		reg_00.bits.ID = mp_ioapics[apic].apicid;
+		reg_00.bits.ID = mp_ioapics[apic_id].apicid;
 		spin_lock_irqsave(&ioapic_lock, flags);
-		io_apic_write(apic, 0, reg_00.raw);
+		io_apic_write(apic_id, 0, reg_00.raw);
 		spin_unlock_irqrestore(&ioapic_lock, flags);
 
 		/*
 		 * Sanity check
 		 */
 		spin_lock_irqsave(&ioapic_lock, flags);
-		reg_00.raw = io_apic_read(apic, 0);
+		reg_00.raw = io_apic_read(apic_id, 0);
 		spin_unlock_irqrestore(&ioapic_lock, flags);
-		if (reg_00.bits.ID != mp_ioapics[apic].apicid)
+		if (reg_00.bits.ID != mp_ioapics[apic_id].apicid)
 			printk("could not set ID!\n");
 		else
 			apic_printk(APIC_VERBOSE, " ok.\n");
diff --git a/arch/x86/kernel/numaq_32.c b/arch/x86/kernel/numaq_32.c
index f2191d4..3928280 100644
--- a/arch/x86/kernel/numaq_32.c
+++ b/arch/x86/kernel/numaq_32.c
@@ -236,7 +236,7 @@ static int __init numaq_setup_ioapic_ids(void)
 
 static int __init numaq_update_genapic(void)
 {
-	genapic->wakeup_cpu = wakeup_secondary_cpu_via_nmi;
+	apic->wakeup_cpu = wakeup_secondary_cpu_via_nmi;
 
 	return 0;
 }
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f41c448..a58e9f5 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -590,7 +590,7 @@ static int __init default_update_genapic(void)
 {
 #ifdef CONFIG_X86_SMP
 # if defined(CONFIG_X86_GENERICARCH) || defined(CONFIG_X86_64)
-	genapic->wakeup_cpu = wakeup_secondary_cpu_via_init;
+	apic->wakeup_cpu = wakeup_secondary_cpu_via_init;
 # endif
 #endif
 
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index c2ded14..2f4f4a6 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -20,14 +20,14 @@
 
 void __init es7000_update_genapic_to_cluster(void)
 {
-	genapic->target_cpus = target_cpus_cluster;
-	genapic->int_delivery_mode = INT_DELIVERY_MODE_CLUSTER;
-	genapic->int_dest_mode = INT_DEST_MODE_CLUSTER;
-	genapic->no_balance_irq = NO_BALANCE_IRQ_CLUSTER;
+	apic->target_cpus = target_cpus_cluster;
+	apic->int_delivery_mode = INT_DELIVERY_MODE_CLUSTER;
+	apic->int_dest_mode = INT_DEST_MODE_CLUSTER;
+	apic->no_balance_irq = NO_BALANCE_IRQ_CLUSTER;
 
-	genapic->init_apic_ldr = init_apic_ldr_cluster;
+	apic->init_apic_ldr = init_apic_ldr_cluster;
 
-	genapic->cpu_mask_to_apicid = cpu_mask_to_apicid_cluster;
+	apic->cpu_mask_to_apicid = cpu_mask_to_apicid_cluster;
 }
 
 static int probe_es7000(void)
diff --git a/arch/x86/mach-generic/probe.c b/arch/x86/mach-generic/probe.c
index 15a38da..82bf0f5 100644
--- a/arch/x86/mach-generic/probe.c
+++ b/arch/x86/mach-generic/probe.c
@@ -23,7 +23,7 @@ extern struct genapic apic_bigsmp;
 extern struct genapic apic_es7000;
 extern struct genapic apic_default;
 
-struct genapic *genapic = &apic_default;
+struct genapic *apic = &apic_default;
 
 static struct genapic *apic_probe[] __initdata = {
 #ifdef CONFIG_X86_NUMAQ
@@ -52,7 +52,7 @@ static int __init parse_apic(char *arg)
 
 	for (i = 0; apic_probe[i]; i++) {
 		if (!strcmp(apic_probe[i]->name, arg)) {
-			genapic = apic_probe[i];
+			apic = apic_probe[i];
 			cmdline_apic = 1;
 			return 0;
 		}
@@ -76,13 +76,13 @@ void __init generic_bigsmp_probe(void)
 	 * - we find more than 8 CPUs in acpi LAPIC listing with xAPIC support
 	 */
 
-	if (!cmdline_apic && genapic == &apic_default) {
+	if (!cmdline_apic && apic == &apic_default) {
 		if (apic_bigsmp.probe()) {
-			genapic = &apic_bigsmp;
+			apic = &apic_bigsmp;
 			if (x86_quirks->update_genapic)
 				x86_quirks->update_genapic();
 			printk(KERN_INFO "Overriding APIC driver with %s\n",
-			       genapic->name);
+			       apic->name);
 		}
 	}
 #endif
@@ -94,7 +94,7 @@ void __init generic_apic_probe(void)
 		int i;
 		for (i = 0; apic_probe[i]; i++) {
 			if (apic_probe[i]->probe()) {
-				genapic = apic_probe[i];
+				apic = apic_probe[i];
 				break;
 			}
 		}
@@ -105,7 +105,7 @@ void __init generic_apic_probe(void)
 		if (x86_quirks->update_genapic)
 			x86_quirks->update_genapic();
 	}
-	printk(KERN_INFO "Using APIC driver %s\n", genapic->name);
+	printk(KERN_INFO "Using APIC driver %s\n", apic->name);
 }
 
 /* These functions can switch the APIC even after the initial ->probe() */
@@ -116,11 +116,11 @@ int __init mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
 	for (i = 0; apic_probe[i]; ++i) {
 		if (apic_probe[i]->mps_oem_check(mpc, oem, productid)) {
 			if (!cmdline_apic) {
-				genapic = apic_probe[i];
+				apic = apic_probe[i];
 				if (x86_quirks->update_genapic)
 					x86_quirks->update_genapic();
 				printk(KERN_INFO "Switched to APIC driver `%s'.\n",
-				       genapic->name);
+				       apic->name);
 			}
 			return 1;
 		}
@@ -134,11 +134,11 @@ int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 	for (i = 0; apic_probe[i]; ++i) {
 		if (apic_probe[i]->acpi_madt_oem_check(oem_id, oem_table_id)) {
 			if (!cmdline_apic) {
-				genapic = apic_probe[i];
+				apic = apic_probe[i];
 				if (x86_quirks->update_genapic)
 					x86_quirks->update_genapic();
 				printk(KERN_INFO "Switched to APIC driver `%s'.\n",
-				       genapic->name);
+				       apic->name);
 			}
 			return 1;
 		}
@@ -148,5 +148,5 @@ int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 
 int hard_smp_processor_id(void)
 {
-	return genapic->get_apic_id(*(unsigned long *)(APIC_BASE+APIC_ID));
+	return apic->get_apic_id(*(unsigned long *)(APIC_BASE+APIC_ID));
 }
-- 
1.6.0.2

