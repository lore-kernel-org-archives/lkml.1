Return-Path: <linux-kernel-owner+w=401wt.eu-S1753016AbYHKOkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbYHKOkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 10:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754456AbYHKOje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 10:39:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:65437 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698AbYHKOj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 10:39:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: [RFC 2/3] powerpc: export all symbols from the definition file
Date: Mon, 11 Aug 2008 16:17:52 +0200
User-Agent: KMail/1.9.9
Cc: linux-arch@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       David Woodhouse <dwmw2@infradead.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, linuxppc-dev@ozlabs.org
References: <200808111606.44103.arnd@arndb.de>
In-Reply-To: <200808111606.44103.arnd@arndb.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808111617.53305.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18aMKhoyU1vX6e5BaNmhESV4JJhqgNCeRE7S+8
 XoYobfhSZvWLm0w0HCrgfAoiUbstY32VPe8EU+fREeuRZwMUBm
 TkurlGmk2LbKm/oZKJH0g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's now possible to export symbols from .S files, so move all
exports out of the ppc_ksyms.c file to the definition of the
symbols.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/powerpc/kernel/entry_32.S       |    3 +++
 arch/powerpc/kernel/entry_64.S       |    2 ++
 arch/powerpc/kernel/fpu.S            |    2 ++
 arch/powerpc/kernel/head_32.S        |    6 ++++++
 arch/powerpc/kernel/head_40x.S       |    4 ++++
 arch/powerpc/kernel/head_44x.S       |    5 +++++
 arch/powerpc/kernel/head_64.S        |    2 ++
 arch/powerpc/kernel/head_8xx.S       |    4 ++++
 arch/powerpc/kernel/head_fsl_booke.S |    6 ++++++
 arch/powerpc/kernel/irq.c            |    4 +++-
 arch/powerpc/kernel/misc_32.S        |   12 ++++++++++++
 arch/powerpc/kernel/misc_64.S        |    5 +++++
 arch/powerpc/kernel/pci-common.c     |    2 ++
 arch/powerpc/kernel/pci_32.c         |    3 +++
 arch/powerpc/kernel/process.c        |    2 ++
 arch/powerpc/kernel/setup-common.c   |    1 +
 arch/powerpc/kernel/setup_32.c       |    5 +++++
 arch/powerpc/kernel/signal_32.c      |    2 ++
 arch/powerpc/kernel/smp.c            |    2 ++
 arch/powerpc/kernel/time.c           |    3 +++
 arch/powerpc/kernel/traps.c          |    4 ++++
 arch/powerpc/lib/checksum_32.S       |    6 ++++++
 arch/powerpc/lib/checksum_64.S       |    5 +++++
 arch/powerpc/lib/copy_32.S           |    7 +++++++
 arch/powerpc/lib/copypage_64.S       |    3 +++
 arch/powerpc/lib/copyuser_64.S       |    3 +++
 arch/powerpc/lib/mem_64.S            |    3 +++
 arch/powerpc/lib/memcpy_64.S         |    3 +++
 arch/powerpc/lib/string.S            |   12 ++++++++++++
 arch/powerpc/mm/hash_low_32.S        |    4 ++++
 arch/powerpc/mm/mmu_context_32.c     |    2 ++
 arch/powerpc/mm/tlb_32.c             |    3 +++
 arch/powerpc/sysdev/dcr-low.S        |    3 +++
 drivers/macintosh/adb.c              |    5 +++++
 drivers/macintosh/via-cuda.c         |    3 +++

 35 files changed, 140 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/entry_32.S b/arch/powerpc/kernel/entry_32.S
index 1cbbf70..7716264 100644
--- a/arch/powerpc/kernel/entry_32.S
+++ b/arch/powerpc/kernel/entry_32.S
@@ -22,6 +22,7 @@
 #include <linux/errno.h>
 #include <linux/sys.h>
 #include <linux/threads.h>
+#include <linux/module.h>
 #include <asm/reg.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
@@ -209,6 +210,7 @@ transfer_to_handler_cont:
 	lwz	r12,_LINK(r11)		/* and return to address in LR */
 	b	fast_exception_return
 #endif
+EXPORT_SYMBOL(transfer_to_handler)
 
 /*
  * On kernel stack overflow, load up an initial stack pointer
@@ -1196,6 +1198,7 @@ mcount_call:
 	lwz	r10,40(r1)
 	addi	r1, r1, 48
 	bctr
+EXPORT_SYMBOL(_mcount)
 
 _GLOBAL(ftrace_caller)
 	/* Based off of objdump optput from glibc */
diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index 2d802e9..fa65272 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -18,6 +18,7 @@
  *  2 of the License, or (at your option) any later version.
  */
 
+#include <linux/module.h>
 #include <linux/errno.h>
 #include <asm/unistd.h>
 #include <asm/processor.h>
@@ -898,6 +899,7 @@ mcount_call:
 	mtlr	r0
 	addi	r1, r1, 112
 	blr
+EXPORT_SYMBOL(_mcount)
 
 _GLOBAL(ftrace_caller)
 	/* Taken from output of objdump from lib64/glibc */
diff --git a/arch/powerpc/kernel/fpu.S b/arch/powerpc/kernel/fpu.S
index a088c06..6e137b4 100644
--- a/arch/powerpc/kernel/fpu.S
+++ b/arch/powerpc/kernel/fpu.S
@@ -14,6 +14,7 @@
  *
  */
 
+#include <linux/module.h>
 #include <asm/reg.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
@@ -154,6 +155,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_VSX)
 	PPC_STL	r5,ADDROFF(last_task_used_math)(r4)
 #endif /* CONFIG_SMP */
 	blr
