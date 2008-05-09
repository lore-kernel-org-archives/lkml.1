Return-Path: <linux-kernel-owner+w=401wt.eu-S932208AbYEIR1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208AbYEIR1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 13:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757683AbYEIR1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 13:27:30 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:49550 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145AbYEIR1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 13:27:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=RqI3rd/YwTt1Pt8ArT2jbPJDRifHxUerunxKhqn7bqBK9B2jh4WOvtWgtvLwikL7jpcPzCrFmNLe7VoKGMyuzftVT8oN89VMRvRIpaRq448bjkEnSPPZoGtdOzfUz14PjwnR42mXx7tE7YY2ZqJVHHyEDTcQIpyfk5g1hZzcdMI=
Message-ID: <386072610805091027p689b1500k50dcad98a8b765f@mail.gmail.com>
Date: Sat, 10 May 2008 01:27:16 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Blackfin arch/serial driver fixing and updates for 2.6.26-rc1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 81b1acfb32fe66dd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'for-linus' branch of

master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git for-linus

to receive the following updates:

 arch/blackfin/Kconfig                              |   18 ++-
 arch/blackfin/kernel/asm-offsets.c                 |    3 -
 arch/blackfin/kernel/fixed_code.S                  |    2 +-
 arch/blackfin/kernel/module.c                      |   37 +++--
 arch/blackfin/kernel/process.c                     |    2 +-
 arch/blackfin/kernel/ptrace.c                      |    4 +-
 arch/blackfin/kernel/signal.c                      |   13 ++
 arch/blackfin/kernel/time-ts.c                     |   10 +-
 arch/blackfin/mach-bf527/boards/ezkit.c            |  104 ++++++++++++++-
 arch/blackfin/mach-bf533/boards/cm_bf533.c         |   33 +++++
 arch/blackfin/mach-bf533/boards/ezkit.c            |   31 +++++
 arch/blackfin/mach-bf533/boards/stamp.c            |   31 +++++
 arch/blackfin/mach-bf537/boards/cm_bf537.c         |   33 +++++
 arch/blackfin/mach-bf537/boards/stamp.c            |   31 +++++
 arch/blackfin/mach-bf548/boards/cm_bf548.c         |   34 +++++
 arch/blackfin/mach-bf548/boards/ezkit.c            |   32 +++++
 arch/blackfin/mach-bf561/boards/cm_bf561.c         |   32 +++++
 arch/blackfin/mach-bf561/boards/ezkit.c            |   31 +++++
 arch/blackfin/mach-common/Makefile                 |    5 +-
 arch/blackfin/mach-common/cpufreq.c                |   26 +++--
 arch/blackfin/mach-common/dpmc.c                   |  137 ++++++++++++++++++++
 arch/blackfin/mach-common/{dpmc.S => dpmc_modes.S} |   27 +----
 arch/blackfin/mach-common/entry.S                  |  113 ++++++++++++-----
 drivers/serial/bfin_5xx.c                          |   98 ++-------------
 include/asm-blackfin/dpmc.h                        |   10 ++-
 include/asm-blackfin/entry.h                       |    5 +
 include/asm-blackfin/mach-bf527/bfin_serial_5xx.h  |    5 +
 include/asm-blackfin/mach-bf533/bfin_serial_5xx.h  |    5 +
 include/asm-blackfin/mach-bf533/defBF532.h         |    2 +
 include/asm-blackfin/mach-bf533/irq.h              |   14 +-
 include/asm-blackfin/mach-bf537/bfin_serial_5xx.h  |    5 +
 include/asm-blackfin/mach-bf537/irq.h              |   35 +++---
 include/asm-blackfin/mach-bf548/bfin_serial_5xx.h  |    3 +
 include/asm-blackfin/mach-bf548/defBF54x_base.h    |   20 +++
 include/asm-blackfin/mach-bf561/bfin_serial_5xx.h  |    5 +
 include/asm-blackfin/mach-bf561/defBF561.h         |   28 ++++
 include/asm-blackfin/mach-bf561/irq.h              |   13 +-
 include/asm-blackfin/mach-common/context.S         |    5 +
 include/asm-blackfin/time.h                        |    4 +
 39 files changed, 817 insertions(+), 229 deletions(-)
 create mode 100644 arch/blackfin/mach-common/dpmc.c
 rename arch/blackfin/mach-common/{dpmc.S => dpmc_modes.S} (82%)

Bernd Schmidt (5):
      [Blackfin] arch: fix bug -  breaking the atomic sections code.
      [Blackfin] arch: In the double fault handler, set up the PT_RETI slot
      [Blackfin] arch: Delete unused (copied from m68k) entries in
asm-offsets.c.
      [Blackfin] arch: disable single stepping when delivering a signal
      [Blackfin] arch: fix gdb testing regression

Bryan Wu (1):
      [Blackfin] arch: add twi_lcd and twi_keypad i2c board info to bf527-ezkit

Grace Pan (1):
      [Blackfin] arch: Set spi flash partition on bf527 as like bf548.

Meihui Fan (1):
      [Blackfin] arch: fix bug - Remove module will not free L1 memory used

Michael Hennerich (7):
      [Blackfin] arch: Cleanup Kconfig, fix comment and make sure we
exclude CCLK=SCLK for some configurations
      [Blackfin] arch: Equalize include files: Add VR_CTL masks
      [Blackfin] arch: Functional power management support: Add CPU
and platform voltage scaling support
      [Blackfin] arch: Add physmap partition for BF527-EZkit
      [Blackfin] arch: Fix BUG - spi flash on bf527 ezkit would fail at mount
      [Blackfin] arch: add EBIU supporting for BF54x EZKIT SMSC
LAN911x/LAN921x families embedded ethernet driver
      [Blackfin] arch: remove useless IRQ_SW_INT defines

Mike Frysinger (5):
      [Blackfin] arch: fix wrong header name in comment
      [Blackfin] arch: protect linux/usb/isp1362.h include until the
driver gets mainlined
      [Blackfin] arch: protect linux/usb/musb.h include until the
driver gets mainlined
      Blackfin Serial Driver: macro away the IER differences between processors
      Blackfin Serial Driver: abstract away DLAB differences into header

Vitja Makarov (1):
      [Blackfin] arch: Support for CPU_FREQ and NOHZ

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 795d0ac..fd57085 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -832,6 +832,7 @@ config BANK_0
 config BANK_1
 	hex "Bank 1"
 	default 0x7BB0
+	default 0x5558 if BF54x

 config BANK_2
 	hex "Bank 2"
@@ -963,21 +964,22 @@ endchoice

 endmenu

-if (BF537 || BF533 || BF54x)
-
 menu "CPU Frequency scaling"

 source "drivers/cpufreq/Kconfig"

-config CPU_FREQ
-	bool
+config CPU_VOLTAGE
+	bool "CPU Voltage scaling"
+	depends on EXPERIMENTAL	
+	depends on CPU_FREQ
 	default n
 	help
-	  If you want to enable this option, you should select the
-	  DPMC driver from Character Devices.
-endmenu
+	  Say Y here if you want CPU voltage scaling according to the CPU frequency.
+	  This option violates the PLL BYPASS recommendation in the Blackfin Processor
+	  manuals. There is a theoretical risk that during VDDINT transitions
+	  the PLL may unlock.

-endif
+endmenu

 source "net/Kconfig"

diff --git a/arch/blackfin/kernel/asm-offsets.c
b/arch/blackfin/kernel/asm-offsets.c
index 721f15f..881afe9 100644
--- a/arch/blackfin/kernel/asm-offsets.c
+++ b/arch/blackfin/kernel/asm-offsets.c
@@ -56,9 +56,6 @@ int main(void)
 	/* offsets into the thread struct */
 	DEFINE(THREAD_KSP, offsetof(struct thread_struct, ksp));
 	DEFINE(THREAD_USP, offsetof(struct thread_struct, usp));
-	DEFINE(THREAD_SR, offsetof(struct thread_struct, seqstat));
-	DEFINE(PT_SR, offsetof(struct thread_struct, seqstat));
-	DEFINE(THREAD_ESP0, offsetof(struct thread_struct, esp0));
 	DEFINE(THREAD_PC, offsetof(struct thread_struct, pc));
 	DEFINE(KERNEL_STACK_SIZE, THREAD_SIZE);

diff --git a/arch/blackfin/kernel/fixed_code.S
b/arch/blackfin/kernel/fixed_code.S
index 5ed4722..4b03ba0 100644
--- a/arch/blackfin/kernel/fixed_code.S
+++ b/arch/blackfin/kernel/fixed_code.S
@@ -1,6 +1,6 @@
 /*
  * This file contains sequences of code that will be copied to a
- * fixed location, defined in <asm/atomic_seq.h>.  The interrupt
+ * fixed location, defined in <asm/fixed_code.h>.  The interrupt
  * handlers ensure that these sequences appear to be atomic when
  * executed from userspace.
  * These are aligned to 16 bytes, so that we have some space to replace
diff --git a/arch/blackfin/kernel/module.c b/arch/blackfin/kernel/module.c
index 8b9fe29..14a4284 100644
--- a/arch/blackfin/kernel/module.c
+++ b/arch/blackfin/kernel/module.c
@@ -160,6 +160,13 @@ int
 module_frob_arch_sections(Elf_Ehdr * hdr, Elf_Shdr * sechdrs,
 			  char *secstrings, struct module *mod)
 {
+	/*
+	 * XXX: sechdrs are vmalloced in kernel/module.c
+	 * and would be vfreed just after module is loaded,
+	 * so we hack to keep the only information we needed
+	 * in mod->arch to correctly free L1 I/D sram later.
+	 * NOTE: this breaks the semantic of mod->arch structure.
+	 */
 	Elf_Shdr *s, *sechdrs_end = sechdrs + hdr->e_shnum;
 	void *dest = NULL;

