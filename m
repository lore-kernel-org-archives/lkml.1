Return-Path: <linux-kernel-owner+w=401wt.eu-S1755922AbYJ3Xei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbYJ3Xei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 19:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbYJ3Xe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 19:34:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44173 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541AbYJ3Xe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 19:34:26 -0400
Date: Fri, 31 Oct 2008 00:34:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes
Message-ID: <20081030233412.GA15508@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus


out-of-topic modifications in x86-fixes-for-linus:
--------------------------------------------------
.mailmap                           # 17c2297: mailmap: add Peter Oruba

 Thanks,

	Ingo

------------------>
Gary Hade (1):
      x86: remove debug code from arch_add_memory()

Harvey Harrison (2):
      x86: two trivial sparse annotations
      x86: start annotating early ioremap pointers with __iomem

James Bottomley (5):
      x86/voyager: fix boot breakage caused by x86: boot secondary cpus through initial_code
      x86: use CONFIG_X86_SMP instead of CONFIG_SMP
      x86/voyager: fix compile breakage casued by x86: move prefill_possible_map calling early
      x86/voyager: fix compile breakage caused by dc1e35c6e95e8923cf1d3510438b63c600fee1e2
      x86/voyager: fix missing cpu_index initialisation

Jan Beulich (1):
      i386/PAE: fix pud_page()

Joerg Roedel (1):
      x86, gart: fix gart detection for Fam11h CPUs

Ken'ichi Ohmichi (1):
      x86, kdump: fix invalid access on i386 sparsemem

Markus Metzger (1):
      x86, bts: improve help text for BTS config

Mike Travis (1):
      x86, uv: fix compile error in uv_hub.h

Peter Oruba (3):
      mailmap: add Peter Oruba
      x86: microcode patch loader author update
      x86: AMD microcode patch loader author update

Ravikiran G Thirumalai (1):
      x86: fix /dev/mem mmap breakage when PAT is disabled

Uwe Hermann (1):
      doc/x86: fix doc subdirs

Yinghai Lu (3):
      x86: fix APIC_DEBUG with inquire_remote_apic
      x86: 64 bit print out absent pages num too
      x86: fix init_memory_mapping for [dc000000 - e0000000) - v2


 .mailmap                                         |    2 +
 Documentation/00-INDEX                           |    4 +-
 Documentation/kernel-parameters.txt              |   12 ++--
 Documentation/lguest/lguest.c                    |    2 +-
 Documentation/x86/x86_64/boot-options.txt        |    4 +-
 Documentation/x86/x86_64/fake-numa-for-cpusets   |    2 +-
 arch/x86/Kconfig                                 |    4 ++
 arch/x86/Kconfig.cpu                             |   24 ++++----
 arch/x86/include/asm/es7000/wakecpu.h            |    9 ++--
 arch/x86/include/asm/io.h                        |    6 +-
 arch/x86/include/asm/mach-default/mach_wakecpu.h |    9 ++--
 arch/x86/include/asm/pgtable-3level.h            |    4 +-
 arch/x86/include/asm/smp.h                       |    6 ++
 arch/x86/include/asm/uv/uv_hub.h                 |    1 +
 arch/x86/kernel/cpu/addon_cpuid_features.c       |    2 +-
 arch/x86/kernel/cpu/common.c                     |    4 +-
 arch/x86/kernel/k8.c                             |    1 -
 arch/x86/kernel/machine_kexec_32.c               |    5 ++-
 arch/x86/kernel/microcode_amd.c                  |    2 +-
 arch/x86/kernel/microcode_core.c                 |    4 +-
 arch/x86/kernel/pci-gart_64.c                    |    2 +-
 arch/x86/kernel/tsc.c                            |    2 +-
 arch/x86/kernel/vsmp_64.c                        |    2 +-
 arch/x86/mach-voyager/voyager_smp.c              |   12 ++++-
 arch/x86/mm/gup.c                                |    2 +-
 arch/x86/mm/init_64.c                            |   61 ++++++++++++++--------
 arch/x86/mm/ioremap.c                            |   22 ++++----
 arch/x86/mm/pat.c                                |    4 ++
 28 files changed, 131 insertions(+), 83 deletions(-)

