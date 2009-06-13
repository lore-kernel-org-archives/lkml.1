Return-Path: <linux-kernel-owner+w=401wt.eu-S932482AbZFMQiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482AbZFMQiO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 12:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763191AbZFMQh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 12:37:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:34484 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759365AbZFMQhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 12:37:54 -0400
Subject: [RFC][GIT PULL][PATCH 0/10 -tip] cpu_debug patches 20090613
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@kernel.org>,
       x86 maintainers <x86@kernel.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Dave Jones <davej@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>
Content-Type: text/plain
Date: Sat, 13 Jun 2009 21:57:16 +0530
Message-Id: <1244910436.11733.14.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By adding these patches, cpu_debug will support :

1. Standard Registers
2. Control Registers
3. Debug Registers
4. Descriptor Tables
5. APIC Registers
6. Model specific Register (MSRs)
7. PCI configuration registers (for AMD)
8. Basic cpuinfo
9. CPUID Functions

Please let me know how we can improve it and add more features so it
becomes more useful.

For example on AMD 64 Laptop :

1. Standard Registers
---------------------

a. access complete state

# cat /sys/kernel/debug/x86/cpu/cpu0/tss/state
 RAX	: ffffffff81789fe8
 RBX	: 000000000007e000
 RCX	: ffffffff8179437f
 RDX	: 0000000000000000
 RSI	: 0000000000000000
 RDI	: 81798e0000104136
 RBP	: 000000000000001f
 ESP	: 0000000000000000
 R08	: 00000000000932d0
 R09	: 0000000000000000
 R10	: ffffffff8179429a
 R11	: ffffffff81789fa8
 R12	: 00000000afc723ac
 R13	: 00000000018e4f80
 R14	: ffffffff817cee80
 R15	: ffffffff81789f88
 CS	:             0010
 DS	:             0018
 SS	:             0000
 ES	:             0018
 FS	:             0000
 GS	:             0000
 EFLAGS	: 0000000000000000
 EIP	: 0000000000000000

2. Control Registers
--------------------

a. access complete state

# cat /sys/kernel/debug/x86/cpu/cpu0/cr/state
 cr0	: 000000008005003b
 cr2	: 0000000000429040
 cr3	: 0000000001001000
 cr4	: 00000000000006b0
 cr8	: 0000000000000000

3. Debug Registers
------------------

a. access complete state

# cat /sys/kernel/debug/x86/cpu/cpu0/debug/state
 dr0	: 0000000000000000
 dr1	: 0000000000000000
 dr2	: 0000000000000000
 dr3	: 0000000000000000
 dr6	: 00000000ffff0ff0
 dr7	: 0000000000000400

 MSR	:
 000001d9: 00000000_00000000

4. Descriptor Tables
--------------------

a. access complete state

# cat /sys/kernel/debug/x86/cpu/cpu0/dt/state
 IDT	: ffffffff81820fff
 GDT	: ffff88002802607f
 LDT	: ffffffff810b0000
 TR	: 0000000000000040

5. APIC Registers
-----------------

a. access complete state

# cat /sys/kernel/debug/x86/cpu/cpu0/apic/state
 LAPIC	:
 ID		: 00000000
 LVR		: 80050010
 TASKPRI	: 00000000
 ARBPRI		: 00000000
 PROCPRI	: 00000000
 LDR		: 01000000
 DFR		: ffffffff
 SPIV		: 000001ff
 ISR		: 00000000
 ESR		: 00000004
 ICR		: 000208fd
 ICR2		: 02000000
 LVTT		: 000300ef
 LVTTHMR	: 00010000
 LVTPC		: 00000400
 LVT0		: 00010700
 LVT1		: 00000400
 LVTERR		: 000000fe
 TMICT		: ffffffff
 TMCCT		: 8d52660d
 TDCR		: 00000003
 EFEAT		: 00040007
 ECTRL		: 00000000
 EILVT0		: 00010000
 EILVT1		: 00010000
 EILVT2		: 00010000
 EILVT3		: 00010000

 MSR	:
 0000001b: 00000000_fee00900

b. access individual APIC register :

# cat /sys/kernel/debug/x86/cpu/cpu0/apic/APIC_EFEAT/value 
0x40007

# cat /sys/kernel/debug/x86/cpu/cpu0/apic/MSR_1b/value
0xfee00900

6. Model specific Register (MSRs)
---------------------------------

a. access complete state, say performance monitor counter (pmc)

# cat /sys/kernel/debug/x86/cpu/cpu0/pmc/state
 MSR	:
 c0010000: 00000000_00430076
 c0010001: 00000000_3d179f6b
 c0010002: 00000000_7993feae
 c0010003: 00000000_f69637fe
 c0010004: 0000000f_4c47618a
 c0010005: 0000f0db_ffc3e9c3
 c0010006: 0000834f_15f5610e
 c0010007: 00006ade_595d2c95

b. access individual MSR :

# cat /sys/kernel/debug/x86/cpu/cpu0/pmc/MSR_c0010006/value 
0x834f15f5610e

c. write individual MSR :
# echo 2 >  /sys/kernel/debug/x86/cpu/cpu0/pmc/MSR_c0010006/value

# cat /sys/kernel/debug/x86/cpu/cpu0/pmc/MSR_c0010006/value 
0x2

7. PCI configuration registers (for AMD)
----------------------------------------

