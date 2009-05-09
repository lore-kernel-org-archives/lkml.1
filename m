Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678AbZEISh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbZEISh2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 14:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753174AbZEIShN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 14:37:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:37569 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbZEIShI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 14:37:08 -0400
Subject: Re: [RFC][git-pull -tip] x86: cpu_debug and cpufeature patches
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <1241603841.3322.3.camel@localhost.localdomain>
References: <1240190145.3106.90.camel@ht.satnam>
	 <1240191359.3106.93.camel@ht.satnam> <1240217428.3083.2.camel@ht.satnam>
	 <20090420111619.GE6670@elte.hu> <1240933437.3074.4.camel@ht.satnam>
	 <20090428172828.GA15392@elte.hu> <1240977176.3028.0.camel@ht.satnam>
	 <20090429105021.GG2373@elte.hu> <1241007294.3061.12.camel@ht.satnam>
	 <20090503090908.GA23183@elte.hu>
	 <1241603841.3322.3.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 10 May 2009 00:06:17 +0530
Message-Id: <1241894177.8978.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-06 at 15:27 +0530, Jaswinder Singh Rajput wrote:
> On Sun, 2009-05-03 at 11:09 +0200, Ingo Molnar wrote:
> > * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > 
> > > We can use cpu_has tests for unknown processors but 'cpu model' is 
> > > accurate and cover all range.
> > > 
> > > cpu_has does not cover following registers:
> > > 1. platform
> > > 2. poweron
> > > 3. control
> > > 4. bios
> > > 5. freq
> > > 6. cache
> > > 7. misc
> > > 8. base
> > > 9. ver
> > > 10. conf
> > 
> > Firstly these should be added to cpufeatures.h.
> > 
> > Then add cpu_has_xxx() accessors need to be added for them and 
> > during CPU init they have to be properly set, via two methods:
> > 
> >  - via CPUID (where this is possible+specified in docs)
> >  - or via "later than CPU version X" checks
> > 
> > Your cpu-model table is equivalent to an explicitly enumerated CPU 
> > version check, but this breaks every time a new CPU comes out. 
> > 
> > "Later than" or CPUID based feature bits are a lot more future-proof 
> > - we only have to add support for new _features_ (and quirks, 
> > occasionally), and dont have to maintain that full table of specific 
> > models to specific features mapping tables.
> > 
> 
> I add some cpufeatures for review, I am still adding rest of them.
> 
> The following changes since commit c861b6f8ea9b39699f4a35bbf7dc06eb937a34de:
>   Ingo Molnar (1):
>         Merge branch 'irq/urgent'
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git master


I added some more patches for the review.

The following changes since commit c861b6f8ea9b39699f4a35bbf7dc06eb937a34de:
  Ingo Molnar (1):
        Merge branch 'irq/urgent'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git master

Jaswinder Singh Rajput (17):
      x86: cpu_debug.c avoid storing cpu_descriptors locally
      x86: cpu_debug update Kconfig entry
      x86: cpu_debug.c remove unwanted header files
      x86: Add cpufeature for Processor Name
      x86: Add cpufeatures for Advanced Power Management
      x86: Add cpufeature for Microcode update
      x86: Add cpufeature for Cache MSRs
      x86: Add cpufeature for Hard and Soft Poweron configuration
      x86: Add cpufeature for Scaleable bus speed
      x86: Add cpufeature for Miscellaneous Features
      x86: Add cpufeature for Platform feature
      x86: Add cpufeature for Hardware configuration
      x86: Add cpufeature for System configuration
      x86: Add cpufeature for System management mode (SMM)
      x86: Add cpufeature for MM configuration
      x86: Add cpufeature for Bus configuration
      x86: cpu_debug replace cpu_modelflag with cpu_has

 arch/x86/Kconfig                  |   11 +-
 arch/x86/include/asm/cpu_debug.h  |  169 +-----------
 arch/x86/include/asm/cpufeature.h |   33 ++-
 arch/x86/include/asm/processor.h  |    1 -
 arch/x86/kernel/cpu/Makefile      |    2 +-
 arch/x86/kernel/cpu/amd.c         |   33 ++-
 arch/x86/kernel/cpu/common.c      |   17 +-
 arch/x86/kernel/cpu/cpu_debug.c   |  542 ++++++++++++-------------------------
 arch/x86/kernel/cpu/intel.c       |   93 ++++++-
 arch/x86/kernel/cpu/powerflags.c  |   20 --
 arch/x86/kernel/cpu/proc.c        |   14 -
 arch/x86/kernel/microcode_amd.c   |    3 +
 arch/x86/kernel/microcode_intel.c |    3 +
 13 files changed, 339 insertions(+), 602 deletions(-)
 delete mode 100644 arch/x86/kernel/cpu/powerflags.c

Complete diff:
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 4395f4f..213cbca 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -951,7 +951,16 @@ config X86_CPU_DEBUG
 	tristate "/sys/kernel/debug/x86/cpu/* - CPU Debug support"
 	---help---
 	  If you select this option, this will provide various x86 CPUs
-	  information through debugfs.
+	  information through debugfs. Any user can read these file but writing
+	  needs root privilege.
+
+	  Note: 1. If you compile cpu_debug as a module, it will _not_ be loaded
+	  automatically (like usual drivers). You will need to load it manually
+	  (or add it to list of modules loaded during boot).
+
+	  2. You need debugfs, if you want to mount debugfs automatically
+	  append this line in /etc/fstab:
+	  debugfs	/sys/kernel/debug	debugfs	defaults	0 0
 
 choice
 	prompt "High Memory Support"
diff --git a/arch/x86/include/asm/cpu_debug.h b/arch/x86/include/asm/cpu_debug.h
index 2228020..818c16b 100644
--- a/arch/x86/include/asm/cpu_debug.h
+++ b/arch/x86/include/asm/cpu_debug.h
@@ -9,76 +9,22 @@
 
 /* Register flags */
 enum cpu_debug_bit {
-/* Model Specific Registers (MSRs)					*/
-	CPU_MC_BIT,				/* Machine Check	*/
-	CPU_MONITOR_BIT,			/* Monitor		*/
-	CPU_TIME_BIT,				/* Time			*/
-	CPU_PMC_BIT,				/* Performance Monitor	*/
-	CPU_PLATFORM_BIT,			/* Platform		*/
-	CPU_APIC_BIT,				/* APIC			*/
-	CPU_POWERON_BIT,			/* Power-on		*/
-	CPU_CONTROL_BIT,			/* Control		*/
-	CPU_FEATURES_BIT,			/* Features control	*/
-	CPU_LBRANCH_BIT,			/* Last Branch		*/
-	CPU_BIOS_BIT,				/* BIOS			*/
-	CPU_FREQ_BIT,				/* Frequency		*/
-	CPU_MTTR_BIT,				/* MTRR			*/
-	CPU_PERF_BIT,				/* Performance		*/
-	CPU_CACHE_BIT,				/* Cache		*/
-	CPU_SYSENTER_BIT,			/* Sysenter		*/
-	CPU_THERM_BIT,				/* Thermal		*/
-	CPU_MISC_BIT,				/* Miscellaneous	*/
-	CPU_DEBUG_BIT,				/* Debug		*/
-	CPU_PAT_BIT,				/* PAT			*/
-	CPU_VMX_BIT,				/* VMX			*/
-	CPU_CALL_BIT,				/* System Call		*/
-	CPU_BASE_BIT,				/* BASE Address		*/
-	CPU_VER_BIT,				/* Version ID		*/
-	CPU_CONF_BIT,				/* Configuration	*/
-	CPU_SMM_BIT,				/* System mgmt mode	*/
-	CPU_SVM_BIT,				/*Secure Virtual Machine*/
-	CPU_OSVM_BIT,				/* OS-Visible Workaround*/
 /* Standard Registers							*/
-	CPU_TSS_BIT,				/* Task Stack Segment	*/
 	CPU_CR_BIT,				/* Control Registers	*/
+	CPU_DEBUG_BIT,				/* Debug		*/
 	CPU_DT_BIT,				/* Descriptor Table	*/
+	CPU_TSS_BIT,				/* Task Stack Segment	*/
 /* End of Registers flags						*/
 	CPU_REG_ALL_BIT,			/* Select all Registers	*/
 };
 
 #define	CPU_REG_ALL		(~0)		/* Select all Registers	*/
 
