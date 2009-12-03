Return-Path: <linux-kernel-owner+w=401wt.eu-S1753363AbZLCVGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbZLCVGp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 16:06:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbZLCVGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 16:06:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59001 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbZLCVGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 16:06:41 -0500
Date: Thu, 3 Dec 2009 22:06:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/mm for v2.6.33
Message-ID: <20091203210630.GA14850@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-mm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-mm-for-linus


out-of-topic modifications in x86-mm-for-linus:
-----------------------------------------------
drivers/acpi/numa.c                # 8716273: x86: Export srat physical topolog

 Thanks,

	Ingo

------------------>
Alexander Potashev (1):
      x86, boot: Simplify setting of the PAE bit

Cliff Wickman (1):
      x86: SGI UV: Fix BAU initialization

David Rientjes (4):
      x86: Clean up and add missing log levels for k8
      x86: Export k8 physical topology
      x86: Export srat physical topology
      x86: Interleave emulated nodes over physical nodes

H. Peter Anvin (10):
      x86-32: Use symbolic constants, safer CPUID when enabling EFER.NX
      x86, sleep: Always save the value of EFER
      x86, pageattr: Make set_memory_(x|nx) aware of NX support
      x86, mm: Clean up and simplify NX enablement
      x86: remove "extern" from function prototypes in <asm/proto.h>
      x86, mm: Call is_untracked_pat_range() rather than is_ISA_range()
      x86, mm: is_untracked_pat_range() takes a normal semiclosed range
      x86: Change is_ISA_range() into an inline function
      x86, platform: Change is_untracked_pat_range() to bool; cleanup init
      x86, mm: Correct the implementation of is_untracked_pat_range()

Jack Steiner (1):
      x86: UV SGI: Don't track GRU space in PAT

Jan Beulich (1):
      x86: Eliminate redundant/contradicting cache line size config options

Kees Cook (1):
      x86, mm: Report state of NX protections during boot

Minchan Kim (1):
      x86: Remove pfn in add_one_highpage_init()

Randy Dunlap (1):
      x86: k8.h: Add struct bootnode

Steven Rostedt (1):
      tracing: allow to change permissions for text with dynamic ftrace enabled

Suresh Siddha (6):
      x86-64: preserve large page mapping for 1st 2MB kernel txt with CONFIG_DEBUG_RODATA
      x86-64: align RODATA kernel section to 2MB with CONFIG_DEBUG_RODATA
      x86-64: add comment for RODATA large page retainment
      x86, cpa: Fix kernel text RO checks in static_protection()
      x86_64, ftrace: Make ftrace use kernel identity mapping to modify code
      x86_64, cpa: Use only text section in set_kernel_text_rw/ro

Xiaotian Feng (1):
      x86/pat: Trivial: don't create debugfs for memtype if pat is disabled

Yinghai Lu (7):
      x86: Make sure wakeup trampoline code is below 1MB
      x86: When cleaning MTRRs, do not fold WP into UC
      x86: Change crash kernel to reserve via reserve_early()
      x86, numa, bootmem: Only free bootmem on NUMA failure path
      x86, numa: Use near(er) online node instead of roundrobin for NUMA
      x86: Move find_smp_config() earlier and avoid bootmem usage
      x86, mtrr: Fix sorting of mtrr after subtracting


 arch/x86/Kconfig.cpu                   |   14 +-
 arch/x86/boot/compressed/head_64.S     |    3 +-
 arch/x86/boot/compressed/vmlinux.lds.S |    3 +-
 arch/x86/include/asm/acpi.h            |    3 +-
 arch/x86/include/asm/cache.h           |    7 +-
 arch/x86/include/asm/cacheflush.h      |    1 +
 arch/x86/include/asm/e820.h            |   23 ++-
 arch/x86/include/asm/k8.h              |    5 +-
 arch/x86/include/asm/mpspec.h          |   11 +-
 arch/x86/include/asm/page_types.h      |    3 +-
 arch/x86/include/asm/pgtable.h         |    6 +-
 arch/x86/include/asm/proto.h           |   17 +-
 arch/x86/include/asm/sections.h        |    6 +
 arch/x86/include/asm/x86_init.h        |    4 +-
 arch/x86/kernel/acpi/sleep.c           |   24 ++--
 arch/x86/kernel/apic/numaq_32.c        |    5 -
 arch/x86/kernel/apic/x2apic_uv_x.c     |   19 +++-
 arch/x86/kernel/cpu/common.c           |    2 +-
 arch/x86/kernel/cpu/intel.c            |    6 +-
 arch/x86/kernel/cpu/mtrr/cleanup.c     |   51 +++++--
 arch/x86/kernel/ftrace.c               |   17 ++
 arch/x86/kernel/head_32.S              |   18 ++-
 arch/x86/kernel/head_64.S              |    3 +-
 arch/x86/kernel/machine_kexec_32.c     |    6 +-
 arch/x86/kernel/mpparse.c              |   44 ++----
 arch/x86/kernel/setup.c                |  106 ++++++--------
 arch/x86/kernel/tlb_uv.c               |    4 +-
 arch/x86/kernel/visws_quirks.c         |    2 +-
 arch/x86/kernel/vmlinux.lds.S          |   38 ++++-
 arch/x86/kernel/x86_init.c             |    2 +
 arch/x86/mm/init.c                     |    4 -
 arch/x86/mm/init_32.c                  |   10 +-
 arch/x86/mm/init_64.c                  |   35 ++++-
 arch/x86/mm/k8topology_64.c            |  101 +++++++------
 arch/x86/mm/numa_32.c                  |    4 +-
 arch/x86/mm/numa_64.c                  |  252 +++++++++++++++++++++++++++-----
 arch/x86/mm/pageattr.c                 |   22 +++
 arch/x86/mm/pat.c                      |   13 +-
 arch/x86/mm/setup_nx.c                 |   59 +++-----
 arch/x86/mm/srat_64.c                  |   29 +++-
 arch/x86/mm/tlb.c                      |    3 +-
 arch/x86/xen/enlighten.c               |    4 +-
 drivers/acpi/numa.c                    |   10 +-
 43 files changed, 656 insertions(+), 343 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index f2824fb..621f2bd 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -301,15 +301,11 @@ config X86_CPU
 
 #
 # Define implied options from the CPU selection here
-config X86_L1_CACHE_BYTES
+config X86_INTERNODE_CACHE_SHIFT
 	int
-	default "128" if MPSC
-	default "64" if GENERIC_CPU || MK8 || MCORE2 || MATOM || X86_32
-
-config X86_INTERNODE_CACHE_BYTES
-	int
-	default "4096" if X86_VSMP
-	default X86_L1_CACHE_BYTES if !X86_VSMP
+	default "12" if X86_VSMP
+	default "7" if NUMA
+	default X86_L1_CACHE_SHIFT
 
 config X86_CMPXCHG
 	def_bool X86_64 || (X86_32 && !M386)
@@ -317,9 +313,9 @@ config X86_CMPXCHG
 config X86_L1_CACHE_SHIFT
 	int
 	default "7" if MPENTIUM4 || MPSC
+	default "6" if MK7 || MK8 || MPENTIUMM || MCORE2 || MATOM || MVIAC7 || X86_GENERIC || GENERIC_CPU
 	default "4" if X86_ELAN || M486 || M386 || MGEODEGX1
 	default "5" if MWINCHIP3D || MWINCHIPC6 || MCRUSOE || MEFFICEON || MCYRIXIII || MK6 || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || M586 || MVIAC3_2 || MGEODE_LX
-	default "6" if MK7 || MK8 || MPENTIUMM || MCORE2 || MATOM || MVIAC7 || X86_GENERIC || GENERIC_CPU
 
 config X86_XADD
 	def_bool y
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 077e1b6..faff0dc 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -107,8 +107,7 @@ ENTRY(startup_32)
 	lgdt	gdt(%ebp)
 
 	/* Enable PAE mode */
-	xorl	%eax, %eax
-	orl	$(X86_CR4_PAE), %eax
+	movl	$(X86_CR4_PAE), %eax
 	movl	%eax, %cr4
 
  /*
diff --git a/arch/x86/boot/compressed/vmlinux.lds.S b/arch/x86/boot/compressed/vmlinux.lds.S
index f4193bb..a6f1a59 100644
--- a/arch/x86/boot/compressed/vmlinux.lds.S
+++ b/arch/x86/boot/compressed/vmlinux.lds.S
@@ -4,6 +4,7 @@ OUTPUT_FORMAT(CONFIG_OUTPUT_FORMAT, CONFIG_OUTPUT_FORMAT, CONFIG_OUTPUT_FORMAT)
 
 #undef i386
 
+#include <asm/cache.h>
 #include <asm/page_types.h>
 
 #ifdef CONFIG_X86_64
@@ -46,7 +47,7 @@ SECTIONS
 		*(.data.*)
 		_edata = . ;
 	}
-	. = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
+	. = ALIGN(L1_CACHE_BYTES);
 	.bss : {
 		_bss = . ;
 		*(.bss)
diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index 4518dc5..60d2b2d 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -118,7 +118,7 @@ extern void acpi_restore_state_mem(void);
 extern unsigned long acpi_wakeup_address;
 
 /* early initialization routine */
-extern void acpi_reserve_bootmem(void);
+extern void acpi_reserve_wakeup_memory(void);
 
 /*
  * Check if the CPU can handle C2 and deeper
@@ -158,6 +158,7 @@ struct bootnode;
 
 #ifdef CONFIG_ACPI_NUMA
 extern int acpi_numa;
+extern int acpi_get_nodes(struct bootnode *physnodes);
 extern int acpi_scan_nodes(unsigned long start, unsigned long end);
 #define NR_NODE_MEMBLKS (MAX_NUMNODES*2)
 extern void acpi_fake_nodes(const struct bootnode *fake_nodes,
diff --git a/arch/x86/include/asm/cache.h b/arch/x86/include/asm/cache.h
index 549860d..2f9047c 100644
--- a/arch/x86/include/asm/cache.h
+++ b/arch/x86/include/asm/cache.h
@@ -9,12 +9,13 @@
 
 #define __read_mostly __attribute__((__section__(".data.read_mostly")))
 
+#define INTERNODE_CACHE_SHIFT CONFIG_X86_INTERNODE_CACHE_SHIFT
+#define INTERNODE_CACHE_BYTES (1 << INTERNODE_CACHE_SHIFT)
+
 #ifdef CONFIG_X86_VSMP
-/* vSMP Internode cacheline shift */
-#define INTERNODE_CACHE_SHIFT (12)
 #ifdef CONFIG_SMP
 #define __cacheline_aligned_in_smp					\
-	__attribute__((__aligned__(1 << (INTERNODE_CACHE_SHIFT))))	\
+	__attribute__((__aligned__(INTERNODE_CACHE_BYTES)))		\
 	__page_aligned_data
 #endif
 #endif