@@ -167,8 +174,8 @@ module_frob_arch_sections(Elf_Ehdr * hdr, Elf_Shdr
* sechdrs,
 		if ((strcmp(".l1.text", secstrings + s->sh_name) == 0) ||
 		    ((strcmp(".text", secstrings + s->sh_name) == 0) &&
 		     (hdr->e_flags & FLG_CODE_IN_L1) && (s->sh_size > 0))) {
-			mod->arch.text_l1 = s;
 			dest = l1_inst_sram_alloc(s->sh_size);
+			mod->arch.text_l1 = dest;
 			if (dest == NULL) {
 				printk(KERN_ERR
 				       "module %s: L1 instruction memory allocation failed\n",
@@ -182,8 +189,8 @@ module_frob_arch_sections(Elf_Ehdr * hdr, Elf_Shdr
* sechdrs,
 		if ((strcmp(".l1.data", secstrings + s->sh_name) == 0) ||
 		    ((strcmp(".data", secstrings + s->sh_name) == 0) &&
 		     (hdr->e_flags & FLG_DATA_IN_L1) && (s->sh_size > 0))) {
-			mod->arch.data_a_l1 = s;
 			dest = l1_data_sram_alloc(s->sh_size);
+			mod->arch.data_a_l1 = dest;
 			if (dest == NULL) {
 				printk(KERN_ERR
 					"module %s: L1 data memory allocation failed\n",
@@ -197,8 +204,8 @@ module_frob_arch_sections(Elf_Ehdr * hdr, Elf_Shdr
* sechdrs,
 		if (strcmp(".l1.bss", secstrings + s->sh_name) == 0 ||
 		    ((strcmp(".bss", secstrings + s->sh_name) == 0) &&
 		     (hdr->e_flags & FLG_DATA_IN_L1) && (s->sh_size > 0))) {
-			mod->arch.bss_a_l1 = s;
 			dest = l1_data_sram_alloc(s->sh_size);
+			mod->arch.bss_a_l1 = dest;
 			if (dest == NULL) {
 				printk(KERN_ERR
 					"module %s: L1 data memory allocation failed\n",
@@ -210,8 +217,8 @@ module_frob_arch_sections(Elf_Ehdr * hdr, Elf_Shdr
* sechdrs,
 			s->sh_addr = (unsigned long)dest;
 		}
 		if (strcmp(".l1.data.B", secstrings + s->sh_name) == 0) {
-			mod->arch.data_b_l1 = s;
 			dest = l1_data_B_sram_alloc(s->sh_size);
+			mod->arch.data_b_l1 = dest;
 			if (dest == NULL) {
 				printk(KERN_ERR
 					"module %s: L1 data memory allocation failed\n",
@@ -223,8 +230,8 @@ module_frob_arch_sections(Elf_Ehdr * hdr, Elf_Shdr
* sechdrs,
 			s->sh_addr = (unsigned long)dest;
 		}
 		if (strcmp(".l1.bss.B", secstrings + s->sh_name) == 0) {
-			mod->arch.bss_b_l1 = s;
 			dest = l1_data_B_sram_alloc(s->sh_size);
+			mod->arch.bss_b_l1 = dest;
 			if (dest == NULL) {
 				printk(KERN_ERR
 					"module %s: L1 data memory allocation failed\n",
@@ -416,14 +423,14 @@ module_finalize(const Elf_Ehdr * hdr,

 void module_arch_cleanup(struct module *mod)
 {
-	if ((mod->arch.text_l1) && (mod->arch.text_l1->sh_addr))
-		l1_inst_sram_free((void *)mod->arch.text_l1->sh_addr);
-	if ((mod->arch.data_a_l1) && (mod->arch.data_a_l1->sh_addr))
-		l1_data_sram_free((void *)mod->arch.data_a_l1->sh_addr);
-	if ((mod->arch.bss_a_l1) && (mod->arch.bss_a_l1->sh_addr))
-		l1_data_sram_free((void *)mod->arch.bss_a_l1->sh_addr);
-	if ((mod->arch.data_b_l1) && (mod->arch.data_b_l1->sh_addr))
-		l1_data_B_sram_free((void *)mod->arch.data_b_l1->sh_addr);
-	if ((mod->arch.bss_b_l1) && (mod->arch.bss_b_l1->sh_addr))
-		l1_data_B_sram_free((void *)mod->arch.bss_b_l1->sh_addr);
+	if (mod->arch.text_l1)
+		l1_inst_sram_free((void *)mod->arch.text_l1);
+	if (mod->arch.data_a_l1)
+		l1_data_sram_free((void *)mod->arch.data_a_l1);
+	if (mod->arch.bss_a_l1)
+		l1_data_sram_free((void *)mod->arch.bss_a_l1);
+	if (mod->arch.data_b_l1)
+		l1_data_B_sram_free((void *)mod->arch.data_b_l1);
+	if (mod->arch.bss_b_l1)
+		l1_data_B_sram_free((void *)mod->arch.bss_b_l1);
 }
diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index be9fdd0..53c2cd2 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -245,7 +245,7 @@ unsigned long get_wchan(struct task_struct *p)

 void finish_atomic_sections (struct pt_regs *regs)
 {
-	int __user *up0 = (int __user *)&regs->p0;
+	int __user *up0 = (int __user *)regs->p0;

 	if (regs->pc < ATOMIC_SEQS_START || regs->pc >= ATOMIC_SEQS_END)
 		return;
diff --git a/arch/blackfin/kernel/ptrace.c b/arch/blackfin/kernel/ptrace.c
index b4f062c..f51ab08 100644
--- a/arch/blackfin/kernel/ptrace.c
+++ b/arch/blackfin/kernel/ptrace.c
@@ -185,8 +185,8 @@ void ptrace_disable(struct task_struct *child)
 {
 	unsigned long tmp;
 	/* make sure the single step bit is not set. */
-	tmp = get_reg(child, PT_SR) & ~(TRACE_BITS << 16);
-	put_reg(child, PT_SR, tmp);
+	tmp = get_reg(child, PT_SYSCFG) & ~TRACE_BITS;
+	put_reg(child, PT_SYSCFG, tmp);
 }

 long arch_ptrace(struct task_struct *child, long request, long addr, long data)
diff --git a/arch/blackfin/kernel/signal.c b/arch/blackfin/kernel/signal.c
index cb9d883..dbc3bbf 100644
--- a/arch/blackfin/kernel/signal.c
+++ b/arch/blackfin/kernel/signal.c
@@ -42,6 +42,9 @@

 #define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))

+/* Location of the trace bit in SYSCFG. */
+#define TRACE_BITS 0x0001
+
 struct fdpic_func_descriptor {
 	unsigned long	text;
 	unsigned long	GOT;
@@ -225,6 +228,16 @@ setup_rt_frame(int sig, struct k_sigaction *ka,
siginfo_t * info,
 	regs->r1 = (unsigned long)(&frame->info);
 	regs->r2 = (unsigned long)(&frame->uc);

+	/*
+	 * Clear the trace flag when entering the signal handler, but
+	 * notify any tracer that was single-stepping it. The tracer
+	 * may want to single-step inside the handler too.
+	 */
+	if (regs->syscfg & TRACE_BITS) {
+		regs->syscfg &= ~TRACE_BITS;
+		ptrace_notify(SIGTRAP);
+	}
+
 	return 0;

  give_sigsegv:
diff --git a/arch/blackfin/kernel/time-ts.c b/arch/blackfin/kernel/time-ts.c
index 4482c47..e887efc 100644
--- a/arch/blackfin/kernel/time-ts.c
+++ b/arch/blackfin/kernel/time-ts.c
@@ -60,7 +60,7 @@ static inline unsigned long long cycles_2_ns(cycle_t cyc)

 static cycle_t read_cycles(void)
 {
-	return get_cycles();
+	return __bfin_cycles_off + (get_cycles() << __bfin_cycles_mod);
 }

 unsigned long long sched_clock(void)
@@ -117,7 +117,7 @@ static void bfin_timer_set_mode(enum clock_event_mode mode,
 		break;
 	}
 	case CLOCK_EVT_MODE_ONESHOT:
-		bfin_write_TSCALE(0);
+		bfin_write_TSCALE(TIME_SCALE - 1);
 		bfin_write_TCOUNT(0);
 		bfin_write_TCNTL(TMPWR | TMREN);
 		CSYNC();
@@ -183,10 +183,14 @@ irqreturn_t timer_interrupt(int irq, void *dev_id)

 static int __init bfin_clockevent_init(void)
 {
+	unsigned long timer_clk;
+
+	timer_clk = get_cclk() / TIME_SCALE;
+
 	setup_irq(IRQ_CORETMR, &bfin_timer_irq);
 	bfin_timer_init();

-	clockevent_bfin.mult = div_sc(get_cclk(), NSEC_PER_SEC,
clockevent_bfin.shift);
+	clockevent_bfin.mult = div_sc(timer_clk, NSEC_PER_SEC, clockevent_bfin.shift);
 	clockevent_bfin.max_delta_ns = clockevent_delta2ns(-1, &clockevent_bfin);
 	clockevent_bfin.min_delta_ns = clockevent_delta2ns(100, &clockevent_bfin);
 	clockevents_register_device(&clockevent_bfin);
diff --git a/arch/blackfin/mach-bf527/boards/ezkit.c
b/arch/blackfin/mach-bf527/boards/ezkit.c
index 583d538..8aa49f8 100644
--- a/arch/blackfin/mach-bf527/boards/ezkit.c
+++ b/arch/blackfin/mach-bf527/boards/ezkit.c
@@ -32,12 +32,14 @@
 #include <linux/platform_device.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
+#include <linux/mtd/physmap.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
 #if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
 #include <linux/usb/isp1362.h>
 #endif
 #include <linux/ata_platform.h>
+#include <linux/i2c.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/usb/sl811.h>
@@ -50,6 +52,7 @@
 #include <asm/reboot.h>
 #include <asm/nand.h>
 #include <asm/portmux.h>
+#include <asm/dpmc.h>
 #include <linux/spi/ad7877.h>

 /*
@@ -171,6 +174,46 @@ static struct platform_device bf52x_t350mcqb_device = {
 };
 #endif

+#if defined(CONFIG_MTD_PHYSMAP) || defined(CONFIG_MTD_PHYSMAP_MODULE)
+static struct mtd_partition ezkit_partitions[] = {
+	{
+		.name       = "Bootloader",
+		.size       = 0x40000,
+		.offset     = 0,
+	}, {
+		.name       = "Kernel",
+		.size       = 0x1C0000,
+		.offset     = MTDPART_OFS_APPEND,
+	}, {
+		.name       = "RootFS",
+		.size       = MTDPART_SIZ_FULL,
+		.offset     = MTDPART_OFS_APPEND,
+	}
+};
+
+static struct physmap_flash_data ezkit_flash_data = {
+	.width      = 2,
+	.parts      = ezkit_partitions,
+	.nr_parts   = ARRAY_SIZE(ezkit_partitions),
+};
+
+static struct resource ezkit_flash_resource = {
+	.start = 0x20000000,
+	.end   = 0x203fffff,
+	.flags = IORESOURCE_MEM,
+};
+
+static struct platform_device ezkit_flash_device = {
+	.name          = "physmap-flash",
+	.id            = 0,
+	.dev = {
+		.platform_data = &ezkit_flash_data,
+	},
+	.num_resources = 1,
+	.resource      = &ezkit_flash_resource,
+};
+#endif
+
 #if defined(CONFIG_MTD_NAND_BF5XX) || defined(CONFIG_MTD_NAND_BF5XX_MODULE)
 static struct mtd_partition partition_info[] = {
 	{
@@ -420,11 +463,7 @@ static struct mtd_partition bfin_spi_flash_partitions[] = {
 		.offset = 0,
 		.mask_flags = MTD_CAP_ROM
 	}, {
-		.name = "kernel",
-		.size = 0xe0000,
-		.offset = MTDPART_OFS_APPEND,
-	}, {
-		.name = "file system",
+		.name = "linux kernel",
 		.size = MTDPART_SIZ_FULL,
 		.offset = MTDPART_OFS_APPEND,
 	}
@@ -434,7 +473,7 @@ static struct flash_platform_data bfin_spi_flash_data = {
 	.name = "m25p80",
 	.parts = bfin_spi_flash_partitions,
 	.nr_parts = ARRAY_SIZE(bfin_spi_flash_partitions),
-	.type = "m25p64",
+	.type = "m25p16",
 };

 /* SPI flash chip (m25p64) */
@@ -755,6 +794,24 @@ static struct platform_device i2c_bfin_twi_device = {
 };
 #endif

+#ifdef CONFIG_I2C_BOARDINFO
+static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
+#if defined(CONFIG_TWI_LCD) || defined(CONFIG_TWI_LCD_MODULE)
+	{
+		I2C_BOARD_INFO("pcf8574_lcd", 0x22),
+		.type = "pcf8574_lcd",
+	},
+#endif
+#if defined(CONFIG_TWI_KEYPAD) || defined(CONFIG_TWI_KEYPAD_MODULE)
+	{
+		I2C_BOARD_INFO("pcf8574_keypad", 0x27),
+		.type = "pcf8574_keypad",
+		.irq = IRQ_PF8,
+	},
+#endif
+};
+#endif
+
 #if defined(CONFIG_SERIAL_BFIN_SPORT) ||
defined(CONFIG_SERIAL_BFIN_SPORT_MODULE)
 static struct platform_device bfin_sport0_uart_device = {
 	.name = "bfin-sport-uart",
@@ -839,7 +896,32 @@ static struct platform_device bfin_gpios_device = {
 	.resource = &bfin_gpios_resources,
 };

+static const unsigned int cclk_vlev_datasheet[] =
+{
+	VRPAIR(VLEV_100, 400000000),
+	VRPAIR(VLEV_105, 426000000),
+	VRPAIR(VLEV_110, 500000000),
+	VRPAIR(VLEV_115, 533000000),
+	VRPAIR(VLEV_120, 600000000),
+};
+
+static struct bfin_dpmc_platform_data bfin_dmpc_vreg_data = {
+	.tuple_tab = cclk_vlev_datasheet,
+	.tabsize = ARRAY_SIZE(cclk_vlev_datasheet),
+	.vr_settling_time = 25 /* us */,
+};
+
+static struct platform_device bfin_dpmc = {
+	.name = "bfin dpmc",
+	.dev = {
+		.platform_data = &bfin_dmpc_vreg_data,
+	},
+};
+
 static struct platform_device *stamp_devices[] __initdata = {
+
+	&bfin_dpmc,
+
 #if defined(CONFIG_MTD_NAND_BF5XX) || defined(CONFIG_MTD_NAND_BF5XX_MODULE)
 	&bf5xx_nand_device,
 #endif
@@ -921,12 +1003,22 @@ static struct platform_device *stamp_devices[]
__initdata = {
 	&bfin_device_gpiokeys,
 #endif

+#if defined(CONFIG_MTD_PHYSMAP) || defined(CONFIG_MTD_PHYSMAP_MODULE)
+	&ezkit_flash_device,
+#endif
+
 	&bfin_gpios_device,
 };

 static int __init stamp_init(void)
 {
 	printk(KERN_INFO "%s(): registering device resources\n", __func__);
+
+#ifdef CONFIG_I2C_BOARDINFO
+	i2c_register_board_info(0, bfin_i2c_board_info,
+				ARRAY_SIZE(bfin_i2c_board_info));
+#endif
+
 	platform_add_devices(stamp_devices, ARRAY_SIZE(stamp_devices));
 #if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
 	spi_register_board_info(bfin_spi_board_info,
diff --git a/arch/blackfin/mach-bf533/boards/cm_bf533.c
b/arch/blackfin/mach-bf533/boards/cm_bf533.c
index a03149c..ed2b0b8 100644
--- a/arch/blackfin/mach-bf533/boards/cm_bf533.c
+++ b/arch/blackfin/mach-bf533/boards/cm_bf533.c
@@ -33,12 +33,15 @@
 #include <linux/mtd/partitions.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
+#if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
 #include <linux/usb/isp1362.h>
+#endif
 #include <linux/ata_platform.h>
 #include <linux/irq.h>
 #include <asm/dma.h>
 #include <asm/bfin5xx_spi.h>
 #include <asm/portmux.h>
+#include <asm/dpmc.h>

 /*
  * Name the Board for the /proc/cpuinfo
@@ -341,7 +344,37 @@ static struct platform_device bfin_pata_device = {
 };
 #endif

+static const unsigned int cclk_vlev_datasheet[] =
+{
+	VRPAIR(VLEV_085, 250000000),
+	VRPAIR(VLEV_090, 376000000),
+	VRPAIR(VLEV_095, 426000000),
+	VRPAIR(VLEV_100, 426000000),
+	VRPAIR(VLEV_105, 476000000),
+	VRPAIR(VLEV_110, 476000000),
+	VRPAIR(VLEV_115, 476000000),
+	VRPAIR(VLEV_120, 600000000),
+	VRPAIR(VLEV_125, 600000000),
+	VRPAIR(VLEV_130, 600000000),
+};
+
+static struct bfin_dpmc_platform_data bfin_dmpc_vreg_data = {
+	.tuple_tab = cclk_vlev_datasheet,
+	.tabsize = ARRAY_SIZE(cclk_vlev_datasheet),
+	.vr_settling_time = 25 /* us */,
+};
+
+static struct platform_device bfin_dpmc = {
+	.name = "bfin dpmc",
+	.dev = {
+		.platform_data = &bfin_dmpc_vreg_data,
+	},
+};
+
 static struct platform_device *cm_bf533_devices[] __initdata = {
+
+	&bfin_dpmc,
+
 #if defined(CONFIG_SERIAL_BFIN) || defined(CONFIG_SERIAL_BFIN_MODULE)
 	&bfin_uart_device,
 #endif
diff --git a/arch/blackfin/mach-bf533/boards/ezkit.c
b/arch/blackfin/mach-bf533/boards/ezkit.c
index 08a7943..9d28415 100644
--- a/arch/blackfin/mach-bf533/boards/ezkit.c
+++ b/arch/blackfin/mach-bf533/boards/ezkit.c
@@ -42,6 +42,7 @@
 #include <asm/dma.h>
 #include <asm/bfin5xx_spi.h>
 #include <asm/portmux.h>
+#include <asm/dpmc.h>

 /*
  * Name the Board for the /proc/cpuinfo
@@ -350,7 +351,37 @@ static struct platform_device i2c_gpio_device = {
 };
 #endif

+static const unsigned int cclk_vlev_datasheet[] =
+{
+	VRPAIR(VLEV_085, 250000000),
+	VRPAIR(VLEV_090, 376000000),
+	VRPAIR(VLEV_095, 426000000),
+	VRPAIR(VLEV_100, 426000000),
+	VRPAIR(VLEV_105, 476000000),
+	VRPAIR(VLEV_110, 476000000),
+	VRPAIR(VLEV_115, 476000000),
+	VRPAIR(VLEV_120, 600000000),
+	VRPAIR(VLEV_125, 600000000),
+	VRPAIR(VLEV_130, 600000000),
+};
+
+static struct bfin_dpmc_platform_data bfin_dmpc_vreg_data = {
+	.tuple_tab = cclk_vlev_datasheet,
+	.tabsize = ARRAY_SIZE(cclk_vlev_datasheet),
+	.vr_settling_time = 25 /* us */,
+};
+
+static struct platform_device bfin_dpmc = {
+	.name = "bfin dpmc",
+	.dev = {
+		.platform_data = &bfin_dmpc_vreg_data,
+	},
+};
+
 static struct platform_device *ezkit_devices[] __initdata = {
+
+	&bfin_dpmc,
+
 #if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91X_MODULE)
 	&smc91x_device,
 #endif
diff --git a/arch/blackfin/mach-bf533/boards/stamp.c
b/arch/blackfin/mach-bf533/boards/stamp.c
index 024f418..7fd35fb 100644
--- a/arch/blackfin/mach-bf533/boards/stamp.c
+++ b/arch/blackfin/mach-bf533/boards/stamp.c
@@ -45,6 +45,7 @@
 #include <asm/bfin5xx_spi.h>
 #include <asm/reboot.h>
 #include <asm/portmux.h>
+#include <asm/dpmc.h>

 /*
  * Name the Board for the /proc/cpuinfo
@@ -516,7 +517,37 @@ static struct i2c_board_info __initdata
bfin_i2c_board_info[] = {
 };
 #endif

+static const unsigned int cclk_vlev_datasheet[] =
+{
+	VRPAIR(VLEV_085, 250000000),
+	VRPAIR(VLEV_090, 376000000),
+	VRPAIR(VLEV_095, 426000000),
+	VRPAIR(VLEV_100, 426000000),
+	VRPAIR(VLEV_105, 476000000),
+	VRPAIR(VLEV_110, 476000000),
+	VRPAIR(VLEV_115, 476000000),
+	VRPAIR(VLEV_120, 600000000),
+	VRPAIR(VLEV_125, 600000000),
+	VRPAIR(VLEV_130, 600000000),
+};
+
+static struct bfin_dpmc_platform_data bfin_dmpc_vreg_data = {
+	.tuple_tab = cclk_vlev_datasheet,
+	.tabsize = ARRAY_SIZE(cclk_vlev_datasheet),
+	.vr_settling_time = 25 /* us */,
+};
+
+static struct platform_device bfin_dpmc = {
+	.name = "bfin dpmc",
+	.dev = {
+		.platform_data = &bfin_dmpc_vreg_data,
+	},
+};
+
 static struct platform_device *stamp_devices[] __initdata = {
+
+	&bfin_dpmc,
+
 #if defined(CONFIG_RTC_DRV_BFIN) || defined(CONFIG_RTC_DRV_BFIN_MODULE)
 	&rtc_device,
 #endif
diff --git a/arch/blackfin/mach-bf537/boards/cm_bf537.c
b/arch/blackfin/mach-bf537/boards/cm_bf537.c
index d8a23cd..73f2142 100644
--- a/arch/blackfin/mach-bf537/boards/cm_bf537.c
+++ b/arch/blackfin/mach-bf537/boards/cm_bf537.c
@@ -35,12 +35,15 @@
 #include <linux/mtd/partitions.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
+#if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
 #include <linux/usb/isp1362.h>
+#endif
 #include <linux/ata_platform.h>
 #include <linux/irq.h>
 #include <asm/dma.h>
 #include <asm/bfin5xx_spi.h>
 #include <asm/portmux.h>
+#include <asm/dpmc.h>

 /*
  * Name the Board for the /proc/cpuinfo
@@ -428,7 +431,37 @@ static struct platform_device bfin_pata_device = {
 };
 #endif

+static const unsigned int cclk_vlev_datasheet[] =
+{
+	VRPAIR(VLEV_085, 250000000),
+	VRPAIR(VLEV_090, 376000000),
+	VRPAIR(VLEV_095, 426000000),
+	VRPAIR(VLEV_100, 426000000),
+	VRPAIR(VLEV_105, 476000000),
+	VRPAIR(VLEV_110, 476000000),
+	VRPAIR(VLEV_115, 476000000),
+	VRPAIR(VLEV_120, 500000000),
+	VRPAIR(VLEV_125, 533000000),
+	VRPAIR(VLEV_130, 600000000),
+};
+
+static struct bfin_dpmc_platform_data bfin_dmpc_vreg_data = {
+	.tuple_tab = cclk_vlev_datasheet,
+	.tabsize = ARRAY_SIZE(cclk_vlev_datasheet),
+	.vr_settling_time = 25 /* us */,
+};
+
+static struct platform_device bfin_dpmc = {
+	.name = "bfin dpmc",
+	.dev = {
+		.platform_data = &bfin_dmpc_vreg_data,
+	},
+};
+
 static struct platform_device *cm_bf537_devices[] __initdata = {
+
+	&bfin_dpmc,
+
 #if defined(CONFIG_FB_HITACHI_TX09) || defined(CONFIG_FB_HITACHI_TX09_MODULE)
 	&hitachi_fb_device,
 #endif
diff --git a/arch/blackfin/mach-bf537/boards/stamp.c
b/arch/blackfin/mach-bf537/boards/stamp.c
index d3727b7..9a756d1 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -47,6 +47,7 @@
 #include <asm/bfin5xx_spi.h>
 #include <asm/reboot.h>
 #include <asm/portmux.h>
+#include <asm/dpmc.h>
 #include <linux/spi/ad7877.h>

 /*
@@ -817,7 +818,37 @@ static struct platform_device bfin_pata_device = {
 };
 #endif

+static const unsigned int cclk_vlev_datasheet[] =
+{
+	VRPAIR(VLEV_085, 250000000),
+	VRPAIR(VLEV_090, 376000000),
+	VRPAIR(VLEV_095, 426000000),
+	VRPAIR(VLEV_100, 426000000),
+	VRPAIR(VLEV_105, 476000000),
+	VRPAIR(VLEV_110, 476000000),
+	VRPAIR(VLEV_115, 476000000),
+	VRPAIR(VLEV_120, 500000000),
+	VRPAIR(VLEV_125, 533000000),
+	VRPAIR(VLEV_130, 600000000),
+};
+
+static struct bfin_dpmc_platform_data bfin_dmpc_vreg_data = {
+	.tuple_tab = cclk_vlev_datasheet,
+	.tabsize = ARRAY_SIZE(cclk_vlev_datasheet),
+	.vr_settling_time = 25 /* us */,
+};
+
+static struct platform_device bfin_dpmc = {
+	.name = "bfin dpmc",
+	.dev = {
+		.platform_data = &bfin_dmpc_vreg_data,
+	},
+};
+
 static struct platform_device *stamp_devices[] __initdata = {
+
+	&bfin_dpmc,
+
 #if defined(CONFIG_BFIN_CFPCMCIA) || defined(CONFIG_BFIN_CFPCMCIA_MODULE)
 	&bfin_pcmcia_cf_device,
 #endif
diff --git a/arch/blackfin/mach-bf548/boards/cm_bf548.c
b/arch/blackfin/mach-bf548/boards/cm_bf548.c
index e3e8479..3b74f96 100644
--- a/arch/blackfin/mach-bf548/boards/cm_bf548.c
+++ b/arch/blackfin/mach-bf548/boards/cm_bf548.c
@@ -36,7 +36,9 @@
 #include <linux/spi/flash.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
+#if defined(CONFIG_USB_MUSB_HDRC) || defined(CONFIG_USB_MUSB_HDRC_MODULE)
 #include <linux/usb/musb.h>
+#endif
 #include <asm/bfin5xx_spi.h>
 #include <asm/cplb.h>
 #include <asm/dma.h>
@@ -44,6 +46,7 @@
 #include <asm/nand.h>
 #include <asm/portmux.h>
 #include <asm/mach/bf54x_keys.h>
+#include <asm/dpmc.h>
 #include <linux/input.h>
 #include <linux/spi/ad7877.h>

@@ -590,7 +593,38 @@ static struct platform_device bfin_device_gpiokeys = {
 };
 #endif

+static const unsigned int cclk_vlev_datasheet[] =
+{
+/*
+ * Internal VLEV BF54XSBBC1533
+ ****temporarily using these values until data sheet is updated
+ */
+	VRPAIR(VLEV_085, 150000000),
+	VRPAIR(VLEV_090, 250000000),
+	VRPAIR(VLEV_110, 276000000),
+	VRPAIR(VLEV_115, 301000000),
+	VRPAIR(VLEV_120, 525000000),
+	VRPAIR(VLEV_125, 550000000),
+	VRPAIR(VLEV_130, 600000000),
+};
+
+static struct bfin_dpmc_platform_data bfin_dmpc_vreg_data = {
+	.tuple_tab = cclk_vlev_datasheet,
+	.tabsize = ARRAY_SIZE(cclk_vlev_datasheet),
+	.vr_settling_time = 25 /* us */,
+};
+
+static struct platform_device bfin_dpmc = {
+	.name = "bfin dpmc",
+	.dev = {
+		.platform_data = &bfin_dmpc_vreg_data,
+	},
+};
+
 static struct platform_device *cm_bf548_devices[] __initdata = {
+
+	&bfin_dpmc,
+
 #if defined(CONFIG_RTC_DRV_BFIN) || defined(CONFIG_RTC_DRV_BFIN_MODULE)
 	&rtc_device,
 #endif
diff --git a/arch/blackfin/mach-bf548/boards/ezkit.c
b/arch/blackfin/mach-bf548/boards/ezkit.c
index b00f68a..d1682bb 100644
--- a/arch/blackfin/mach-bf548/boards/ezkit.c
+++ b/arch/blackfin/mach-bf548/boards/ezkit.c
@@ -46,6 +46,7 @@
 #include <asm/dma.h>
 #include <asm/gpio.h>
 #include <asm/nand.h>
+#include <asm/dpmc.h>
 #include <asm/portmux.h>
 #include <asm/mach/bf54x_keys.h>
 #include <linux/input.h>
@@ -689,7 +690,38 @@ static struct platform_device bfin_gpios_device = {
 	.resource = &bfin_gpios_resources,
 };

+static const unsigned int cclk_vlev_datasheet[] =
+{
+/*
+ * Internal VLEV BF54XSBBC1533
+ ****temporarily using these values until data sheet is updated
+ */
+	VRPAIR(VLEV_085, 150000000),
+	VRPAIR(VLEV_090, 250000000),
+	VRPAIR(VLEV_110, 276000000),
+	VRPAIR(VLEV_115, 301000000),
+	VRPAIR(VLEV_120, 525000000),
+	VRPAIR(VLEV_125, 550000000),
+	VRPAIR(VLEV_130, 600000000),
+};
+
+static struct bfin_dpmc_platform_data bfin_dmpc_vreg_data = {
+	.tuple_tab = cclk_vlev_datasheet,
+	.tabsize = ARRAY_SIZE(cclk_vlev_datasheet),
+	.vr_settling_time = 25 /* us */,
+};
+
+static struct platform_device bfin_dpmc = {
+	.name = "bfin dpmc",
+	.dev = {
+		.platform_data = &bfin_dmpc_vreg_data,
+	},
+};
+
 static struct platform_device *ezkit_devices[] __initdata = {
+
+	&bfin_dpmc,
+
 #if defined(CONFIG_RTC_DRV_BFIN) || defined(CONFIG_RTC_DRV_BFIN_MODULE)
 	&rtc_device,
 #endif
diff --git a/arch/blackfin/mach-bf561/boards/cm_bf561.c
b/arch/blackfin/mach-bf561/boards/cm_bf561.c
index 9fd5809..466ef59 100644
--- a/arch/blackfin/mach-bf561/boards/cm_bf561.c
+++ b/arch/blackfin/mach-bf561/boards/cm_bf561.c
@@ -33,12 +33,15 @@
 #include <linux/mtd/partitions.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
+#if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
 #include <linux/usb/isp1362.h>
+#endif
 #include <linux/ata_platform.h>
 #include <linux/irq.h>
 #include <asm/dma.h>
 #include <asm/bfin5xx_spi.h>
 #include <asm/portmux.h>
+#include <asm/dpmc.h>

 /*
  * Name the Board for the /proc/cpuinfo
@@ -339,8 +342,37 @@ static struct platform_device bfin_pata_device = {
 };
 #endif

+static const unsigned int cclk_vlev_datasheet[] =
+{
+	VRPAIR(VLEV_085, 250000000),
+	VRPAIR(VLEV_090, 300000000),
+	VRPAIR(VLEV_095, 313000000),
+	VRPAIR(VLEV_100, 350000000),
+	VRPAIR(VLEV_105, 400000000),
+	VRPAIR(VLEV_110, 444000000),
+	VRPAIR(VLEV_115, 450000000),
+	VRPAIR(VLEV_120, 475000000),
+	VRPAIR(VLEV_125, 500000000),
+	VRPAIR(VLEV_130, 600000000),
+};
+
+static struct bfin_dpmc_platform_data bfin_dmpc_vreg_data = {
+	.tuple_tab = cclk_vlev_datasheet,
+	.tabsize = ARRAY_SIZE(cclk_vlev_datasheet),
+	.vr_settling_time = 25 /* us */,
+};
+
+static struct platform_device bfin_dpmc = {
+	.name = "bfin dpmc",
+	.dev = {
+		.platform_data = &bfin_dmpc_vreg_data,
+	},
+};
+
 static struct platform_device *cm_bf561_devices[] __initdata = {

+	&bfin_dpmc,
+
 #if defined(CONFIG_FB_HITACHI_TX09) || defined(CONFIG_FB_HITACHI_TX09_MODULE)
 	&hitachi_fb_device,
 #endif
diff --git a/arch/blackfin/mach-bf561/boards/ezkit.c
b/arch/blackfin/mach-bf561/boards/ezkit.c
index 0d74b7d..61d8f76 100644
--- a/arch/blackfin/mach-bf561/boards/ezkit.c
+++ b/arch/blackfin/mach-bf561/boards/ezkit.c
@@ -39,6 +39,7 @@
 #include <asm/dma.h>
 #include <asm/bfin5xx_spi.h>
 #include <asm/portmux.h>
+#include <asm/dpmc.h>

 /*
  * Name the Board for the /proc/cpuinfo
@@ -443,7 +444,37 @@ static struct platform_device i2c_gpio_device = {
 };
 #endif

+static const unsigned int cclk_vlev_datasheet[] =
+{
+	VRPAIR(VLEV_085, 250000000),
+	VRPAIR(VLEV_090, 300000000),
+	VRPAIR(VLEV_095, 313000000),
+	VRPAIR(VLEV_100, 350000000),
+	VRPAIR(VLEV_105, 400000000),
+	VRPAIR(VLEV_110, 444000000),
+	VRPAIR(VLEV_115, 450000000),
+	VRPAIR(VLEV_120, 475000000),
+	VRPAIR(VLEV_125, 500000000),
+	VRPAIR(VLEV_130, 600000000),
+};
+
+static struct bfin_dpmc_platform_data bfin_dmpc_vreg_data = {
+	.tuple_tab = cclk_vlev_datasheet,
+	.tabsize = ARRAY_SIZE(cclk_vlev_datasheet),
+	.vr_settling_time = 25 /* us */,
+};
+
+static struct platform_device bfin_dpmc = {
+	.name = "bfin dpmc",
+	.dev = {
+		.platform_data = &bfin_dmpc_vreg_data,
+	},
+};
+
 static struct platform_device *ezkit_devices[] __initdata = {
+
+	&bfin_dpmc,
+
 #if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91X_MODULE)
 	&smc91x_device,
 #endif
diff --git a/arch/blackfin/mach-common/Makefile
b/arch/blackfin/mach-common/Makefile
index 393081e..422bfee 100644
--- a/arch/blackfin/mach-common/Makefile
+++ b/arch/blackfin/mach-common/Makefile
@@ -6,5 +6,6 @@ obj-y := \
 	cache.o cacheinit.o entry.o \
 	interrupt.o lock.o irqpanic.o arch_checks.o ints-priority.o

-obj-$(CONFIG_PM)         += pm.o dpmc.o
-obj-$(CONFIG_CPU_FREQ)   += cpufreq.o
+obj-$(CONFIG_PM)          += pm.o dpmc_modes.o
+obj-$(CONFIG_CPU_FREQ)    += cpufreq.o
+obj-$(CONFIG_CPU_VOLTAGE) += dpmc.o
diff --git a/arch/blackfin/mach-common/cpufreq.c
b/arch/blackfin/mach-common/cpufreq.c
index ed81e00..75cdad2 100644
--- a/arch/blackfin/mach-common/cpufreq.c
+++ b/arch/blackfin/mach-common/cpufreq.c
@@ -62,6 +62,14 @@ static struct bfin_dpm_state {
 	unsigned int tscale; /* change the divider on the core timer interrupt */
 } dpm_state_table[3];

+/*
+   normalized to maximum frequncy offset for CYCLES,
+   used in time-ts cycles clock source, but could be used
+   somewhere also.
+ */
+unsigned long long __bfin_cycles_off;
+unsigned int __bfin_cycles_mod;
+
 /**************************************************************************/

 static unsigned int bfin_getfreq(unsigned int cpu)
@@ -80,6 +88,7 @@ static int bfin_target(struct cpufreq_policy *policy,
 	unsigned int index, plldiv, tscale;
 	unsigned long flags, cclk_hz;
 	struct cpufreq_freqs freqs;
+	cycles_t cycles;

 	if (cpufreq_frequency_table_target(policy, bfin_freq_table,
 		 target_freq, relation, &index))
@@ -101,8 +110,14 @@ static int bfin_target(struct cpufreq_policy *policy,
 		bfin_write_PLL_DIV(plldiv);
 		/* we have to adjust the core timer, because it is using cclk */
 		bfin_write_TSCALE(tscale);
+		cycles = get_cycles();
 		SSYNC();
+	cycles += 10; /* ~10 cycles we loose after get_cycles() */
+	__bfin_cycles_off += (cycles << __bfin_cycles_mod) - (cycles << index);
+	__bfin_cycles_mod = index;
 	local_irq_restore(flags);
+	/* TODO: just test case for cycles clock source, remove later */
+	pr_debug("cpufreq: done\n");
 	cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);

 	return 0;
@@ -119,22 +134,13 @@ static int __init __bfin_cpu_init(struct
cpufreq_policy *policy)
 	unsigned long cclk, sclk, csel, min_cclk;
 	int index;

-#ifdef CONFIG_CYCLES_CLOCKSOURCE
-/*
- * Clocksource CYCLES is still CONTINUOUS but not longer MONOTONIC in
case we enable
- * CPU frequency scaling, since CYCLES runs off Core Clock.
- */
-	printk(KERN_WARNING "CPU frequency scaling not supported:
Clocksource not suitable\n"
-		return -ENODEV;
-#endif
-
 	if (policy->cpu != 0)
 		return -EINVAL;

 	cclk = get_cclk();
 	sclk = get_sclk();

-#if ANOMALY_05000273
+#if ANOMALY_05000273 || (!defined(CONFIG_BF54x) && defined(CONFIG_BFIN_DCACHE))
 	min_cclk = sclk * 2;
 #else
 	min_cclk = sclk;
diff --git a/arch/blackfin/mach-common/dpmc.S b/arch/blackfin/mach-common/dpmc.S
deleted file mode 100644
index 9d45aa3..0000000
--- a/arch/blackfin/mach-common/dpmc.S
+++ /dev/null
@@ -1,343 +0,0 @@
-/*
- * File:         arch/blackfin/mach-common/dpmc.S
- * Based on:
- * Author:       LG Soft India
- *
- * Created:      ?
- * Description:  Watchdog Timer APIs
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
-#include <linux/linkage.h>
-#include <asm/blackfin.h>
-#include <asm/mach/irq.h>
-
-
-.section .l1.text
-
-ENTRY(_sleep_mode)
-	[--SP] = ( R7:0, P5:0 );
-	[--SP] =  RETS;
-
-	call _set_sic_iwr;
-
-	R0 = 0xFFFF (Z);
-	call _set_rtc_istat;
-
-	P0.H = hi(PLL_CTL);
-	P0.L = lo(PLL_CTL);
-	R1 = W[P0](z);
-	BITSET (R1, 3);
-	W[P0] = R1.L;
-
-	CLI R2;
-	SSYNC;
-	IDLE;
-	STI R2;
-
-	call _test_pll_locked;
-
-	R0 = IWR_ENABLE(0);
-	R1 = IWR_DISABLE_ALL;
-	R2 = IWR_DISABLE_ALL;
-
-	call _set_sic_iwr;
-
-	P0.H = hi(PLL_CTL);
-	P0.L = lo(PLL_CTL);
-	R7 = w[p0](z);
-	BITCLR (R7, 3);
-	BITCLR (R7, 5);
-	w[p0] = R7.L;
-	IDLE;
-	call _test_pll_locked;
-
-	RETS = [SP++];
-	( R7:0, P5:0 ) = [SP++];
-	RTS;
-
-ENTRY(_hibernate_mode)
-	[--SP] = ( R7:0, P5:0 );
-	[--SP] =  RETS;
-
-	call _set_sic_iwr;
-
-	R0 = 0xFFFF (Z);
-	call _set_rtc_istat;
-
-	P0.H = hi(VR_CTL);
-	P0.L = lo(VR_CTL);
-	R1 = W[P0](z);
-	BITSET (R1, 8);
-	BITCLR (R1, 0);
-	BITCLR (R1, 1);
-	W[P0] = R1.L;
-	SSYNC;
-
-	CLI R2;
-	IDLE;
-
-	/* Actually, adding anything may not be necessary...SDRAM contents
-	 * are lost
-	 */
-
-ENTRY(_deep_sleep)
-	[--SP] = ( R7:0, P5:0 );
-	[--SP] =  RETS;
-
-	CLI R4;
-
-	R0 = IWR_ENABLE(0);
-	R1 = IWR_DISABLE_ALL;
-	R2 = IWR_DISABLE_ALL;
-
-	call _set_sic_iwr;
-
-	call _set_dram_srfs;
-
-	/* Clear all the interrupts,bits sticky */
-	R0 = 0xFFFF (Z);
-	call _set_rtc_istat
-
-	P0.H = hi(PLL_CTL);
-	P0.L = lo(PLL_CTL);
-	R0 = W[P0](z);
-	BITSET (R0, 5);
-	W[P0] = R0.L;
-
-	call _test_pll_locked;
-
-	SSYNC;
-	IDLE;
-
-	call _unset_dram_srfs;
-
-	call _test_pll_locked;
-
-	R0 = IWR_ENABLE(0);
-	R1 = IWR_DISABLE_ALL;
-	R2 = IWR_DISABLE_ALL;
-
-	call _set_sic_iwr;
-
-	P0.H = hi(PLL_CTL);
-	P0.L = lo(PLL_CTL);
-	R0 = w[p0](z);
-	BITCLR (R0, 3);
-	BITCLR (R0, 5);
-	BITCLR (R0, 8);
-	w[p0] = R0;
-	IDLE;
-	call _test_pll_locked;
-
-	STI R4;
-
-	RETS = [SP++];
-	( R7:0, P5:0 ) = [SP++];
-	RTS;
-
-ENTRY(_sleep_deeper)
-	[--SP] = ( R7:0, P5:0 );
-	[--SP] =  RETS;
-
-	CLI R4;
-
-	P3 = R0;
-	P4 = R1;
-	P5 = R2;
-
-	R0 = IWR_ENABLE(0);
-	R1 = IWR_DISABLE_ALL;
-	R2 = IWR_DISABLE_ALL;
-
-	call _set_sic_iwr;
-	call _set_dram_srfs;	/* Set SDRAM Self Refresh */
-
-	/* Clear all the interrupts,bits sticky */
-	R0 = 0xFFFF (Z);
-	call _set_rtc_istat;
-	P0.H = hi(PLL_DIV);
-	P0.L = lo(PLL_DIV);
-	R6 = W[P0](z);
-	R0.L = 0xF;
-	W[P0] = R0.l;		/* Set Max VCO to SCLK divider */
-
-	P0.H = hi(PLL_CTL);
-	P0.L = lo(PLL_CTL);
-	R5 = W[P0](z);
-	R0.L = (CONFIG_MIN_VCO_HZ/CONFIG_CLKIN_HZ) << 9;
-	W[P0] = R0.l;		/* Set Min CLKIN to VCO multiplier */
-
-	SSYNC;
-	IDLE;
-
-	call _test_pll_locked;
-
-	P0.H = hi(VR_CTL);
-	P0.L = lo(VR_CTL);
-	R7 = W[P0](z);
-	R1 = 0x6;
-	R1 <<= 16;
-	R2 = 0x0404(Z);
-	R1 = R1|R2;
-
-	R2 = DEPOSIT(R7, R1);
-	W[P0] = R2;		/* Set Min Core Voltage */
-
-	SSYNC;
-	IDLE;
-
-	call _test_pll_locked;
-
-	R0 = P3;
-	R1 = P4;
-	R3 = P5;
-	call _set_sic_iwr;	/* Set Awake from IDLE */
-
-	P0.H = hi(PLL_CTL);
-	P0.L = lo(PLL_CTL);
-	R0 = W[P0](z);
-	BITSET (R0, 3);
-	W[P0] = R0.L;		/* Turn CCLK OFF */
-	SSYNC;
-	IDLE;
-
-	call _test_pll_locked;
-
-	R0 = IWR_ENABLE(0);
-	R1 = IWR_DISABLE_ALL;
-	R2 = IWR_DISABLE_ALL;
-
-	call _set_sic_iwr;	/* Set Awake from IDLE PLL */
-
-	P0.H = hi(VR_CTL);
-	P0.L = lo(VR_CTL);
-	W[P0]= R7;
-
-	SSYNC;
-	IDLE;
-
-	call _test_pll_locked;
-
-	P0.H = hi(PLL_DIV);
-	P0.L = lo(PLL_DIV);
-	W[P0]= R6;		/* Restore CCLK and SCLK divider */
-
-	P0.H = hi(PLL_CTL);
-	P0.L = lo(PLL_CTL);
-	w[p0] = R5;		/* Restore VCO multiplier */
-	IDLE;
-	call _test_pll_locked;
-
-	call _unset_dram_srfs;	/* SDRAM Self Refresh Off */
-
-	STI R4;
-
-	RETS = [SP++];
-	( R7:0, P5:0 ) = [SP++];
-	RTS;
-
-ENTRY(_set_dram_srfs)
-	/*  set the dram to self refresh mode */
-#if defined(CONFIG_BF54x)
-	P0.H = hi(EBIU_RSTCTL);
-	P0.L = lo(EBIU_RSTCTL);
-	R2 = [P0];
-	R3.H = hi(SRREQ);
-	R3.L = lo(SRREQ);
-#else
-	P0.H = hi(EBIU_SDGCTL);
-	P0.L = lo(EBIU_SDGCTL);
-	R2 = [P0];
-	R3.H = hi(SRFS);
-	R3.L = lo(SRFS);
-#endif
-	R2 = R2|R3;
-	[P0] = R2;
-	ssync;
-#if defined(CONFIG_BF54x)
-.LSRR_MODE:
-	R2 = [P0];
-	CC = BITTST(R2, 4);
-	if !CC JUMP .LSRR_MODE;
-#endif
-	RTS;
-
-ENTRY(_unset_dram_srfs)
-	/*  set the dram out of self refresh mode */
-#if defined(CONFIG_BF54x)
-	P0.H = hi(EBIU_RSTCTL);
-	P0.L = lo(EBIU_RSTCTL);
-	R2 = [P0];
-	R3.H = hi(SRREQ);
-	R3.L = lo(SRREQ);
-#else
-	P0.H = hi(EBIU_SDGCTL);
-	P0.L = lo(EBIU_SDGCTL);
-	R2 = [P0];
-	R3.H = hi(SRFS);
-	R3.L = lo(SRFS);
-#endif
-	R3 = ~R3;
-	R2 = R2&R3;
-	[P0] = R2;
-	ssync;
-	RTS;
-
-ENTRY(_set_sic_iwr)
-#if defined(CONFIG_BF54x) || defined(CONFIG_BF52x)  || defined(CONFIG_BF561)
-	P0.H = hi(SIC_IWR0);
-	P0.L = lo(SIC_IWR0);
-	P1.H = hi(SIC_IWR1);
-	P1.L = lo(SIC_IWR1);
-	[P1] = R1;
-#if defined(CONFIG_BF54x)
-	P1.H = hi(SIC_IWR2);
-	P1.L = lo(SIC_IWR2);
-	[P1] = R2;
-#endif
-#else
-	P0.H = hi(SIC_IWR);
-	P0.L = lo(SIC_IWR);
-#endif
-	[P0] = R0;
-
-	SSYNC;
-	RTS;
-
-ENTRY(_set_rtc_istat)
-#ifndef CONFIG_BF561
-	P0.H = hi(RTC_ISTAT);
-	P0.L = lo(RTC_ISTAT);
-	w[P0] = R0.L;
-	SSYNC;
-#endif
-	RTS;
-
-ENTRY(_test_pll_locked)
-	P0.H = hi(PLL_STAT);
-	P0.L = lo(PLL_STAT);
-1:
-	R0 = W[P0] (Z);
-	CC = BITTST(R0,5);
-	IF !CC JUMP 1b;
-	RTS;
diff --git a/arch/blackfin/mach-common/dpmc.c b/arch/blackfin/mach-common/dpmc.c
new file mode 100644
index 0000000..02c7efd
--- /dev/null
+++ b/arch/blackfin/mach-common/dpmc.c
@@ -0,0 +1,137 @@
+/*
+ * Copyright 2008 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#include <linux/cdev.h>
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/types.h>
+#include <linux/cpufreq.h>
+
+#include <asm/delay.h>
+#include <asm/dpmc.h>
+
+#define DRIVER_NAME "bfin dpmc"
+
+#define dprintk(msg...) \
+	cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, DRIVER_NAME, msg)
+
+struct bfin_dpmc_platform_data *pdata;
+
+/**
+ *	bfin_set_vlev - Update VLEV field in VR_CTL Reg.
+ *			Avoid BYPASS sequence
+ */
+static void bfin_set_vlev(unsigned int vlev)
+{
+	unsigned pll_lcnt;
+
+	pll_lcnt = bfin_read_PLL_LOCKCNT();
+
+	bfin_write_PLL_LOCKCNT(1);
+	bfin_write_VR_CTL((bfin_read_VR_CTL() & ~VLEV) | vlev);
+	bfin_write_PLL_LOCKCNT(pll_lcnt);
+}
+
+/**
+ *	bfin_get_vlev - Get CPU specific VLEV from platform device data
+ */
+static unsigned int bfin_get_vlev(unsigned int freq)
+{
+	int i;
+
+	if (!pdata)
+		goto err_out;
+
+	freq >>= 16;
+
+	for (i = 0; i < pdata->tabsize; i++)
+		if (freq <= (pdata->tuple_tab[i] & 0xFFFF))
+			return pdata->tuple_tab[i] >> 16;
+
+err_out:
+	printk(KERN_WARNING "DPMC: No suitable CCLK VDDINT voltage pair found\n");
+	return VLEV_120;
+}
+
+#ifdef CONFIG_CPU_FREQ
+static int
+vreg_cpufreq_notifier(struct notifier_block *nb, unsigned long val, void *data)
+{
+	struct cpufreq_freqs *freq = data;
+
+	if (val == CPUFREQ_PRECHANGE && freq->old < freq->new) {
+		bfin_set_vlev(bfin_get_vlev(freq->new));
+		udelay(pdata->vr_settling_time); /* Wait until Volatge settled */
+
+	} else if (val == CPUFREQ_POSTCHANGE && freq->old > freq->new)
+		bfin_set_vlev(bfin_get_vlev(freq->new));
+
+	return 0;
+}
+
+static struct notifier_block vreg_cpufreq_notifier_block = {
+	.notifier_call	= vreg_cpufreq_notifier
+};
+#endif /* CONFIG_CPU_FREQ */
+
+/**
+ *	bfin_dpmc_probe -
+ *
+ */
+static int __devinit bfin_dpmc_probe(struct platform_device *pdev)
+{
+	if (pdev->dev.platform_data)
+		pdata = pdev->dev.platform_data;
+	else
+		return -EINVAL;
+
+	return cpufreq_register_notifier(&vreg_cpufreq_notifier_block,
+					 CPUFREQ_TRANSITION_NOTIFIER);
+}
+
+/**
+ *	bfin_dpmc_remove -
+ */
+static int __devexit bfin_dpmc_remove(struct platform_device *pdev)
+{
+	pdata = NULL;
+	return cpufreq_unregister_notifier(&vreg_cpufreq_notifier_block,
+					 CPUFREQ_TRANSITION_NOTIFIER);
+}
+
+struct platform_driver bfin_dpmc_device_driver = {
+	.probe   = bfin_dpmc_probe,
+	.remove  = __devexit_p(bfin_dpmc_remove),
+	.driver  = {
+		.name = DRIVER_NAME,
+	}
+};
+
+/**
+ *	bfin_dpmc_init - Init driver
+ */
+static int __init bfin_dpmc_init(void)
+{
+	return platform_driver_register(&bfin_dpmc_device_driver);
+}
+module_init(bfin_dpmc_init);
+
+/**
+ *	bfin_dpmc_exit - break down driver
+ */
+static void __exit bfin_dpmc_exit(void)
+{
+	platform_driver_unregister(&bfin_dpmc_device_driver);
+}
+module_exit(bfin_dpmc_exit);
+
+MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
+MODULE_DESCRIPTION("cpu power management driver for Blackfin");
+MODULE_LICENSE("GPL");
diff --git a/arch/blackfin/mach-common/dpmc_modes.S
b/arch/blackfin/mach-common/dpmc_modes.S
new file mode 100644
index 0000000..b7981d3
--- /dev/null
+++ b/arch/blackfin/mach-common/dpmc_modes.S
@@ -0,0 +1,320 @@
+/*
+ * Copyright 2004-2008 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#include <linux/linkage.h>
+#include <asm/blackfin.h>
+#include <asm/mach/irq.h>
+
+
+.section .l1.text
+
+ENTRY(_sleep_mode)
+	[--SP] = ( R7:0, P5:0 );
+	[--SP] =  RETS;
+
+	call _set_sic_iwr;
+
+	R0 = 0xFFFF (Z);
+	call _set_rtc_istat;
+
+	P0.H = hi(PLL_CTL);
+	P0.L = lo(PLL_CTL);
+	R1 = W[P0](z);
+	BITSET (R1, 3);
+	W[P0] = R1.L;
+
+	CLI R2;
+	SSYNC;
+	IDLE;
+	STI R2;
+
+	call _test_pll_locked;
+
+	R0 = IWR_ENABLE(0);
+	R1 = IWR_DISABLE_ALL;
+	R2 = IWR_DISABLE_ALL;
+
+	call _set_sic_iwr;
+
+	P0.H = hi(PLL_CTL);
+	P0.L = lo(PLL_CTL);
+	R7 = w[p0](z);
+	BITCLR (R7, 3);
+	BITCLR (R7, 5);
+	w[p0] = R7.L;
+	IDLE;
+	call _test_pll_locked;
+
+	RETS = [SP++];
+	( R7:0, P5:0 ) = [SP++];
+	RTS;
+
+ENTRY(_hibernate_mode)
+	[--SP] = ( R7:0, P5:0 );
+	[--SP] =  RETS;
+
+	call _set_sic_iwr;
+
+	R0 = 0xFFFF (Z);
+	call _set_rtc_istat;
+
+	P0.H = hi(VR_CTL);
+	P0.L = lo(VR_CTL);
+	R1 = W[P0](z);
+	BITSET (R1, 8);
+	BITCLR (R1, 0);
+	BITCLR (R1, 1);
+	W[P0] = R1.L;
+	SSYNC;
+
+	CLI R2;
+	IDLE;
+
+	/* Actually, adding anything may not be necessary...SDRAM contents
+	 * are lost
+	 */
+
+ENTRY(_deep_sleep)
+	[--SP] = ( R7:0, P5:0 );
+	[--SP] =  RETS;
+
+	CLI R4;
+
+	R0 = IWR_ENABLE(0);
+	R1 = IWR_DISABLE_ALL;
+	R2 = IWR_DISABLE_ALL;
+
+	call _set_sic_iwr;
+
+	call _set_dram_srfs;
+
+	/* Clear all the interrupts,bits sticky */
+	R0 = 0xFFFF (Z);
+	call _set_rtc_istat
+
+	P0.H = hi(PLL_CTL);
+	P0.L = lo(PLL_CTL);
+	R0 = W[P0](z);
+	BITSET (R0, 5);
+	W[P0] = R0.L;
+
+	call _test_pll_locked;
+
+	SSYNC;
+	IDLE;
+
+	call _unset_dram_srfs;
+
+	call _test_pll_locked;
+
+	R0 = IWR_ENABLE(0);
+	R1 = IWR_DISABLE_ALL;
+	R2 = IWR_DISABLE_ALL;
+
+	call _set_sic_iwr;
+
+	P0.H = hi(PLL_CTL);
+	P0.L = lo(PLL_CTL);
+	R0 = w[p0](z);
+	BITCLR (R0, 3);
+	BITCLR (R0, 5);
+	BITCLR (R0, 8);
+	w[p0] = R0;
+	IDLE;
+	call _test_pll_locked;
+
+	STI R4;
+
+	RETS = [SP++];
+	( R7:0, P5:0 ) = [SP++];
+	RTS;
+
+ENTRY(_sleep_deeper)
+	[--SP] = ( R7:0, P5:0 );
+	[--SP] =  RETS;
+
+	CLI R4;
+
+	P3 = R0;
+	P4 = R1;
+	P5 = R2;
+
+	R0 = IWR_ENABLE(0);
+	R1 = IWR_DISABLE_ALL;
+	R2 = IWR_DISABLE_ALL;
+
+	call _set_sic_iwr;
+	call _set_dram_srfs;	/* Set SDRAM Self Refresh */
+
+	/* Clear all the interrupts,bits sticky */
+	R0 = 0xFFFF (Z);
+	call _set_rtc_istat;
+	P0.H = hi(PLL_DIV);
+	P0.L = lo(PLL_DIV);
+	R6 = W[P0](z);
+	R0.L = 0xF;
+	W[P0] = R0.l;		/* Set Max VCO to SCLK divider */
+
+	P0.H = hi(PLL_CTL);
+	P0.L = lo(PLL_CTL);
+	R5 = W[P0](z);
+	R0.L = (CONFIG_MIN_VCO_HZ/CONFIG_CLKIN_HZ) << 9;
+	W[P0] = R0.l;		/* Set Min CLKIN to VCO multiplier */
+
+	SSYNC;
+	IDLE;
+
+	call _test_pll_locked;
+
+	P0.H = hi(VR_CTL);
+	P0.L = lo(VR_CTL);
+	R7 = W[P0](z);
+	R1 = 0x6;
+	R1 <<= 16;
+	R2 = 0x0404(Z);
+	R1 = R1|R2;
+
+	R2 = DEPOSIT(R7, R1);
+	W[P0] = R2;		/* Set Min Core Voltage */
+
+	SSYNC;
+	IDLE;
+
+	call _test_pll_locked;
+
+	R0 = P3;
+	R1 = P4;
+	R3 = P5;
+	call _set_sic_iwr;	/* Set Awake from IDLE */
+
+	P0.H = hi(PLL_CTL);
+	P0.L = lo(PLL_CTL);
+	R0 = W[P0](z);
+	BITSET (R0, 3);
+	W[P0] = R0.L;		/* Turn CCLK OFF */
+	SSYNC;
+	IDLE;
+
+	call _test_pll_locked;
+
+	R0 = IWR_ENABLE(0);
+	R1 = IWR_DISABLE_ALL;
+	R2 = IWR_DISABLE_ALL;
+
+	call _set_sic_iwr;	/* Set Awake from IDLE PLL */
+
+	P0.H = hi(VR_CTL);
+	P0.L = lo(VR_CTL);
+	W[P0]= R7;
+
+	SSYNC;
+	IDLE;
+
+	call _test_pll_locked;
+
+	P0.H = hi(PLL_DIV);
+	P0.L = lo(PLL_DIV);
+	W[P0]= R6;		/* Restore CCLK and SCLK divider */
+
+	P0.H = hi(PLL_CTL);
+	P0.L = lo(PLL_CTL);
+	w[p0] = R5;		/* Restore VCO multiplier */
+	IDLE;
+	call _test_pll_locked;
+
+	call _unset_dram_srfs;	/* SDRAM Self Refresh Off */
+
+	STI R4;
+
+	RETS = [SP++];
+	( R7:0, P5:0 ) = [SP++];
+	RTS;
+
+ENTRY(_set_dram_srfs)
+	/*  set the dram to self refresh mode */
+#if defined(CONFIG_BF54x)
+	P0.H = hi(EBIU_RSTCTL);
+	P0.L = lo(EBIU_RSTCTL);
+	R2 = [P0];
+	R3.H = hi(SRREQ);
+	R3.L = lo(SRREQ);
+#else
+	P0.H = hi(EBIU_SDGCTL);
+	P0.L = lo(EBIU_SDGCTL);
+	R2 = [P0];
+	R3.H = hi(SRFS);
+	R3.L = lo(SRFS);
+#endif
+	R2 = R2|R3;
+	[P0] = R2;
+	ssync;
+#if defined(CONFIG_BF54x)
+.LSRR_MODE:
+	R2 = [P0];
+	CC = BITTST(R2, 4);
+	if !CC JUMP .LSRR_MODE;
+#endif
+	RTS;
+
+ENTRY(_unset_dram_srfs)
+	/*  set the dram out of self refresh mode */
+#if defined(CONFIG_BF54x)
+	P0.H = hi(EBIU_RSTCTL);
+	P0.L = lo(EBIU_RSTCTL);
+	R2 = [P0];
+	R3.H = hi(SRREQ);
+	R3.L = lo(SRREQ);
+#else
+	P0.H = hi(EBIU_SDGCTL);
+	P0.L = lo(EBIU_SDGCTL);
+	R2 = [P0];
+	R3.H = hi(SRFS);
+	R3.L = lo(SRFS);
+#endif
+	R3 = ~R3;
+	R2 = R2&R3;
+	[P0] = R2;
+	ssync;
+	RTS;
+
+ENTRY(_set_sic_iwr)
+#if defined(CONFIG_BF54x) || defined(CONFIG_BF52x)  || defined(CONFIG_BF561)
+	P0.H = hi(SIC_IWR0);
+	P0.L = lo(SIC_IWR0);
+	P1.H = hi(SIC_IWR1);
+	P1.L = lo(SIC_IWR1);
+	[P1] = R1;
+#if defined(CONFIG_BF54x)
+	P1.H = hi(SIC_IWR2);
+	P1.L = lo(SIC_IWR2);
+	[P1] = R2;
+#endif
+#else
+	P0.H = hi(SIC_IWR);
+	P0.L = lo(SIC_IWR);
+#endif
+	[P0] = R0;
+
+	SSYNC;
+	RTS;
+
+ENTRY(_set_rtc_istat)
+#ifndef CONFIG_BF561
+	P0.H = hi(RTC_ISTAT);
+	P0.L = lo(RTC_ISTAT);
+	w[P0] = R0.L;
+	SSYNC;
+#endif
+	RTS;
+
+ENTRY(_test_pll_locked)
+	P0.H = hi(PLL_STAT);
+	P0.L = lo(PLL_STAT);
+1:
+	R0 = W[P0] (Z);
+	CC = BITTST(R0,5);
+	IF !CC JUMP 1b;
+	RTS;
diff --git a/arch/blackfin/mach-common/entry.S
b/arch/blackfin/mach-common/entry.S
index f2fb87e..038f70e 100644
--- a/arch/blackfin/mach-common/entry.S
+++ b/arch/blackfin/mach-common/entry.S
@@ -151,26 +151,62 @@ ENTRY(_ex_soft_bp)
 ENDPROC(_ex_soft_bp)

 ENTRY(_ex_single_step)
+	/* If we just returned from an interrupt, the single step event is
+	   for the RTI instruction.  */
 	r7 = retx;
 	r6 = reti;
 	cc = r7 == r6;
-	if cc jump _bfin_return_from_exception
-	r7 = syscfg;
-	bitclr (r7, 0);
-	syscfg = R7;
+	if cc jump _bfin_return_from_exception;

+	/* If we were in user mode, do the single step normally.  */
 	p5.l = lo(IPEND);
 	p5.h = hi(IPEND);
 	r6 = [p5];
-	cc = bittst(r6, 5);
-	if !cc jump _ex_trap_c;
-	p4.l = lo(EVT5);
-	p4.h = hi(EVT5);
-	r6.h = _exception_to_level5;
-	r6.l = _exception_to_level5;
-	r7 = [p4];
-	cc = r6 == r7;
-	if !cc jump _ex_trap_c;
+	r7 = 0xffe0 (z);
+	r7 = r7 & r6;
+	cc = r7 == 0;
+	if !cc jump 1f;
+
+	/* Single stepping only a single instruction, so clear the trace
+	 * bit here.  */
+	r7 = syscfg;
+	bitclr (r7, 0);
+	syscfg = R7;
+	jump _ex_trap_c;
+
+1:
+	/*
+	 * We were in an interrupt handler.  By convention, all of them save
+	 * SYSCFG with their first instruction, so by checking whether our
+	 * RETX points at the entry point, we can determine whether to allow
+	 * a single step, or whether to clear SYSCFG.
+	 *
+	 * First, find out the interrupt level and the event vector for it.
+	 */
+	p5.l = lo(EVT0);
+	p5.h = hi(EVT0);
+	p5 += -4;
+2:
+	r7 = rot r7 by -1;
+	p5 += 4;
+	if !cc jump 2b;
+
+	/* What we actually do is test for the _second_ instruction in the
+	 * IRQ handler.  That way, if there are insns following the restore
+	 * of SYSCFG after leaving the handler, we will not turn off SYSCFG
+	 * for them.  */
+
+	r7 = [p5];
+	r7 += 2;
+	r6 = RETX;
+	cc = R7 == R6;
+	if !cc jump _bfin_return_from_exception;
+
+	r7 = syscfg;
+	bitclr (r7, 0);
+	syscfg = R7;
+
+	/* Fall through to _bfin_return_from_exception.  */
 ENDPROC(_ex_single_step)

 ENTRY(_bfin_return_from_exception)
@@ -234,20 +270,26 @@ ENTRY(_ex_trap_c)
 	p5.l = _saved_icplb_fault_addr;
 	[p5] = r7;

-	p4.l = __retx;
-	p4.h = __retx;
+	p4.l = _excpt_saved_stuff;
+	p4.h = _excpt_saved_stuff;
+
 	r6 = retx;
 	[p4] = r6;
-	p4.l = lo(SAFE_USER_INSTRUCTION);
-	p4.h = hi(SAFE_USER_INSTRUCTION);
-	retx = p4;
+
+	r6 = SYSCFG;
+	[p4 + 4] = r6;
+	BITCLR(r6, 0);
+	SYSCFG = r6;

 	/* Disable all interrupts, but make sure level 5 is enabled so
 	 * we can switch to that level.  Save the old mask.  */
 	cli r6;
-	p4.l = _excpt_saved_imask;
-	p4.h = _excpt_saved_imask;
-	[p4] = r6;
+	[p4 + 8] = r6;
+
+	p4.l = lo(SAFE_USER_INSTRUCTION);
+	p4.h = hi(SAFE_USER_INSTRUCTION);
+	retx = p4;
+
 	r6 = 0x3f;
 	sti r6;

@@ -295,6 +337,11 @@ ENTRY(_double_fault)
          */
         SAVE_ALL_SYS

+	/* The dumping functions expect the return address in the RETI
+	 * slot.  */
+	r6 = retx;
+	[sp + PT_PC] = r6;
+
         r0 = sp;        /* stack frame pt_regs pointer argument ==> r0 */
         SP += -12;
         call _double_fault_c;
@@ -307,16 +354,17 @@ ENDPROC(_double_fault)
 ENTRY(_exception_to_level5)
 	SAVE_ALL_SYS

-	p4.l = __retx;
-	p4.h = __retx;
+	p4.l = _excpt_saved_stuff;
+	p4.h = _excpt_saved_stuff;
 	r6 = [p4];
 	[sp + PT_PC] = r6;

+	r6 = [p4 + 4];
+	[sp + PT_SYSCFG] = r6;
+
 	/* Restore interrupt mask.  We haven't pushed RETI, so this
 	 * doesn't enable interrupts until we return from this handler.  */
-	p4.l = _excpt_saved_imask;
-	p4.h = _excpt_saved_imask;
-	r6 = [p4];
+	r6 = [p4 + 8];
 	sti r6;

 	/* Restore the hardware error vector.  */
@@ -1344,7 +1392,14 @@ ENTRY(_sys_call_table)
 	.rept NR_syscalls-(.-_sys_call_table)/4
 	.long _sys_ni_syscall
 	.endr
-_excpt_saved_imask:
+
+	/*
+	 * Used to save the real RETX, IMASK and SYSCFG when temporarily
+	 * storing safe values across the transition from exception to IRQ5.
+	 */
+_excpt_saved_stuff:
+	.long 0;
+	.long 0;
 	.long 0;

 _exception_stack:
@@ -1358,7 +1413,3 @@ _exception_stack_top:
 _last_cplb_fault_retx:
 	.long 0;
 #endif
-	/* Used to save the real RETX when temporarily storing a safe
-	 * return address.  */
-__retx:
-	.long 0;
diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 8a2f6a1..d6b4ead 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -65,9 +65,6 @@ static void bfin_serial_stop_tx(struct uart_port *port)
 {
 	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
 	struct circ_buf *xmit = &uart->port.info->xmit;
-#if !defined(CONFIG_BF54x) && !defined(CONFIG_SERIAL_BFIN_DMA)
-	unsigned short ier;
-#endif

 	while (!(UART_GET_LSR(uart) & TEMT))
 		cpu_relax();
@@ -82,12 +79,8 @@ static void bfin_serial_stop_tx(struct uart_port *port)
 #ifdef CONFIG_BF54x
 	/* Clear TFI bit */
 	UART_PUT_LSR(uart, TFI);
-	UART_CLEAR_IER(uart, ETBEI);
-#else
-	ier = UART_GET_IER(uart);
-	ier &= ~ETBEI;
-	UART_PUT_IER(uart, ier);
 #endif
+	UART_CLEAR_IER(uart, ETBEI);
 #endif
 }

@@ -102,14 +95,7 @@ static void bfin_serial_start_tx(struct uart_port *port)
 	if (uart->tx_done)
 		bfin_serial_dma_tx_chars(uart);
 #else
-#ifdef CONFIG_BF54x
 	UART_SET_IER(uart, ETBEI);
-#else
-	unsigned short ier;
-	ier = UART_GET_IER(uart);
-	ier |= ETBEI;
-	UART_PUT_IER(uart, ier);
-#endif
 	bfin_serial_tx_chars(uart);
 #endif
 }
@@ -120,21 +106,10 @@ static void bfin_serial_start_tx(struct uart_port *port)
 static void bfin_serial_stop_rx(struct uart_port *port)
 {
 	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
-#ifdef	CONFIG_KGDB_UART
-	if (uart->port.line != CONFIG_KGDB_UART_PORT) {
+#ifdef CONFIG_KGDB_UART
+	if (uart->port.line != CONFIG_KGDB_UART_PORT)
 #endif
-#ifdef CONFIG_BF54x
 	UART_CLEAR_IER(uart, ERBFI);
-#else
-	unsigned short ier;
-
-	ier = UART_GET_IER(uart);
-	ier &= ~ERBFI;
-	UART_PUT_IER(uart, ier);
-#endif
-#ifdef	CONFIG_KGDB_UART
-	}
-#endif
 }

 /*
@@ -161,10 +136,7 @@ void kgdb_put_debug_char(int chr)
 		SSYNC();
 	}

-#ifndef CONFIG_BF54x
-	UART_PUT_LCR(uart, UART_GET_LCR(uart)&(~DLAB));
-	SSYNC();
-#endif
+	UART_CLEAR_DLAB(uart);
 	UART_PUT_CHAR(uart, (unsigned char)chr);
 	SSYNC();
 }
@@ -183,10 +155,7 @@ int kgdb_get_debug_char(void)
 	while(!(UART_GET_LSR(uart) & DR)) {
 		SSYNC();
 	}
-#ifndef CONFIG_BF54x
-	UART_PUT_LCR(uart, UART_GET_LCR(uart)&(~DLAB));
-	SSYNC();
-#endif
+	UART_CLEAR_DLAB(uart);
 	chr = UART_GET_CHAR(uart);
 	SSYNC();

@@ -208,9 +177,6 @@ static void bfin_serial_rx_chars(struct
bfin_serial_port *uart)
 	struct tty_struct *tty = uart->port.info->tty;
 	unsigned int status, ch, flg;
 	static struct timeval anomaly_start = { .tv_sec = 0 };
-#ifdef CONFIG_KGDB_UART
-	struct pt_regs *regs = get_irq_regs();
-#endif

 	status = UART_GET_LSR(uart);
 	UART_CLEAR_LSR(uart);
@@ -220,6 +186,7 @@ static void bfin_serial_rx_chars(struct
bfin_serial_port *uart)

 #ifdef CONFIG_KGDB_UART
 	if (uart->port.line == CONFIG_KGDB_UART_PORT) {
+		struct pt_regs *regs = get_irq_regs();
 		if (uart->port.cons->index == CONFIG_KGDB_UART_PORT && ch == 0x1) {
/* Ctrl + A */
 			kgdb_breakkey_pressed(regs);
 			return;
@@ -391,7 +358,6 @@ static void bfin_serial_do_work(struct work_struct *work)
 static void bfin_serial_dma_tx_chars(struct bfin_serial_port *uart)
 {
 	struct circ_buf *xmit = &uart->port.info->xmit;
-	unsigned short ier;

 	uart->tx_done = 0;

@@ -429,13 +395,7 @@ static void bfin_serial_dma_tx_chars(struct
bfin_serial_port *uart)
 	set_dma_x_modify(uart->tx_dma_channel, 1);
 	enable_dma(uart->tx_dma_channel);

-#ifdef CONFIG_BF54x
 	UART_SET_IER(uart, ETBEI);
-#else
-	ier = UART_GET_IER(uart);
-	ier |= ETBEI;
-	UART_PUT_IER(uart, ier);
-#endif
 }

 static void bfin_serial_dma_rx_chars(struct bfin_serial_port *uart)
@@ -513,19 +473,12 @@ static irqreturn_t bfin_serial_dma_tx_int(int
irq, void *dev_id)
 {
 	struct bfin_serial_port *uart = dev_id;
 	struct circ_buf *xmit = &uart->port.info->xmit;
-	unsigned short ier;

 	spin_lock(&uart->port.lock);
 	if (!(get_dma_curr_irqstat(uart->tx_dma_channel)&DMA_RUN)) {
 		disable_dma(uart->tx_dma_channel);
 		clear_dma_irqstat(uart->tx_dma_channel);
-#ifdef CONFIG_BF54x
 		UART_CLEAR_IER(uart, ETBEI);
-#else
-		ier = UART_GET_IER(uart);
-		ier &= ~ETBEI;
-		UART_PUT_IER(uart, ier);
-#endif
 		xmit->tail = (xmit->tail + uart->tx_count) & (UART_XMIT_SIZE - 1);
 		uart->port.icount.tx += uart->tx_count;

@@ -701,7 +654,6 @@ static int bfin_serial_startup(struct uart_port *port)
 # endif
 	}

-
 	if (request_irq
 	    (uart->port.irq+1, bfin_serial_tx_int, IRQF_DISABLED,
 	     "BFIN_UART_TX", uart)) {
@@ -710,11 +662,7 @@ static int bfin_serial_startup(struct uart_port *port)
 		return -EBUSY;
 	}
 #endif
-#ifdef CONFIG_BF54x
 	UART_SET_IER(uart, ERBFI);
-#else
-	UART_PUT_IER(uart, UART_GET_IER(uart) | ERBFI);
-#endif
 	return 0;
 }

@@ -810,26 +758,15 @@ bfin_serial_set_termios(struct uart_port *port,
struct ktermios *termios,
 	UART_PUT_IER(uart, 0);
 #endif

-#ifndef CONFIG_BF54x
 	/* Set DLAB in LCR to Access DLL and DLH */
-	val = UART_GET_LCR(uart);
-	val |= DLAB;
-	UART_PUT_LCR(uart, val);
-	SSYNC();
-#endif
+	UART_SET_DLAB(uart);

 	UART_PUT_DLL(uart, quot & 0xFF);
-	SSYNC();
 	UART_PUT_DLH(uart, (quot >> 8) & 0xFF);
 	SSYNC();

-#ifndef CONFIG_BF54x
 	/* Clear DLAB in LCR to Access THR RBR IER */
-	val = UART_GET_LCR(uart);
-	val &= ~DLAB;
-	UART_PUT_LCR(uart, val);
-	SSYNC();
-#endif
+	UART_CLEAR_DLAB(uart);

 	UART_PUT_LCR(uart, lcr);

@@ -992,8 +929,7 @@ bfin_serial_console_get_options(struct
bfin_serial_port *uart, int *baud,
 	status = UART_GET_IER(uart) & (ERBFI | ETBEI);
 	if (status == (ERBFI | ETBEI)) {
 		/* ok, the port was enabled */
-		unsigned short lcr, val;
-		unsigned short dlh, dll;
+		u16 lcr, dlh, dll;

 		lcr = UART_GET_LCR(uart);

@@ -1010,22 +946,14 @@ bfin_serial_console_get_options(struct
bfin_serial_port *uart, int *baud,
 			case 2:	*bits = 7; break;
 			case 3:	*bits = 8; break;
 		}
-#ifndef CONFIG_BF54x
 		/* Set DLAB in LCR to Access DLL and DLH */
-		val = UART_GET_LCR(uart);
-		val |= DLAB;
-		UART_PUT_LCR(uart, val);
-#endif
+		UART_SET_DLAB(uart);

 		dll = UART_GET_DLL(uart);
 		dlh = UART_GET_DLH(uart);

-#ifndef CONFIG_BF54x
 		/* Clear DLAB in LCR to Access THR RBR IER */
-		val = UART_GET_LCR(uart);
-		val &= ~DLAB;
-		UART_PUT_LCR(uart, val);
-#endif
+		UART_CLEAR_DLAB(uart);

 		*baud = get_sclk() / (16*(dll | dlh << 8));
 	}
@@ -1290,11 +1218,7 @@ static int __init bfin_serial_init(void)
 		request_irq(uart->port.irq, bfin_serial_rx_int,
 			IRQF_DISABLED, "BFIN_UART_RX", uart);
 		pr_info("Request irq for kgdb uart port\n");
-#ifdef CONFIG_BF54x
 		UART_SET_IER(uart, ERBFI);
-#else
-		UART_PUT_IER(uart, UART_GET_IER(uart) | ERBFI);
-#endif
 		SSYNC();
 		t.c_cflag = CS8|B57600;
 		t.c_iflag = 0;
diff --git a/include/asm-blackfin/dpmc.h b/include/asm-blackfin/dpmc.h
index 686cf83..7f34cd3 100644
--- a/include/asm-blackfin/dpmc.h
+++ b/include/asm-blackfin/dpmc.h
@@ -1,7 +1,7 @@
 /*
  * include/asm-blackfin/dpmc.h -  Miscellaneous IOCTL commands for
Dynamic Power
  *   			 	Management Controller Driver.
- * Copyright (C) 2004 Analog Device Inc.
+ * Copyright (C) 2004-2008 Analog Device Inc.
  *
  */
 #ifndef _BLACKFIN_DPMC_H_
@@ -65,6 +65,14 @@ void disable_wdog_timer(void);
 extern unsigned long get_cclk(void);
 extern unsigned long get_sclk(void);

+struct bfin_dpmc_platform_data {
+	const unsigned int *tuple_tab;
+	unsigned short tabsize;
+	unsigned short vr_settling_time; /* in us */
+};
+
+#define VRPAIR(vlev, freq) (((vlev) << 16) | ((freq) >> 16))
+
 #endif	/* __KERNEL__ */

 #endif	/*_BLACKFIN_DPMC_H_*/
diff --git a/include/asm-blackfin/entry.h b/include/asm-blackfin/entry.h
index 562c6d3..c4f721e 100644
--- a/include/asm-blackfin/entry.h
+++ b/include/asm-blackfin/entry.h
@@ -17,6 +17,11 @@
 #define	PF_DTRACE_OFF	1
 #define	PF_DTRACE_BIT	5

+/*
+ * NOTE!  The single-stepping code assumes that all interrupt handlers
+ * start by saving SYSCFG on the stack with their first instruction.
+ */
+
 /* This one is used for exceptions, emulation, and NMI.  It doesn't push
    RETI and doesn't do cli.  */
 #define SAVE_ALL_SYS		save_context_no_interrupts
diff --git a/include/asm-blackfin/mach-bf527/bfin_serial_5xx.h
b/include/asm-blackfin/mach-bf527/bfin_serial_5xx.h
index f0ab273..26e3c80 100644
--- a/include/asm-blackfin/mach-bf527/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf527/bfin_serial_5xx.h
@@ -44,10 +44,15 @@
 #define UART_PUT_CHAR(uart, v)   bfin_write16(((uart)->port.membase +
OFFSET_THR), v)
 #define UART_PUT_DLL(uart, v)    bfin_write16(((uart)->port.membase +
OFFSET_DLL), v)
 #define UART_PUT_IER(uart, v)    bfin_write16(((uart)->port.membase +
OFFSET_IER), v)
+#define UART_SET_IER(uart, v)    UART_PUT_IER(uart, UART_GET_IER(uart) | (v))
+#define UART_CLEAR_IER(uart, v)  UART_PUT_IER(uart, UART_GET_IER(uart) & ~(v))
 #define UART_PUT_DLH(uart, v)    bfin_write16(((uart)->port.membase +
OFFSET_DLH), v)
 #define UART_PUT_LCR(uart, v)    bfin_write16(((uart)->port.membase +
OFFSET_LCR), v)
 #define UART_PUT_GCTL(uart, v)   bfin_write16(((uart)->port.membase +
OFFSET_GCTL), v)

+#define UART_SET_DLAB(uart)     do { UART_PUT_LCR(uart,
UART_GET_LCR(uart) | DLAB); SSYNC(); } while (0)
+#define UART_CLEAR_DLAB(uart)   do { UART_PUT_LCR(uart,
UART_GET_LCR(uart) & ~DLAB); SSYNC(); } while (0)
+
 #if defined(CONFIG_BFIN_UART0_CTSRTS) || defined(CONFIG_BFIN_UART1_CTSRTS)
 # define CONFIG_SERIAL_BFIN_CTSRTS

diff --git a/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
b/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
index fbe88de..d016603 100644
--- a/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
@@ -44,10 +44,15 @@
 #define UART_PUT_CHAR(uart,v)   bfin_write16(((uart)->port.membase +
OFFSET_THR),v)
 #define UART_PUT_DLL(uart,v)    bfin_write16(((uart)->port.membase +
OFFSET_DLL),v)
 #define UART_PUT_IER(uart,v)    bfin_write16(((uart)->port.membase +
OFFSET_IER),v)
+#define UART_SET_IER(uart,v)    UART_PUT_IER(uart, UART_GET_IER(uart) | (v))
+#define UART_CLEAR_IER(uart,v)  UART_PUT_IER(uart, UART_GET_IER(uart) & ~(v))
 #define UART_PUT_DLH(uart,v)    bfin_write16(((uart)->port.membase +
OFFSET_DLH),v)
 #define UART_PUT_LCR(uart,v)    bfin_write16(((uart)->port.membase +
OFFSET_LCR),v)
 #define UART_PUT_GCTL(uart,v)   bfin_write16(((uart)->port.membase +
OFFSET_GCTL),v)

+#define UART_SET_DLAB(uart)     do { UART_PUT_LCR(uart,
UART_GET_LCR(uart) | DLAB); SSYNC(); } while (0)
+#define UART_CLEAR_DLAB(uart)   do { UART_PUT_LCR(uart,
UART_GET_LCR(uart) & ~DLAB); SSYNC(); } while (0)
+
 #ifdef CONFIG_BFIN_UART0_CTSRTS
 # define CONFIG_SERIAL_BFIN_CTSRTS
 # ifndef CONFIG_UART0_CTS_PIN
