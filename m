Return-Path: <linux-kernel-owner+w=401wt.eu-S1752731AbYLULNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbYLULNK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 06:13:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbYLULMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 06:12:55 -0500
Received: from harold.telenet-ops.be ([195.130.133.65]:51142 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbYLULMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 06:12:51 -0500
Date: Sun, 21 Dec 2008 12:12:44 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Rusty Russell <rusty@rustcorp.com.au>, linux-next@vger.kernel.org,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] m68k: Kill several external declarations in source files
 (was: Re: linux-next: boot-params tree build failure)
In-Reply-To: <Pine.LNX.4.64.0812170915400.29433@anakin>
Message-ID: <Pine.LNX.4.64.0812211205270.3499@anakin>
References: <20081217165557.b4898a4b.sfr@canb.auug.org.au>
 <Pine.LNX.4.64.0812170915400.29433@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2008, Geert Uytterhoeven wrote:
> On Wed, 17 Dec 2008, Stephen Rothwell wrote:
> > The build of next-20081216 (m68k defconfig) failed like this:
> > 
> > arch/m68k/kernel/setup.c:230: error: conflicting types for '_end'
> > arch/m68k/kernel/setup.c:215: error: previous declaration of '_end' was here
> > 
> > Caused by commit 0de5c2d9f02d2018fd671ca1015432dffa5eb338 ("param:
> > arch_get_boot_command_line()") from the poot-params tree.
> 
> This is due to the existing
> 
>     extern int _etext, _edata, _end;
> 
> in and the newly added
> 
>     extern char _end[];
> 
> to arch/m68k/kernel/setup.c.
> 
> As these are already declared in asm-generic/sections.h (which is used by
> asm-m68k/sections.h), I'll switch arch/m68k/kernel/setup.c to using them.

Subject: [PATCH] m68k: Kill several external declarations in source files
    
  - Replace external declarations by proper includes where availiable.
    The accesses to some symbols had to be modified, as before they were
    declared using e.g. "extern int _end", while asm-generic/sections.h uses
    e.g. "extern char _end[]"
  - Remove unused or superfluous external declarations

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Shall I cherry pick this into my for-next branch (breaking Rusty's changes),
or wait until the current linux-next has been merged by Linus (and maybe
postpone to .30)?

 arch/m68k/apollo/config.c   |    4 ----
 arch/m68k/atari/atakeyb.c   |    1 -
 arch/m68k/bvme6000/config.c |    1 -
 arch/m68k/kernel/setup.c    |   11 +++++------
 arch/m68k/mac/config.c      |   12 ------------
 arch/m68k/mac/debug.c       |    1 -
 arch/m68k/mac/macints.c     |   10 +---------
 arch/m68k/mac/misc.c        |    1 -
 arch/m68k/mac/via.c         |    2 +-
 arch/m68k/math-emu/fp_log.c |    1 -
 arch/m68k/mm/init.c         |    4 +---
 arch/m68k/mm/motorola.c     |    7 +++----
 arch/m68k/mvme147/config.c  |    1 -
 arch/m68k/mvme16x/config.c  |    1 -
 arch/m68k/q40/config.c      |    3 ---
 arch/m68k/sun3/config.c     |    8 +++-----
 arch/m68k/sun3/mmu_emu.c    |    1 -
 arch/m68k/sun3x/config.c    |    1 -
 18 files changed, 14 insertions(+), 56 deletions(-)

diff --git a/arch/m68k/apollo/config.c b/arch/m68k/apollo/config.c
index 78df98f..cf215a0 100644
--- a/arch/m68k/apollo/config.c
+++ b/arch/m68k/apollo/config.c
@@ -31,10 +31,6 @@ extern unsigned long dn_gettimeoffset(void);
 extern int dn_dummy_hwclk(int, struct rtc_time *);
 extern int dn_dummy_set_clock_mmss(unsigned long);
 extern void dn_dummy_reset(void);
-extern void dn_dummy_waitbut(void);
-extern struct fb_info *dn_fb_init(long *);
-extern void dn_dummy_debug_init(void);
-extern irqreturn_t dn_process_int(int irq, struct pt_regs *fp);
 #ifdef CONFIG_HEARTBEAT
 static void dn_heartbeat(int on);
 #endif
diff --git a/arch/m68k/atari/atakeyb.c b/arch/m68k/atari/atakeyb.c
index 2c16dcb..dedfc09 100644
--- a/arch/m68k/atari/atakeyb.c
+++ b/arch/m68k/atari/atakeyb.c
@@ -33,7 +33,6 @@
 #include <asm/atari_joystick.h>
 #include <asm/irq.h>
 
-extern unsigned int keymap_count;
 
 /* Hook for MIDI serial driver */
 void (*atari_MIDI_interrupt_hook) (void);
diff --git a/arch/m68k/bvme6000/config.c b/arch/m68k/bvme6000/config.c
index c072595..9fe6fef 100644
--- a/arch/m68k/bvme6000/config.c
+++ b/arch/m68k/bvme6000/config.c
@@ -43,7 +43,6 @@ extern unsigned long bvme6000_gettimeoffset (void);
 extern int bvme6000_hwclk (int, struct rtc_time *);
 extern int bvme6000_set_clock_mmss (unsigned long);
 extern void bvme6000_reset (void);
-extern void bvme6000_waitbut(void);
 void bvme6000_set_vectors (void);
 
 /* Save tick handler routine pointer, will point to do_timer() in
diff --git a/arch/m68k/kernel/setup.c b/arch/m68k/kernel/setup.c
index 066faec..594cbd1 100644
--- a/arch/m68k/kernel/setup.c
+++ b/arch/m68k/kernel/setup.c
@@ -26,6 +26,7 @@
 #include <linux/initrd.h>
 
 #include <asm/bootinfo.h>
+#include <asm/sections.h>
 #include <asm/setup.h>
 #include <asm/fpu.h>
 #include <asm/irq.h>
@@ -63,7 +64,6 @@ EXPORT_SYMBOL(vme_brdtype);
 int m68k_is040or060;
 EXPORT_SYMBOL(m68k_is040or060);
 
-extern int end;
 extern unsigned long availmem;
 
 int m68k_num_memory;
@@ -216,11 +216,10 @@ static void __init m68k_parse_bootinfo(const struct bi_record *record)
 
 void __init setup_arch(char **cmdline_p)
 {
-	extern int _etext, _edata, _end;
 	int i;
 
 	/* The bootinfo is located right after the kernel bss */
-	m68k_parse_bootinfo((const struct bi_record *)&_end);
+	m68k_parse_bootinfo((const struct bi_record *)_end);
 
 	if (CPU_IS_040)
 		m68k_is040or060 = 4;
@@ -253,9 +252,9 @@ void __init setup_arch(char **cmdline_p)
 	}
 
 	init_mm.start_code = PAGE_OFFSET;
-	init_mm.end_code = (unsigned long) &_etext;
-	init_mm.end_data = (unsigned long) &_edata;
-	init_mm.brk = (unsigned long) &_end;
+	init_mm.end_code = (unsigned long)_etext;
+	init_mm.end_data = (unsigned long)_edata;
+	init_mm.brk = (unsigned long)_end;
 
 	*cmdline_p = m68k_command_line;
 	memcpy(boot_command_line, *cmdline_p, CL_SIZE);
diff --git a/arch/m68k/mac/config.c b/arch/m68k/mac/config.c
index a7b42ac..be01798 100644
--- a/arch/m68k/mac/config.c
+++ b/arch/m68k/mac/config.c
@@ -52,13 +52,6 @@
 
 struct mac_booter_data mac_bi_data;
 
-/* New m68k bootinfo stuff and videobase */
-
-extern int m68k_num_memory;
-extern struct mem_info m68k_memory[NUM_MEMINFO];
-
-extern struct mem_info m68k_ramdisk;
-
 /* The phys. video addr. - might be bogus on some machines */
 static unsigned long mac_orig_videoaddr;
 
@@ -66,7 +59,6 @@ static unsigned long mac_orig_videoaddr;
 extern unsigned long mac_gettimeoffset(void);
 extern int mac_hwclk(int, struct rtc_time *);
 extern int mac_set_clock_mmss(unsigned long);
-extern int show_mac_interrupts(struct seq_file *, void *);
 extern void iop_preinit(void);
 extern void iop_init(void);
 extern void via_init(void);
@@ -865,10 +857,6 @@ static void __init mac_identify(void)
 		mac_bi_data.boottime, mac_bi_data.gmtbias);
 	printk(KERN_DEBUG " Machine ID: %ld CPUid: 0x%lx memory size: 0x%lx \n",
 		mac_bi_data.id, mac_bi_data.cpuid, mac_bi_data.memsize);