diff --git a/.mailmap b/.mailmap
index eba9bf9..97f7b4f 100644
--- a/.mailmap
+++ b/.mailmap
@@ -80,6 +80,8 @@ Nguyen Anh Quynh <aquynh@gmail.com>
 Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
 Patrick Mochel <mochel@digitalimplant.org>
 Peter A Jonsson <pj@ludd.ltu.se>
+Peter Oruba <peter@oruba.de>
+Peter Oruba <peter.oruba@amd.com>
 Praveen BP <praveenbp@ti.com>
 Rajesh Shah <rajesh.shah@intel.com>
 Ralf Baechle <ralf@linux-mips.org>
diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index 7286ad0..edef85c 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -172,7 +172,7 @@ i2c/
 	- directory with info about the I2C bus/protocol (2 wire, kHz speed).
 i2o/
 	- directory with info about the Linux I2O subsystem.
-i386/
+x86/i386/
 	- directory with info about Linux on Intel 32 bit architecture.
 ia64/
 	- directory with info about Linux on Intel 64 bit architecture.
@@ -382,7 +382,7 @@ w1/
 	- directory with documents regarding the 1-wire (w1) subsystem.
 watchdog/
 	- how to auto-reboot Linux if it has "fallen and can't get up". ;-)
-x86_64/
+x86/x86_64/
 	- directory with info on Linux support for AMD x86-64 (Hammer) machines.
 zorro.txt
 	- info on writing drivers for Zorro bus devices found on Amigas.
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 343e0f0..1bbcaa8 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -100,7 +100,7 @@ parameter is applicable:
 	X86-32	X86-32, aka i386 architecture is enabled.
 	X86-64	X86-64 architecture is enabled.
 			More X86-64 boot options can be found in
-			Documentation/x86_64/boot-options.txt .
+			Documentation/x86/x86_64/boot-options.txt .
 	X86	Either 32bit or 64bit x86 (same as X86-32+X86-64)
 
 In addition, the following text indicates that the option:
@@ -112,10 +112,10 @@ In addition, the following text indicates that the option:
 Parameters denoted with BOOT are actually interpreted by the boot
 loader, and have no meaning to the kernel directly.
 Do not modify the syntax of boot loader parameters without extreme
-need or coordination with <Documentation/i386/boot.txt>.
+need or coordination with <Documentation/x86/i386/boot.txt>.
 
 There are also arch-specific kernel-parameters not documented here.
-See for example <Documentation/x86_64/boot-options.txt>.
+See for example <Documentation/x86/x86_64/boot-options.txt>.
 
 Note that ALL kernel parameters listed below are CASE SENSITIVE, and that
 a trailing = on the name of any parameter states that that parameter will
@@ -1222,7 +1222,7 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	mce		[X86-32] Machine Check Exception
 
-	mce=option	[X86-64] See Documentation/x86_64/boot-options.txt
+	mce=option	[X86-64] See Documentation/x86/x86_64/boot-options.txt
 
 	md=		[HW] RAID subsystems devices and level
 			See Documentation/md.txt.
@@ -1728,7 +1728,7 @@ and is between 256 and 4096 characters. It is defined in the file
 			See Documentation/paride.txt.
 
 	pirq=		[SMP,APIC] Manual mp-table setup
-			See Documentation/i386/IO-APIC.txt.
+			See Documentation/x86/i386/IO-APIC.txt.
 
 	plip=		[PPT,NET] Parallel port network link
 			Format: { parport<nr> | timid | 0 }
@@ -2343,7 +2343,7 @@ and is between 256 and 4096 characters. It is defined in the file
 			See Documentation/fb/modedb.txt.
 
 	vga=		[BOOT,X86-32] Select a particular video mode
-			See Documentation/i386/boot.txt and
+			See Documentation/x86/i386/boot.txt and
 			Documentation/svga.txt.
 			Use vga=ask for menu.
 			This is actually a boot loader parameter; the value is
diff --git a/Documentation/lguest/lguest.c b/Documentation/lguest/lguest.c
index 7228369..da86fd5 100644
--- a/Documentation/lguest/lguest.c
+++ b/Documentation/lguest/lguest.c
@@ -402,7 +402,7 @@ static unsigned long load_bzimage(int fd)
 	void *p = from_guest_phys(0x100000);
 
 	/* Go back to the start of the file and read the header.  It should be
-	 * a Linux boot header (see Documentation/i386/boot.txt) */
+	 * a Linux boot header (see Documentation/x86/i386/boot.txt) */
 	lseek(fd, 0, SEEK_SET);
 	read(fd, &boot, sizeof(boot));
 
diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
index 72ffb53..f6d561a 100644
--- a/Documentation/x86/x86_64/boot-options.txt
+++ b/Documentation/x86/x86_64/boot-options.txt
@@ -35,7 +35,7 @@ APICs
 
    nolapic	 Don't use the local APIC (alias for i386 compatibility)
 
-   pirq=...	 See Documentation/i386/IO-APIC.txt
+   pirq=...	 See Documentation/x86/i386/IO-APIC.txt
 
    noapictimer	 Don't set up the APIC timer
 
@@ -139,7 +139,7 @@ Non Executable Mappings
 SMP
 
   additional_cpus=NUM Allow NUM more CPUs for hotplug
-		 (defaults are specified by the BIOS, see Documentation/x86_64/cpu-hotplug-spec)
+		 (defaults are specified by the BIOS, see Documentation/x86/x86_64/cpu-hotplug-spec)
 
 NUMA
 
diff --git a/Documentation/x86/x86_64/fake-numa-for-cpusets b/Documentation/x86/x86_64/fake-numa-for-cpusets
index d1a985c..33bb566 100644
--- a/Documentation/x86/x86_64/fake-numa-for-cpusets
+++ b/Documentation/x86/x86_64/fake-numa-for-cpusets
@@ -10,7 +10,7 @@ amount of system memory that are available to a certain class of tasks.
 For more information on the features of cpusets, see Documentation/cpusets.txt.
 There are a number of different configurations you can use for your needs.  For
 more information on the numa=fake command line option and its various ways of
-configuring fake nodes, see Documentation/x86_64/boot-options.txt.
+configuring fake nodes, see Documentation/x86/x86_64/boot-options.txt.
 
 For the purposes of this introduction, we'll assume a very primitive NUMA
 emulation setup of "numa=fake=4*512,".  This will split our system memory into
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 350bee1..2a40c4c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -231,6 +231,10 @@ config SMP
 
 	  If you don't know what to do here, say N.
 
+config X86_HAS_BOOT_CPU_ID
+	def_bool y
+	depends on X86_VOYAGER
+
 config X86_FIND_SMP_CONFIG
 	def_bool y
 	depends on X86_MPPARSE || X86_VOYAGER
diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 0b7c4a3..b815664 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -513,19 +513,19 @@ config CPU_SUP_UMC_32
 	  If unsure, say N.
 
 config X86_DS
-	bool "Debug Store support"
-	default y
-	help
-	  Add support for Debug Store.
-	  This allows the kernel to provide a memory buffer to the hardware
-	  to store various profiling and tracing events.
+	def_bool X86_PTRACE_BTS
+	depends on X86_DEBUGCTLMSR
 
 config X86_PTRACE_BTS
-	bool "ptrace interface to Branch Trace Store"
+	bool "Branch Trace Store"
 	default y
-	depends on (X86_DS && X86_DEBUGCTLMSR)
+	depends on X86_DEBUGCTLMSR
 	help
-	  Add a ptrace interface to allow collecting an execution trace
-	  of the traced task.
-	  This collects control flow changes in a (cyclic) buffer and allows
-	  debuggers to fill in the gaps and show an execution trace of the debuggee.
+	  This adds a ptrace interface to the hardware's branch trace store.
+
+	  Debuggers may use it to collect an execution trace of the debugged
+	  application in order to answer the question 'how did I get here?'.
+	  Debuggers may trace user mode as well as kernel mode.
+
+	  Say Y unless there is no application development on this machine
+	  and you want to save a small amount of code size.
diff --git a/arch/x86/include/asm/es7000/wakecpu.h b/arch/x86/include/asm/es7000/wakecpu.h
index 3ffc5a7..3984934 100644
--- a/arch/x86/include/asm/es7000/wakecpu.h
+++ b/arch/x86/include/asm/es7000/wakecpu.h
@@ -50,10 +50,9 @@ static inline void restore_NMI_vector(unsigned short *high, unsigned short *low)
 {
 }
 
