Return-Path: <linux-kernel-owner+w=401wt.eu-S1755678AbYGYJTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678AbYGYJTq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 05:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754361AbYGYJSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 05:18:50 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:13083 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546AbYGYJSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 05:18:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=Hg/JwCSsCrn8MovnmxN49acNdFMSJrJYMBJfNNseFN9P1Ip+9sNcvJpKEf9841XyZw
         GDon79TAlFFsHlSXGFbckWZ5gppdrjDMNttW2NkZU52+0BYRk91x5SA7D+qoLs68rhWF
         U1cC7CInOXaOEdPs2eGeLcKBu1S3nm5aNmhd0=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: mach_summit to summit
Date: Fri, 25 Jul 2008 02:17:44 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200807250214.28786.yhlu.kernel@gmail.com> <200807250215.15588.yhlu.kernel@gmail.com>
In-Reply-To: <200807250215.15588.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807250217.44246.yhlu.kernel@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/summit_32.c                      |    2 
 arch/x86/mach-generic/summit.c                   |    8 
 include/asm-x86/mach-summit/irq_vectors_limits.h |   14 -
 include/asm-x86/mach-summit/mach_apic.h          |  185 -----------------------
 include/asm-x86/mach-summit/mach_apicdef.h       |   13 -
 include/asm-x86/mach-summit/mach_ipi.h           |   25 ---
 include/asm-x86/mach-summit/mach_mpparse.h       |  110 -------------
 include/asm-x86/summit/apic.h                    |  185 +++++++++++++++++++++++
 include/asm-x86/summit/apicdef.h                 |   13 +
 include/asm-x86/summit/ipi.h                     |   25 +++
 include/asm-x86/summit/irq_vectors_limits.h      |   14 +
 include/asm-x86/summit/mpparse.h                 |  109 +++++++++++++
 12 files changed, 351 insertions(+), 352 deletions(-)

Index: linux-2.6/arch/x86/kernel/summit_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/summit_32.c
+++ linux-2.6/arch/x86/kernel/summit_32.c
@@ -30,7 +30,7 @@
 #include <linux/init.h>
 #include <asm/io.h>
 #include <asm/bios_ebda.h>
-#include <asm/mach-summit/mach_mpparse.h>
+#include <asm/summit/mpparse.h>
 
 static struct rio_table_hdr *rio_table_hdr __initdata;
 static struct scal_detail   *scal_devs[MAX_NUMNODES] __initdata;
Index: linux-2.6/arch/x86/mach-generic/summit.c
===================================================================
--- linux-2.6.orig/arch/x86/mach-generic/summit.c
+++ linux-2.6/arch/x86/mach-generic/summit.c
@@ -11,11 +11,11 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/init.h>
-#include <asm/mach-summit/mach_apicdef.h>
+#include <asm/summit/apicdef.h>
 #include <linux/smp.h>