diff --git a/include/asm-blackfin/mach-bf533/defBF532.h
b/include/asm-blackfin/mach-bf533/defBF532.h
index 17e1548..0ab4dd7 100644
--- a/include/asm-blackfin/mach-bf533/defBF532.h
+++ b/include/asm-blackfin/mach-bf533/defBF532.h
@@ -468,6 +468,8 @@
 #define	VLEV_110		0x00B0	/* 		VLEV = 1.10 V (-5% - +10% Accuracy)	*/
 #define	VLEV_115		0x00C0	/* 		VLEV = 1.15 V (-5% - +10% Accuracy)	*/
 #define	VLEV_120		0x00D0	/* 		VLEV = 1.20 V (-5% - +10% Accuracy)	*/
+#define	VLEV_125		0x00E0	/*              VLEV = 1.25 V (-5% - +10%
Accuracy)     */
+#define	VLEV_130		0x00F0	/*              VLEV = 1.30 V (-5% - +10%
Accuracy)     */

 #define	WAKE			0x0100	/* Enable RTC/Reset Wakeup From Hibernate	*/
 #define	SCKELOW			0x8000	/* Do Not Drive SCKE High During Reset After
Hibernate */
diff --git a/include/asm-blackfin/mach-bf533/irq.h
b/include/asm-blackfin/mach-bf533/irq.h
index 832e6f6..5aa38e5 100644
--- a/include/asm-blackfin/mach-bf533/irq.h
+++ b/include/asm-blackfin/mach-bf533/irq.h
@@ -66,12 +66,13 @@ Core        Emulation               **
 	    DMA8/9 Interrupt	    IVG13	28
 	    DMA10/11 Interrupt	    IVG13	29
 	    Watchdog Timer	    IVG13	30
