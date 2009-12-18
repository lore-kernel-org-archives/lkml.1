Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450AbZLRS4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbZLRS4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 13:56:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755023AbZLRS4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 13:56:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41109 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683AbZLRS4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 13:56:49 -0500
Date: Fri, 18 Dec 2009 19:56:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20091218185631.GA15747@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus


out-of-topic modifications in x86-fixes-for-linus:
--------------------------------------------------
Makefile                           # 06b5dc6: Makefile: Unexport LC_ALL instead
                                   # c051346: Makefile: set LC_CTYPE, LC_COLLAT
include/linux/decompress/mm.h      # c1e7c3a: bzip2/lzma/gzip: pre-boot malloc 
include/linux/mm.h                 # 3299625: x86: Fix checking of SRAT when no
init/initramfs.c                   # 5429136: initramfs: add missing decompress
lib/decompress_bunzip2.c           # d452986: bzip2: Add missing checks for mal
mm/page_alloc.c                    # 3299625: x86: Fix checking of SRAT when no

 Thanks,

	Ingo

------------------>
Andreas Herrmann (1):
      x86, amd: Get multi-node CPU info from NodeId MSR instead of PCI config space

Borislav Petkov (1):
      x86, msr: msrs_alloc/free for CONFIG_SMP=n

H. Peter Anvin (3):
      x86, msr/cpuid: Register enough minors for the MSR and CPUID drivers
      Makefile: set LC_CTYPE, LC_COLLATE, LC_NUMERIC to C
      Makefile: Unexport LC_ALL instead of clearing it

Pallipadi, Venkatesh (1):
      x86: Reenable TSC sync check at boot, even with NONSTOP_TSC

Phillip Lougher (3):
      bzip2/lzma/gzip: pre-boot malloc doesn't return NULL on failure
      bzip2: Add missing checks for malloc returning NULL
      initramfs: add missing decompressor error check

Roland Dreier (1):
      x86: Don't use POSIX character classes in gen-insn-attr-x86.awk

Sheng Yang (1):
      x86: Add IA32_TSC_AUX MSR and use it

Suresh Siddha (2):
      x86, cpuid: Add "volatile" to asm in native_cpuid()
      x86, irq: Allow 0xff for /proc/irq/[n]/smp_affinity on an 8-cpu system

Yinghai Lu (2):
      x86: Fix checking of SRAT when node 0 ram is not from 0
      x86: Increase MAX_EARLY_RES; insufficient on 32-bit NUMA

akpm@linux-foundation.org (1):
      x86: Fix objdump version check in arch/x86/tools/chkobjdump.awk


 Makefile                              |    7 +
 arch/x86/include/asm/cpufeature.h     |    1 +
 arch/x86/include/asm/hw_irq.h         |    3 +-
 arch/x86/include/asm/msr-index.h      |    2 +
 arch/x86/include/asm/msr.h            |   16 ++-
 arch/x86/include/asm/processor.h      |    2 +-
 arch/x86/kernel/apic/apic_flat_64.c   |    5 +-
 arch/x86/kernel/apic/bigsmp_32.c      |    5 +-
 arch/x86/kernel/apic/io_apic.c        |   32 ++---
 arch/x86/kernel/apic/x2apic_cluster.c |    5 +-
 arch/x86/kernel/apic/x2apic_phys.c    |    5 +-
 arch/x86/kernel/apic/x2apic_uv_x.c    |    5 +-
 arch/x86/kernel/cpu/amd.c             |   53 +++------
 arch/x86/kernel/cpu/intel.c           |    1 -
 arch/x86/kernel/cpuid.c               |    5 +-
 arch/x86/kernel/e820.c                |    2 +-
 arch/x86/kernel/msr.c                 |    4 +-
 arch/x86/kernel/tsc.c                 |    1 +
 arch/x86/kernel/uv_irq.c              |    3 +-
 arch/x86/lib/Makefile                 |    4 +-
 arch/x86/lib/msr-smp.c                |  204 +++++++++++++++++++++++++++++++
 arch/x86/lib/msr.c                    |  213 ---------------------------------
 arch/x86/mm/srat_32.c                 |    2 +
 arch/x86/mm/srat_64.c                 |    4 +-
 arch/x86/tools/chkobjdump.awk         |    2 +-
 arch/x86/tools/gen-insn-attr-x86.awk  |   10 +-
 include/linux/decompress/mm.h         |    4 +-
 include/linux/mm.h                    |    3 +
 init/initramfs.c                      |   10 +-
 lib/decompress_bunzip2.c              |   10 ++-
 mm/page_alloc.c                       |    4 +-
 31 files changed, 307 insertions(+), 320 deletions(-)
 create mode 100644 arch/x86/lib/msr-smp.c

diff --git a/Makefile b/Makefile
index 33d4732..5e92ca5 100644
--- a/Makefile
+++ b/Makefile
@@ -16,6 +16,13 @@ NAME = Man-Eating Seals of Antiquity
 # o  print "Entering directory ...";
 MAKEFLAGS += -rR --no-print-directory
 
+# Avoid funny character set dependencies
+unexport LC_ALL
+LC_CTYPE=C
+LC_COLLATE=C
+LC_NUMERIC=C
+export LC_CTYPE LC_COLLATE LC_NUMERIC
+
 # We are using a recursive build, so we need to do a little thinking
 # to get the ordering right.
 #
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 613700f..637e1ec 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -153,6 +153,7 @@
 #define X86_FEATURE_SSE5	(6*32+11) /* SSE-5 */
 #define X86_FEATURE_SKINIT	(6*32+12) /* SKINIT/STGI instructions */
 #define X86_FEATURE_WDT		(6*32+13) /* Watchdog timer */
