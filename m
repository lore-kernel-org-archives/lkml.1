Return-Path: <linux-kernel-owner+w=401wt.eu-S1753528AbYHPN5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbYHPN5U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 09:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbYHPN5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 09:57:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53486 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbYHPN5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 09:57:08 -0400
Date: Sat, 16 Aug 2008 15:56:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] x86 fixes for v2.6.27
Message-ID: <20080816135644.GA2637@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

Thanks,

	Ingo

------------------>
Alex Nixon (1):
      x86: change init_gdt to update the gdt via write_gdt, rather than a direct write.

Aristeu Rozanski (2):
      x86, perfctr: don't use CCCR_OVF_PMI1 on Pentium 4Ds
      x86, NMI: fix watchdog failure message

Arjan van de Ven (1):
      x86: use WARN() in arch/x86/mm/pageattr.c

Darrick J. Wong (1):
      x86, msr: fix NULL pointer deref due to msr_open on nonexistent CPUs

Dave Jones (1):
      x86: silence mmconfig printk

H. Peter Anvin (1):
      x86: cleanup for setup code crashes during IST probe

Hugh Dickins (1):
      x86: fix /proc/meminfo DirectMap

Ingo Molnar (2):
      x86, nmi: clean UP NMI watchdog failure message
      x86: add MAP_STACK mmap flag

Jan Beulich (2):
      x86: fix spin_is_contended()
      x86-64: fix overlap of modules and fixmap areas

Jens Rottmann (1):
      x86, geode-mfgpt: check IRQ before using MFGPT as clocksource

Joerg Roedel (5):
      x86: fix setup code crashes on my old 486 box
      x86, AMD IOMMU: use status bit instead of memory write-back for completion wait
      x86, AMD IOMMU: initialize device table properly
      x86m AMD IOMMU: cleanup: replace LOW_U32 macro with generic lower_32_bits
      x86, AMD IOMMU: initialize dma_ops after sysfs registration

Johannes Weiner (1):
      x86: propagate new nonpanic bootmem macros to CONFIG_HAVE_ARCH_BOOTMEM_NODE

John Keller (1):
      x86: allow MMCONFIG above 4GB on x86_64

Marcin Slusarz (4):
      x86: fix 2 section mismatch warnings - map_high()
      x86: fix 2 section mismatch warnings - find_and_reserve_crashkernel
      x86, acpi: cleanup, temp_stack is used only when CONFIG_SMP is set
      x86: fix section mismatch warning - spp_getpage()

Mark Langsdorf (1):
      x86: invalidate caches before going into suspend

Max Krasnyansky (1):
      x86: resurrect proper handling of maxcpus= kernel option (v2)

Mikael Pettersson (1):
      x86: fix readb() et al compile error with gcc-3.2.3

Pavel Machek (1):
      arch/x86/Kconfig: clean up, experimental adjustement

Suresh Siddha (1):
      x64, fpu: fix possible FPU leakage in error conditions

Thomas Gleixner (1):
      x86: hpet: workaround SB700 BIOS

Yinghai Lu (2):
      x86: don't call e820_regiter_active_regions if out of range on node
      x86: check bigsmp in smp_sanity_check instead of cpu_up


 arch/x86/Kconfig                       |    6 ++--
 arch/x86/boot/boot.h                   |    8 +++++
 arch/x86/boot/cpu.c                    |    3 --
 arch/x86/boot/cpucheck.c               |   10 +-----
 arch/x86/boot/main.c                   |    5 +++
 arch/x86/kernel/acpi/boot.c            |   16 +++++++++-
 arch/x86/kernel/acpi/sleep.c           |    2 +-
 arch/x86/kernel/amd_iommu.c            |   19 +++++++-----
 arch/x86/kernel/amd_iommu_init.c       |   24 +++++++++++++--
 arch/x86/kernel/apic_32.c              |    8 -----
 arch/x86/kernel/apic_64.c              |    7 ----
 arch/x86/kernel/cpu/perfctr-watchdog.c |    8 ++++-
 arch/x86/kernel/genx2apic_uv_x.c       |    2 +-
 arch/x86/kernel/head64.c               |    1 +
 arch/x86/kernel/hpet.c                 |   24 ++++++++++++++
 arch/x86/kernel/mfgpt_32.c             |   52 ++++++++++++++++++++++---------
 arch/x86/kernel/msr.c                  |    2 +-
 arch/x86/kernel/nmi.c                  |   28 +++++++++++-----
 arch/x86/kernel/process_32.c           |    5 +--
 arch/x86/kernel/process_64.c           |    5 +--
 arch/x86/kernel/setup.c                |    2 +-
 arch/x86/kernel/signal_64.c            |   11 ++++++-
 arch/x86/kernel/smpboot.c              |   52 +++++++++++++++++--------------
 arch/x86/kernel/smpcommon.c            |   17 ++++++----
 arch/x86/kernel/traps_64.c             |    9 +++++-
 arch/x86/kernel/visws_quirks.c         |    6 +--
 arch/x86/mm/init_64.c                  |   12 ++++++-
 arch/x86/mm/pageattr-test.c            |    3 +-
 arch/x86/mm/pageattr.c                 |   21 ++++++++-----
 arch/x86/mm/srat_32.c                  |   12 +++++--
 arch/x86/pci/mmconfig-shared.c         |    2 +-
 include/asm-x86/amd_iommu_types.h      |    8 +++--
 include/asm-x86/geode.h                |    3 +-
 include/asm-x86/i387.h                 |    2 -
 include/asm-x86/io.h                   |   18 +++++-----
 include/asm-x86/mman.h                 |    1 +
 include/asm-x86/mmzone_32.h            |    6 ++++
 include/asm-x86/pgtable_64.h           |    2 +-
 include/asm-x86/processor.h            |   23 ++++++++++++++
 include/asm-x86/spinlock.h             |    4 +-
 40 files changed, 300 insertions(+), 149 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ac2fb06..68d91c8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -951,9 +951,9 @@ config NUMA
 	  local memory controller of the CPU and add some more
 	  NUMA awareness to the kernel.
 
-	  For i386 this is currently highly experimental and should be only
+	  For 32-bit this is currently highly experimental and should be only
 	  used for kernel development. It might also cause boot failures.
-	  For x86_64 this is recommended on all multiprocessor Opteron systems.
+	  For 64-bit this is recommended on all multiprocessor Opteron systems.
 	  If the system is EM64T, you should say N unless your system is
 	  EM64T NUMA.
 
@@ -1263,7 +1263,7 @@ config KEXEC
 	  strongly in flux, so no good recommendation can be made.
 
 config CRASH_DUMP
-	bool "kernel crash dumps (EXPERIMENTAL)"
+	bool "kernel crash dumps"
 	depends on X86_64 || (X86_32 && HIGHMEM)
 	help
 	  Generate crash dump after being started by kexec.
diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index a34b998..616b804 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -24,6 +24,8 @@
 #include <linux/edd.h>
 #include <asm/boot.h>
 #include <asm/setup.h>
+#include "bitops.h"
+#include <asm/cpufeature.h>
 
 /* Useful macros */
 #define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
@@ -242,6 +244,12 @@ int cmdline_find_option(const char *option, char *buffer, int bufsize);
 int cmdline_find_option_bool(const char *option);
 
 /* cpu.c, cpucheck.c */
+struct cpu_features {
+	int level;		/* Family, or 64 for x86-64 */
+	int model;
+	u32 flags[NCAPINTS];
+};
+extern struct cpu_features cpu;
 int check_cpu(int *cpu_level_ptr, int *req_level_ptr, u32 **err_flags_ptr);
 int validate_cpu(void);
 
diff --git a/arch/x86/boot/cpu.c b/arch/x86/boot/cpu.c
index 92d6fd7..75298fe 100644
--- a/arch/x86/boot/cpu.c
+++ b/arch/x86/boot/cpu.c
@@ -16,9 +16,6 @@
  */
 
 #include "boot.h"
-#include "bitops.h"
-#include <asm/cpufeature.h>
-
 #include "cpustr.h"
 
 static char *cpu_name(int level)
diff --git a/arch/x86/boot/cpucheck.c b/arch/x86/boot/cpucheck.c
index 7804389..4b9ae7c 100644
--- a/arch/x86/boot/cpucheck.c
+++ b/arch/x86/boot/cpucheck.c
@@ -22,21 +22,13 @@
 
 #ifdef _SETUP
 # include "boot.h"
-# include "bitops.h"
 #endif
 #include <linux/types.h>
-#include <asm/cpufeature.h>
 #include <asm/processor-flags.h>
 #include <asm/required-features.h>
 #include <asm/msr-index.h>
 
-struct cpu_features {
-	int level;		/* Family, or 64 for x86-64 */
-	int model;
-	u32 flags[NCAPINTS];
-};
-
-static struct cpu_features cpu;
+struct cpu_features cpu;
 static u32 cpu_vendor[3];
 static u32 err_flags[NCAPINTS];
 