-#if 0
-	printk("Ramdisk: addr 0x%lx size 0x%lx\n",
-		m68k_ramdisk.addr, m68k_ramdisk.size);
-#endif
 
 	iop_init();
 	via_init();
diff --git a/arch/m68k/mac/debug.c b/arch/m68k/mac/debug.c
index 65dd77a..bce074c 100644
--- a/arch/m68k/mac/debug.c
+++ b/arch/m68k/mac/debug.c
@@ -27,7 +27,6 @@
 #include <asm/macints.h>
 
 extern unsigned long mac_videobase;
-extern unsigned long mac_videodepth;
 extern unsigned long mac_rowbytes;
 
 extern void mac_serial_print(const char *);
diff --git a/arch/m68k/mac/macints.c b/arch/m68k/mac/macints.c
index 82e560c..7d0cbf3 100644
--- a/arch/m68k/mac/macints.c
+++ b/arch/m68k/mac/macints.c
@@ -134,6 +134,7 @@
 #include <asm/errno.h>
 #include <asm/macints.h>
 #include <asm/irq_regs.h>
+#include <asm/mac_oss.h>
 
 #define DEBUG_SPURIOUS
 #define SHUTUP_SONIC
@@ -146,7 +147,6 @@ static int scc_mask;
  * VIA/RBV hooks
  */
 