+#define X86_FEATURE_NODEID_MSR	(6*32+19) /* NodeId MSR */
 
 /*
  * Auxiliary flags: Linux defined - For features scattered in various
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 08c48a8..eeac829 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -103,7 +103,8 @@ extern int assign_irq_vector(int, struct irq_cfg *, const struct cpumask *);
 extern void send_cleanup_vector(struct irq_cfg *);
 
 struct irq_desc;
-extern unsigned int set_desc_affinity(struct irq_desc *, const struct cpumask *);
+extern unsigned int set_desc_affinity(struct irq_desc *, const struct cpumask *,
+				      unsigned int *dest_id);
 extern int IO_APIC_get_PCI_irq_vector(int bus, int devfn, int pin, struct io_apic_irq_attr *irq_attr);
 extern void setup_ioapic_dest(void);
 
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 4ffe09b..1cd58cd 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -12,6 +12,7 @@
 #define MSR_FS_BASE		0xc0000100 /* 64bit FS base */
 #define MSR_GS_BASE		0xc0000101 /* 64bit GS base */
 #define MSR_KERNEL_GS_BASE	0xc0000102 /* SwapGS GS shadow */
+#define MSR_TSC_AUX		0xc0000103 /* Auxiliary TSC */
 
 /* EFER bits: */
 #define _EFER_SCE		0  /* SYSCALL/SYSRET */
@@ -123,6 +124,7 @@
 #define FAM10H_MMIO_CONF_BUSRANGE_SHIFT 2
 #define FAM10H_MMIO_CONF_BASE_MASK	0xfffffff
 #define FAM10H_MMIO_CONF_BASE_SHIFT	20
+#define MSR_FAM10H_NODE_ID		0xc001100c
 
 /* K8 MSRs */
 #define MSR_K8_TOP_MEM1			0xc001001a
diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 2d228fc..c5bc4c2 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -27,6 +27,18 @@ struct msr {
 	};
 };
 
+struct msr_info {
+	u32 msr_no;
+	struct msr reg;
+	struct msr *msrs;
+	int err;
+};
+
+struct msr_regs_info {
+	u32 *regs;
+	int err;
+};
+
 static inline unsigned long long native_read_tscp(unsigned int *aux)
 {
 	unsigned long low, high;
@@ -240,9 +252,9 @@ do {                                                            \
 #define checking_wrmsrl(msr, val) wrmsr_safe((msr), (u32)(val),		\
 					     (u32)((val) >> 32))
 
-#define write_tsc(val1, val2) wrmsr(0x10, (val1), (val2))
+#define write_tsc(val1, val2) wrmsr(MSR_IA32_TSC, (val1), (val2))
 
-#define write_rdtscp_aux(val) wrmsr(0xc0000103, (val), 0)
+#define write_rdtscp_aux(val) wrmsr(MSR_TSC_AUX, (val), 0)
 
 struct msr *msrs_alloc(void);
 void msrs_free(struct msr *msrs);
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 6f8ec1c..fc801ba 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -181,7 +181,7 @@ static inline void native_cpuid(unsigned int *eax, unsigned int *ebx,
 				unsigned int *ecx, unsigned int *edx)
 {
 	/* ecx is often an input as well as an output. */
-	asm("cpuid"
+	asm volatile("cpuid"
 	    : "=a" (*eax),
 	      "=b" (*ebx),
 	      "=c" (*ecx),
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index d0c99ab..eacbd2b 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -306,10 +306,7 @@ physflat_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 		if (cpumask_test_cpu(cpu, cpu_online_mask))
 			break;
 	}
-	if (cpu < nr_cpu_ids)
-		return per_cpu(x86_cpu_to_apicid, cpu);
-
-	return BAD_APICID;
+	return per_cpu(x86_cpu_to_apicid, cpu);
 }
 
 struct apic apic_physflat =  {
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index 38dcecf..cb804c5 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -131,10 +131,7 @@ static unsigned int bigsmp_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 		if (cpumask_test_cpu(cpu, cpu_online_mask))
 			break;
 	}
-	if (cpu < nr_cpu_ids)
-		return bigsmp_cpu_to_logical_apicid(cpu);
-
-	return BAD_APICID;
+	return bigsmp_cpu_to_logical_apicid(cpu);
 }
 
 static int bigsmp_phys_pkg_id(int cpuid_apic, int index_msb)
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index d5d498f..98ced70 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2276,26 +2276,28 @@ static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, struct irq
 
 /*
  * Either sets desc->affinity to a valid value, and returns
- * ->cpu_mask_to_apicid of that, or returns BAD_APICID and
+ * ->cpu_mask_to_apicid of that in dest_id, or returns -1 and
  * leaves desc->affinity untouched.
  */
 unsigned int
-set_desc_affinity(struct irq_desc *desc, const struct cpumask *mask)
+set_desc_affinity(struct irq_desc *desc, const struct cpumask *mask,
+		  unsigned int *dest_id)
 {
 	struct irq_cfg *cfg;
 	unsigned int irq;
 
 	if (!cpumask_intersects(mask, cpu_online_mask))
-		return BAD_APICID;
+		return -1;
 
 	irq = desc->irq;
 	cfg = desc->chip_data;
 	if (assign_irq_vector(irq, cfg, mask))
-		return BAD_APICID;
+		return -1;
 
 	cpumask_copy(desc->affinity, mask);
 
-	return apic->cpu_mask_to_apicid_and(desc->affinity, cfg->domain);
+	*dest_id = apic->cpu_mask_to_apicid_and(desc->affinity, cfg->domain);
+	return 0;
 }
 
 static int
@@ -2311,12 +2313,11 @@ set_ioapic_affinity_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
 	cfg = desc->chip_data;
 
 	spin_lock_irqsave(&ioapic_lock, flags);
-	dest = set_desc_affinity(desc, mask);
-	if (dest != BAD_APICID) {
+	ret = set_desc_affinity(desc, mask, &dest);
+	if (!ret) {
 		/* Only the high 8 bits are valid. */
 		dest = SET_APIC_LOGICAL_ID(dest);
 		__target_IO_APIC_irq(irq, dest, cfg);
-		ret = 0;
 	}
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 
@@ -3351,8 +3352,7 @@ static int set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
 	struct msi_msg msg;
 	unsigned int dest;
 
-	dest = set_desc_affinity(desc, mask);
-	if (dest == BAD_APICID)
+	if (set_desc_affinity(desc, mask, &dest))
 		return -1;
 
 	cfg = desc->chip_data;
@@ -3384,8 +3384,7 @@ ir_set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
 	if (get_irte(irq, &irte))
 		return -1;
 
-	dest = set_desc_affinity(desc, mask);
-	if (dest == BAD_APICID)
+	if (set_desc_affinity(desc, mask, &dest))
 		return -1;
 
 	irte.vector = cfg->vector;
@@ -3567,8 +3566,7 @@ static int dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 	struct msi_msg msg;
 	unsigned int dest;
 
-	dest = set_desc_affinity(desc, mask);
-	if (dest == BAD_APICID)
+	if (set_desc_affinity(desc, mask, &dest))
 		return -1;
 
 	cfg = desc->chip_data;
@@ -3623,8 +3621,7 @@ static int hpet_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 	struct msi_msg msg;
 	unsigned int dest;
 
-	dest = set_desc_affinity(desc, mask);
-	if (dest == BAD_APICID)
+	if (set_desc_affinity(desc, mask, &dest))
 		return -1;
 
 	cfg = desc->chip_data;
@@ -3730,8 +3727,7 @@ static int set_ht_irq_affinity(unsigned int irq, const struct cpumask *mask)
 	struct irq_cfg *cfg;
 	unsigned int dest;
 
-	dest = set_desc_affinity(desc, mask);
-	if (dest == BAD_APICID)
+	if (set_desc_affinity(desc, mask, &dest))
 		return -1;
 
 	cfg = desc->chip_data;
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index a5371ec..cf69c59 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -148,10 +148,7 @@ x2apic_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 			break;
 	}
 
-	if (cpu < nr_cpu_ids)
-		return per_cpu(x86_cpu_to_logical_apicid, cpu);
-
-	return BAD_APICID;
+	return per_cpu(x86_cpu_to_logical_apicid, cpu);
 }
 
 static unsigned int x2apic_cluster_phys_get_apic_id(unsigned long x)
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index a8989aa..8972f38 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -146,10 +146,7 @@ x2apic_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 			break;
 	}
 
