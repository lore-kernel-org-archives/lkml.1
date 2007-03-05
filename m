Return-Path: <linux-kernel-owner+w=401wt.eu-S932067AbXCEHNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067AbXCEHNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 02:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbXCEHNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 02:13:18 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:15635 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbXCEHNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 02:13:15 -0500
X-IronPort-AV: i="4.14,247,1170651600"; 
   d="scan'208"; a="29929739:sNHT40236539"
Subject: Re: [PATCH -mm 1/5] Blackfin: blackfin architecture patch update
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, bert.hubert@netherlabs.nl,
       linux-kernel@vger.kernel.org
In-Reply-To: <200703032138.49308.arnd@arndb.de>
References: <1172722480.5264.75.camel@roc-desktop>
	 <200703032138.49308.arnd@arndb.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Mon, 05 Mar 2007 15:13:03 +0800
Message-Id: <1173078783.5264.158.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-03 at 15:38 -0500, Arnd Bergmann wrote:
> On Thursday 01 March 2007 05:14:40 Wu, Bryan wrote: 
> > The whole patch is located at URL: 
> >
> https://blackfin.uclinux.org/gf/download/frsrelease/39/2583/blackfin-arch.p 
> >atch The incremental patch is located at URL: 
> >
> https://blackfin.uclinux.org/gf/download/frsrelease/39/2584/blackfin-arch-m 
> >m2-update.patch
> 
> I'm not sure if that was intentional, but the second patch does not
> apply 
> on top of the -mm kernel but rather patch the the patch old itself. 
> This basically makes it impossible to review just that part, so
> better 
> provide the diff between the kernel with the old patch and the kernel 
> with the new patch next time.
> 

Sorry for messing up this incremental patch. Here is the updated
incremental patch

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/Kconfig                           |  122 ++++++-
 arch/blackfin/kernel/entry.S                    |    4
 arch/blackfin/kernel/irqchip.c                  |    5
 arch/blackfin/kernel/process.c                  |   48 ++
 arch/blackfin/kernel/setup.c                    |   41 +-
 arch/blackfin/kernel/signal.c                   |    5
 arch/blackfin/kernel/sys_bfin.c                 |   16
 arch/blackfin/kernel/time.c                     |    6
 arch/blackfin/kernel/traps.c                    |    4
 arch/blackfin/lib/ashldi3.c                     |    4
 arch/blackfin/lib/ashrdi3.c                     |    4
 arch/blackfin/lib/checksum.c                    |    4
 arch/blackfin/lib/divsi3.S                      |    8
 arch/blackfin/lib/lshrdi3.c                     |    4
 arch/blackfin/lib/memcpy.S                      |    6
 arch/blackfin/lib/memset.S                      |    6
 arch/blackfin/lib/modsi3.S                      |    7
 arch/blackfin/lib/muldi3.c                      |    4
 arch/blackfin/lib/smulsi3_highpart.S            |    6
 arch/blackfin/lib/udivsi3.S                     |    9
 arch/blackfin/lib/umodsi3.S                     |    5
 arch/blackfin/lib/umulsi3_highpart.S            |    6
 arch/blackfin/mach-bf537/boards/stamp.c         |   49 ++
 arch/blackfin/mach-bf537/head.S                 |    1
 arch/blackfin/mach-bf561/boards/generic_board.c |    2
 arch/blackfin/mach-common/cache.S               |    2
 arch/blackfin/mach-common/cplbhdlr.S            |    4
 arch/blackfin/mach-common/cplbmgr.S             |    4
 arch/blackfin/mach-common/entry.S               |   17 -
 arch/blackfin/mach-common/ints-priority-dc.c    |    4
 arch/blackfin/mach-common/ints-priority-sc.c    |    4
 include/asm-blackfin/cplbinit.h                 |  397 ++++++++++++------------
 include/asm-blackfin/delay.h                    |    5
 include/asm-blackfin/dma-mapping.h              |    5
 include/asm-blackfin/mach-bf533/bf533.h         |   11
 include/asm-blackfin/mach-bf533/mem_map.h       |   62 ++-
 include/asm-blackfin/mach-bf537/bf537.h         |   11
 include/asm-blackfin/mach-bf537/defBF534.h      |    2
 include/asm-blackfin/mach-bf537/mem_map.h       |   77 +++-
 include/asm-blackfin/mach-bf561/bf561.h         |    5
 include/asm-blackfin/mach-bf561/mem_map.h       |   28 +
 include/asm-blackfin/pgtable.h                  |    8
 include/asm-blackfin/uaccess.h                  |   41 --
 include/asm-blackfin/unistd.h                   |    2
 include/asm-blackfin/xor.h                      |    1
 init/Kconfig                                    |    3
 46 files changed, 725 insertions(+), 344 deletions(-)

diff -uprN linux-2.6-orig/arch/blackfin/Kconfig linux-2.6/arch/blackfin/Kconfig
--- linux-2.6-orig/arch/blackfin/Kconfig	2007-03-05 11:50:21.000000000 +0800
+++ linux-2.6/arch/blackfin/Kconfig	2007-03-05 11:57:23.000000000 +0800
@@ -9,6 +9,10 @@ config MMU
 	bool
 	default n
 
+config ZONE_DMA
+	bool
+	default y 
+
 config FPU
 	bool
 	default n
@@ -21,6 +25,10 @@ config RWSEM_XCHGADD_ALGORITHM
 	bool
 	default n
 
+config BLACKFIN
+	bool
+	default y
+
 config BFIN
 	bool
 	default y
@@ -140,21 +148,14 @@ config BF_REV_0_5
 
 endchoice
 
-config BLACKFIN
+config BFIN_DUAL_CORE
 	bool
-	depends on (BF537 || BF536 \
-		|| BF534 || BF561 || BF535 || BF533 || BF532 || BF531)
+	depends on (BF561)
 	default y
 
 config BFIN_SINGLE_CORE
 	bool
-	depends on (BF537 || BF536 \
-		|| BF534 || BF535 || BF533 || BF532 || BF531)
-	default y
-
-config BFIN_DUAL_CORE
-	bool
-	depends on (BF561)
+	depends on !BFIN_DUAL_CORE
 	default y
 
 choice
@@ -427,11 +428,104 @@ comment "Memory Optimizations"
 
 config I_ENTRY_L1
 	bool "Locate interrupt entry code in L1 Memory"
-	default n
+	default y
 	help
 	  If enabled interrupt entry code (STORE/RESTORE CONTEXT) is linked
 	  into L1 instruction memory.(less latency)
 
+config EXCPT_IRQ_SYSC_L1
+	bool "Locate entire ASM lowlevel excepetion / interrupt - Syscall and CPLB handler code in L1 Memory"
+	default y
+	help
+	  If enabled entire ASM lowlevel exception and interrupt entry code (STORE/RESTORE CONTEXT) is linked
+	  into L1 instruction memory.(less latency)
+
+config DO_IRQ_L1
+	bool "Locate frequently called do_irq dispatcher function in L1 Memory"
+	default y
+	help
+	  If enabled frequently called do_irq dispatcher function is linked
+	  into L1 instruction memory.(less latency)
+
+config CORE_TIMER_IRQ_L1
+	bool "Locate frequently called timer_interrupt() function in L1 Memory"
+	default y
+	help
+	  If enabled frequently called timer_interrupt() function is linked
+	  into L1 instruction memory.(less latency)
+
+config IDLE_L1
+	bool "Locate frequently idle function in L1 Memory"
+	default y
+	help
+	  If enabled frequently called idle function is linked
+	  into L1 instruction memory.(less latency)
+
+config SCHEDULE_L1
+	bool "Locate kernel schedule function in L1 Memory"
+	default y
+	help
+	  If enabled frequently called kernel schedule is linked
+	  into L1 instruction memory.(less latency)
+
+config ARITHMETIC_OPS_L1
+	bool "Locate kernel owned arithmetic functions in L1 Memory"
+	default y
+	help
+	  If enabled arithmetic functions are linked
+	  into L1 instruction memory.(less latency)
+	  
+config ACCESS_OK_L1
+	bool "Locate access_ok function in L1 Memory"
+	default y
+	help
+	  If enabled access_ok function is linked
+	  into L1 instruction memory.(less latency)
+
+config MEMSET_L1
+	bool "Locate memset function in L1 Memory"
+	default y
+	help
+	  If enabled memset function is linked
+	  into L1 instruction memory.(less latency)
+
+config MEMCPY_L1
+	bool "Locate memcpy function in L1 Memory"
+	default y
+	help
+	  If enabled memcpy function is linked
+	  into L1 instruction memory.(less latency)
+
+config SYS_BFIN_SPINLOCK_L1
+	bool "Locate sys_bfin_spinlock function in L1 Memory"
+	default y
+	help
+	  If enabled sys_bfin_spinlock function is linked
+	  into L1 instruction memory.(less latency)
+	  
+config IP_CHECKSUM_L1
+	bool "Locate IP Checksum function in L1 Memory"
+	default n
+	help
+	  If enabled IP Checksum function is linked
+	  into L1 instruction memory.(less latency)
+
+config SYSCALL_TAB_L1
+	bool "Locate Syscall Table L1 Data Memory"
+	default n
+	depends on !BF531
+	help
+	  If enabled the Syscall LUT is linked
+	  into L1 data memory.(less latency)
+
+config CPLB_SWITCH_TAB_L1
+	bool "Locate CPLB Switch Tables L1 Data Memory"
+	default n
+	depends on !BF531
+	help
+	  If enabled the CPLB Switch Tables are linked
+	  into L1 data memory.(less latency)
+
 endmenu
 
 
@@ -488,6 +582,10 @@ config BLKFIN_CACHE
 	bool "Enable ICACHE"
 config BLKFIN_DCACHE
 	bool "Enable DCACHE"
+config BLKFIN_DCACHE_BANKA
+	bool "Enable only 16k BankA DCACHE - BankB is SRAM"
+	depends on BLKFIN_DCACHE && !BF531
+	default n
 config BLKFIN_CACHE_LOCK
 	bool "Enable Cache Locking"
 
@@ -817,7 +915,7 @@ config DEBUG_KERNEL_START
 config DEBUG_SERIAL_EARLY_INIT
 	bool "Initialize serial driver early"
 	default n
-	depends on SERIAL_BLACKFIN
+	depends on SERIAL_BFIN
 	help
 	  Say Y here if you want to get kernel output early when kernel
 	  crashes before the normal console initialization. If this option
diff -uprN linux-2.6-orig/arch/blackfin/kernel/entry.S linux-2.6/arch/blackfin/kernel/entry.S
--- linux-2.6-orig/arch/blackfin/kernel/entry.S	2007-03-05 11:50:21.000000000 +0800
+++ linux-2.6/arch/blackfin/kernel/entry.S	2007-03-05 11:57:23.000000000 +0800
@@ -36,7 +36,11 @@
 
 #include <asm/mach-common/context.S>
 
+#ifdef CONFIG_EXCPT_IRQ_SYSC_L1
+.section .l1.text
+#else
 .text
+#endif
 
 ENTRY(_ret_from_fork)
 	SP += -12;