+EXPORT_SYMBOL(giveup_fpu)
 
 /*
  * These are used in the alignment trap handler when emulating
diff --git a/arch/powerpc/kernel/head_32.S b/arch/powerpc/kernel/head_32.S
index 99ee2f0..d6c8a03 100644
--- a/arch/powerpc/kernel/head_32.S
+++ b/arch/powerpc/kernel/head_32.S
@@ -21,6 +21,7 @@
  *
  */
 
+#include <linux/module.h>
 #include <asm/reg.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
@@ -690,6 +691,7 @@ DataStoreTLBMiss:
 
 	.globl mol_trampoline
 	.set mol_trampoline, i0x2f00
+EXPORT_SYMBOL(mol_trampoline)
 
 	. = 0x3000
 
@@ -801,6 +803,7 @@ giveup_altivec:
 #endif /* CONFIG_SMP */
 	blr
 #endif /* CONFIG_ALTIVEC */
+EXPORT_SYMBOL(giveup_altivec)
 
 /*
  * This code is jumped to from the startup code to copy
@@ -1092,6 +1095,7 @@ _ENTRY(set_context)
 	sync
 	isync
 	blr
+EXPORT_SYMBOL(set_context)
 
 /*
  * An undocumented "feature" of 604e requires that the v bit
@@ -1294,6 +1298,7 @@ sdata:
 	.globl	empty_zero_page
 empty_zero_page:
 	.space	4096
+EXPORT_SYMBOL(empty_zero_page)
 
 	.globl	swapper_pg_dir
 swapper_pg_dir:
@@ -1307,6 +1312,7 @@ intercept_table:
 	.long 0, 0, 0, 0, 0, 0, 0, 0
 	.long 0, 0, 0, 0, 0, 0, 0, 0
 	.long 0, 0, 0, 0, 0, 0, 0, 0
+EXPORT_SYMBOL(intercept_table)
 
 /* Room for two PTE pointers, usually the kernel and current user pointers
  * to their respective root page table.
diff --git a/arch/powerpc/kernel/head_40x.S b/arch/powerpc/kernel/head_40x.S
index 56d8e5d..717de09 100644
--- a/arch/powerpc/kernel/head_40x.S
+++ b/arch/powerpc/kernel/head_40x.S
@@ -31,6 +31,7 @@
  *
  */
 
+#include <linux/module.h>
 #include <asm/processor.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
@@ -822,6 +823,7 @@ finish_tlb_load:
  */
 _ENTRY(giveup_fpu)
 	blr
+EXPORT_SYMBOL(giveup_fpu)
 
 /* This is where the main kernel code starts.
  */
@@ -987,6 +989,7 @@ _GLOBAL(set_context)
 	isync				/* Need an isync to flush shadow */
 					/* TLBs after changing PID */
 	blr
+EXPORT_SYMBOL(set_context)
 
 /* We put a few things here that have to be page-aligned. This stuff
  * goes at the beginning of the data segment, which is page-aligned.
@@ -998,6 +1001,7 @@ sdata:
 	.globl	empty_zero_page
 empty_zero_page:
 	.space	4096
+EXPORT_SYMBOL(empty_zero_page)
 	.globl	swapper_pg_dir
 swapper_pg_dir:
 	.space	PGD_TABLE_SIZE
diff --git a/arch/powerpc/kernel/head_44x.S b/arch/powerpc/kernel/head_44x.S
index f3a1ea9..703a70c 100644
--- a/arch/powerpc/kernel/head_44x.S
+++ b/arch/powerpc/kernel/head_44x.S
@@ -28,6 +28,7 @@
  * option) any later version.
  */
 
+#include <linux/module.h>
 #include <asm/processor.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
@@ -604,6 +605,7 @@ _GLOBAL(__fixup_440A_mcheck)
  */
 _GLOBAL(giveup_altivec)
 	blr
+EXPORT_SYMBOL(giveup_altivec)
 
 /*
  * extern void giveup_fpu(struct task_struct *prev)
@@ -613,6 +615,7 @@ _GLOBAL(giveup_altivec)
 #ifndef CONFIG_PPC_FPU
 _GLOBAL(giveup_fpu)
 	blr
+EXPORT_SYMBOL(giveup_fpu)
 #endif
 
 _GLOBAL(set_context)
@@ -628,6 +631,7 @@ _GLOBAL(set_context)
 	mtspr	SPRN_PID,r3
 	isync			/* Force context change */
 	blr
+EXPORT_SYMBOL(set_context)
 
 /*
  * We put a few things here that have to be page-aligned. This stuff
@@ -640,6 +644,7 @@ sdata:
 	.globl	empty_zero_page
 empty_zero_page:
 	.space	4096
+EXPORT_SYMBOL(empty_zero_page)
 
 /*
  * To support >32-bit physical addresses, we use an 8KB pgdir.
diff --git a/arch/powerpc/kernel/head_64.S b/arch/powerpc/kernel/head_64.S
index cc8fb47..d807daa 100644
--- a/arch/powerpc/kernel/head_64.S
+++ b/arch/powerpc/kernel/head_64.S
@@ -21,6 +21,7 @@
  *  2 of the License, or (at your option) any later version.
  */
 
+#include <linux/module.h>
 #include <linux/threads.h>
 #include <asm/reg.h>
 #include <asm/page.h>
@@ -1653,6 +1654,7 @@ END_FW_FTR_SECTION_IFSET(FW_FEATURE_ISERIES)
 	.globl	empty_zero_page
 empty_zero_page:
 	.space	PAGE_SIZE
+EXPORT_SYMBOL(empty_zero_page)
 
 	.globl	swapper_pg_dir
 swapper_pg_dir:
diff --git a/arch/powerpc/kernel/head_8xx.S b/arch/powerpc/kernel/head_8xx.S
index 3c9452d..c3ef451 100644
--- a/arch/powerpc/kernel/head_8xx.S
+++ b/arch/powerpc/kernel/head_8xx.S
@@ -19,6 +19,7 @@
  *
  */
 
+#include <linux/module.h>
 #include <asm/processor.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
@@ -590,6 +591,7 @@ DataTLBError:
 	.globl	giveup_fpu
 giveup_fpu:
 	blr
+EXPORT_SYMBOL(giveup_fpu)
 
 /*
  * This is where the main kernel code starts.
@@ -831,6 +833,7 @@ _GLOBAL(set_context)
 #endif
 	SYNC
 	blr
+EXPORT_SYMBOL(set_context)
 
 #ifdef CONFIG_8xx_CPU6
 /* It's here because it is unique to the 8xx.
@@ -861,6 +864,7 @@ sdata:
 	.globl	empty_zero_page
 empty_zero_page:
 	.space	4096
+EXPORT_SYMBOL(empty_zero_page)
 
 	.globl	swapper_pg_dir
 swapper_pg_dir:
diff --git a/arch/powerpc/kernel/head_fsl_booke.S b/arch/powerpc/kernel/head_fsl_booke.S
index 3cb52fa..7e579fc 100644
--- a/arch/powerpc/kernel/head_fsl_booke.S
+++ b/arch/powerpc/kernel/head_fsl_booke.S
@@ -30,6 +30,7 @@
  * option) any later version.
  */
 
+#include <linux/module.h>
 #include <linux/threads.h>
 #include <asm/processor.h>
 #include <asm/page.h>
@@ -902,6 +903,7 @@ _GLOBAL(loadcam_entry)
  */
 _GLOBAL(giveup_altivec)
 	blr
+EXPORT_SYMBOL(giveup_altivec)
 
 #ifdef CONFIG_SPE
 /*
@@ -938,6 +940,7 @@ _GLOBAL(giveup_spe)
 #endif /* !CONFIG_SMP */
 	blr
 #endif /* CONFIG_SPE */
+EXPORT_SYMBOL(giveup_spe)
 
 /*
  * extern void giveup_fpu(struct task_struct *prev)
@@ -947,6 +950,7 @@ _GLOBAL(giveup_spe)
 #ifndef CONFIG_PPC_FPU
 _GLOBAL(giveup_fpu)
 	blr
+EXPORT_SYMBOL(giveup_fpu)
 #endif
 
 /*
@@ -980,6 +984,7 @@ _GLOBAL(set_context)
 	mtspr	SPRN_PID,r3
 	isync			/* Force context change */
 	blr
+EXPORT_SYMBOL(set_context)
 
 _GLOBAL(flush_dcache_L1)
 	mfspr	r3,SPRN_L1CFG0
@@ -1038,6 +1043,7 @@ sdata:
 	.globl	empty_zero_page
 empty_zero_page:
 	.space	4096
+EXPORT_SYMBOL(empty_zero_page)
 	.globl	swapper_pg_dir
 swapper_pg_dir:
 	.space	PGD_TABLE_SIZE
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index d972dec..e6a9af6 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -83,9 +83,10 @@ extern int tau_interrupts(int);
 #endif
 #endif /* CONFIG_PPC32 */
 
-#ifdef CONFIG_PPC64
 EXPORT_SYMBOL(irq_desc);
 
+#ifdef CONFIG_PPC64
+
 int distribute_irqs = 1;
 
 static inline notrace unsigned long get_hard_enabled(void)
@@ -334,6 +335,7 @@ void do_IRQ(struct pt_regs *regs)
 	}
 #endif
 }