-#if APIC_DEBUG
- #define inquire_remote_apic(apicid) __inquire_remote_apic(apicid)
-#else
- #define inquire_remote_apic(apicid) {}
-#endif
+#define inquire_remote_apic(apicid) do {		\
+		if (apic_verbosity >= APIC_DEBUG)	\
+			__inquire_remote_apic(apicid);	\
+	} while (0)
 
 #endif /* __ASM_MACH_WAKECPU_H */
diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 5618a10..ac2abc8 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -82,9 +82,9 @@ extern void __iomem *ioremap_wc(unsigned long offset, unsigned long size);
 extern void early_ioremap_init(void);
 extern void early_ioremap_clear(void);
 extern void early_ioremap_reset(void);
-extern void *early_ioremap(unsigned long offset, unsigned long size);
-extern void *early_memremap(unsigned long offset, unsigned long size);
-extern void early_iounmap(void *addr, unsigned long size);
+extern void __iomem *early_ioremap(unsigned long offset, unsigned long size);
+extern void __iomem *early_memremap(unsigned long offset, unsigned long size);
+extern void early_iounmap(void __iomem *addr, unsigned long size);
 extern void __iomem *fix_ioremap(unsigned idx, unsigned long phys);
 
 
diff --git a/arch/x86/include/asm/mach-default/mach_wakecpu.h b/arch/x86/include/asm/mach-default/mach_wakecpu.h
index d5c0b82..9d80db9 100644
--- a/arch/x86/include/asm/mach-default/mach_wakecpu.h
+++ b/arch/x86/include/asm/mach-default/mach_wakecpu.h
@@ -33,10 +33,9 @@ static inline void restore_NMI_vector(unsigned short *high, unsigned short *low)
 {
 }
 
-#if APIC_DEBUG
- #define inquire_remote_apic(apicid) __inquire_remote_apic(apicid)
-#else
- #define inquire_remote_apic(apicid) {}
-#endif
+#define inquire_remote_apic(apicid) do {		\
+		if (apic_verbosity >= APIC_DEBUG)	\
+			__inquire_remote_apic(apicid);	\
+	} while (0)
 
 #endif /* _ASM_X86_MACH_DEFAULT_MACH_WAKECPU_H */
diff --git a/arch/x86/include/asm/pgtable-3level.h b/arch/x86/include/asm/pgtable-3level.h
index fb16cec..52597ae 100644
--- a/arch/x86/include/asm/pgtable-3level.h
+++ b/arch/x86/include/asm/pgtable-3level.h
@@ -120,13 +120,13 @@ static inline void pud_clear(pud_t *pudp)
 		write_cr3(pgd);
 }
 
-#define pud_page(pud) ((struct page *) __va(pud_val(pud) & PTE_PFN_MASK))
+#define pud_page(pud) pfn_to_page(pud_val(pud) >> PAGE_SHIFT)
 
 #define pud_page_vaddr(pud) ((unsigned long) __va(pud_val(pud) & PTE_PFN_MASK))
 
 
 /* Find an entry in the second-level page table.. */
-#define pmd_offset(pud, address) ((pmd_t *)pud_page(*(pud)) +	\
+#define pmd_offset(pud, address) ((pmd_t *)pud_page_vaddr(*(pud)) +	\
 				  pmd_index(address))
 
 #ifdef CONFIG_SMP
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 2766021..d12811c 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -225,5 +225,11 @@ static inline int hard_smp_processor_id(void)
 
 #endif /* CONFIG_X86_LOCAL_APIC */
 
+#ifdef CONFIG_X86_HAS_BOOT_CPU_ID
+extern unsigned char boot_cpu_id;
+#else
+#define boot_cpu_id	0
+#endif
+
 #endif /* __ASSEMBLY__ */
 #endif /* _ASM_X86_SMP_H */
diff --git a/arch/x86/include/asm/uv/uv_hub.h b/arch/x86/include/asm/uv/uv_hub.h
index c6ad93e..7a57826 100644
--- a/arch/x86/include/asm/uv/uv_hub.h
+++ b/arch/x86/include/asm/uv/uv_hub.h
@@ -13,6 +13,7 @@
 
 #include <linux/numa.h>
 #include <linux/percpu.h>