-extern void via_init(void);
 extern void via_register_interrupts(void);
 extern void via_irq_enable(int);
 extern void via_irq_disable(int);
@@ -157,9 +157,6 @@ extern int  via_irq_pending(int);
  * OSS hooks
  */
 
-extern int oss_present;
-
-extern void oss_init(void);
 extern void oss_register_interrupts(void);
 extern void oss_irq_enable(int);
 extern void oss_irq_disable(int);
@@ -170,9 +167,6 @@ extern int  oss_irq_pending(int);
  * PSC hooks
  */
 
-extern int psc_present;
-
-extern void psc_init(void);
 extern void psc_register_interrupts(void);
 extern void psc_irq_enable(int);
 extern void psc_irq_disable(int);
@@ -191,12 +185,10 @@ extern void iop_register_interrupts(void);
 
 extern int baboon_present;
 
-extern void baboon_init(void);
 extern void baboon_register_interrupts(void);
 extern void baboon_irq_enable(int);
 extern void baboon_irq_disable(int);
 extern void baboon_irq_clear(int);
-extern int  baboon_irq_pending(int);
 
 /*
  * SCC interrupt routines
diff --git a/arch/m68k/mac/misc.c b/arch/m68k/mac/misc.c
index a44c708..5d81856 100644
--- a/arch/m68k/mac/misc.c
+++ b/arch/m68k/mac/misc.c
@@ -35,7 +35,6 @@
 
 #define RTC_OFFSET 2082844800
 
-extern struct mac_booter_data mac_bi_data;
 static void (*rom_reset)(void);
 
 #ifdef CONFIG_ADB_CUDA
diff --git a/arch/m68k/mac/via.c b/arch/m68k/mac/via.c
index 490dcb0..796c822 100644
--- a/arch/m68k/mac/via.c
+++ b/arch/m68k/mac/via.c
@@ -34,6 +34,7 @@
 #include <asm/macints.h>
 #include <asm/mac_via.h>
 #include <asm/mac_psc.h>
+#include <asm/mac_oss.h>
 
 volatile __u8 *via1, *via2;
 int rbv_present;
@@ -84,7 +85,6 @@ void via_irq_disable(int irq);
 void via_irq_clear(int irq);
 
 extern irqreturn_t mac_scc_dispatch(int, void *);
-extern int oss_present;
 
 /*
  * Initialize the VIAs
diff --git a/arch/m68k/math-emu/fp_log.c b/arch/m68k/math-emu/fp_log.c
index b1033ae..367ecee 100644
--- a/arch/m68k/math-emu/fp_log.c
+++ b/arch/m68k/math-emu/fp_log.c
@@ -24,7 +24,6 @@ static const struct fp_ext fp_one =
 
 extern struct fp_ext *fp_fadd(struct fp_ext *dest, const struct fp_ext *src);
 extern struct fp_ext *fp_fdiv(struct fp_ext *dest, const struct fp_ext *src);
-extern struct fp_ext *fp_fmul(struct fp_ext *dest, const struct fp_ext *src);
 
 struct fp_ext *
 fp_fsqrt(struct fp_ext *dest, struct fp_ext *src)
diff --git a/arch/m68k/mm/init.c b/arch/m68k/mm/init.c
index 81bb08c..0007b2a 100644
--- a/arch/m68k/mm/init.c
+++ b/arch/m68k/mm/init.c
@@ -28,6 +28,7 @@
 #ifdef CONFIG_ATARI
 #include <asm/atari_stram.h>
 #endif
+#include <asm/sections.h>
 #include <asm/tlb.h>
 
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
@@ -73,9 +74,6 @@ extern void init_pointer_table(unsigned long ptable);
 
 /* References to section boundaries */
 