-            Software Interrupt 1    IVG14       31
-            Software Interrupt 2    --
+
+            Softirq		    IVG14       31
+            System Call    --
                  (lowest priority)  IVG15       32 *
  */
-#define SYS_IRQS		32
-#define NR_PERI_INTS    24
+#define SYS_IRQS	31
+#define NR_PERI_INTS	24

 /* The ABSTRACT IRQ definitions */
 /** the first seven of the following are fixed, the rest you change
if you need to **/
@@ -96,7 +97,7 @@ Core        Emulation               **
 #define	IRQ_SPORT0_TX		17	/*DMA2 Interrupt (SPORT0 TX) */
 #define	IRQ_SPORT1_RX		18	/*DMA3 Interrupt (SPORT1 RX) */
 #define	IRQ_SPORT1_TX		19	/*DMA4 Interrupt (SPORT1 TX) */
-#define IRQ_SPI			20	/*DMA5 Interrupt (SPI) */
+#define 	IRQ_SPI			20	/*DMA5 Interrupt (SPI) */
 #define	IRQ_UART_RX		21	/*DMA6 Interrupt (UART RX) */
 #define	IRQ_UART_TX		22	/*DMA7 Interrupt (UART TX) */
 #define	IRQ_TMR0		23	/*Timer 0 */