diff --git a/arch/x86/include/asm/cacheflush.h b/arch/x86/include/asm/cacheflush.h
index b54f6af..eebb2cd 100644
--- a/arch/x86/include/asm/cacheflush.h
+++ b/arch/x86/include/asm/cacheflush.h
@@ -176,6 +176,7 @@ void clflush_cache_range(void *addr, unsigned int size);
 #ifdef CONFIG_DEBUG_RODATA
 void mark_rodata_ro(void);
 extern const int rodata_test_data;
+extern int kernel_set_to_readonly;
 void set_kernel_text_rw(void);
 void set_kernel_text_ro(void);
 #else
diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
index 40b4e61..761249e 100644
--- a/arch/x86/include/asm/e820.h
+++ b/arch/x86/include/asm/e820.h
@@ -61,6 +61,12 @@ struct e820map {
 	struct e820entry map[E820_X_MAX];
 };
 
+#define ISA_START_ADDRESS	0xa0000
+#define ISA_END_ADDRESS		0x100000
+
+#define BIOS_BEGIN		0x000a0000
+#define BIOS_END		0x00100000
+
 #ifdef __KERNEL__
 /* see comment in arch/x86/kernel/e820.c */
 extern struct e820map e820;
@@ -126,15 +132,18 @@ extern void e820_reserve_resources(void);
 extern void e820_reserve_resources_late(void);
 extern void setup_memory_map(void);
 extern char *default_machine_specific_memory_setup(void);
-#endif /* __KERNEL__ */
-#endif /* __ASSEMBLY__ */
 
-#define ISA_START_ADDRESS	0xa0000
-#define ISA_END_ADDRESS		0x100000
-#define is_ISA_range(s, e) ((s) >= ISA_START_ADDRESS && (e) < ISA_END_ADDRESS)
+/*
+ * Returns true iff the specified range [s,e) is completely contained inside
+ * the ISA region.
+ */
+static inline bool is_ISA_range(u64 s, u64 e)
+{
+	return s >= ISA_START_ADDRESS && e <= ISA_END_ADDRESS;
+}
 
-#define BIOS_BEGIN		0x000a0000
-#define BIOS_END		0x00100000
+#endif /* __KERNEL__ */
+#endif /* __ASSEMBLY__ */
 
 #ifdef __KERNEL__
 #include <linux/ioport.h>
diff --git a/arch/x86/include/asm/k8.h b/arch/x86/include/asm/k8.h
index c2d1f3b..f70e600 100644
--- a/arch/x86/include/asm/k8.h
+++ b/arch/x86/include/asm/k8.h
@@ -4,13 +4,16 @@
 #include <linux/pci.h>
 
 extern struct pci_device_id k8_nb_ids[];
+struct bootnode;
 
 extern int early_is_k8_nb(u32 value);
 extern struct pci_dev **k8_northbridges;
 extern int num_k8_northbridges;
 extern int cache_k8_northbridges(void);
 extern void k8_flush_garts(void);
-extern int k8_scan_nodes(unsigned long start, unsigned long end);
+extern int k8_get_nodes(struct bootnode *nodes);
+extern int k8_numa_init(unsigned long start_pfn, unsigned long end_pfn);
+extern int k8_scan_nodes(void);
 
 #ifdef CONFIG_K8_NB
 static inline struct pci_dev *node_to_k8_nb_misc(int node)
diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index 79c9450..644cf1a 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -71,12 +71,7 @@ static inline void early_get_smp_config(void)
 
 static inline void find_smp_config(void)
 {
-	x86_init.mpparse.find_smp_config(1);
-}
-
-static inline void early_find_smp_config(void)
-{
-	x86_init.mpparse.find_smp_config(0);
+	x86_init.mpparse.find_smp_config();
 }
 
 #ifdef CONFIG_X86_MPPARSE
@@ -89,7 +84,7 @@ extern void default_mpc_oem_bus_info(struct mpc_bus *m, char *str);
 # else
 #  define default_mpc_oem_bus_info NULL
 # endif
-extern void default_find_smp_config(unsigned int reserve);
+extern void default_find_smp_config(void);
 extern void default_get_smp_config(unsigned int early);
 #else
 static inline void early_reserve_e820_mpc_new(void) { }
@@ -97,7 +92,7 @@ static inline void early_reserve_e820_mpc_new(void) { }
 #define default_mpc_apic_id NULL
 #define default_smp_read_mpc_oem NULL
 #define default_mpc_oem_bus_info NULL
-#define default_find_smp_config x86_init_uint_noop
+#define default_find_smp_config x86_init_noop
 #define default_get_smp_config x86_init_uint_noop
 #endif
 
diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
index 6473f5c..642fe34 100644
--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -49,7 +49,8 @@ extern unsigned long max_pfn_mapped;
 extern unsigned long init_memory_mapping(unsigned long start,
 					 unsigned long end);
 
-extern void initmem_init(unsigned long start_pfn, unsigned long end_pfn);
+extern void initmem_init(unsigned long start_pfn, unsigned long end_pfn,
+				int acpi, int k8);
 extern void free_initmem(void);
 
 #endif	/* !__ASSEMBLY__ */
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index af6fd36..a34c785 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -16,6 +16,8 @@
 
 #ifndef __ASSEMBLY__
 
+#include <asm/x86_init.h>
+
 /*
  * ZERO_PAGE is a global shared page that is always zero: used
  * for zero-mapped memory areas etc..
@@ -270,9 +272,9 @@ static inline int is_new_memtype_allowed(u64 paddr, unsigned long size,
 					 unsigned long new_flags)
 {
 	/*
-	 * PAT type is always WB for ISA. So no need to check.
+	 * PAT type is always WB for untracked ranges, so no need to check.
 	 */
-	if (is_ISA_range(paddr, paddr + size - 1))
+	if (x86_platform.is_untracked_pat_range(paddr, paddr + size))
 		return 1;
 
 	/*
diff --git a/arch/x86/include/asm/proto.h b/arch/x86/include/asm/proto.h
index 621f56d..4009f65 100644
--- a/arch/x86/include/asm/proto.h
+++ b/arch/x86/include/asm/proto.h
@@ -5,18 +5,19 @@
 
 /* misc architecture specific prototypes */
 
-extern void early_idt_handler(void);
+void early_idt_handler(void);
 
-extern void system_call(void);
-extern void syscall_init(void);
+void system_call(void);
+void syscall_init(void);
 
-extern void ia32_syscall(void);
-extern void ia32_cstar_target(void);
-extern void ia32_sysenter_target(void);
+void ia32_syscall(void);
+void ia32_cstar_target(void);
+void ia32_sysenter_target(void);
 
-extern void syscall32_cpu_init(void);
+void syscall32_cpu_init(void);
 
-extern void check_efer(void);
+void x86_configure_nx(void);
+void x86_report_nx(void);
 
 extern int reboot_force;
 
diff --git a/arch/x86/include/asm/sections.h b/arch/x86/include/asm/sections.h
index 1b7ee5d..0a52424 100644
--- a/arch/x86/include/asm/sections.h
+++ b/arch/x86/include/asm/sections.h
@@ -2,7 +2,13 @@
 #define _ASM_X86_SECTIONS_H
 
 #include <asm-generic/sections.h>
+#include <asm/uaccess.h>
 
 extern char __brk_base[], __brk_limit[];
+extern struct exception_table_entry __stop___ex_table[];
+
+#if defined(CONFIG_X86_64) && defined(CONFIG_DEBUG_RODATA)
+extern char __end_rodata_hpage_align[];
+#endif
 
 #endif	/* _ASM_X86_SECTIONS_H */
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 2c756fd..97e5fb4 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -26,7 +26,7 @@ struct x86_init_mpparse {
 	void (*smp_read_mpc_oem)(struct mpc_table *mpc);
 	void (*mpc_oem_pci_bus)(struct mpc_bus *m);
 	void (*mpc_oem_bus_info)(struct mpc_bus *m, char *name);
-	void (*find_smp_config)(unsigned int reserve);
+	void (*find_smp_config)(void);
 	void (*get_smp_config)(unsigned int early);
 };
 