-#define	CPU_MC			(1 << CPU_MC_BIT)
-#define	CPU_MONITOR		(1 << CPU_MONITOR_BIT)
-#define	CPU_TIME		(1 << CPU_TIME_BIT)
-#define	CPU_PMC			(1 << CPU_PMC_BIT)
-#define	CPU_PLATFORM		(1 << CPU_PLATFORM_BIT)
-#define	CPU_APIC		(1 << CPU_APIC_BIT)
-#define	CPU_POWERON		(1 << CPU_POWERON_BIT)
-#define	CPU_CONTROL		(1 << CPU_CONTROL_BIT)
-#define	CPU_FEATURES		(1 << CPU_FEATURES_BIT)
-#define	CPU_LBRANCH		(1 << CPU_LBRANCH_BIT)
-#define	CPU_BIOS		(1 << CPU_BIOS_BIT)
-#define	CPU_FREQ		(1 << CPU_FREQ_BIT)
-#define	CPU_MTRR		(1 << CPU_MTTR_BIT)
-#define	CPU_PERF		(1 << CPU_PERF_BIT)
-#define	CPU_CACHE		(1 << CPU_CACHE_BIT)
-#define	CPU_SYSENTER		(1 << CPU_SYSENTER_BIT)
-#define	CPU_THERM		(1 << CPU_THERM_BIT)
-#define	CPU_MISC		(1 << CPU_MISC_BIT)
-#define	CPU_DEBUG		(1 << CPU_DEBUG_BIT)
-#define	CPU_PAT			(1 << CPU_PAT_BIT)
-#define	CPU_VMX			(1 << CPU_VMX_BIT)
-#define	CPU_CALL		(1 << CPU_CALL_BIT)
-#define	CPU_BASE		(1 << CPU_BASE_BIT)
-#define	CPU_VER			(1 << CPU_VER_BIT)
-#define	CPU_CONF		(1 << CPU_CONF_BIT)
-#define	CPU_SMM			(1 << CPU_SMM_BIT)
-#define	CPU_SVM			(1 << CPU_SVM_BIT)
-#define	CPU_OSVM		(1 << CPU_OSVM_BIT)
-#define	CPU_TSS			(1 << CPU_TSS_BIT)
-#define	CPU_CR			(1 << CPU_CR_BIT)
-#define	CPU_DT			(1 << CPU_DT_BIT)
+#define CPU_STD_BASE		0xFFFFF000
+#define CPU_CR			(CPU_STD_BASE + CPU_CR_BIT)
+#define CPU_DEBUG		(CPU_STD_BASE + CPU_DEBUG_BIT)
+#define CPU_DT			(CPU_STD_BASE + CPU_DT_BIT)
+#define CPU_TSS			(CPU_STD_BASE + CPU_TSS_BIT)
 
 /* Register file flags */
 enum cpu_file_bit {
@@ -86,105 +32,7 @@ enum cpu_file_bit {
 	CPU_VALUE_BIT,				/* value		*/
 };
 
-#define	CPU_FILE_VALUE			(1 << CPU_VALUE_BIT)
-
-/*
- * DisplayFamily_DisplayModel	Processor Families/Processor Number Series
- * --------------------------	------------------------------------------
- * 05_01, 05_02, 05_04		Pentium, Pentium with MMX
- *
- * 06_01			Pentium Pro
- * 06_03, 06_05			Pentium II Xeon, Pentium II
- * 06_07, 06_08, 06_0A, 06_0B	Pentium III Xeon, Pentum III
- *
- * 06_09, 060D			Pentium M
- *
- * 06_0E			Core Duo, Core Solo
- *
- * 06_0F			Xeon 3000, 3200, 5100, 5300, 7300 series,
- *				Core 2 Quad, Core 2 Extreme, Core 2 Duo,
- *				Pentium dual-core
- * 06_17			Xeon 5200, 5400 series, Core 2 Quad Q9650
- *
- * 06_1C			Atom
- *
- * 0F_00, 0F_01, 0F_02		Xeon, Xeon MP, Pentium 4
- * 0F_03, 0F_04			Xeon, Xeon MP, Pentium 4, Pentium D
- *
- * 0F_06			Xeon 7100, 5000 Series, Xeon MP,
- *				Pentium 4, Pentium D
- */
-
-/* Register processors bits */
-enum cpu_processor_bit {
-	CPU_NONE,
-/* Intel */
-	CPU_INTEL_PENTIUM_BIT,
-	CPU_INTEL_P6_BIT,
-	CPU_INTEL_PENTIUM_M_BIT,
-	CPU_INTEL_CORE_BIT,
-	CPU_INTEL_CORE2_BIT,
-	CPU_INTEL_ATOM_BIT,
-	CPU_INTEL_XEON_P4_BIT,
-	CPU_INTEL_XEON_MP_BIT,
-/* AMD */
-	CPU_AMD_K6_BIT,
-	CPU_AMD_K7_BIT,
-	CPU_AMD_K8_BIT,
-	CPU_AMD_0F_BIT,
-	CPU_AMD_10_BIT,
-	CPU_AMD_11_BIT,
-};
-
-#define	CPU_INTEL_PENTIUM	(1 << CPU_INTEL_PENTIUM_BIT)
-#define	CPU_INTEL_P6		(1 << CPU_INTEL_P6_BIT)
-#define	CPU_INTEL_PENTIUM_M	(1 << CPU_INTEL_PENTIUM_M_BIT)
-#define	CPU_INTEL_CORE		(1 << CPU_INTEL_CORE_BIT)
-#define	CPU_INTEL_CORE2		(1 << CPU_INTEL_CORE2_BIT)
-#define	CPU_INTEL_ATOM		(1 << CPU_INTEL_ATOM_BIT)
-#define	CPU_INTEL_XEON_P4	(1 << CPU_INTEL_XEON_P4_BIT)
-#define	CPU_INTEL_XEON_MP	(1 << CPU_INTEL_XEON_MP_BIT)
-
-#define	CPU_INTEL_PX		(CPU_INTEL_P6 | CPU_INTEL_PENTIUM_M)
-#define	CPU_INTEL_COREX		(CPU_INTEL_CORE | CPU_INTEL_CORE2)
-#define	CPU_INTEL_XEON		(CPU_INTEL_XEON_P4 | CPU_INTEL_XEON_MP)
-#define	CPU_CO_AT		(CPU_INTEL_CORE | CPU_INTEL_ATOM)
-#define	CPU_C2_AT		(CPU_INTEL_CORE2 | CPU_INTEL_ATOM)
-#define	CPU_CX_AT		(CPU_INTEL_COREX | CPU_INTEL_ATOM)
-#define	CPU_CX_XE		(CPU_INTEL_COREX | CPU_INTEL_XEON)
-#define	CPU_P6_XE		(CPU_INTEL_P6 | CPU_INTEL_XEON)
-#define	CPU_PM_CO_AT		(CPU_INTEL_PENTIUM_M | CPU_CO_AT)
-#define	CPU_C2_AT_XE		(CPU_C2_AT | CPU_INTEL_XEON)
-#define	CPU_CX_AT_XE		(CPU_CX_AT | CPU_INTEL_XEON)
-#define	CPU_P6_CX_AT		(CPU_INTEL_P6 | CPU_CX_AT)
-#define	CPU_P6_CX_XE		(CPU_P6_XE | CPU_INTEL_COREX)
-#define	CPU_P6_CX_AT_XE		(CPU_INTEL_P6 | CPU_CX_AT_XE)
-#define	CPU_PM_CX_AT_XE		(CPU_INTEL_PENTIUM_M | CPU_CX_AT_XE)
-#define	CPU_PM_CX_AT		(CPU_INTEL_PENTIUM_M | CPU_CX_AT)
-#define	CPU_PM_CX_XE		(CPU_INTEL_PENTIUM_M | CPU_CX_XE)
-#define	CPU_PX_CX_AT		(CPU_INTEL_PX | CPU_CX_AT)
-#define	CPU_PX_CX_AT_XE		(CPU_INTEL_PX | CPU_CX_AT_XE)
-
-/* Select all supported Intel CPUs */
-#define	CPU_INTEL_ALL		(CPU_INTEL_PENTIUM | CPU_PX_CX_AT_XE)
-
-#define	CPU_AMD_K6		(1 << CPU_AMD_K6_BIT)
-#define	CPU_AMD_K7		(1 << CPU_AMD_K7_BIT)
-#define	CPU_AMD_K8		(1 << CPU_AMD_K8_BIT)
-#define	CPU_AMD_0F		(1 << CPU_AMD_0F_BIT)
-#define	CPU_AMD_10		(1 << CPU_AMD_10_BIT)
-#define	CPU_AMD_11		(1 << CPU_AMD_11_BIT)
-
-#define	CPU_K10_PLUS		(CPU_AMD_10 | CPU_AMD_11)
-#define	CPU_K0F_PLUS		(CPU_AMD_0F | CPU_K10_PLUS)
-#define	CPU_K8_PLUS		(CPU_AMD_K8 | CPU_K0F_PLUS)
-#define	CPU_K7_PLUS		(CPU_AMD_K7 | CPU_K8_PLUS)
-
-/* Select all supported AMD CPUs */
-#define	CPU_AMD_ALL		(CPU_AMD_K6 | CPU_K7_PLUS)
-
-/* Select all supported CPUs */
-#define	CPU_ALL			(CPU_INTEL_ALL | CPU_AMD_ALL)
+#define	CPU_FILE_VALUE		(1 << CPU_VALUE_BIT)
 
 #define MAX_CPU_FILES		512
 
@@ -220,7 +68,6 @@ struct cpu_debug_range {
 	unsigned		min;		/* Register range min	*/
 	unsigned		max;		/* Register range max	*/
 	unsigned		flag;		/* Supported flags	*/
-	unsigned		model;		/* Supported models	*/
 };
 
 #endif /* _ASM_X86_CPU_DEBUG_H */
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index bb83b1c..a1d7b3e 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -6,7 +6,7 @@
 
 #include <asm/required-features.h>
 
-#define NCAPINTS	9	/* N 32-bit words worth of info */
+#define NCAPINTS	10	/* N 32-bit words worth of info */
 
 /*
  * Note: If the comment begins with a quoted string, that string is used
@@ -76,7 +76,6 @@
 #define X86_FEATURE_K7		(3*32+ 5) /* "" Athlon */
 #define X86_FEATURE_P3		(3*32+ 6) /* "" P3 */
 #define X86_FEATURE_P4		(3*32+ 7) /* "" P4 */
-#define X86_FEATURE_CONSTANT_TSC (3*32+ 8) /* TSC ticks at a constant rate */
 #define X86_FEATURE_UP		(3*32+ 9) /* smp kernel running on up */
 #define X86_FEATURE_FXSAVE_LEAK (3*32+10) /* "" FXSAVE leaks FOP/FIP/FOP */
 #define X86_FEATURE_ARCH_PERFMON (3*32+11) /* Intel Architectural PerfMon */
@@ -153,8 +152,22 @@
  * Auxiliary flags: Linux defined - For features scattered in various
  * CPUID levels like 0x6, 0xA etc
  */
-#define X86_FEATURE_IDA		(7*32+ 0) /* Intel Dynamic Acceleration */
-#define X86_FEATURE_ARAT	(7*32+ 1) /* Always Running APIC Timer */
+#define X86_FEATURE_IDA		(7*32+ 0) /* Intel Dynamic Acceleration	*/
+#define X86_FEATURE_ARAT	(7*32+ 1) /* Always Running APIC Timer	*/
+#define X86_FEATURE_PNAME	(7*32+ 2) /* Processor Name		*/
+#define X86_FEATURE_MICROCODE	(7*32+ 3) /* Microcode update		*/
+#define X86_FEATURE_CACHE	(7*32+ 4) /* BBL_CR_* MSRs (PII & PIII)	*/
+#define X86_FEATURE_CACHE_CTL	(7*32+ 5) /* Cache control MSRs		*/
+#define X86_FEATURE_HARD_POWERON (7*32+ 6) /* Hard Poweron configuration*/
+#define X86_FEATURE_SOFT_POWERON (7*32+ 7) /* Soft Poweron configuration*/
+#define X86_FEATURE_FSB_FREQ 	(7*32+ 8) /* Scaleable bus speed	*/
+#define X86_FEATURE_MISC 	(7*32+ 9) /* Miscellaneous features	*/
+#define X86_FEATURE_PLATFORM 	(7*32+ 10) /* Platform feature		*/
+#define X86_FEATURE_HW_CFG 	(7*32+ 11) /* Hardware configuration	*/
+#define X86_FEATURE_SYS_CFG 	(7*32+ 12) /* System configuration	*/
+#define X86_FEATURE_SMM 	(7*32+ 13) /* System Management	Mode	*/
+#define X86_FEATURE_MM_CFG 	(7*32+ 14) /* MM configuration		*/
+#define X86_FEATURE_BUS_CFG 	(7*32+ 15) /* Bus configuration		*/
 
 /* Virtualization flags: Linux defined */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
@@ -163,12 +176,22 @@
 #define X86_FEATURE_EPT         (8*32+ 3) /* Intel Extended Page Table */
 #define X86_FEATURE_VPID        (8*32+ 4) /* Intel Virtual Processor ID */
 
+/* Advanced Power Management (Function 8000_0007h), edx */
+#define X86_FEATURE_TS		(9*32+ 0) /* Temperatue sensor		*/
+#define X86_FEATURE_FID		(9*32+ 1) /* Frequency ID control	*/
+#define X86_FEATURE_VID		(9*32+ 2) /* Voltage ID control		*/
+#define X86_FEATURE_TTP		(9*32+ 3) /* Thermal trip		*/
+#define X86_FEATURE_HTC		(9*32+ 4) /* Hardware thermal control	*/
+#define X86_FEATURE_STC		(9*32+ 5) /* Software thermal control	*/
+#define X86_FEATURE_100MHZSTEPS	(9*32+ 6) /* 100 MHz multiplier control	*/
+#define X86_FEATURE_HWPSTATE	(9*32+ 7) /* Hardware P-State control	*/
+#define X86_FEATURE_CONSTANT_TSC (9*32+ 8) /* Constant rate TSC ticks	*/
+
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
 #include <linux/bitops.h>
 
 extern const char * const x86_cap_flags[NCAPINTS*32];
-extern const char * const x86_power_flags[32];
 
 #define test_cpu_cap(c, bit)						\
 	 test_bit(bit, (unsigned long *)((c)->x86_capability))
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 0b2fab0..deabe4a 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -90,7 +90,6 @@ struct cpuinfo_x86 {
 	/* in KB - valid for CPUS which support this call: */
 	int			x86_cache_size;
 	int			x86_cache_alignment;	/* In bytes */
-	int			x86_power;
 	unsigned long		loops_per_jiffy;
 #ifdef CONFIG_SMP
 	/* cpus sharing the last level cache: */
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 3efcb2b..b43fcbb 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -8,7 +8,7 @@ CFLAGS_REMOVE_common.o = -pg
 endif
 
 obj-y			:= intel_cacheinfo.o addon_cpuid_features.o
-obj-y			+= proc.o capflags.o powerflags.o common.o
+obj-y			+= proc.o capflags.o common.o
 obj-y			+= vmware.o hypervisor.o
 
 obj-$(CONFIG_X86_32)	+= bugs.o cmpxchg.o
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 7e4a459..4b7f7dc 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -333,15 +333,6 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 {
 	early_init_amd_mc(c);
 
-	/*
-	 * c->x86_power is 8000_0007 edx. Bit 8 is TSC runs at constant rate
-	 * with P/T states and does not stop in deep C-states
-	 */
-	if (c->x86_power & (1 << 8)) {
-		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
-		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
-	}
-
 #ifdef CONFIG_X86_64
 	set_cpu_cap(c, X86_FEATURE_SYSCALL32);
 #else
@@ -485,6 +476,30 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		}
 	}
 #endif
+
+	/* Set cpufeatures for miscellaneous MSRs			*/
+	if (c->x86 >= 7) {				/* K7+		*/
+		/* MSRC001_0015 Hardware Configuration Register (HWCR)	*/
+		set_cpu_cap(c, X86_FEATURE_HW_CFG);
+	}
+	if (c->x86 >= 8) {				/* K8+		*/
+		/*
+		 * System configuration MSRs:
+		 * MSRC001_0010 System Configuration Register (SYS_CFG)
+		 * MSRC001_001F Northbridge Configuration Register (NB_CFG)
+		 */
+		set_cpu_cap(c, X86_FEATURE_SYS_CFG);
+		/* SMM MSRs C001_0111-C001_0113 & C001_0050-C000_0056	*/
+		set_cpu_cap(c, X86_FEATURE_SMM);
+	}
+	if (c->x86 >= 0x10) {				/* fam10h+	*/
+		/* MSRC001_1022 Data Cache Configuration (DC_CFG)	*/
+		set_cpu_cap(c, X86_FEATURE_CACHE_CTL);
+		/* MSRC001_0058 MMIO Configuration Base Address Register*/
+		set_cpu_cap(c, X86_FEATURE_MM_CFG);
+		/* MSRC001_1023 Bus Unit Configuration Register (BU_CFG)*/
+		set_cpu_cap(c, X86_FEATURE_BUS_CFG);
+	}
 }
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index a86769e..b2b2cbd 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -360,6 +360,7 @@ static void __cpuinit get_model_name(struct cpuinfo_x86 *c)
 	cpuid(0x80000003, &v[4], &v[5], &v[6], &v[7]);
 	cpuid(0x80000004, &v[8], &v[9], &v[10], &v[11]);
 	c->x86_model_id[48] = 0;