diff -uprN linux-2.6-orig/arch/blackfin/kernel/irqchip.c linux-2.6/arch/blackfin/kernel/irqchip.c
--- linux-2.6-orig/arch/blackfin/kernel/irqchip.c	2007-03-05 11:50:21.000000000 +0800
+++ linux-2.6/arch/blackfin/kernel/irqchip.c	2007-03-05 13:54:10.000000000 +0800
@@ -97,6 +97,11 @@ int show_interrupts(struct seq_file *p, 
  * come via this function.  Instead, they should provide their
  * own 'handler'
  */
+
+#ifdef CONFIG_DO_IRQ_L1
+asmlinkage void asm_do_IRQ(unsigned int irq, struct pt_regs *regs)__attribute__((l1_text));
+#endif
+
 asmlinkage void asm_do_IRQ(unsigned int irq, struct pt_regs *regs)
 {
 	struct pt_regs *old_regs;
diff -uprN linux-2.6-orig/arch/blackfin/kernel/process.c linux-2.6/arch/blackfin/kernel/process.c
--- linux-2.6-orig/arch/blackfin/kernel/process.c	2007-03-05 11:50:21.000000000 +0800
+++ linux-2.6/arch/blackfin/kernel/process.c	2007-03-05 13:54:10.000000000 +0800
@@ -97,6 +97,11 @@ static inline void leds_switch(int flag)
 /*
  * The idle loop on BFIN
  */
+#ifdef CONFIG_IDLE_L1
+static inline void default_idle(void)__attribute__((l1_text));
+void cpu_idle(void)__attribute__((l1_text));
+#endif
+
 static inline void default_idle(void)
 {
 	while (!need_resched()) {
@@ -346,3 +351,46 @@ unsigned long get_wchan(struct task_stru
 	while (count++ < 16);
 	return 0;
 }
+
+#if !defined(CONFIG_NO_ACCESS_CHECK)
+int _access_ok(unsigned long addr, unsigned long size)
+{
+
+	if (addr > (addr + size))
+		return 0;
+	if (segment_eq(get_fs(),KERNEL_DS))
+		return 1;
+#ifdef CONFIG_MTD_UCLINUX
+	if (addr >= memory_start && (addr + size) <= memory_end)
+		return 1;
+	if (addr >= memory_mtd_end && (addr + size) <= physical_mem_end)
+		return 1;
+#else
+	if (addr >= memory_start && (addr + size) <= physical_mem_end)
+		return 1;
+#endif
+	if (addr >= (unsigned long)__init_begin &&
+	    addr + size <= (unsigned long)__init_end)
+		return 1;
+	if (addr >= L1_SCRATCH_START
+	    && addr + size <= L1_SCRATCH_START + L1_SCRATCH_LENGTH)
+		return 1;
+#if L1_CODE_LENGTH != 0
+	if (addr >= L1_CODE_START + (_etext_l1 - _stext_l1)
+	    && addr + size <= L1_CODE_START + L1_CODE_LENGTH)
+		return 1;
+#endif
+#if L1_DATA_A_LENGTH != 0
+	if (addr >= L1_DATA_A_START + (_ebss_l1 - _sdata_l1)
+	    && addr + size <= L1_DATA_A_START + L1_DATA_A_LENGTH)
+		return 1;
+#endif
+#if L1_DATA_B_LENGTH != 0
+	if (addr >= L1_DATA_B_START
+	    && addr + size <= L1_DATA_B_START + L1_DATA_B_LENGTH)
+		return 1;
+#endif
+	return 0;
+}
+EXPORT_SYMBOL(_access_ok);
+#endif
diff -uprN linux-2.6-orig/arch/blackfin/kernel/setup.c linux-2.6/arch/blackfin/kernel/setup.c
--- linux-2.6-orig/arch/blackfin/kernel/setup.c	2007-03-05 11:50:21.000000000 +0800
+++ linux-2.6/arch/blackfin/kernel/setup.c	2007-03-05 11:57:23.000000000 +0800
@@ -309,6 +309,8 @@ void __init setup_arch(char **cmdline_p)
 	printk(KERN_NOTICE "Warning: limiting memory to %liMB due to hardware anomaly 05000263\n", memory_end >> 20);
 #endif				/* ANOMALY_05000263 */
 
+	memory_end -= SIZE_4K; /*In case there is no valid CPLB behind memory_end make sure we don't get to close*/
+
 	init_mm.start_code = (unsigned long)_stext;
 	init_mm.end_code = (unsigned long)_etext;
 	init_mm.end_data = (unsigned long)_edata;
@@ -447,8 +449,8 @@ subsys_initcall(topology_init);
 #if defined(CONFIG_BLKFIN_DCACHE) || defined(CONFIG_BLKFIN_CACHE)
 u16 lock_kernel_check(u32 start, u32 end)
 {
-	if ((start <= (u32) _stext && end >= (u32) __bss_stop)
-	    || (start >= (u32) _stext && end <= (u32) __bss_stop))
+	if ((start <= (u32) _stext && end >= (u32) _end)
+	    || (start >= (u32) _stext && end <= (u32) _end))
 		return IN_KERNEL;
 	return 0;
 }
@@ -763,16 +765,12 @@ static int show_cpuinfo(struct seq_file 
 #endif
 
 	u_long cclk = 0, sclk = 0;
-	u_int id;
+	u_int id, dcache_size = 0, dsup_banks = 0;
 
 	cpu = CPU;
 	mmu = "none";
 	fpu = "none";
-	if (&bfin_board_name) {
-		name = bfin_board_name;
-	} else {
-		name = "Unknown";
-	}
+	name = bfin_board_name;
 
 	cclk = get_cclk();
 	sclk = get_sclk();
@@ -808,13 +806,36 @@ static int show_cpuinfo(struct seq_file 
 			   "\n");
 	else
 		seq_printf(m, "D-CACHE:\tOFF\n");
+
+
+	switch(bfin_read_DMEM_CONTROL() & (1 << DMC0_P | 1 << DMC1_P)) {
+		case ACACHE_BSRAM:
+			seq_printf(m, "DBANK-A:\tCACHE\n" "DBANK-B:\tSRAM\n");
+			dcache_size = 16; 
+			dsup_banks = 1;
+			break;				
+		case ACACHE_BCACHE:
+			seq_printf(m, "DBANK-A:\tCACHE\n" "DBANK-B:\tCACHE\n");
+			dcache_size = 32; 
+			dsup_banks = 2;
+			break;
+		case ASRAM_BSRAM:
+			seq_printf(m, "DBANK-A:\tSRAM\n" "DBANK-B:\tSRAM\n");
+			dcache_size = 0; 
+			dsup_banks = 0;
+			break;
+		default:
+		break;
+	}
+
+
 	seq_printf(m, "I-CACHE Size:\t%dKB\n", BLKFIN_ICACHESIZE / 1024);
-	seq_printf(m, "D-CACHE Size:\t%dKB\n", BLKFIN_DCACHESIZE / 1024);
+	seq_printf(m, "D-CACHE Size:\t%dKB\n", dcache_size);
 	seq_printf(m, "I-CACHE Setup:\t%d Sub-banks/%d Ways, %d Lines/Way\n",
 		   BLKFIN_ISUBBANKS, BLKFIN_IWAYS, BLKFIN_ILINES);
 	seq_printf(m,
 		   "D-CACHE Setup:\t%d Super-banks/%d Sub-banks/%d Ways, %d Lines/Way\n",
-		   BLKFIN_DSUPBANKS, BLKFIN_DSUBBANKS, BLKFIN_DWAYS,
+		   dsup_banks, BLKFIN_DSUBBANKS, BLKFIN_DWAYS,
 		   BLKFIN_DLINES);
 #ifdef CONFIG_BLKFIN_CACHE_LOCK
 	lock = read_iloc();
diff -uprN linux-2.6-orig/arch/blackfin/kernel/signal.c linux-2.6/arch/blackfin/kernel/signal.c
--- linux-2.6-orig/arch/blackfin/kernel/signal.c	2007-03-05 11:50:21.000000000 +0800
+++ linux-2.6/arch/blackfin/kernel/signal.c	2007-03-05 11:57:23.000000000 +0800
@@ -66,6 +66,11 @@ struct rt_sigframe {
 	struct ucontext uc;
 };
 
+asmlinkage int sys_sigaltstack(const stack_t * uss, stack_t * uoss)
+{
+	return do_sigaltstack(uss, uoss, rdusp());
+}
+
 static inline int
 rt_restore_ucontext(struct pt_regs *regs, struct ucontext *uc, int *pr0)
 {
diff -uprN linux-2.6-orig/arch/blackfin/kernel/sys_bfin.c linux-2.6/arch/blackfin/kernel/sys_bfin.c
--- linux-2.6-orig/arch/blackfin/kernel/sys_bfin.c	2007-03-05 11:50:21.000000000 +0800
+++ linux-2.6/arch/blackfin/kernel/sys_bfin.c	2007-03-05 13:39:47.000000000 +0800
@@ -115,19 +115,3 @@ asmlinkage void *sys_dma_memcpy(void *de
 {
 	return safe_dma_memcpy(dest, src, len);
 }
-
-/*
- * Do a system call from kernel instead of calling sys_execve so we
- * end up with proper pt_regs.
- */
-int kernel_execve(const char *filename, char *const argv[], char *const envp[])
-{
-       register long __res asm ("P0") = __NR_execve;
-       register long __a asm ("R0") = (long)(filename);
-       register long __b asm ("R1") = (long)(argv);
-       register long __c asm ("R2") = (long)(envp);
-       asm volatile ("raise 15" : "+d" (__a)
-                       : "d" (__res), "d" (__b), "d" (__c));
-       return __a;
-}
-
diff -uprN linux-2.6-orig/arch/blackfin/kernel/time.c linux-2.6/arch/blackfin/kernel/time.c
--- linux-2.6-orig/arch/blackfin/kernel/time.c	2007-03-05 11:50:21.000000000 +0800
+++ linux-2.6/arch/blackfin/kernel/time.c	2007-03-05 11:57:23.000000000 +0800
@@ -197,6 +197,10 @@ static inline int set_rtc_mmss(unsigned 
  * timer_interrupt() needs to keep up the real-time clock,
  * as well as call the "do_timer()" routine every clocktick
  */
+#ifdef CONFIG_CORE_TIMER_IRQ_L1
+irqreturn_t timer_interrupt(int irq, void *dummy)__attribute__((l1_text));
+#endif
+
 irqreturn_t timer_interrupt(int irq, void *dummy)
 {
 	/* last time the cmos clock got updated */
@@ -243,7 +247,7 @@ void __init time_init(void)
 	 * userspace to have to deal with time values greater than
 	 * 2^31 seconds (which uClibc cannot cope with yet)
 	 */
-	if (bfin_read_RTC_STAT() & 0x60000000) {
+	if ((bfin_read_RTC_STAT() & 0xC0000000) == 0xC0000000) {
 		printk(KERN_NOTICE "bfin-rtc: invalid date; resetting\n");
 		bfin_write_RTC_STAT(0);
 	}
diff -uprN linux-2.6-orig/arch/blackfin/kernel/traps.c linux-2.6/arch/blackfin/kernel/traps.c
--- linux-2.6-orig/arch/blackfin/kernel/traps.c	2007-03-05 11:50:21.000000000 +0800
+++ linux-2.6/arch/blackfin/kernel/traps.c	2007-03-05 13:54:10.000000000 +0800
@@ -622,6 +622,10 @@ void dump_bfin_regs(struct pt_regs *fp, 
 	printk("\n\n");
 }
 
+#ifdef CONFIG_SYS_BFIN_SPINLOCK_L1
+asmlinkage int sys_bfin_spinlock(int *spinlock)__attribute__((l1_text));
+#endif
+
 asmlinkage int sys_bfin_spinlock(int *spinlock)
 {
 	int ret = 0;
diff -uprN linux-2.6-orig/arch/blackfin/lib/ashldi3.c linux-2.6/arch/blackfin/lib/ashldi3.c
--- linux-2.6-orig/arch/blackfin/lib/ashldi3.c	2007-03-05 11:50:21.000000000 +0800
+++ linux-2.6/arch/blackfin/lib/ashldi3.c	2007-03-05 11:57:23.000000000 +0800
@@ -31,6 +31,10 @@
 
 #include "gcclib.h"
 
+#ifdef CONFIG_ARITHMETIC_OPS_L1
+DItype __ashldi3(DItype u, word_type b)__attribute__((l1_text));
+#endif
+
 DItype __ashldi3(DItype u, word_type b)
 {
 	DIunion w;
diff -uprN linux-2.6-orig/arch/blackfin/lib/ashrdi3.c linux-2.6/arch/blackfin/lib/ashrdi3.c
--- linux-2.6-orig/arch/blackfin/lib/ashrdi3.c	2007-03-05 11:50:21.000000000 +0800
+++ linux-2.6/arch/blackfin/lib/ashrdi3.c	2007-03-05 11:57:23.000000000 +0800
@@ -31,6 +31,10 @@
 
 #include "gcclib.h"
 
+#ifdef CONFIG_ARITHMETIC_OPS_L1
+DItype __ashrdi3(DItype u, word_type b)__attribute__((l1_text));
+#endif
+
 DItype __ashrdi3(DItype u, word_type b)
 {
 	DIunion w;
diff -uprN linux-2.6-orig/arch/blackfin/lib/checksum.c linux-2.6/arch/blackfin/lib/checksum.c
--- linux-2.6-orig/arch/blackfin/lib/checksum.c	2007-03-05 11:50:21.000000000 +0800
+++ linux-2.6/arch/blackfin/lib/checksum.c	2007-03-05 11:57:23.000000000 +0800
@@ -34,6 +34,10 @@
 #include <net/checksum.h>
 #include <asm/checksum.h>
 
+#ifdef CONFIG_IP_CHECKSUM_L1
+static unsigned short do_csum(const unsigned char *buff, int len)__attribute__((l1_text));
+#endif
+
 static unsigned short do_csum(const unsigned char *buff, int len)
 {
 	register unsigned long sum = 0;
diff -uprN linux-2.6-orig/arch/blackfin/lib/divsi3.S linux-2.6/arch/blackfin/lib/divsi3.S
--- linux-2.6-orig/arch/blackfin/lib/divsi3.S	2007-03-05 11:50:21.000000000 +0800
+++ linux-2.6/arch/blackfin/lib/divsi3.S	2007-03-05 13:54:10.000000000 +0800
@@ -46,7 +46,13 @@
 
 .global   ___divsi3;
 
-.align 8;
+#ifdef CONFIG_ARITHMETIC_OPS_L1
+.section .l1.text
+#else
+.text
+#endif
+
+.align 2;
 ___divsi3 :
 
 
diff -uprN linux-2.6-orig/arch/blackfin/lib/lshrdi3.c linux-2.6/arch/blackfin/lib/lshrdi3.c
--- linux-2.6-orig/arch/blackfin/lib/lshrdi3.c	2007-03-05 11:50:21.000000000 +0800
+++ linux-2.6/arch/blackfin/lib/lshrdi3.c	2007-03-05 11:57:23.000000000 +0800
@@ -45,6 +45,10 @@ typedef union {
 	DItype ll;
 } DIunion;
 
+#ifdef CONFIG_ARITHMETIC_OPS_L1
+DItype __lshrdi3(DItype u, word_type b)__attribute__((l1_text));
+#endif
+
 DItype __lshrdi3(DItype u, word_type b)
 {
 	DIunion w;
diff -uprN linux-2.6-orig/arch/blackfin/lib/memcpy.S linux-2.6/arch/blackfin/lib/memcpy.S
--- linux-2.6-orig/arch/blackfin/lib/memcpy.S	2007-03-05 11:50:21.000000000 +0800
+++ linux-2.6/arch/blackfin/lib/memcpy.S	2007-03-05 11:57:23.000000000 +0800
@@ -36,6 +36,12 @@
 
 #include <linux/linkage.h>
 
+#ifdef CONFIG_MEMCPY_L1
+.section .l1.text
+#else
+.text
+#endif
+
 .align 2
 
 ENTRY(_memcpy)
diff -uprN linux-2.6-orig/arch/blackfin/lib/memset.S linux-2.6/arch/blackfin/lib/memset.S
--- linux-2.6-orig/arch/blackfin/lib/memset.S	2007-03-05 11:50:21.000000000 +0800
+++ linux-2.6/arch/blackfin/lib/memset.S	2007-03-05 11:57:23.000000000 +0800
@@ -33,6 +33,12 @@
 
 .align 2
 
+#ifdef CONFIG_MEMSET_L1
+.section .l1.text
+#else
+.text
+#endif
+
 /*
  * C Library function MEMSET
  * R0 = address (leave unchanged to form result)
diff -uprN linux-2.6-orig/arch/blackfin/lib/modsi3.S linux-2.6/arch/blackfin/lib/modsi3.S
--- linux-2.6-orig/arch/blackfin/lib/modsi3.S	2007-03-05 11:50:21.000000000 +0800
+++ linux-2.6/arch/blackfin/lib/modsi3.S	2007-03-05 11:57:23.000000000 +0800
@@ -39,6 +39,13 @@
 .type ___modsi3, STT_FUNC;
 .extern ___divsi3;
 .type ___divsi3, STT_FUNC;
+
+#ifdef CONFIG_ARITHMETIC_OPS_L1
+.section .l1.text
+#else
+.text
+#endif
+
 ___modsi3:
 
 	CC=R0==0;
diff -uprN linux-2.6-orig/arch/blackfin/lib/muldi3.c linux-2.6/arch/blackfin/lib/muldi3.c
--- linux-2.6-orig/arch/blackfin/lib/muldi3.c	2007-03-05 11:50:21.000000000 +0800
+++ linux-2.6/arch/blackfin/lib/muldi3.c	2007-03-05 11:57:23.000000000 +0800
@@ -83,6 +83,10 @@ typedef union {
 	ditype ll;
 } diunion;
 
+#ifdef CONFIG_ARITHMETIC_OPS_L1
+ditype __muldi3(ditype u, ditype v)__attribute__((l1_text));
+#endif
+
 ditype __muldi3(ditype u, ditype v)
 {
 	diunion w;
diff -uprN linux-2.6-orig/arch/blackfin/lib/smulsi3_highpart.S linux-2.6/arch/blackfin/lib/smulsi3_highpart.S
--- linux-2.6-orig/arch/blackfin/lib/smulsi3_highpart.S	2007-03-05 11:50:21.000000000 +0800
+++ linux-2.6/arch/blackfin/lib/smulsi3_highpart.S	2007-03-05 11:57:23.000000000 +0800
@@ -2,6 +2,12 @@
 .global ___smulsi3_highpart;
 .type ___smulsi3_highpart, STT_FUNC;
 
+#ifdef CONFIG_ARITHMETIC_OPS_L1
+.section .l1.text
+#else
+.text
+#endif
+
 ___smulsi3_highpart:
 	R2 = R1.L * R0.L (FU);
 	R3 = R1.H * R0.L (IS,M);
diff -uprN linux-2.6-orig/arch/blackfin/lib/udivsi3.S linux-2.6/arch/blackfin/lib/udivsi3.S
--- linux-2.6-orig/arch/blackfin/lib/udivsi3.S	2007-03-05 11:50:21.000000000 +0800
+++ linux-2.6/arch/blackfin/lib/udivsi3.S	2007-03-05 14:33:30.000000000 +0800
@@ -33,6 +33,13 @@
 
 #define CARRY AC0
 
+#ifdef CONFIG_ARITHMETIC_OPS_L1
+.section .l1.text
+#else
+.text
+#endif
+
+
 ENTRY(___udivsi3)
 
   CC = R0 < R1 (IU);    /* If X < Y, always return 0 */
@@ -105,7 +112,7 @@ ENTRY(___udivsi3)
   ** with some post-adjustment
   */
   R3 = R1 >> 1;		/* Pre-scaled divisor for primitive case */
-  R2 = R0 >> 16 ;
+  R2 = R0 >> 16; 
 
   R2 = R3 - R2;		/* shifted divisor < upper 16 bits of dividend */
   CC &= CARRY;
diff -uprN linux-2.6-orig/arch/blackfin/lib/umodsi3.S linux-2.6/arch/blackfin/lib/umodsi3.S
--- linux-2.6-orig/arch/blackfin/lib/umodsi3.S	2007-03-05 11:50:21.000000000 +0800
+++ linux-2.6/arch/blackfin/lib/umodsi3.S	2007-03-05 11:57:23.000000000 +0800
@@ -29,7 +29,12 @@
  * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#ifdef CONFIG_ARITHMETIC_OPS_L1
+.section .l1.text
+#else
 .text
+#endif
+
 .extern ___udivsi3;
 .globl	___umodsi3
 ___umodsi3:
diff -uprN linux-2.6-orig/arch/blackfin/lib/umulsi3_highpart.S linux-2.6/arch/blackfin/lib/umulsi3_highpart.S
--- linux-2.6-orig/arch/blackfin/lib/umulsi3_highpart.S	2007-03-05 11:50:21.000000000 +0800
+++ linux-2.6/arch/blackfin/lib/umulsi3_highpart.S	2007-03-05 11:57:23.000000000 +0800
@@ -2,6 +2,12 @@
 .global ___umulsi3_highpart;
 .type ___umulsi3_highpart, STT_FUNC;
 
+#ifdef CONFIG_ARITHMETIC_OPS_L1
+.section .l1.text
+#else
+.text
+#endif
+
 ___umulsi3_highpart:
 	R2 = R1.H * R0.H, R3 = R1.L * R0.H (FU);
 	R0 = R1.L * R0.L, R1 = R1.H * R0.L (FU);
diff -uprN linux-2.6-orig/arch/blackfin/mach-bf537/boards/stamp.c linux-2.6/arch/blackfin/mach-bf537/boards/stamp.c
--- linux-2.6-orig/arch/blackfin/mach-bf537/boards/stamp.c	2007-03-05 11:50:21.000000000 +0800
+++ linux-2.6/arch/blackfin/mach-bf537/boards/stamp.c	2007-03-05 13:54:10.000000000 +0800
@@ -40,6 +40,8 @@
 #include <linux/usb_isp1362.h>
 #endif
 #include <asm/irq.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
 #include <asm/bfin5xx_spi.h>
 #include <linux/usb_sl811.h>
 
@@ -54,6 +56,53 @@ char *bfin_board_name = "ADDS-BF537-STAM
  *  Driver needs to know address, irq and flag pin.
  */
 
+#define ISP1761_BASE       0x203C0000
+#define ISP1761_IRQ        IRQ_PF7
+
+#if defined(CONFIG_USB_ISP1760_HCD) || defined(CONFIG_USB_ISP1760_HCD_MODULE)
+static struct resource bfin_isp1761_resources[] = {
+	[0] = {
+		.name	= "isp1761-regs",
+		.start  = ISP1761_BASE + 0x00000000,
+		.end    = ISP1761_BASE + 0x000fffff,
+		.flags  = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start  = ISP1761_IRQ,
+		.end    = ISP1761_IRQ,
+		.flags  = IORESOURCE_IRQ | IORESOURCE_IRQ_LOWLEVEL,
+	},
+};
+
+static struct platform_device bfin_isp1761_device = {
+	.name           = "isp1761",
+	.id             = 0,
+	.num_resources  = ARRAY_SIZE(bfin_isp1761_resources),
+	.resource       = bfin_isp1761_resources,
+};
+
+static struct platform_device *bfin_isp1761_devices[] = {
+	&bfin_isp1761_device,
+};
+
+int __init bfin_isp1761_init(void)
+{
+	unsigned int num_devices=ARRAY_SIZE(bfin_isp1761_devices);
+
+	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	set_irq_type(ISP1761_IRQ, IRQF_TRIGGER_FALLING);
+
+	return platform_add_devices(bfin_isp1761_devices, num_devices);
+}
+
+void __exit bfin_isp1761_exit(void)
+{
+	platform_device_unregister(&bfin_isp1761_device);
+}
+
+arch_initcall(bfin_isp1761_init);
+#endif
+
 #if defined(CONFIG_BFIN_CFPCMCIA) || defined(CONFIG_BFIN_CFPCMCIA_MODULE)
 static struct resource bfin_pcmcia_cf_resources[] = {
 	{
diff -uprN linux-2.6-orig/arch/blackfin/mach-bf537/head.S linux-2.6/arch/blackfin/mach-bf537/head.S
--- linux-2.6-orig/arch/blackfin/mach-bf537/head.S	2007-03-05 11:50:21.000000000 +0800
+++ linux-2.6/arch/blackfin/mach-bf537/head.S	2007-03-05 11:57:23.000000000 +0800
@@ -240,7 +240,6 @@ ENTRY(__stext)
 	r0 = AMGCTLVAL;
 	w[p2] = r0;
 	ssync;
-	call _real_start;
 
 	/* This section keeps the processor in supervisor mode
 	 * during kernel boot.  Switches to user mode at end of boot.
diff -uprN linux-2.6-orig/arch/blackfin/mach-bf561/boards/generic_board.c linux-2.6/arch/blackfin/mach-bf561/boards/generic_board.c
--- linux-2.6-orig/arch/blackfin/mach-bf561/boards/generic_board.c	2007-03-05 11:50:21.000000000 +0800
+++ linux-2.6/arch/blackfin/mach-bf561/boards/generic_board.c	2007-03-05 11:57:23.000000000 +0800
@@ -34,6 +34,8 @@
 #include <linux/platform_device.h>
 #include <asm/irq.h>
 
+char *bfin_board_name = "UNKNOWN BOARD";
+
 /*
  *  Driver needs to know address, irq and flag pin.
  */
diff -uprN linux-2.6-orig/arch/blackfin/mach-common/cache.S linux-2.6/arch/blackfin/mach-common/cache.S
--- linux-2.6-orig/arch/blackfin/mach-common/cache.S	2007-03-05 11:50:21.000000000 +0800
+++ linux-2.6/arch/blackfin/mach-common/cache.S	2007-03-05 11:57:23.000000000 +0800
@@ -211,7 +211,7 @@ ENTRY(_dcache_invalidate)
 
 	/* Configures the data cache again */
 
-	R6 = (ACACHE_BCACHE | ENDCPLB | PORT_PREF0);
+	R6 = DMEM_CNTR;
 	R7 = R7 | R6;
 
 	CLI R6;
diff -uprN linux-2.6-orig/arch/blackfin/mach-common/cplbhdlr.S linux-2.6/arch/blackfin/mach-common/cplbhdlr.S
--- linux-2.6-orig/arch/blackfin/mach-common/cplbhdlr.S	2007-03-05 11:50:21.000000000 +0800
+++ linux-2.6/arch/blackfin/mach-common/cplbhdlr.S	2007-03-05 11:57:23.000000000 +0800
@@ -33,7 +33,11 @@
 #include <asm/cplb.h>
 #include <asm/entry.h>
 
+#ifdef CONFIG_EXCPT_IRQ_SYSC_L1
+.section .l1.text
+#else
 .text
+#endif
 
 .type _cplb_mgr, STT_FUNC;
 .type _panic_cplb_error, STT_FUNC;
diff -uprN linux-2.6-orig/arch/blackfin/mach-common/cplbmgr.S linux-2.6/arch/blackfin/mach-common/cplbmgr.S
--- linux-2.6-orig/arch/blackfin/mach-common/cplbmgr.S	2007-03-05 11:50:21.000000000 +0800
+++ linux-2.6/arch/blackfin/mach-common/cplbmgr.S	2007-03-05 13:54:10.000000000 +0800
@@ -55,7 +55,11 @@
 #include <asm/blackfin.h>
 #include <asm/cplb.h>
 
+#ifdef CONFIG_EXCPT_IRQ_SYSC_L1
+.section .l1.text
+#else
 .text
+#endif
 
 .align 2;
 ENTRY(_cplb_mgr)
diff -uprN linux-2.6-orig/arch/blackfin/mach-common/entry.S linux-2.6/arch/blackfin/mach-common/entry.S
--- linux-2.6-orig/arch/blackfin/mach-common/entry.S	2007-03-05 11:50:21.000000000 +0800
+++ linux-2.6/arch/blackfin/mach-common/entry.S	2007-03-05 13:39:47.000000000 +0800
@@ -79,13 +79,18 @@
 # define DEBUG_STOP_HWTRACE
 #endif
 
+#ifdef CONFIG_EXCPT_IRQ_SYSC_L1
+.section .l1.text
+#else
 .text
+#endif
 
 /* Slightly simplified and streamlined entry point for CPLB misses.
  * This one does not lower the level to IRQ5, and thus can be used to
  * patch up CPLB misses on the kernel stack.
  */
 ENTRY(_ex_dcplb)
+#if defined(ANOMALY_05000261)
 	/*
 	 * Work around an anomaly: if we see a new DCPLB fault, return
 	 * without doing anything.  Then, if we get the same fault again,
@@ -99,6 +104,7 @@ ENTRY(_ex_dcplb)
 	cc = r6 == r7;
 	if !cc jump _return_from_exception;
 	/* fall through */
+#endif
 
 ENTRY(_ex_icplb)
 	(R7:6,P5:4) = [sp++];
@@ -333,7 +339,7 @@ ENTRY(_trap) /* Exception: 4th entry int
 	[sp + PT_R0] = r7;	/* return value from system call */
 	jump .Lsyscall_really_exit;
 
-ENTRY(_execve)
+ENTRY(_kernel_execve)
 	link SIZEOF_PTREGS;
 	p0 = sp;
 	r3 = SIZEOF_PTREGS / 4;
@@ -749,7 +755,11 @@ ENTRY(_init_exception_buff)
  * a CPLB. This is needed to ensure we don't get double fault conditions
  */
 
+#ifdef CONFIG_SYSCALL_TAB_L1
+.section .l1.data
+#else
 .data
+#endif
 ALIGN
 _extable:
 	/* entry for each EXCAUSE[5:0]
@@ -1010,7 +1020,7 @@ ENTRY(_sys_call_table)
 	.long _sys_getcwd
 	.long _sys_capget
 	.long _sys_capset	/* 185 */
-	.long _sys_ni_syscall	/* old sys_sigaltstack */
+	.long _sys_sigaltstack
 	.long _sys_sendfile
 	.long _sys_ni_syscall	/* streams1 */
 	.long _sys_ni_syscall	/* streams2 */
@@ -1178,10 +1188,11 @@ _exception_stack:
 	.endr
 _exception_stack_top:
 
+#if defined(ANOMALY_05000261)
 /* Used by the assembly entry point to work around an anomaly.  */
 _last_cplb_fault_retx:
 	.long 0;
-
+#endif
 /*
  * Single instructions can have multiple faults, which need to be
  * handled by traps.c, in irq5. We store the exception cause to ensure
diff -uprN linux-2.6-orig/arch/blackfin/mach-common/ints-priority-dc.c linux-2.6/arch/blackfin/mach-common/ints-priority-dc.c
--- linux-2.6-orig/arch/blackfin/mach-common/ints-priority-dc.c	2007-03-05 11:50:21.000000000 +0800
+++ linux-2.6/arch/blackfin/mach-common/ints-priority-dc.c	2007-03-05 13:54:10.000000000 +0800
@@ -438,6 +438,10 @@ int __init init_arch_irq(void)
 	return 0;
 }
 
+#ifdef CONFIG_DO_IRQ_L1
+void do_irq(int vec, struct pt_regs *fp)__attribute__((l1_text));
+#endif
+
 void do_irq(int vec, struct pt_regs *fp)
 {
 	if (vec == EVT_IVTMR_P) {
diff -uprN linux-2.6-orig/arch/blackfin/mach-common/ints-priority-sc.c linux-2.6/arch/blackfin/mach-common/ints-priority-sc.c
--- linux-2.6-orig/arch/blackfin/mach-common/ints-priority-sc.c	2007-03-05 11:50:21.000000000 +0800
+++ linux-2.6/arch/blackfin/mach-common/ints-priority-sc.c	2007-03-05 11:57:23.000000000 +0800
@@ -547,6 +547,10 @@ int __init init_arch_irq(void)
 	return 0;
 }
 
+#ifdef CONFIG_DO_IRQ_L1
+void do_irq(int vec, struct pt_regs *fp)__attribute__((l1_text));
+#endif
+
 void do_irq(int vec, struct pt_regs *fp)
 {
 	if (vec == EVT_IVTMR_P) {
diff -uprN linux-2.6-orig/include/asm-blackfin/cplbinit.h linux-2.6/include/asm-blackfin/cplbinit.h
--- linux-2.6-orig/include/asm-blackfin/cplbinit.h	2007-03-05 11:50:22.000000000 +0800
+++ linux-2.6/include/asm-blackfin/cplbinit.h	2007-03-05 11:57:23.000000000 +0800
@@ -1,192 +1,205 @@
-/*
- * File:         include/asm-blackfin/cplbinit.h
- * Based on:
- * Author:
- *
- * Created:
- * Description:
- *
- * Rev:          $Id: cplbinit.h,v 1.3 2007/01/02 03:11:59 adamliyi Exp $
- *
- * Modified:
- *               Copyright 2004-2006 Analog Devices Inc.
- *
- * Bugs:         Enter bugs at http://blackfin.uclinux.org/
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see the file COPYING, or write
- * to the Free Software Foundation, Inc.,
- * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-
-#include <asm/blackfin.h>
-#include <asm/cplb.h>
-
-#define INITIAL_T 0x1
-#define SWITCH_T  0x2
-#define I_CPLB    0x4
-#define D_CPLB    0x8
-
-#define IN_KERNEL 1
-
-enum
-{ZERO_P, L1I_MEM, L1D_MEM, SDRAM_KERN , SDRAM_RAM_MTD, SDRAM_DMAZ, RES_MEM, ASYNC_MEM, L2_MEM};
-
-struct cplb_desc {
-	u32 start; /* start address */
-	u32 end; /* end address */
-	u32 psize; /* prefered size if any otherwise 1MB or 4MB*/
-	u16 attr;/* attributes */
-	u16 i_conf;/* I-CPLB DATA */
-	u16 d_conf;/* D-CPLB DATA */
-	u16 valid;/* valid */
-	const s8 name[30];/* name */
-};
-
-struct cplb_tab {
-  u_long *tab;
-	u16 pos;
-	u16 size;
-};
-
-u_long icplb_table[MAX_CPLBS+1];
-u_long dcplb_table[MAX_CPLBS+1];
-
-/* Till here we are discussing about the static memory management model.
- * However, the operating envoronments commonly define more CPLB
- * descriptors to cover the entire addressable memory than will fit into
- * the available on-chip 16 CPLB MMRs. When this happens, the below table
- * will be used which will hold all the potentially required CPLB descriptors
- *
- * This is how Page descriptor Table is implemented in uClinux/Blackfin.
- */
-
-u_long ipdt_table[MAX_SWITCH_I_CPLBS+1];
-u_long dpdt_table[MAX_SWITCH_D_CPLBS+1];
-
-#ifdef CONFIG_CPLB_INFO
-u_long ipdt_swapcount_table[MAX_SWITCH_I_CPLBS];
-u_long dpdt_swapcount_table[MAX_SWITCH_D_CPLBS];
-#endif
-
-struct s_cplb {
-	struct cplb_tab init_i;
-	struct cplb_tab init_d;
-	struct cplb_tab switch_i;
-	struct cplb_tab switch_d;
-};
-
-#if defined(CONFIG_BLKFIN_DCACHE) || defined(CONFIG_BLKFIN_CACHE)
-static struct cplb_desc cplb_data[] = {
-	{
-		.start = 0,
-		.end = SIZE_4K,
-		.psize = SIZE_4K,
-		.attr = INITIAL_T | SWITCH_T | I_CPLB | D_CPLB,
-		.i_conf = SDRAM_OOPS,
-		.d_conf = SDRAM_OOPS,
-#if defined(CONFIG_DEBUG_HUNT_FOR_ZERO)
-		.valid = 1,
-#else
-		.valid = 0,
-#endif
-		.name = "ZERO Pointer Saveguard",
-	},
-	{
-		.start = L1_CODE_START,
-		.end = L1_CODE_START + L1_CODE_LENGTH,
-		.psize = SIZE_4M,
-		.attr = INITIAL_T | SWITCH_T | I_CPLB,
-		.i_conf = L1_IMEMORY,
-		.d_conf = 0,
-		.valid = 1,
-		.name = "L1 I-Memory",
-	},
-	{
-		.start = L1_DATA_A_START,
-		.end = L1_DATA_B_START + L1_DATA_B_LENGTH,
-		.psize = SIZE_4M,
-		.attr = INITIAL_T | SWITCH_T | D_CPLB,
-		.i_conf = 0,
-		.d_conf = L1_DMEMORY,
-#if defined(CONFIG_BF536)
-		.valid = 0,
-#else
-		.valid = 1,
-#endif
-		.name = "L1 D-Memory",
-	},
-	{
-		.start = 0,
-		.end = 0,  /* dynamic */
-		.psize = 0,
-		.attr = INITIAL_T | SWITCH_T | I_CPLB | D_CPLB,
-		.i_conf =  SDRAM_IGENERIC,
-		.d_conf =  SDRAM_DGENERIC,
-		.valid = 1,
-		.name = "SDRAM Kernel",
-	},
-	{
-		.start = 0, /* dynamic */
-		.end = 0, /* dynamic */
-		.psize = 0,
-		.attr = INITIAL_T | SWITCH_T | D_CPLB,
-		.i_conf =  SDRAM_IGENERIC,
-		.d_conf =  SDRAM_DNON_CHBL,
-		.valid = 1,
-		.name = "SDRAM RAM MTD",
-	},
-	{
-		.start = 0, /* dynamic */
-		.end = 0,   /* dynamic */
-		.psize = SIZE_1M,
-		.attr = INITIAL_T | SWITCH_T | D_CPLB,
-		.d_conf = SDRAM_DNON_CHBL,
-		.valid = 1,//(DMA_UNCACHED_REGION > 0),
-		.name = "SDRAM Uncached DMA ZONE",
-	},
-	{
-		.start = 0, /* dynamic */
-		.end = 0, /* dynamic */
-		.psize = 0,
-		.attr = SWITCH_T | D_CPLB,
-		.i_conf = 0, /* dynamic */
-		.d_conf = 0, /* dynamic */
-		.valid = 1,
-		.name = "SDRAM Reserved Memory",
-	},
-	{
-		.start = ASYNC_BANK0_BASE,
-		.end = ASYNC_BANK3_BASE + ASYNC_BANK3_SIZE,
-		.psize = 0,
-		.attr = SWITCH_T | D_CPLB,
-		.d_conf = SDRAM_EBIU,
-		.valid = 1,
-		.name = "ASYNC Memory",
-	},
-	{
-#if defined(CONFIG_BF561)
-		.start = L2_SRAM,
-		.end = L2_SRAM_END,
-		.psize = SIZE_1M,
-		.attr = SWITCH_T | D_CPLB,
-		.i_conf = L2_MEMORY,
-		.d_conf = L2_MEMORY,
-		.valid = 1,
-#else
-		.valid = 0,
-#endif
-		.name = "L2 Memory",
-	}
-};
-#endif
+/*
+ * File:         include/asm-blackfin/cplbinit.h
+ * Based on:
+ * Author:
+ *
+ * Created:
+ * Description:
+ *
+ * Rev:          $Id: cplbinit.h,v 1.3 2007/01/02 03:11:59 adamliyi Exp $
+ *
+ * Modified:
+ *               Copyright 2004-2006 Analog Devices Inc.
+ *
+ * Bugs:         Enter bugs at http://blackfin.uclinux.org/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <asm/blackfin.h>
+#include <asm/cplb.h>
+
+#define INITIAL_T 0x1
+#define SWITCH_T  0x2
+#define I_CPLB    0x4
+#define D_CPLB    0x8
+
+#define IN_KERNEL 1
+
+enum
+{ZERO_P, L1I_MEM, L1D_MEM, SDRAM_KERN , SDRAM_RAM_MTD, SDRAM_DMAZ, RES_MEM, ASYNC_MEM, L2_MEM};
+
+struct cplb_desc {
+	u32 start; /* start address */
+	u32 end; /* end address */
+	u32 psize; /* prefered size if any otherwise 1MB or 4MB*/
+	u16 attr;/* attributes */
+	u16 i_conf;/* I-CPLB DATA */
+	u16 d_conf;/* D-CPLB DATA */
+	u16 valid;/* valid */
+	const s8 name[30];/* name */
+};
+
+struct cplb_tab {
+  u_long *tab;
+	u16 pos;
+	u16 size;
+};
+
+u_long icplb_table[MAX_CPLBS+1];
+u_long dcplb_table[MAX_CPLBS+1];
+
+/* Till here we are discussing about the static memory management model.
+ * However, the operating envoronments commonly define more CPLB
+ * descriptors to cover the entire addressable memory than will fit into
+ * the available on-chip 16 CPLB MMRs. When this happens, the below table
+ * will be used which will hold all the potentially required CPLB descriptors
+ *
+ * This is how Page descriptor Table is implemented in uClinux/Blackfin.
+ */
+
+#ifdef CONFIG_CPLB_SWITCH_TAB_L1
+u_long ipdt_table[MAX_SWITCH_I_CPLBS+1]__attribute__((l1_data));
+u_long dpdt_table[MAX_SWITCH_D_CPLBS+1]__attribute__((l1_data));
+
+#ifdef CONFIG_CPLB_INFO
+u_long ipdt_swapcount_table[MAX_SWITCH_I_CPLBS]__attribute__((l1_data));
+u_long dpdt_swapcount_table[MAX_SWITCH_D_CPLBS]__attribute__((l1_data));
+#endif /* CONFIG_CPLB_INFO */
+
+#else
+
+u_long ipdt_table[MAX_SWITCH_I_CPLBS+1];
+u_long dpdt_table[MAX_SWITCH_D_CPLBS+1];
+
+#ifdef CONFIG_CPLB_INFO
+u_long ipdt_swapcount_table[MAX_SWITCH_I_CPLBS];
+u_long dpdt_swapcount_table[MAX_SWITCH_D_CPLBS];
+#endif /* CONFIG_CPLB_INFO */
+
+#endif /*CONFIG_CPLB_SWITCH_TAB_L1*/
+
+struct s_cplb {
+	struct cplb_tab init_i;
+	struct cplb_tab init_d;
+	struct cplb_tab switch_i;
+	struct cplb_tab switch_d;
+};
+
+#if defined(CONFIG_BLKFIN_DCACHE) || defined(CONFIG_BLKFIN_CACHE)
+static struct cplb_desc cplb_data[] = {
+	{
+		.start = 0,
+		.end = SIZE_4K,
+		.psize = SIZE_4K,
+		.attr = INITIAL_T | SWITCH_T | I_CPLB | D_CPLB,
+		.i_conf = SDRAM_OOPS,
+		.d_conf = SDRAM_OOPS,
+#if defined(CONFIG_DEBUG_HUNT_FOR_ZERO)
+		.valid = 1,
+#else
+		.valid = 0,
+#endif
+		.name = "ZERO Pointer Saveguard",
+	},
+	{
+		.start = L1_CODE_START,
+		.end = L1_CODE_START + L1_CODE_LENGTH,
+		.psize = SIZE_4M,
+		.attr = INITIAL_T | SWITCH_T | I_CPLB,
+		.i_conf = L1_IMEMORY,
+		.d_conf = 0,
+		.valid = 1,
+		.name = "L1 I-Memory",
+	},
+	{
+		.start = L1_DATA_A_START,
+		.end = L1_DATA_B_START + L1_DATA_B_LENGTH,
+		.psize = SIZE_4M,
+		.attr = INITIAL_T | SWITCH_T | D_CPLB,
+		.i_conf = 0,
+		.d_conf = L1_DMEMORY,
+#if ((L1_DATA_A_LENGTH > 0) || (L1_DATA_B_LENGTH > 0))
+		.valid = 1,
+#else
+		.valid = 0,
+#endif
+		.name = "L1 D-Memory",
+	},
+	{
+		.start = 0,
+		.end = 0,  /* dynamic */
+		.psize = 0,
+		.attr = INITIAL_T | SWITCH_T | I_CPLB | D_CPLB,
+		.i_conf =  SDRAM_IGENERIC,
+		.d_conf =  SDRAM_DGENERIC,
+		.valid = 1,
+		.name = "SDRAM Kernel",
+	},
+	{
+		.start = 0, /* dynamic */
+		.end = 0, /* dynamic */
+		.psize = 0,
+		.attr = INITIAL_T | SWITCH_T | D_CPLB,
+		.i_conf =  SDRAM_IGENERIC,
+		.d_conf =  SDRAM_DNON_CHBL,
+		.valid = 1,
+		.name = "SDRAM RAM MTD",
+	},
+	{
+		.start = 0, /* dynamic */
+		.end = 0,   /* dynamic */
+		.psize = SIZE_1M,
+		.attr = INITIAL_T | SWITCH_T | D_CPLB,
+		.d_conf = SDRAM_DNON_CHBL,
+		.valid = 1,//(DMA_UNCACHED_REGION > 0),
+		.name = "SDRAM Uncached DMA ZONE",
+	},
+	{
+		.start = 0, /* dynamic */
+		.end = 0, /* dynamic */
+		.psize = 0,
+		.attr = SWITCH_T | D_CPLB,
+		.i_conf = 0, /* dynamic */
+		.d_conf = 0, /* dynamic */
+		.valid = 1,
+		.name = "SDRAM Reserved Memory",
+	},
+	{
+		.start = ASYNC_BANK0_BASE,
+		.end = ASYNC_BANK3_BASE + ASYNC_BANK3_SIZE,
+		.psize = 0,
+		.attr = SWITCH_T | D_CPLB,
+		.d_conf = SDRAM_EBIU,
+		.valid = 1,
+		.name = "ASYNC Memory",
+	},
+	{
+#if defined(CONFIG_BF561)
+		.start = L2_SRAM,
+		.end = L2_SRAM_END,
+		.psize = SIZE_1M,
+		.attr = SWITCH_T | D_CPLB,
+		.i_conf = L2_MEMORY,
+		.d_conf = L2_MEMORY,
+		.valid = 1,
+#else
+		.valid = 0,
+#endif
+		.name = "L2 Memory",
+	}
+};
+#endif
diff -uprN linux-2.6-orig/include/asm-blackfin/delay.h linux-2.6/include/asm-blackfin/delay.h
--- linux-2.6-orig/include/asm-blackfin/delay.h	2007-03-05 11:50:22.000000000 +0800
+++ linux-2.6/include/asm-blackfin/delay.h	2007-03-05 11:57:23.000000000 +0800
@@ -7,10 +7,11 @@ static inline void __delay(unsigned long
 /* FIXME: Currently the assembler doesn't recognize Loop Register Clobbers,
    uncomment this as soon those are implemented */
 /*
-      __asm__ __volatile__ (  "\t LSETUP (1,1) LC0= %0\n\t"
-                              "l:\t NOP;\n\t"
+      __asm__ __volatile__ (  "\t LSETUP (1f,1f) LC0= %0\n\t"
+                              "1:\t NOP;\n\t"
                               : :"a" (loops)
                               : "LT0","LB0","LC0");
+
 */
 
 	__asm__ __volatile__("[--SP] = LC0;\n\t"
diff -uprN linux-2.6-orig/include/asm-blackfin/dma-mapping.h linux-2.6/include/asm-blackfin/dma-mapping.h
--- linux-2.6-orig/include/asm-blackfin/dma-mapping.h	2007-03-05 11:50:22.000000000 +0800
+++ linux-2.6/include/asm-blackfin/dma-mapping.h	2007-03-05 11:57:23.000000000 +0800
@@ -65,4 +65,9 @@ static inline
 	BUG_ON(direction == DMA_NONE);
 }
 
+/* Now for the API extensions over the pci_ one */
+
+#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
+#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
+
 #endif				/* _BLACKFIN_DMA_MAPPING_H */
diff -uprN linux-2.6-orig/include/asm-blackfin/mach-bf533/bf533.h linux-2.6/include/asm-blackfin/mach-bf533/bf533.h
--- linux-2.6-orig/include/asm-blackfin/mach-bf533/bf533.h	2007-03-05 11:50:22.000000000 +0800
+++ linux-2.6/include/asm-blackfin/mach-bf533/bf533.h	2007-03-05 13:54:10.000000000 +0800
@@ -53,15 +53,6 @@
 
 /***************************/
 
-#define BLKFIN_ICACHESIZE	(16*1024)
-
-#if defined(CONFIG_BF533) || defined(CONFIG_BF532)
-#define BLKFIN_DCACHESIZE	(32*1024)
-#define BLKFIN_DSUPBANKS	2
-#else
-#define BLKFIN_DCACHESIZE	(16*1024)
-#define BLKFIN_DSUPBANKS	1
-#endif
 
 #define BLKFIN_DSUBBANKS	4
 #define BLKFIN_DWAYS		2
@@ -280,7 +271,7 @@
 			| CPLB_SUPV_WR | CPLB_USER_WR | CPLB_USER_RD | CPLB_VALID | ANOMALY_05000158_WORKAROUND)
 #endif
 
-#define L1_DMEMORY       (CPLB_SUPV_WR | CPLB_USER_WR | CPLB_USER_RD | CPLB_VALID | ANOMALY_05000158_WORKAROUND | CPLB_DIRTY)
+#define L1_DMEMORY       (CPLB_SUPV_WR | CPLB_USER_WR | CPLB_USER_RD | CPLB_VALID | ANOMALY_05000158_WORKAROUND | CPLB_LOCK | CPLB_DIRTY)
 #define SDRAM_DNON_CHBL  (CPLB_SUPV_WR | CPLB_USER_WR | CPLB_USER_RD | CPLB_VALID | ANOMALY_05000158_WORKAROUND | CPLB_DIRTY)
 #define SDRAM_EBIU       (CPLB_SUPV_WR | CPLB_USER_WR | CPLB_USER_RD | CPLB_VALID | ANOMALY_05000158_WORKAROUND | CPLB_DIRTY)
 #define SDRAM_OOPS  	 (CPLB_VALID | ANOMALY_05000158_WORKAROUND | CPLB_LOCK | CPLB_DIRTY)
diff -uprN linux-2.6-orig/include/asm-blackfin/mach-bf533/mem_map.h linux-2.6/include/asm-blackfin/mach-bf533/mem_map.h
--- linux-2.6-orig/include/asm-blackfin/mach-bf533/mem_map.h	2007-03-05 11:50:22.000000000 +0800
+++ linux-2.6/include/asm-blackfin/mach-bf533/mem_map.h	2007-03-05 11:57:23.000000000 +0800
@@ -52,6 +52,12 @@
 
 /* Level 1 Memory */
 
+#ifdef CONFIG_BLKFIN_CACHE
+#define BLKFIN_ICACHESIZE	(16*1024)
+#else
+#define BLKFIN_ICACHESIZE	(0*1024)
+#endif
+
 /* Memory Map for ADSP-BF533 processors */
 
 #ifdef CONFIG_BF533
@@ -66,18 +72,28 @@
 #endif
 
 #ifdef CONFIG_BLKFIN_DCACHE
-#define DMEM_CNTR (ACACHE_BCACHE | ENDCPLB | PORT_PREF0)
+
+#ifdef CONFIG_BLKFIN_DCACHE_BANKA
+#define DMEM_CNTR (ACACHE_BSRAM | ENDCPLB | PORT_PREF0)
 #define L1_DATA_A_LENGTH      (0x8000 - 0x4000)
+#define L1_DATA_B_LENGTH      0x8000
+#define BLKFIN_DCACHESIZE	(16*1024)
+#define BLKFIN_DSUPBANKS	1
 #else
-#define DMEM_CNTR (ASRAM_BSRAM | ENDCPLB | PORT_PREF0)
-#define L1_DATA_A_LENGTH      0x8000
+#define DMEM_CNTR (ACACHE_BCACHE | ENDCPLB | PORT_PREF0)
+#define L1_DATA_A_LENGTH      (0x8000 - 0x4000)
+#define L1_DATA_B_LENGTH      (0x8000 - 0x4000)
+#define BLKFIN_DCACHESIZE	(32*1024)
+#define BLKFIN_DSUPBANKS	2
 #endif
 
-#ifdef CONFIG_BLKFIN_DCACHE
-#define L1_DATA_B_LENGTH      (0x8000 - 0x4000)
 #else
+#define DMEM_CNTR (ASRAM_BSRAM | ENDCPLB | PORT_PREF0)
+#define L1_DATA_A_LENGTH      0x8000
 #define L1_DATA_B_LENGTH      0x8000
-#endif
+#define BLKFIN_DCACHESIZE	(0*1024)
+#define BLKFIN_DSUPBANKS	0
+#endif /*CONFIG_BLKFIN_DCACHE*/
 #endif
 
 /* Memory Map for ADSP-BF532 processors */
@@ -94,18 +110,29 @@
 #endif
 
 #ifdef CONFIG_BLKFIN_DCACHE
-#define DMEM_CNTR (ACACHE_BCACHE | ENDCPLB | PORT_PREF0)
+
+#ifdef CONFIG_BLKFIN_DCACHE_BANKA
+#define DMEM_CNTR (ACACHE_BSRAM | ENDCPLB | PORT_PREF0)
 #define L1_DATA_A_LENGTH      (0x4000 - 0x4000)
+#define L1_DATA_B_LENGTH      0x4000
+#define BLKFIN_DCACHESIZE	(16*1024)
+#define BLKFIN_DSUPBANKS	1
+
 #else
-#define DMEM_CNTR (ASRAM_BSRAM | ENDCPLB | PORT_PREF0)
-#define L1_DATA_A_LENGTH      0x4000
+#define DMEM_CNTR (ACACHE_BCACHE | ENDCPLB | PORT_PREF0)
+#define L1_DATA_A_LENGTH      (0x4000 - 0x4000)
+#define L1_DATA_B_LENGTH      (0x4000 - 0x4000)
+#define BLKFIN_DCACHESIZE	(32*1024)
+#define BLKFIN_DSUPBANKS	2
 #endif
 
-#ifdef CONFIG_BLKFIN_DCACHE
-#define L1_DATA_B_LENGTH      (0x4000 - 0x4000)
 #else
+#define DMEM_CNTR (ASRAM_BSRAM | ENDCPLB | PORT_PREF0)
+#define L1_DATA_A_LENGTH      0x4000
 #define L1_DATA_B_LENGTH      0x4000
-#endif
+#define BLKFIN_DCACHESIZE	(0*1024)
+#define BLKFIN_DSUPBANKS	0
+#endif /*CONFIG_BLKFIN_DCACHE*/
 #endif
 
 /* Memory Map for ADSP-BF531 processors */
@@ -116,13 +143,20 @@
 #define L1_DATA_B_START     0xFF904000
 #define L1_CODE_LENGTH      0x4000
 #define L1_DATA_B_LENGTH      0x0000
+
+
 #ifdef CONFIG_BLKFIN_DCACHE
-#define DMEM_CNTR (ACACHE_BSRAM | ENDCPLB)
+#define DMEM_CNTR (ACACHE_BSRAM | ENDCPLB  | PORT_PREF0)
 #define L1_DATA_A_LENGTH      (0x4000 - 0x4000)
+#define BLKFIN_DCACHESIZE	(16*1024)
+#define BLKFIN_DSUPBANKS	1
 #else
-#define DMEM_CNTR (ASRAM_BSRAM | ENDCPLB)
+#define DMEM_CNTR (ASRAM_BSRAM | ENDCPLB  | PORT_PREF0)
 #define L1_DATA_A_LENGTH      0x4000
+#define BLKFIN_DCACHESIZE	(0*1024)
+#define BLKFIN_DSUPBANKS	0
 #endif
+
 #endif
 
 /* Scratch Pad Memory */
diff -uprN linux-2.6-orig/include/asm-blackfin/mach-bf537/bf537.h linux-2.6/include/asm-blackfin/mach-bf537/bf537.h
--- linux-2.6-orig/include/asm-blackfin/mach-bf537/bf537.h	2007-03-05 11:50:22.000000000 +0800
+++ linux-2.6/include/asm-blackfin/mach-bf537/bf537.h	2007-03-05 11:57:23.000000000 +0800
@@ -63,15 +63,6 @@
 
 /***************************/
 
-#define BLKFIN_ICACHESIZE	(16*1024)
-
-#if defined(CONFIG_BF537) || defined(CONFIG_BF534)
-#define BLKFIN_DCACHESIZE	(32*1024)
-#define BLKFIN_DSUPBANKS	2
-#else
-#define BLKFIN_DCACHESIZE	(16*1024)
-#define BLKFIN_DSUPBANKS	1
-#endif
 
 #define BLKFIN_DSUBBANKS	4
 #define BLKFIN_DWAYS		2
@@ -261,7 +252,7 @@
 #endif
 
 
-#define L1_DMEMORY       (CPLB_SUPV_WR | CPLB_USER_WR | CPLB_USER_RD | CPLB_VALID | ANOMALY_05000158_WORKAROUND | CPLB_DIRTY )
+#define L1_DMEMORY       (CPLB_SUPV_WR | CPLB_USER_WR | CPLB_USER_RD | CPLB_VALID | ANOMALY_05000158_WORKAROUND | CPLB_LOCK | CPLB_DIRTY )
 #define SDRAM_DNON_CHBL  (CPLB_SUPV_WR | CPLB_USER_WR | CPLB_USER_RD | CPLB_VALID | ANOMALY_05000158_WORKAROUND | CPLB_DIRTY )
 #define SDRAM_EBIU       (CPLB_SUPV_WR | CPLB_USER_WR | CPLB_USER_RD | CPLB_VALID | ANOMALY_05000158_WORKAROUND | CPLB_DIRTY )
 #define SDRAM_OOPS  	 (CPLB_VALID | ANOMALY_05000158_WORKAROUND | CPLB_LOCK | CPLB_DIRTY )
diff -uprN linux-2.6-orig/include/asm-blackfin/mach-bf537/defBF534.h linux-2.6/include/asm-blackfin/mach-bf537/defBF534.h
--- linux-2.6-orig/include/asm-blackfin/mach-bf537/defBF534.h	2007-03-05 11:50:22.000000000 +0800
+++ linux-2.6/include/asm-blackfin/mach-bf537/defBF534.h	2007-03-05 11:57:23.000000000 +0800
@@ -1171,7 +1171,7 @@
 #define GM			0x0008	/* Get More (When RDBR Full, Overwrite/Discard*)        */
 #define PSSE		0x0010	/* Slave-Select Input Enable                                            */
 #define EMISO		0x0020	/* Enable MISO As Output                                                        */
-#define SIZE		0x0100	/* Size of Words (16/8* Bits)                                           */
+#define SPI_SIZE	0x0100	/* Size of Words (16/8* Bits)                                           */
 #define LSBF		0x0200	/* LSB First                                                                            */
 #define CPHA		0x0400	/* Clock Phase                                                                          */
 #define CPOL		0x0800	/* Clock Polarity                                                                       */
diff -uprN linux-2.6-orig/include/asm-blackfin/mach-bf537/mem_map.h linux-2.6/include/asm-blackfin/mach-bf537/mem_map.h
--- linux-2.6-orig/include/asm-blackfin/mach-bf537/mem_map.h	2007-03-05 11:50:22.000000000 +0800
+++ linux-2.6/include/asm-blackfin/mach-bf537/mem_map.h	2007-03-05 11:57:23.000000000 +0800
@@ -59,6 +59,13 @@
 
 /* Memory Map for ADSP-BF537 processors */
 
+#ifdef CONFIG_BLKFIN_CACHE
+#define BLKFIN_ICACHESIZE	(16*1024)
+#else
+#define BLKFIN_ICACHESIZE	(0*1024)
+#endif
+
+
 #ifdef CONFIG_BF537
 #define L1_CODE_START       0xFFA00000
 #define L1_DATA_A_START     0xFF800000
@@ -67,20 +74,30 @@
 #define L1_CODE_LENGTH      0xC000
 
 #ifdef CONFIG_BLKFIN_DCACHE
-#define DMEM_CNTR (ACACHE_BCACHE | ENDCPLB | PORT_PREF0)
+
+#ifdef CONFIG_BLKFIN_DCACHE_BANKA
+#define DMEM_CNTR (ACACHE_BSRAM | ENDCPLB | PORT_PREF0)
 #define L1_DATA_A_LENGTH      (0x8000 - 0x4000)
+#define L1_DATA_B_LENGTH      0x8000
+#define BLKFIN_DCACHESIZE	(16*1024)
+#define BLKFIN_DSUPBANKS	1
 #else
-#define DMEM_CNTR (ASRAM_BSRAM | ENDCPLB | PORT_PREF0)
-#define L1_DATA_A_LENGTH      0x8000
+#define DMEM_CNTR (ACACHE_BCACHE | ENDCPLB | PORT_PREF0)
+#define L1_DATA_A_LENGTH      (0x8000 - 0x4000)
+#define L1_DATA_B_LENGTH      (0x8000 - 0x4000)
+#define BLKFIN_DCACHESIZE	(32*1024)
+#define BLKFIN_DSUPBANKS	2
 #endif
 
-#ifdef CONFIG_BLKFIN_DCACHE
-#define L1_DATA_B_LENGTH      (0x8000 - 0x4000)
 #else
+#define DMEM_CNTR (ASRAM_BSRAM | ENDCPLB | PORT_PREF0)
+#define L1_DATA_A_LENGTH      0x8000
 #define L1_DATA_B_LENGTH      0x8000
-#endif
+#define BLKFIN_DCACHESIZE	(0*1024)
+#define BLKFIN_DSUPBANKS	0
+#endif /*CONFIG_BLKFIN_DCACHE*/
 
-#endif
+#endif /*CONFIG_BF537*/
 
 /* Memory Map for ADSP-BF536 processors */
 
@@ -91,19 +108,31 @@
 
 #define L1_CODE_LENGTH      0xC000
 
+
 #ifdef CONFIG_BLKFIN_DCACHE
-#define DMEM_CNTR (ACACHE_BSRAM | ENDCPLB)
+
+#ifdef CONFIG_BLKFIN_DCACHE_BANKA
+#define DMEM_CNTR (ACACHE_BSRAM | ENDCPLB | PORT_PREF0)
 #define L1_DATA_A_LENGTH      (0x4000 - 0x4000)
+#define L1_DATA_B_LENGTH      0x4000
+#define BLKFIN_DCACHESIZE	(16*1024)
+#define BLKFIN_DSUPBANKS	1
+
 #else
-#define DMEM_CNTR (ASRAM_BSRAM | ENDCPLB)
-#define L1_DATA_A_LENGTH      0x4000
+#define DMEM_CNTR (ACACHE_BCACHE | ENDCPLB | PORT_PREF0)
+#define L1_DATA_A_LENGTH      (0x4000 - 0x4000)
+#define L1_DATA_B_LENGTH      (0x4000 - 0x4000)
+#define BLKFIN_DCACHESIZE	(32*1024)
+#define BLKFIN_DSUPBANKS	2
 #endif
 
-#ifdef CONFIG_BLKFIN_DCACHE
-#define L1_DATA_B_LENGTH      (0x4000 - 0x4000)
 #else
+#define DMEM_CNTR (ASRAM_BSRAM | ENDCPLB | PORT_PREF0)
+#define L1_DATA_A_LENGTH      0x4000
 #define L1_DATA_B_LENGTH      0x4000
-#endif
+#define BLKFIN_DCACHESIZE	(0*1024)
+#define BLKFIN_DSUPBANKS	0
+#endif /*CONFIG_BLKFIN_DCACHE*/
 
 #endif
 
@@ -118,18 +147,28 @@
 
 #ifdef CONFIG_BLKFIN_DCACHE
 
-#define DMEM_CNTR (ACACHE_BCACHE | ENDCPLB | PORT_PREF0)
+#ifdef CONFIG_BLKFIN_DCACHE_BANKA
+#define DMEM_CNTR (ACACHE_BSRAM | ENDCPLB | PORT_PREF0)
 #define L1_DATA_A_LENGTH      (0x8000 - 0x4000)
+#define L1_DATA_B_LENGTH      0x8000
+#define BLKFIN_DCACHESIZE	(16*1024)
+#define BLKFIN_DSUPBANKS	1
+
 #else
-#define DMEM_CNTR (ASRAM_BSRAM | ENDCPLB | PORT_PREF0)
-#define L1_DATA_A_LENGTH      0x8000
-#endif
-#ifdef CONFIG_BLKFIN_DCACHE
+#define DMEM_CNTR (ACACHE_BCACHE | ENDCPLB | PORT_PREF0)
+#define L1_DATA_A_LENGTH      (0x8000 - 0x4000)
 #define L1_DATA_B_LENGTH      (0x8000 - 0x4000)
+#define BLKFIN_DCACHESIZE	(32*1024)
+#define BLKFIN_DSUPBANKS	2
+#endif
 
 #else
+#define DMEM_CNTR (ASRAM_BSRAM | ENDCPLB | PORT_PREF0)
+#define L1_DATA_A_LENGTH      0x8000
 #define L1_DATA_B_LENGTH      0x8000
-#endif
+#define BLKFIN_DCACHESIZE	(0*1024)
+#define BLKFIN_DSUPBANKS	0
+#endif /*CONFIG_BLKFIN_DCACHE*/
 
 #endif
 
diff -uprN linux-2.6-orig/include/asm-blackfin/mach-bf561/bf561.h linux-2.6/include/asm-blackfin/mach-bf561/bf561.h
--- linux-2.6-orig/include/asm-blackfin/mach-bf561/bf561.h	2007-03-05 11:50:22.000000000 +0800
+++ linux-2.6/include/asm-blackfin/mach-bf561/bf561.h	2007-03-05 13:54:10.000000000 +0800
@@ -74,14 +74,11 @@
  * Blackfin Cache setup
  */
 
-#define BLKFIN_ICACHESIZE	(16*1024)
-#define BLKFIN_DCACHESIZE	(32*1024)
 
 #define BLKFIN_ISUBBANKS	4
 #define BLKFIN_IWAYS		4
 #define BLKFIN_ILINES		32
 
-#define BLKFIN_DSUPBANKS	2
 #define BLKFIN_DSUBBANKS	4
 #define BLKFIN_DWAYS		2
 #define BLKFIN_DLINES		64
@@ -351,7 +348,7 @@
 #endif
 
 
-#define L1_DMEMORY       (CPLB_SUPV_WR | CPLB_USER_WR | CPLB_USER_RD | CPLB_VALID | ANOMALY_05000158_WORKAROUND | CPLB_DIRTY)
+#define L1_DMEMORY       (CPLB_SUPV_WR | CPLB_USER_WR | CPLB_USER_RD | CPLB_VALID | ANOMALY_05000158_WORKAROUND | CPLB_LOCK | CPLB_DIRTY)
 #define SDRAM_DNON_CHBL  (CPLB_SUPV_WR | CPLB_USER_WR | CPLB_USER_RD | CPLB_VALID | ANOMALY_05000158_WORKAROUND | CPLB_DIRTY)
 #define SDRAM_EBIU       (CPLB_SUPV_WR | CPLB_USER_WR | CPLB_USER_RD | CPLB_VALID | ANOMALY_05000158_WORKAROUND | CPLB_DIRTY)
 #define SDRAM_OOPS  	 (CPLB_VALID | ANOMALY_05000158_WORKAROUND | CPLB_LOCK | CPLB_DIRTY)
diff -uprN linux-2.6-orig/include/asm-blackfin/mach-bf561/mem_map.h linux-2.6/include/asm-blackfin/mach-bf561/mem_map.h
--- linux-2.6-orig/include/asm-blackfin/mach-bf561/mem_map.h	2007-03-05 11:50:22.000000000 +0800
+++ linux-2.6/include/asm-blackfin/mach-bf561/mem_map.h	2007-03-05 11:57:23.000000000 +0800
@@ -23,6 +23,12 @@
 
 /* Level 1 Memory */
 
+#ifdef CONFIG_BLKFIN_CACHE
+#define BLKFIN_ICACHESIZE	(16*1024)
+#else
+#define BLKFIN_ICACHESIZE	(0*1024)
+#endif
+
 /* Memory Map for ADSP-BF561 processors */
 
 #ifdef CONFIG_BF561
@@ -33,18 +39,28 @@
 #define L1_CODE_LENGTH      0x4000
 
 #ifdef CONFIG_BLKFIN_DCACHE
-#define DMEM_CNTR (ACACHE_BCACHE | ENDCPLB | PORT_PREF0)
+
+#ifdef CONFIG_BLKFIN_DCACHE_BANKA
+#define DMEM_CNTR (ACACHE_BSRAM | ENDCPLB | PORT_PREF0)
 #define L1_DATA_A_LENGTH      (0x8000 - 0x4000)
+#define L1_DATA_B_LENGTH      0x8000
+#define BLKFIN_DCACHESIZE	(16*1024)
+#define BLKFIN_DSUPBANKS	1
 #else
-#define DMEM_CNTR (ASRAM_BSRAM | ENDCPLB | PORT_PREF0)
-#define L1_DATA_A_LENGTH      0x8000
+#define DMEM_CNTR (ACACHE_BCACHE | ENDCPLB | PORT_PREF0)
+#define L1_DATA_A_LENGTH      (0x8000 - 0x4000)
+#define L1_DATA_B_LENGTH      (0x8000 - 0x4000)
+#define BLKFIN_DCACHESIZE	(32*1024)
+#define BLKFIN_DSUPBANKS	2
 #endif
 
-#ifdef CONFIG_BLKFIN_DCACHE
-#define L1_DATA_B_LENGTH      (0x8000 - 0x4000)
 #else
+#define DMEM_CNTR (ASRAM_BSRAM | ENDCPLB | PORT_PREF0)
+#define L1_DATA_A_LENGTH      0x8000
 #define L1_DATA_B_LENGTH      0x8000
-#endif
+#define BLKFIN_DCACHESIZE	(0*1024)
+#define BLKFIN_DSUPBANKS	0
+#endif /*CONFIG_BLKFIN_DCACHE*/
 #endif
 
 /* Level 2 Memory */
diff -uprN linux-2.6-orig/include/asm-blackfin/pgtable.h linux-2.6/include/asm-blackfin/pgtable.h
--- linux-2.6-orig/include/asm-blackfin/pgtable.h	2007-03-05 11:50:22.000000000 +0800
+++ linux-2.6/include/asm-blackfin/pgtable.h	2007-03-05 11:57:23.000000000 +0800
@@ -59,4 +59,12 @@ extern unsigned int kobjsize(const void 
 #define	VMALLOC_START	0
 #define	VMALLOC_END	0xffffffff
 
+#define  __HAVE_ARCH_ENTER_LAZY_CPU_MODE
+#define arch_enter_lazy_cpu_mode()	do {} while (0)
+#define arch_leave_lazy_cpu_mode()	do {} while (0)
+
+#define  __HAVE_ARCH_ENTER_LAZY_MMU_MODE
+#define arch_enter_lazy_mmu_mode()	do {} while (0)
+#define arch_leave_lazy_mmu_mode()	do {} while (0)
+
 #endif				/* _BLACKFIN_PGTABLE_H */
diff -uprN linux-2.6-orig/include/asm-blackfin/uaccess.h linux-2.6/include/asm-blackfin/uaccess.h
--- linux-2.6-orig/include/asm-blackfin/uaccess.h	2007-03-05 11:50:22.000000000 +0800
+++ linux-2.6/include/asm-blackfin/uaccess.h	2007-03-05 11:57:23.000000000 +0800
@@ -41,48 +41,15 @@ extern int is_in_rom(unsigned long);
  * get_fs() == KERNEL_DS, checking is bypassed.
  */
 
-static inline int _access_ok(unsigned long addr, unsigned long size)
-{
 #ifdef CONFIG_NO_ACCESS_CHECK
-	return 1;
+static inline int _access_ok(unsigned long addr, unsigned long size) { return 1; } 
 #else
-	if (addr > (addr + size))
-		return 0;
-	if (segment_eq(get_fs(),KERNEL_DS))
-		return 1;
-#ifdef CONFIG_MTD_UCLINUX
-	if (addr >= memory_start && (addr + size) <= memory_end)
-		return 1;
-	if (addr >= memory_mtd_end && (addr + size) <= physical_mem_end)
-		return 1;
+#ifdef CONFIG_ACCESS_OK_L1
+extern int _access_ok(unsigned long addr, unsigned long size)__attribute__((l1_text));
 #else
-	if (addr >= memory_start && (addr + size) <= physical_mem_end)
-		return 1;
-#endif
-	if (addr >= (unsigned long)__init_begin &&
-	    addr + size <= (unsigned long)__init_end)
-		return 1;
-	if (addr >= L1_SCRATCH_START
-	    && addr + size <= L1_SCRATCH_START + L1_SCRATCH_LENGTH)
-		return 1;
-#if L1_CODE_LENGTH != 0
-	if (addr >= L1_CODE_START + (_etext_l1 - _stext_l1)
-	    && addr + size <= L1_CODE_START + L1_CODE_LENGTH)
-		return 1;
-#endif
-#if L1_DATA_A_LENGTH != 0
-	if (addr >= L1_DATA_A_START + (_ebss_l1 - _sdata_l1)
-	    && addr + size <= L1_DATA_A_START + L1_DATA_A_LENGTH)
-		return 1;
+extern int _access_ok(unsigned long addr, unsigned long size);
 #endif
-#if L1_DATA_B_LENGTH != 0
-	if (addr >= L1_DATA_B_START
-	    && addr + size <= L1_DATA_B_START + L1_DATA_B_LENGTH)
-		return 1;
 #endif
-	return 0;
-#endif
-}
 
 /*
  * The exception table consists of pairs of addresses: the first is the
diff -uprN linux-2.6-orig/include/asm-blackfin/unistd.h linux-2.6/include/asm-blackfin/unistd.h
--- linux-2.6-orig/include/asm-blackfin/unistd.h	2007-03-05 11:50:22.000000000 +0800
+++ linux-2.6/include/asm-blackfin/unistd.h	2007-03-05 11:57:23.000000000 +0800
@@ -188,7 +188,7 @@
 #define __NR_getcwd		183
 #define __NR_capget		184
 #define __NR_capset		185
-				/* 186 __NR_sigaltstack obsolete */
+#define __NR_sigaltstack	186
 #define __NR_sendfile		187
 				/* 188 __NR_getpmsg */
 				/* 189 __NR_putpmsg */
diff -uprN linux-2.6-orig/include/asm-blackfin/xor.h linux-2.6/include/asm-blackfin/xor.h
--- linux-2.6-orig/include/asm-blackfin/xor.h	1970-01-01 08:00:00.000000000 +0800
+++ linux-2.6/include/asm-blackfin/xor.h	2007-03-05 11:57:23.000000000 +0800
@@ -0,0 +1 @@
+#include <asm-generic/xor.h>
diff -uprN linux-2.6-orig/init/Kconfig linux-2.6/init/Kconfig
--- linux-2.6-orig/init/Kconfig	2007-03-05 11:50:22.000000000 +0800
+++ linux-2.6/init/Kconfig	2007-03-05 11:57:23.000000000 +0800
@@ -336,7 +336,7 @@ menuconfig EMBEDDED
 
 config UID16
 	bool "Enable 16-bit UID system calls" if EMBEDDED
-	depends on ARM || CRIS || FRV || H8300 || X86_32 || M68K || (S390 && !64BIT) || SUPERH || SPARC32 || (SPARC64 && SPARC32_COMPAT) || UML || (X86_64 && IA32_EMULATION) || BFIN
+	depends on ARM || BFIN || CRIS || FRV || H8300 || X86_32 || M68K || (S390 && !64BIT) || SUPERH || SPARC32 || (SPARC64 && SPARC32_COMPAT) || UML || (X86_64 && IA32_EMULATION)
 	default y
 	help
 	  This enables the legacy 16-bit UID syscall wrappers.
@@ -443,7 +443,6 @@ config FUTEX
 config EPOLL
 	bool "Enable eventpoll support" if EMBEDDED
 	default y
-	depends on MMU
 	help
 	  Disabling this option will cause the kernel to be built without
 	  support for epoll family of system calls.
_

Thanks
-Bryan Wu
