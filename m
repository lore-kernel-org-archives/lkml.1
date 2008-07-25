Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbYGYJUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbYGYJUH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 05:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520AbYGYJSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 05:18:51 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:13081 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbYGYJSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 05:18:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=v2nrw62lKAXA7n7sWvQyLmeDPOJdvLc6wykSNASHwXLeggka/JOQe3DQ2KoDuURvKs
         hNKQlXJkkQ4b/mscWs0xa9rIUaujZP+4PU4nhSLwGvdrwGpbptvu6bnP/1LiTUMqj0Pz
         GL1o8wEp9bgxtsvbQFGs6N3pDnq6tROr60ePA=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: mach-numaq to numaq
Date: Fri, 25 Jul 2008 02:17:55 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200807250214.28786.yhlu.kernel@gmail.com>
In-Reply-To: <200807250214.28786.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807250217.55408.yhlu.kernel@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/mach-generic/numaq.c             |   10 +-
 include/asm-x86/mach-numaq/mach_apic.h    |  138 ------------------------------
 include/asm-x86/mach-numaq/mach_apicdef.h |   14 ---
 include/asm-x86/mach-numaq/mach_ipi.h     |   25 -----
 include/asm-x86/mach-numaq/mach_mpparse.h |    7 -
 include/asm-x86/mach-numaq/mach_wakecpu.h |   43 ---------
 include/asm-x86/numaq/apic.h              |  138 ++++++++++++++++++++++++++++++
 include/asm-x86/numaq/apicdef.h           |   14 +++
 include/asm-x86/numaq/ipi.h               |   25 +++++
 include/asm-x86/numaq/mpparse.h           |    7 +
 include/asm-x86/numaq/wakecpu.h           |   43 +++++++++
 11 files changed, 232 insertions(+), 232 deletions(-)

Index: linux-2.6/arch/x86/mach-generic/numaq.c
===================================================================
--- linux-2.6.orig/arch/x86/mach-generic/numaq.c
+++ linux-2.6/arch/x86/mach-generic/numaq.c
@@ -11,12 +11,12 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/init.h>
-#include <asm/mach-numaq/mach_apicdef.h>
+#include <asm/numaq/apicdef.h>
 #include <linux/smp.h>