@@ -116,11 +116,13 @@ struct x86_cpuinit_ops {
  * @calibrate_tsc:		calibrate TSC
  * @get_wallclock:		get time from HW clock like RTC etc.
  * @set_wallclock:		set time back to HW clock
+ * @is_untracked_pat_range	exclude from PAT logic
  */
 struct x86_platform_ops {
 	unsigned long (*calibrate_tsc)(void);
 	unsigned long (*get_wallclock)(void);
 	int (*set_wallclock)(unsigned long nowtime);
+	bool (*is_untracked_pat_range)(u64 start, u64 end);
 };
 
 extern struct x86_init_ops x86_init;
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index ca93638..82e5086 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -78,12 +78,9 @@ int acpi_save_state_mem(void)
 #ifndef CONFIG_64BIT
 	store_gdt((struct desc_ptr *)&header->pmode_gdt);
 
-	header->pmode_efer_low = nx_enabled;
-	if (header->pmode_efer_low & 1) {
-		/* This is strange, why not save efer, always? */
-		rdmsr(MSR_EFER, header->pmode_efer_low,
-			header->pmode_efer_high);
-	}
+	if (rdmsr_safe(MSR_EFER, &header->pmode_efer_low,
+		       &header->pmode_efer_high))
+		header->pmode_efer_low = header->pmode_efer_high = 0;
 #endif /* !CONFIG_64BIT */
 
 	header->pmode_cr0 = read_cr0();
@@ -119,29 +116,32 @@ void acpi_restore_state_mem(void)
 
 
 /**
- * acpi_reserve_bootmem - do _very_ early ACPI initialisation
+ * acpi_reserve_wakeup_memory - do _very_ early ACPI initialisation
  *
  * We allocate a page from the first 1MB of memory for the wakeup
  * routine for when we come back from a sleep state. The
  * runtime allocator allows specification of <16MB pages, but not
  * <1MB pages.
  */
-void __init acpi_reserve_bootmem(void)
+void __init acpi_reserve_wakeup_memory(void)
 {
+	unsigned long mem;
+
 	if ((&wakeup_code_end - &wakeup_code_start) > WAKEUP_SIZE) {
 		printk(KERN_ERR
 		       "ACPI: Wakeup code way too big, S3 disabled.\n");
 		return;
 	}
 
-	acpi_realmode = (unsigned long)alloc_bootmem_low(WAKEUP_SIZE);
+	mem = find_e820_area(0, 1<<20, WAKEUP_SIZE, PAGE_SIZE);
 
-	if (!acpi_realmode) {
+	if (mem == -1L) {
 		printk(KERN_ERR "ACPI: Cannot allocate lowmem, S3 disabled.\n");
 		return;
 	}
-
-	acpi_wakeup_address = virt_to_phys((void *)acpi_realmode);
+	acpi_realmode = (unsigned long) phys_to_virt(mem);
+	acpi_wakeup_address = mem;
+	reserve_early(mem, mem + WAKEUP_SIZE, "ACPI WAKEUP");
 }
 
 
diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index efa00e2..9c0629c 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -264,11 +264,6 @@ static void __init smp_read_mpc_oem(struct mpc_table *mpc)
 static __init void early_check_numaq(void)
 {
 	/*
-	 * Find possible boot-time SMP configuration:
-	 */
-	early_find_smp_config();
-
-	/*
 	 * get boot-time SMP configuration:
 	 */
 	if (smp_found_config)
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index f5f5886..1e09417 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -30,10 +30,22 @@
 #include <asm/apic.h>
 #include <asm/ipi.h>
 #include <asm/smp.h>
+#include <asm/x86_init.h>
 
 DEFINE_PER_CPU(int, x2apic_extra_bits);
 
 static enum uv_system_type uv_system_type;
+static u64 gru_start_paddr, gru_end_paddr;
+
+static inline bool is_GRU_range(u64 start, u64 end)
+{
+	return start >= gru_start_paddr && end <= gru_end_paddr;
+}
+
+static bool uv_is_untracked_pat_range(u64 start, u64 end)
+{
+	return is_ISA_range(start, end) || is_GRU_range(start, end);
+}
 
 static int early_get_nodeid(void)
 {
@@ -49,6 +61,7 @@ static int early_get_nodeid(void)
 static int __init uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	if (!strcmp(oem_id, "SGI")) {
+		x86_platform.is_untracked_pat_range =  uv_is_untracked_pat_range;
 		if (!strcmp(oem_table_id, "UVL"))
 			uv_system_type = UV_LEGACY_APIC;
 		else if (!strcmp(oem_table_id, "UVX"))
@@ -385,8 +398,12 @@ static __init void map_gru_high(int max_pnode)
 	int shift = UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR_BASE_SHFT;
 
 	gru.v = uv_read_local_mmr(UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR);
-	if (gru.s.enable)
+	if (gru.s.enable) {
 		map_high("GRU", gru.s.base, shift, max_pnode, map_wb);
+		gru_start_paddr = ((u64)gru.s.base << shift);
+		gru_end_paddr = gru_start_paddr + (1UL << shift) * (max_pnode + 1);
+
+	}
 }
 
 static __init void map_mmr_high(int max_pnode)
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index cc25c2b..18346da 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1136,7 +1136,7 @@ void __cpuinit cpu_init(void)
 	wrmsrl(MSR_KERNEL_GS_BASE, 0);
 	barrier();
 
-	check_efer();
+	x86_configure_nx();
 	if (cpu != 0)
 		enable_x2apic();
 
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 40e1835..c900b73 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -263,8 +263,12 @@ static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
 	/* Don't do the funky fallback heuristics the AMD version employs
 	   for now. */
 	node = apicid_to_node[apicid];
-	if (node == NUMA_NO_NODE || !node_online(node))
+	if (node == NUMA_NO_NODE)
 		node = first_node(node_online_map);
+	else if (!node_online(node)) {
+		/* reuse the value from init_cpu_to_node() */
+		node = cpu_to_node(cpu);
+	}
 	numa_set_node(cpu, node);
 
 	printk(KERN_INFO "CPU %d/0x%x -> Node %d\n", cpu, apicid, node);
diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
index 315738c..6987af7 100644
--- a/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -170,6 +170,41 @@ static int __init cmp_range(const void *x1, const void *x2)
 	return start1 - start2;
 }
 
+static int __init clean_sort_range(struct res_range *range, int az)
+{
+	int i, j, k = az - 1, nr_range = 0;
+
+	for (i = 0; i < k; i++) {
+		if (range[i].end)
+			continue;
+		for (j = k; j > i; j--) {
+			if (range[j].end) {
+				k = j;
+				break;
+			}
+		}
+		if (j == i)
+			break;
+		range[i].start = range[k].start;
+		range[i].end   = range[k].end;
+		range[k].start = 0;
+		range[k].end   = 0;
+		k--;
+	}
+	/* count it */
+	for (i = 0; i < az; i++) {
+		if (!range[i].end) {
+			nr_range = i;
+			break;
+		}
+	}
+
+	/* sort them */
+	sort(range, nr_range, sizeof(struct res_range), cmp_range, NULL);
+
+	return nr_range;
+}
+
 #define BIOS_BUG_MSG KERN_WARNING \
 	"WARNING: BIOS bug: VAR MTRR %d contains strange UC entry under 1M, check with your system vendor!\n"
 
@@ -223,22 +258,18 @@ x86_get_mtrr_mem_range(struct res_range *range, int nr_range,
 		subtract_range(range, extra_remove_base,
 				 extra_remove_base + extra_remove_size  - 1);
 
-	/* get new range num */
-	nr_range = 0;
-	for (i = 0; i < RANGE_NUM; i++) {
-		if (!range[i].end)
-			continue;
-		nr_range++;
-	}
 	if  (debug_print) {
 		printk(KERN_DEBUG "After UC checking\n");
-		for (i = 0; i < nr_range; i++)
+		for (i = 0; i < RANGE_NUM; i++) {
+			if (!range[i].end)
+				continue;
 			printk(KERN_DEBUG "MTRR MAP PFN: %016lx - %016lx\n",
 				 range[i].start, range[i].end + 1);
+		}
 	}
 
 	/* sort the ranges */
-	sort(range, nr_range, sizeof(struct res_range), cmp_range, NULL);
+	nr_range = clean_sort_range(range, RANGE_NUM);
 	if  (debug_print) {
 		printk(KERN_DEBUG "After sorting\n");
 		for (i = 0; i < nr_range; i++)
@@ -689,8 +720,6 @@ static int __init mtrr_need_cleanup(void)
 			continue;
 		if (!size)
 			type = MTRR_NUM_TYPES;
-		if (type == MTRR_TYPE_WRPROT)
-			type = MTRR_TYPE_UNCACHABLE;
 		num[type]++;
 	}
 
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 9dbb527..944e982 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -187,9 +187,26 @@ static void wait_for_nmi(void)
 	nmi_wait_count++;
 }
 
+static inline int
+within(unsigned long addr, unsigned long start, unsigned long end)
+{
+	return addr >= start && addr < end;
+}
+
 static int
 do_ftrace_mod_code(unsigned long ip, void *new_code)
 {
+	/*
+	 * On x86_64, kernel text mappings are mapped read-only with
+	 * CONFIG_DEBUG_RODATA. So we use the kernel identity mapping instead
+	 * of the kernel text mapping to modify the kernel text.
+	 *
+	 * For 32bit kernels, these mappings are same and we can use
+	 * kernel identity mapping to modify code.
+	 */
+	if (within(ip, (unsigned long)_text, (unsigned long)_etext))
+		ip = (unsigned long)__va(__pa(ip));
+
 	mod_code_ip = (void *)ip;
 	mod_code_newcode = new_code;
 
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 050c278..7fd318b 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -18,6 +18,8 @@
 #include <asm/asm-offsets.h>
 #include <asm/setup.h>
 #include <asm/processor-flags.h>
+#include <asm/msr-index.h>
+#include <asm/cpufeature.h>
 #include <asm/percpu.h>
 
 /* Physical address */
@@ -297,25 +299,27 @@ ENTRY(startup_32_smp)
 	orl %edx,%eax
 	movl %eax,%cr4
 
-	btl $5, %eax		# check if PAE is enabled
-	jnc 6f
+	testb $X86_CR4_PAE, %al		# check if PAE is enabled
+	jz 6f
 
 	/* Check if extended functions are implemented */
 	movl $0x80000000, %eax
 	cpuid
-	cmpl $0x80000000, %eax
-	jbe 6f
+	/* Value must be in the range 0x80000001 to 0x8000ffff */
+	subl $0x80000001, %eax
+	cmpl $(0x8000ffff-0x80000001), %eax
+	ja 6f
 	mov $0x80000001, %eax
 	cpuid
 	/* Execute Disable bit supported? */
-	btl $20, %edx
+	btl $(X86_FEATURE_NX & 31), %edx
 	jnc 6f
 
 	/* Setup EFER (Extended Feature Enable Register) */
-	movl $0xc0000080, %ecx
+	movl $MSR_EFER, %ecx
 	rdmsr
 
-	btsl $11, %eax
+	btsl $_EFER_NX, %eax
 	/* Make changes effective */
 	wrmsr
 
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 780cd92..b55ee4f 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -262,11 +262,11 @@ ENTRY(secondary_startup_64)
 	.quad	x86_64_start_kernel
 	ENTRY(initial_gs)
 	.quad	INIT_PER_CPU_VAR(irq_stack_union)
-	__FINITDATA
 
 	ENTRY(stack_start)
 	.quad  init_thread_union+THREAD_SIZE-8
 	.word  0
+	__FINITDATA
 
 bad_address:
 	jmp bad_address
@@ -340,6 +340,7 @@ ENTRY(name)
 	i = i + 1 ;					\
 	.endr
 
+	.data
 	/*
 	 * This default setting generates an ident mapping at address 0x100000
 	 * and a mapping for the kernel that precisely maps virtual address
diff --git a/arch/x86/kernel/machine_kexec_32.c b/arch/x86/kernel/machine_kexec_32.c
index c1c429d..03657e7 100644
--- a/arch/x86/kernel/machine_kexec_32.c
+++ b/arch/x86/kernel/machine_kexec_32.c
@@ -157,8 +157,7 @@ int machine_kexec_prepare(struct kimage *image)
 {
 	int error;
 
-	if (nx_enabled)
-		set_pages_x(image->control_code_page, 1);
+	set_pages_x(image->control_code_page, 1);
 	error = machine_kexec_alloc_page_tables(image);
 	if (error)
 		return error;
@@ -172,8 +171,7 @@ int machine_kexec_prepare(struct kimage *image)
  */
 void machine_kexec_cleanup(struct kimage *image)
 {
-	if (nx_enabled)
-		set_pages_nx(image->control_code_page, 1);
+	set_pages_nx(image->control_code_page, 1);
 	machine_kexec_free_page_tables(image);
 }
 
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 5be95ef..35a57c9 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -667,36 +667,18 @@ void __init default_get_smp_config(unsigned int early)
 	 */
 }
 
-static void __init smp_reserve_bootmem(struct mpf_intel *mpf)
+static void __init smp_reserve_memory(struct mpf_intel *mpf)
 {
 	unsigned long size = get_mpc_size(mpf->physptr);
-#ifdef CONFIG_X86_32
-	/*
-	 * We cannot access to MPC table to compute table size yet,
-	 * as only few megabytes from the bottom is mapped now.
-	 * PC-9800's MPC table places on the very last of physical
-	 * memory; so that simply reserving PAGE_SIZE from mpf->physptr
-	 * yields BUG() in reserve_bootmem.
-	 * also need to make sure physptr is below than max_low_pfn
-	 * we don't need reserve the area above max_low_pfn
-	 */
-	unsigned long end = max_low_pfn * PAGE_SIZE;
 
-	if (mpf->physptr < end) {
-		if (mpf->physptr + size > end)
-			size = end - mpf->physptr;
-		reserve_bootmem_generic(mpf->physptr, size, BOOTMEM_DEFAULT);
-	}
-#else
-	reserve_bootmem_generic(mpf->physptr, size, BOOTMEM_DEFAULT);
-#endif
+	reserve_early(mpf->physptr, mpf->physptr+size, "MP-table mpc");
 }
 
-static int __init smp_scan_config(unsigned long base, unsigned long length,
-				  unsigned reserve)
+static int __init smp_scan_config(unsigned long base, unsigned long length)
 {
 	unsigned int *bp = phys_to_virt(base);
 	struct mpf_intel *mpf;
+	unsigned long mem;
 
 	apic_printk(APIC_VERBOSE, "Scan SMP from %p for %ld bytes.\n",
 			bp, length);
@@ -717,12 +699,10 @@ static int __init smp_scan_config(unsigned long base, unsigned long length,
 			printk(KERN_INFO "found SMP MP-table at [%p] %llx\n",
 			       mpf, (u64)virt_to_phys(mpf));
 
-			if (!reserve)
-				return 1;
-			reserve_bootmem_generic(virt_to_phys(mpf), sizeof(*mpf),
-						BOOTMEM_DEFAULT);
+			mem = virt_to_phys(mpf);
+			reserve_early(mem, mem + sizeof(*mpf), "MP-table mpf");
 			if (mpf->physptr)
-				smp_reserve_bootmem(mpf);
+				smp_reserve_memory(mpf);
 
 			return 1;
 		}
@@ -732,7 +712,7 @@ static int __init smp_scan_config(unsigned long base, unsigned long length,
 	return 0;
 }
 
-void __init default_find_smp_config(unsigned int reserve)
+void __init default_find_smp_config(void)
 {
 	unsigned int address;
 
@@ -744,9 +724,9 @@ void __init default_find_smp_config(unsigned int reserve)
 	 * 2) Scan the top 1K of base RAM
 	 * 3) Scan the 64K of bios
 	 */
-	if (smp_scan_config(0x0, 0x400, reserve) ||
-	    smp_scan_config(639 * 0x400, 0x400, reserve) ||
-	    smp_scan_config(0xF0000, 0x10000, reserve))
+	if (smp_scan_config(0x0, 0x400) ||
+	    smp_scan_config(639 * 0x400, 0x400) ||
+	    smp_scan_config(0xF0000, 0x10000))
 		return;
 	/*
 	 * If it is an SMP machine we should know now, unless the
@@ -767,7 +747,7 @@ void __init default_find_smp_config(unsigned int reserve)
 
 	address = get_bios_ebda();
 	if (address)
-		smp_scan_config(address, 0x400, reserve);
+		smp_scan_config(address, 0x400);
 }
 
 #ifdef CONFIG_X86_IO_APIC
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index e09f0e2..cdb6a8a 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -106,6 +106,7 @@
 #include <asm/percpu.h>
 #include <asm/topology.h>
 #include <asm/apicdef.h>
+#include <asm/k8.h>
 #ifdef CONFIG_X86_64
 #include <asm/numa_64.h>
 #endif
@@ -486,42 +487,11 @@ static void __init reserve_early_setup_data(void)
 
 #ifdef CONFIG_KEXEC
 
-/**
- * Reserve @size bytes of crashkernel memory at any suitable offset.
- *
- * @size: Size of the crashkernel memory to reserve.
- * Returns the base address on success, and -1ULL on failure.
- */
-static
-unsigned long long __init find_and_reserve_crashkernel(unsigned long long size)
-{
-	const unsigned long long alignment = 16<<20; 	/* 16M */
-	unsigned long long start = 0LL;
-
-	while (1) {
-		int ret;
-
-		start = find_e820_area(start, ULONG_MAX, size, alignment);
-		if (start == -1ULL)
-			return start;
-
-		/* try to reserve it */
-		ret = reserve_bootmem_generic(start, size, BOOTMEM_EXCLUSIVE);
-		if (ret >= 0)
-			return start;
-
-		start += alignment;
-	}
-}
-
 static inline unsigned long long get_total_mem(void)
 {
 	unsigned long long total;
 
-	total = max_low_pfn - min_low_pfn;
-#ifdef CONFIG_HIGHMEM
-	total += highend_pfn - highstart_pfn;
-#endif
+	total = max_pfn - min_low_pfn;
 
 	return total << PAGE_SHIFT;
 }
@@ -541,21 +511,25 @@ static void __init reserve_crashkernel(void)
 
 	/* 0 means: find the address automatically */
 	if (crash_base <= 0) {
-		crash_base = find_and_reserve_crashkernel(crash_size);
+		const unsigned long long alignment = 16<<20;	/* 16M */
+
+		crash_base = find_e820_area(alignment, ULONG_MAX, crash_size,
+				 alignment);
 		if (crash_base == -1ULL) {
-			pr_info("crashkernel reservation failed. "
-				"No suitable area found.\n");
+			pr_info("crashkernel reservation failed - No suitable area found.\n");
 			return;
 		}
 	} else {
-		ret = reserve_bootmem_generic(crash_base, crash_size,
-					BOOTMEM_EXCLUSIVE);
-		if (ret < 0) {
-			pr_info("crashkernel reservation failed - "
-				"memory is in use\n");
+		unsigned long long start;
+
+		start = find_e820_area(crash_base, ULONG_MAX, crash_size,
+				 1<<20);
+		if (start != crash_base) {
+			pr_info("crashkernel reservation failed - memory is in use.\n");
 			return;
 		}
 	}
+	reserve_early(crash_base, crash_base + crash_size, "CRASH KERNEL");
 
 	printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
 			"for crashkernel (System RAM: %ldMB)\n",
@@ -691,6 +665,9 @@ static struct dmi_system_id __initdata bad_bios_dmi_table[] = {
 
 void __init setup_arch(char **cmdline_p)
 {
+	int acpi = 0;
+	int k8 = 0;
+
 #ifdef CONFIG_X86_32
 	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
 	visws_early_detect();
@@ -783,21 +760,18 @@ void __init setup_arch(char **cmdline_p)
 	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = command_line;
 
-#ifdef CONFIG_X86_64
 	/*
-	 * Must call this twice: Once just to detect whether hardware doesn't
-	 * support NX (so that the early EHCI debug console setup can safely
-	 * call set_fixmap(), and then again after parsing early parameters to
-	 * honor the respective command line option.
+	 * x86_configure_nx() is called before parse_early_param() to detect
+	 * whether hardware doesn't support NX (so that the early EHCI debug
+	 * console setup can safely call set_fixmap()). It may then be called
+	 * again from within noexec_setup() during parsing early parameters
+	 * to honor the respective command line option.
 	 */
-	check_efer();
-#endif
+	x86_configure_nx();
 
 	parse_early_param();
 
-#ifdef CONFIG_X86_64
-	check_efer();
-#endif
+	x86_report_nx();
 
 	/* Must be before kernel pagetables are setup */
 	vmi_activate();
@@ -893,6 +867,13 @@ void __init setup_arch(char **cmdline_p)
 
 	reserve_brk();
 
+#ifdef CONFIG_ACPI_SLEEP
+	/*
+	 * Reserve low memory region for sleep support.
+	 * even before init_memory_mapping
+	 */
+	acpi_reserve_wakeup_memory();
+#endif
 	init_gbpages();
 
 	/* max_pfn_mapped is updated here */
@@ -919,6 +900,8 @@ void __init setup_arch(char **cmdline_p)
 
 	reserve_initrd();
 
+	reserve_crashkernel();
+
 	vsmp_init();
 
 	io_delay_init();
@@ -930,27 +913,24 @@ void __init setup_arch(char **cmdline_p)
 
 	early_acpi_boot_init();
 
+	/*
+	 * Find and reserve possible boot-time SMP configuration:
+	 */
+	find_smp_config();
+
 #ifdef CONFIG_ACPI_NUMA
 	/*
 	 * Parse SRAT to discover nodes.
 	 */
-	acpi_numa_init();
+	acpi = acpi_numa_init();
 #endif
 
-	initmem_init(0, max_pfn);
-
-#ifdef CONFIG_ACPI_SLEEP
-	/*
-	 * Reserve low memory region for sleep support.
-	 */
-	acpi_reserve_bootmem();
+#ifdef CONFIG_K8_NUMA
+	if (!acpi)
+		k8 = !k8_numa_init(0, max_pfn);
 #endif
-	/*
-	 * Find and reserve possible boot-time SMP configuration:
-	 */
-	find_smp_config();
 
-	reserve_crashkernel();
+	initmem_init(0, max_pfn, acpi, k8);
 
 #ifdef CONFIG_X86_64
 	/*
diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index 503c1f2..af21e55 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -819,10 +819,8 @@ static int __init uv_init_blade(int blade)
 	 */
 	apicid = blade_to_first_apicid(blade);
 	pa = uv_read_global_mmr64(pnode, UVH_BAU_DATA_CONFIG);
-	if ((pa & 0xff) != UV_BAU_MESSAGE) {
-		uv_write_global_mmr64(pnode, UVH_BAU_DATA_CONFIG,
+	uv_write_global_mmr64(pnode, UVH_BAU_DATA_CONFIG,
 				      ((apicid << 32) | UV_BAU_MESSAGE));
-	}
 	return 0;
 }
 
diff --git a/arch/x86/kernel/visws_quirks.c b/arch/x86/kernel/visws_quirks.c
index f068553..1498efa 100644
--- a/arch/x86/kernel/visws_quirks.c
+++ b/arch/x86/kernel/visws_quirks.c
@@ -197,7 +197,7 @@ static void __init MP_processor_info(struct mpc_cpu *m)
 	apic_version[m->apicid] = ver;
 }
 
-static void __init visws_find_smp_config(unsigned int reserve)
+static void __init visws_find_smp_config(void)
 {
 	struct mpc_cpu *mp = phys_to_virt(CO_CPU_TAB_PHYS);
 	unsigned short ncpus = readw(phys_to_virt(CO_CPU_NUM_PHYS));
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 92929fb..eeb4f5f 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -41,6 +41,32 @@ ENTRY(phys_startup_64)
 jiffies_64 = jiffies;
 #endif
 
+#if defined(CONFIG_X86_64) && defined(CONFIG_DEBUG_RODATA)
+/*
+ * On 64-bit, align RODATA to 2MB so that even with CONFIG_DEBUG_RODATA
+ * we retain large page mappings for boundaries spanning kernel text, rodata
+ * and data sections.
+ *
+ * However, kernel identity mappings will have different RWX permissions
+ * to the pages mapping to text and to the pages padding (which are freed) the
+ * text section. Hence kernel identity mappings will be broken to smaller
+ * pages. For 64-bit, kernel text and kernel identity mappings are different,
+ * so we can enable protection checks that come with CONFIG_DEBUG_RODATA,
+ * as well as retain 2MB large page mappings for kernel text.
+ */
+#define X64_ALIGN_DEBUG_RODATA_BEGIN	. = ALIGN(HPAGE_SIZE);
+
+#define X64_ALIGN_DEBUG_RODATA_END				\
+		. = ALIGN(HPAGE_SIZE);				\
+		__end_rodata_hpage_align = .;
+
+#else
+
+#define X64_ALIGN_DEBUG_RODATA_BEGIN
+#define X64_ALIGN_DEBUG_RODATA_END
+
+#endif
+
 PHDRS {
 	text PT_LOAD FLAGS(5);          /* R_E */
 	data PT_LOAD FLAGS(7);          /* RWE */
@@ -90,7 +116,9 @@ SECTIONS
 
 	EXCEPTION_TABLE(16) :text = 0x9090
 
+	X64_ALIGN_DEBUG_RODATA_BEGIN
 	RO_DATA(PAGE_SIZE)
+	X64_ALIGN_DEBUG_RODATA_END
 
 	/* Data */
 	.data : AT(ADDR(.data) - LOAD_OFFSET) {
@@ -107,13 +135,13 @@ SECTIONS
 
 		PAGE_ALIGNED_DATA(PAGE_SIZE)
 
-		CACHELINE_ALIGNED_DATA(CONFIG_X86_L1_CACHE_BYTES)
+		CACHELINE_ALIGNED_DATA(L1_CACHE_BYTES)
 
 		DATA_DATA
 		CONSTRUCTORS
 
 		/* rarely changed data like cpu maps */
-		READ_MOSTLY_DATA(CONFIG_X86_INTERNODE_CACHE_BYTES)
+		READ_MOSTLY_DATA(INTERNODE_CACHE_BYTES)
 
 		/* End of data section */
 		_edata = .;
@@ -137,12 +165,12 @@ SECTIONS
 		*(.vsyscall_0)
 	} :user
 
-	. = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
+	. = ALIGN(L1_CACHE_BYTES);
 	.vsyscall_fn : AT(VLOAD(.vsyscall_fn)) {
 		*(.vsyscall_fn)
 	}
 
-	. = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
+	. = ALIGN(L1_CACHE_BYTES);
 	.vsyscall_gtod_data : AT(VLOAD(.vsyscall_gtod_data)) {
 		*(.vsyscall_gtod_data)
 	}
@@ -166,7 +194,7 @@ SECTIONS
 	}
 	vgetcpu_mode = VVIRT(.vgetcpu_mode);
 
-	. = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
+	. = ALIGN(L1_CACHE_BYTES);
 	.jiffies : AT(VLOAD(.jiffies)) {
 		*(.jiffies)
 	}
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 4449a4a..861b8b5 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -13,6 +13,7 @@
 #include <asm/e820.h>
 #include <asm/time.h>
 #include <asm/irq.h>
+#include <asm/pat.h>
 #include <asm/tsc.h>
 
 void __cpuinit x86_init_noop(void) { }
@@ -72,4 +73,5 @@ struct x86_platform_ops x86_platform = {
 	.calibrate_tsc			= native_calibrate_tsc,
 	.get_wallclock			= mach_get_cmos_time,
 	.set_wallclock			= mach_set_rtc_mmss,
+	.is_untracked_pat_range		= is_ISA_range,
 };
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 73ffd55..d406c52 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -146,10 +146,6 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	use_gbpages = direct_gbpages;
 #endif
 
-	set_nx();
-	if (nx_enabled)
-		printk(KERN_INFO "NX (Execute Disable) protection: active\n");
-
 	/* Enable PSE if available */
 	if (cpu_has_pse)
 		set_in_cr4(X86_CR4_PSE);
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 30938c1..c973f8e 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -412,7 +412,7 @@ static void __init permanent_kmaps_init(pgd_t *pgd_base)
 	pkmap_page_table = pte;
 }
 
-static void __init add_one_highpage_init(struct page *page, int pfn)
+static void __init add_one_highpage_init(struct page *page)
 {
 	ClearPageReserved(page);
 	init_page_count(page);
@@ -445,7 +445,7 @@ static int __init add_highpages_work_fn(unsigned long start_pfn,
 		if (!pfn_valid(node_pfn))
 			continue;
 		page = pfn_to_page(node_pfn);
-		add_one_highpage_init(page, node_pfn);
+		add_one_highpage_init(page);
 	}
 
 	return 0;
@@ -703,8 +703,8 @@ void __init find_low_pfn_range(void)
 }
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
-void __init initmem_init(unsigned long start_pfn,
-				  unsigned long end_pfn)
+void __init initmem_init(unsigned long start_pfn, unsigned long end_pfn,
+				int acpi, int k8)
 {
 #ifdef CONFIG_HIGHMEM
 	highstart_pfn = highend_pfn = max_pfn;
@@ -997,7 +997,7 @@ static noinline int do_test_wp_bit(void)
 const int rodata_test_data = 0xC3;
 EXPORT_SYMBOL_GPL(rodata_test_data);
 
-static int kernel_set_to_readonly;
+int kernel_set_to_readonly __read_mostly;
 
 void set_kernel_text_rw(void)
 {
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 5a4398a..5198b9b 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -568,7 +568,8 @@ kernel_physical_mapping_init(unsigned long start,
 }
 
 #ifndef CONFIG_NUMA
-void __init initmem_init(unsigned long start_pfn, unsigned long end_pfn)
+void __init initmem_init(unsigned long start_pfn, unsigned long end_pfn,
+				int acpi, int k8)
 {
 	unsigned long bootmap_size, bootmap;
 
@@ -694,12 +695,12 @@ void __init mem_init(void)
 const int rodata_test_data = 0xC3;
 EXPORT_SYMBOL_GPL(rodata_test_data);
 
-static int kernel_set_to_readonly;
+int kernel_set_to_readonly;
 
 void set_kernel_text_rw(void)
 {
-	unsigned long start = PFN_ALIGN(_stext);
-	unsigned long end = PFN_ALIGN(__start_rodata);
+	unsigned long start = PFN_ALIGN(_text);
+	unsigned long end = PFN_ALIGN(__stop___ex_table);
 
 	if (!kernel_set_to_readonly)
 		return;
@@ -707,13 +708,18 @@ void set_kernel_text_rw(void)
 	pr_debug("Set kernel text: %lx - %lx for read write\n",
 		 start, end);
 
+	/*
+	 * Make the kernel identity mapping for text RW. Kernel text
+	 * mapping will always be RO. Refer to the comment in
+	 * static_protections() in pageattr.c
+	 */
 	set_memory_rw(start, (end - start) >> PAGE_SHIFT);
 }
 
 void set_kernel_text_ro(void)
 {
-	unsigned long start = PFN_ALIGN(_stext);
-	unsigned long end = PFN_ALIGN(__start_rodata);
+	unsigned long start = PFN_ALIGN(_text);
+	unsigned long end = PFN_ALIGN(__stop___ex_table);
 
 	if (!kernel_set_to_readonly)
 		return;
@@ -721,14 +727,21 @@ void set_kernel_text_ro(void)
 	pr_debug("Set kernel text: %lx - %lx for read only\n",
 		 start, end);
 
+	/*
+	 * Set the kernel identity mapping for text RO.
+	 */
 	set_memory_ro(start, (end - start) >> PAGE_SHIFT);
 }
 
 void mark_rodata_ro(void)
 {
-	unsigned long start = PFN_ALIGN(_stext), end = PFN_ALIGN(__end_rodata);
+	unsigned long start = PFN_ALIGN(_text);
 	unsigned long rodata_start =
 		((unsigned long)__start_rodata + PAGE_SIZE - 1) & PAGE_MASK;
+	unsigned long end = (unsigned long) &__end_rodata_hpage_align;
+	unsigned long text_end = PAGE_ALIGN((unsigned long) &__stop___ex_table);
+	unsigned long rodata_end = PAGE_ALIGN((unsigned long) &__end_rodata);
+	unsigned long data_start = (unsigned long) &_sdata;
 
 	printk(KERN_INFO "Write protecting the kernel read-only data: %luk\n",
 	       (end - start) >> 10);
@@ -751,6 +764,14 @@ void mark_rodata_ro(void)
 	printk(KERN_INFO "Testing CPA: again\n");
 	set_memory_ro(start, (end-start) >> PAGE_SHIFT);
 #endif
+
+	free_init_pages("unused kernel memory",
+			(unsigned long) page_address(virt_to_page(text_end)),
+			(unsigned long)
+				 page_address(virt_to_page(rodata_start)));
+	free_init_pages("unused kernel memory",
+			(unsigned long) page_address(virt_to_page(rodata_end)),
+			(unsigned long) page_address(virt_to_page(data_start)));
 }
 
 #endif
diff --git a/arch/x86/mm/k8topology_64.c b/arch/x86/mm/k8topology_64.c
index 268f825..970ed57 100644
--- a/arch/x86/mm/k8topology_64.c
+++ b/arch/x86/mm/k8topology_64.c
@@ -24,6 +24,9 @@
 #include <asm/apic.h>
 #include <asm/k8.h>
 
+static struct bootnode __initdata nodes[8];
+static nodemask_t __initdata nodes_parsed = NODE_MASK_NONE;
+
 static __init int find_northbridge(void)
 {
 	int num;
@@ -54,18 +57,6 @@ static __init void early_get_boot_cpu_id(void)
 	 * need to get boot_cpu_id so can use that to create apicid_to_node
 	 * in k8_scan_nodes()
 	 */
-	/*
-	 * Find possible boot-time SMP configuration:
-	 */
-#ifdef CONFIG_X86_MPPARSE
-	early_find_smp_config();
-#endif
-#ifdef CONFIG_ACPI
-	/*
-	 * Read APIC information from ACPI tables.
-	 */
-	early_acpi_boot_init();
-#endif
 #ifdef CONFIG_X86_MPPARSE
 	/*
 	 * get boot-time SMP configuration:
@@ -76,12 +67,26 @@ static __init void early_get_boot_cpu_id(void)
 	early_init_lapic_mapping();
 }
 
-int __init k8_scan_nodes(unsigned long start, unsigned long end)
+int __init k8_get_nodes(struct bootnode *physnodes)
 {
-	unsigned numnodes, cores, bits, apicid_base;
+	int i;
+	int ret = 0;
+
+	for_each_node_mask(i, nodes_parsed) {
+		physnodes[ret].start = nodes[i].start;
+		physnodes[ret].end = nodes[i].end;
+		ret++;
+	}
+	return ret;
+}
+
+int __init k8_numa_init(unsigned long start_pfn, unsigned long end_pfn)
+{
+	unsigned long start = PFN_PHYS(start_pfn);
+	unsigned long end = PFN_PHYS(end_pfn);
+	unsigned numnodes;
 	unsigned long prevbase;
-	struct bootnode nodes[8];
-	int i, j, nb, found = 0;
+	int i, nb, found = 0;
 	u32 nodeid, reg;
 
 	if (!early_pci_allowed())
@@ -91,16 +96,15 @@ int __init k8_scan_nodes(unsigned long start, unsigned long end)
 	if (nb < 0)
 		return nb;
 
-	printk(KERN_INFO "Scanning NUMA topology in Northbridge %d\n", nb);
+	pr_info("Scanning NUMA topology in Northbridge %d\n", nb);
 
 	reg = read_pci_config(0, nb, 0, 0x60);
 	numnodes = ((reg >> 4) & 0xF) + 1;
 	if (numnodes <= 1)
 		return -1;
 
-	printk(KERN_INFO "Number of nodes %d\n", numnodes);
+	pr_info("Number of physical nodes %d\n", numnodes);
 
-	memset(&nodes, 0, sizeof(nodes));
 	prevbase = 0;
 	for (i = 0; i < 8; i++) {
 		unsigned long base, limit;
@@ -111,28 +115,28 @@ int __init k8_scan_nodes(unsigned long start, unsigned long end)
 		nodeid = limit & 7;
 		if ((base & 3) == 0) {
 			if (i < numnodes)
-				printk("Skipping disabled node %d\n", i);
+				pr_info("Skipping disabled node %d\n", i);
 			continue;
 		}
 		if (nodeid >= numnodes) {
-			printk("Ignoring excess node %d (%lx:%lx)\n", nodeid,
-			       base, limit);
+			pr_info("Ignoring excess node %d (%lx:%lx)\n", nodeid,
+				base, limit);
 			continue;
 		}
 
 		if (!limit) {
-			printk(KERN_INFO "Skipping node entry %d (base %lx)\n",
-			       i, base);
+			pr_info("Skipping node entry %d (base %lx)\n",
+				i, base);
 			continue;
 		}
 		if ((base >> 8) & 3 || (limit >> 8) & 3) {
-			printk(KERN_ERR "Node %d using interleaving mode %lx/%lx\n",
-			       nodeid, (base>>8)&3, (limit>>8) & 3);
+			pr_err("Node %d using interleaving mode %lx/%lx\n",
+			       nodeid, (base >> 8) & 3, (limit >> 8) & 3);
 			return -1;
 		}
-		if (node_isset(nodeid, node_possible_map)) {
-			printk(KERN_INFO "Node %d already present. Skipping\n",
-			       nodeid);
+		if (node_isset(nodeid, nodes_parsed)) {
+			pr_info("Node %d already present, skipping\n",
+				nodeid);
 			continue;
 		}
 
@@ -141,8 +145,8 @@ int __init k8_scan_nodes(unsigned long start, unsigned long end)
 		limit |= (1<<24)-1;
 		limit++;
 
-		if (limit > max_pfn << PAGE_SHIFT)
-			limit = max_pfn << PAGE_SHIFT;
+		if (limit > end)
+			limit = end;
 		if (limit <= base)
 			continue;
 
@@ -154,24 +158,24 @@ int __init k8_scan_nodes(unsigned long start, unsigned long end)
 		if (limit > end)
 			limit = end;
 		if (limit == base) {
-			printk(KERN_ERR "Empty node %d\n", nodeid);
+			pr_err("Empty node %d\n", nodeid);
 			continue;
 		}
 		if (limit < base) {
-			printk(KERN_ERR "Node %d bogus settings %lx-%lx.\n",
+			pr_err("Node %d bogus settings %lx-%lx.\n",
 			       nodeid, base, limit);
 			continue;
 		}
 
 		/* Could sort here, but pun for now. Should not happen anyroads. */
 		if (prevbase > base) {
-			printk(KERN_ERR "Node map not sorted %lx,%lx\n",
+			pr_err("Node map not sorted %lx,%lx\n",
 			       prevbase, base);
 			return -1;
 		}
 
-		printk(KERN_INFO "Node %d MemBase %016lx Limit %016lx\n",
-		       nodeid, base, limit);
+		pr_info("Node %d MemBase %016lx Limit %016lx\n",
+			nodeid, base, limit);
 
 		found++;
 
@@ -180,18 +184,29 @@ int __init k8_scan_nodes(unsigned long start, unsigned long end)
 
 		prevbase = base;
 
-		node_set(nodeid, node_possible_map);
+		node_set(nodeid, nodes_parsed);
 	}
 
 	if (!found)
 		return -1;
+	return 0;
+}
+
+int __init k8_scan_nodes(void)
+{
+	unsigned int bits;
+	unsigned int cores;
+	unsigned int apicid_base;
+	int i;
 
+	BUG_ON(nodes_empty(nodes_parsed));
+	node_possible_map = nodes_parsed;
 	memnode_shift = compute_hash_shift(nodes, 8, NULL);
 	if (memnode_shift < 0) {
-		printk(KERN_ERR "No NUMA node hash function found. Contact maintainer\n");
+		pr_err("No NUMA node hash function found. Contact maintainer\n");
 		return -1;
 	}
-	printk(KERN_INFO "Using node hash shift of %d\n", memnode_shift);
+	pr_info("Using node hash shift of %d\n", memnode_shift);
 
 	/* use the coreid bits from early_identify_cpu */
 	bits = boot_cpu_data.x86_coreid_bits;
@@ -200,14 +215,12 @@ int __init k8_scan_nodes(unsigned long start, unsigned long end)
 	/* need to get boot_cpu_id early for system with apicid lifting */
 	early_get_boot_cpu_id();
 	if (boot_cpu_physical_apicid > 0) {
-		printk(KERN_INFO "BSP APIC ID: %02x\n",
-				 boot_cpu_physical_apicid);
+		pr_info("BSP APIC ID: %02x\n", boot_cpu_physical_apicid);
 		apicid_base = boot_cpu_physical_apicid;
 	}
 
-	for (i = 0; i < 8; i++) {
-		if (nodes[i].start == nodes[i].end)
-			continue;
+	for_each_node_mask(i, node_possible_map) {
+		int j;
 
 		e820_register_active_regions(i,
 				nodes[i].start >> PAGE_SHIFT,
diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index d253006..b20760c 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -347,8 +347,8 @@ static void init_remap_allocator(int nid)
 		(ulong) node_remap_end_vaddr[nid]);
 }
 
-void __init initmem_init(unsigned long start_pfn,
-				  unsigned long end_pfn)
+void __init initmem_init(unsigned long start_pfn, unsigned long end_pfn,
+				int acpi, int k8)
 {
 	int nid;
 	long kva_target_pfn;
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 459913b..83bbc70 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -239,8 +239,14 @@ setup_node_bootmem(int nodeid, unsigned long start, unsigned long end)
 	bootmap = early_node_mem(nodeid, bootmap_start, end,
 				 bootmap_pages<<PAGE_SHIFT, PAGE_SIZE);
 	if (bootmap == NULL)  {
-		if (nodedata_phys < start || nodedata_phys >= end)
-			free_bootmem(nodedata_phys, pgdat_size);
+		if (nodedata_phys < start || nodedata_phys >= end) {
+			/*
+			 * only need to free it if it is from other node
+			 * bootmem
+			 */
+			if (nid != nodeid)
+				free_bootmem(nodedata_phys, pgdat_size);
+		}
 		node_data[nodeid] = NULL;
 		return;
 	}
@@ -306,8 +312,71 @@ void __init numa_init_array(void)
 
 #ifdef CONFIG_NUMA_EMU
 /* Numa emulation */
+static struct bootnode nodes[MAX_NUMNODES] __initdata;
+static struct bootnode physnodes[MAX_NUMNODES] __initdata;
 static char *cmdline __initdata;
 
+static int __init setup_physnodes(unsigned long start, unsigned long end,
+					int acpi, int k8)
+{
+	int nr_nodes = 0;
+	int ret = 0;
+	int i;
+
+#ifdef CONFIG_ACPI_NUMA
+	if (acpi)
+		nr_nodes = acpi_get_nodes(physnodes);
+#endif
+#ifdef CONFIG_K8_NUMA
+	if (k8)
+		nr_nodes = k8_get_nodes(physnodes);
+#endif
+	/*
+	 * Basic sanity checking on the physical node map: there may be errors
+	 * if the SRAT or K8 incorrectly reported the topology or the mem=
+	 * kernel parameter is used.
+	 */
+	for (i = 0; i < nr_nodes; i++) {
+		if (physnodes[i].start == physnodes[i].end)
+			continue;
+		if (physnodes[i].start > end) {
+			physnodes[i].end = physnodes[i].start;
+			continue;
+		}
+		if (physnodes[i].end < start) {
+			physnodes[i].start = physnodes[i].end;
+			continue;
+		}
+		if (physnodes[i].start < start)
+			physnodes[i].start = start;
+		if (physnodes[i].end > end)
+			physnodes[i].end = end;
+	}
+
+	/*
+	 * Remove all nodes that have no memory or were truncated because of the
+	 * limited address range.
+	 */
+	for (i = 0; i < nr_nodes; i++) {
+		if (physnodes[i].start == physnodes[i].end)
+			continue;
+		physnodes[ret].start = physnodes[i].start;
+		physnodes[ret].end = physnodes[i].end;
+		ret++;
+	}
+
+	/*
+	 * If no physical topology was detected, a single node is faked to cover
+	 * the entire address space.
+	 */
+	if (!ret) {
+		physnodes[ret].start = start;
+		physnodes[ret].end = end;
+		ret = 1;
+	}
+	return ret;
+}
+
 /*
  * Setups up nid to range from addr to addr + size.  If the end
  * boundary is greater than max_addr, then max_addr is used instead.
@@ -315,11 +384,9 @@ static char *cmdline __initdata;
  * allocation past addr and -1 otherwise.  addr is adjusted to be at
  * the end of the node.
  */
-static int __init setup_node_range(int nid, struct bootnode *nodes, u64 *addr,
-				   u64 size, u64 max_addr)
+static int __init setup_node_range(int nid, u64 *addr, u64 size, u64 max_addr)
 {
 	int ret = 0;
-
 	nodes[nid].start = *addr;
 	*addr += size;
 	if (*addr >= max_addr) {
@@ -335,12 +402,111 @@ static int __init setup_node_range(int nid, struct bootnode *nodes, u64 *addr,
 }
 
 /*
+ * Sets up nr_nodes fake nodes interleaved over physical nodes ranging from addr
+ * to max_addr.  The return value is the number of nodes allocated.
+ */
+static int __init split_nodes_interleave(u64 addr, u64 max_addr,
+						int nr_phys_nodes, int nr_nodes)
+{
+	nodemask_t physnode_mask = NODE_MASK_NONE;
+	u64 size;
+	int big;
+	int ret = 0;
+	int i;
+
+	if (nr_nodes <= 0)
+		return -1;
+	if (nr_nodes > MAX_NUMNODES) {
+		pr_info("numa=fake=%d too large, reducing to %d\n",
+			nr_nodes, MAX_NUMNODES);
+		nr_nodes = MAX_NUMNODES;
+	}
+
+	size = (max_addr - addr - e820_hole_size(addr, max_addr)) / nr_nodes;
+	/*
+	 * Calculate the number of big nodes that can be allocated as a result
+	 * of consolidating the remainder.
+	 */
+	big = ((size & ~FAKE_NODE_MIN_HASH_MASK) & nr_nodes) /
+		FAKE_NODE_MIN_SIZE;
+
+	size &= FAKE_NODE_MIN_HASH_MASK;
+	if (!size) {
+		pr_err("Not enough memory for each node.  "
+			"NUMA emulation disabled.\n");
+		return -1;
+	}
+
+	for (i = 0; i < nr_phys_nodes; i++)
+		if (physnodes[i].start != physnodes[i].end)
+			node_set(i, physnode_mask);
+
+	/*
+	 * Continue to fill physical nodes with fake nodes until there is no
+	 * memory left on any of them.
+	 */
+	while (nodes_weight(physnode_mask)) {
+		for_each_node_mask(i, physnode_mask) {
+			u64 end = physnodes[i].start + size;
+			u64 dma32_end = PFN_PHYS(MAX_DMA32_PFN);
+
+			if (ret < big)
+				end += FAKE_NODE_MIN_SIZE;
+
+			/*
+			 * Continue to add memory to this fake node if its
+			 * non-reserved memory is less than the per-node size.
+			 */
+			while (end - physnodes[i].start -
+				e820_hole_size(physnodes[i].start, end) < size) {
+				end += FAKE_NODE_MIN_SIZE;
+				if (end > physnodes[i].end) {
+					end = physnodes[i].end;
+					break;
+				}
+			}
+
+			/*
+			 * If there won't be at least FAKE_NODE_MIN_SIZE of
+			 * non-reserved memory in ZONE_DMA32 for the next node,
+			 * this one must extend to the boundary.
+			 */
+			if (end < dma32_end && dma32_end - end -
+			    e820_hole_size(end, dma32_end) < FAKE_NODE_MIN_SIZE)
+				end = dma32_end;
+
+			/*
+			 * If there won't be enough non-reserved memory for the
+			 * next node, this one must extend to the end of the
+			 * physical node.
+			 */
+			if (physnodes[i].end - end -
+			    e820_hole_size(end, physnodes[i].end) < size)
+				end = physnodes[i].end;
+
+			/*
+			 * Avoid allocating more nodes than requested, which can
+			 * happen as a result of rounding down each node's size
+			 * to FAKE_NODE_MIN_SIZE.
+			 */
+			if (nodes_weight(physnode_mask) + ret >= nr_nodes)
+				end = physnodes[i].end;
+
+			if (setup_node_range(ret++, &physnodes[i].start,
+						end - physnodes[i].start,
+						physnodes[i].end) < 0)
+				node_clear(i, physnode_mask);
+		}
+	}
+	return ret;
+}
+
+/*
  * Splits num_nodes nodes up equally starting at node_start.  The return value
  * is the number of nodes split up and addr is adjusted to be at the end of the
  * last node allocated.
  */
-static int __init split_nodes_equally(struct bootnode *nodes, u64 *addr,
-				      u64 max_addr, int node_start,
+static int __init split_nodes_equally(u64 *addr, u64 max_addr, int node_start,
 				      int num_nodes)
 {
 	unsigned int big;
@@ -388,7 +554,7 @@ static int __init split_nodes_equally(struct bootnode *nodes, u64 *addr,
 					break;
 				}
 			}
-		if (setup_node_range(i, nodes, addr, end - *addr, max_addr) < 0)
+		if (setup_node_range(i, addr, end - *addr, max_addr) < 0)
 			break;
 	}
 	return i - node_start + 1;
@@ -399,12 +565,12 @@ static int __init split_nodes_equally(struct bootnode *nodes, u64 *addr,
  * always assigned to a final node and can be asymmetric.  Returns the number of
  * nodes split.
  */
-static int __init split_nodes_by_size(struct bootnode *nodes, u64 *addr,
-				      u64 max_addr, int node_start, u64 size)
+static int __init split_nodes_by_size(u64 *addr, u64 max_addr, int node_start,
+				      u64 size)
 {
 	int i = node_start;
 	size = (size << 20) & FAKE_NODE_MIN_HASH_MASK;
-	while (!setup_node_range(i++, nodes, addr, size, max_addr))
+	while (!setup_node_range(i++, addr, size, max_addr))
 		;
 	return i - node_start;
 }
@@ -413,15 +579,15 @@ static int __init split_nodes_by_size(struct bootnode *nodes, u64 *addr,
  * Sets up the system RAM area from start_pfn to last_pfn according to the
  * numa=fake command-line option.
  */
-static struct bootnode nodes[MAX_NUMNODES] __initdata;
-
-static int __init numa_emulation(unsigned long start_pfn, unsigned long last_pfn)
+static int __init numa_emulation(unsigned long start_pfn,
+			unsigned long last_pfn, int acpi, int k8)
 {
 	u64 size, addr = start_pfn << PAGE_SHIFT;
 	u64 max_addr = last_pfn << PAGE_SHIFT;
 	int num_nodes = 0, num = 0, coeff_flag, coeff = -1, i;
+	int num_phys_nodes;
 
-	memset(&nodes, 0, sizeof(nodes));
+	num_phys_nodes = setup_physnodes(addr, max_addr, acpi, k8);
 	/*
 	 * If the numa=fake command-line is just a single number N, split the
 	 * system RAM into N fake nodes.
@@ -429,7 +595,8 @@ static int __init numa_emulation(unsigned long start_pfn, unsigned long last_pfn
 	if (!strchr(cmdline, '*') && !strchr(cmdline, ',')) {
 		long n = simple_strtol(cmdline, NULL, 0);
 
-		num_nodes = split_nodes_equally(nodes, &addr, max_addr, 0, n);
+		num_nodes = split_nodes_interleave(addr, max_addr,
+							num_phys_nodes, n);
 		if (num_nodes < 0)
 			return num_nodes;
 		goto out;
@@ -456,8 +623,8 @@ static int __init numa_emulation(unsigned long start_pfn, unsigned long last_pfn
 			size = ((u64)num << 20) & FAKE_NODE_MIN_HASH_MASK;
 			if (size)
 				for (i = 0; i < coeff; i++, num_nodes++)
-					if (setup_node_range(num_nodes, nodes,
-						&addr, size, max_addr) < 0)
+					if (setup_node_range(num_nodes, &addr,
+						size, max_addr) < 0)
 						goto done;
 			if (!*cmdline)
 				break;
@@ -473,7 +640,7 @@ done:
 	if (addr < max_addr) {
 		if (coeff_flag && coeff < 0) {
 			/* Split remaining nodes into num-sized chunks */
-			num_nodes += split_nodes_by_size(nodes, &addr, max_addr,
+			num_nodes += split_nodes_by_size(&addr, max_addr,
 							 num_nodes, num);
 			goto out;
 		}
@@ -482,7 +649,7 @@ done:
 			/* Split remaining nodes into coeff chunks */
 			if (coeff <= 0)
 				break;
-			num_nodes += split_nodes_equally(nodes, &addr, max_addr,
+			num_nodes += split_nodes_equally(&addr, max_addr,
 							 num_nodes, coeff);
 			break;
 		case ',':
@@ -490,8 +657,8 @@ done:
 			break;
 		default:
 			/* Give one final node */
-			setup_node_range(num_nodes, nodes, &addr,
-					 max_addr - addr, max_addr);
+			setup_node_range(num_nodes, &addr, max_addr - addr,
+					 max_addr);
 			num_nodes++;
 		}
 	}
@@ -505,14 +672,10 @@ out:
 	}
 
 	/*
-	 * We need to vacate all active ranges that may have been registered by
-	 * SRAT and set acpi_numa to -1 so that srat_disabled() always returns
-	 * true.  NUMA emulation has succeeded so we will not scan ACPI nodes.
+	 * We need to vacate all active ranges that may have been registered for
+	 * the e820 memory map.
 	 */
 	remove_all_active_ranges();
-#ifdef CONFIG_ACPI_NUMA
-	acpi_numa = -1;
-#endif
 	for_each_node_mask(i, node_possible_map) {
 		e820_register_active_regions(i, nodes[i].start >> PAGE_SHIFT,
 						nodes[i].end >> PAGE_SHIFT);
@@ -524,7 +687,8 @@ out:
 }
 #endif /* CONFIG_NUMA_EMU */
 
-void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn)
+void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn,
+				int acpi, int k8)
 {
 	int i;
 
@@ -532,23 +696,22 @@ void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn)
 	nodes_clear(node_online_map);
 
 #ifdef CONFIG_NUMA_EMU
-	if (cmdline && !numa_emulation(start_pfn, last_pfn))
+	if (cmdline && !numa_emulation(start_pfn, last_pfn, acpi, k8))
 		return;
 	nodes_clear(node_possible_map);
 	nodes_clear(node_online_map);
 #endif
 
 #ifdef CONFIG_ACPI_NUMA
-	if (!numa_off && !acpi_scan_nodes(start_pfn << PAGE_SHIFT,
-					  last_pfn << PAGE_SHIFT))
+	if (!numa_off && acpi && !acpi_scan_nodes(start_pfn << PAGE_SHIFT,
+						  last_pfn << PAGE_SHIFT))
 		return;
 	nodes_clear(node_possible_map);
 	nodes_clear(node_online_map);
 #endif
 
 #ifdef CONFIG_K8_NUMA
-	if (!numa_off && !k8_scan_nodes(start_pfn<<PAGE_SHIFT,
-					last_pfn<<PAGE_SHIFT))
+	if (!numa_off && k8 && !k8_scan_nodes())
 		return;
 	nodes_clear(node_possible_map);
 	nodes_clear(node_online_map);
@@ -601,6 +764,25 @@ static __init int numa_setup(char *opt)
 early_param("numa", numa_setup);
 
 #ifdef CONFIG_NUMA
+
+static __init int find_near_online_node(int node)
+{
+	int n, val;
+	int min_val = INT_MAX;
+	int best_node = -1;
+
+	for_each_online_node(n) {
+		val = node_distance(node, n);
+
+		if (val < min_val) {
+			min_val = val;
+			best_node = n;
+		}
+	}
+
+	return best_node;
+}
+
 /*
  * Setup early cpu_to_node.
  *
@@ -632,7 +814,7 @@ void __init init_cpu_to_node(void)
 		if (node == NUMA_NO_NODE)
 			continue;
 		if (!node_online(node))
-			continue;
+			node = find_near_online_node(node);
 		numa_set_node(cpu, node);
 	}
 }
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index dd38bfb..1d4eb93 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -279,6 +279,22 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
 		   __pa((unsigned long)__end_rodata) >> PAGE_SHIFT))
 		pgprot_val(forbidden) |= _PAGE_RW;
 
+#if defined(CONFIG_X86_64) && defined(CONFIG_DEBUG_RODATA)
+	/*
+	 * Once the kernel maps the text as RO (kernel_set_to_readonly is set),
+	 * kernel text mappings for the large page aligned text, rodata sections
+	 * will be always read-only. For the kernel identity mappings covering
+	 * the holes caused by this alignment can be anything that user asks.
+	 *
+	 * This will preserve the large page mappings for kernel text/data
+	 * at no extra cost.
+	 */
+	if (kernel_set_to_readonly &&
+	    within(address, (unsigned long)_text,
+		   (unsigned long)__end_rodata_hpage_align))
+		pgprot_val(forbidden) |= _PAGE_RW;
+#endif
+
 	prot = __pgprot(pgprot_val(prot) & ~pgprot_val(forbidden));
 
 	return prot;
@@ -1069,12 +1085,18 @@ EXPORT_SYMBOL(set_memory_array_wb);
 
 int set_memory_x(unsigned long addr, int numpages)
 {
+	if (!(__supported_pte_mask & _PAGE_NX))
+		return 0;
+
 	return change_page_attr_clear(&addr, numpages, __pgprot(_PAGE_NX), 0);
 }
 EXPORT_SYMBOL(set_memory_x);
 
 int set_memory_nx(unsigned long addr, int numpages)
 {
+	if (!(__supported_pte_mask & _PAGE_NX))
+		return 0;
+
 	return change_page_attr_set(&addr, numpages, __pgprot(_PAGE_NX), 0);
 }
 EXPORT_SYMBOL(set_memory_nx);
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index e78cd0e..a81b7e7 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -20,6 +20,7 @@
 #include <asm/cacheflush.h>
 #include <asm/processor.h>
 #include <asm/tlbflush.h>
+#include <asm/x86_init.h>
 #include <asm/pgtable.h>
 #include <asm/fcntl.h>
 #include <asm/e820.h>
@@ -388,7 +389,7 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 	}
 
 	/* Low ISA region is always mapped WB in page table. No need to track */
-	if (is_ISA_range(start, end - 1)) {
+	if (x86_platform.is_untracked_pat_range(start, end)) {
 		if (new_type)
 			*new_type = _PAGE_CACHE_WB;
 		return 0;
@@ -499,7 +500,7 @@ int free_memtype(u64 start, u64 end)
 		return 0;
 
 	/* Low ISA region is always mapped WB. No need to track */
-	if (is_ISA_range(start, end - 1))
+	if (x86_platform.is_untracked_pat_range(start, end))
 		return 0;
 
 	is_range_ram = pat_pagerange_is_ram(start, end);
@@ -582,7 +583,7 @@ static unsigned long lookup_memtype(u64 paddr)
 	int rettype = _PAGE_CACHE_WB;
 	struct memtype *entry;
 
-	if (is_ISA_range(paddr, paddr + PAGE_SIZE - 1))
+	if (x86_platform.is_untracked_pat_range(paddr, paddr + PAGE_SIZE))
 		return rettype;
 
 	if (pat_pagerange_is_ram(paddr, paddr + PAGE_SIZE)) {
@@ -1018,8 +1019,10 @@ static const struct file_operations memtype_fops = {
 
 static int __init pat_memtype_list_init(void)
 {
-	debugfs_create_file("pat_memtype_list", S_IRUSR, arch_debugfs_dir,
-				NULL, &memtype_fops);
+	if (pat_enabled) {
+		debugfs_create_file("pat_memtype_list", S_IRUSR,
+				    arch_debugfs_dir, NULL, &memtype_fops);
+	}
 	return 0;
 }
 
diff --git a/arch/x86/mm/setup_nx.c b/arch/x86/mm/setup_nx.c
index 513d8ed..a3250aa 100644
--- a/arch/x86/mm/setup_nx.c
+++ b/arch/x86/mm/setup_nx.c
@@ -3,10 +3,8 @@
 #include <linux/init.h>
 
 #include <asm/pgtable.h>
+#include <asm/proto.h>
 
-int nx_enabled;
-
-#if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
 static int disable_nx __cpuinitdata;
 
 /*
@@ -22,48 +20,41 @@ static int __init noexec_setup(char *str)
 	if (!str)
 		return -EINVAL;
 	if (!strncmp(str, "on", 2)) {
-		__supported_pte_mask |= _PAGE_NX;
 		disable_nx = 0;
 	} else if (!strncmp(str, "off", 3)) {
 		disable_nx = 1;
-		__supported_pte_mask &= ~_PAGE_NX;
 	}
+	x86_configure_nx();
 	return 0;
 }
 early_param("noexec", noexec_setup);
-#endif
 
-#ifdef CONFIG_X86_PAE
-void __init set_nx(void)
+void __cpuinit x86_configure_nx(void)
 {
-	unsigned int v[4], l, h;
-
-	if (cpu_has_pae && (cpuid_eax(0x80000000) > 0x80000001)) {
-		cpuid(0x80000001, &v[0], &v[1], &v[2], &v[3]);
+	if (cpu_has_nx && !disable_nx)
+		__supported_pte_mask |= _PAGE_NX;
+	else
+		__supported_pte_mask &= ~_PAGE_NX;
+}
 
-		if ((v[3] & (1 << 20)) && !disable_nx) {
-			rdmsr(MSR_EFER, l, h);
-			l |= EFER_NX;
-			wrmsr(MSR_EFER, l, h);
-			nx_enabled = 1;
-			__supported_pte_mask |= _PAGE_NX;
+void __init x86_report_nx(void)
+{
+	if (!cpu_has_nx) {
+		printk(KERN_NOTICE "Notice: NX (Execute Disable) protection "
+		       "missing in CPU or disabled in BIOS!\n");
+	} else {
+#if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
+		if (disable_nx) {
+			printk(KERN_INFO "NX (Execute Disable) protection: "
+			       "disabled by kernel command line option\n");
+		} else {
+			printk(KERN_INFO "NX (Execute Disable) protection: "
+			       "active\n");
 		}
-	}
-}
 #else
-void set_nx(void)
-{
-}
+		/* 32bit non-PAE kernel, NX cannot be used */
+		printk(KERN_NOTICE "Notice: NX (Execute Disable) protection "
+		       "cannot be enabled: non-PAE kernel!\n");
 #endif
-
-#ifdef CONFIG_X86_64
-void __cpuinit check_efer(void)
-{
-	unsigned long efer;
-
-	rdmsrl(MSR_EFER, efer);
-	if (!(efer & EFER_NX) || disable_nx)
-		__supported_pte_mask &= ~_PAGE_NX;
+	}
 }
-#endif
-
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index dbb5381..34aa438 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -290,8 +290,6 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 
 	printk(KERN_INFO "SRAT: Node %u PXM %u %lx-%lx\n", node, pxm,
 	       start, end);
-	e820_register_active_regions(node, start >> PAGE_SHIFT,
-				     end >> PAGE_SHIFT);
 
 	if (ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) {
 		update_nodes_add(node, start, end);
@@ -338,6 +336,19 @@ static int __init nodes_cover_memory(const struct bootnode *nodes)
 
 void __init acpi_numa_arch_fixup(void) {}
 
+int __init acpi_get_nodes(struct bootnode *physnodes)
+{
+	int i;
+	int ret = 0;
+
+	for_each_node_mask(i, nodes_parsed) {
+		physnodes[ret].start = nodes[i].start;
+		physnodes[ret].end = nodes[i].end;
+		ret++;
+	}
+	return ret;
+}
+
 /* Use the information discovered above to actually set up the nodes. */
 int __init acpi_scan_nodes(unsigned long start, unsigned long end)
 {
@@ -350,11 +361,6 @@ int __init acpi_scan_nodes(unsigned long start, unsigned long end)
 	for (i = 0; i < MAX_NUMNODES; i++)
 		cutoff_node(i, start, end);
 
-	if (!nodes_cover_memory(nodes)) {
-		bad_srat();
-		return -1;
-	}
-
 	memnode_shift = compute_hash_shift(node_memblk_range, num_node_memblks,
 					   memblk_nodeid);
 	if (memnode_shift < 0) {
@@ -364,6 +370,14 @@ int __init acpi_scan_nodes(unsigned long start, unsigned long end)
 		return -1;
 	}
 
+	for_each_node_mask(i, nodes_parsed)
+		e820_register_active_regions(i, nodes[i].start >> PAGE_SHIFT,
+						nodes[i].end >> PAGE_SHIFT);
+	if (!nodes_cover_memory(nodes)) {
+		bad_srat();
+		return -1;
+	}
+
 	/* Account for nodes with cpus and no memory */
 	nodes_or(node_possible_map, nodes_parsed, cpu_nodes_parsed);
 
@@ -454,7 +468,6 @@ void __init acpi_fake_nodes(const struct bootnode *fake_nodes, int num_nodes)
 	for (i = 0; i < num_nodes; i++)
 		if (fake_nodes[i].start != fake_nodes[i].end)
 			node_set(i, nodes_parsed);
-	WARN_ON(!nodes_cover_memory(fake_nodes));
 }
 
 static int null_slit_node_compare(int a, int b)
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 36fe08e..65b58e4 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -8,6 +8,7 @@
 
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
+#include <asm/cache.h>
 #include <asm/apic.h>
 #include <asm/uv/uv.h>
 
@@ -43,7 +44,7 @@ union smp_flush_state {
 		spinlock_t tlbstate_lock;
 		DECLARE_BITMAP(flush_cpumask, NR_CPUS);
 	};
-	char pad[CONFIG_X86_INTERNODE_CACHE_BYTES];
+	char pad[INTERNODE_CACHE_BYTES];
 } ____cacheline_internodealigned_in_smp;
 
 /* State is put into the per CPU data section, but padded
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 3439616..c5e805d 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1082,10 +1082,8 @@ asmlinkage void __init xen_start_kernel(void)
 
 	__supported_pte_mask |= _PAGE_IOMAP;
 
-#ifdef CONFIG_X86_64
 	/* Work out if we support NX */
-	check_efer();
-#endif
+	x86_configure_nx();
 
 	xen_setup_features();
 
diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
index 202dd0c..2be2fb6 100644
--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -283,22 +283,24 @@ acpi_table_parse_srat(enum acpi_srat_type id,
 
 int __init acpi_numa_init(void)
 {
+	int ret = 0;
+
 	/* SRAT: Static Resource Affinity Table */
 	if (!acpi_table_parse(ACPI_SIG_SRAT, acpi_parse_srat)) {
 		acpi_table_parse_srat(ACPI_SRAT_TYPE_X2APIC_CPU_AFFINITY,
 				      acpi_parse_x2apic_affinity, NR_CPUS);
 		acpi_table_parse_srat(ACPI_SRAT_TYPE_CPU_AFFINITY,
 				      acpi_parse_processor_affinity, NR_CPUS);
-		acpi_table_parse_srat(ACPI_SRAT_TYPE_MEMORY_AFFINITY,
-				      acpi_parse_memory_affinity,
-				      NR_NODE_MEMBLKS);
+		ret = acpi_table_parse_srat(ACPI_SRAT_TYPE_MEMORY_AFFINITY,
+					    acpi_parse_memory_affinity,
+					    NR_NODE_MEMBLKS);
 	}
 
 	/* SLIT: System Locality Information Table */
 	acpi_table_parse(ACPI_SIG_SLIT, acpi_parse_slit);
 
 	acpi_numa_arch_fixup();
-	return 0;
+	return ret;
 }
 
 int acpi_get_pxm(acpi_handle h)