-	if (cpu < nr_cpu_ids)
-		return per_cpu(x86_cpu_to_apicid, cpu);
-
-	return BAD_APICID;
+	return per_cpu(x86_cpu_to_apicid, cpu);
 }
 
 static unsigned int x2apic_phys_get_apic_id(unsigned long x)
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index b684bb3..d56b0ef 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -225,10 +225,7 @@ uv_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 		if (cpumask_test_cpu(cpu, cpu_online_mask))
 			break;
 	}
-	if (cpu < nr_cpu_ids)
-		return per_cpu(x86_cpu_to_apicid, cpu);
-
-	return BAD_APICID;
+	return per_cpu(x86_cpu_to_apicid, cpu);
 }
 
 static unsigned int x2apic_get_apic_id(unsigned long x)
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 8dc3ea1..e485825 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -254,59 +254,36 @@ static int __cpuinit nearby_node(int apicid)
 
 /*
  * Fixup core topology information for AMD multi-node processors.
- * Assumption 1: Number of cores in each internal node is the same.
- * Assumption 2: Mixed systems with both single-node and dual-node
- *               processors are not supported.
+ * Assumption: Number of cores in each internal node is the same.
  */
 #ifdef CONFIG_X86_HT
 static void __cpuinit amd_fixup_dcm(struct cpuinfo_x86 *c)
 {
-#ifdef CONFIG_PCI
-	u32 t, cpn;
-	u8 n, n_id;
+	unsigned long long value;
+	u32 nodes, cores_per_node;
 	int cpu = smp_processor_id();
 
+	if (!cpu_has(c, X86_FEATURE_NODEID_MSR))
+		return;
+
 	/* fixup topology information only once for a core */
 	if (cpu_has(c, X86_FEATURE_AMD_DCM))
 		return;
 
-	/* check for multi-node processor on boot cpu */
-	t = read_pci_config(0, 24, 3, 0xe8);
-	if (!(t & (1 << 29)))
+	rdmsrl(MSR_FAM10H_NODE_ID, value);
+
+	nodes = ((value >> 3) & 7) + 1;
+	if (nodes == 1)
 		return;
 
 	set_cpu_cap(c, X86_FEATURE_AMD_DCM);
+	cores_per_node = c->x86_max_cores / nodes;
 
-	/* cores per node: each internal node has half the number of cores */
-	cpn = c->x86_max_cores >> 1;
+	/* store NodeID, use llc_shared_map to store sibling info */
+	per_cpu(cpu_llc_id, cpu) = value & 7;
 
-	/* even-numbered NB_id of this dual-node processor */
-	n = c->phys_proc_id << 1;
-
-	/*
-	 * determine internal node id and assign cores fifty-fifty to
-	 * each node of the dual-node processor
-	 */
-	t = read_pci_config(0, 24 + n, 3, 0xe8);
-	n = (t>>30) & 0x3;
-	if (n == 0) {
-		if (c->cpu_core_id < cpn)
-			n_id = 0;
-		else
-			n_id = 1;
-	} else {
-		if (c->cpu_core_id < cpn)
-			n_id = 1;
-		else
-			n_id = 0;
-	}
-
-	/* compute entire NodeID, use llc_shared_map to store sibling info */
-	per_cpu(cpu_llc_id, cpu) = (c->phys_proc_id << 1) + n_id;
-
-	/* fixup core id to be in range from 0 to cpn */
-	c->cpu_core_id = c->cpu_core_id % cpn;
-#endif
+	/* fixup core id to be in range from 0 to (cores_per_node - 1) */
+	c->cpu_core_id = c->cpu_core_id % cores_per_node;
 }
 #endif
 
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 9c31e8b..879666f 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -70,7 +70,6 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 	if (c->x86_power & (1 << 8)) {
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
-		set_cpu_cap(c, X86_FEATURE_TSC_RELIABLE);
 		sched_clock_stable = 1;
 	}
 
diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
index 7ef24a7..cb27fd6 100644
--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -187,7 +187,8 @@ static int __init cpuid_init(void)
 	int i, err = 0;
 	i = 0;
 
-	if (register_chrdev(CPUID_MAJOR, "cpu/cpuid", &cpuid_fops)) {
+	if (__register_chrdev(CPUID_MAJOR, 0, NR_CPUS,
+			      "cpu/cpuid", &cpuid_fops)) {
 		printk(KERN_ERR "cpuid: unable to get major %d for cpuid\n",
 		       CPUID_MAJOR);
 		err = -EBUSY;
@@ -216,7 +217,7 @@ out_class:
 	}
 	class_destroy(cpuid_class);
 out_chrdev:
-	unregister_chrdev(CPUID_MAJOR, "cpu/cpuid");
+	__unregister_chrdev(CPUID_MAJOR, 0, NR_CPUS, "cpu/cpuid");
 out:
 	return err;
 }
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index f50447d..05ed7ab 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -724,7 +724,7 @@ core_initcall(e820_mark_nvs_memory);
 /*
  * Early reserved memory areas.
  */
-#define MAX_EARLY_RES 20
+#define MAX_EARLY_RES 32
 
 struct early_res {
 	u64 start, end;
diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 572b07e..4bd93c9 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -246,7 +246,7 @@ static int __init msr_init(void)
 	int i, err = 0;
 	i = 0;
 
-	if (register_chrdev(MSR_MAJOR, "cpu/msr", &msr_fops)) {
+	if (__register_chrdev(MSR_MAJOR, 0, NR_CPUS, "cpu/msr", &msr_fops)) {
 		printk(KERN_ERR "msr: unable to get major %d for msr\n",
 		       MSR_MAJOR);
 		err = -EBUSY;
@@ -274,7 +274,7 @@ out_class:
 		msr_device_destroy(i);
 	class_destroy(msr_class);
 out_chrdev:
-	unregister_chrdev(MSR_MAJOR, "cpu/msr");
+	__unregister_chrdev(MSR_MAJOR, 0, NR_CPUS, "cpu/msr");
 out:
 	return err;
 }
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index cd982f4..597683a 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -763,6 +763,7 @@ void mark_tsc_unstable(char *reason)
 {
 	if (!tsc_unstable) {
 		tsc_unstable = 1;
+		sched_clock_stable = 0;
 		printk(KERN_INFO "Marking TSC unstable due to %s\n", reason);
 		/* Change only the rating, when not registered */
 		if (clocksource_tsc.mult)
diff --git a/arch/x86/kernel/uv_irq.c b/arch/x86/kernel/uv_irq.c
index 61d805d..ece73d8 100644
--- a/arch/x86/kernel/uv_irq.c
+++ b/arch/x86/kernel/uv_irq.c
@@ -215,8 +215,7 @@ static int uv_set_irq_affinity(unsigned int irq, const struct cpumask *mask)
 	unsigned long mmr_offset;
 	unsigned mmr_pnode;
 
-	dest = set_desc_affinity(desc, mask);
-	if (dest == BAD_APICID)
+	if (set_desc_affinity(desc, mask, &dest))
 		return -1;
 
 	mmr_value = 0;
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index a2d6472..706be8b 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -14,7 +14,7 @@ $(obj)/inat.o: $(obj)/inat-tables.c
 
 clean-files := inat-tables.c
 
-obj-$(CONFIG_SMP) := msr.o
+obj-$(CONFIG_SMP) += msr-smp.o
 
 lib-y := delay.o
 lib-y += thunk_$(BITS).o
@@ -22,7 +22,7 @@ lib-y += usercopy_$(BITS).o getuser.o putuser.o
 lib-y += memcpy_$(BITS).o
 lib-y += insn.o inat.o
 
-obj-y += msr-reg.o msr-reg-export.o
+obj-y += msr.o msr-reg.o msr-reg-export.o
 
 ifeq ($(CONFIG_X86_32),y)
         obj-y += atomic64_32.o
diff --git a/arch/x86/lib/msr-smp.c b/arch/x86/lib/msr-smp.c
new file mode 100644
index 0000000..a6b1b86
--- /dev/null
+++ b/arch/x86/lib/msr-smp.c
@@ -0,0 +1,204 @@
+#include <linux/module.h>
+#include <linux/preempt.h>
+#include <linux/smp.h>
+#include <asm/msr.h>
+
+static void __rdmsr_on_cpu(void *info)
+{
+	struct msr_info *rv = info;
+	struct msr *reg;
+	int this_cpu = raw_smp_processor_id();
+
+	if (rv->msrs)
+		reg = per_cpu_ptr(rv->msrs, this_cpu);
+	else
+		reg = &rv->reg;
+
+	rdmsr(rv->msr_no, reg->l, reg->h);
+}
+
+static void __wrmsr_on_cpu(void *info)
+{
+	struct msr_info *rv = info;
+	struct msr *reg;
+	int this_cpu = raw_smp_processor_id();
+
+	if (rv->msrs)
+		reg = per_cpu_ptr(rv->msrs, this_cpu);
+	else
+		reg = &rv->reg;
+
+	wrmsr(rv->msr_no, reg->l, reg->h);
+}
+
+int rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
+{
+	int err;
+	struct msr_info rv;
+
+	memset(&rv, 0, sizeof(rv));
+
+	rv.msr_no = msr_no;
+	err = smp_call_function_single(cpu, __rdmsr_on_cpu, &rv, 1);
+	*l = rv.reg.l;
+	*h = rv.reg.h;
+
+	return err;
+}
+EXPORT_SYMBOL(rdmsr_on_cpu);
+
+int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
+{
+	int err;
+	struct msr_info rv;
+
+	memset(&rv, 0, sizeof(rv));
+
+	rv.msr_no = msr_no;
+	rv.reg.l = l;
+	rv.reg.h = h;
+	err = smp_call_function_single(cpu, __wrmsr_on_cpu, &rv, 1);
+
+	return err;
+}
+EXPORT_SYMBOL(wrmsr_on_cpu);
+
+static void __rwmsr_on_cpus(const struct cpumask *mask, u32 msr_no,
+			    struct msr *msrs,
+			    void (*msr_func) (void *info))
+{
+	struct msr_info rv;
+	int this_cpu;
+
+	memset(&rv, 0, sizeof(rv));
+
+	rv.msrs	  = msrs;
+	rv.msr_no = msr_no;
+
+	this_cpu = get_cpu();
+
+	if (cpumask_test_cpu(this_cpu, mask))
+		msr_func(&rv);
+
+	smp_call_function_many(mask, msr_func, &rv, 1);
+	put_cpu();
+}
+
+/* rdmsr on a bunch of CPUs
+ *
+ * @mask:       which CPUs
+ * @msr_no:     which MSR
+ * @msrs:       array of MSR values
+ *
+ */
+void rdmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr *msrs)
+{
+	__rwmsr_on_cpus(mask, msr_no, msrs, __rdmsr_on_cpu);
+}
+EXPORT_SYMBOL(rdmsr_on_cpus);
+
+/*
+ * wrmsr on a bunch of CPUs
+ *
+ * @mask:       which CPUs
+ * @msr_no:     which MSR
+ * @msrs:       array of MSR values
+ *
+ */
+void wrmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr *msrs)
+{
+	__rwmsr_on_cpus(mask, msr_no, msrs, __wrmsr_on_cpu);
+}
+EXPORT_SYMBOL(wrmsr_on_cpus);
+
+/* These "safe" variants are slower and should be used when the target MSR
+   may not actually exist. */
+static void __rdmsr_safe_on_cpu(void *info)
+{
+	struct msr_info *rv = info;
+
+	rv->err = rdmsr_safe(rv->msr_no, &rv->reg.l, &rv->reg.h);
+}
+
+static void __wrmsr_safe_on_cpu(void *info)
+{
+	struct msr_info *rv = info;
+
+	rv->err = wrmsr_safe(rv->msr_no, rv->reg.l, rv->reg.h);
+}
+
+int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
+{
+	int err;
+	struct msr_info rv;
+
+	memset(&rv, 0, sizeof(rv));
+
+	rv.msr_no = msr_no;
+	err = smp_call_function_single(cpu, __rdmsr_safe_on_cpu, &rv, 1);
+	*l = rv.reg.l;
+	*h = rv.reg.h;
+
+	return err ? err : rv.err;
+}
+EXPORT_SYMBOL(rdmsr_safe_on_cpu);
+
+int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
+{
+	int err;
+	struct msr_info rv;
+
+	memset(&rv, 0, sizeof(rv));
+
+	rv.msr_no = msr_no;
+	rv.reg.l = l;
+	rv.reg.h = h;
+	err = smp_call_function_single(cpu, __wrmsr_safe_on_cpu, &rv, 1);
+
+	return err ? err : rv.err;
+}
+EXPORT_SYMBOL(wrmsr_safe_on_cpu);
+
+/*
+ * These variants are significantly slower, but allows control over
+ * the entire 32-bit GPR set.
+ */
+static void __rdmsr_safe_regs_on_cpu(void *info)
+{
+	struct msr_regs_info *rv = info;
+
+	rv->err = rdmsr_safe_regs(rv->regs);
+}
+
+static void __wrmsr_safe_regs_on_cpu(void *info)
+{
+	struct msr_regs_info *rv = info;
+
+	rv->err = wrmsr_safe_regs(rv->regs);
+}
+
+int rdmsr_safe_regs_on_cpu(unsigned int cpu, u32 *regs)
+{
+	int err;
+	struct msr_regs_info rv;
+
+	rv.regs   = regs;
+	rv.err    = -EIO;
+	err = smp_call_function_single(cpu, __rdmsr_safe_regs_on_cpu, &rv, 1);
+
+	return err ? err : rv.err;
+}
+EXPORT_SYMBOL(rdmsr_safe_regs_on_cpu);
+
+int wrmsr_safe_regs_on_cpu(unsigned int cpu, u32 *regs)
+{
+	int err;
+	struct msr_regs_info rv;
+
+	rv.regs = regs;
+	rv.err  = -EIO;
+	err = smp_call_function_single(cpu, __wrmsr_safe_regs_on_cpu, &rv, 1);
+
+	return err ? err : rv.err;
+}
+EXPORT_SYMBOL(wrmsr_safe_regs_on_cpu);
diff --git a/arch/x86/lib/msr.c b/arch/x86/lib/msr.c
index 8728341..8f8eebd 100644
--- a/arch/x86/lib/msr.c
+++ b/arch/x86/lib/msr.c
@@ -1,123 +1,7 @@
 #include <linux/module.h>
 #include <linux/preempt.h>
-#include <linux/smp.h>
 #include <asm/msr.h>
 
-struct msr_info {
-	u32 msr_no;
-	struct msr reg;
-	struct msr *msrs;
-	int err;
-};
-
-static void __rdmsr_on_cpu(void *info)
-{
-	struct msr_info *rv = info;
-	struct msr *reg;
-	int this_cpu = raw_smp_processor_id();
-
-	if (rv->msrs)
-		reg = per_cpu_ptr(rv->msrs, this_cpu);
-	else
-		reg = &rv->reg;
-
-	rdmsr(rv->msr_no, reg->l, reg->h);
-}
-
-static void __wrmsr_on_cpu(void *info)
-{
-	struct msr_info *rv = info;
-	struct msr *reg;
-	int this_cpu = raw_smp_processor_id();
-
-	if (rv->msrs)
-		reg = per_cpu_ptr(rv->msrs, this_cpu);
-	else
-		reg = &rv->reg;
-
-	wrmsr(rv->msr_no, reg->l, reg->h);
-}
-
-int rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
-{
-	int err;
-	struct msr_info rv;
-
-	memset(&rv, 0, sizeof(rv));
-
-	rv.msr_no = msr_no;
-	err = smp_call_function_single(cpu, __rdmsr_on_cpu, &rv, 1);
-	*l = rv.reg.l;
-	*h = rv.reg.h;
-
-	return err;
-}
-EXPORT_SYMBOL(rdmsr_on_cpu);
-
-int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
-{
-	int err;
-	struct msr_info rv;
-
-	memset(&rv, 0, sizeof(rv));
-
-	rv.msr_no = msr_no;
-	rv.reg.l = l;
-	rv.reg.h = h;
-	err = smp_call_function_single(cpu, __wrmsr_on_cpu, &rv, 1);
-
-	return err;
-}
-EXPORT_SYMBOL(wrmsr_on_cpu);
-
-static void __rwmsr_on_cpus(const struct cpumask *mask, u32 msr_no,
-			    struct msr *msrs,
-			    void (*msr_func) (void *info))
-{
-	struct msr_info rv;
-	int this_cpu;
-
-	memset(&rv, 0, sizeof(rv));
-
-	rv.msrs	  = msrs;
-	rv.msr_no = msr_no;
-
-	this_cpu = get_cpu();
-
-	if (cpumask_test_cpu(this_cpu, mask))
-		msr_func(&rv);
-
-	smp_call_function_many(mask, msr_func, &rv, 1);
-	put_cpu();
-}
-
-/* rdmsr on a bunch of CPUs
- *
- * @mask:       which CPUs
- * @msr_no:     which MSR
- * @msrs:       array of MSR values
- *
- */
-void rdmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr *msrs)
-{
-	__rwmsr_on_cpus(mask, msr_no, msrs, __rdmsr_on_cpu);
-}
-EXPORT_SYMBOL(rdmsr_on_cpus);
-
-/*
- * wrmsr on a bunch of CPUs
- *
- * @mask:       which CPUs
- * @msr_no:     which MSR
- * @msrs:       array of MSR values
- *
- */
-void wrmsr_on_cpus(const struct cpumask *mask, u32 msr_no, struct msr *msrs)
-{
-	__rwmsr_on_cpus(mask, msr_no, msrs, __wrmsr_on_cpu);
-}
-EXPORT_SYMBOL(wrmsr_on_cpus);
-
 struct msr *msrs_alloc(void)
 {
 	struct msr *msrs = NULL;
@@ -137,100 +21,3 @@ void msrs_free(struct msr *msrs)
 	free_percpu(msrs);
 }
 EXPORT_SYMBOL(msrs_free);
-
-/* These "safe" variants are slower and should be used when the target MSR
-   may not actually exist. */
-static void __rdmsr_safe_on_cpu(void *info)
-{
-	struct msr_info *rv = info;
-
-	rv->err = rdmsr_safe(rv->msr_no, &rv->reg.l, &rv->reg.h);
-}
-
-static void __wrmsr_safe_on_cpu(void *info)
-{
-	struct msr_info *rv = info;
-
-	rv->err = wrmsr_safe(rv->msr_no, rv->reg.l, rv->reg.h);
-}
-
-int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
-{
-	int err;
-	struct msr_info rv;
-
-	memset(&rv, 0, sizeof(rv));
-
-	rv.msr_no = msr_no;
-	err = smp_call_function_single(cpu, __rdmsr_safe_on_cpu, &rv, 1);
-	*l = rv.reg.l;
-	*h = rv.reg.h;
-
-	return err ? err : rv.err;
-}
-EXPORT_SYMBOL(rdmsr_safe_on_cpu);
-
-int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
-{
-	int err;
-	struct msr_info rv;
-
-	memset(&rv, 0, sizeof(rv));
-
-	rv.msr_no = msr_no;
-	rv.reg.l = l;
-	rv.reg.h = h;
-	err = smp_call_function_single(cpu, __wrmsr_safe_on_cpu, &rv, 1);
-
-	return err ? err : rv.err;
-}
-EXPORT_SYMBOL(wrmsr_safe_on_cpu);
-
-/*
- * These variants are significantly slower, but allows control over
- * the entire 32-bit GPR set.
- */
-struct msr_regs_info {
-	u32 *regs;
-	int err;
-};
-
-static void __rdmsr_safe_regs_on_cpu(void *info)
-{
-	struct msr_regs_info *rv = info;
-
-	rv->err = rdmsr_safe_regs(rv->regs);
-}
-
-static void __wrmsr_safe_regs_on_cpu(void *info)
-{
-	struct msr_regs_info *rv = info;
-
-	rv->err = wrmsr_safe_regs(rv->regs);
-}
-
-int rdmsr_safe_regs_on_cpu(unsigned int cpu, u32 *regs)
-{
-	int err;
-	struct msr_regs_info rv;
-
-	rv.regs   = regs;
-	rv.err    = -EIO;
-	err = smp_call_function_single(cpu, __rdmsr_safe_regs_on_cpu, &rv, 1);
-
-	return err ? err : rv.err;
-}
-EXPORT_SYMBOL(rdmsr_safe_regs_on_cpu);
-
-int wrmsr_safe_regs_on_cpu(unsigned int cpu, u32 *regs)
-{
-	int err;
-	struct msr_regs_info rv;
-
-	rv.regs = regs;
-	rv.err  = -EIO;
-	err = smp_call_function_single(cpu, __wrmsr_safe_regs_on_cpu, &rv, 1);
-
-	return err ? err : rv.err;
-}
-EXPORT_SYMBOL(wrmsr_safe_regs_on_cpu);
diff --git a/arch/x86/mm/srat_32.c b/arch/x86/mm/srat_32.c
index 6f8aa33..9324f13 100644
--- a/arch/x86/mm/srat_32.c
+++ b/arch/x86/mm/srat_32.c
@@ -267,6 +267,8 @@ int __init get_memcfg_from_srat(void)
 		e820_register_active_regions(chunk->nid, chunk->start_pfn,
 					     min(chunk->end_pfn, max_pfn));
 	}