+#include <linux/timer.h>
 #include <asm/types.h>
 #include <asm/percpu.h>
 
diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index 0d9c993..ef8f831 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -69,7 +69,7 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
  */
 void __cpuinit detect_extended_topology(struct cpuinfo_x86 *c)
 {
-#ifdef CONFIG_SMP
+#ifdef CONFIG_X86_SMP
 	unsigned int eax, ebx, ecx, edx, sub_index;
 	unsigned int ht_mask_width, core_plus_mask_width;
 	unsigned int core_select_mask, core_level_siblings;
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 25581dc..da8f15a 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -549,6 +549,8 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 		this_cpu->c_early_init(c);
 
 	validate_pat_support(c);
+
+	c->cpu_index = boot_cpu_id;
 }
 
 void __init early_cpu_init(void)
@@ -1134,7 +1136,7 @@ void __cpuinit cpu_init(void)
 	/*
 	 * Boot processor to setup the FP and extended state context info.
 	 */
-	if (!smp_processor_id())
+	if (smp_processor_id() == boot_cpu_id)
 		init_thread_xstate();
 
 	xsave_init();
diff --git a/arch/x86/kernel/k8.c b/arch/x86/kernel/k8.c
index 304d8ba..cbc4332 100644
--- a/arch/x86/kernel/k8.c
+++ b/arch/x86/kernel/k8.c
@@ -18,7 +18,6 @@ static u32 *flush_words;
 struct pci_device_id k8_nb_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB_MISC) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_11H_NB_MISC) },
 	{}
 };
 EXPORT_SYMBOL(k8_nb_ids);
diff --git a/arch/x86/kernel/machine_kexec_32.c b/arch/x86/kernel/machine_kexec_32.c
index 0732adb..7a38574 100644
--- a/arch/x86/kernel/machine_kexec_32.c
+++ b/arch/x86/kernel/machine_kexec_32.c
@@ -162,7 +162,10 @@ void machine_kexec(struct kimage *image)
 	page_list[VA_PTE_0] = (unsigned long)kexec_pte0;
 	page_list[PA_PTE_1] = __pa(kexec_pte1);
 	page_list[VA_PTE_1] = (unsigned long)kexec_pte1;
-	page_list[PA_SWAP_PAGE] = (page_to_pfn(image->swap_page) << PAGE_SHIFT);
+
+	if (image->type == KEXEC_TYPE_DEFAULT)
+		page_list[PA_SWAP_PAGE] = (page_to_pfn(image->swap_page)
+						<< PAGE_SHIFT);
 
 	/* The segment registers are funny things, they have both a
 	 * visible and an invisible part.  Whenever the visible part is
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 7a1f8ee..5f8e5d7 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -39,7 +39,7 @@
 #include <asm/microcode.h>
 
 MODULE_DESCRIPTION("AMD Microcode Update Driver");
-MODULE_AUTHOR("Peter Oruba <peter.oruba@amd.com>");
+MODULE_AUTHOR("Peter Oruba");
 MODULE_LICENSE("GPL v2");
 
 #define UCODE_MAGIC                0x00414d44
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 936d8d5..82fb280 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -480,8 +480,8 @@ static int __init microcode_init(void)
 
 	printk(KERN_INFO
 	       "Microcode Update Driver: v" MICROCODE_VERSION
-	       " <tigran@aivazian.fsnet.co.uk>"
-	       " <peter.oruba@amd.com>\n");
+	       " <tigran@aivazian.fsnet.co.uk>,"
+	       " Peter Oruba\n");
 
 	return 0;
 }
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index e3f75bb..a42b02b 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -744,7 +744,7 @@ void __init gart_iommu_init(void)
 	long i;
 
 	if (cache_k8_northbridges() < 0 || num_k8_northbridges == 0) {
-		printk(KERN_INFO "PCI-GART: No AMD northbridge found.\n");
+		printk(KERN_INFO "PCI-GART: No AMD GART found.\n");
 		return;
 	}
 
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 161bb85..62348e4 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -759,7 +759,7 @@ __cpuinit int unsynchronized_tsc(void)
 	if (!cpu_has_tsc || tsc_unstable)
 		return 1;
 
-#ifdef CONFIG_SMP
+#ifdef CONFIG_X86_SMP
 	if (apic_is_clustered_box())
 		return 1;
 #endif
diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index 7766d36..a688f3b 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -78,7 +78,7 @@ static unsigned __init_or_module vsmp_patch(u8 type, u16 clobbers, void *ibuf,
 
 static void __init set_vsmp_pv_ops(void)
 {
-	void *address;
+	void __iomem *address;
 	unsigned int cap, ctl, cfg;
 
 	/* set vSMP magic bits to indicate vSMP capable kernel */
diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index 0f6e8a6..7f4c6af 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -90,6 +90,7 @@ static void ack_vic_irq(unsigned int irq);
 static void vic_enable_cpi(void);
 static void do_boot_cpu(__u8 cpuid);
 static void do_quad_bootstrap(void);
+static void initialize_secondary(void);
 
 int hard_smp_processor_id(void);
 int safe_smp_processor_id(void);
@@ -344,6 +345,12 @@ static void do_quad_bootstrap(void)
 	}
 }
 
+void prefill_possible_map(void)
+{
+	/* This is empty on voyager because we need a much
+	 * earlier detection which is done in find_smp_config */
+}
+
 /* Set up all the basic stuff: read the SMP config and make all the
  * SMP information reflect only the boot cpu.  All others will be
  * brought on-line later. */
@@ -413,6 +420,7 @@ void __init smp_store_cpu_info(int id)
 	struct cpuinfo_x86 *c = &cpu_data(id);
 
 	*c = boot_cpu_data;
+	c->cpu_index = id;
 
 	identify_secondary_cpu(c);
 }
@@ -650,6 +658,8 @@ void __init smp_boot_cpus(void)
 	 smp_tune_scheduling();
 	 */
 	smp_store_cpu_info(boot_cpu_id);
+	/* setup the jump vector */
+	initial_code = (unsigned long)initialize_secondary;
 	printk("CPU%d: ", boot_cpu_id);
 	print_cpu_info(&cpu_data(boot_cpu_id));
 
@@ -702,7 +712,7 @@ void __init smp_boot_cpus(void)
 
 /* Reload the secondary CPUs task structure (this function does not
  * return ) */
-void __init initialize_secondary(void)
+static void __init initialize_secondary(void)
 {
 #if 0
 	// AC kernels only
diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index 4ba373c..be54176 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -233,7 +233,7 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 	len = (unsigned long) nr_pages << PAGE_SHIFT;
 	end = start + len;
 	if (unlikely(!access_ok(write ? VERIFY_WRITE : VERIFY_READ,
-					start, len)))
+					(void __user *)start, len)))
 		goto slow_irqon;
 
 	/*
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index f79a02f..9db01db 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -671,12 +671,13 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	unsigned long last_map_addr = 0;
 	unsigned long page_size_mask = 0;
 	unsigned long start_pfn, end_pfn;
+	unsigned long pos;
 
 	struct map_range mr[NR_RANGE_MR];
 	int nr_range, i;
 	int use_pse, use_gbpages;
 
-	printk(KERN_INFO "init_memory_mapping\n");
+	printk(KERN_INFO "init_memory_mapping: %016lx-%016lx\n", start, end);
 
 	/*
 	 * Find space for the kernel direct mapping tables.
@@ -710,35 +711,50 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 
 	/* head if not big page alignment ?*/
 	start_pfn = start >> PAGE_SHIFT;
-	end_pfn = ((start + (PMD_SIZE - 1)) >> PMD_SHIFT)
+	pos = start_pfn << PAGE_SHIFT;
+	end_pfn = ((pos + (PMD_SIZE - 1)) >> PMD_SHIFT)
 			<< (PMD_SHIFT - PAGE_SHIFT);
-	nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
+	if (start_pfn < end_pfn) {
+		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
+		pos = end_pfn << PAGE_SHIFT;
+	}
 
 	/* big page (2M) range*/
-	start_pfn = ((start + (PMD_SIZE - 1))>>PMD_SHIFT)
+	start_pfn = ((pos + (PMD_SIZE - 1))>>PMD_SHIFT)
 			 << (PMD_SHIFT - PAGE_SHIFT);