+EXPORT_SYMBOL(do_IRQ);
 
 void __init init_IRQ(void)
 {
diff --git a/arch/powerpc/kernel/misc_32.S b/arch/powerpc/kernel/misc_32.S
index 6321ae3..d8c8b82 100644
--- a/arch/powerpc/kernel/misc_32.S
+++ b/arch/powerpc/kernel/misc_32.S
@@ -16,6 +16,7 @@
  *
  */
 
+#include <linux/module.h>
 #include <linux/sys.h>
 #include <asm/unistd.h>
 #include <asm/errno.h>
@@ -435,6 +436,7 @@ _GLOBAL(_tlbie)
 #endif /* CONFIG_SMP */
 #endif /* ! CONFIG_40x */
 	blr
+EXPORT_SYMBOL(_tlbie)
 
 /*
  * Flush instruction cache.
@@ -481,6 +483,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_UNIFIED_ID_CACHE)
 #endif /* CONFIG_8xx/4xx */
 	isync
 	blr
+EXPORT_SYMBOL(flush_instruction_cache)
 
 /*
  * Write any modified data cache blocks out to memory
@@ -512,6 +515,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_COHERENT_ICACHE)
 	sync				/* additional sync needed on g4 */
 	isync
 	blr
+EXPORT_SYMBOL(__flush_icache_range)
 /*
  * Write any modified data cache blocks out to memory.
  * Does not invalidate the corresponding cache lines (especially for
@@ -554,6 +558,7 @@ _GLOBAL(flush_dcache_range)
 	bdnz	1b
 	sync				/* wait for dcbst's to get to ram */
 	blr
+EXPORT_SYMBOL(flush_dcache_range)
 
 /*
  * Like above, but invalidate the D-cache.  This is used by the 8xx
@@ -670,6 +675,7 @@ _GLOBAL(clear_pages)
 	addi	r3,r3,L1_CACHE_BYTES
 	bdnz	1b
 	blr
+EXPORT_SYMBOL(clear_pages)
 
 /*
  * Copy a whole page.  We use the dcbz instruction on the destination
@@ -741,6 +747,7 @@ _GLOBAL(copy_page)
 	li	r11,4
 	b	2b
 #endif	/* CONFIG_8xx */
+EXPORT_SYMBOL(copy_page)
 
 /*
  * void atomic_clear_mask(atomic_t mask, atomic_t *addr)
@@ -787,6 +794,7 @@ _GLOBAL(__ashrdi3)
 	sraw	r3,r3,r5	# MSW = MSW >> count
 	or	r4,r4,r7	# LSW |= t2
 	blr
+EXPORT_SYMBOL(__ashrdi3)
 
 _GLOBAL(__ashldi3)
 	subfic	r6,r5,32
@@ -798,6 +806,7 @@ _GLOBAL(__ashldi3)
 	slw	r4,r4,r5	# LSW = LSW << count
 	or	r3,r3,r7	# MSW |= t2
 	blr
+EXPORT_SYMBOL(__ashldi3)
 
 _GLOBAL(__lshrdi3)
 	subfic	r6,r5,32
@@ -809,6 +818,7 @@ _GLOBAL(__lshrdi3)
 	srw	r3,r3,r5	# MSW = MSW >> count
 	or	r4,r4,r7	# LSW |= t2
 	blr
+EXPORT_SYMBOL(__lshrdi3)
 
 /*
  * 64-bit comparison: __ucmpdi2(u64 a, u64 b)
@@ -824,6 +834,7 @@ _GLOBAL(__ucmpdi2)
 	bltlr
 	li	r3,2
 	blr
+EXPORT_SYMBOL(__ucmpdi2);
 
 _GLOBAL(abs)
 	srawi	r4,r3,31
@@ -861,6 +872,7 @@ _GLOBAL(kernel_thread)
 	lwz	r31,12(r1)
 	addi	r1,r1,16
 	blr
+EXPORT_SYMBOL(kernel_thread)
 
 /*
  * This routine is just here to keep GCC happy - sigh...
diff --git a/arch/powerpc/kernel/misc_64.S b/arch/powerpc/kernel/misc_64.S
index 4dd70cf..b1d05c0 100644
--- a/arch/powerpc/kernel/misc_64.S
+++ b/arch/powerpc/kernel/misc_64.S
@@ -14,6 +14,7 @@
  *
  */
 
+#include <linux/module.h>
 #include <linux/sys.h>
 #include <asm/unistd.h>
 #include <asm/errno.h>
@@ -108,6 +109,7 @@ _KPROBE(__flush_icache_range)
 	isync
 	blr
 	.previous .text
+EXPORT_SYMBOL(__flush_icache_range)
 /*
  * Like above, but only do the D-cache.
  *
@@ -137,6 +139,7 @@ _GLOBAL(flush_dcache_range)
 	bdnz	0b
 	sync
 	blr
+EXPORT_SYMBOL(flush_dcache_range)
 
 /*
  * Like above, but works on non-mapped physical addresses.
@@ -442,6 +445,7 @@ _GLOBAL(kernel_thread)
 	ld	r29,-24(r1)
 	ld	r30,-16(r1)
 	blr
+EXPORT_SYMBOL(kernel_thread)
 
 /*
  * disable_kernel_fp()
@@ -503,6 +507,7 @@ _GLOBAL(giveup_altivec)
 	std	r5,0(r4)
 #endif /* CONFIG_SMP */
 	blr
+EXPORT_SYMBOL(giveup_altivec)
 
 #endif /* CONFIG_ALTIVEC */
 
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index 224e9a1..3e7b258 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -23,6 +23,7 @@
 #include <linux/string.h>
 #include <linux/init.h>
 #include <linux/bootmem.h>
+#include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/list.h>
 #include <linux/syscalls.h>
@@ -52,6 +53,7 @@ static int global_phb_number;		/* Global phb counter */
 
 /* ISA Memory physical address */
 resource_size_t isa_mem_base;
+EXPORT_SYMBOL(isa_mem_base);
 
 /* Default PCI flags is 0 */
 unsigned int ppc_pci_flags;
diff --git a/arch/powerpc/kernel/pci_32.c b/arch/powerpc/kernel/pci_32.c
index 88db4ff..329acae 100644
--- a/arch/powerpc/kernel/pci_32.c
+++ b/arch/powerpc/kernel/pci_32.c
@@ -3,6 +3,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/string.h>
@@ -33,7 +34,9 @@
 #endif
 
 unsigned long isa_io_base     = 0;
+EXPORT_SYMBOL(isa_io_base);
 unsigned long pci_dram_offset = 0;
+EXPORT_SYMBOL(pci_dram_offset);
 int pcibios_assign_bus_offset = 1;
 
 void pcibios_make_OF_bus_map(void);
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 957bded..c832697 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -167,6 +167,7 @@ void giveup_vsx(struct task_struct *tsk)
 	giveup_altivec(tsk);
 	__giveup_vsx(tsk);
 }
+EXPORT_SYMBOL(giveup_vsx);
 
 void flush_vsx_to_thread(struct task_struct *tsk)
 {
@@ -760,6 +761,7 @@ void start_thread(struct pt_regs *regs, unsigned long start, unsigned long sp)
 	current->thread.used_spe = 0;
 #endif /* CONFIG_SPE */
 }
+EXPORT_SYMBOL(start_thread);
 
 #define PR_FP_ALL_EXCEPT (PR_FP_EXC_DIV | PR_FP_EXC_OVF | PR_FP_EXC_UND \
 		| PR_FP_EXC_RES | PR_FP_EXC_INV)
diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index 9cc5a52..174614d 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -91,6 +91,7 @@ struct screen_info screen_info = {
 	.orig_video_isVGA = 1,
 	.orig_video_points = 16
 };
+EXPORT_SYMBOL(screen_info);
 
 #ifdef __DO_IRQ_CANON
 /* XXX should go elsewhere eventually */
diff --git a/arch/powerpc/kernel/setup_32.c b/arch/powerpc/kernel/setup_32.c
index 066e65c..f871152 100644
--- a/arch/powerpc/kernel/setup_32.c
+++ b/arch/powerpc/kernel/setup_32.c
@@ -50,8 +50,13 @@ EXPORT_SYMBOL_GPL(boot_cpuid);
 int boot_cpuid_phys;
 
 unsigned long ISA_DMA_THRESHOLD;
+EXPORT_SYMBOL(ISA_DMA_THRESHOLD);
+
 unsigned int DMA_MODE_READ;
+EXPORT_SYMBOL(DMA_MODE_READ);
+
 unsigned int DMA_MODE_WRITE;
+EXPORT_SYMBOL(DMA_MODE_WRITE);
 
 int have_of = 1;
 
diff --git a/arch/powerpc/kernel/signal_32.c b/arch/powerpc/kernel/signal_32.c
index 3e80aa3..ca17314 100644
--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -25,6 +25,7 @@
 #include <linux/errno.h>
 #include <linux/elf.h>
 #include <linux/ptrace.h>
+#include <linux/module.h>
 #ifdef CONFIG_PPC64
 #include <linux/syscalls.h>
 #include <linux/compat.h>
@@ -1288,3 +1289,4 @@ badframe:
 	force_sig(SIGSEGV, current);
 	return 0;
 }
+EXPORT_SYMBOL(sys_sigreturn);
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 5337ca7..65f4c3a 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -58,6 +58,8 @@
 #endif
 
 int smp_hw_index[NR_CPUS];
+EXPORT_SYMBOL(smp_hw_index);
+
 struct thread_info *secondary_ti;
 
 cpumask_t cpu_possible_map = CPU_MASK_NONE;
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index e2ee66b..fc4646d 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -142,6 +142,7 @@ static void __init clocksource_init(void);
 #endif
 
 unsigned long tb_ticks_per_jiffy;
+EXPORT_SYMBOL(tb_ticks_per_jiffy);
 unsigned long tb_ticks_per_usec = 100; /* sane default */
 EXPORT_SYMBOL(tb_ticks_per_usec);
 unsigned long tb_ticks_per_sec;
@@ -612,6 +613,7 @@ void timer_interrupt(struct pt_regs * regs)
 	irq_exit();
 	set_irq_regs(old_regs);
 }
+EXPORT_SYMBOL(timer_interrupt);
 
 void wakeup_decrementer(void)
 {
@@ -1091,6 +1093,7 @@ void to_tm(int tim, struct rtc_time * tm)
 	 */
 	GregorianDay(tm);
 }
+EXPORT_SYMBOL(to_tm);
 
 /* Auxiliary function to compute scaling factors */
 /* Actually the choice of a timebase running at 1/4 the of the bus
diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index 81ccb8d..8d9c77a 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -533,6 +533,7 @@ void machine_check_exception(struct pt_regs *regs)
 	if (!(regs->msr & MSR_RI))
 		panic("Unrecoverable Machine check");
 }
+EXPORT_SYMBOL(machine_check_exception);
 
 void SMIException(struct pt_regs *regs)
 {
@@ -574,6 +575,7 @@ void __kprobes single_step_exception(struct pt_regs *regs)
 
 	_exception(SIGTRAP, regs, TRAP_TRACE, regs->nip);
 }
+EXPORT_SYMBOL(single_step_exception);
 
 /*
  * After we have successfully emulated an instruction, we have to
@@ -893,6 +895,7 @@ void __kprobes program_check_exception(struct pt_regs *regs)
 	else
 		_exception(SIGILL, regs, ILL_ILLOPC, regs->nip);
 }
+EXPORT_SYMBOL(program_check_exception);
 
 void alignment_exception(struct pt_regs *regs)
 {
@@ -921,6 +924,7 @@ void alignment_exception(struct pt_regs *regs)
 	else
 		bad_page_fault(regs, regs->dar, sig);
 }
+EXPORT_SYMBOL(alignment_exception);
 
 void StackOverflow(struct pt_regs *regs)
 {
diff --git a/arch/powerpc/lib/checksum_32.S b/arch/powerpc/lib/checksum_32.S
index 7874e8a..194d9bb 100644
--- a/arch/powerpc/lib/checksum_32.S
+++ b/arch/powerpc/lib/checksum_32.S
@@ -12,6 +12,7 @@
  * Severely hacked about by Paul Mackerras (paulus@cs.anu.edu.au).
  */
 
+#include <linux/module.h>
 #include <linux/sys.h>
 #include <asm/processor.h>
 #include <asm/errno.h>
@@ -39,6 +40,7 @@ _GLOBAL(ip_fast_csum)
 	not	r3,r3
 	srwi	r3,r3,16
 	blr
+EXPORT_SYMBOL(ip_fast_csum)
 
 /*
  * Compute checksum of TCP or UDP pseudo-header:
@@ -55,6 +57,7 @@ _GLOBAL(csum_tcpudp_magic)
 	not	r3,r3
 	srwi	r3,r3,16
 	blr
+EXPORT_SYMBOL(csum_tcpudp_magic)
 
 /*
  * computes the checksum of a memory block at buff, length len,
@@ -93,6 +96,7 @@ _GLOBAL(csum_partial)
 	adde	r0,r0,r5
 5:	addze	r3,r0		/* add in final carry */
 	blr