diff --git a/arch/x86/boot/main.c b/arch/x86/boot/main.c
index 2296164..197421d 100644
--- a/arch/x86/boot/main.c
+++ b/arch/x86/boot/main.c
@@ -73,6 +73,11 @@ static void keyboard_set_repeat(void)
  */
 static void query_ist(void)
 {
+	/* Some older BIOSes apparently crash on this call, so filter
+	   it from machines too old to have SpeedStep at all. */
+	if (cpu.level < 6)
+		return;
+
 	asm("int $0x15"
 	    : "=a" (boot_params.ist_info.signature),
 	      "=b" (boot_params.ist_info.command),
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index fa88a1d..bfd10fd 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -97,6 +97,8 @@ static u64 acpi_lapic_addr __initdata = APIC_DEFAULT_PHYS_BASE;
 #warning ACPI uses CMPXCHG, i486 and later hardware
 #endif
 
+static int acpi_mcfg_64bit_base_addr __initdata = FALSE;
+
 /* --------------------------------------------------------------------------
                               Boot-time Configuration
    -------------------------------------------------------------------------- */
@@ -158,6 +160,14 @@ char *__init __acpi_map_table(unsigned long phys, unsigned long size)
 struct acpi_mcfg_allocation *pci_mmcfg_config;
 int pci_mmcfg_config_num;
 
+static int __init acpi_mcfg_oem_check(struct acpi_table_mcfg *mcfg)
+{
+	if (!strcmp(mcfg->header.oem_id, "SGI"))
+		acpi_mcfg_64bit_base_addr = TRUE;
+
+	return 0;
+}
+
 int __init acpi_parse_mcfg(struct acpi_table_header *header)
 {
 	struct acpi_table_mcfg *mcfg;
@@ -190,8 +200,12 @@ int __init acpi_parse_mcfg(struct acpi_table_header *header)
 	}
 
 	memcpy(pci_mmcfg_config, &mcfg[1], config_size);
+
+	acpi_mcfg_oem_check(mcfg);
+
 	for (i = 0; i < pci_mmcfg_config_num; ++i) {
-		if (pci_mmcfg_config[i].address > 0xFFFFFFFF) {
+		if ((pci_mmcfg_config[i].address > 0xFFFFFFFF) &&
+		    !acpi_mcfg_64bit_base_addr) {
 			printk(KERN_ERR PREFIX
 			       "MMCONFIG not in low 4GB of memory\n");
 			kfree(pci_mmcfg_config);
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index fa2161d..81e5ab6 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -20,7 +20,7 @@ unsigned long acpi_realmode_flags;
 /* address in low memory of the wakeup routine. */
 static unsigned long acpi_realmode;
 
-#ifdef CONFIG_64BIT
+#if defined(CONFIG_SMP) && defined(CONFIG_64BIT)
 static char temp_stack[10240];
 #endif
 
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 22d7d05..de39e1f 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -101,16 +101,13 @@ static int iommu_queue_command(struct amd_iommu *iommu, struct iommu_cmd *cmd)
  */
 static int iommu_completion_wait(struct amd_iommu *iommu)
 {
-	int ret;
+	int ret, ready = 0;
+	unsigned status = 0;
 	struct iommu_cmd cmd;
-	volatile u64 ready = 0;
-	unsigned long ready_phys = virt_to_phys(&ready);
 	unsigned long i = 0;
 
 	memset(&cmd, 0, sizeof(cmd));
-	cmd.data[0] = LOW_U32(ready_phys) | CMD_COMPL_WAIT_STORE_MASK;
-	cmd.data[1] = upper_32_bits(ready_phys);
-	cmd.data[2] = 1; /* value written to 'ready' */
+	cmd.data[0] = CMD_COMPL_WAIT_INT_MASK;
 	CMD_SET_TYPE(&cmd, CMD_COMPL_WAIT);
 
 	iommu->need_sync = 0;
@@ -122,9 +119,15 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
 
 	while (!ready && (i < EXIT_LOOP_COUNT)) {
 		++i;
-		cpu_relax();
+		/* wait for the bit to become one */
+		status = readl(iommu->mmio_base + MMIO_STATUS_OFFSET);
+		ready = status & MMIO_STATUS_COM_WAIT_INT_MASK;
 	}
 
+	/* set bit back to zero */
+	status &= ~MMIO_STATUS_COM_WAIT_INT_MASK;
+	writel(status, iommu->mmio_base + MMIO_STATUS_OFFSET);
+
 	if (unlikely((i == EXIT_LOOP_COUNT) && printk_ratelimit()))
 		printk(KERN_WARNING "AMD IOMMU: Completion wait loop failed\n");
 
@@ -161,7 +164,7 @@ static int iommu_queue_inv_iommu_pages(struct amd_iommu *iommu,
 	address &= PAGE_MASK;
 	CMD_SET_TYPE(&cmd, CMD_INV_IOMMU_PAGES);
 	cmd.data[1] |= domid;
-	cmd.data[2] = LOW_U32(address);
+	cmd.data[2] = lower_32_bits(address);
 	cmd.data[3] = upper_32_bits(address);
 	if (s) /* size bit - we flush more than one 4kb page */
 		cmd.data[2] |= CMD_INV_IOMMU_PAGES_SIZE_MASK;
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index d9a9da5..a69cc0f 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -801,6 +801,21 @@ static int __init init_memory_definitions(struct acpi_table_header *table)
 }
 
 /*
+ * Init the device table to not allow DMA access for devices and
+ * suppress all page faults
+ */
+static void init_device_table(void)
+{
+	u16 devid;
+
+	for (devid = 0; devid <= amd_iommu_last_bdf; ++devid) {
+		set_dev_entry_bit(devid, DEV_ENTRY_VALID);
+		set_dev_entry_bit(devid, DEV_ENTRY_TRANSLATION);
+		set_dev_entry_bit(devid, DEV_ENTRY_NO_PAGE_FAULT);
+	}
+}
+
+/*
  * This function finally enables all IOMMUs found in the system after
  * they have been initialized
  */
@@ -931,6 +946,9 @@ int __init amd_iommu_init(void)
 	if (amd_iommu_pd_alloc_bitmap == NULL)
 		goto free;
 
+	/* init the device table */
+	init_device_table();
+
 	/*
 	 * let all alias entries point to itself
 	 */
@@ -954,15 +972,15 @@ int __init amd_iommu_init(void)
 	if (acpi_table_parse("IVRS", init_memory_definitions) != 0)
 		goto free;
 
-	ret = amd_iommu_init_dma_ops();
+	ret = sysdev_class_register(&amd_iommu_sysdev_class);
 	if (ret)
 		goto free;
 
-	ret = sysdev_class_register(&amd_iommu_sysdev_class);
+	ret = sysdev_register(&device_amd_iommu);
 	if (ret)
 		goto free;
 
-	ret = sysdev_register(&device_amd_iommu);
+	ret = amd_iommu_init_dma_ops();
 	if (ret)
 		goto free;
 
diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 039a8d4..f88bd0d 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1454,8 +1454,6 @@ void disconnect_bsp_APIC(int virt_wire_setup)
 	}
 }
 
-unsigned int __cpuinitdata maxcpus = NR_CPUS;
-
 void __cpuinit generic_processor_info(int apicid, int version)
 {
 	int cpu;
@@ -1482,12 +1480,6 @@ void __cpuinit generic_processor_info(int apicid, int version)
 		return;
 	}
 
-	if (num_processors >= maxcpus) {
-		printk(KERN_WARNING "WARNING: maxcpus limit of %i reached."
-			" Processor ignored.\n", maxcpus);
-		return;
-	}
-
 	num_processors++;
 	cpus_complement(tmp_map, cpu_present_map);
 	cpu = first_cpu(tmp_map);
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 7f1f030..446c062 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -90,7 +90,6 @@ static unsigned long apic_phys;
 
 unsigned long mp_lapic_addr;
 
-unsigned int __cpuinitdata maxcpus = NR_CPUS;
 /*
  * Get the LAPIC version
  */
@@ -1062,12 +1061,6 @@ void __cpuinit generic_processor_info(int apicid, int version)
 		return;
 	}
 
-	if (num_processors >= maxcpus) {
-		printk(KERN_WARNING "WARNING: maxcpus limit of %i reached."
-		       " Processor ignored.\n", maxcpus);
-		return;
-	}
-
 	num_processors++;
 	cpus_complement(tmp_map, cpu_present_map);
 	cpu = first_cpu(tmp_map);
diff --git a/arch/x86/kernel/cpu/perfctr-watchdog.c b/arch/x86/kernel/cpu/perfctr-watchdog.c
index de7439f..05cc22d 100644
--- a/arch/x86/kernel/cpu/perfctr-watchdog.c
+++ b/arch/x86/kernel/cpu/perfctr-watchdog.c
@@ -478,7 +478,13 @@ static int setup_p4_watchdog(unsigned nmi_hz)
 		perfctr_msr = MSR_P4_IQ_PERFCTR1;
 		evntsel_msr = MSR_P4_CRU_ESCR0;
 		cccr_msr = MSR_P4_IQ_CCCR1;
-		cccr_val = P4_CCCR_OVF_PMI1 | P4_CCCR_ESCR_SELECT(4);
+
+		/* Pentium 4 D processors don't support P4_CCCR_OVF_PMI1 */
+		if (boot_cpu_data.x86_model == 4 && boot_cpu_data.x86_mask == 4)
+			cccr_val = P4_CCCR_OVF_PMI0;
+		else
+			cccr_val = P4_CCCR_OVF_PMI1;
+		cccr_val |= P4_CCCR_ESCR_SELECT(4);
 	}
 
 	evntsel = P4_ESCR_EVENT_SELECT(0x3F)
diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index 2cfcbde..2d7e307 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -222,7 +222,7 @@ static __init void map_low_mmrs(void)
 
 enum map_type {map_wb, map_uc};
 
-static void map_high(char *id, unsigned long base, int shift, enum map_type map_type)
+static __init void map_high(char *id, unsigned long base, int shift, enum map_type map_type)
 {
 	unsigned long bytes, paddr;
 
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 1b318e9..9bfc4d7 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -88,6 +88,7 @@ void __init x86_64_start_kernel(char * real_mode_data)
 	BUILD_BUG_ON(!(MODULES_VADDR > __START_KERNEL));
 	BUILD_BUG_ON(!(((MODULES_END - 1) & PGDIR_MASK) ==
 				(__START_KERNEL & PGDIR_MASK)));
+	BUILD_BUG_ON(__fix_to_virt(__end_of_fixed_addresses) <= MODULES_END);
 
 	/* clear bss before set_intr_gate with early_idt_handler */
 	clear_bss();
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index ad2b15a..59fd3b6 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -359,6 +359,7 @@ static int hpet_clocksource_register(void)
 int __init hpet_enable(void)
 {
 	unsigned long id;
+	int i;
 
 	if (!is_hpet_capable())
 		return 0;
@@ -369,6 +370,29 @@ int __init hpet_enable(void)
 	 * Read the period and check for a sane value:
 	 */
 	hpet_period = hpet_readl(HPET_PERIOD);
+
+	/*
+	 * AMD SB700 based systems with spread spectrum enabled use a
+	 * SMM based HPET emulation to provide proper frequency
+	 * setting. The SMM code is initialized with the first HPET
+	 * register access and takes some time to complete. During
+	 * this time the config register reads 0xffffffff. We check
+	 * for max. 1000 loops whether the config register reads a non
+	 * 0xffffffff value to make sure that HPET is up and running
+	 * before we go further. A counting loop is safe, as the HPET
+	 * access takes thousands of CPU cycles. On non SB700 based
+	 * machines this check is only done once and has no side
+	 * effects.
+	 */
+	for (i = 0; hpet_readl(HPET_CFG) == 0xFFFFFFFF; i++) {
+		if (i == 1000) {
+			printk(KERN_WARNING
+			       "HPET config register value = 0xFFFFFFFF. "
+			       "Disabling HPET\n");
+			goto out_nohpet;
+		}
+	}
+
 	if (hpet_period < HPET_MIN_PERIOD || hpet_period > HPET_MAX_PERIOD)
 		goto out_nohpet;
 
diff --git a/arch/x86/kernel/mfgpt_32.c b/arch/x86/kernel/mfgpt_32.c
index 07c0f82..3b59951 100644
--- a/arch/x86/kernel/mfgpt_32.c
+++ b/arch/x86/kernel/mfgpt_32.c
@@ -33,6 +33,8 @@
 #include <linux/module.h>
 #include <asm/geode.h>
 
+#define MFGPT_DEFAULT_IRQ	7
+
 static struct mfgpt_timer_t {
 	unsigned int avail:1;
 } mfgpt_timers[MFGPT_MAX_TIMERS];
@@ -157,29 +159,48 @@ int geode_mfgpt_toggle_event(int timer, int cmp, int event, int enable)
 }
 EXPORT_SYMBOL_GPL(geode_mfgpt_toggle_event);
 
-int geode_mfgpt_set_irq(int timer, int cmp, int irq, int enable)
+int geode_mfgpt_set_irq(int timer, int cmp, int *irq, int enable)
 {
-	u32 val, dummy;
-	int offset;
+	u32 zsel, lpc, dummy;
+	int shift;
 
 	if (timer < 0 || timer >= MFGPT_MAX_TIMERS)
 		return -EIO;
 
-	if (geode_mfgpt_toggle_event(timer, cmp, MFGPT_EVENT_IRQ, enable))
+	/*
+	 * Unfortunately, MFGPTs come in pairs sharing their IRQ lines. If VSA
+	 * is using the same CMP of the timer's Siamese twin, the IRQ is set to
+	 * 2, and we mustn't use nor change it.
+	 * XXX: Likewise, 2 Linux drivers might clash if the 2nd overwrites the
+	 * IRQ of the 1st. This can only happen if forcing an IRQ, calling this
+	 * with *irq==0 is safe. Currently there _are_ no 2 drivers.
+	 */
+	rdmsr(MSR_PIC_ZSEL_LOW, zsel, dummy);
+	shift = ((cmp == MFGPT_CMP1 ? 0 : 4) + timer % 4) * 4;
+	if (((zsel >> shift) & 0xF) == 2)
 		return -EIO;
 
-	rdmsr(MSR_PIC_ZSEL_LOW, val, dummy);
+	/* Choose IRQ: if none supplied, keep IRQ already set or use default */
+	if (!*irq)
+		*irq = (zsel >> shift) & 0xF;
+	if (!*irq)
+		*irq = MFGPT_DEFAULT_IRQ;
 
-	offset = (timer % 4) * 4;
-
-	val &= ~((0xF << offset) | (0xF << (offset + 16)));
+	/* Can't use IRQ if it's 0 (=disabled), 2, or routed to LPC */
+	if (*irq < 1 || *irq == 2 || *irq > 15)
+		return -EIO;
+	rdmsr(MSR_PIC_IRQM_LPC, lpc, dummy);
+	if (lpc & (1 << *irq))
+		return -EIO;
 
+	/* All chosen and checked - go for it */
+	if (geode_mfgpt_toggle_event(timer, cmp, MFGPT_EVENT_IRQ, enable))
+		return -EIO;
 	if (enable) {
-		val |= (irq & 0x0F) << (offset);
-		val |= (irq & 0x0F) << (offset + 16);
+		zsel = (zsel & ~(0xF << shift)) | (*irq << shift);
+		wrmsr(MSR_PIC_ZSEL_LOW, zsel, dummy);
 	}
 
-	wrmsr(MSR_PIC_ZSEL_LOW, val, dummy);
 	return 0;
 }
 
@@ -242,7 +263,7 @@ EXPORT_SYMBOL_GPL(geode_mfgpt_alloc_timer);
 static unsigned int mfgpt_tick_mode = CLOCK_EVT_MODE_SHUTDOWN;
 static u16 mfgpt_event_clock;
 
-static int irq = 7;
+static int irq;
 static int __init mfgpt_setup(char *str)
 {
 	get_option(&str, &irq);
@@ -346,7 +367,7 @@ int __init mfgpt_timer_setup(void)
 	mfgpt_event_clock = timer;
 
 	/* Set up the IRQ on the MFGPT side */
-	if (geode_mfgpt_setup_irq(mfgpt_event_clock, MFGPT_CMP2, irq)) {
+	if (geode_mfgpt_setup_irq(mfgpt_event_clock, MFGPT_CMP2, &irq)) {
 		printk(KERN_ERR "mfgpt-timer:  Could not set up IRQ %d\n", irq);
 		return -EIO;
 	}
@@ -374,13 +395,14 @@ int __init mfgpt_timer_setup(void)
 			&mfgpt_clockevent);
 
 	printk(KERN_INFO
-	       "mfgpt-timer:  registering the MFGPT timer as a clock event.\n");
+	       "mfgpt-timer:  Registering MFGPT timer %d as a clock event, using IRQ %d\n",
+	       timer, irq);
 	clockevents_register_device(&mfgpt_clockevent);
 
 	return 0;
 
 err:
-	geode_mfgpt_release_irq(mfgpt_event_clock, MFGPT_CMP2, irq);
+	geode_mfgpt_release_irq(mfgpt_event_clock, MFGPT_CMP2, &irq);
 	printk(KERN_ERR
 	       "mfgpt-timer:  Unable to set up the MFGPT clock source\n");
 	return -EIO;
diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 9fd8095..e439380 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -131,7 +131,7 @@ static int msr_open(struct inode *inode, struct file *file)
 		ret = -EIO;	/* MSR not supported */
 out:
 	unlock_kernel();
-	return 0;
+	return ret;
 }
 
 /*
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index ac6d512..abb78a2 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -114,6 +114,23 @@ static __init void nmi_cpu_busy(void *data)
 }
 #endif
 
+static void report_broken_nmi(int cpu, int *prev_nmi_count)
+{
+	printk(KERN_CONT "\n");
+
+	printk(KERN_WARNING
+		"WARNING: CPU#%d: NMI appears to be stuck (%d->%d)!\n",
+			cpu, prev_nmi_count[cpu], get_nmi_count(cpu));
+
+	printk(KERN_WARNING
+		"Please report this to bugzilla.kernel.org,\n");
+	printk(KERN_WARNING
+		"and attach the output of the 'dmesg' command.\n");
+
+	per_cpu(wd_enabled, cpu) = 0;
+	atomic_dec(&nmi_active);
+}
+
 int __init check_nmi_watchdog(void)
 {
 	unsigned int *prev_nmi_count;
@@ -141,15 +158,8 @@ int __init check_nmi_watchdog(void)
 	for_each_online_cpu(cpu) {
 		if (!per_cpu(wd_enabled, cpu))
 			continue;
-		if (get_nmi_count(cpu) - prev_nmi_count[cpu] <= 5) {
-			printk(KERN_WARNING "WARNING: CPU#%d: NMI "
-				"appears to be stuck (%d->%d)!\n",
-				cpu,
-				prev_nmi_count[cpu],
-				get_nmi_count(cpu));
-			per_cpu(wd_enabled, cpu) = 0;
-			atomic_dec(&nmi_active);
-		}
+		if (get_nmi_count(cpu) - prev_nmi_count[cpu] <= 5)
+			report_broken_nmi(cpu, prev_nmi_count);
 	}
 	endflag = 1;
 	if (!atomic_read(&nmi_active)) {
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 53bc653..3b7a1dd 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -95,7 +95,6 @@ static inline void play_dead(void)
 {
 	/* This must be done before dead CPU ack */
 	cpu_exit_clear();
-	wbinvd();
 	mb();
 	/* Ack it */
 	__get_cpu_var(cpu_state) = CPU_DEAD;
@@ -104,8 +103,8 @@ static inline void play_dead(void)
 	 * With physical CPU hotplug, we should halt the cpu
 	 */
 	local_irq_disable();
-	while (1)
-		halt();
+	/* mask all interrupts, flush any and all caches, and halt */
+	wbinvd_halt();
 }
 #else
 static inline void play_dead(void)
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 3fb62a7..71553b6 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -93,14 +93,13 @@ DECLARE_PER_CPU(int, cpu_state);
 static inline void play_dead(void)
 {
 	idle_task_exit();
-	wbinvd();
 	mb();
 	/* Ack it */
 	__get_cpu_var(cpu_state) = CPU_DEAD;
 
 	local_irq_disable();
-	while (1)
-		halt();
+	/* mask all interrupts, flush any and all caches, and halt */
+	wbinvd_halt();
 }
 #else
 static inline void play_dead(void)
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 68b48e3..a4656ad 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -445,7 +445,7 @@ static void __init reserve_early_setup_data(void)
  * @size: Size of the crashkernel memory to reserve.
  * Returns the base address on success, and -1ULL on failure.
  */
-unsigned long long find_and_reserve_crashkernel(unsigned long long size)
+unsigned long long __init find_and_reserve_crashkernel(unsigned long long size)
 {
 	const unsigned long long alignment = 16<<20; 	/* 16M */
 	unsigned long long start = 0LL;
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index b45ef8d..ca316b5 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -104,7 +104,16 @@ static inline int restore_i387(struct _fpstate __user *buf)
 		clts();
 		task_thread_info(current)->status |= TS_USEDFPU;
 	}
-	return restore_fpu_checking((__force struct i387_fxsave_struct *)buf);
+	err = restore_fpu_checking((__force struct i387_fxsave_struct *)buf);
+	if (unlikely(err)) {
+		/*
+		 * Encountered an error while doing the restore from the
+		 * user buffer, clear the fpu state.
+		 */
+		clear_fpu(tsk);
+		clear_used_math();
+	}
+	return err;
 }
 
 /*
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 91055d7..a8fb8a9 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -994,17 +994,7 @@ int __cpuinit native_cpu_up(unsigned int cpu)
 	flush_tlb_all();
 	low_mappings = 1;
 
-#ifdef CONFIG_X86_PC
-	if (def_to_bigsmp && apicid > 8) {
-		printk(KERN_WARNING
-			"More than 8 CPUs detected - skipping them.\n"
-			"Use CONFIG_X86_GENERICARCH and CONFIG_X86_BIGSMP.\n");
-		err = -1;
-	} else
-		err = do_boot_cpu(apicid, cpu);
-#else
 	err = do_boot_cpu(apicid, cpu);
-#endif
 
 	zap_low_mappings();
 	low_mappings = 0;
@@ -1058,6 +1048,34 @@ static __init void disable_smp(void)
 static int __init smp_sanity_check(unsigned max_cpus)
 {
 	preempt_disable();
+
+#if defined(CONFIG_X86_PC) && defined(CONFIG_X86_32)
+	if (def_to_bigsmp && nr_cpu_ids > 8) {
+		unsigned int cpu;
+		unsigned nr;
+
+		printk(KERN_WARNING
+		       "More than 8 CPUs detected - skipping them.\n"
+		       "Use CONFIG_X86_GENERICARCH and CONFIG_X86_BIGSMP.\n");
+
+		nr = 0;
+		for_each_present_cpu(cpu) {
+			if (nr >= 8)
+				cpu_clear(cpu, cpu_present_map);
+			nr++;
+		}
+
+		nr = 0;
+		for_each_possible_cpu(cpu) {
+			if (nr >= 8)
+				cpu_clear(cpu, cpu_possible_map);
+			nr++;
+		}
+
+		nr_cpu_ids = 8;
+	}
+#endif
+
 	if (!physid_isset(hard_smp_processor_id(), phys_cpu_present_map)) {
 		printk(KERN_WARNING "weird, boot CPU (#%d) not listed"
 				    "by the BIOS.\n", hard_smp_processor_id());
@@ -1386,17 +1404,3 @@ void __cpu_die(unsigned int cpu)
 	BUG();
 }
 #endif
-
-/*
- * If the BIOS enumerates physical processors before logical,
- * maxcpus=N at enumeration-time can be used to disable HT.
- */
-static int __init parse_maxcpus(char *arg)
-{
-	extern unsigned int maxcpus;
-
-	if (arg)
-		maxcpus = simple_strtoul(arg, NULL, 0);
-	return 0;
-}
-early_param("maxcpus", parse_maxcpus);
diff --git a/arch/x86/kernel/smpcommon.c b/arch/x86/kernel/smpcommon.c
index 99941b3..397e309 100644
--- a/arch/x86/kernel/smpcommon.c
+++ b/arch/x86/kernel/smpcommon.c
@@ -8,18 +8,21 @@
 DEFINE_PER_CPU(unsigned long, this_cpu_off);
 EXPORT_PER_CPU_SYMBOL(this_cpu_off);
 