-	end_pfn = ((start + (PUD_SIZE - 1))>>PUD_SHIFT)
+	end_pfn = ((pos + (PUD_SIZE - 1))>>PUD_SHIFT)
 			 << (PUD_SHIFT - PAGE_SHIFT);
-	if (end_pfn > ((end>>PUD_SHIFT)<<(PUD_SHIFT - PAGE_SHIFT)))
-		end_pfn = ((end>>PUD_SHIFT)<<(PUD_SHIFT - PAGE_SHIFT));
-	nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
-			page_size_mask & (1<<PG_LEVEL_2M));
+	if (end_pfn > ((end>>PMD_SHIFT)<<(PMD_SHIFT - PAGE_SHIFT)))
+		end_pfn = ((end>>PMD_SHIFT)<<(PMD_SHIFT - PAGE_SHIFT));
+	if (start_pfn < end_pfn) {
+		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
+				page_size_mask & (1<<PG_LEVEL_2M));
+		pos = end_pfn << PAGE_SHIFT;
+	}
 
 	/* big page (1G) range */
-	start_pfn = end_pfn;
-	end_pfn = (end>>PUD_SHIFT) << (PUD_SHIFT - PAGE_SHIFT);
-	nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
+	start_pfn = ((pos + (PUD_SIZE - 1))>>PUD_SHIFT)
+			 << (PUD_SHIFT - PAGE_SHIFT);
+	end_pfn = (end >> PUD_SHIFT) << (PUD_SHIFT - PAGE_SHIFT);
+	if (start_pfn < end_pfn) {
+		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
 				page_size_mask &
 				 ((1<<PG_LEVEL_2M)|(1<<PG_LEVEL_1G)));
+		pos = end_pfn << PAGE_SHIFT;
+	}
 
 	/* tail is not big page (1G) alignment */
-	start_pfn = end_pfn;
-	end_pfn = (end>>PMD_SHIFT) << (PMD_SHIFT - PAGE_SHIFT);
-	nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
-			page_size_mask & (1<<PG_LEVEL_2M));
+	start_pfn = ((pos + (PMD_SIZE - 1))>>PMD_SHIFT)
+			 << (PMD_SHIFT - PAGE_SHIFT);
+	end_pfn = (end >> PMD_SHIFT) << (PMD_SHIFT - PAGE_SHIFT);
+	if (start_pfn < end_pfn) {
+		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
+				page_size_mask & (1<<PG_LEVEL_2M));
+		pos = end_pfn << PAGE_SHIFT;
+	}
 
 	/* tail is not big page (2M) alignment */
-	start_pfn = end_pfn;
+	start_pfn = pos>>PAGE_SHIFT;
 	end_pfn = end>>PAGE_SHIFT;
 	nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
 
@@ -842,7 +858,7 @@ int arch_add_memory(int nid, u64 start, u64 size)
 		max_pfn_mapped = last_mapped_pfn;
 
 	ret = __add_pages(zone, start_pfn, nr_pages);
-	WARN_ON(1);
+	WARN_ON_ONCE(ret);
 
 	return ret;
 }