+EXPORT_SYMBOL(csum_partial)
 
 /*
  * Computes the checksum of a memory block at src, length len,
@@ -203,6 +207,8 @@ dst_error:
 1:	addze	r3,r0
 	blr
 
+EXPORT_SYMBOL(csum_partial_copy_generic)
+
 .section __ex_table,"a"
 	.long	81b,src_error_1
 	.long	91b,dst_error
diff --git a/arch/powerpc/lib/checksum_64.S b/arch/powerpc/lib/checksum_64.S
index ef96c6c..c6a7b67 100644
--- a/arch/powerpc/lib/checksum_64.S
+++ b/arch/powerpc/lib/checksum_64.S
@@ -12,6 +12,7 @@
  * Severely hacked about by Paul Mackerras (paulus@cs.anu.edu.au).
  */
 
+#include <linux/module.h>
 #include <linux/sys.h>
 #include <asm/processor.h>
 #include <asm/errno.h>
@@ -43,6 +44,7 @@ _GLOBAL(ip_fast_csum)
 	not	r3,r3
 	srwi	r3,r3,16
 	blr
+EXPORT_SYMBOL(ip_fast_csum)
 
 /*
  * Compute checksum of TCP or UDP pseudo-header:
@@ -64,6 +66,7 @@ _GLOBAL(csum_tcpudp_magic)
 	not	r3,r3
 	srwi	r3,r3,16
 	blr
+EXPORT_SYMBOL(csum_tcpudp_magic)
 
 /*
  * Computes the checksum of a memory block at buff, length len,
@@ -114,6 +117,7 @@ _GLOBAL(csum_partial)
         add     r3,r4,r5
         srdi    r3,r3,32
         blr
+EXPORT_SYMBOL(csum_partial)
 
 /*
  * Computes the checksum of a memory block at src, length len,
@@ -169,6 +173,7 @@ _GLOBAL(csum_partial_copy_generic)
         add     r3,r4,r3
         srdi    r3,r3,32
 	blr
+EXPORT_SYMBOL(csum_partial_copy_generic)
 
 /* These shouldn't go in the fixup section, since that would
    cause the ex_table addresses to get out of order. */
diff --git a/arch/powerpc/lib/copy_32.S b/arch/powerpc/lib/copy_32.S
index c657de5..aa3645d 100644
--- a/arch/powerpc/lib/copy_32.S
+++ b/arch/powerpc/lib/copy_32.S
@@ -8,6 +8,7 @@
  * as published by the Free Software Foundation; either version
  * 2 of the License, or (at your option) any later version.
  */
+#include <linux/module.h>
 #include <asm/processor.h>
 #include <asm/cache.h>
 #include <asm/errno.h>
@@ -154,6 +155,7 @@ _GLOBAL(memset)
 8:	stbu	r4,1(r6)
 	bdnz	8b
 	blr
+EXPORT_SYMBOL(memset)
 
 /*
  * This version uses dcbz on the complete cache lines in the
@@ -235,6 +237,7 @@ _GLOBAL(cacheable_memcpy)
 	addi	r6,r6,1
 	bdnz	40b
 65:	blr
+EXPORT_SYMBOL(cacheable_memcpy)
 
 _GLOBAL(memmove)
 	cmplw	0,r3,r4
@@ -281,6 +284,8 @@ _GLOBAL(memcpy)
 	beq	2b
 	mtctr	r7
 	b	1b
+EXPORT_SYMBOL(memmove)
+EXPORT_SYMBOL(memcpy)
 
 _GLOBAL(backwards_memcpy)
 	rlwinm.	r7,r5,32-3,3,31		/* r0 = r5 >> 3 */
@@ -540,3 +545,5 @@ _GLOBAL(__copy_tofrom_user)
 	.long	112b,120b
 	.long	114b,120b
 	.text
+
+EXPORT_SYMBOL(__copy_tofrom_user)
diff --git a/arch/powerpc/lib/copypage_64.S b/arch/powerpc/lib/copypage_64.S
index f9837f4..e81ffa2 100644
--- a/arch/powerpc/lib/copypage_64.S
+++ b/arch/powerpc/lib/copypage_64.S
@@ -6,6 +6,7 @@
  * as published by the Free Software Foundation; either version
  * 2 of the License, or (at your option) any later version.
  */
+#include <linux/module.h>
 #include <asm/processor.h>
 #include <asm/ppc_asm.h>
 
@@ -117,3 +118,5 @@ _GLOBAL(copy_4K_page)
 	ld	r30,-16(1)
 	ld	r31,-8(1)
 	blr
+
+EXPORT_SYMBOL(copy_4K_page)
diff --git a/arch/powerpc/lib/copyuser_64.S b/arch/powerpc/lib/copyuser_64.S
index 25ec537..2342fd6 100644
--- a/arch/powerpc/lib/copyuser_64.S
+++ b/arch/powerpc/lib/copyuser_64.S
@@ -6,6 +6,7 @@
  * as published by the Free Software Foundation; either version
  * 2 of the License, or (at your option) any later version.
  */
+#include <linux/module.h>
 #include <asm/processor.h>
 #include <asm/ppc_asm.h>
 
@@ -572,3 +573,5 @@ _GLOBAL(__copy_tofrom_user)
 	.llong	89b,100b
 	.llong	90b,100b
 	.llong	91b,100b
+
+EXPORT_SYMBOL(__copy_tofrom_user)
diff --git a/arch/powerpc/lib/mem_64.S b/arch/powerpc/lib/mem_64.S
index 11ce045..2a18d58 100644
--- a/arch/powerpc/lib/mem_64.S
+++ b/arch/powerpc/lib/mem_64.S
@@ -8,6 +8,7 @@
  * as published by the Free Software Foundation; either version
  * 2 of the License, or (at your option) any later version.
  */