@@ -108,9 +109,6 @@ Core        Emulation               **
 #define	IRQ_MEM_DMA1		29	/*DMA10/11 Interrupt (Memory DMA Stream 1) */
 #define	IRQ_WATCH	   	30	/*Watch Dog Timer */

-#define	IRQ_SW_INT1		31	/*Software Int 1 */
-#define	IRQ_SW_INT2		32	/*Software Int 2 (reserved for SYSCALL) */
-
 #define IRQ_PF0			33
 #define IRQ_PF1			34
 #define IRQ_PF2			35
diff --git a/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h
b/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h
index fd100a4..f79d1a0 100644
--- a/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h
@@ -44,10 +44,15 @@
 #define UART_PUT_CHAR(uart,v)   bfin_write16(((uart)->port.membase +
OFFSET_THR),v)
 #define UART_PUT_DLL(uart,v)    bfin_write16(((uart)->port.membase +
OFFSET_DLL),v)
 #define UART_PUT_IER(uart,v)    bfin_write16(((uart)->port.membase +
OFFSET_IER),v)
+#define UART_SET_IER(uart,v)    UART_PUT_IER(uart, UART_GET_IER(uart) | (v))
+#define UART_CLEAR_IER(uart,v)  UART_PUT_IER(uart, UART_GET_IER(uart) & ~(v))
 #define UART_PUT_DLH(uart,v)    bfin_write16(((uart)->port.membase +