@@ -884,6 +900,7 @@ static struct kcore_list kcore_mem, kcore_vmalloc, kcore_kernel,
 void __init mem_init(void)
 {
 	long codesize, reservedpages, datasize, initsize;
+	unsigned long absent_pages;
 
 	start_periodic_check_for_corruption();
 
@@ -899,8 +916,9 @@ void __init mem_init(void)
 #else
 	totalram_pages = free_all_bootmem();
 #endif
-	reservedpages = max_pfn - totalram_pages -
-					absent_pages_in_range(0, max_pfn);
+
+	absent_pages = absent_pages_in_range(0, max_pfn);
+	reservedpages = max_pfn - totalram_pages - absent_pages;
 	after_bootmem = 1;
 
 	codesize =  (unsigned long) &_etext - (unsigned long) &_text;
@@ -917,10 +935,11 @@ void __init mem_init(void)
 				 VSYSCALL_END - VSYSCALL_START);
 
 	printk(KERN_INFO "Memory: %luk/%luk available (%ldk kernel code, "
-				"%ldk reserved, %ldk data, %ldk init)\n",
+			 "%ldk absent, %ldk reserved, %ldk data, %ldk init)\n",
 		(unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
 		max_pfn << (PAGE_SHIFT-10),
 		codesize >> 10,
+		absent_pages << (PAGE_SHIFT-10),
 		reservedpages << (PAGE_SHIFT-10),
 		datasize >> 10,
 		initsize >> 10);
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index ae71e11..d4c4307 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -387,7 +387,7 @@ static void __iomem *ioremap_default(resource_size_t phys_addr,
 					unsigned long size)
 {
 	unsigned long flags;
-	void *ret;
+	void __iomem *ret;
 	int err;
 
 	/*
@@ -399,11 +399,11 @@ static void __iomem *ioremap_default(resource_size_t phys_addr,
 	if (err < 0)
 		return NULL;
 
-	ret = (void *) __ioremap_caller(phys_addr, size, flags,
-					__builtin_return_address(0));
+	ret = __ioremap_caller(phys_addr, size, flags,
+			       __builtin_return_address(0));
 
 	free_memtype(phys_addr, phys_addr + size);
-	return (void __iomem *)ret;
+	return ret;
 }
 
 void __iomem *ioremap_prot(resource_size_t phys_addr, unsigned long size,
@@ -622,7 +622,7 @@ static inline void __init early_clear_fixmap(enum fixed_addresses idx)
 		__early_set_fixmap(idx, 0, __pgprot(0));
 }
 
-static void *prev_map[FIX_BTMAPS_SLOTS] __initdata;
+static void __iomem *prev_map[FIX_BTMAPS_SLOTS] __initdata;
 static unsigned long prev_size[FIX_BTMAPS_SLOTS] __initdata;
 static int __init check_early_ioremap_leak(void)
 {
@@ -645,7 +645,7 @@ static int __init check_early_ioremap_leak(void)
 }
 late_initcall(check_early_ioremap_leak);
 
-static void __init *__early_ioremap(unsigned long phys_addr, unsigned long size, pgprot_t prot)
+static void __init __iomem *__early_ioremap(unsigned long phys_addr, unsigned long size, pgprot_t prot)
 {
 	unsigned long offset, last_addr;
 	unsigned int nrpages;
@@ -713,23 +713,23 @@ static void __init *__early_ioremap(unsigned long phys_addr, unsigned long size,
 	if (early_ioremap_debug)
 		printk(KERN_CONT "%08lx + %08lx\n", offset, fix_to_virt(idx0));
 
-	prev_map[slot] = (void *) (offset + fix_to_virt(idx0));
+	prev_map[slot] = (void __iomem *)(offset + fix_to_virt(idx0));
 	return prev_map[slot];
 }
 
 /* Remap an IO device */
-void __init *early_ioremap(unsigned long phys_addr, unsigned long size)
+void __init __iomem *early_ioremap(unsigned long phys_addr, unsigned long size)
 {
 	return __early_ioremap(phys_addr, size, PAGE_KERNEL_IO);
 }
 
 /* Remap memory */
-void __init *early_memremap(unsigned long phys_addr, unsigned long size)
+void __init __iomem *early_memremap(unsigned long phys_addr, unsigned long size)
 {
 	return __early_ioremap(phys_addr, size, PAGE_KERNEL);
 }
 
-void __init early_iounmap(void *addr, unsigned long size)
+void __init early_iounmap(void __iomem *addr, unsigned long size)
 {
 	unsigned long virt_addr;
 	unsigned long offset;
@@ -779,7 +779,7 @@ void __init early_iounmap(void *addr, unsigned long size)
 		--idx;
 		--nrpages;
 	}
-	prev_map[slot] = 0;
+	prev_map[slot] = NULL;
 }
 
 void __this_fixmap_does_not_exist(void)
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 738fd0f..eb1bf00 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -481,12 +481,16 @@ static inline int range_is_allowed(unsigned long pfn, unsigned long size)
 	return 1;
 }
 #else
+/* This check is needed to avoid cache aliasing when PAT is enabled */
 static inline int range_is_allowed(unsigned long pfn, unsigned long size)
 {
 	u64 from = ((u64)pfn) << PAGE_SHIFT;
 	u64 to = from + size;
 	u64 cursor = from;
 
+	if (!pat_enabled)
+		return 1;
+
 	while (cursor < to) {
 		if (!devmem_is_allowed(pfn)) {
 			printk(KERN_INFO