+	/* for out of order entries in SRAT */
+	sort_node_map();
 
 	for_each_online_node(nid) {
 		unsigned long start = node_start_pfn[nid];
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index d890754..a271241 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -317,7 +317,7 @@ static int __init nodes_cover_memory(const struct bootnode *nodes)
 		unsigned long s = nodes[i].start >> PAGE_SHIFT;
 		unsigned long e = nodes[i].end >> PAGE_SHIFT;
 		pxmram += e - s;
-		pxmram -= absent_pages_in_range(s, e);
+		pxmram -= __absent_pages_in_range(i, s, e);
 		if ((long)pxmram < 0)
 			pxmram = 0;
 	}
@@ -373,6 +373,8 @@ int __init acpi_scan_nodes(unsigned long start, unsigned long end)
 	for_each_node_mask(i, nodes_parsed)
 		e820_register_active_regions(i, nodes[i].start >> PAGE_SHIFT,
 						nodes[i].end >> PAGE_SHIFT);
+	/* for out of order entries in SRAT */
+	sort_node_map();
 	if (!nodes_cover_memory(nodes)) {
 		bad_srat();
 		return -1;
diff --git a/arch/x86/tools/chkobjdump.awk b/arch/x86/tools/chkobjdump.awk
index 0d13cd9..5bbb5a3 100644
--- a/arch/x86/tools/chkobjdump.awk
+++ b/arch/x86/tools/chkobjdump.awk
@@ -9,7 +9,7 @@ BEGIN {
 }
 
 /^GNU/ {
-	split($4, ver, ".");
+	split($3, ver, ".");
 	if (ver[1] > od_ver ||
 	    (ver[1] == od_ver && ver[2] >= od_sver)) {
 		exit 1;
diff --git a/arch/x86/tools/gen-insn-attr-x86.awk b/arch/x86/tools/gen-insn-attr-x86.awk
index 7a68506..eaf11f5 100644
--- a/arch/x86/tools/gen-insn-attr-x86.awk
+++ b/arch/x86/tools/gen-insn-attr-x86.awk
@@ -6,8 +6,6 @@
 
 # Awk implementation sanity check
 function check_awk_implement() {
-	if (!match("abc", "[[:lower:]]+"))
-		return "Your awk doesn't support charactor-class."
 	if (sprintf("%x", 0) != "0")
 		return "Your awk has a printf-format problem."
 	return ""
@@ -44,12 +42,12 @@ BEGIN {
 	delete gtable
 	delete atable
 
-	opnd_expr = "^[[:alpha:]/]"
+	opnd_expr = "^[A-Za-z/]"
 	ext_expr = "^\\("
 	sep_expr = "^\\|$"
-	group_expr = "^Grp[[:alnum:]]+"
+	group_expr = "^Grp[0-9A-Za-z]+"
 
-	imm_expr = "^[IJAO][[:lower:]]"
+	imm_expr = "^[IJAO][a-z]"
 	imm_flag["Ib"] = "INAT_MAKE_IMM(INAT_IMM_BYTE)"
 	imm_flag["Jb"] = "INAT_MAKE_IMM(INAT_IMM_BYTE)"
 	imm_flag["Iw"] = "INAT_MAKE_IMM(INAT_IMM_WORD)"
@@ -62,7 +60,7 @@ BEGIN {
 	imm_flag["Ob"] = "INAT_MOFFSET"
 	imm_flag["Ov"] = "INAT_MOFFSET"
 
-	modrm_expr = "^([CDEGMNPQRSUVW/][[:lower:]]+|NTA|T[012])"
+	modrm_expr = "^([CDEGMNPQRSUVW/][a-z]+|NTA|T[012])"
 	force64_expr = "\\([df]64\\)"
 	rex_expr = "^REX(\\.[XRWB]+)*"
 	fpu_expr = "^ESC" # TODO
diff --git a/include/linux/decompress/mm.h b/include/linux/decompress/mm.h
index 12ff8c3..5032b9a 100644
--- a/include/linux/decompress/mm.h
+++ b/include/linux/decompress/mm.h
@@ -25,7 +25,7 @@ static void *malloc(int size)
 	void *p;
 
 	if (size < 0)
-		error("Malloc error");
+		return NULL;
 	if (!malloc_ptr)
 		malloc_ptr = free_mem_ptr;
 
@@ -35,7 +35,7 @@ static void *malloc(int size)
 	malloc_ptr += size;
 
 	if (free_mem_end_ptr && malloc_ptr >= free_mem_end_ptr)
-		error("Out of memory");
+		return NULL;
 
 	malloc_count++;
 	return p;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 24c3956..20a2036 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1022,6 +1022,9 @@ extern void add_active_range(unsigned int nid, unsigned long start_pfn,
 extern void remove_active_range(unsigned int nid, unsigned long start_pfn,
 					unsigned long end_pfn);
 extern void remove_all_active_ranges(void);
+void sort_node_map(void);
+unsigned long __absent_pages_in_range(int nid, unsigned long start_pfn,
+						unsigned long end_pfn);
 extern unsigned long absent_pages_in_range(unsigned long start_pfn,
 						unsigned long end_pfn);
 extern void get_pfn_range_for_nid(unsigned int nid,
diff --git a/init/initramfs.c b/init/initramfs.c
index 4c00edc..b37d34b 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -413,7 +413,7 @@ static unsigned my_inptr;   /* index of next byte to be processed in inbuf */
 
 static char * __init unpack_to_rootfs(char *buf, unsigned len)
 {
-	int written;
+	int written, res;
 	decompress_fn decompress;
 	const char *compress_name;
 	static __initdata char msg_buf[64];
@@ -445,10 +445,12 @@ static char * __init unpack_to_rootfs(char *buf, unsigned len)
 		}
 		this_header = 0;
 		decompress = decompress_method(buf, len, &compress_name);
-		if (decompress)
-			decompress(buf, len, NULL, flush_buffer, NULL,
+		if (decompress) {
+			res = decompress(buf, len, NULL, flush_buffer, NULL,
 				   &my_inptr, error);
-		else if (compress_name) {
+			if (res)
+				error("decompressor failed");
+		} else if (compress_name) {
 			if (!message) {
 				snprintf(msg_buf, sizeof msg_buf,
 					 "compression method %s not configured",
diff --git a/lib/decompress_bunzip2.c b/lib/decompress_bunzip2.c
index 7607420..a4e971d 100644
--- a/lib/decompress_bunzip2.c
+++ b/lib/decompress_bunzip2.c
@@ -637,6 +637,8 @@ static int INIT start_bunzip(struct bunzip_data **bdp, void *inbuf, int len,
 
 	/* Allocate bunzip_data.  Most fields initialize to zero. */
 	bd = *bdp = malloc(i);
+	if (!bd)
+		return RETVAL_OUT_OF_MEMORY;
 	memset(bd, 0, sizeof(struct bunzip_data));
 	/* Setup input buffer */
 	bd->inbuf = inbuf;
@@ -664,6 +666,8 @@ static int INIT start_bunzip(struct bunzip_data **bdp, void *inbuf, int len,
 	bd->dbufSize = 100000*(i-BZh0);
 
 	bd->dbuf = large_malloc(bd->dbufSize * sizeof(int));
+	if (!bd->dbuf)
+		return RETVAL_OUT_OF_MEMORY;
 	return RETVAL_OK;
 }
 
@@ -686,7 +690,7 @@ STATIC int INIT bunzip2(unsigned char *buf, int len,
 
 	if (!outbuf) {
 		error("Could not allocate output bufer");
-		return -1;
+		return RETVAL_OUT_OF_MEMORY;
 	}
 	if (buf)
 		inbuf = buf;
@@ -694,6 +698,7 @@ STATIC int INIT bunzip2(unsigned char *buf, int len,
 		inbuf = malloc(BZIP2_IOBUF_SIZE);
 	if (!inbuf) {
 		error("Could not allocate input bufer");
+		i = RETVAL_OUT_OF_MEMORY;
 		goto exit_0;
 	}
 	i = start_bunzip(&bd, inbuf, len, fill);
@@ -720,11 +725,14 @@ STATIC int INIT bunzip2(unsigned char *buf, int len,
 	} else if (i == RETVAL_UNEXPECTED_OUTPUT_EOF) {
 		error("Compressed file ends unexpectedly");
 	}
+	if (!bd)
+		goto exit_1;
 	if (bd->dbuf)
 		large_free(bd->dbuf);
 	if (pos)
 		*pos = bd->inbufPos;
 	free(bd);
+exit_1:
 	if (!buf)
 		free(inbuf);
 exit_0:
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2bc2ac6..873c863 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3573,7 +3573,7 @@ static unsigned long __meminit zone_spanned_pages_in_node(int nid,
  * Return the number of holes in a range on a node. If nid is MAX_NUMNODES,
  * then all holes in the requested range will be accounted for.
  */
-static unsigned long __meminit __absent_pages_in_range(int nid,
+unsigned long __meminit __absent_pages_in_range(int nid,
 				unsigned long range_start_pfn,
 				unsigned long range_end_pfn)
 {
@@ -4102,7 +4102,7 @@ static int __init cmp_node_active_region(const void *a, const void *b)
 }
 
 /* sort the node_map by start_pfn */
-static void __init sort_node_map(void)
+void __init sort_node_map(void)
 {
 	sort(early_node_map, (size_t)nr_nodemap_entries,
 			sizeof(struct node_active_region),
