Return-Path: <linux-kernel-owner+w=401wt.eu-S1754103AbYJ1SOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbYJ1SOL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 14:14:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbYJ1SN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 14:13:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58723 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352AbYJ1SN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 14:13:56 -0400
Date: Tue, 28 Oct 2008 19:13:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes, #2
Message-ID: <20081028181334.GA14831@elte.hu>
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
Joerg Roedel (1):
      x86, gart: fix gart detection for Fam11h CPUs

Ken'ichi Ohmichi (1):
      x86, kdump: fix invalid access on i386 sparsemem

Markus Metzger (1):
      x86, bts: improve help text for BTS config

Peter Oruba (3):
      mailmap: add Peter Oruba
      x86: microcode patch loader author update
      x86: AMD microcode patch loader author update

Uwe Hermann (1):
      doc/x86: fix doc subdirs

Yinghai Lu (2):
      x86: fix APIC_DEBUG with inquire_remote_apic
      x86: 64 bit print out absent pages num too


 .mailmap                                         |    2 +
 Documentation/00-INDEX                           |    4 +-
 Documentation/kernel-parameters.txt              |   12 +++++-----
 Documentation/lguest/lguest.c                    |    2 +-
 Documentation/x86/x86_64/boot-options.txt        |    4 +-
 Documentation/x86/x86_64/fake-numa-for-cpusets   |    2 +-
 arch/x86/Kconfig.cpu                             |   24 +++++++++++-----------
 arch/x86/include/asm/es7000/wakecpu.h            |    9 +++----
 arch/x86/include/asm/mach-default/mach_wakecpu.h |    9 +++----
 arch/x86/kernel/k8.c                             |    1 -
 arch/x86/kernel/machine_kexec_32.c               |    5 +++-
 arch/x86/kernel/microcode_amd.c                  |    2 +-
 arch/x86/kernel/microcode_core.c                 |    4 +-
 arch/x86/kernel/pci-gart_64.c                    |    2 +-
 arch/x86/mm/init_64.c                            |    9 +++++--
 15 files changed, 48 insertions(+), 43 deletions(-)

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
 
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index f79a02f..ad38648 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -884,6 +884,7 @@ static struct kcore_list kcore_mem, kcore_vmalloc, kcore_kernel,
 void __init mem_init(void)
 {
 	long codesize, reservedpages, datasize, initsize;
+	unsigned long absent_pages;
 
 	start_periodic_check_for_corruption();
 
@@ -899,8 +900,9 @@ void __init mem_init(void)
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
@@ -917,10 +919,11 @@ void __init mem_init(void)
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