a. access complete state

 PCI configuration regsiters :
 function : 0
 000	: 13001022
 004	: 00100000
 008	: 06000040
 00c	: 00800000
 034	: 00000080
 040	: 00000000
 044	: 00000000
 048	: 00000000
 04c	: 00000000
 050	: 00000000
 054	: 00000000
 058	: 00000000
 05c	: 00000000
 060	: 00000000
 064	: 00000000
 068	: 012e4820
 06c	: 00000030
 080	: 21010008
 084	: 11112020
 088	: 1ff50a60
 08c	: 00000003
 090	: 001005b6
 094	: 00000000
 098	: 00000007
 0a0	: 00000000
 0a4	: 00000000
 0a8	: 00000000
 0ac	: 00000000
 0b0	: 00000000
 0b4	: 00000000
 0b8	: 00000000
 0c0	: 00000000
 0c4	: 00000000
 0c8	: 00000000
 0cc	: 00000000
 0d0	: 00000000
 0d4	: 00000000
 0d8	: 00000000
 0e0	: 00000000
 0e4	: 00000000
 0e8	: 00000000
 0ec	: 00000000
 0f0	: 00000000
 0f4	: 00000000
 0f8	: 00000000
 110	: 00000000
 114	: 00000000
 118	: 00000000
 11c	: 00000000
 120	: 00000000
 124	: 00000000
 128	: 00000000
 12c	: 00000000
 130	: 000000c1
 134	: 00000000
 138	: 00000000
 13c	: 00000000
 140	: 00000000
 144	: 00000000
 148	: 00000000
 14c	: 00000000
 150	: 00070000
 164	: 00000000
 168	: 00000000
 16c	: 0074e026
 170	: 07c00109
 174	: 00000000
 178	: 00000000
 17c	: 00000000
 180	: 00000000
 184	: 00000000
 188	: 00000000
 18c	: 00000000
 1a0	: 00000000
 1a4	: 00002824
 1d0	: 00000400
 1d4	: 00000051

 function : 1
 000	: 13011022
 004	: 00000000
 008	: 06000000
 00c	: 00800000
 034	: 00000000
 040	: 00000003
 044	: 013f0000
 048	: 00000000
 04c	: 00000000
 050	: 00000000
 054	: 00000000
 058	: 00000000
 05c	: 00000000
 060	: 00000000
 064	: 00000000
 068	: 00000000
 06c	: 00000000
 070	: 00000000
 074	: 00000000
 078	: 00000000
 07c	: 00000000
 080	: 00000000
 084	: 00000000
 088	: 00000a03
 08c	: 00000b00
 090	: 00c00003
 094	: 00cfff80
 098	: 00d00003
 09c	: 00d21f00
 0a0	: 00d22003
 0a4	: 00d22f80
 0a8	: 00d23003
 0ac	: 00dfff00
 0b0	: 00e00003
 0b4	: 00e3ff80
 0b8	: 00e40003
 0bc	: 00ffff00
 0c0	: 00000013
 0c4	: 00fff000
 0c8	: 00000000
 0cc	: 00000000
 0d0	: 00000000
 0d4	: 00000000
 0d8	: 00000000
 0dc	: 00000000
 0e0	: 00000000
 0e4	: 00000000
 0e8	: 00000000
 0ec	: 00000000
 0f0	: c0004001
 0f4	: 00000000
 110	: 00000000
 114	: 00000000
 120	: 00000000
 124	: 00000000
 140	: 00000000
 144	: 00000000
 148	: 00000000
 14c	: 00000000
 150	: 00000000
 154	: 00000000
 158	: 00000000
 15c	: 00000000
 160	: 00000000
 164	: 00000000
 168	: 00000000
 16c	: 00000000
 170	: 00000000
 174	: 00000000
 178	: 00000000
 17c	: 00000000
 180	: e0000011
 184	: 00000000

 function : 2
 000	: 13021022
 004	: 00000000
 008	: 06000000
 00c	: 00800000
 034	: 00000000
 040	: 00000001
 044	: 00000101
 048	: 00000000
 04c	: 00000000
 050	: 00000000
 054	: 00000000
 058	: 00000000
 05c	: 00000000
 060	: 00783ee0
 064	: 00000000
 068	: 00000000
 06c	: 00000000
 070	: 00000000
 074	: 00000000
 078	: 00000036
 07c	: 00000000
 080	: 00000005
 084	: 00000000
 088	: 7d7dfb35
 08c	: 0022173f
 090	: 00600020
 094	: 7e51806b
 098	: 80000013
 09c	: 0000003a
 0a0	: 000000a8
 0a4	: 00000000
 10c	: 00000000
 110	: 00000584
 114	: 00000000
 118	: 1441b4a4
 11c	: 00402064
 140	: 00000001
 144	: 00000101
 148	: 00000000
 14c	: 00000000
 150	: 00000000
 154	: 00000000
 158	: 00000000
 15c	: 00000000
 160	: 00783ee0
 164	: 00000000
 168	: 00000000
 16c	: 00000000
 178	: 00000036
 17c	: 00000000
 180	: 00000005
 184	: 00000000
 188	: 4d7dfb35
 18c	: 0022173f
 190	: 00600020
 194	: 7e51806b
 198	: 80000013
 19c	: 0000003c
 1a0	: 00000008
 1b0	: 00000000

 function : 3
 000	: 13031022
 004	: 00100000
 008	: 06000000
 00c	: 00800000
 034	: 000000f0
 040	: 00000100
 044	: 0a100040
 048	: 00000000
 04c	: 00000000
 050	: 00000000
 054	: 00000000
 058	: 00000000
 05c	: 00000000
 060	: 00000000
 064	: 1a600000
 068	: 100000c0
 06c	: 08000808
 070	: 00000000
 074	: 30000876
 078	: 00000000
 07c	: 85001101
 080	: ff00f300
 084	: 80e600ee
 088	: 00000000
 08c	: 00000000
 090	: 00000000
 094	: 00000000
 098	: 00000000
 09c	: 00000000
 0a0	: 800402bc
 0a4	: 3b201800
 0b0	: 00000000
 0d4	: 0005024d
 0d8	: 03000025
 0dc	: 00034240
 0e4	: 00000520
 0e8	: 00001f81
 0f0	: 0010000f
 0f4	: 00000000
 0f8	: 00000000
 0fc	: 00200f31
 140	: 00000000
 144	: 00000000
 148	: 00000000
 14c	: 00000000
 150	: 00000000
 154	: 00000000
 158	: 00000000
 15c	: 00000000
 160	: 00000000
 164	: 00000000
 168	: 00000000
 16c	: 00000000
 170	: 00000000
 174	: 00000000
 178	: 00000000
 17c	: 00000000
 180	: 00400002
 188	: 1b000438
 190	: 00000000
 1a0	: 00000000
 1cc	: 00000000
 1e4	: 80000000
 1e8	: 00000000
 1ec	: 00000000
 1f0	: 000f0500
 1fc	: 00000000

 function : 4
 000	: 13041022
 004	: 00000000
 008	: 06000000
 00c	: 00800000
 034	: 00000000
 080	: 00000000
 084	: 00000000
 088	: 00000000
 08c	: 00000000
 090	: 00000000
 094	: 00000000
 098	: 00000000
 09c	: 00000000
 0a0	: 00000000
 0a4	: 00000000
 0a8	: 00000000
 0ac	: 00000000
 0b0	: 00000000
 0b4	: 00000000
 0b8	: 00000000
 0bc	: 00000000
 0c0	: 00000000
 0c4	: 00000000
 0c8	: 00000000
 0cc	: 00000000
 0d0	: 00000000
 0d4	: 00000000
 0d8	: 00000000
 0dc	: 00000000
 0e0	: 00000000
 0e4	: 00000000
 0e8	: 00000000
 0ec	: 00000000
 0f0	: 00000000
 0f4	: 00000000
 0f8	: 00000000
 170	: 00000006
 174	: 0a3cdfe6
 180	: 800000c4
 184	: 00006400
 188	: 00000000
 18c	: 00000000
 190	: 00000000
 194	: 00000000
 198	: 00000000
 19c	: 00000000
 1c4	: 00000000
 1e0	: 00000000
 1e4	: 00000000
 1e8	: 00000000
 1ec	: 00000000
 1f0	: 00000000

b. access individual PCI configuration :

# cat /sys/kernel/debug/x86/cpu/cpu0/pci/PCI0_000/value 
0x13001022

# cat /sys/kernel/debug/x86/cpu/cpu0/therm/PCI3_0a4/value 
0x3c001800

8. Basic cpuinfo
----------------

a. access complete state

# cat /sys/kernel/debug/x86/cpu/cpu0/cpuinfo/state 
 CPUINFO	:
 processor		: 0
 family			: 17
 vendor			: 2
 model			: 3
 mask			: 1
 TLB size		: 1024 4K pages
 virtual bits		: 48
 physical bits		: 40
 extended cpuid level	: 8000001a (8000001a)
 cpuid level		: 1
 flags			: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm 3dnowext 3dnow constant_tsc rep_good nonstop_tsc pni cx16 lahf_lm cmp_legacy svm extapic cr8_legacy 3dnowprefetch osvw skinit
 vendor id		: AuthenticAMD
 model id		: AMD Turion(tm) X2 Ultra Dual-Core Mobile ZM-80
 cache size		: 1024 KB
 cache alignment	: 64
 power management	: ts ttp tm stc 100mhzsteps hwpstate
 loops per jiffy	: 2098811
 bogomips		: 4197.62
 max cores		: 2
 apic id		: 0
 intial apic id		: 0
 clflush size		: 64
 cpu cores		: 2
 physical id		: 0
 core id		: 0
 cpu index		: 0
 hyper vendor		: 0

9. CPUID Functions
------------------

a. access complete state

# cat /sys/kernel/debug/x86/cpu/cpu0/cpuid/state
 CPUID	:
              eax       ebx       ecx       edx
 00000000  00000001  68747541  444d4163  69746e65
 00000001  00200f31  00020800  00002001  178bfbff
 80000000  8000001a  68747541  444d4163  69746e65
 80000001  00200f31  20000500  0000131f  ebd3fbff
 80000002  20444d41  69727554  74286e6f  5820296d
 80000003  6c552032  20617274  6c617544  726f432d
 80000004  6f4d2065  656c6962  2d4d5a20  00003038
 80000005  ff08ff08  ff20ff20  40020140  40020140
 80000006  00000000  42004200  04008140  00000000
 80000007  00000000  00000000  00000000  000001f9
 80000008  00003028  00000000  00001001  00000000
 80000009  00000000  00000000  00000000  00000000
 8000000a  00000001  00000040  00000000  0000000e
 8000000b  00000000  00000000  00000000  00000000
 8000000c  00000000  00000000  00000000  00000000
 8000000d  00000000  00000000  00000000  00000000
 8000000e  00000000  00000000  00000000  00000000
 8000000f  00000000  00000000  00000000  00000000
 80000010  00000000  00000000  00000000  00000000
 80000011  00000000  00000000  00000000  00000000
 80000012  00000000  00000000  00000000  00000000
 80000013  00000000  00000000  00000000  00000000
 80000014  00000000  00000000  00000000  00000000
 80000015  00000000  00000000  00000000  00000000
 80000016  00000000  00000000  00000000  00000000
 80000017  00000000  00000000  00000000  00000000
 80000018  00000000  00000000  00000000  00000000
 80000019  00000000  00000000  00000000  00000000
 8000001a  00000000  00000000  00000000  00000000

The following changes since commit 50149b2db7be15514079089d0c4efa4c7a2676bb:
  Ingo Molnar (1):
        Merge branch 'linus'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git master