OFFSET_DLH),v)
 #define UART_PUT_LCR(uart,v)    bfin_write16(((uart)->port.membase +
OFFSET_LCR),v)
 #define UART_PUT_GCTL(uart,v)   bfin_write16(((uart)->port.membase +
OFFSET_GCTL),v)

+#define UART_SET_DLAB(uart)     do { UART_PUT_LCR(uart,
UART_GET_LCR(uart) | DLAB); SSYNC(); } while (0)
+#define UART_CLEAR_DLAB(uart)   do { UART_PUT_LCR(uart,
UART_GET_LCR(uart) & ~DLAB); SSYNC(); } while (0)
+
 #if defined(CONFIG_BFIN_UART0_CTSRTS) || defined(CONFIG_BFIN_UART1_CTSRTS)
 # define CONFIG_SERIAL_BFIN_CTSRTS

diff --git a/include/asm-blackfin/mach-bf537/irq.h
b/include/asm-blackfin/mach-bf537/irq.h
index be6f2ff..2e68a8a 100644
--- a/include/asm-blackfin/mach-bf537/irq.h
+++ b/include/asm-blackfin/mach-bf537/irq.h
@@ -34,24 +34,23 @@

 /*
  * Interrupt source definitions
-             Event Source    Core Event Name
-Core        Emulation               **
- Events         (highest priority)  EMU         0
-            Reset                   RST         1
-            NMI                     NMI         2
-            Exception               EVX         3
-            Reserved                --          4
-            Hardware Error          IVHW        5
-            Core Timer              IVTMR       6 *
-
-.....
-
-            Software Interrupt 1    IVG14       31
-            Software Interrupt 2    --
-                 (lowest priority)  IVG15       32 *
+ *            Event Source    Core Event Name
+ * Core       Emulation               **
+ * Events         (highest priority)  EMU         0
+ *            Reset                   RST         1
+ *            NMI                     NMI         2
+ *            Exception               EVX         3
+ *            Reserved                --          4
+ *            Hardware Error          IVHW        5
+ *            Core Timer              IVTMR       6
+ *  .....
+ *
+ *            Softirq		      IVG14
+ *            System Call    --
+ *               (lowest priority)    IVG15
  */