+#include <linux/module.h>
 #include <asm/processor.h>
 #include <asm/errno.h>
 #include <asm/ppc_asm.h>
@@ -76,11 +77,13 @@ _GLOBAL(memset)
 10:	bflr	31
 	stb	r4,0(r6)
 	blr
+EXPORT_SYMBOL(memset)
 
 _GLOBAL(memmove)
 	cmplw	0,r3,r4
 	bgt	.backwards_memcpy
 	b	.memcpy
+EXPORT_SYMBOL(memmove)
 
 _GLOBAL(backwards_memcpy)
 	rlwinm.	r7,r5,32-3,3,31		/* r0 = r5 >> 3 */
diff --git a/arch/powerpc/lib/memcpy_64.S b/arch/powerpc/lib/memcpy_64.S
index 3f13112..839945b 100644
--- a/arch/powerpc/lib/memcpy_64.S
+++ b/arch/powerpc/lib/memcpy_64.S
@@ -6,6 +6,7 @@
  * as published by the Free Software Foundation; either version
  * 2 of the License, or (at your option) any later version.
  */
+#include <linux/module.h>
 #include <asm/processor.h>
 #include <asm/ppc_asm.h>
 
@@ -171,3 +172,5 @@ _GLOBAL(memcpy)
 	stb	r0,0(r3)
 4:	ld	r3,48(r1)	/* return dest pointer */
 	blr
+
+EXPORT_SYMBOL(memcpy)
diff --git a/arch/powerpc/lib/string.S b/arch/powerpc/lib/string.S
index 64e2e49..929100a 100644
--- a/arch/powerpc/lib/string.S
+++ b/arch/powerpc/lib/string.S
@@ -8,6 +8,7 @@
  * as published by the Free Software Foundation; either version
  * 2 of the License, or (at your option) any later version.
  */
+#include <linux/module.h>
 #include <asm/processor.h>
 #include <asm/errno.h>
 #include <asm/ppc_asm.h>
@@ -24,6 +25,7 @@ _GLOBAL(strcpy)
 	stbu	r0,1(r5)
 	bne	1b
 	blr
+EXPORT_SYMBOL(strcpy)
 
 /* This clears out any unused part of the destination buffer,
    just as the libc version does.  -- paulus */
@@ -44,6 +46,7 @@ _GLOBAL(strncpy)
 2:	stbu	r0,1(r6)	/* clear it out if so */
 	bdnz	2b
 	blr
+EXPORT_SYMBOL(strncpy)
 
 _GLOBAL(strcat)
 	addi	r5,r3,-1
@@ -57,6 +60,7 @@ _GLOBAL(strcat)
 	stbu	r0,1(r5)
 	bne	1b
 	blr
+EXPORT_SYMBOL(strcat)
 
 _GLOBAL(strcmp)
 	addi	r5,r3,-1
@@ -68,6 +72,7 @@ _GLOBAL(strcmp)
 	beqlr	1
 	beq	1b
 	blr
+EXPORT_SYMBOL(strcmp)
 
 _GLOBAL(strncmp)
 	PPC_LCMPI r5,0
@@ -82,6 +87,7 @@ _GLOBAL(strncmp)
 	beqlr	1
 	bdnzt	eq,1b
 	blr
+EXPORT_SYMBOL(strncmp)
 
 _GLOBAL(strlen)
 	addi	r4,r3,-1
@@ -90,6 +96,7 @@ _GLOBAL(strlen)
 	bne	1b
 	subf	r3,r3,r4
 	blr
+EXPORT_SYMBOL(strlen)
 
 _GLOBAL(memcmp)
 	cmpwi	0,r5,0
@@ -104,6 +111,7 @@ _GLOBAL(memcmp)
 	blr
 2:	li	r3,0
 	blr
+EXPORT_SYMBOL(memcmp)
 
 _GLOBAL(memchr)
 	cmpwi	0,r5,0
@@ -116,6 +124,7 @@ _GLOBAL(memchr)
 	beqlr
 2:	li	r3,0
 	blr
+EXPORT_SYMBOL(memchr)
 
 _GLOBAL(__clear_user)
 	addi	r6,r3,-4
@@ -158,6 +167,7 @@ _GLOBAL(__clear_user)
 	PPC_LONG	1b,91b
 	PPC_LONG	8b,92b
 	.text
+EXPORT_SYMBOL(__clear_user)
 
 _GLOBAL(__strncpy_from_user)
 	addi	r6,r3,-1
@@ -179,6 +189,7 @@ _GLOBAL(__strncpy_from_user)
 	.section __ex_table,"a"
 	PPC_LONG	1b,99b
 	.text
+EXPORT_SYMBOL(__strncpy_from_user)
 
 /* r3 = str, r4 = len (> 0), r5 = top (highest addr) */
 _GLOBAL(__strnlen_user)
@@ -203,3 +214,4 @@ _GLOBAL(__strnlen_user)
 
 	.section __ex_table,"a"
 	PPC_LONG	1b,99b
+EXPORT_SYMBOL(__strnlen_user)
diff --git a/arch/powerpc/mm/hash_low_32.S b/arch/powerpc/mm/hash_low_32.S
index b9ba7d9..ac9bef1 100644
--- a/arch/powerpc/mm/hash_low_32.S
+++ b/arch/powerpc/mm/hash_low_32.S
@@ -19,6 +19,7 @@
  *
  */
 
+#include <linux/module.h>
 #include <asm/reg.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
@@ -33,6 +34,7 @@
 	.globl mmu_hash_lock
 mmu_hash_lock:
 	.space	4