-/* Initialize the CPU's GDT.  This is either the boot CPU doing itself
-   (still using the master per-cpu area), or a CPU doing it for a
-   secondary which will soon come up. */
+/*
+ * Initialize the CPU's GDT.  This is either the boot CPU doing itself
+ * (still using the master per-cpu area), or a CPU doing it for a
+ * secondary which will soon come up.
+ */
 __cpuinit void init_gdt(int cpu)
 {
-	struct desc_struct *gdt = get_cpu_gdt_table(cpu);
+	struct desc_struct gdt;
 
-	pack_descriptor(&gdt[GDT_ENTRY_PERCPU],
-			__per_cpu_offset[cpu], 0xFFFFF,
+	pack_descriptor(&gdt, __per_cpu_offset[cpu], 0xFFFFF,
 			0x2 | DESCTYPE_S, 0x8);
+	gdt.s = 1;
 
-	gdt[GDT_ENTRY_PERCPU].s = 1;
+	write_gdt_entry(get_cpu_gdt_table(cpu),
+			GDT_ENTRY_PERCPU, &gdt, DESCTYPE_S);
 
 	per_cpu(this_cpu_off, cpu) = __per_cpu_offset[cpu];
 	per_cpu(cpu_number, cpu) = cpu;
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index 3f18d73..513caac 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -1131,7 +1131,14 @@ asmlinkage void math_state_restore(void)
 	}
 
 	clts();				/* Allow maths ops (or we recurse) */
-	restore_fpu_checking(&me->thread.xstate->fxsave);
+	/*
+	 * Paranoid restore. send a SIGSEGV if we fail to restore the state.
+	 */
+	if (unlikely(restore_fpu_checking(&me->thread.xstate->fxsave))) {
+		stts();
+		force_sig(SIGSEGV, me);
+		return;
+	}
 	task_thread_info(me)->status |= TS_USEDFPU;
 	me->fpu_counter++;
 }