-#define SYS_IRQS        41
+#define SYS_IRQS        39
 #define NR_PERI_INTS    32

 /* The ABSTRACT IRQ definitions */
@@ -95,10 +94,8 @@ Core        Emulation               **
 #define IRQ_PORTG_INTB      35	/* PF Port G (PF15:0) Interrupt B */
 #define IRQ_MEM_DMA0        36	/*(Memory DMA Stream 0) */
 #define IRQ_MEM_DMA1        37	/*(Memory DMA Stream 1) */
-#define IRQ_PROG_INTB	    38	/* PF Ports F (PF15:0) Interrupt B */
+#define IRQ_PROG_INTB	      38	/* PF Ports F (PF15:0) Interrupt B */
 #define IRQ_WATCH           38	/*Watch Dog Timer */
-#define IRQ_SW_INT1         40	/*Software Int 1 */
-#define IRQ_SW_INT2         41	/*Software Int 2 (reserved for SYSCALL) */

 #define IRQ_PPI_ERROR       42	/*PPI Error Interrupt */
 #define IRQ_CAN_ERROR       43	/*CAN Error Interrupt */
diff --git a/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
b/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
index 6547027..5eb46a7 100644
--- a/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
@@ -54,6 +54,9 @@
 #define UART_PUT_GCTL(uart,v)   bfin_write16(((uart)->port.membase +