+	set_cpu_cap(c, X86_FEATURE_PNAME);
 
 	/*
 	 * Intel chips right-justify this string for some dumb reason;
@@ -575,8 +576,22 @@ static void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
 #endif
 
 	if (c->extended_cpuid_level >= 0x80000007)
-		c->x86_power = cpuid_edx(0x80000007);
+		c->x86_capability[9] = cpuid_edx(0x80000007);
 
+	/*
+	 * Advanced power management is 8000_0007 edx.
+	 * Bit 8 is TSC runs at constant rate with P/T states
+	 * and does not stop in deep C-states.
+	 *
+	 * It is also reliable across cores and sockets. (but not across
+	 * cabinets - we turn it off in that case explicitly.)
+	 */
+	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
+		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
+		set_cpu_cap(c, X86_FEATURE_TSC_RELIABLE);
+		if (c->x86_vendor == X86_VENDOR_INTEL)
+			sched_clock_stable = 1;
+	}
 }
 
 static void __cpuinit identify_cpu_without_cpuid(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
index 46e29ab..c6246aa 100644
--- a/arch/x86/kernel/cpu/cpu_debug.c
+++ b/arch/x86/kernel/cpu/cpu_debug.c
@@ -6,16 +6,12 @@
  * For licencing details see kernel-base/COPYING
  */
 
-#include <linux/interrupt.h>
-#include <linux/compiler.h>
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
-#include <linux/kprobes.h>
 #include <linux/uaccess.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/percpu.h>
-#include <linux/signal.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
 #include <linux/types.h>
@@ -26,384 +22,190 @@
 #include <asm/cpu_debug.h>
 #include <asm/paravirt.h>
 #include <asm/system.h>
-#include <asm/traps.h>
 #include <asm/apic.h>
 #include <asm/desc.h>
 
-static DEFINE_PER_CPU(struct cpu_cpuX_base, cpu_arr[CPU_REG_ALL_BIT]);
 static DEFINE_PER_CPU(struct cpu_private *, priv_arr[MAX_CPU_FILES]);
-static DEFINE_PER_CPU(unsigned, cpu_modelflag);
 static DEFINE_PER_CPU(int, cpu_priv_count);
-static DEFINE_PER_CPU(unsigned, cpu_model);
 
 static DEFINE_MUTEX(cpu_debug_lock);
 
 static struct dentry *cpu_debugfs_dir;
 
 static struct cpu_debug_base cpu_base[] = {
-	{ "mc",		CPU_MC,		0	},
-	{ "monitor",	CPU_MONITOR,	0	},
-	{ "time",	CPU_TIME,	0	},
-	{ "pmc",	CPU_PMC,	1	},
-	{ "platform",	CPU_PLATFORM,	0	},
-	{ "apic",	CPU_APIC,	0	},
-	{ "poweron",	CPU_POWERON,	0	},
-	{ "control",	CPU_CONTROL,	0	},
-	{ "features",	CPU_FEATURES,	0	},
-	{ "lastbranch",	CPU_LBRANCH,	0	},
-	{ "bios",	CPU_BIOS,	0	},
-	{ "freq",	CPU_FREQ,	0	},
-	{ "mtrr",	CPU_MTRR,	0	},
-	{ "perf",	CPU_PERF,	0	},
-	{ "cache",	CPU_CACHE,	0	},
-	{ "sysenter",	CPU_SYSENTER,	0	},
-	{ "therm",	CPU_THERM,	0	},
-	{ "misc",	CPU_MISC,	0	},
-	{ "debug",	CPU_DEBUG,	0	},
-	{ "pat",	CPU_PAT,	0	},
-	{ "vmx",	CPU_VMX,	0	},
-	{ "call",	CPU_CALL,	0	},
-	{ "base",	CPU_BASE,	0	},
-	{ "ver",	CPU_VER,	0	},
-	{ "conf",	CPU_CONF,	0	},
-	{ "smm",	CPU_SMM,	0	},
-	{ "svm",	CPU_SVM,	0	},
-	{ "osvm",	CPU_OSVM,	0	},
-	{ "tss",	CPU_TSS,	0	},
-	{ "cr",		CPU_CR,		0	},
-	{ "dt",		CPU_DT,		0	},
-	{ "registers",	CPU_REG_ALL,	0	},
+	/*  Model Specific Registers (MSRs)				*/
+	{ "apic",		X86_FEATURE_APIC,		0	},
+	{ "base",		X86_FEATURE_LM,			0	},
+	{ "branch",		X86_FEATURE_BTS,		0	},
+	{ "bus_cfg",		X86_FEATURE_BUS_CFG,		0	},
+	{ "cache",		X86_FEATURE_CACHE,		0	},
+	{ "cache_ctl",		X86_FEATURE_CACHE_CTL,		0	},
+	{ "control",		X86_FEATURE_SMX,		0	},
+	{ "debug_ext",		X86_FEATURE_DE,			0	},
+	{ "debug_store",	X86_FEATURE_DS,			0	},
+	{ "features",		X86_FEATURE_NX,			0	},
+	{ "fsb_freq",		X86_FEATURE_FSB_FREQ,		0	},
+	{ "hard_poweron",	X86_FEATURE_HARD_POWERON,	0	},
+	{ "hw_cfg",		X86_FEATURE_HW_CFG,		0	},
+	{ "mc",			X86_FEATURE_MCA,		0	},
+	{ "microcode",		X86_FEATURE_MICROCODE,		0	},
+	{ "misc",		X86_FEATURE_MISC,		0	},
+	{ "mm_cfg",		X86_FEATURE_MM_CFG,		0	},
+	{ "monitor",		X86_FEATURE_MWAIT,		0	},
+	{ "mtrr",		X86_FEATURE_MTRR,		0	},
+	{ "osvw",		X86_FEATURE_OSVW,		0	},
+	{ "pat",		X86_FEATURE_PAT,		0	},
+	{ "perf",		X86_FEATURE_EST,		0	},
+	{ "platform",		X86_FEATURE_PLATFORM,		0	},
+	{ "pmc",		X86_FEATURE_ARCH_PERFMON,	1	},
+	{ "pname",		X86_FEATURE_PNAME,		0	},
+	{ "pstate",		X86_FEATURE_HWPSTATE,		0	},
+	{ "smm",		X86_FEATURE_SMM,		0	},
+	{ "soft_poweron",	X86_FEATURE_SOFT_POWERON,	0	},
+	{ "svm",		X86_FEATURE_SVM,		0	},
+	{ "sys_cfg",		X86_FEATURE_SYS_CFG,		0	},
+	{ "syscall",		X86_FEATURE_SYSCALL,		0	},
+	{ "sysenter",		X86_FEATURE_SEP,		0	},
+	{ "therm",		X86_FEATURE_ACC,		0	},
+	{ "therm2",		X86_FEATURE_TM2,		0	},
+	{ "tsc",		X86_FEATURE_TSC,		0	},
+	{ "tsc_aux",		X86_FEATURE_RDTSCP,		0	},
+	{ "vmx",		X86_FEATURE_VMX,		0	},
+	/* Standard Registers						*/
+	{ "cr",			CPU_CR,				0	},
+	{ "debug",		CPU_DEBUG,			0	},
+	{ "dt",			CPU_DT,				0	},
+	{ "tss",		CPU_TSS,			0	},
 };
 
-static struct cpu_file_base cpu_file[] = {
-	{ "index",	CPU_REG_ALL,	0	},
-	{ "value",	CPU_REG_ALL,	1	},
-};
+static DEFINE_PER_CPU(struct cpu_cpuX_base, cpu_arr[ARRAY_SIZE(cpu_base)]);
 
-/* Intel Registers Range */
-static struct cpu_debug_range cpu_intel_range[] = {
-	{ 0x00000000, 0x00000001, CPU_MC,	CPU_INTEL_ALL		},
-	{ 0x00000006, 0x00000007, CPU_MONITOR,	CPU_CX_AT_XE		},
-	{ 0x00000010, 0x00000010, CPU_TIME,	CPU_INTEL_ALL		},
-	{ 0x00000011, 0x00000013, CPU_PMC,	CPU_INTEL_PENTIUM	},
-	{ 0x00000017, 0x00000017, CPU_PLATFORM,	CPU_PX_CX_AT_XE		},
-	{ 0x0000001B, 0x0000001B, CPU_APIC,	CPU_P6_CX_AT_XE		},
-
-	{ 0x0000002A, 0x0000002A, CPU_POWERON,	CPU_PX_CX_AT_XE		},
-	{ 0x0000002B, 0x0000002B, CPU_POWERON,	CPU_INTEL_XEON		},
-	{ 0x0000002C, 0x0000002C, CPU_FREQ,	CPU_INTEL_XEON		},
-	{ 0x0000003A, 0x0000003A, CPU_CONTROL,	CPU_CX_AT_XE		},
-
-	{ 0x00000040, 0x00000043, CPU_LBRANCH,	CPU_PM_CX_AT_XE		},
-	{ 0x00000044, 0x00000047, CPU_LBRANCH,	CPU_PM_CO_AT		},
-	{ 0x00000060, 0x00000063, CPU_LBRANCH,	CPU_C2_AT		},
-	{ 0x00000064, 0x00000067, CPU_LBRANCH,	CPU_INTEL_ATOM		},
-
-	{ 0x00000079, 0x00000079, CPU_BIOS,	CPU_P6_CX_AT_XE		},
-	{ 0x00000088, 0x0000008A, CPU_CACHE,	CPU_INTEL_P6		},
-	{ 0x0000008B, 0x0000008B, CPU_BIOS,	CPU_P6_CX_AT_XE		},
-	{ 0x0000009B, 0x0000009B, CPU_MONITOR,	CPU_INTEL_XEON		},
-
-	{ 0x000000C1, 0x000000C2, CPU_PMC,	CPU_P6_CX_AT		},
-	{ 0x000000CD, 0x000000CD, CPU_FREQ,	CPU_CX_AT		},
-	{ 0x000000E7, 0x000000E8, CPU_PERF,	CPU_CX_AT		},
-	{ 0x000000FE, 0x000000FE, CPU_MTRR,	CPU_P6_CX_XE		},
-
-	{ 0x00000116, 0x00000116, CPU_CACHE,	CPU_INTEL_P6		},
-	{ 0x00000118, 0x00000118, CPU_CACHE,	CPU_INTEL_P6		},
-	{ 0x00000119, 0x00000119, CPU_CACHE,	CPU_INTEL_PX		},
-	{ 0x0000011A, 0x0000011B, CPU_CACHE,	CPU_INTEL_P6		},
-	{ 0x0000011E, 0x0000011E, CPU_CACHE,	CPU_PX_CX_AT		},
-
-	{ 0x00000174, 0x00000176, CPU_SYSENTER,	CPU_P6_CX_AT_XE		},
-	{ 0x00000179, 0x0000017A, CPU_MC,	CPU_PX_CX_AT_XE		},
-	{ 0x0000017B, 0x0000017B, CPU_MC,	CPU_P6_XE		},
-	{ 0x00000186, 0x00000187, CPU_PMC,	CPU_P6_CX_AT		},
-	{ 0x00000198, 0x00000199, CPU_PERF,	CPU_PM_CX_AT_XE		},
-	{ 0x0000019A, 0x0000019A, CPU_TIME,	CPU_PM_CX_AT_XE		},
-	{ 0x0000019B, 0x0000019D, CPU_THERM,	CPU_PM_CX_AT_XE		},
-	{ 0x000001A0, 0x000001A0, CPU_MISC,	CPU_PM_CX_AT_XE		},
-
-	{ 0x000001C9, 0x000001C9, CPU_LBRANCH,	CPU_PM_CX_AT		},
-	{ 0x000001D7, 0x000001D8, CPU_LBRANCH,	CPU_INTEL_XEON		},
-	{ 0x000001D9, 0x000001D9, CPU_DEBUG,	CPU_CX_AT_XE		},
-	{ 0x000001DA, 0x000001DA, CPU_LBRANCH,	CPU_INTEL_XEON		},
-	{ 0x000001DB, 0x000001DB, CPU_LBRANCH,	CPU_P6_XE		},
-	{ 0x000001DC, 0x000001DC, CPU_LBRANCH,	CPU_INTEL_P6		},
-	{ 0x000001DD, 0x000001DE, CPU_LBRANCH,	CPU_PX_CX_AT_XE		},
-	{ 0x000001E0, 0x000001E0, CPU_LBRANCH,	CPU_INTEL_P6		},
-
-	{ 0x00000200, 0x0000020F, CPU_MTRR,	CPU_P6_CX_XE		},
-	{ 0x00000250, 0x00000250, CPU_MTRR,	CPU_P6_CX_XE		},
-	{ 0x00000258, 0x00000259, CPU_MTRR,	CPU_P6_CX_XE		},
-	{ 0x00000268, 0x0000026F, CPU_MTRR,	CPU_P6_CX_XE		},
-	{ 0x00000277, 0x00000277, CPU_PAT,	CPU_C2_AT_XE		},
-	{ 0x000002FF, 0x000002FF, CPU_MTRR,	CPU_P6_CX_XE		},
-
-	{ 0x00000300, 0x00000308, CPU_PMC,	CPU_INTEL_XEON		},
-	{ 0x00000309, 0x0000030B, CPU_PMC,	CPU_C2_AT_XE		},
-	{ 0x0000030C, 0x00000311, CPU_PMC,	CPU_INTEL_XEON		},
-	{ 0x00000345, 0x00000345, CPU_PMC,	CPU_C2_AT		},
-	{ 0x00000360, 0x00000371, CPU_PMC,	CPU_INTEL_XEON		},
-	{ 0x0000038D, 0x00000390, CPU_PMC,	CPU_C2_AT		},
-	{ 0x000003A0, 0x000003BE, CPU_PMC,	CPU_INTEL_XEON		},
-	{ 0x000003C0, 0x000003CD, CPU_PMC,	CPU_INTEL_XEON		},
-	{ 0x000003E0, 0x000003E1, CPU_PMC,	CPU_INTEL_XEON		},
-	{ 0x000003F0, 0x000003F0, CPU_PMC,	CPU_INTEL_XEON		},
-	{ 0x000003F1, 0x000003F1, CPU_PMC,	CPU_C2_AT_XE		},
-	{ 0x000003F2, 0x000003F2, CPU_PMC,	CPU_INTEL_XEON		},
-
-	{ 0x00000400, 0x00000402, CPU_MC,	CPU_PM_CX_AT_XE		},
-	{ 0x00000403, 0x00000403, CPU_MC,	CPU_INTEL_XEON		},
-	{ 0x00000404, 0x00000406, CPU_MC,	CPU_PM_CX_AT_XE		},
-	{ 0x00000407, 0x00000407, CPU_MC,	CPU_INTEL_XEON		},
-	{ 0x00000408, 0x0000040A, CPU_MC,	CPU_PM_CX_AT_XE		},
-	{ 0x0000040B, 0x0000040B, CPU_MC,	CPU_INTEL_XEON		},
-	{ 0x0000040C, 0x0000040E, CPU_MC,	CPU_PM_CX_XE		},
-	{ 0x0000040F, 0x0000040F, CPU_MC,	CPU_INTEL_XEON		},
-	{ 0x00000410, 0x00000412, CPU_MC,	CPU_PM_CX_AT_XE		},
-	{ 0x00000413, 0x00000417, CPU_MC,	CPU_CX_AT_XE		},
-	{ 0x00000480, 0x0000048B, CPU_VMX,	CPU_CX_AT_XE		},
-
-	{ 0x00000600, 0x00000600, CPU_DEBUG,	CPU_PM_CX_AT_XE		},
-	{ 0x00000680, 0x0000068F, CPU_LBRANCH,	CPU_INTEL_XEON		},
-	{ 0x000006C0, 0x000006CF, CPU_LBRANCH,	CPU_INTEL_XEON		},
-
-	{ 0x000107CC, 0x000107D3, CPU_PMC,	CPU_INTEL_XEON_MP	},
-
-	{ 0xC0000080, 0xC0000080, CPU_FEATURES,	CPU_INTEL_XEON		},
-	{ 0xC0000081, 0xC0000082, CPU_CALL,	CPU_INTEL_XEON		},
-	{ 0xC0000084, 0xC0000084, CPU_CALL,	CPU_INTEL_XEON		},
-	{ 0xC0000100, 0xC0000102, CPU_BASE,	CPU_INTEL_XEON		},
+static struct cpu_file_base cpu_file[] = {
+	{ "index",		CPU_REG_ALL,			0	},
+	{ "value",		CPU_REG_ALL,			1	},
 };
 
-/* AMD Registers Range */
-static struct cpu_debug_range cpu_amd_range[] = {
-	{ 0x00000000, 0x00000001, CPU_MC,	CPU_K10_PLUS,		},
-	{ 0x00000010, 0x00000010, CPU_TIME,	CPU_K8_PLUS,		},
-	{ 0x0000001B, 0x0000001B, CPU_APIC,	CPU_K8_PLUS,		},
-	{ 0x0000002A, 0x0000002A, CPU_POWERON,	CPU_K7_PLUS		},
-	{ 0x0000008B, 0x0000008B, CPU_VER,	CPU_K8_PLUS		},
-	{ 0x000000FE, 0x000000FE, CPU_MTRR,	CPU_K8_PLUS,		},
-
-	{ 0x00000174, 0x00000176, CPU_SYSENTER,	CPU_K8_PLUS,		},
-	{ 0x00000179, 0x0000017B, CPU_MC,	CPU_K8_PLUS,		},
-	{ 0x000001D9, 0x000001D9, CPU_DEBUG,	CPU_K8_PLUS,		},
-	{ 0x000001DB, 0x000001DE, CPU_LBRANCH,	CPU_K8_PLUS,		},
-
-	{ 0x00000200, 0x0000020F, CPU_MTRR,	CPU_K8_PLUS,		},
-	{ 0x00000250, 0x00000250, CPU_MTRR,	CPU_K8_PLUS,		},
-	{ 0x00000258, 0x00000259, CPU_MTRR,	CPU_K8_PLUS,		},
-	{ 0x00000268, 0x0000026F, CPU_MTRR,	CPU_K8_PLUS,		},
-	{ 0x00000277, 0x00000277, CPU_PAT,	CPU_K8_PLUS,		},
-	{ 0x000002FF, 0x000002FF, CPU_MTRR,	CPU_K8_PLUS,		},
-
-	{ 0x00000400, 0x00000413, CPU_MC,	CPU_K8_PLUS,		},
-
-	{ 0xC0000080, 0xC0000080, CPU_FEATURES,	CPU_AMD_ALL,		},
-	{ 0xC0000081, 0xC0000084, CPU_CALL,	CPU_K8_PLUS,		},
-	{ 0xC0000100, 0xC0000102, CPU_BASE,	CPU_K8_PLUS,		},
-	{ 0xC0000103, 0xC0000103, CPU_TIME,	CPU_K10_PLUS,		},
-
-	{ 0xC0010000, 0xC0010007, CPU_PMC,	CPU_K8_PLUS,		},
-	{ 0xC0010010, 0xC0010010, CPU_CONF,	CPU_K7_PLUS,		},
-	{ 0xC0010015, 0xC0010015, CPU_CONF,	CPU_K7_PLUS,		},
-	{ 0xC0010016, 0xC001001A, CPU_MTRR,	CPU_K8_PLUS,		},
-	{ 0xC001001D, 0xC001001D, CPU_MTRR,	CPU_K8_PLUS,		},
-	{ 0xC001001F, 0xC001001F, CPU_CONF,	CPU_K8_PLUS,		},
-	{ 0xC0010030, 0xC0010035, CPU_BIOS,	CPU_K8_PLUS,		},
-	{ 0xC0010044, 0xC0010048, CPU_MC,	CPU_K8_PLUS,		},
-	{ 0xC0010050, 0xC0010056, CPU_SMM,	CPU_K0F_PLUS,		},
-	{ 0xC0010058, 0xC0010058, CPU_CONF,	CPU_K10_PLUS,		},
-	{ 0xC0010060, 0xC0010060, CPU_CACHE,	CPU_AMD_11,		},
-	{ 0xC0010061, 0xC0010068, CPU_SMM,	CPU_K10_PLUS,		},
-	{ 0xC0010069, 0xC001006B, CPU_SMM,	CPU_AMD_11,		},
-	{ 0xC0010070, 0xC0010071, CPU_SMM,	CPU_K10_PLUS,		},
-	{ 0xC0010111, 0xC0010113, CPU_SMM,	CPU_K8_PLUS,		},
-	{ 0xC0010114, 0xC0010118, CPU_SVM,	CPU_K10_PLUS,		},
-	{ 0xC0010140, 0xC0010141, CPU_OSVM,	CPU_K10_PLUS,		},
-	{ 0xC0011022, 0xC0011023, CPU_CONF,	CPU_K10_PLUS,		},
+/* CPU Registers Range */
+static struct cpu_debug_range cpu_reg_range[] = {
+	{ 0x00000000, 0x00000001, X86_FEATURE_MCA			},
+	{ 0x00000006, 0x00000007, X86_FEATURE_MWAIT			},
+	{ 0x00000010, 0x00000010, X86_FEATURE_TSC			},
+	{ 0x00000011, 0x00000013, X86_FEATURE_ARCH_PERFMON		},
+	{ 0x00000017, 0x00000017, X86_FEATURE_MICROCODE			},
+	{ 0x0000001B, 0x0000001B, X86_FEATURE_APIC			},
+	{ 0x0000002A, 0x0000002A, X86_FEATURE_HARD_POWERON		},
+	{ 0x0000002B, 0x0000002C, X86_FEATURE_SOFT_POWERON		},
+	{ 0x0000003A, 0x0000003A, X86_FEATURE_SMX			},
+	{ 0x00000040, 0x00000047, X86_FEATURE_BTS			},
+	{ 0x00000060, 0x00000067, X86_FEATURE_BTS			},
+	{ 0x00000079, 0x00000079, X86_FEATURE_MICROCODE			},
+	{ 0x00000088, 0x0000008A, X86_FEATURE_CACHE			},
+	{ 0x0000008B, 0x0000008B, X86_FEATURE_MICROCODE			},
+	{ 0x0000009B, 0x0000009B, X86_FEATURE_MWAIT			},
+	{ 0x000000C1, 0x000000C2, X86_FEATURE_ARCH_PERFMON		},
+	{ 0x000000CD, 0x000000CD, X86_FEATURE_FSB_FREQ			},
+	{ 0x000000E7, 0x000000E8, X86_FEATURE_EST			},
+	{ 0x000000FE, 0x000000FE, X86_FEATURE_MTRR			},
+
+	{ 0x00000116, 0x00000116, X86_FEATURE_CACHE			},
+	{ 0x00000118, 0x00000118, X86_FEATURE_CACHE			},
+	{ 0x00000119, 0x00000119, X86_FEATURE_CACHE_CTL			},
+	{ 0x0000011A, 0x0000011B, X86_FEATURE_CACHE			},
+	{ 0x0000011E, 0x0000011E, X86_FEATURE_CACHE_CTL			},
+	{ 0x00000174, 0x00000176, X86_FEATURE_SEP			},
+	{ 0x00000179, 0x0000017B, X86_FEATURE_MCA			},
+	{ 0x00000186, 0x00000187, X86_FEATURE_ARCH_PERFMON		},
+	{ 0x00000198, 0x00000199, X86_FEATURE_EST			},
+	{ 0x0000019A, 0x0000019C, X86_FEATURE_ACC			},
+	{ 0x0000019D, 0x0000019D, X86_FEATURE_TM2			},
+	{ 0x000001A0, 0x000001A0, X86_FEATURE_MISC			},
+	{ 0x000001A1, 0x000001A1, X86_FEATURE_PLATFORM			},
+	{ 0x000001C9, 0x000001C9, X86_FEATURE_BTS			},
+	{ 0x000001D7, 0x000001D8, X86_FEATURE_BTS			},
+	{ 0x000001D9, 0x000001D9, X86_FEATURE_DE			},
+	{ 0x000001DA, 0x000001DE, X86_FEATURE_BTS			},
+	{ 0x000001E0, 0x000001E0, X86_FEATURE_BTS			},
+
+	{ 0x00000200, 0x0000020F, X86_FEATURE_MTRR			},
+	{ 0x00000250, 0x00000250, X86_FEATURE_MTRR			},
+	{ 0x00000258, 0x00000259, X86_FEATURE_MTRR			},
+	{ 0x00000268, 0x0000026F, X86_FEATURE_MTRR			},
+	{ 0x00000277, 0x00000277, X86_FEATURE_PAT			},
+	{ 0x000002FF, 0x000002FF, X86_FEATURE_MTRR			},
+
+	{ 0x00000300, 0x00000311, X86_FEATURE_ARCH_PERFMON		},
+	{ 0x00000345, 0x00000345, X86_FEATURE_ARCH_PERFMON		},
+	{ 0x00000360, 0x00000371, X86_FEATURE_ARCH_PERFMON		},
+	{ 0x0000038D, 0x00000390, X86_FEATURE_ARCH_PERFMON		},
+	{ 0x000003A0, 0x000003BE, X86_FEATURE_ARCH_PERFMON		},
+	{ 0x000003C0, 0x000003CD, X86_FEATURE_ARCH_PERFMON		},
+	{ 0x000003E0, 0x000003E1, X86_FEATURE_ARCH_PERFMON		},
+	{ 0x000003F0, 0x000003F2, X86_FEATURE_ARCH_PERFMON		},
+
+	{ 0x00000400, 0x00000417, X86_FEATURE_MCA			},
+	{ 0x00000480, 0x0000048B, X86_FEATURE_VMX			},
+
+	{ 0x00000600, 0x00000600, X86_FEATURE_DS			},
+	{ 0x00000680, 0x0000068F, X86_FEATURE_BTS			},
+	{ 0x000006C0, 0x000006CF, X86_FEATURE_BTS			},
+
+	{ 0x000107CC, 0xC00107D3, X86_FEATURE_ARCH_PERFMON		},
+
+	{ 0xC0000080, 0xC0000080, X86_FEATURE_NX			},
+	{ 0xC0000081, 0xC0000084, X86_FEATURE_SYSCALL			},
+	{ 0xC0000100, 0xC0000102, X86_FEATURE_LM			},
+	{ 0xC0000103, 0xC0000103, X86_FEATURE_RDTSCP			},
+
+	{ 0xC0010000, 0xC0010007, X86_FEATURE_ARCH_PERFMON		},
+	{ 0xC0010010, 0xC0010010, X86_FEATURE_SYS_CFG			},
+	{ 0xC0010015, 0xC0010015, X86_FEATURE_HW_CFG			},
+	{ 0xC0010016, 0xC001001A, X86_FEATURE_MTRR			},
+	{ 0xC001001D, 0xC001001D, X86_FEATURE_MTRR			},
+	{ 0xC001001F, 0xC001001F, X86_FEATURE_SYS_CFG			},
+	{ 0xC0010030, 0xC0010035, X86_FEATURE_PNAME			},
+	{ 0xC0010044, 0xC0010048, X86_FEATURE_MCA			},
+	{ 0xC0010050, 0xC0010056, X86_FEATURE_SMM			},
+	{ 0xC0010058, 0xC0010058, X86_FEATURE_MM_CFG			},
+	{ 0xC0010060, 0xC0010060, X86_FEATURE_DE			},
+	{ 0xC0010061, 0xC001006B, X86_FEATURE_HWPSTATE			},
+	{ 0xC0010070, 0xC0010071, X86_FEATURE_HWPSTATE			},
+	{ 0xC0010111, 0xC0010113, X86_FEATURE_SMM			},
+	{ 0xC0010114, 0xC0010118, X86_FEATURE_SVM			},
+	{ 0xC0010140, 0xC0010141, X86_FEATURE_OSVW			},
+
+	{ 0xC0011022, 0xC0011023, X86_FEATURE_BUS_CFG			},
 };
 
-
-/* Intel */
-static int get_intel_modelflag(unsigned model)
-{
-	int flag;
-
-	switch (model) {
-	case 0x0501:
-	case 0x0502:
-	case 0x0504:
-		flag = CPU_INTEL_PENTIUM;
-		break;
-	case 0x0601:
-	case 0x0603:
-	case 0x0605:
-	case 0x0607:
-	case 0x0608:
-	case 0x060A:
-	case 0x060B:
-		flag = CPU_INTEL_P6;
-		break;
-	case 0x0609:
-	case 0x060D:
-		flag = CPU_INTEL_PENTIUM_M;
-		break;
-	case 0x060E:
-		flag = CPU_INTEL_CORE;
-		break;
-	case 0x060F:
-	case 0x0617:
-		flag = CPU_INTEL_CORE2;
-		break;
-	case 0x061C:
-		flag = CPU_INTEL_ATOM;
-		break;
-	case 0x0F00:
-	case 0x0F01:
-	case 0x0F02:
-	case 0x0F03:
-	case 0x0F04:
-		flag = CPU_INTEL_XEON_P4;
-		break;
-	case 0x0F06:
-		flag = CPU_INTEL_XEON_MP;
-		break;
-	default:
-		flag = CPU_NONE;
-		break;
-	}
-
-	return flag;
-}
-
-/* AMD */
-static int get_amd_modelflag(unsigned model)
-{
-	int flag;
-
-	switch (model >> 8) {
-	case 0x6:
-		flag = CPU_AMD_K6;
-		break;
-	case 0x7:
-		flag = CPU_AMD_K7;
-		break;
-	case 0x8:
-		flag = CPU_AMD_K8;
-		break;
-	case 0xf:
-		flag = CPU_AMD_0F;
-		break;
-	case 0x10:
-		flag = CPU_AMD_10;
-		break;
-	case 0x11:
-		flag = CPU_AMD_11;
-		break;
-	default:
-		flag = CPU_NONE;
-		break;
-	}
-
-	return flag;
-}
-
-static int get_cpu_modelflag(unsigned cpu)
-{
-	int flag;
-
-	flag = per_cpu(cpu_model, cpu);
-
-	switch (flag >> 16) {
-	case X86_VENDOR_INTEL:
-		flag = get_intel_modelflag(flag);
-		break;
-	case X86_VENDOR_AMD:
-		flag = get_amd_modelflag(flag & 0xffff);
-		break;
-	default:
-		flag = CPU_NONE;
-		break;
-	}
-
-	return flag;
-}
-
-static int get_cpu_range_count(unsigned cpu)
-{
-	int index;
-
-	switch (per_cpu(cpu_model, cpu) >> 16) {
-	case X86_VENDOR_INTEL:
-		index = ARRAY_SIZE(cpu_intel_range);
-		break;
-	case X86_VENDOR_AMD:
-		index = ARRAY_SIZE(cpu_amd_range);
-		break;
-	default:
-		index = 0;
-		break;
-	}
-
-	return index;
-}
-
 static int is_typeflag_valid(unsigned cpu, unsigned flag)
 {
-	unsigned vendor, modelflag;
-	int i, index;
+	struct cpuinfo_x86 *cpui;
+	int i;
 
 	/* Standard Registers should be always valid */
-	if (flag >= CPU_TSS)
+	if (flag >= CPU_STD_BASE)
 		return 1;
 
-	modelflag = per_cpu(cpu_modelflag, cpu);
-	vendor = per_cpu(cpu_model, cpu) >> 16;
-	index = get_cpu_range_count(cpu);
-
-	for (i = 0; i < index; i++) {
-		switch (vendor) {
-		case X86_VENDOR_INTEL:
-			if ((cpu_intel_range[i].model & modelflag) &&
-			    (cpu_intel_range[i].flag & flag))
-				return 1;
-			break;
-		case X86_VENDOR_AMD:
-			if ((cpu_amd_range[i].model & modelflag) &&
-			    (cpu_amd_range[i].flag & flag))
-				return 1;
-			break;
-		}
+	cpui = &cpu_data(cpu);
+	if (!cpu_has(cpui, flag))
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(cpu_reg_range); i++) {
+		if (cpu_reg_range[i].flag == flag)
+			return 1;
 	}
 
 	/* Invalid */
 	return 0;
 }
 
-static unsigned get_cpu_range(unsigned cpu, unsigned *min, unsigned *max,
+static unsigned get_cpu_range(unsigned *min, unsigned *max,
 			      int index, unsigned flag)
 {
-	unsigned modelflag;
-
-	modelflag = per_cpu(cpu_modelflag, cpu);
 	*max = 0;
-	switch (per_cpu(cpu_model, cpu) >> 16) {
-	case X86_VENDOR_INTEL:
-		if ((cpu_intel_range[index].model & modelflag) &&
-		    (cpu_intel_range[index].flag & flag)) {
-			*min = cpu_intel_range[index].min;
-			*max = cpu_intel_range[index].max;
-		}
-		break;
-	case X86_VENDOR_AMD:
-		if ((cpu_amd_range[index].model & modelflag) &&
-		    (cpu_amd_range[index].flag & flag)) {
-			*min = cpu_amd_range[index].min;
-			*max = cpu_amd_range[index].max;
-		}
-		break;
+
+	if (cpu_reg_range[index].flag == flag) {
+		*min = cpu_reg_range[index].min;
+		*max = cpu_reg_range[index].max;
 	}
 
 	return *max;
@@ -434,7 +236,7 @@ static void print_msr(struct seq_file *seq, unsigned cpu, unsigned flag)
 	unsigned msr, msr_min, msr_max;
 	struct cpu_private *priv;
 	u32 low, high;
-	int i, range;
+	int i;
 
 	if (seq) {
 		priv = seq->private;
@@ -446,10 +248,8 @@ static void print_msr(struct seq_file *seq, unsigned cpu, unsigned flag)
 		}
 	}
 
-	range = get_cpu_range_count(cpu);
-
-	for (i = 0; i < range; i++) {
-		if (!get_cpu_range(cpu, &msr_min, &msr_max, i, flag))
+	for (i = 0; i < ARRAY_SIZE(cpu_reg_range); i++) {
+		if (!get_cpu_range(&msr_min, &msr_max, i, flag))
 			continue;
 
 		for (msr = msr_min; msr <= msr_max; msr++) {
@@ -557,8 +357,6 @@ static void print_dr(void *arg)
 		get_debugreg(dr, i);
 		seq_printf(seq, " dr%d\t: %016lx\n", i, dr);
 	}
-
-	seq_printf(seq, "\n MSR\t:\n");
 }
 
 static void print_apic(void *arg)
@@ -611,11 +409,9 @@ static int cpu_seq_show(struct seq_file *seq, void *v)
 		smp_call_function_single(priv->cpu, print_dt, seq, 1);
 		break;
 	case CPU_DEBUG:
-		if (priv->file == CPU_INDEX_BIT)
-			smp_call_function_single(priv->cpu, print_dr, seq, 1);
-		print_msr(seq, priv->cpu, cpu_base[priv->type].flag);
+		smp_call_function_single(priv->cpu, print_dr, seq, 1);
 		break;
-	case CPU_APIC:
+	case X86_FEATURE_APIC:
 		if (priv->file == CPU_INDEX_BIT)
 			smp_call_function_single(priv->cpu, print_apic, seq, 1);
 		print_msr(seq, priv->cpu, cpu_base[priv->type].flag);
@@ -694,7 +490,7 @@ static int write_cpu_register(struct cpu_private *priv, const char *buf)
 		return ret;
 
 	/* Supporting only MSRs */
-	if (priv->type < CPU_TSS_BIT)
+	if (cpu_base[priv->type].flag < CPU_STD_BASE)
 		return write_msr(priv, val);
 
 	return ret;
@@ -775,7 +571,7 @@ static int cpu_init_regfiles(unsigned cpu, unsigned int type, unsigned reg,
 	unsigned file;
 	int err = 0;
 
-	for (file = 0; file <  ARRAY_SIZE(cpu_file); file++) {
+	for (file = 0; file < ARRAY_SIZE(cpu_file); file++) {
 		err = cpu_create_file(cpu, type, reg, file, dentry);
 		if (err)
 			return err;
@@ -788,15 +584,12 @@ static int cpu_init_msr(unsigned cpu, unsigned type, struct dentry *dentry)
 {
 	struct dentry *cpu_dentry = NULL;
 	unsigned reg, reg_min, reg_max;
-	int i, range, err = 0;
+	int i, err = 0;
 	char reg_dir[12];
 	u32 low, high;
 
-	range = get_cpu_range_count(cpu);
-
-	for (i = 0; i < range; i++) {
-		if (!get_cpu_range(cpu, &reg_min, &reg_max, i,
-				   cpu_base[type].flag))
+	for (i = 0; i < ARRAY_SIZE(cpu_reg_range); i++) {
+		if (!get_cpu_range(&reg_min, &reg_max, i, cpu_base[type].flag))
 			continue;
 
 		for (reg = reg_min; reg <= reg_max; reg++) {
@@ -820,13 +613,12 @@ static int cpu_init_allreg(unsigned cpu, struct dentry *dentry)
 	unsigned type;
 	int err = 0;
 
-	for (type = 0; type <  ARRAY_SIZE(cpu_base) - 1; type++) {
+	for (type = 0; type < ARRAY_SIZE(cpu_base); type++) {
 		if (!is_typeflag_valid(cpu, cpu_base[type].flag))
 			continue;
 		cpu_dentry = debugfs_create_dir(cpu_base[type].name, dentry);
 		per_cpu(cpu_arr[type].dentry, cpu) = cpu_dentry;
-
-		if (type < CPU_TSS_BIT)
+		if (cpu_base[type].flag < CPU_STD_BASE)
 			err = cpu_init_msr(cpu, type, cpu_dentry);
 		else
 			err = cpu_create_file(cpu, type, 0, CPU_INDEX_BIT,
@@ -850,13 +642,13 @@ static int cpu_init_cpu(void)
 		cpui = &cpu_data(cpu);
 		if (!cpu_has(cpui, X86_FEATURE_MSR))
 			continue;
-		per_cpu(cpu_model, cpu) = ((cpui->x86_vendor << 16) |
-					   (cpui->x86 << 8) |
-					   (cpui->x86_model));
-		per_cpu(cpu_modelflag, cpu) = get_cpu_modelflag(cpu);
 
 		sprintf(cpu_dir, "cpu%d", cpu);
 		cpu_dentry = debugfs_create_dir(cpu_dir, cpu_debugfs_dir);
+		if (!cpu_dentry) {
+			pr_err("unable to create dir \"%s\"\n", cpu_dir);
+			return -EACCES;
+		}
 		err = cpu_init_allreg(cpu, cpu_dentry);
 
 		pr_info("cpu%d(%d) debug files %d\n",
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 5dac7bd..3a56724 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -61,20 +61,6 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 		c->x86_phys_bits = 36;
 
 	/*
-	 * c->x86_power is 8000_0007 edx. Bit 8 is TSC runs at constant rate
-	 * with P/T states and does not stop in deep C-states.
-	 *
-	 * It is also reliable across cores and sockets. (but not across
-	 * cabinets - we turn it off in that case explicitly.)
-	 */
-	if (c->x86_power & (1 << 8)) {
-		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
-		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
-		set_cpu_cap(c, X86_FEATURE_TSC_RELIABLE);
-		sched_clock_stable = 1;
-	}
-
-	/*
 	 * There is a known erratum on Pentium III and Core Solo
 	 * and Core Duo CPUs.
 	 * " Page with PAT set to WC while associated MTRR is UC
@@ -427,6 +413,85 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 
 	if (cpu_has(c, X86_FEATURE_VMX))
 		detect_vmx_virtcap(c);
+
+	/* Set cpufeatures for miscellaneous MSRs			*/
+	if (c->x86 == 6) {
+		/* Miscellaneous Features IA32_MISC_ENABLE		*/
+		set_cpu_cap(c, X86_FEATURE_MISC);
+
+		switch (c->x86_model) {
+		case 1:					/* Pentium Pro	*/
+			/* Hard Poweron configuration MSR_EBL_CR_POWERON*/
+			set_cpu_cap(c, X86_FEATURE_HARD_POWERON);
+			/* !Miscellaneous Features IA32_MISC_ENABLE	*/
+			clear_cpu_cap(c, X86_FEATURE_MISC);
+			break;
+
+		case 3: case 5:				/* Pentium II	*/
+		case 7: case 8: case 0xA: case 0xB:	/* Pentium III	*/
+			/* Hard Poweron configuration MSR_EBL_CR_POWERON*/
+			set_cpu_cap(c, X86_FEATURE_HARD_POWERON);
+			/* BBL_CR_* MSRs (Pentium II & III processors)	*/
+			set_cpu_cap(c, X86_FEATURE_CACHE);
+			/* BBL_CR_CTL* MSRs (Cache control MSRs)	*/ 
+			set_cpu_cap(c, X86_FEATURE_CACHE_CTL);
+			/* !Miscellaneous Features IA32_MISC_ENABLE	*/
+			clear_cpu_cap(c, X86_FEATURE_MISC);
+			break;
+
+		case 9:	case 0xD:			/* Pentium M	*/
+			/* Hard Poweron configuration MSR_EBL_CR_POWERON*/
+			set_cpu_cap(c, X86_FEATURE_HARD_POWERON);
+			/* BBL_CR_CTL* MSRs (Cache control MSRs)	*/ 
+			set_cpu_cap(c, X86_FEATURE_CACHE_CTL);
+			break;
+
+		case 0xE:				/* Core		*/
+		case 0xF: case 0x17:			/* Core 2	*/
+		case 0x1C:				/* ATOM		*/
+			/* Hard Poweron configuration MSR_EBL_CR_POWERON*/
+			set_cpu_cap(c, X86_FEATURE_HARD_POWERON);
+			/* BBL_CR_CTL* MSRs (Cache control MSRs)	*/ 
+			set_cpu_cap(c, X86_FEATURE_CACHE_CTL);
+			/* Scaleable bus speed MSR_FSB_FREQ		*/ 
+			set_cpu_cap(c, X86_FEATURE_FSB_FREQ);
+			break;
+
+		case 0x16:				/* Celeron Core	*/
+			/* Hard Poweron configuration MSR_EBL_CR_POWERON*/
+			set_cpu_cap(c, X86_FEATURE_HARD_POWERON);
+			break;
+
+		case 0x1D:				/* Xeon MP	*/
+			/* Hard Poweron configuration MSR_EBL_CR_POWERON*/
+			set_cpu_cap(c, X86_FEATURE_HARD_POWERON);
+			/*
+			 * Soft Poweron configuration MSR_EBC_SOFT_POWERON
+			 * Frequency configuration MSR_EBC_FREQUENCY_ID
+			 */
+			set_cpu_cap(c, X86_FEATURE_SOFT_POWERON);
+			break;
+		}
+	}
+	if (c->x86 == 0xF) {
+		/* Hard Poweron configuration MSR_EBL_CR_POWERON	*/
+		set_cpu_cap(c, X86_FEATURE_HARD_POWERON);
+		/*
+		 * Soft Poweron configuration MSR_EBC_SOFT_POWERON
+		 * Frequency configuration MSR_EBC_FREQUENCY_ID
+		 */
+		set_cpu_cap(c, X86_FEATURE_SOFT_POWERON);
+
+		/* Miscellaneous Features IA32_MISC_ENABLE		*/
+		set_cpu_cap(c, X86_FEATURE_MISC);
+
+		switch (c->x86_model) {
+		case 3: case 4: case 6:
+			/* Platform Feature MSR_PLATFORM_BRV		*/
+			set_cpu_cap(c, X86_FEATURE_PLATFORM);
+			break;
+		}
+	}
 }
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/cpu/powerflags.c b/arch/x86/kernel/cpu/powerflags.c
deleted file mode 100644
index 5abbea2..0000000
--- a/arch/x86/kernel/cpu/powerflags.c
+++ /dev/null
@@ -1,20 +0,0 @@
-/*
- * Strings for the various x86 power flags
- *
- * This file must not contain any executable code.
- */
-
-#include <asm/cpufeature.h>
-
-const char *const x86_power_flags[32] = {
-	"ts",	/* temperature sensor */
-	"fid",  /* frequency id control */
-	"vid",  /* voltage id control */
-	"ttp",  /* thermal trip */
-	"tm",
-	"stc",
-	"100mhzsteps",
-	"hwpstate",
-	"",	/* tsc invariant mapped to constant_tsc */
-		/* nothing */
-};
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index f93047f..523bf39 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -121,20 +121,6 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 	seq_printf(m, "address sizes\t: %u bits physical, %u bits virtual\n",
 		   c->x86_phys_bits, c->x86_virt_bits);
 #endif
-
-	seq_printf(m, "power management:");
-	for (i = 0; i < 32; i++) {
-		if (c->x86_power & (1 << i)) {
-			if (i < ARRAY_SIZE(x86_power_flags) &&
-			    x86_power_flags[i])
-				seq_printf(m, "%s%s",
-					   x86_power_flags[i][0]?" ":"",
-					   x86_power_flags[i]);
-			else
-				seq_printf(m, " [%d]", i);
-		}
-	}
-
 	seq_printf(m, "\n\n");
 
 	return 0;
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 453b579..ec9e5e2 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -95,6 +95,9 @@ static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
 		       "supported\n", cpu, c->x86);
 		return -1;
 	}
+	/* setting microcode update feature to friendly access of UCODE MSRs */
+	set_cpu_cap(c, X86_FEATURE_MICROCODE);
+
 	rdmsr(MSR_AMD64_PATCH_LEVEL, csig->rev, dummy);
 	printk(KERN_INFO "microcode: CPU%d: patch_level=0x%x\n", cpu, csig->rev);
 	return 0;
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index 149b9ec..2fcaa58 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -168,6 +168,9 @@ static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
 		return -1;
 	}
 
+	/* setting microcode update feature to friendly access of UCODE MSRs */
+	set_cpu_cap(c, X86_FEATURE_MICROCODE);
+
 	csig->sig = cpuid_eax(0x00000001);
 
 	if ((c->x86_model >= 5) || (c->x86 > 6)) {