diff --git a/arch/x86/kernel/visws_quirks.c b/arch/x86/kernel/visws_quirks.c
index 41e01b1..594ef47 100644
--- a/arch/x86/kernel/visws_quirks.c
+++ b/arch/x86/kernel/visws_quirks.c
@@ -184,8 +184,6 @@ static int __init visws_get_smp_config(unsigned int early)
 	return 1;
 }
 
-extern unsigned int __cpuinitdata maxcpus;
-
 /*
  * The Visual Workstation is Intel MP compliant in the hardware
  * sense, but it doesn't have a BIOS(-configuration table).
@@ -244,8 +242,8 @@ static int __init visws_find_smp_config(unsigned int reserve)
 		ncpus = CO_CPU_MAX;
 	}
 
-	if (ncpus > maxcpus)
-		ncpus = maxcpus;
+	if (ncpus > setup_max_cpus)
+		ncpus = setup_max_cpus;
 
 #ifdef CONFIG_X86_LOCAL_APIC
 	smp_found_config = 1;
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 129618c..a87ea0e 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -60,7 +60,7 @@ static unsigned long dma_reserve __initdata;
 
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 
-int direct_gbpages __meminitdata
+int direct_gbpages
 #ifdef CONFIG_DIRECT_GBPAGES
 				= 1
 #endif
@@ -88,7 +88,11 @@ early_param("gbpages", parse_direct_gbpages_on);
 
 int after_bootmem;
 
-static __init void *spp_getpage(void)
+/*
+ * NOTE: This function is marked __ref because it calls __init function
+ * (alloc_bootmem_pages). It's safe to do it ONLY when after_bootmem == 0.
+ */
+static __ref void *spp_getpage(void)
 {
 	void *ptr;
 
@@ -314,6 +318,7 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 {
 	unsigned long pages = 0;
 	unsigned long last_map_addr = end;
+	unsigned long start = address;
 
 	int i = pmd_index(address);
 
@@ -334,6 +339,9 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 			if (!pmd_large(*pmd))
 				last_map_addr = phys_pte_update(pmd, address,
 								 end);
+			/* Count entries we're using from level2_ident_pgt */
+			if (start == 0)
+				pages++;
 			continue;
 		}
 
diff --git a/arch/x86/mm/pageattr-test.c b/arch/x86/mm/pageattr-test.c
index 0dcd42e..d4aa503 100644
--- a/arch/x86/mm/pageattr-test.c
+++ b/arch/x86/mm/pageattr-test.c
@@ -221,8 +221,7 @@ static int pageattr_test(void)
 	failed += print_split(&sc);
 
 	if (failed) {
-		printk(KERN_ERR "NOT PASSED. Please report.\n");
-		WARN_ON(1);
+		WARN(1, KERN_ERR "NOT PASSED. Please report.\n");
 		return -EINVAL;
 	} else {
 		if (print)
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 65c6e46..f5f5154 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -55,13 +55,19 @@ static void split_page_count(int level)
 
 int arch_report_meminfo(char *page)
 {
-	int n = sprintf(page, "DirectMap4k:  %8lu\n"
-			"DirectMap2M:  %8lu\n",
-			direct_pages_count[PG_LEVEL_4K],
-			direct_pages_count[PG_LEVEL_2M]);
+	int n = sprintf(page, "DirectMap4k:  %8lu kB\n",
+			direct_pages_count[PG_LEVEL_4K] << 2);
+#if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
+	n += sprintf(page + n, "DirectMap2M:  %8lu kB\n",
+			direct_pages_count[PG_LEVEL_2M] << 11);
+#else
+	n += sprintf(page + n, "DirectMap4M:  %8lu kB\n",
+			direct_pages_count[PG_LEVEL_2M] << 12);
+#endif
 #ifdef CONFIG_X86_64
-	n += sprintf(page + n, "DirectMap1G:  %8lu\n",
-		     direct_pages_count[PG_LEVEL_1G]);
+	if (direct_gbpages)
+		n += sprintf(page + n, "DirectMap1G:  %8lu kB\n",
+			direct_pages_count[PG_LEVEL_1G] << 20);
 #endif
 	return n;
 }
@@ -592,10 +598,9 @@ repeat:
 	if (!pte_val(old_pte)) {
 		if (!primary)
 			return 0;
-		printk(KERN_WARNING "CPA: called for zero pte. "
+		WARN(1, KERN_WARNING "CPA: called for zero pte. "
 		       "vaddr = %lx cpa->vaddr = %lx\n", address,
 		       cpa->vaddr);
-		WARN_ON(1);
 		return -EINVAL;
 	}
 
diff --git a/arch/x86/mm/srat_32.c b/arch/x86/mm/srat_32.c
index 1eb2973..16ae70f 100644
--- a/arch/x86/mm/srat_32.c
+++ b/arch/x86/mm/srat_32.c
@@ -178,7 +178,7 @@ void acpi_numa_arch_fixup(void)
  * start of the node, and that the current "end" address is after
  * the previous one.
  */
-static __init void node_read_chunk(int nid, struct node_memory_chunk_s *memory_chunk)
+static __init int node_read_chunk(int nid, struct node_memory_chunk_s *memory_chunk)
 {
 	/*
 	 * Only add present memory as told by the e820.
@@ -189,10 +189,10 @@ static __init void node_read_chunk(int nid, struct node_memory_chunk_s *memory_c
 	if (memory_chunk->start_pfn >= max_pfn) {
 		printk(KERN_INFO "Ignoring SRAT pfns: %08lx - %08lx\n",
 			memory_chunk->start_pfn, memory_chunk->end_pfn);
-		return;
+		return -1;
 	}
 	if (memory_chunk->nid != nid)
-		return;
+		return -1;
 
 	if (!node_has_online_mem(nid))
 		node_start_pfn[nid] = memory_chunk->start_pfn;
@@ -202,6 +202,8 @@ static __init void node_read_chunk(int nid, struct node_memory_chunk_s *memory_c
 
 	if (node_end_pfn[nid] < memory_chunk->end_pfn)
 		node_end_pfn[nid] = memory_chunk->end_pfn;
+
+	return 0;
 }
 
 int __init get_memcfg_from_srat(void)
@@ -259,7 +261,9 @@ int __init get_memcfg_from_srat(void)
 		printk(KERN_DEBUG
 			"chunk %d nid %d start_pfn %08lx end_pfn %08lx\n",
 		       j, chunk->nid, chunk->start_pfn, chunk->end_pfn);
-		node_read_chunk(chunk->nid, chunk);
+		if (node_read_chunk(chunk->nid, chunk))
+			continue;
+
 		e820_register_active_regions(chunk->nid, chunk->start_pfn,
 					     min(chunk->end_pfn, max_pfn));
 	}
diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index 23faaa8..2bd5c53 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -365,7 +365,7 @@ static void __init pci_mmcfg_reject_broken(int early)
 	return;
 
 reject:
-	printk(KERN_ERR "PCI: Not using MMCONFIG.\n");
+	printk(KERN_INFO "PCI: Not using MMCONFIG.\n");
 	pci_mmcfg_arch_free();
 	kfree(pci_mmcfg_config);
 	pci_mmcfg_config = NULL;
diff --git a/include/asm-x86/amd_iommu_types.h b/include/asm-x86/amd_iommu_types.h
index 22aa58c..dcc8120 100644
--- a/include/asm-x86/amd_iommu_types.h
+++ b/include/asm-x86/amd_iommu_types.h
@@ -31,9 +31,6 @@
 #define ALIAS_TABLE_ENTRY_SIZE		2
 #define RLOOKUP_TABLE_ENTRY_SIZE	(sizeof(void *))
 
-/* helper macros */
-#define LOW_U32(x) ((x) & ((1ULL << 32)-1))
-
 /* Length of the MMIO region for the AMD IOMMU */
 #define MMIO_REGION_LENGTH       0x4000
 
@@ -69,6 +66,9 @@
 #define MMIO_EVT_TAIL_OFFSET	0x2018
 #define MMIO_STATUS_OFFSET	0x2020
 
+/* MMIO status bits */
+#define MMIO_STATUS_COM_WAIT_INT_MASK	0x04
+
 /* feature control bits */
 #define CONTROL_IOMMU_EN        0x00ULL
 #define CONTROL_HT_TUN_EN       0x01ULL
@@ -89,6 +89,7 @@
 #define CMD_INV_IOMMU_PAGES     0x03
 
 #define CMD_COMPL_WAIT_STORE_MASK	0x01
+#define CMD_COMPL_WAIT_INT_MASK		0x02
 #define CMD_INV_IOMMU_PAGES_SIZE_MASK	0x01
 #define CMD_INV_IOMMU_PAGES_PDE_MASK	0x02
 
@@ -99,6 +100,7 @@
 #define DEV_ENTRY_TRANSLATION   0x01
 #define DEV_ENTRY_IR            0x3d
 #define DEV_ENTRY_IW            0x3e
+#define DEV_ENTRY_NO_PAGE_FAULT	0x62
 #define DEV_ENTRY_EX            0x67
 #define DEV_ENTRY_SYSMGT1       0x68
 #define DEV_ENTRY_SYSMGT2       0x69
diff --git a/include/asm-x86/geode.h b/include/asm-x86/geode.h
index bb06027..2c1cda0 100644
--- a/include/asm-x86/geode.h
+++ b/include/asm-x86/geode.h
@@ -50,6 +50,7 @@ extern int geode_get_dev_base(unsigned int dev);
 #define MSR_PIC_YSEL_HIGH	0x51400021
 #define MSR_PIC_ZSEL_LOW	0x51400022
 #define MSR_PIC_ZSEL_HIGH	0x51400023
+#define MSR_PIC_IRQM_LPC	0x51400025
 
 #define MSR_MFGPT_IRQ		0x51400028
 #define MSR_MFGPT_NR		0x51400029
@@ -237,7 +238,7 @@ static inline u16 geode_mfgpt_read(int timer, u16 reg)
 }
 
 extern int geode_mfgpt_toggle_event(int timer, int cmp, int event, int enable);
-extern int geode_mfgpt_set_irq(int timer, int cmp, int irq, int enable);
+extern int geode_mfgpt_set_irq(int timer, int cmp, int *irq, int enable);
 extern int geode_mfgpt_alloc_timer(int timer, int domain);
 
 #define geode_mfgpt_setup_irq(t, c, i) geode_mfgpt_set_irq((t), (c), (i), 1)
diff --git a/include/asm-x86/i387.h b/include/asm-x86/i387.h
index 6d3b210..56d00e3 100644
--- a/include/asm-x86/i387.h
+++ b/include/asm-x86/i387.h
@@ -63,8 +63,6 @@ static inline int restore_fpu_checking(struct i387_fxsave_struct *fx)
 #else
 		     : [fx] "cdaSDb" (fx), "m" (*fx), "0" (0));
 #endif
-	if (unlikely(err))
-		init_fpu(current);
 	return err;
 }
 
diff --git a/include/asm-x86/io.h b/include/asm-x86/io.h
index bf5d629..0f954dc 100644
--- a/include/asm-x86/io.h
+++ b/include/asm-x86/io.h
@@ -21,7 +21,7 @@ extern void __iomem *fix_ioremap(unsigned idx, unsigned long phys);
 
 #define build_mmio_read(name, size, type, reg, barrier) \
 static inline type name(const volatile void __iomem *addr) \
-{ type ret; asm volatile("mov" size " %1,%0":"=" reg (ret) \
+{ type ret; asm volatile("mov" size " %1,%0":reg (ret) \
 :"m" (*(volatile type __force *)addr) barrier); return ret; }
 
 #define build_mmio_write(name, size, type, reg, barrier) \
@@ -29,13 +29,13 @@ static inline void name(type val, volatile void __iomem *addr) \
 { asm volatile("mov" size " %0,%1": :reg (val), \
 "m" (*(volatile type __force *)addr) barrier); }
 
-build_mmio_read(readb, "b", unsigned char, "q", :"memory")
-build_mmio_read(readw, "w", unsigned short, "r", :"memory")
-build_mmio_read(readl, "l", unsigned int, "r", :"memory")
+build_mmio_read(readb, "b", unsigned char, "=q", :"memory")
+build_mmio_read(readw, "w", unsigned short, "=r", :"memory")
+build_mmio_read(readl, "l", unsigned int, "=r", :"memory")
 
-build_mmio_read(__readb, "b", unsigned char, "q", )
-build_mmio_read(__readw, "w", unsigned short, "r", )
-build_mmio_read(__readl, "l", unsigned int, "r", )
+build_mmio_read(__readb, "b", unsigned char, "=q", )
+build_mmio_read(__readw, "w", unsigned short, "=r", )
+build_mmio_read(__readl, "l", unsigned int, "=r", )
 
 build_mmio_write(writeb, "b", unsigned char, "q", :"memory")
 build_mmio_write(writew, "w", unsigned short, "r", :"memory")
@@ -59,8 +59,8 @@ build_mmio_write(__writel, "l", unsigned int, "r", )
 #define mmiowb() barrier()
 
 #ifdef CONFIG_X86_64
-build_mmio_read(readq, "q", unsigned long, "r", :"memory")
-build_mmio_read(__readq, "q", unsigned long, "r", )
+build_mmio_read(readq, "q", unsigned long, "=r", :"memory")
+build_mmio_read(__readq, "q", unsigned long, "=r", )
 build_mmio_write(writeq, "q", unsigned long, "r", :"memory")
 build_mmio_write(__writeq, "q", unsigned long, "r", )
 
diff --git a/include/asm-x86/mman.h b/include/asm-x86/mman.h
index c1682b5..90bc410 100644
--- a/include/asm-x86/mman.h
+++ b/include/asm-x86/mman.h
@@ -12,6 +12,7 @@
 #define MAP_NORESERVE	0x4000		/* don't check for reservations */
 #define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
+#define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
diff --git a/include/asm-x86/mmzone_32.h b/include/asm-x86/mmzone_32.h
index b2298a2..5862e64 100644
--- a/include/asm-x86/mmzone_32.h
+++ b/include/asm-x86/mmzone_32.h
@@ -97,10 +97,16 @@ static inline int pfn_valid(int pfn)
 	reserve_bootmem_node(NODE_DATA(0), (addr), (size), (flags))
 #define alloc_bootmem(x) \
 	__alloc_bootmem_node(NODE_DATA(0), (x), SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
+#define alloc_bootmem_nopanic(x) \
+	__alloc_bootmem_node_nopanic(NODE_DATA(0), (x), SMP_CACHE_BYTES, \
+				__pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_low(x) \
 	__alloc_bootmem_node(NODE_DATA(0), (x), SMP_CACHE_BYTES, 0)
 #define alloc_bootmem_pages(x) \
 	__alloc_bootmem_node(NODE_DATA(0), (x), PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
+#define alloc_bootmem_pages_nopanic(x) \
+	__alloc_bootmem_node_nopanic(NODE_DATA(0), (x), PAGE_SIZE, \
+				__pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_low_pages(x) \
 	__alloc_bootmem_node(NODE_DATA(0), (x), PAGE_SIZE, 0)
 #define alloc_bootmem_node(pgdat, x)					\
diff --git a/include/asm-x86/pgtable_64.h b/include/asm-x86/pgtable_64.h
index ac5fff4..549144d 100644
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -151,7 +151,7 @@ static inline void native_pgd_clear(pgd_t *pgd)
 #define VMALLOC_END      _AC(0xffffe1ffffffffff, UL)
 #define VMEMMAP_START	 _AC(0xffffe20000000000, UL)
 #define MODULES_VADDR    _AC(0xffffffffa0000000, UL)
-#define MODULES_END      _AC(0xfffffffffff00000, UL)
+#define MODULES_END      _AC(0xffffffffff000000, UL)
 #define MODULES_LEN   (MODULES_END - MODULES_VADDR)
 
 #ifndef __ASSEMBLY__
diff --git a/include/asm-x86/processor.h b/include/asm-x86/processor.h
index 5f58da4..4df3e2f 100644
--- a/include/asm-x86/processor.h
+++ b/include/asm-x86/processor.h
@@ -728,6 +728,29 @@ extern unsigned long		boot_option_idle_override;
 extern unsigned long		idle_halt;
 extern unsigned long		idle_nomwait;
 
+/*
+ * on systems with caches, caches must be flashed as the absolute
+ * last instruction before going into a suspended halt.  Otherwise,
+ * dirty data can linger in the cache and become stale on resume,
+ * leading to strange errors.
+ *
+ * perform a variety of operations to guarantee that the compiler
+ * will not reorder instructions.  wbinvd itself is serializing
+ * so the processor will not reorder.
+ *
+ * Systems without cache can just go into halt.
+ */
+static inline void wbinvd_halt(void)
+{
+	mb();
+	/* check for clflush to determine if wbinvd is legal */
+	if (cpu_has_clflush)
+		asm volatile("cli; wbinvd; 1: hlt; jmp 1b" : : : "memory");
+	else
+		while (1)
+			halt();
+}
+
 extern void enable_sep_cpu(void);
 extern int sysenter_setup(void);
 
diff --git a/include/asm-x86/spinlock.h b/include/asm-x86/spinlock.h
index 4f9a986..e39c790 100644
--- a/include/asm-x86/spinlock.h
+++ b/include/asm-x86/spinlock.h
@@ -65,7 +65,7 @@ static inline int __ticket_spin_is_contended(raw_spinlock_t *lock)
 {
 	int tmp = ACCESS_ONCE(lock->slock);
 
-	return (((tmp >> 8) & 0xff) - (tmp & 0xff)) > 1;
+	return (((tmp >> 8) - tmp) & 0xff) > 1;
 }
 
 static __always_inline void __ticket_spin_lock(raw_spinlock_t *lock)
@@ -127,7 +127,7 @@ static inline int __ticket_spin_is_contended(raw_spinlock_t *lock)
 {
 	int tmp = ACCESS_ONCE(lock->slock);
 
-	return (((tmp >> 16) & 0xffff) - (tmp & 0xffff)) > 1;
+	return (((tmp >> 16) - tmp) & 0xffff) > 1;
 }
 
 static __always_inline void __ticket_spin_lock(raw_spinlock_t *lock)