-extern char _text[], _etext[];
-extern char __init_begin[], __init_end[];
-
 extern pmd_t *zero_pgtable;
 
 void __init mem_init(void)
diff --git a/arch/m68k/mm/motorola.c b/arch/m68k/mm/motorola.c
index c5dbb9b..4665fc8 100644
--- a/arch/m68k/mm/motorola.c
+++ b/arch/m68k/mm/motorola.c
@@ -30,6 +30,7 @@
 #ifdef CONFIG_ATARI
 #include <asm/atari_stram.h>
 #endif
+#include <asm/sections.h>
 
 #undef DEBUG
 
@@ -301,14 +302,12 @@ void __init paging_init(void)
 	}
 }
 
-extern char __init_begin, __init_end;
-
 void free_initmem(void)
 {
 	unsigned long addr;
 
-	addr = (unsigned long)&__init_begin;
-	for (; addr < (unsigned long)&__init_end; addr += PAGE_SIZE) {
+	addr = (unsigned long)__init_begin;
+	for (; addr < (unsigned long)__init_end; addr += PAGE_SIZE) {
 		virt_to_page(addr)->flags &= ~(1 << PG_reserved);
 		init_page_count(virt_to_page(addr));
 		free_page(addr);
diff --git a/arch/m68k/mvme147/config.c b/arch/m68k/mvme147/config.c
index 43cdf47..b72f079 100644
--- a/arch/m68k/mvme147/config.c
+++ b/arch/m68k/mvme147/config.c
@@ -42,7 +42,6 @@ extern unsigned long mvme147_gettimeoffset (void);
 extern int mvme147_hwclk (int, struct rtc_time *);
 extern int mvme147_set_clock_mmss (unsigned long);
 extern void mvme147_reset (void);
-extern void mvme147_waitbut(void);
 
 
 static int bcd2int (unsigned char b);
diff --git a/arch/m68k/mvme16x/config.c b/arch/m68k/mvme16x/config.c
index 84ce1d8..fbdced1 100644
--- a/arch/m68k/mvme16x/config.c
+++ b/arch/m68k/mvme16x/config.c
@@ -48,7 +48,6 @@ extern unsigned long mvme16x_gettimeoffset (void);
 extern int mvme16x_hwclk (int, struct rtc_time *);
 extern int mvme16x_set_clock_mmss (unsigned long);
 extern void mvme16x_reset (void);
-extern void mvme16x_waitbut(void);
 
 int bcd2int (unsigned char b);
 
diff --git a/arch/m68k/q40/config.c b/arch/m68k/q40/config.c
index 7110546..31ab3f0 100644
--- a/arch/m68k/q40/config.c
+++ b/arch/m68k/q40/config.c
@@ -36,7 +36,6 @@
 #include <asm/machdep.h>
 #include <asm/q40_master.h>
 
-extern irqreturn_t q40_process_int(int level, struct pt_regs *regs);
 extern void q40_init_IRQ(void);
 static void q40_get_model(char *model);
 extern void q40_sched_init(irq_handler_t handler);
@@ -47,8 +46,6 @@ static unsigned int q40_get_ss(void);
 static int q40_set_clock_mmss(unsigned long);
 static int q40_get_rtc_pll(struct rtc_pll_info *pll);
 static int q40_set_rtc_pll(struct rtc_pll_info *pll);
-extern void q40_waitbut(void);
-void q40_set_vectors(void);
 
 extern void q40_mksound(unsigned int /*freq*/, unsigned int /*ticks*/);
 
diff --git a/arch/m68k/sun3/config.c b/arch/m68k/sun3/config.c
index 8dfaa20..2ca25bd 100644
--- a/arch/m68k/sun3/config.c
+++ b/arch/m68k/sun3/config.c
@@ -27,23 +27,21 @@
 #include <asm/sun3mmu.h>
 #include <asm/rtc.h>
 #include <asm/machdep.h>
+#include <asm/idprom.h>
 #include <asm/intersil.h>
 #include <asm/irq.h>
+#include <asm/sections.h>
 #include <asm/segment.h>
 #include <asm/sun3ints.h>
 
-extern char _text, _end;
-
 char sun3_reserved_pmeg[SUN3_PMEGS_NUM];
 
 extern unsigned long sun3_gettimeoffset(void);
 static void sun3_sched_init(irq_handler_t handler);
 extern void sun3_get_model (char* model);
-extern void idprom_init (void);
 extern int sun3_hwclk(int set, struct rtc_time *t);
 
 volatile char* clock_va;
-extern volatile unsigned char* sun3_intreg;
 extern unsigned long availmem;
 unsigned long num_pages;
 
@@ -149,7 +147,7 @@ void __init config_sun3(void)
 	mach_halt	     =  sun3_halt;
 	mach_get_hardware_list = sun3_get_hardware_list;
 
-	memory_start = ((((int)&_end) + 0x2000) & ~0x1fff);
+	memory_start = ((((unsigned long)_end) + 0x2000) & ~0x1fff);
 // PROM seems to want the last couple of physical pages. --m
 	memory_end   = *(romvec->pv_sun3mem) + PAGE_OFFSET - 2*PAGE_SIZE;
 
diff --git a/arch/m68k/sun3/mmu_emu.c b/arch/m68k/sun3/mmu_emu.c
index 60f9d45..3cd1939 100644
--- a/arch/m68k/sun3/mmu_emu.c
+++ b/arch/m68k/sun3/mmu_emu.c
@@ -27,7 +27,6 @@
 #include <asm/mmu_context.h>
 #include <asm/dvma.h>
 
-extern void prom_reboot (char *) __attribute__ ((__noreturn__));
 
 #undef DEBUG_MMU_EMU
 #define DEBUG_PROM_MAPS
diff --git a/arch/m68k/sun3x/config.c b/arch/m68k/sun3x/config.c
index 2b1ca2d..fc599fa 100644
--- a/arch/m68k/sun3x/config.c
+++ b/arch/m68k/sun3x/config.c
@@ -23,7 +23,6 @@
 #include "time.h"
 
 volatile char *clock_va;
-extern volatile unsigned char *sun3_intreg;
 
 extern void sun3_get_model(char *model);
 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