-#include <asm/mach-numaq/mach_apic.h>
-#include <asm/mach-numaq/mach_ipi.h>
-#include <asm/mach-numaq/mach_mpparse.h>
-#include <asm/mach-numaq/mach_wakecpu.h>
+#include <asm/numaq/apic.h>
+#include <asm/numaq/ipi.h>
+#include <asm/numaq/mpparse.h>
+#include <asm/numaq/wakecpu.h>
 #include <asm/numaq.h>
 
 static int mps_oem_check(struct mp_config_table *mpc, char *oem,
Index: linux-2.6/include/asm-x86/mach-numaq/mach_apic.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mach-numaq/mach_apic.h
+++ /dev/null
@@ -1,138 +0,0 @@
-#ifndef __ASM_MACH_APIC_H
-#define __ASM_MACH_APIC_H
-
-#include <asm/io.h>
-#include <linux/mmzone.h>
-#include <linux/nodemask.h>
-
-#define APIC_DFR_VALUE	(APIC_DFR_CLUSTER)
-
-static inline cpumask_t target_cpus(void)
-{
-	return CPU_MASK_ALL;
-}
-
-#define TARGET_CPUS (target_cpus())
-
-#define NO_BALANCE_IRQ (1)
-#define esr_disable (1)
-
-#define INT_DELIVERY_MODE dest_LowestPrio
-#define INT_DEST_MODE 0     /* physical delivery on LOCAL quad */
- 
-static inline unsigned long check_apicid_used(physid_mask_t bitmap, int apicid)
-{
-	return physid_isset(apicid, bitmap);
-}
-static inline unsigned long check_apicid_present(int bit)
-{
-	return physid_isset(bit, phys_cpu_present_map);
-}
-#define apicid_cluster(apicid) (apicid & 0xF0)
-
-static inline int apic_id_registered(void)
-{
-	return 1;
-}
-
-static inline void init_apic_ldr(void)
-{
-	/* Already done in NUMA-Q firmware */
-}
-
-static inline void setup_apic_routing(void)
-{
-	printk("Enabling APIC mode:  %s.  Using %d I/O APICs\n",
-		"NUMA-Q", nr_ioapics);
-}
-
-/*
- * Skip adding the timer int on secondary nodes, which causes
- * a small but painful rift in the time-space continuum.
- */
-static inline int multi_timer_check(int apic, int irq)
-{
-	return apic != 0 && irq == 0;
-}
-
-static inline physid_mask_t ioapic_phys_id_map(physid_mask_t phys_map)
-{
-	/* We don't have a good way to do this yet - hack */
-	return physids_promote(0xFUL);
-}
-
-/* Mapping from cpu number to logical apicid */
-extern u8 cpu_2_logical_apicid[];
-static inline int cpu_to_logical_apicid(int cpu)
-{
-       if (cpu >= NR_CPUS)
-	       return BAD_APICID;
-	return (int)cpu_2_logical_apicid[cpu];
-}
-
-/*
- * Supporting over 60 cpus on NUMA-Q requires a locality-dependent
- * cpu to APIC ID relation to properly interact with the intelligent
- * mode of the cluster controller.
- */
-static inline int cpu_present_to_apicid(int mps_cpu)
-{
-	if (mps_cpu < 60)
-		return ((mps_cpu >> 2) << 4) | (1 << (mps_cpu & 0x3));
-	else
-		return BAD_APICID;
-}
-
-static inline int apicid_to_node(int logical_apicid) 
-{
-	return logical_apicid >> 4;
-}
-
-static inline physid_mask_t apicid_to_cpu_present(int logical_apicid)
-{
-	int node = apicid_to_node(logical_apicid);
-	int cpu = __ffs(logical_apicid & 0xf);
-
-	return physid_mask_of_physid(cpu + 4*node);
-}
-
-extern void *xquad_portio;
-
-static inline void setup_portio_remap(void)
-{
-	int num_quads = num_online_nodes();
-
-	if (num_quads <= 1)
-       		return;
-
-	printk("Remapping cross-quad port I/O for %d quads\n", num_quads);
-	xquad_portio = ioremap(XQUAD_PORTIO_BASE, num_quads*XQUAD_PORTIO_QUAD);
-	printk("xquad_portio vaddr 0x%08lx, len %08lx\n",
-		(u_long) xquad_portio, (u_long) num_quads*XQUAD_PORTIO_QUAD);
-}
-
-static inline int check_phys_apicid_present(int boot_cpu_physical_apicid)
-{
-	return (1);
-}
-
-static inline void enable_apic_mode(void)
-{
-}
-
-/*
- * We use physical apicids here, not logical, so just return the default
- * physical broadcast to stop people from breaking us
- */
-static inline unsigned int cpu_mask_to_apicid(cpumask_t cpumask)
-{
-	return (int) 0xF;
-}
-
-/* No NUMA-Q box has a HT CPU, but it can't hurt to use the default code. */
-static inline u32 phys_pkg_id(u32 cpuid_apic, int index_msb)
-{
-	return cpuid_apic >> index_msb;
-}
-
-#endif /* __ASM_MACH_APIC_H */
Index: linux-2.6/include/asm-x86/mach-numaq/mach_apicdef.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mach-numaq/mach_apicdef.h
+++ /dev/null
@@ -1,14 +0,0 @@
-#ifndef __ASM_MACH_APICDEF_H
-#define __ASM_MACH_APICDEF_H
-
-
-#define APIC_ID_MASK (0xF<<24)
-
-static inline unsigned get_apic_id(unsigned long x)
-{
-	        return (((x)>>24)&0x0F);
-}
-
-#define         GET_APIC_ID(x)  get_apic_id(x)
-
-#endif
Index: linux-2.6/include/asm-x86/mach-numaq/mach_ipi.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mach-numaq/mach_ipi.h
+++ /dev/null
@@ -1,25 +0,0 @@
-#ifndef __ASM_MACH_IPI_H
-#define __ASM_MACH_IPI_H
-
-void send_IPI_mask_sequence(cpumask_t, int vector);
-
-static inline void send_IPI_mask(cpumask_t mask, int vector)
-{
-	send_IPI_mask_sequence(mask, vector);
-}
-
-static inline void send_IPI_allbutself(int vector)
-{
-	cpumask_t mask = cpu_online_map;
-	cpu_clear(smp_processor_id(), mask);
-
-	if (!cpus_empty(mask))
-		send_IPI_mask(mask, vector);
-}
-
-static inline void send_IPI_all(int vector)
-{
-	send_IPI_mask(cpu_online_map, vector);
-}
-
-#endif /* __ASM_MACH_IPI_H */
Index: linux-2.6/include/asm-x86/mach-numaq/mach_mpparse.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mach-numaq/mach_mpparse.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef __ASM_MACH_MPPARSE_H
-#define __ASM_MACH_MPPARSE_H
-
-extern void numaq_mps_oem_check(struct mp_config_table *mpc, char *oem,
-				char *productid);
-
-#endif /* __ASM_MACH_MPPARSE_H */
Index: linux-2.6/include/asm-x86/mach-numaq/mach_wakecpu.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mach-numaq/mach_wakecpu.h
+++ /dev/null
@@ -1,43 +0,0 @@
-#ifndef __ASM_MACH_WAKECPU_H
-#define __ASM_MACH_WAKECPU_H
-
-/* This file copes with machines that wakeup secondary CPUs by NMIs */
-
-#define WAKE_SECONDARY_VIA_NMI
-
-#define TRAMPOLINE_LOW phys_to_virt(0x8)
-#define TRAMPOLINE_HIGH phys_to_virt(0xa)
-
-#define boot_cpu_apicid boot_cpu_logical_apicid
-
-/* We don't do anything here because we use NMI's to boot instead */
-static inline void wait_for_init_deassert(atomic_t *deassert)
-{
-}
-
-/*
- * Because we use NMIs rather than the INIT-STARTUP sequence to
- * bootstrap the CPUs, the APIC may be in a weird state. Kick it.
- */
-static inline void smp_callin_clear_local_apic(void)
-{
-	clear_local_APIC();
-}
-
-static inline void store_NMI_vector(unsigned short *high, unsigned short *low)
-{
-	printk("Storing NMI vector\n");
-	*high = *((volatile unsigned short *) TRAMPOLINE_HIGH);
-	*low = *((volatile unsigned short *) TRAMPOLINE_LOW);
-}
-
-static inline void restore_NMI_vector(unsigned short *high, unsigned short *low)
-{
-	printk("Restoring NMI vector\n");
-	*((volatile unsigned short *) TRAMPOLINE_HIGH) = *high;
-	*((volatile unsigned short *) TRAMPOLINE_LOW) = *low;
-}
-
-#define inquire_remote_apic(apicid) {}
-
-#endif /* __ASM_MACH_WAKECPU_H */
Index: linux-2.6/include/asm-x86/numaq/apic.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-x86/numaq/apic.h
@@ -0,0 +1,138 @@
+#ifndef __ASM_NUMAQ_APIC_H
+#define __ASM_NUMAQ_APIC_H
+
+#include <asm/io.h>
+#include <linux/mmzone.h>
+#include <linux/nodemask.h>
+
+#define APIC_DFR_VALUE	(APIC_DFR_CLUSTER)
+
+static inline cpumask_t target_cpus(void)
+{
+	return CPU_MASK_ALL;
+}
+
+#define TARGET_CPUS (target_cpus())
+
+#define NO_BALANCE_IRQ (1)
+#define esr_disable (1)
+
+#define INT_DELIVERY_MODE dest_LowestPrio
+#define INT_DEST_MODE 0     /* physical delivery on LOCAL quad */
+ 
+static inline unsigned long check_apicid_used(physid_mask_t bitmap, int apicid)
+{
+	return physid_isset(apicid, bitmap);
+}
+static inline unsigned long check_apicid_present(int bit)
+{
+	return physid_isset(bit, phys_cpu_present_map);
+}
+#define apicid_cluster(apicid) (apicid & 0xF0)
+
+static inline int apic_id_registered(void)
+{
+	return 1;
+}
+
+static inline void init_apic_ldr(void)
+{
+	/* Already done in NUMA-Q firmware */
+}
+
+static inline void setup_apic_routing(void)
+{
+	printk("Enabling APIC mode:  %s.  Using %d I/O APICs\n",
+		"NUMA-Q", nr_ioapics);
+}
+
+/*
+ * Skip adding the timer int on secondary nodes, which causes
+ * a small but painful rift in the time-space continuum.
+ */
+static inline int multi_timer_check(int apic, int irq)
+{
+	return apic != 0 && irq == 0;
+}
+
+static inline physid_mask_t ioapic_phys_id_map(physid_mask_t phys_map)
+{
+	/* We don't have a good way to do this yet - hack */
+	return physids_promote(0xFUL);
+}
+
+/* Mapping from cpu number to logical apicid */
+extern u8 cpu_2_logical_apicid[];
+static inline int cpu_to_logical_apicid(int cpu)
+{
+       if (cpu >= NR_CPUS)
+	       return BAD_APICID;
+	return (int)cpu_2_logical_apicid[cpu];
+}
+
+/*
+ * Supporting over 60 cpus on NUMA-Q requires a locality-dependent
+ * cpu to APIC ID relation to properly interact with the intelligent
+ * mode of the cluster controller.
+ */
+static inline int cpu_present_to_apicid(int mps_cpu)
+{
+	if (mps_cpu < 60)
+		return ((mps_cpu >> 2) << 4) | (1 << (mps_cpu & 0x3));
+	else
+		return BAD_APICID;
+}
+
+static inline int apicid_to_node(int logical_apicid) 
+{
+	return logical_apicid >> 4;
+}
+
+static inline physid_mask_t apicid_to_cpu_present(int logical_apicid)
+{
+	int node = apicid_to_node(logical_apicid);
+	int cpu = __ffs(logical_apicid & 0xf);
+
+	return physid_mask_of_physid(cpu + 4*node);
+}
+
+extern void *xquad_portio;
+
+static inline void setup_portio_remap(void)
+{
+	int num_quads = num_online_nodes();
+
+	if (num_quads <= 1)
+       		return;
+
+	printk("Remapping cross-quad port I/O for %d quads\n", num_quads);
+	xquad_portio = ioremap(XQUAD_PORTIO_BASE, num_quads*XQUAD_PORTIO_QUAD);
+	printk("xquad_portio vaddr 0x%08lx, len %08lx\n",
+		(u_long) xquad_portio, (u_long) num_quads*XQUAD_PORTIO_QUAD);
+}
+
+static inline int check_phys_apicid_present(int boot_cpu_physical_apicid)
+{
+	return (1);
+}
+
+static inline void enable_apic_mode(void)
+{
+}
+
+/*
+ * We use physical apicids here, not logical, so just return the default
+ * physical broadcast to stop people from breaking us
+ */
+static inline unsigned int cpu_mask_to_apicid(cpumask_t cpumask)
+{
+	return (int) 0xF;
+}
+
+/* No NUMA-Q box has a HT CPU, but it can't hurt to use the default code. */
+static inline u32 phys_pkg_id(u32 cpuid_apic, int index_msb)
+{
+	return cpuid_apic >> index_msb;
+}
+
+#endif /* __ASM_NUMAQ_APIC_H */
Index: linux-2.6/include/asm-x86/numaq/apicdef.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-x86/numaq/apicdef.h
@@ -0,0 +1,14 @@
+#ifndef __ASM_NUMAQ_APICDEF_H
+#define __ASM_NUMAQ_APICDEF_H
+
+
+#define APIC_ID_MASK (0xF<<24)
+
+static inline unsigned get_apic_id(unsigned long x)
+{
+	        return (((x)>>24)&0x0F);
+}
+
+#define         GET_APIC_ID(x)  get_apic_id(x)
+
+#endif
Index: linux-2.6/include/asm-x86/numaq/ipi.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-x86/numaq/ipi.h
@@ -0,0 +1,25 @@
+#ifndef __ASM_NUMAQ_IPI_H
+#define __ASM_NUMAQ_IPI_H
+
+void send_IPI_mask_sequence(cpumask_t, int vector);
+
+static inline void send_IPI_mask(cpumask_t mask, int vector)
+{
+	send_IPI_mask_sequence(mask, vector);
+}
+
+static inline void send_IPI_allbutself(int vector)
+{
+	cpumask_t mask = cpu_online_map;
+	cpu_clear(smp_processor_id(), mask);
+
+	if (!cpus_empty(mask))
+		send_IPI_mask(mask, vector);
+}
+
+static inline void send_IPI_all(int vector)
+{
+	send_IPI_mask(cpu_online_map, vector);
+}
+
+#endif /* __ASM_NUMAQ_IPI_H */
Index: linux-2.6/include/asm-x86/numaq/mpparse.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-x86/numaq/mpparse.h
@@ -0,0 +1,7 @@
+#ifndef __ASM_NUMAQ_MPPARSE_H
+#define __ASM_NUMAQ_MPPARSE_H
+
+extern void numaq_mps_oem_check(struct mp_config_table *mpc, char *oem,
+				char *productid);
+
+#endif /* __ASM_NUMAQ_MPPARSE_H */
Index: linux-2.6/include/asm-x86/numaq/wakecpu.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-x86/numaq/wakecpu.h
@@ -0,0 +1,43 @@
+#ifndef __ASM_NUMAQ_WAKECPU_H
+#define __ASM_NUMAQ_WAKECPU_H
+
+/* This file copes with machines that wakeup secondary CPUs by NMIs */
+
+#define WAKE_SECONDARY_VIA_NMI
+
+#define TRAMPOLINE_LOW phys_to_virt(0x8)
+#define TRAMPOLINE_HIGH phys_to_virt(0xa)
+
+#define boot_cpu_apicid boot_cpu_logical_apicid
+
+/* We don't do anything here because we use NMI's to boot instead */
+static inline void wait_for_init_deassert(atomic_t *deassert)
+{
+}
+
+/*
+ * Because we use NMIs rather than the INIT-STARTUP sequence to
+ * bootstrap the CPUs, the APIC may be in a weird state. Kick it.
+ */
+static inline void smp_callin_clear_local_apic(void)
+{
+	clear_local_APIC();
+}
+
+static inline void store_NMI_vector(unsigned short *high, unsigned short *low)
+{
+	printk("Storing NMI vector\n");
+	*high = *((volatile unsigned short *) TRAMPOLINE_HIGH);
+	*low = *((volatile unsigned short *) TRAMPOLINE_LOW);
+}
+
+static inline void restore_NMI_vector(unsigned short *high, unsigned short *low)
+{
+	printk("Restoring NMI vector\n");
+	*((volatile unsigned short *) TRAMPOLINE_HIGH) = *high;
+	*((volatile unsigned short *) TRAMPOLINE_LOW) = *low;
+}
+
+#define inquire_remote_apic(apicid) {}
+
+#endif /* __ASM_NUMAQ_WAKECPU_H */