Jaswinder Singh Rajput (10):
      x86: cpu_debug update Kconfig entry
      x86: cpu_debug.c remove some not required header files
      x86: cpu_debug.c use a WARN_ONCE() instead of a pr_err()
      x86: cpu_debug make room to support more categories
      x86: cpu_debug update MSR list to support new architectures
      x86: cpu_debug make room for more cpu registers
      x86: cpu_debug support APIC_register_name with directory structure
      x86: cpu_debug display PCI configuration registers for AMD
      x86: cpu_debug display cpuid functions
      x86: cpu_debug display basic cpuinfo

 arch/x86/Kconfig                 |   12 +-
 arch/x86/include/asm/cpu_debug.h |  125 ++++----
 arch/x86/kernel/cpu/cpu_debug.c  |  681 +++++++++++++++++++++++++++++++++-----
 3 files changed, 666 insertions(+), 152 deletions(-)

Complete diff :

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0c2321d..e5e26b3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -994,9 +994,19 @@ config X86_CPUID
 
 config X86_CPU_DEBUG
 	tristate "/sys/kernel/debug/x86/cpu/* - CPU Debug support"
+	select DEBUG_FS
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
index d96c1ee..b75758e 100644
--- a/arch/x86/include/asm/cpu_debug.h
+++ b/arch/x86/include/asm/cpu_debug.h
@@ -10,91 +10,80 @@
 /* Register flags */
 enum cpu_debug_bit {
 /* Model Specific Registers (MSRs)					*/
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
+	CPU_MC,					/* Machine Check	*/
+	CPU_MONITOR,				/* Monitor		*/
+	CPU_TIME,				/* Time			*/
+	CPU_PMC,				/* Performance Monitor	*/
+	CPU_PLATFORM,				/* Platform		*/
+	CPU_APIC,				/* APIC			*/
+	CPU_POWERON,				/* Power-on		*/
+	CPU_CONTROL,				/* Control		*/
+	CPU_FEATURES,				/* Features control	*/
+	CPU_LBRANCH,				/* Last Branch		*/
+	CPU_BIOS,				/* BIOS			*/
+	CPU_FREQ,				/* Frequency		*/
+	CPU_MTRR,				/* MTRR			*/
+	CPU_PERF,				/* Performance		*/
+	CPU_CACHE,				/* Cache		*/
+	CPU_SYSENTER,				/* Sysenter		*/
+	CPU_THERM,				/* Thermal		*/
+	CPU_MISC,				/* Miscellaneous	*/
+	CPU_DEBUG,				/* Debug		*/
+	CPU_PAT,				/* PAT			*/
+	CPU_VMX,				/* VMX			*/
+	CPU_CALL,				/* System Call		*/
+	CPU_BASE,				/* BASE Address		*/
+	CPU_VER,				/* Version ID		*/
+	CPU_CONF,				/* Configuration	*/
+	CPU_SMM,				/* System mgmt mode	*/
+	CPU_POWER,				/* Power mgmt		*/
+	CPU_PNAME,				/* Processor name	*/
+	CPU_IBS,				/* IBS			*/
+	CPU_SVM,				/*Secure Virtual Machine*/
+	CPU_OSVM,				/* OS-Visible Workaround*/
+	CPU_NB,					/* North Bridge		*/
+	CPU_DRAM,				/* DRAM			*/
+	CPU_MMIO,				/* Memory based IO	*/
+	CPU_DISPLAY,				/* Display/VGA		*/
+	CPU_LINK,				/* HyperTransport	*/
 /* Standard Registers							*/
-	CPU_TSS_BIT,				/* Task Stack Segment	*/
-	CPU_CR_BIT,				/* Control Registers	*/
-	CPU_DT_BIT,				/* Descriptor Table	*/
+	CPU_TSS,				/* Task Stack Segment	*/
+	CPU_CR,					/* Control Registers	*/
+	CPU_DT,					/* Descriptor Table	*/
+	CPU_CPUID,				/* CPUID		*/
+	CPU_CPUINFO,				/* struct cpuinfo_x86	*/
+	CPU_PCI,				/* PCI configuration	*/
 /* End of Registers flags						*/
-	CPU_REG_ALL_BIT,			/* Select all Registers	*/
+	CPU_REG_MAX,				/* Max Registers flags	*/
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
-
 /* Register file flags */
 enum cpu_file_bit {
-	CPU_INDEX_BIT,				/* index		*/
-	CPU_VALUE_BIT,				/* value		*/
+	CPU_INDEX,				/* index		*/
+	CPU_VALUE,				/* value		*/
+};
+
+/* Register category flags */
+enum cpu_cat_bit {
+	CPU_REG_STD,				/* Standard registers	*/
+	CPU_REG_MSR,				/* MSRs			*/
+	CPU_REG_APIC,				/* APIC registers	*/
+	CPU_REG_PCI,				/* PCI conf registers	*/
 };
 
-#define	CPU_FILE_VALUE		(1 << CPU_VALUE_BIT)
+#define MAX_CPU_FILES		768		/* Max CPU debug files	*/
+#define MAX_CPU_PCI		5		/* AMD supports func 0-4*/
 
-#define MAX_CPU_FILES		512
+#define CPUID_MASK		0xffff0000
 
 struct cpu_private {
 	unsigned		cpu;
 	unsigned		type;
 	unsigned		reg;
 	unsigned		file;
+	unsigned		cat;
 };
 
 struct cpu_debug_base {
diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
index 6b2a52d..993a5bc 100644
--- a/arch/x86/kernel/cpu/cpu_debug.c
+++ b/arch/x86/kernel/cpu/cpu_debug.c
@@ -6,32 +6,34 @@
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
 #include <linux/init.h>
 #include <linux/slab.h>
+#include <linux/pci.h>
 #include <linux/smp.h>
 
 #include <asm/cpu_debug.h>
 #include <asm/paravirt.h>
 #include <asm/system.h>
-#include <asm/traps.h>
 #include <asm/apic.h>
 #include <asm/desc.h>
 
-static DEFINE_PER_CPU(struct cpu_cpuX_base, cpu_arr[CPU_REG_ALL_BIT]);
+#ifdef MODULE
+#include "capflags.c"
+#include "powerflags.c"
+#endif
+
+static DEFINE_PER_CPU(struct cpu_cpuX_base, cpu_arr[CPU_REG_MAX]);
 static DEFINE_PER_CPU(struct cpu_private *, priv_arr[MAX_CPU_FILES]);
+static DEFINE_PER_CPU(struct pci_dev *, pci_arr[MAX_CPU_PCI]);
 static DEFINE_PER_CPU(int, cpu_priv_count);
 
 static DEFINE_MUTEX(cpu_debug_lock);
@@ -65,21 +67,63 @@ static struct cpu_debug_base cpu_base[] = {
 	{ "ver",	CPU_VER,	0	},
 	{ "conf",	CPU_CONF,	0	},
 	{ "smm",	CPU_SMM,	0	},
+	{ "power",	CPU_POWER,	0	},
+	{ "pname",	CPU_PNAME,	0	},
+	{ "ibs",	CPU_IBS,	0	},
 	{ "svm",	CPU_SVM,	0	},
 	{ "osvm",	CPU_OSVM,	0	},
+	{ "nbridge",	CPU_NB,		0	},
+	{ "dram",	CPU_DRAM,	0	},
+	{ "mmio",	CPU_MMIO,	0	},
+	{ "display",	CPU_DISPLAY,	0	},
+	{ "link",	CPU_LINK,	0	},
 	{ "tss",	CPU_TSS,	0	},
 	{ "cr",		CPU_CR,		0	},
 	{ "dt",		CPU_DT,		0	},
+	{ "cpuid",	CPU_CPUID,	0	},
+	{ "cpuinfo",	CPU_CPUINFO,	0	},
+	{ "pci",	CPU_PCI,	0	},
 	{ "registers",	CPU_REG_ALL,	0	},
 };
 
+#ifdef CONFIG_X86_LOCAL_APIC
+static struct cpu_debug_base cpu_apic[] = {
+	{ "ID",		APIC_ID,	0	},
+	{ "LVR",	APIC_LVR,	0	},
+	{ "TASKPRI",	APIC_TASKPRI,	0	},
+	{ "ARBPRI",	APIC_ARBPRI,	0	},
+	{ "PROCPRI",	APIC_PROCPRI,	0	},
+	{ "LDR",	APIC_LDR,	0	},
+	{ "DFR",	APIC_DFR,	0	},
+	{ "SPIV",	APIC_SPIV,	0	},
+	{ "ISR",	APIC_ISR,	0	},
+	{ "ESR",	APIC_ESR,	0	},
+	{ "ICR",	APIC_ICR,	0	},
+	{ "ICR2",	APIC_ICR2,	0	},
+	{ "LVTT",	APIC_LVTT,	0	},
+	{ "LVTTHMR",	APIC_LVTTHMR,	0	},
+	{ "LVTPC",	APIC_LVTPC,	0	},
+	{ "LVT0",	APIC_LVT0,	0	},
+	{ "LVT1",	APIC_LVT1,	0	},
+	{ "LVTERR",	APIC_LVTERR,	0	},
+	{ "TMICT",	APIC_TMICT,	0	},
+	{ "TMCCT",	APIC_TMCCT,	0	},
+	{ "TDCR",	APIC_TDCR,	0	},
+};
+
+static struct cpu_debug_base cpu_xapic[] = {
+	{ "EFEAT",	APIC_EFEAT,	0	},
+	{ "ECTRL",	APIC_ECTRL,	0	},
+};
+#endif
+
 static struct cpu_file_base cpu_file[] = {
-	{ "index",	CPU_REG_ALL,	0	},
+	{ "state",	CPU_REG_ALL,	0	},
 	{ "value",	CPU_REG_ALL,	1	},
 };
 
 /* CPU Registers Range */
-static struct cpu_debug_range cpu_reg_range[] = {
+static struct cpu_debug_range cpu_msr_range[] = {
 	{ 0x00000000, 0x00000001, CPU_MC,	},
 	{ 0x00000006, 0x00000007, CPU_MONITOR,	},
 	{ 0x00000010, 0x00000010, CPU_TIME,	},
@@ -95,6 +139,7 @@ static struct cpu_debug_range cpu_reg_range[] = {
 	{ 0x00000088, 0x0000008A, CPU_CACHE,	},
 	{ 0x0000008B, 0x0000008B, CPU_BIOS,	},
 	{ 0x0000009B, 0x0000009B, CPU_MONITOR,	},
+	{ 0x000000A0, 0x000000A1, CPU_SMM,	},
 	{ 0x000000C1, 0x000000C4, CPU_PMC,	},
 	{ 0x000000CD, 0x000000CD, CPU_FREQ,	},
 	{ 0x000000E7, 0x000000E8, CPU_PERF,	},
@@ -103,40 +148,49 @@ static struct cpu_debug_range cpu_reg_range[] = {
 	{ 0x00000116, 0x0000011E, CPU_CACHE,	},
 	{ 0x00000174, 0x00000176, CPU_SYSENTER,	},
 	{ 0x00000179, 0x0000017B, CPU_MC,	},
+	{ 0x00000180, 0x00000185, CPU_MC,	},
 	{ 0x00000186, 0x00000189, CPU_PMC,	},
 	{ 0x00000198, 0x00000199, CPU_PERF,	},
 	{ 0x0000019A, 0x0000019A, CPU_TIME,	},
 	{ 0x0000019B, 0x0000019D, CPU_THERM,	},
 	{ 0x000001A0, 0x000001A0, CPU_MISC,	},
-	{ 0x000001C9, 0x000001C9, CPU_LBRANCH,	},
+	{ 0x000001A1, 0x000001A1, CPU_PLATFORM,	},
+	{ 0x000001A2, 0x000001A2, CPU_THERM,	},
+	{ 0x000001A6, 0x000001A6, CPU_PMC,	},
+	{ 0x000001AD, 0x000001AD, CPU_FREQ,	},
+	{ 0x000001C8, 0x000001C9, CPU_LBRANCH,	},
 	{ 0x000001D7, 0x000001D8, CPU_LBRANCH,	},
 	{ 0x000001D9, 0x000001D9, CPU_DEBUG,	},
 	{ 0x000001DA, 0x000001E0, CPU_LBRANCH,	},
+	{ 0x000001F2, 0x000001F3, CPU_SMM,	},
 
 	{ 0x00000200, 0x0000020F, CPU_MTRR,	},
 	{ 0x00000250, 0x00000250, CPU_MTRR,	},
 	{ 0x00000258, 0x00000259, CPU_MTRR,	},
 	{ 0x00000268, 0x0000026F, CPU_MTRR,	},
 	{ 0x00000277, 0x00000277, CPU_PAT,	},
+	{ 0x00000280, 0x00000288, CPU_MC,	},
 	{ 0x000002FF, 0x000002FF, CPU_MTRR,	},
 
 	{ 0x00000300, 0x00000311, CPU_PMC,	},
 	{ 0x00000345, 0x00000345, CPU_PMC,	},
 	{ 0x00000360, 0x00000371, CPU_PMC,	},
-	{ 0x0000038D, 0x00000390, CPU_PMC,	},
+	{ 0x0000038D, 0x00000396, CPU_PMC,	},
 	{ 0x000003A0, 0x000003BE, CPU_PMC,	},
 	{ 0x000003C0, 0x000003CD, CPU_PMC,	},
 	{ 0x000003E0, 0x000003E1, CPU_PMC,	},
-	{ 0x000003F0, 0x000003F2, CPU_PMC,	},
+	{ 0x000003F0, 0x000003FD, CPU_PMC,	},
 
-	{ 0x00000400, 0x00000417, CPU_MC,	},
+	{ 0x00000400, 0x00000421, CPU_MC,	},
 	{ 0x00000480, 0x0000048B, CPU_VMX,	},
 
 	{ 0x00000600, 0x00000600, CPU_DEBUG,	},
 	{ 0x00000680, 0x0000068F, CPU_LBRANCH,	},
 	{ 0x000006C0, 0x000006CF, CPU_LBRANCH,	},
 
-	{ 0x000107CC, 0x000107D3, CPU_PMC,	},
+	{ 0x00000800, 0x0000083F, CPU_APIC,	},
+
+	{ 0x000107CC, 0x000107D8, CPU_PMC,	},
 
 	{ 0xC0000080, 0xC0000080, CPU_FEATURES,	},
 	{ 0xC0000081, 0xC0000084, CPU_CALL,	},
@@ -149,20 +203,120 @@ static struct cpu_debug_range cpu_reg_range[] = {
 	{ 0xC0010016, 0xC001001A, CPU_MTRR,	},
 	{ 0xC001001D, 0xC001001D, CPU_MTRR,	},
 	{ 0xC001001F, 0xC001001F, CPU_CONF,	},
-	{ 0xC0010030, 0xC0010035, CPU_BIOS,	},
-	{ 0xC0010044, 0xC0010048, CPU_MC,	},
+	{ 0xC0010022, 0xC0010022, CPU_MC,	},
+	{ 0xC0010030, 0xC0010035, CPU_PNAME,	},
+	{ 0xC0010044, 0xC0010049, CPU_MC,	},
 	{ 0xC0010050, 0xC0010056, CPU_SMM,	},
 	{ 0xC0010058, 0xC0010058, CPU_CONF,	},
 	{ 0xC0010060, 0xC0010060, CPU_CACHE,	},
-	{ 0xC0010061, 0xC0010068, CPU_SMM,	},
-	{ 0xC0010069, 0xC001006B, CPU_SMM,	},
+	{ 0xC0010061, 0xC001006B, CPU_POWER,	},
 	{ 0xC0010070, 0xC0010071, CPU_SMM,	},
+	{ 0xC0010074, 0xC0010074, CPU_TIME,	},
 	{ 0xC0010111, 0xC0010113, CPU_SMM,	},
 	{ 0xC0010114, 0xC0010118, CPU_SVM,	},
 	{ 0xC0010140, 0xC0010141, CPU_OSVM,	},
+
+	{ 0xC0011004, 0xC0011005, CPU_FEATURES,	},
 	{ 0xC0011022, 0xC0011023, CPU_CONF,	},
+	{ 0xC001102A, 0xC001102A, CPU_CONF,	},
+	{ 0xC0011030, 0xC001103A, CPU_IBS,	},
+};
+
+/* PCI-defined configurations registers		*/
+
+/* Function 0 Link Configuration Registers	*/
+static struct cpu_debug_range cpu_amd_pci0[] = {
+	{ 0x000,	0x00C,	CPU_PCI		},
+	{ 0x034,	0x034,	CPU_PCI		},
+	{ 0x040,	0x06C,	CPU_LINK	},
+	{ 0x080,	0x098,	CPU_LINK	},
+	{ 0x0A0,	0x0B8,	CPU_LINK	},
+	{ 0x0C0,	0x0D8,	CPU_LINK	},
+	{ 0x0E0,	0x0F8,	CPU_LINK	},
+	{ 0x110,	0x150,	CPU_LINK	},
+	{ 0x164,	0x18C,	CPU_LINK	},
+	{ 0x1A0,	0x1A0,	CPU_LINK	},
+	{ 0x1A4,	0x1A4,	CPU_DISPLAY	},
+	{ 0x1D0,	0x1D4,	CPU_DISPLAY	},
+};
+
+/* Function 1 Address Map Registers		*/
+static struct cpu_debug_range cpu_amd_pci1[] = {
+	{ 0x000,	0x00C,	CPU_PCI		},
+	{ 0x034,	0x034,	CPU_PCI		},
+	{ 0x040,	0x07C,	CPU_DRAM	},
+	{ 0x080,	0x0BC,	CPU_MMIO	},
+	{ 0x0C0,	0x0DC,	CPU_PCI		},
+	{ 0x0E0,	0x0EC,	CPU_CONF	},
+	{ 0x0F0,	0x0F0,	CPU_DRAM	},
+	{ 0x0F4,	0x0F4,	CPU_DISPLAY	},
+	{ 0x110,	0x114,	CPU_MMIO	},
+	{ 0x120,	0x124,	CPU_DRAM	},
+	{ 0x140,	0x17C,	CPU_DRAM	},
+	{ 0x180,	0x184,	CPU_NB		},
+};
+
+/* Function 2 DRAM Controller Registers		*/
+static struct cpu_debug_range cpu_amd_pci2[] = {
+	{ 0x000,	0x00C,	CPU_PCI		},
+	{ 0x034,	0x034,	CPU_PCI		},
+	{ 0x040,	0x0A4,	CPU_DRAM	},
+	{ 0x10C,	0x11C,	CPU_DRAM	},
+	{ 0x140,	0x16C,	CPU_DRAM	},
+	{ 0x178,	0x1A0,	CPU_DRAM	},
+	{ 0x1B0,	0x1B0,	CPU_DRAM	},
+};
+
+/* Function 3 Misc. Configuration Registers	*/
+static struct cpu_debug_range cpu_amd_pci3[] = {
+	{ 0x000,	0x00C,	CPU_PCI		},
+	{ 0x034,	0x034,	CPU_PCI		},
+	{ 0x040,	0x054,	CPU_NB		},
+	{ 0x058,	0x060,	CPU_DRAM	},
+	{ 0x064,	0x068,	CPU_THERM	},
+	{ 0x06C,	0x06C,	CPU_POWER	},
+	{ 0x070,	0x07C,	CPU_DISPLAY	},
+	{ 0x080,	0x084,	CPU_POWER	},
+	{ 0x088,	0x08C,	CPU_NB		},
+	{ 0x090,	0x09C,	CPU_DISPLAY	},
+	{ 0x0A0,	0x0A0,	CPU_POWER	},
+	{ 0x0A4,	0x0A4,	CPU_THERM	},
+	{ 0x0B0,	0x0B0,	CPU_DISPLAY	},
+	{ 0x0D4,	0x0DC,	CPU_POWER	},
+	{ 0x0E4,	0x0E4,	CPU_THERM	},
+	{ 0x0E8,	0x0E8,	CPU_NB		},
+	{ 0x0F0,	0x0F0,	CPU_PCI		},
+	{ 0x0F4,	0x0F8,	CPU_PCI		},
+	{ 0x0FC,	0x0FC,	CPU_CPUID	},
+	{ 0x140,	0x180,	CPU_NB		},
+	{ 0x188,	0x188,	CPU_NB		},
+	{ 0x190,	0x190,	CPU_CONTROL	},
+	{ 0x1A0,	0x1A0,	CPU_CACHE	},
+	{ 0x1CC,	0x1CC,	CPU_IBS		},
+	{ 0x1E4,	0x1EC,	CPU_THERM	},
+	{ 0x1F0,	0x1F0,	CPU_CPUID	},
+	{ 0x1FC,	0x1FC,	CPU_NB		},
 };
 
+/* Function 4 Link Configuration Registers	*/
+static struct cpu_debug_range cpu_amd_pci4[] = {
+	{ 0x000,	0x00C,	CPU_PCI		},
+	{ 0x034,	0x034,	CPU_PCI		},
+	{ 0x080,	0x0F8,	CPU_LINK	},
+	{ 0x170,	0x174,	CPU_POWER	},
+	{ 0x180,	0x19C,	CPU_LINK	},
+	{ 0x1C4,	0x1C4,	CPU_POWER	},
+	{ 0x1E0,	0x1F0,	CPU_POWER	},
+};
+
+/* Extended CPUID base address			*/
+static u32 cpu_ext_cpuid[] = {
+	0x80000000,		/* Intel, AMD	*/
+	0x80860000,		/* Transmeta	*/
+	0xC0000000,		/* Centaur	*/
+};
+
+/* Check validity of cpu debug flag */
 static int is_typeflag_valid(unsigned cpu, unsigned flag)
 {
 	int i;
@@ -171,8 +325,9 @@ static int is_typeflag_valid(unsigned cpu, unsigned flag)
 	if (flag >= CPU_TSS)
 		return 1;
 
-	for (i = 0; i < ARRAY_SIZE(cpu_reg_range); i++) {
-		if (cpu_reg_range[i].flag == flag)
+	/* check MSR range */
+	for (i = 0; i < ARRAY_SIZE(cpu_msr_range); i++) {
+		if (cpu_msr_range[i].flag == flag)
 			return 1;
 	}
 
@@ -180,12 +335,13 @@ static int is_typeflag_valid(unsigned cpu, unsigned flag)
 	return 0;
 }
 
-static unsigned get_cpu_range(unsigned cpu, unsigned *min, unsigned *max,
+/* get MSR range */
+static unsigned get_msr_range(unsigned cpu, unsigned *min, unsigned *max,
 			      int index, unsigned flag)
 {
-	if (cpu_reg_range[index].flag == flag) {
-		*min = cpu_reg_range[index].min;
-		*max = cpu_reg_range[index].max;
+	if (cpu_msr_range[index].flag == flag) {
+		*min = cpu_msr_range[index].min;
+		*max = cpu_msr_range[index].max;
 	} else
 		*max = 0;
 
@@ -226,11 +382,12 @@ static void print_msr(struct seq_file *seq, unsigned cpu, unsigned flag)
 					       &low, &high))
 				print_cpu_data(seq, priv->reg, low, high);
 			return;
-		}
+		} else
+			seq_printf(seq, " MSR\t:\n");
 	}
 
-	for (i = 0; i < ARRAY_SIZE(cpu_reg_range); i++) {
-		if (!get_cpu_range(cpu, &msr_min, &msr_max, i, flag))
+	for (i = 0; i < ARRAY_SIZE(cpu_msr_range); i++) {
+		if (!get_msr_range(cpu, &msr_min, &msr_max, i, flag))
 			continue;
 
 		for (msr = msr_min; msr <= msr_max; msr++) {
@@ -339,7 +496,7 @@ static void print_dr(void *arg)
 		seq_printf(seq, " dr%d\t: %016lx\n", i, dr);
 	}
 
-	seq_printf(seq, "\n MSR\t:\n");
+	seq_printf(seq, "\n");
 }
 
 static void print_apic(void *arg)
@@ -347,43 +504,251 @@ static void print_apic(void *arg)
 	struct seq_file *seq = arg;
 
 #ifdef CONFIG_X86_LOCAL_APIC
+	unsigned int i;
+
 	seq_printf(seq, " LAPIC\t:\n");
-	seq_printf(seq, " ID\t\t: %08x\n",  apic_read(APIC_ID) >> 24);
-	seq_printf(seq, " LVR\t\t: %08x\n",  apic_read(APIC_LVR));
-	seq_printf(seq, " TASKPRI\t: %08x\n",  apic_read(APIC_TASKPRI));
-	seq_printf(seq, " ARBPRI\t\t: %08x\n",  apic_read(APIC_ARBPRI));
-	seq_printf(seq, " PROCPRI\t: %08x\n",  apic_read(APIC_PROCPRI));
-	seq_printf(seq, " LDR\t\t: %08x\n",  apic_read(APIC_LDR));
-	seq_printf(seq, " DFR\t\t: %08x\n",  apic_read(APIC_DFR));
-	seq_printf(seq, " SPIV\t\t: %08x\n",  apic_read(APIC_SPIV));
-	seq_printf(seq, " ISR\t\t: %08x\n",  apic_read(APIC_ISR));
-	seq_printf(seq, " ESR\t\t: %08x\n",  apic_read(APIC_ESR));
-	seq_printf(seq, " ICR\t\t: %08x\n",  apic_read(APIC_ICR));
-	seq_printf(seq, " ICR2\t\t: %08x\n",  apic_read(APIC_ICR2));
-	seq_printf(seq, " LVTT\t\t: %08x\n",  apic_read(APIC_LVTT));
-	seq_printf(seq, " LVTTHMR\t: %08x\n",  apic_read(APIC_LVTTHMR));
-	seq_printf(seq, " LVTPC\t\t: %08x\n",  apic_read(APIC_LVTPC));
-	seq_printf(seq, " LVT0\t\t: %08x\n",  apic_read(APIC_LVT0));
-	seq_printf(seq, " LVT1\t\t: %08x\n",  apic_read(APIC_LVT1));
-	seq_printf(seq, " LVTERR\t\t: %08x\n",  apic_read(APIC_LVTERR));
-	seq_printf(seq, " TMICT\t\t: %08x\n",  apic_read(APIC_TMICT));
-	seq_printf(seq, " TMCCT\t\t: %08x\n",  apic_read(APIC_TMCCT));
-	seq_printf(seq, " TDCR\t\t: %08x\n",  apic_read(APIC_TDCR));
+	for (i = 0; i < ARRAY_SIZE(cpu_apic); i++) {
+		if (strlen(cpu_apic[i].name) < 7)
+			seq_printf(seq, " %s\t\t: %08x\n",  cpu_apic[i].name,
+				   apic_read(cpu_apic[i].flag));
+		else
+			seq_printf(seq, " %s\t: %08x\n",  cpu_apic[i].name,
+				   apic_read(cpu_apic[i].flag));
+	}
 	if (boot_cpu_has(X86_FEATURE_EXTAPIC)) {
-		unsigned int i, v, maxeilvt;
+		unsigned int maxeilvt;
 
-		v = apic_read(APIC_EFEAT);
-		maxeilvt = (v >> 16) & 0xff;
-		seq_printf(seq, " EFEAT\t\t: %08x\n", v);
-		seq_printf(seq, " ECTRL\t\t: %08x\n", apic_read(APIC_ECTRL));
+		for (i = 0; i < ARRAY_SIZE(cpu_xapic); i++)
+			seq_printf(seq, " %s\t\t: %08x\n",  cpu_xapic[i].name,
+				   apic_read(cpu_xapic[i].flag));
 
-		for (i = 0; i < maxeilvt; i++) {
-			v = apic_read(APIC_EILVTn(i));
-			seq_printf(seq, " EILVT%d\t\t: %08x\n", i, v);
+		maxeilvt = (apic_read(APIC_EFEAT) >> 16) & 0xff;
+		for (i = 0; i < maxeilvt; i++)
+			seq_printf(seq, " EILVT%d\t\t: %08x\n",
+				   i, apic_read(APIC_EILVTn(i)));
+	}
+	seq_printf(seq, "\n");
+#endif
+}
+
+/* Get extended CPUID level */
+static u32 get_extended_cpuid(void)
+{
+	u32 i, level;
+
+	for (i = 0; i < ARRAY_SIZE(cpu_ext_cpuid); i++) {
+		level = cpuid_eax(cpu_ext_cpuid[i]);
+		if ((level & CPUID_MASK) == cpu_ext_cpuid[i])
+			return level;
+	}
+
+	return 0;		/* Not found */
+}
+
+static void print_cpuidabcd(struct seq_file *seq, u32 min, u32 max)
+{
+	u32 i, eax, ebx, ecx, edx;
+
+	for (i = min; i <= max; i++) {
+		cpuid(i, &eax, &ebx, &ecx, &edx);
+		seq_printf(seq, " %08x  %08x  %08x  %08x  %08x\n",
+			   i, eax, ebx, ecx, edx);
+	}
+}
+
+static void print_cpuid(void *arg)
+{
+	struct seq_file *seq = arg;
+	u32 level;
+
+	seq_printf(seq, " CPUID\t:\n");
+	seq_printf(seq, "              eax       ebx       ecx       edx\n");
+
+	/* Standard CPUID functions */
+	level = cpuid_eax(0);
+	print_cpuidabcd(seq, 0, level);
+
+	/* Extended CPUID functions */
+	level = get_extended_cpuid();
+	if (level)
+		print_cpuidabcd(seq, (level & CPUID_MASK), level);
+}
+
+/* dump struct cpuinfo_x86 */
+static void print_cpuinfo(void *arg)
+{
+	struct seq_file *seq = arg;
+	struct cpu_private *priv = seq->private;
+	struct cpuinfo_x86 *cpui;
+	unsigned int i;
+
+	cpui = &cpu_data(priv->cpu);
+	seq_printf(seq, " CPUINFO\t:\n");
+	seq_printf(seq, " processor\t\t: %u\n", priv->cpu);
+
+	seq_printf(seq, " family\t\t\t: %u\n", cpui->x86);
+	seq_printf(seq, " vendor\t\t\t: %u\n", cpui->x86_vendor);
+	seq_printf(seq, " model\t\t\t: %u\n", cpui->x86_model);
+	seq_printf(seq, " mask\t\t\t: %u\n", cpui->x86_mask);
+#ifdef CONFIG_X86_32
+	seq_printf(seq, " wp_works_ok\t\t: %u\n", cpui->wp_works_ok);
+	seq_printf(seq, " halt_works_ok\t\t: %u\n", cpui->hlt_works_ok);
+	seq_printf(seq, " hard_math\t\t: %u\n", cpui->hard_math);
+	seq_printf(seq, " rfu\t\t\t: %u\n", cpui->rfu);
+	seq_printf(seq, " fdiv_bug\t\t: %u\n", cpui->fdiv_bug);
+	seq_printf(seq, " f00f_bug\t\t: %u\n", cpui->f00f_bug);
+	seq_printf(seq, " coma_bug\t\t: %u\n", cpui->coma_bug);
+#else
+	seq_printf(seq, " TLB size\t\t: %d 4K pages\n", cpui->x86_tlbsize);
+#endif
+	seq_printf(seq, " virtual bits\t\t: %u\n", cpui->x86_virt_bits);
+	seq_printf(seq, " physical bits\t\t: %u\n", cpui->x86_phys_bits);
+
+	seq_printf(seq, " extended cpuid level\t: %08x (%08x)\n",
+		   cpui->extended_cpuid_level, get_extended_cpuid());
+	seq_printf(seq, " cpuid level\t\t: %d\n", cpui->cpuid_level);
+
+	seq_printf(seq, " flags\t\t\t:");
+	for (i = 0; i < 32 * NCAPINTS; i++)
+		if (cpu_has(cpui, i) && x86_cap_flags[i] != NULL)
+			seq_printf(seq, " %s", x86_cap_flags[i]);
+
+	seq_printf(seq, "\n vendor id\t\t: %s\n",
+		   cpui->x86_vendor_id[0] ? cpui->x86_vendor_id : "unknown");
+	seq_printf(seq, " model id\t\t: %s\n",
+		   cpui->x86_model_id[0] ? cpui->x86_model_id : "unknown");
+
+	seq_printf(seq, " cache size\t\t: %d KB\n", cpui->x86_cache_size);
+	seq_printf(seq, " cache alignment\t: %d\n", cpui->x86_cache_alignment);
+
+	seq_printf(seq, " power management\t:");
+	for (i = 0; i < 32; i++) {
+		if (cpui->x86_power & (1 << i)) {
+			if (i < ARRAY_SIZE(x86_power_flags) &&
+			    x86_power_flags[i])
+				seq_printf(seq, "%s%s",
+					   x86_power_flags[i][0] ? " " : "",
+					   x86_power_flags[i]);
+			else
+				seq_printf(seq, " [%d]", i);
 		}
 	}
-#endif /* CONFIG_X86_LOCAL_APIC */
-	seq_printf(seq, "\n MSR\t:\n");
+
+	seq_printf(seq, "\n loops per jiffy\t: %lu\n", cpui->loops_per_jiffy);
+	seq_printf(seq, " bogomips\t\t: %lu.%02lu\n",
+		   cpui->loops_per_jiffy/(500000/HZ),
+		   (cpui->loops_per_jiffy/(5000/HZ)) % 100);
+
+	seq_printf(seq, " max cores\t\t: %d\n", cpui->x86_max_cores);
+	seq_printf(seq, " apic id\t\t: %d\n", cpui->apicid);
+	seq_printf(seq, " intial apic id\t\t: %d\n", cpui->initial_apicid);
+	seq_printf(seq, " clflush size\t\t: %u\n", cpui->x86_clflush_size);
+
+#ifdef CONFIG_SMP
+	seq_printf(seq, " cpu cores\t\t: %d\n", cpui->booted_cores);
+	seq_printf(seq, " physical id\t\t: %d\n", cpui->phys_proc_id);
+	seq_printf(seq, " core id\t\t: %d\n", cpui->cpu_core_id);
+	seq_printf(seq, " cpu index\t\t: %d\n", cpui->cpu_index);
+#endif
+
+	seq_printf(seq, " hyper vendor\t\t: %d\n", cpui->x86_hyper_vendor);
+}
+
+static void print_apicval(void *arg)
+{
+	struct seq_file *seq = arg;
+
+#ifdef CONFIG_X86_LOCAL_APIC
+	struct cpu_private *priv = seq->private;
+
+	seq_printf(seq, "0x%x\n", apic_read(priv->reg));
+#endif
+}
+
+static void print_pcival(void *arg)
+{
+	struct seq_file *seq = arg;
+	struct cpu_private *priv = seq->private;
+	struct pci_dev *dev;
+	u32 data = (priv->reg & 0xf0000) >> 16;
+
+	if (data >= MAX_CPU_PCI)
+		return;
+
+	dev = per_cpu(pci_arr[data], priv->cpu);
+	if (!pci_read_config_dword(dev, priv->reg & 0x0fff, &data))
+		seq_printf(seq, "0x%x\n", data);
+}
+
+#define PRINT_AMD_PCI(func) \
+static void print_amd_pci##func(struct seq_file *seq, struct pci_dev *dev) \
+{									\
+	unsigned int reg, i;						\
+	u32 data;							\
+									\
+	for (i = 0; i < ARRAY_SIZE(cpu_amd_pci##func); i++) {		\
+		for (reg = cpu_amd_pci##func[i].min; 			\
+		     reg <= cpu_amd_pci##func[i].max; reg++) {		\
+			if (!pci_read_config_dword(dev, reg, &data)) {	\
+				seq_printf(seq, " %03x\t: %08x\n", 	\
+					   reg, data);			\
+			}						\
+		}							\
+	}								\
+	seq_printf(seq, "\n");						\
+}
+
+PRINT_AMD_PCI(0)
+PRINT_AMD_PCI(1)
+PRINT_AMD_PCI(2)
+PRINT_AMD_PCI(3)
+PRINT_AMD_PCI(4)
+
+static void print_amd_pci(struct seq_file *seq)
+{
+	struct cpu_private *priv = seq->private;
+	struct pci_dev *dev;
+	unsigned int func;
+
+	for (func = 0; func < MAX_CPU_PCI; func++) {
+		dev = per_cpu(pci_arr[func], priv->cpu);
+		if (dev == NULL)
+			continue;
+
+		seq_printf(seq, " function : %d\n", func);
+
+		switch (func) {
+		case 0:
+			print_amd_pci0(seq, dev);
+			break;
+		case 1:
+			print_amd_pci1(seq, dev);
+			break;
+		case 2:
+			print_amd_pci2(seq, dev);
+			break;
+		case 3:
+			print_amd_pci3(seq, dev);
+			break;
+		case 4:
+			print_amd_pci4(seq, dev);
+			break;
+		}
+	}
+}
+
+static void print_pci(void *arg)
+{
+	struct seq_file *seq = arg;
+
+	seq_printf(seq, " PCI configuration regsiters :\n");
+	switch (boot_cpu_data.x86_vendor) {
+	case X86_VENDOR_AMD:
+		print_amd_pci(seq);
+		break;
+	default:
+		return;
+	}
 }
 
 static int cpu_seq_show(struct seq_file *seq, void *v)
@@ -403,19 +768,46 @@ static int cpu_seq_show(struct seq_file *seq, void *v)
 	case CPU_DT:
 		smp_call_function_single(priv->cpu, print_dt, seq, 1);
 		break;
+	case CPU_CPUID:
+		if (priv->file == CPU_INDEX)
+			smp_call_function_single(priv->cpu, print_cpuid,
+						 seq, 1);
+		else
+			smp_call_function_single(priv->cpu, print_pcival,
+						 seq, 1);
+		break;
+	case CPU_CPUINFO:
+		smp_call_function_single(priv->cpu, print_cpuinfo, seq, 1);
+		break;
+	case CPU_PCI:
+		if (priv->file == CPU_INDEX)
+			smp_call_function_single(priv->cpu, print_pci, seq, 1);
+		else
+			smp_call_function_single(priv->cpu, print_pcival,
+						 seq, 1);
+		break;
 	case CPU_DEBUG:
-		if (priv->file == CPU_INDEX_BIT)
+		if (priv->file == CPU_INDEX)
 			smp_call_function_single(priv->cpu, print_dr, seq, 1);
-		print_msr(seq, priv->cpu, cpu_base[priv->type].flag);
+		if (priv->cat == CPU_REG_MSR)
+			print_msr(seq, priv->cpu, cpu_base[priv->type].flag);
 		break;
 	case CPU_APIC:
-		if (priv->file == CPU_INDEX_BIT)
+		if (priv->file == CPU_INDEX)
 			smp_call_function_single(priv->cpu, print_apic, seq, 1);
-		print_msr(seq, priv->cpu, cpu_base[priv->type].flag);
+		if (priv->cat == CPU_REG_MSR)
+			print_msr(seq, priv->cpu, cpu_base[priv->type].flag);
+		else if (priv->cat == CPU_REG_APIC)
+			smp_call_function_single(priv->cpu, print_apicval,
+						 seq, 1);
 		break;
 
 	default:
-		print_msr(seq, priv->cpu, cpu_base[priv->type].flag);
+		if (priv->cat == CPU_REG_MSR)
+			print_msr(seq, priv->cpu, cpu_base[priv->type].flag);
+		else if (priv->cat == CPU_REG_PCI)
+			smp_call_function_single(priv->cpu, print_pcival,
+						 seq, 1);
 		break;
 	}
 	seq_printf(seq, "\n");
@@ -487,7 +879,7 @@ static int write_cpu_register(struct cpu_private *priv, const char *buf)
 		return ret;
 
 	/* Supporting only MSRs */
-	if (priv->type < CPU_TSS_BIT)
+	if (priv->type < CPU_TSS)
 		return write_msr(priv, val);
 
 	return ret;
@@ -525,12 +917,12 @@ static const struct file_operations cpu_fops = {
 };
 
 static int cpu_create_file(unsigned cpu, unsigned type, unsigned reg,
-			   unsigned file, struct dentry *dentry)
+			   unsigned file, unsigned cat, struct dentry *dentry)
 {
 	struct cpu_private *priv = NULL;
 
 	/* Already intialized */
-	if (file == CPU_INDEX_BIT)
+	if (file == CPU_INDEX)
 		if (per_cpu(cpu_arr[type].init, cpu))
 			return 0;
 
@@ -542,6 +934,7 @@ static int cpu_create_file(unsigned cpu, unsigned type, unsigned reg,
 	priv->type = type;
 	priv->reg = reg;
 	priv->file = file;
+	priv->cat = cat;
 	mutex_lock(&cpu_debug_lock);
 	per_cpu(priv_arr[type], cpu) = priv;
 	per_cpu(cpu_priv_count, cpu)++;
@@ -551,7 +944,7 @@ static int cpu_create_file(unsigned cpu, unsigned type, unsigned reg,
 		debugfs_create_file(cpu_file[file].name, S_IRUGO,
 				    dentry, (void *)priv, &cpu_fops);
 	else {
-		debugfs_create_file(cpu_base[type].name, S_IRUGO,
+		debugfs_create_file(cpu_file[file].name, S_IRUGO,
 				    per_cpu(cpu_arr[type].dentry, cpu),
 				    (void *)priv, &cpu_fops);
 		mutex_lock(&cpu_debug_lock);
@@ -563,13 +956,13 @@ static int cpu_create_file(unsigned cpu, unsigned type, unsigned reg,
 }
 
 static int cpu_init_regfiles(unsigned cpu, unsigned int type, unsigned reg,
-			     struct dentry *dentry)
+			     unsigned cat, struct dentry *dentry)
 {
 	unsigned file;
 	int err = 0;
 
-	for (file = 0; file <  ARRAY_SIZE(cpu_file); file++) {
-		err = cpu_create_file(cpu, type, reg, file, dentry);
+	for (file = 0; file < ARRAY_SIZE(cpu_file); file++) {
+		err = cpu_create_file(cpu, type, reg, file, cat, dentry);
 		if (err)
 			return err;
 	}
@@ -585,8 +978,8 @@ static int cpu_init_msr(unsigned cpu, unsigned type, struct dentry *dentry)
 	char reg_dir[12];
 	u32 low, high;
 
-	for (i = 0; i < ARRAY_SIZE(cpu_reg_range); i++) {
-		if (!get_cpu_range(cpu, &reg_min, &reg_max, i,
+	for (i = 0; i < ARRAY_SIZE(cpu_msr_range); i++) {
+		if (!get_msr_range(cpu, &reg_min, &reg_max, i,
 				   cpu_base[type].flag))
 			continue;
 
@@ -594,9 +987,10 @@ static int cpu_init_msr(unsigned cpu, unsigned type, struct dentry *dentry)
 			if (rdmsr_safe_on_cpu(cpu, reg, &low, &high))
 				continue;
 
-			sprintf(reg_dir, "0x%x", reg);
+			sprintf(reg_dir, "MSR_%x", reg);
 			cpu_dentry = debugfs_create_dir(reg_dir, dentry);
-			err = cpu_init_regfiles(cpu, type, reg, cpu_dentry);
+			err = cpu_init_regfiles(cpu, type, reg, CPU_REG_MSR,
+						cpu_dentry);
 			if (err)
 				return err;
 		}
@@ -605,23 +999,144 @@ static int cpu_init_msr(unsigned cpu, unsigned type, struct dentry *dentry)
 	return err;
 }
 
+static void cpu_init_apic(unsigned cpu, struct dentry *dentry)
+{
+#ifdef CONFIG_X86_LOCAL_APIC
+	struct dentry *cpu_dentry;
+	char reg_dir[16];
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(cpu_apic); i++) {
+		sprintf(reg_dir, "APIC_%s", cpu_apic[i].name);
+		cpu_dentry = debugfs_create_dir(reg_dir, dentry);
+		cpu_create_file(cpu, CPU_APIC, cpu_apic[i].flag, CPU_VALUE,
+				CPU_REG_APIC, cpu_dentry);
+	}
+
+	if (boot_cpu_has(X86_FEATURE_EXTAPIC)) {
+		unsigned int maxeilvt;
+
+		for (i = 0; i < ARRAY_SIZE(cpu_xapic); i++) {
+			sprintf(reg_dir, "APIC_%s", cpu_xapic[i].name);
+			cpu_dentry = debugfs_create_dir(reg_dir, dentry);
+			cpu_create_file(cpu, CPU_APIC, cpu_xapic[i].flag,
+					CPU_VALUE, CPU_REG_APIC, cpu_dentry);
+		}
+
+		maxeilvt = (apic_read(APIC_EFEAT) >> 16) & 0xff;
+		for (i = 0; i < maxeilvt; i++) {
+			sprintf(reg_dir, "APIC_EILVT%d", i);
+			cpu_dentry = debugfs_create_dir(reg_dir, dentry);
+			cpu_create_file(cpu, CPU_APIC, APIC_EILVTn(i),
+					CPU_VALUE, CPU_REG_APIC, cpu_dentry);
+		}
+	}
+#endif
+}
+
+#define INIT_AMD_PCI(func) \
+static void init_amd_pci##func(unsigned cpu, struct dentry *dentry, 	\
+				struct pci_dev *dev)			\
+{									\
+	struct dentry *cdentry;						\
+	unsigned int reg, i, id;					\
+	char reg_dir[10];						\
+	u32 data;							\
+									\
+	for (i = 0; i < ARRAY_SIZE(cpu_amd_pci##func); i++) {		\
+		for (reg = cpu_amd_pci##func[i].min;			\
+		     reg <= cpu_amd_pci##func[i].max; reg++) {		\
+			if (!pci_read_config_dword(dev, reg, &data)) {	\
+				sprintf(reg_dir, "PCI%d_%03x",		\
+					func, reg);			\
+				id = cpu_amd_pci##func[i].flag;		\
+				cdentry = debugfs_create_dir(reg_dir,	\
+					per_cpu(cpu_arr[id].dentry, cpu)); \
+				cpu_create_file(cpu, 			\
+						cpu_amd_pci##func[i].flag, \
+						(func << 16) | reg,	\
+						CPU_VALUE, CPU_REG_PCI, \
+						cdentry);		\
+			}						\
+		}							\
+	}								\
+}
+
+/* AMD supports five functions, 0 through 4 */
+INIT_AMD_PCI(0)
+INIT_AMD_PCI(1)
+INIT_AMD_PCI(2)
+INIT_AMD_PCI(3)
+INIT_AMD_PCI(4)
+
+static void init_amd_pci(unsigned cpu, struct dentry *dentry)
+{
+	struct pci_dev *dev = NULL;
+	unsigned int func;
+
+	while ((dev = pci_get_device(PCI_VENDOR_ID_AMD, PCI_ANY_ID, dev))
+	       != NULL) {
+		if ((dev->device >= 0x1100) && (dev->device < 0x2000)) {
+			func = dev->device & 0xff;
+			if (func >= MAX_CPU_PCI)
+				continue;
+
+			per_cpu(pci_arr[func], cpu) = dev;
+			switch (func) {
+			case 0:
+				init_amd_pci0(cpu, dentry, dev);
+				break;
+			case 1:
+				init_amd_pci1(cpu, dentry, dev);
+				break;
+			case 2:
+				init_amd_pci2(cpu, dentry, dev);
+				break;
+			case 3:
+				init_amd_pci3(cpu, dentry, dev);
+				break;
+			case 4:
+				init_amd_pci4(cpu, dentry, dev);
+				break;
+			}
+		}
+	}
+}
+
+static void cpu_init_pci(unsigned cpu, struct dentry *dentry)
+{
+	switch (boot_cpu_data.x86_vendor) {
+	case X86_VENDOR_AMD:
+		init_amd_pci(cpu, dentry);
+		break;
+	default:
+		return;
+	}
+}
+
 static int cpu_init_allreg(unsigned cpu, struct dentry *dentry)
 {
 	struct dentry *cpu_dentry = NULL;
 	unsigned type;
 	int err = 0;
 
-	for (type = 0; type <  ARRAY_SIZE(cpu_base) - 1; type++) {
-		if (!is_typeflag_valid(cpu, cpu_base[type].flag))
-			continue;
+	for (type = 0; type < ARRAY_SIZE(cpu_base) - 1; type++) {
 		cpu_dentry = debugfs_create_dir(cpu_base[type].name, dentry);
 		per_cpu(cpu_arr[type].dentry, cpu) = cpu_dentry;
 
-		if (type < CPU_TSS_BIT)
+		/* check before preparing "state" file */
+		if (!is_typeflag_valid(cpu, cpu_base[type].flag))
+			continue;
+
+		if (type == CPU_APIC)
+			cpu_init_apic(cpu, cpu_dentry);
+		if (type == CPU_PCI)
+			cpu_init_pci(cpu, cpu_dentry);
+		if (type < CPU_TSS)
 			err = cpu_init_msr(cpu, type, cpu_dentry);
 		else
-			err = cpu_create_file(cpu, type, 0, CPU_INDEX_BIT,
-					      cpu_dentry);
+			err = cpu_create_file(cpu, type, 0, CPU_INDEX,
+					      CPU_REG_STD, cpu_dentry);
 		if (err)
 			return err;
 	}
@@ -649,8 +1164,8 @@ static int cpu_init_cpu(void)
 		pr_info("cpu%d(%d) debug files %d\n",
 			cpu, nr_cpu_ids, per_cpu(cpu_priv_count, cpu));
 		if (per_cpu(cpu_priv_count, cpu) > MAX_CPU_FILES) {
-			pr_err("Register files count %d exceeds limit %d\n",
-				per_cpu(cpu_priv_count, cpu), MAX_CPU_FILES);
+			WARN_ONCE(1, "debug files count %d exceeds limit %d\n",
+				  per_cpu(cpu_priv_count, cpu), MAX_CPU_FILES);
 			per_cpu(cpu_priv_count, cpu) = MAX_CPU_FILES;
 			err = -ENFILE;
 		}
@@ -683,6 +1198,6 @@ static void __exit cpu_debug_exit(void)
 module_init(cpu_debug_init);
 module_exit(cpu_debug_exit);
 
-MODULE_AUTHOR("Jaswinder Singh Rajput");
+MODULE_AUTHOR("Jaswinder Singh Rajput <jaswinder@kernel.org>");
 MODULE_DESCRIPTION("CPU Debug module");
 MODULE_LICENSE("GPL");