+EXPORT_SYMBOL(mmu_hash_lock); /* For MOL */
 #endif /* CONFIG_SMP */
 
 /*
@@ -609,3 +611,5 @@ _GLOBAL(flush_hash_patch_B)
 	SYNC_601
 	isync
 	blr
+
+EXPORT_SYMBOL(flush_hash_pages); /* For MOL */
diff --git a/arch/powerpc/mm/mmu_context_32.c b/arch/powerpc/mm/mmu_context_32.c
index cc32ba4..b990cc4 100644
--- a/arch/powerpc/mm/mmu_context_32.c
+++ b/arch/powerpc/mm/mmu_context_32.c
@@ -23,12 +23,14 @@
  */
 
 #include <linux/mm.h>
+#include <linux/module.h>
 #include <linux/init.h>
 
 #include <asm/mmu_context.h>
 #include <asm/tlbflush.h>
 
 unsigned long next_mmu_context;
+EXPORT_SYMBOL(next_mmu_context);
 unsigned long context_map[LAST_CONTEXT / BITS_PER_LONG + 1];
 #ifdef FEW_CONTEXTS
 atomic_t nr_free_contexts;
diff --git a/arch/powerpc/mm/tlb_32.c b/arch/powerpc/mm/tlb_32.c
index eb4b512..2523d71 100644
--- a/arch/powerpc/mm/tlb_32.c
+++ b/arch/powerpc/mm/tlb_32.c
@@ -24,6 +24,7 @@
 
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/module.h>
 #include <linux/init.h>
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
@@ -136,6 +137,7 @@ void flush_tlb_kernel_range(unsigned long start, unsigned long end)
 	flush_range(&init_mm, start, end);
 	FINISH_FLUSH;
 }
+EXPORT_SYMBOL(flush_tlb_kernel_range);
 
 /*
  * Flush all the (user) entries for the address space described by mm.
@@ -175,6 +177,7 @@ void flush_tlb_page(struct vm_area_struct *vma, unsigned long vmaddr)
 		flush_hash_pages(mm->context.id, vmaddr, pmd_val(*pmd), 1);
 	FINISH_FLUSH;
 }
+EXPORT_SYMBOL(flush_tlb_page);
 
 /*
  * For each address in the range, find the pte for the address
diff --git a/arch/powerpc/sysdev/dcr-low.S b/arch/powerpc/sysdev/dcr-low.S
index 2078f39..27bc06c 100644
--- a/arch/powerpc/sysdev/dcr-low.S
+++ b/arch/powerpc/sysdev/dcr-low.S
@@ -9,6 +9,7 @@
  * option) any later version.
  */
 
+#include <linux/module.h>
 #include <asm/ppc_asm.h>
 #include <asm/processor.h>
 
@@ -22,9 +23,11 @@
 
 _GLOBAL(__mfdcr)
 	DCR_ACCESS_PROLOG(__mfdcr_table)
+EXPORT_SYMBOL(__mfdcr);
 
 _GLOBAL(__mtdcr)
 	DCR_ACCESS_PROLOG(__mtdcr_table)
+EXPORT_SYMBOL(__mtdcr);
 
 __mfdcr_table:
 	mfdcr  r3,0; blr
iff --git a/drivers/macintosh/adb.c b/drivers/macintosh/adb.c
index cae5248..b915cc4 100644
--- a/drivers/macintosh/adb.c
+++ b/drivers/macintosh/adb.c
@@ -390,6 +390,7 @@ adb_poll(void)
 		return;
 	adb_controller->poll();
 }
+EXPORT_SYMBOL(adb_poll);
 
 static void adb_sync_req_done(struct adb_request *req)
 {
@@ -439,6 +440,7 @@ adb_request(struct adb_request *req, void (*done)(struct adb_request *),
 
 	return rc;
 }
+EXPORT_SYMBOL(adb_request);
 
  /* Ultimately this should return the number of devices with
     the given default id.
@@ -474,6 +476,7 @@ adb_register(int default_id, int handler_id, struct adb_ids *ids,
 	mutex_unlock(&adb_handler_mutex);
 	return ids->nids;
 }
+EXPORT_SYMBOL(adb_register);
 
 int
 adb_unregister(int index)
@@ -495,6 +498,7 @@ adb_unregister(int index)
 	mutex_unlock(&adb_handler_mutex);
 	return ret;
 }
+EXPORT_SYMBOL(adb_unregister);
 
 void
 adb_input(unsigned char *buf, int nb, int autopoll)
@@ -561,6 +565,7 @@ adb_try_handler_change(int address, int new_id)
 	mutex_unlock(&adb_handler_mutex);
 	return ret;
 }
+EXPORT_SYMBOL(adb_try_handler_change);
 
 int
 adb_get_infos(int address, int *original_address, int *handler_id)
diff --git a/drivers/macintosh/via-cuda.c b/drivers/macintosh/via-cuda.c
index 741a93a..91dd6bf 100644
--- a/drivers/macintosh/via-cuda.c
+++ b/drivers/macintosh/via-cuda.c
@@ -10,6 +10,7 @@
  */
 #include <stdarg.h>
 #include <linux/types.h>
+#include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
@@ -375,6 +376,7 @@ cuda_request(struct adb_request *req, void (*done)(struct adb_request *),
     req->reply_expected = 1;
     return cuda_write(req);
 }
+EXPORT_SYMBOL(cuda_request);
 
 static int
 cuda_write(struct adb_request *req)
@@ -435,6 +437,7 @@ cuda_poll(void)
     cuda_interrupt(0, NULL);
     enable_irq(cuda_irq);
 }
+EXPORT_SYMBOL(cuda_poll);
 
 static irqreturn_t
 cuda_interrupt(int irq, void *arg)