-#include <asm/mach-summit/mach_apic.h>
-#include <asm/mach-summit/mach_ipi.h>
-#include <asm/mach-summit/mach_mpparse.h>
+#include <asm/summit/apic.h>
+#include <asm/summit/ipi.h>
+#include <asm/summit/mpparse.h>
 
 static int probe_summit(void)
 {
Index: linux-2.6/include/asm-x86/mach-summit/irq_vectors_limits.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mach-summit/irq_vectors_limits.h
+++ /dev/null
@@ -1,14 +0,0 @@
-#ifndef _ASM_IRQ_VECTORS_LIMITS_H
-#define _ASM_IRQ_VECTORS_LIMITS_H
-
-/*
- * For Summit or generic (i.e. installer) kernels, we have lots of I/O APICs,
- * even with uni-proc kernels, so use a big array.
- *
- * This value should be the same in both the generic and summit subarches.
- * Change one, change 'em both.
- */
-#define NR_IRQS	224
-#define NR_IRQ_VECTORS	1024
-
-#endif /* _ASM_IRQ_VECTORS_LIMITS_H */
Index: linux-2.6/include/asm-x86/mach-summit/mach_apic.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mach-summit/mach_apic.h
+++ /dev/null
@@ -1,185 +0,0 @@
-#ifndef __ASM_MACH_APIC_H
-#define __ASM_MACH_APIC_H
-
-#include <asm/smp.h>
-
-#define esr_disable (1)
-#define NO_BALANCE_IRQ (0)
-
-/* In clustered mode, the high nibble of APIC ID is a cluster number.
- * The low nibble is a 4-bit bitmap. */
-#define XAPIC_DEST_CPUS_SHIFT	4
-#define XAPIC_DEST_CPUS_MASK	((1u << XAPIC_DEST_CPUS_SHIFT) - 1)
-#define XAPIC_DEST_CLUSTER_MASK	(XAPIC_DEST_CPUS_MASK << XAPIC_DEST_CPUS_SHIFT)
-
-#define APIC_DFR_VALUE	(APIC_DFR_CLUSTER)
-
-static inline cpumask_t target_cpus(void)
-{
-	/* CPU_MASK_ALL (0xff) has undefined behaviour with
-	 * dest_LowestPrio mode logical clustered apic interrupt routing
-	 * Just start on cpu 0.  IRQ balancing will spread load
-	 */
-	return cpumask_of_cpu(0);
-} 
-#define TARGET_CPUS	(target_cpus())
-
-#define INT_DELIVERY_MODE (dest_LowestPrio)
-#define INT_DEST_MODE 1     /* logical delivery broadcast to all procs */
-
-static inline unsigned long check_apicid_used(physid_mask_t bitmap, int apicid)
-{
-	return 0;
-} 
-
-/* we don't use the phys_cpu_present_map to indicate apicid presence */
-static inline unsigned long check_apicid_present(int bit) 
-{
-	return 1;
-}
-
-#define apicid_cluster(apicid) ((apicid) & XAPIC_DEST_CLUSTER_MASK)
-
-extern u8 cpu_2_logical_apicid[];
-
-static inline void init_apic_ldr(void)
-{
-	unsigned long val, id;
-	int count = 0;
-	u8 my_id = (u8)hard_smp_processor_id();
-	u8 my_cluster = (u8)apicid_cluster(my_id);
-#ifdef CONFIG_SMP
-	u8 lid;
-	int i;
-
-	/* Create logical APIC IDs by counting CPUs already in cluster. */
-	for (count = 0, i = NR_CPUS; --i >= 0; ) {
-		lid = cpu_2_logical_apicid[i];
-		if (lid != BAD_APICID && apicid_cluster(lid) == my_cluster)
-			++count;
-	}
-#endif
-	/* We only have a 4 wide bitmap in cluster mode.  If a deranged
-	 * BIOS puts 5 CPUs in one APIC cluster, we're hosed. */
-	BUG_ON(count >= XAPIC_DEST_CPUS_SHIFT);
-	id = my_cluster | (1UL << count);
-	apic_write(APIC_DFR, APIC_DFR_VALUE);
-	val = apic_read(APIC_LDR) & ~APIC_LDR_MASK;
-	val |= SET_APIC_LOGICAL_ID(id);
-	apic_write(APIC_LDR, val);
-}
-
-static inline int multi_timer_check(int apic, int irq)
-{
-	return 0;
-}
-
-static inline int apic_id_registered(void)
-{
-	return 1;
-}
-
-static inline void setup_apic_routing(void)
-{
-	printk("Enabling APIC mode:  Summit.  Using %d I/O APICs\n",
-						nr_ioapics);
-}
-
-static inline int apicid_to_node(int logical_apicid)
-{
-#ifdef CONFIG_SMP
-	return apicid_2_node[hard_smp_processor_id()];
-#else
-	return 0;
-#endif
-}
-
-/* Mapping from cpu number to logical apicid */
-static inline int cpu_to_logical_apicid(int cpu)
-{
-#ifdef CONFIG_SMP
-       if (cpu >= NR_CPUS)
-	       return BAD_APICID;
-	return (int)cpu_2_logical_apicid[cpu];
-#else
-	return logical_smp_processor_id();
-#endif
-}
-
-static inline int cpu_present_to_apicid(int mps_cpu)
-{
-	if (mps_cpu < NR_CPUS)
-		return (int)per_cpu(x86_bios_cpu_apicid, mps_cpu);
-	else
-		return BAD_APICID;
-}
-
-static inline physid_mask_t ioapic_phys_id_map(physid_mask_t phys_id_map)
-{
-	/* For clustered we don't have a good way to do this yet - hack */
-	return physids_promote(0x0F);
-}
-
-static inline physid_mask_t apicid_to_cpu_present(int apicid)
-{
-	return physid_mask_of_physid(0);
-}
-
-static inline void setup_portio_remap(void)
-{
-}
-
-static inline int check_phys_apicid_present(int boot_cpu_physical_apicid)
-{
-	return 1;
-}
-
-static inline void enable_apic_mode(void)
-{
-}
-
-static inline unsigned int cpu_mask_to_apicid(cpumask_t cpumask)
-{
-	int num_bits_set;
-	int cpus_found = 0;
-	int cpu;
-	int apicid;	
-
-	num_bits_set = cpus_weight(cpumask);
-	/* Return id to all */
-	if (num_bits_set == NR_CPUS)
-		return (int) 0xFF;
-	/* 
-	 * The cpus in the mask must all be on the apic cluster.  If are not 
-	 * on the same apicid cluster return default value of TARGET_CPUS. 
-	 */
-	cpu = first_cpu(cpumask);
-	apicid = cpu_to_logical_apicid(cpu);
-	while (cpus_found < num_bits_set) {
-		if (cpu_isset(cpu, cpumask)) {
-			int new_apicid = cpu_to_logical_apicid(cpu);
-			if (apicid_cluster(apicid) != 
-					apicid_cluster(new_apicid)){
-				printk ("%s: Not a valid mask!\n",__FUNCTION__);
-				return 0xFF;
-			}
-			apicid = apicid | new_apicid;
-			cpus_found++;
-		}
-		cpu++;
-	}
-	return apicid;
-}
-
-/* cpuid returns the value latched in the HW at reset, not the APIC ID
- * register's value.  For any box whose BIOS changes APIC IDs, like
- * clustered APIC systems, we must use hard_smp_processor_id.
- *
- * See Intel's IA-32 SW Dev's Manual Vol2 under CPUID.
- */
-static inline u32 phys_pkg_id(u32 cpuid_apic, int index_msb)
-{
-	return hard_smp_processor_id() >> index_msb;
-}
-
-#endif /* __ASM_MACH_APIC_H */
Index: linux-2.6/include/asm-x86/mach-summit/mach_apicdef.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mach-summit/mach_apicdef.h
+++ /dev/null
@@ -1,13 +0,0 @@
-#ifndef __ASM_MACH_APICDEF_H
-#define __ASM_MACH_APICDEF_H
-
-#define		APIC_ID_MASK		(0xFF<<24)
-
-static inline unsigned get_apic_id(unsigned long x) 
-{ 
-	return (((x)>>24)&0xFF);
-} 
-
-#define		GET_APIC_ID(x)	get_apic_id(x)
-
-#endif
Index: linux-2.6/include/asm-x86/mach-summit/mach_ipi.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mach-summit/mach_ipi.h
+++ /dev/null
@@ -1,25 +0,0 @@
-#ifndef __ASM_MACH_IPI_H
-#define __ASM_MACH_IPI_H
-
-void send_IPI_mask_sequence(cpumask_t mask, int vector);
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
Index: linux-2.6/include/asm-x86/mach-summit/mach_mpparse.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mach-summit/mach_mpparse.h
+++ /dev/null
@@ -1,110 +0,0 @@
-#ifndef __ASM_MACH_MPPARSE_H
-#define __ASM_MACH_MPPARSE_H
-
-#include <mach_apic.h>
-#include <asm/tsc.h>
-
-extern int use_cyclone;
-
-#ifdef CONFIG_X86_SUMMIT_NUMA
-extern void setup_summit(void);
-#else
-#define setup_summit()	{}
-#endif
-
-static inline int mps_oem_check(struct mp_config_table *mpc, char *oem, 
-		char *productid)
-{
-	if (!strncmp(oem, "IBM ENSW", 8) && 
-			(!strncmp(productid, "VIGIL SMP", 9) 
-			 || !strncmp(productid, "EXA", 3)
-			 || !strncmp(productid, "RUTHLESS SMP", 12))){
-		mark_tsc_unstable("Summit based system");
-		use_cyclone = 1; /*enable cyclone-timer*/
-		setup_summit();
-		return 1;
-	}
-	return 0;
-}
-
-/* Hook from generic ACPI tables.c */
-static inline int acpi_madt_oem_check(char *oem_id, char *oem_table_id)
-{
-	if (!strncmp(oem_id, "IBM", 3) &&
-	    (!strncmp(oem_table_id, "SERVIGIL", 8)
-	     || !strncmp(oem_table_id, "EXA", 3))){
-		mark_tsc_unstable("Summit based system");
-		use_cyclone = 1; /*enable cyclone-timer*/
-		setup_summit();
-		return 1;
-	}
-	return 0;
-}
-
-struct rio_table_hdr {
-	unsigned char version;      /* Version number of this data structure           */
-	                            /* Version 3 adds chassis_num & WP_index           */
-	unsigned char num_scal_dev; /* # of Scalability devices (Twisters for Vigil)   */
-	unsigned char num_rio_dev;  /* # of RIO I/O devices (Cyclones and Winnipegs)   */
-} __attribute__((packed));
-
-struct scal_detail {
-	unsigned char node_id;      /* Scalability Node ID                             */
-	unsigned long CBAR;         /* Address of 1MB register space                   */
-	unsigned char port0node;    /* Node ID port connected to: 0xFF=None            */
-	unsigned char port0port;    /* Port num port connected to: 0,1,2, or 0xFF=None */
-	unsigned char port1node;    /* Node ID port connected to: 0xFF = None          */
-	unsigned char port1port;    /* Port num port connected to: 0,1,2, or 0xFF=None */
-	unsigned char port2node;    /* Node ID port connected to: 0xFF = None          */
-	unsigned char port2port;    /* Port num port connected to: 0,1,2, or 0xFF=None */
-	unsigned char chassis_num;  /* 1 based Chassis number (1 = boot node)          */
-} __attribute__((packed));
-
-struct rio_detail {
-	unsigned char node_id;      /* RIO Node ID                                     */
-	unsigned long BBAR;         /* Address of 1MB register space                   */
-	unsigned char type;         /* Type of device                                  */
-	unsigned char owner_id;     /* For WPEG: Node ID of Cyclone that owns this WPEG*/
-	                            /* For CYC:  Node ID of Twister that owns this CYC */
-	unsigned char port0node;    /* Node ID port connected to: 0xFF=None            */
-	unsigned char port0port;    /* Port num port connected to: 0,1,2, or 0xFF=None */
-	unsigned char port1node;    /* Node ID port connected to: 0xFF=None            */
-	unsigned char port1port;    /* Port num port connected to: 0,1,2, or 0xFF=None */
-	unsigned char first_slot;   /* For WPEG: Lowest slot number below this WPEG    */
-	                            /* For CYC:  0                                     */
-	unsigned char status;       /* For WPEG: Bit 0 = 1 : the XAPIC is used         */
-	                            /*                 = 0 : the XAPIC is not used, ie:*/
-	                            /*                     ints fwded to another XAPIC */
-	                            /*           Bits1:7 Reserved                      */
-	                            /* For CYC:  Bits0:7 Reserved                      */
-	unsigned char WP_index;     /* For WPEG: WPEG instance index - lower ones have */
-	                            /*           lower slot numbers/PCI bus numbers    */
-	                            /* For CYC:  No meaning                            */
-	unsigned char chassis_num;  /* 1 based Chassis number                          */
-	                            /* For LookOut WPEGs this field indicates the      */
-	                            /* Expansion Chassis #, enumerated from Boot       */
-	                            /* Node WPEG external port, then Boot Node CYC     */
-	                            /* external port, then Next Vigil chassis WPEG     */
-	                            /* external port, etc.                             */
-	                            /* Shared Lookouts have only 1 chassis number (the */
-	                            /* first one assigned)                             */
-} __attribute__((packed));
-
-
-typedef enum {
-	CompatTwister = 0,  /* Compatibility Twister               */
-	AltTwister    = 1,  /* Alternate Twister of internal 8-way */
-	CompatCyclone = 2,  /* Compatibility Cyclone               */
-	AltCyclone    = 3,  /* Alternate Cyclone of internal 8-way */
-	CompatWPEG    = 4,  /* Compatibility WPEG                  */
-	AltWPEG       = 5,  /* Second Planar WPEG                  */
-	LookOutAWPEG  = 6,  /* LookOut WPEG                        */
-	LookOutBWPEG  = 7,  /* LookOut WPEG                        */
-} node_type;
-
-static inline int is_WPEG(struct rio_detail *rio){
-	return (rio->type == CompatWPEG || rio->type == AltWPEG ||
-		rio->type == LookOutAWPEG || rio->type == LookOutBWPEG);
-}
-
-#endif /* __ASM_MACH_MPPARSE_H */
Index: linux-2.6/include/asm-x86/summit/apic.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-x86/summit/apic.h
@@ -0,0 +1,185 @@
+#ifndef __ASM_SUMMIT_APIC_H
+#define __ASM_SUMMIT_APIC_H
+
+#include <asm/smp.h>
+
+#define esr_disable (1)
+#define NO_BALANCE_IRQ (0)
+
+/* In clustered mode, the high nibble of APIC ID is a cluster number.
+ * The low nibble is a 4-bit bitmap. */
+#define XAPIC_DEST_CPUS_SHIFT	4
+#define XAPIC_DEST_CPUS_MASK	((1u << XAPIC_DEST_CPUS_SHIFT) - 1)
+#define XAPIC_DEST_CLUSTER_MASK	(XAPIC_DEST_CPUS_MASK << XAPIC_DEST_CPUS_SHIFT)
+
+#define APIC_DFR_VALUE	(APIC_DFR_CLUSTER)
+
+static inline cpumask_t target_cpus(void)
+{
+	/* CPU_MASK_ALL (0xff) has undefined behaviour with
+	 * dest_LowestPrio mode logical clustered apic interrupt routing
+	 * Just start on cpu 0.  IRQ balancing will spread load
+	 */
+	return cpumask_of_cpu(0);
+}
+#define TARGET_CPUS	(target_cpus())
+
+#define INT_DELIVERY_MODE (dest_LowestPrio)
+#define INT_DEST_MODE 1     /* logical delivery broadcast to all procs */
+
+static inline unsigned long check_apicid_used(physid_mask_t bitmap, int apicid)
+{
+	return 0;
+}
+
+/* we don't use the phys_cpu_present_map to indicate apicid presence */
+static inline unsigned long check_apicid_present(int bit)
+{
+	return 1;
+}
+
+#define apicid_cluster(apicid) ((apicid) & XAPIC_DEST_CLUSTER_MASK)
+
+extern u8 cpu_2_logical_apicid[];
+
+static inline void init_apic_ldr(void)
+{
+	unsigned long val, id;
+	int count = 0;
+	u8 my_id = (u8)hard_smp_processor_id();
+	u8 my_cluster = (u8)apicid_cluster(my_id);
+#ifdef CONFIG_SMP
+	u8 lid;
+	int i;
+
+	/* Create logical APIC IDs by counting CPUs already in cluster. */
+	for (count = 0, i = NR_CPUS; --i >= 0; ) {
+		lid = cpu_2_logical_apicid[i];
+		if (lid != BAD_APICID && apicid_cluster(lid) == my_cluster)
+			++count;
+	}
+#endif
+	/* We only have a 4 wide bitmap in cluster mode.  If a deranged
+	 * BIOS puts 5 CPUs in one APIC cluster, we're hosed. */
+	BUG_ON(count >= XAPIC_DEST_CPUS_SHIFT);
+	id = my_cluster | (1UL << count);
+	apic_write(APIC_DFR, APIC_DFR_VALUE);
+	val = apic_read(APIC_LDR) & ~APIC_LDR_MASK;
+	val |= SET_APIC_LOGICAL_ID(id);
+	apic_write(APIC_LDR, val);
+}
+
+static inline int multi_timer_check(int apic, int irq)
+{
+	return 0;
+}
+
+static inline int apic_id_registered(void)
+{
+	return 1;
+}
+
+static inline void setup_apic_routing(void)
+{
+	printk("Enabling APIC mode:  Summit.  Using %d I/O APICs\n",
+						nr_ioapics);
+}
+
+static inline int apicid_to_node(int logical_apicid)
+{
+#ifdef CONFIG_SMP
+	return apicid_2_node[hard_smp_processor_id()];
+#else
+	return 0;
+#endif
+}
+
+/* Mapping from cpu number to logical apicid */
+static inline int cpu_to_logical_apicid(int cpu)
+{
+#ifdef CONFIG_SMP
+       if (cpu >= NR_CPUS)
+	       return BAD_APICID;
+	return (int)cpu_2_logical_apicid[cpu];
+#else
+	return logical_smp_processor_id();
+#endif
+}
+
+static inline int cpu_present_to_apicid(int mps_cpu)
+{
+	if (mps_cpu < NR_CPUS)
+		return (int)per_cpu(x86_bios_cpu_apicid, mps_cpu);
+	else
+		return BAD_APICID;
+}
+
+static inline physid_mask_t ioapic_phys_id_map(physid_mask_t phys_id_map)
+{
+	/* For clustered we don't have a good way to do this yet - hack */
+	return physids_promote(0x0F);
+}
+
+static inline physid_mask_t apicid_to_cpu_present(int apicid)
+{
+	return physid_mask_of_physid(0);
+}
+
+static inline void setup_portio_remap(void)
+{
+}
+
+static inline int check_phys_apicid_present(int boot_cpu_physical_apicid)
+{
+	return 1;
+}
+
+static inline void enable_apic_mode(void)
+{
+}
+
+static inline unsigned int cpu_mask_to_apicid(cpumask_t cpumask)
+{
+	int num_bits_set;
+	int cpus_found = 0;
+	int cpu;
+	int apicid;
+
+	num_bits_set = cpus_weight(cpumask);
+	/* Return id to all */
+	if (num_bits_set == NR_CPUS)
+		return (int) 0xFF;
+	/*
+	 * The cpus in the mask must all be on the apic cluster.  If are not
+	 * on the same apicid cluster return default value of TARGET_CPUS.
+	 */
+	cpu = first_cpu(cpumask);
+	apicid = cpu_to_logical_apicid(cpu);
+	while (cpus_found < num_bits_set) {
+		if (cpu_isset(cpu, cpumask)) {
+			int new_apicid = cpu_to_logical_apicid(cpu);
+			if (apicid_cluster(apicid) !=
+					apicid_cluster(new_apicid)){
+				printk ("%s: Not a valid mask!\n",__FUNCTION__);
+				return 0xFF;
+			}
+			apicid = apicid | new_apicid;
+			cpus_found++;
+		}
+		cpu++;
+	}
+	return apicid;
+}
+
+/* cpuid returns the value latched in the HW at reset, not the APIC ID
+ * register's value.  For any box whose BIOS changes APIC IDs, like
+ * clustered APIC systems, we must use hard_smp_processor_id.
+ *
+ * See Intel's IA-32 SW Dev's Manual Vol2 under CPUID.
+ */
+static inline u32 phys_pkg_id(u32 cpuid_apic, int index_msb)
+{
+	return hard_smp_processor_id() >> index_msb;
+}
+
+#endif /* __ASM_SUMMIT_APIC_H */
Index: linux-2.6/include/asm-x86/summit/apicdef.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-x86/summit/apicdef.h
@@ -0,0 +1,13 @@
+#ifndef __ASM_SUMMIT_APICDEF_H
+#define __ASM_SUMMIT_APICDEF_H
+
+#define		APIC_ID_MASK		(0xFF<<24)
+
+static inline unsigned get_apic_id(unsigned long x)
+{
+	return (x>>24)&0xFF;
+}
+
+#define		GET_APIC_ID(x)	get_apic_id(x)
+
+#endif
Index: linux-2.6/include/asm-x86/summit/ipi.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-x86/summit/ipi.h
@@ -0,0 +1,25 @@
+#ifndef __ASM_SUMMIT_IPI_H
+#define __ASM_SUMMIT_IPI_H
+
+void send_IPI_mask_sequence(cpumask_t mask, int vector);
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
+#endif /* __ASM_SUMMIT_IPI_H */
Index: linux-2.6/include/asm-x86/summit/irq_vectors_limits.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-x86/summit/irq_vectors_limits.h
@@ -0,0 +1,14 @@
+#ifndef _ASM_IRQ_VECTORS_LIMITS_H
+#define _ASM_IRQ_VECTORS_LIMITS_H
+
+/*
+ * For Summit or generic (i.e. installer) kernels, we have lots of I/O APICs,
+ * even with uni-proc kernels, so use a big array.
+ *
+ * This value should be the same in both the generic and summit subarches.
+ * Change one, change 'em both.
+ */
+#define NR_IRQS	224
+#define NR_IRQ_VECTORS	1024
+
+#endif /* _ASM_IRQ_VECTORS_LIMITS_H */
Index: linux-2.6/include/asm-x86/summit/mpparse.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-x86/summit/mpparse.h
@@ -0,0 +1,109 @@
+#ifndef __ASM_SUMMIT_MPPARSE_H
+#define __ASM_SUMMIT_MPPARSE_H
+
+#include <asm/tsc.h>
+
+extern int use_cyclone;
+
+#ifdef CONFIG_X86_SUMMIT_NUMA
+extern void setup_summit(void);
+#else
+#define setup_summit()	{}
+#endif
+
+static inline int mps_oem_check(struct mp_config_table *mpc, char *oem,
+		char *productid)
+{
+	if (!strncmp(oem, "IBM ENSW", 8) &&
+			(!strncmp(productid, "VIGIL SMP", 9)
+			 || !strncmp(productid, "EXA", 3)
+			 || !strncmp(productid, "RUTHLESS SMP", 12))){
+		mark_tsc_unstable("Summit based system");
+		use_cyclone = 1; /*enable cyclone-timer*/
+		setup_summit();
+		return 1;
+	}
+	return 0;
+}
+
+/* Hook from generic ACPI tables.c */
+static inline int acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+{
+	if (!strncmp(oem_id, "IBM", 3) &&
+	    (!strncmp(oem_table_id, "SERVIGIL", 8)
+	     || !strncmp(oem_table_id, "EXA", 3))){
+		mark_tsc_unstable("Summit based system");
+		use_cyclone = 1; /*enable cyclone-timer*/
+		setup_summit();
+		return 1;
+	}
+	return 0;
+}
+
+struct rio_table_hdr {
+	unsigned char version;      /* Version number of this data structure           */
+	                            /* Version 3 adds chassis_num & WP_index           */
+	unsigned char num_scal_dev; /* # of Scalability devices (Twisters for Vigil)   */
+	unsigned char num_rio_dev;  /* # of RIO I/O devices (Cyclones and Winnipegs)   */
+} __attribute__((packed));
+
+struct scal_detail {
+	unsigned char node_id;      /* Scalability Node ID                             */
+	unsigned long CBAR;         /* Address of 1MB register space                   */
+	unsigned char port0node;    /* Node ID port connected to: 0xFF=None            */
+	unsigned char port0port;    /* Port num port connected to: 0,1,2, or 0xFF=None */
+	unsigned char port1node;    /* Node ID port connected to: 0xFF = None          */
+	unsigned char port1port;    /* Port num port connected to: 0,1,2, or 0xFF=None */
+	unsigned char port2node;    /* Node ID port connected to: 0xFF = None          */
+	unsigned char port2port;    /* Port num port connected to: 0,1,2, or 0xFF=None */
+	unsigned char chassis_num;  /* 1 based Chassis number (1 = boot node)          */
+} __attribute__((packed));
+
+struct rio_detail {
+	unsigned char node_id;      /* RIO Node ID                                     */
+	unsigned long BBAR;         /* Address of 1MB register space                   */
+	unsigned char type;         /* Type of device                                  */
+	unsigned char owner_id;     /* For WPEG: Node ID of Cyclone that owns this WPEG*/
+	                            /* For CYC:  Node ID of Twister that owns this CYC */
+	unsigned char port0node;    /* Node ID port connected to: 0xFF=None            */
+	unsigned char port0port;    /* Port num port connected to: 0,1,2, or 0xFF=None */
+	unsigned char port1node;    /* Node ID port connected to: 0xFF=None            */
+	unsigned char port1port;    /* Port num port connected to: 0,1,2, or 0xFF=None */
+	unsigned char first_slot;   /* For WPEG: Lowest slot number below this WPEG    */
+	                            /* For CYC:  0                                     */
+	unsigned char status;       /* For WPEG: Bit 0 = 1 : the XAPIC is used         */
+	                            /*                 = 0 : the XAPIC is not used, ie:*/
+	                            /*                     ints fwded to another XAPIC */
+	                            /*           Bits1:7 Reserved                      */
+	                            /* For CYC:  Bits0:7 Reserved                      */
+	unsigned char WP_index;     /* For WPEG: WPEG instance index - lower ones have */
+	                            /*           lower slot numbers/PCI bus numbers    */
+	                            /* For CYC:  No meaning                            */
+	unsigned char chassis_num;  /* 1 based Chassis number                          */
+	                            /* For LookOut WPEGs this field indicates the      */
+	                            /* Expansion Chassis #, enumerated from Boot       */
+	                            /* Node WPEG external port, then Boot Node CYC     */
+	                            /* external port, then Next Vigil chassis WPEG     */
+	                            /* external port, etc.                             */
+	                            /* Shared Lookouts have only 1 chassis number (the */
+	                            /* first one assigned)                             */
+} __attribute__((packed));
+
+
+typedef enum {
+	CompatTwister = 0,  /* Compatibility Twister               */
+	AltTwister    = 1,  /* Alternate Twister of internal 8-way */
+	CompatCyclone = 2,  /* Compatibility Cyclone               */
+	AltCyclone    = 3,  /* Alternate Cyclone of internal 8-way */
+	CompatWPEG    = 4,  /* Compatibility WPEG                  */
+	AltWPEG       = 5,  /* Second Planar WPEG                  */
+	LookOutAWPEG  = 6,  /* LookOut WPEG                        */
+	LookOutBWPEG  = 7,  /* LookOut WPEG                        */
+} node_type;
+
+static inline int is_WPEG(struct rio_detail *rio){
+	return (rio->type == CompatWPEG || rio->type == AltWPEG ||
+		rio->type == LookOutAWPEG || rio->type == LookOutBWPEG);
+}
+
+#endif /* __ASM_SUMMIT_MPPARSE_H */