OFFSET_GCTL),v)
 #define UART_PUT_MCR(uart,v)    bfin_write16(((uart)->port.membase +
OFFSET_MCR),v)

+#define UART_SET_DLAB(uart)     /* MMRs not muxed on BF54x */
+#define UART_CLEAR_DLAB(uart)   /* MMRs not muxed on BF54x */
+
 #if defined(CONFIG_BFIN_UART0_CTSRTS) || defined(CONFIG_BFIN_UART1_CTSRTS)
 # define CONFIG_SERIAL_BFIN_CTSRTS

diff --git a/include/asm-blackfin/mach-bf548/defBF54x_base.h
b/include/asm-blackfin/mach-bf548/defBF54x_base.h
index 08f90c2..e022e89 100644
--- a/include/asm-blackfin/mach-bf548/defBF54x_base.h
+++ b/include/asm-blackfin/mach-bf548/defBF54x_base.h
@@ -2329,6 +2329,26 @@
 #define                    KPADWE  0x1000     /* Keypad Wake-Up Enable */
 #define                     ROTWE  0x2000     /* Rotary Wake-Up Enable */

+#define	FREQ_333		0x0001	/* Switching Frequency Is 333 kHz */
+#define	FREQ_667		0x0002	/* Switching Frequency Is 667 kHz */
+#define	FREQ_1000		0x0003	/* Switching Frequency Is 1 MHz */
+
+#define	GAIN_5			0x0000	/* GAIN = 5*/
+#define	GAIN_10			0x0004	/* GAIN = 1*/
+#define	GAIN_20			0x0008	/* GAIN = 2*/
+#define	GAIN_50			0x000C	/* GAIN = 5*/
+
+#define	VLEV_085 		0x0060	/* VLEV = 0.85 V (-5% - +10% Accuracy) */
+#define	VLEV_090		0x0070	/* VLEV = 0.90 V (-5% - +10% Accuracy) */
+#define	VLEV_095		0x0080	/* VLEV = 0.95 V (-5% - +10% Accuracy) */
+#define	VLEV_100		0x0090	/* VLEV = 1.00 V (-5% - +10% Accuracy) */
+#define	VLEV_105		0x00A0	/* VLEV = 1.05 V (-5% - +10% Accuracy) */
+#define	VLEV_110		0x00B0	/* VLEV = 1.10 V (-5% - +10% Accuracy) */
+#define	VLEV_115		0x00C0	/* VLEV = 1.15 V (-5% - +10% Accuracy) */
+#define	VLEV_120		0x00D0	/* VLEV = 1.20 V (-5% - +10% Accuracy) */
+#define	VLEV_125		0x00E0	/* VLEV = 1.25 V (-5% - +10% Accuracy) */
+#define	VLEV_130		0x00F0	/* VLEV = 1.30 V (-5% - +10% Accuracy) */
+
 /* Bit masks for NFC_CTL */

 #define                    WR_DLY  0xf        /* Write Strobe Delay */
diff --git a/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
b/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
index 8a4e66d..7a96287 100644
--- a/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
@@ -44,10 +44,15 @@
 #define UART_PUT_CHAR(uart,v)   bfin_write16(((uart)->port.membase +
OFFSET_THR),v)
 #define UART_PUT_DLL(uart,v)    bfin_write16(((uart)->port.membase +
OFFSET_DLL),v)
 #define UART_PUT_IER(uart,v)    bfin_write16(((uart)->port.membase +
OFFSET_IER),v)
+#define UART_SET_IER(uart,v)    UART_PUT_IER(uart, UART_GET_IER(uart) | (v))
+#define UART_CLEAR_IER(uart,v)  UART_PUT_IER(uart, UART_GET_IER(uart) & ~(v))
 #define UART_PUT_DLH(uart,v)    bfin_write16(((uart)->port.membase +
OFFSET_DLH),v)
 #define UART_PUT_LCR(uart,v)    bfin_write16(((uart)->port.membase +
OFFSET_LCR),v)
 #define UART_PUT_GCTL(uart,v)   bfin_write16(((uart)->port.membase +
OFFSET_GCTL),v)

+#define UART_SET_DLAB(uart)     do { UART_PUT_LCR(uart,
UART_GET_LCR(uart) | DLAB); SSYNC(); } while (0)
+#define UART_CLEAR_DLAB(uart)   do { UART_PUT_LCR(uart,
UART_GET_LCR(uart) & ~DLAB); SSYNC(); } while (0)
+
 #ifdef CONFIG_BFIN_UART0_CTSRTS
 # define CONFIG_SERIAL_BFIN_CTSRTS
 # ifndef CONFIG_UART0_CTS_PIN
diff --git a/include/asm-blackfin/mach-bf561/defBF561.h
b/include/asm-blackfin/mach-bf561/defBF561.h
index 366c9b9..1ab50e9 100644
--- a/include/asm-blackfin/mach-bf561/defBF561.h
+++ b/include/asm-blackfin/mach-bf561/defBF561.h
@@ -868,6 +868,34 @@
 #define CHIPID_FAMILY          0x0FFFF000
 #define CHIPID_MANUFACTURE     0x00000FFE

+/* VR_CTL Masks																	*/
+#define	FREQ			0x0003	/* Switching Oscillator Frequency For Regulator	*/
+#define	HIBERNATE		0x0000	/* Powerdown/Bypass On-Board Regulation	*/
+#define	FREQ_333		0x0001	/* Switching Frequency Is 333 kHz */
+#define	FREQ_667		0x0002	/* Switching Frequency Is 667 kHz */
+#define	FREQ_1000		0x0003	/* Switching Frequency Is 1 MHz */
+
+#define	GAIN			0x000C	/* Voltage Level Gain	*/
+#define	GAIN_5			0x0000	/* GAIN = 5*/
+#define	GAIN_10			0x0004	/* GAIN = 1*/
+#define	GAIN_20			0x0008	/* GAIN = 2*/
+#define	GAIN_50			0x000C	/* GAIN = 5*/
+
+#define	VLEV			0x00F0	/* Internal Voltage Level */
+#define	VLEV_085 		0x0060	/* VLEV = 0.85 V (-5% - +10% Accuracy) */
+#define	VLEV_090		0x0070	/* VLEV = 0.90 V (-5% - +10% Accuracy) */
+#define	VLEV_095		0x0080	/* VLEV = 0.95 V (-5% - +10% Accuracy) */
+#define	VLEV_100		0x0090	/* VLEV = 1.00 V (-5% - +10% Accuracy) */
+#define	VLEV_105		0x00A0	/* VLEV = 1.05 V (-5% - +10% Accuracy) */
+#define	VLEV_110		0x00B0	/* VLEV = 1.10 V (-5% - +10% Accuracy) */
+#define	VLEV_115		0x00C0	/* VLEV = 1.15 V (-5% - +10% Accuracy) */
+#define	VLEV_120		0x00D0	/* VLEV = 1.20 V (-5% - +10% Accuracy) */
+#define	VLEV_125		0x00E0	/* VLEV = 1.25 V (-5% - +10% Accuracy) */
+#define	VLEV_130		0x00F0	/* VLEV = 1.30 V (-5% - +10% Accuracy) */
+
+#define	WAKE			0x0100	/* Enable RTC/Reset Wakeup From Hibernate */
+#define	SCKELOW			0x8000	/* Do Not Drive SCKE High During Reset After
Hibernate */
+
 /* PLL_DIV Masks */
 #define SCLK_DIV(x)  (x)	/* SCLK = VCO / x */

diff --git a/include/asm-blackfin/mach-bf561/irq.h
b/include/asm-blackfin/mach-bf561/irq.h
index 83f0383..6698389 100644
--- a/include/asm-blackfin/mach-bf561/irq.h
+++ b/include/asm-blackfin/mach-bf561/irq.h
@@ -118,12 +118,13 @@
 	    Supplemental interrupt 0		IVG7	    69
 	    supplemental interrupt 1		IVG7	    70

-            Software Interrupt 1		IVG14       71
-            Software Interrupt 2		IVG15       72 *
-						(lowest priority)
+            Softirq		    		IVG14
+            System Call    --
+                 (lowest priority)  		IVG15
+
  **********************************************************************/

-#define SYS_IRQS		72
+#define SYS_IRQS		71
 #define NR_PERI_INTS		64

 /*
@@ -237,9 +238,7 @@
 #define IRQ_RESERVED_2		(IVG_BASE + 61)	/* Reserved interrupt       */
 #define IRQ_SUPPLE_0		(IVG_BASE + 62)	/* Supplemental interrupt 0 */
 #define IRQ_SUPPLE_1		(IVG_BASE + 63)	/* supplemental interrupt 1 */
-#define	IRQ_SW_INT1		71	/* Software Interrupt 1     */
-#define	IRQ_SW_INT2		72	/* Software Interrupt 2     */
-						/* reserved for SYSCALL */
+
 #define IRQ_PF0			73
 #define IRQ_PF1			74
 #define IRQ_PF2			75
diff --git a/include/asm-blackfin/mach-common/context.S
b/include/asm-blackfin/mach-common/context.S
index fd0ebe1..c0e630e 100644
--- a/include/asm-blackfin/mach-common/context.S
+++ b/include/asm-blackfin/mach-common/context.S
@@ -28,6 +28,11 @@
  */

 /*
+ * NOTE!  The single-stepping code assumes that all interrupt handlers
+ * start by saving SYSCFG on the stack with their first instruction.
+ */
+
+/*
  * Code to save processor context.
  *  We even save the register which are preserved by a function call
  *	 - r4, r5, r6, r7, p3, p4, p5
diff --git a/include/asm-blackfin/time.h b/include/asm-blackfin/time.h
index 6e5859b..ddc43ce 100644
--- a/include/asm-blackfin/time.h
+++ b/include/asm-blackfin/time.h
@@ -24,6 +24,8 @@

 #ifndef CONFIG_CPU_FREQ
 #define TIME_SCALE 1
+#define __bfin_cycles_off (0)
+#define __bfin_cycles_mod (0)
 #else
 /*
  * Blackfin CPU frequency scaling supports max Core Clock 1, 1/2 and 1/4 .
@@ -31,6 +33,8 @@
  * adjust the Core Timer Presale Register. This way we don't lose time.
  */
 #define TIME_SCALE 4
+extern unsigned long long __bfin_cycles_off;
+extern unsigned int __bfin_cycles_mod;
 #endif

 #endif
