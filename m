Return-Path: <linux-kernel-owner+w=401wt.eu-S1755566Ab0A1MyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab0A1MyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 07:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755281Ab0A1MyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 07:54:24 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:54032 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754677Ab0A1MyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 07:54:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=XC+HqdYjoU73rY6dMvQ550OGQOGtL6XPrPTBu/AuWKK4jnay2RxcS76nnioDMprmr8
         4Cc0QMV1T+WRwHwc7hHF7523lxiM+RG5p1G1SY+9EfHn2Bt0fQq+a3puL/Ssvo6LZtJX
         7Lj8L1aARRfpgXmL3BTAFVfF+wrbjgALJCep8=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux@arm.linux.org.uk
Cc: eric.y.miao@gmail.com, tony@atomide.com, linux-kernel@vger.kernel.org,
       khilman@deeprootsystems.com, lethal@linux-sh.org, ben-linux@fluff.org,
       Magnus Damm <magnus.damm@gmail.com>,
       linux-arm-kernel@lists.infradead.org
Date: Thu, 28 Jan 2010 21:40:38 +0900
Message-Id: <20100128124038.8982.82995.sendpatchset@rxone.opensource.se>
In-Reply-To: <20100128124028.8982.16123.sendpatchset@rxone.opensource.se>
References: <20100128124028.8982.16123.sendpatchset@rxone.opensource.se>
Subject: [PATCH 01/06] ARM: SuperH Mobile ARM, sh7367 and G3EVM support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

This patch contains the SuperH Mobile ARM base support together
with sh7367 CPU and G3EVM board support. Only timer, serial
console and NOR flash are supported at this point. Patches for
the interrupt controller, pinmux support, clock framework and
runtime pm will be submitted as feature patches on top of this.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Applies on top of linux-next 20100119

 arch/arm/Kconfig                                  |    7 
 arch/arm/Makefile                                 |    1 
 arch/arm/mach-shmobile/Kconfig                    |   53 ++++
 arch/arm/mach-shmobile/Makefile                   |   12 +
 arch/arm/mach-shmobile/Makefile.boot              |    9 
 arch/arm/mach-shmobile/board-g3evm.c              |  127 +++++++++++
 arch/arm/mach-shmobile/clock-sh7367.c             |   89 +++++++
 arch/arm/mach-shmobile/include/mach/clkdev.h      |    7 
 arch/arm/mach-shmobile/include/mach/common.h      |   11 
 arch/arm/mach-shmobile/include/mach/dma.h         |    1 
 arch/arm/mach-shmobile/include/mach/entry-macro.S |   39 +++
 arch/arm/mach-shmobile/include/mach/gpio.h        |    1 
 arch/arm/mach-shmobile/include/mach/hardware.h    |    7 
 arch/arm/mach-shmobile/include/mach/io.h          |    9 
 arch/arm/mach-shmobile/include/mach/irqs.h        |   10 
 arch/arm/mach-shmobile/include/mach/memory.h      |    7 
 arch/arm/mach-shmobile/include/mach/system.h      |   14 +
 arch/arm/mach-shmobile/include/mach/timex.h       |    6 
 arch/arm/mach-shmobile/include/mach/uncompress.h  |   21 +
 arch/arm/mach-shmobile/include/mach/vmalloc.h     |    6 
 arch/arm/mach-shmobile/setup-sh7367.c             |  241 +++++++++++++++++++++
 arch/arm/mach-shmobile/timer.c                    |   46 ++++
 22 files changed, 724 insertions(+)

--- 0001/arch/arm/Kconfig
+++ work/arch/arm/Kconfig	2010-01-20 18:59:55.000000000 +0900
@@ -740,6 +740,11 @@ config ARCH_U8500
 	help
 	  Support for ST-Ericsson's Ux500 architecture
 
+config ARCH_SHMOBILE
+	bool "Renesas SH-Mobile"
+	help
+	  Support for Renesas's SH-Mobile ARM platforms
+
 endchoice
 
 source "arch/arm/mach-aaec2000/Kconfig"
@@ -851,6 +856,8 @@ source "arch/arm/mach-versatile/Kconfig"
 
 source "arch/arm/mach-w90x900/Kconfig"
 
+source "arch/arm/mach-shmobile/Kconfig"
+
 # Definitions to make life easier
 config ARCH_ACORN
 	bool
--- 0001/arch/arm/Makefile
+++ work/arch/arm/Makefile	2010-01-20 18:59:55.000000000 +0900
@@ -166,6 +166,7 @@ machine-$(CONFIG_ARCH_S5P6440)		:= s5p64
 machine-$(CONFIG_ARCH_S5PC1XX)		:= s5pc100
 machine-$(CONFIG_ARCH_SA1100)		:= sa1100
 machine-$(CONFIG_ARCH_SHARK)		:= shark
+machine-$(CONFIG_ARCH_SHMOBILE) 	:= shmobile
 machine-$(CONFIG_ARCH_STMP378X)		:= stmp378x
 machine-$(CONFIG_ARCH_STMP37XX)		:= stmp37xx
 machine-$(CONFIG_ARCH_U300)		:= u300
--- /dev/null
+++ work/arch/arm/mach-shmobile/Kconfig	2010-01-20 18:59:56.000000000 +0900
@@ -0,0 +1,53 @@
+if ARCH_SHMOBILE
+
+comment "SH-Mobile System Type"
+
+config ARCH_SH7367
+	bool "SH-Mobile SH7367 (G3)"
+	select CPU_V6
+	select HAVE_CLK
+	select COMMON_CLKDEV
+	select GENERIC_TIME
+	select GENERIC_CLOCKEVENTS
+
+comment "SH-Mobile Board Type"
+
+config MACH_G3EVM
+	bool "G3EVM board"
+	depends on ARCH_SH7367
+
+comment "SH-Mobile System Configuration"
+
+menu "Memory configuration"
+
+config MEMORY_START
+	hex "Physical memory start address"
+	default "0x50000000" if MACH_G3EVM
+	default "0x00000000"
+	---help---
+	  Tweak this only when porting to a new machine which does not
+	  already have a defconfig. Changing it from the known correct
+	  value on any of the known systems will only lead to disaster.
+
+config MEMORY_SIZE
+	hex "Physical memory size"
+	default "0x08000000" if MACH_G3EVM
+	default "0x04000000"
+	help
+	  This sets the default memory size assumed by your kernel. It can
+	  be overridden as normal by the 'mem=' argument on the kernel command
+	  line.
+
+endmenu
+
+menu "Timer and clock configuration"
+
+config SH_TIMER_CMT
+	bool "CMT timer driver"
+	default y
+	help
+	  This enables build of the CMT timer driver.
+
+endmenu
+
+endif
--- /dev/null
+++ work/arch/arm/mach-shmobile/Makefile	2010-01-20 18:59:56.000000000 +0900
@@ -0,0 +1,12 @@
+#
+# Makefile for the linux kernel.
+#
+
+# Common objects
+obj-y				:= timer.o
+
+# CPU objects
+obj-$(CONFIG_ARCH_SH7367)	+= setup-sh7367.o clock-sh7367.o
+
+# Board objects
+obj-$(CONFIG_MACH_G3EVM)	+= board-g3evm.o
--- /dev/null
+++ work/arch/arm/mach-shmobile/Makefile.boot	2010-01-20 18:59:56.000000000 +0900
@@ -0,0 +1,9 @@
+__ZRELADDR	:= $(shell /bin/bash -c 'printf "0x%08x" \
+		     $$[$(CONFIG_MEMORY_START) + 0x8000]')
+
+   zreladdr-y   := $(__ZRELADDR)
+
+# Unsupported legacy stuff
+#
+#params_phys-y (Instead: Pass atags pointer in r2)
+#initrd_phys-y (Instead: Use compiled-in initramfs)
--- /dev/null
+++ work/arch/arm/mach-shmobile/board-g3evm.c	2010-01-20 18:59:56.000000000 +0900
@@ -0,0 +1,127 @@
+/*
+ * G3EVM board support
+ *
+ * Copyright (C) 2010  Magnus Damm
+ * Copyright (C) 2008  Yoshihiro Shimoda
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/platform_device.h>
+#include <linux/delay.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/partitions.h>
+#include <linux/mtd/physmap.h>
+#include <linux/io.h>
+#include <mach/common.h>
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+
+static struct mtd_partition nor_flash_partitions[] = {
+	{
+		.name		= "loader",
+		.offset		= 0x00000000,
+		.size		= 512 * 1024,
+	},
+	{
+		.name		= "bootenv",
+		.offset		= MTDPART_OFS_APPEND,
+		.size		= 512 * 1024,
+	},
+	{
+		.name		= "kernel_ro",
+		.offset		= MTDPART_OFS_APPEND,
+		.size		= 8 * 1024 * 1024,
+		.mask_flags	= MTD_WRITEABLE,
+	},
+	{
+		.name		= "kernel",
+		.offset		= MTDPART_OFS_APPEND,
+		.size		= 8 * 1024 * 1024,
+	},
+	{
+		.name		= "data",
+		.offset		= MTDPART_OFS_APPEND,
+		.size		= MTDPART_SIZ_FULL,
+	},
+};
+
+static struct physmap_flash_data nor_flash_data = {
+	.width		= 2,
+	.parts		= nor_flash_partitions,
+	.nr_parts	= ARRAY_SIZE(nor_flash_partitions),
+};
+
+static struct resource nor_flash_resources[] = {
+	[0]	= {
+		.start	= 0x00000000,
+		.end	= 0x08000000 - 1,
+		.flags	= IORESOURCE_MEM,
+	}
+};
+
+static struct platform_device nor_flash_device = {
+	.name		= "physmap-flash",
+	.dev		= {
+		.platform_data	= &nor_flash_data,
+	},
+	.num_resources	= ARRAY_SIZE(nor_flash_resources),
+	.resource	= nor_flash_resources,
+};
+
+
+static struct platform_device *g3evm_devices[] __initdata = {
+	&nor_flash_device,
+};
+
+static struct map_desc g3evm_io_desc[] __initdata = {
+	/* create a 1:1 entity map for 0xe6xxxxxx
+	 * used by CPGA, INTC and PFC.
+	 */
+	{
+		.virtual	= 0xe6000000,
+		.pfn		= __phys_to_pfn(0xe6000000),
+		.length		= 256 << 20,
+		.type		= MT_DEVICE_NONSHARED
+	},
+};
+
+static void __init g3evm_map_io(void)
+{
+	iotable_init(g3evm_io_desc, ARRAY_SIZE(g3evm_io_desc));
+
+	/* setup early devices and clocks here as well */
+	sh7367_add_early_devices();
+	sh7367_clock_init();
+}
+
+static void __init g3evm_init(void)
+{
+	sh7367_add_standard_devices();
+
+	platform_add_devices(g3evm_devices, ARRAY_SIZE(g3evm_devices));
+}
+
+MACHINE_START(G3EVM, "g3evm")
+	.phys_io	= 0xe6000000,
+	.io_pg_offst	= ((0xe6000000) >> 18) & 0xfffc,
+	.map_io		= g3evm_map_io,
+	.init_irq	= sh7367_init_irq,
+	.init_machine	= g3evm_init,
+	.timer		= &shmobile_timer,
+MACHINE_END
--- /dev/null
+++ work/arch/arm/mach-shmobile/clock-sh7367.c	2010-01-21 19:49:08.000000000 +0900
@@ -0,0 +1,89 @@
+/*
+ * Preliminary clock framework support for sh7367
+ *
+ * Copyright (C) 2010  Magnus Damm
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/clk.h>
+
+struct clk {
+	const char *name;
+	unsigned long rate;
+};
+
+#include <asm/clkdev.h>
+
+int __clk_get(struct clk *clk)
+{
+	return 1;
+}
+EXPORT_SYMBOL(__clk_get);
+
+void __clk_put(struct clk *clk)
+{
+}
+EXPORT_SYMBOL(__clk_put);
+
+
+int clk_enable(struct clk *clk)
+{
+	return 0;
+}
+EXPORT_SYMBOL(clk_enable);
+
+void clk_disable(struct clk *clk)
+{
+}
+EXPORT_SYMBOL(clk_disable);
+
+unsigned long clk_get_rate(struct clk *clk)
+{
+	return clk ? clk->rate : 0;
+}
+EXPORT_SYMBOL(clk_get_rate);
+
+/* a static peripheral clock for now - enough to get sh-sci working */
+static struct clk peripheral_clk = {
+	.name	    = "peripheral_clk",
+	.rate	    = 48000000,
+};
+
+/* a static rclk for now - enough to get sh_cmt working */
+static struct clk r_clk = {
+	.name	    = "r_clk",
+	.rate	    = 32768,
+};
+
+static struct clk_lookup lookups[] = {
+	{
+		.clk = &peripheral_clk,
+	}, {
+		.clk = &r_clk,
+	}
+};
+
+void __init sh7367_clock_init(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(lookups); i++) {
+		lookups[i].con_id = lookups[i].clk->name;
+		clkdev_add(&lookups[i]);
+	}
+}
--- /dev/null
+++ work/arch/arm/mach-shmobile/include/mach/clkdev.h	2010-01-20 18:59:56.000000000 +0900
@@ -0,0 +1,7 @@
+#ifndef __ASM_MACH_CLKDEV_H
+#define __ASM_MACH_CLKDEV_H
+
+int __clk_get(struct clk *clk);
+void __clk_put(struct clk *clk);
+
+#endif /* __ASM_MACH_CLKDEV_H */
--- /dev/null
+++ work/arch/arm/mach-shmobile/include/mach/common.h	2010-01-20 18:59:56.000000000 +0900
@@ -0,0 +1,11 @@
+#ifndef __ARCH_MACH_COMMON_H
+#define __ARCH_MACH_COMMON_H
+
+extern struct sys_timer shmobile_timer;
+
+extern void sh7367_init_irq(void);
+extern void sh7367_add_early_devices(void);
+extern void sh7367_add_standard_devices(void);
+extern void sh7367_clock_init(void);
+
+#endif /* __ARCH_MACH_COMMON_H */
--- /dev/null
+++ work/arch/arm/mach-shmobile/include/mach/dma.h	2010-01-20 18:59:56.000000000 +0900
@@ -0,0 +1 @@
+/* empty */
--- /dev/null
+++ work/arch/arm/mach-shmobile/include/mach/entry-macro.S	2010-01-20 18:59:56.000000000 +0900
@@ -0,0 +1,39 @@
+/*
+ * Copyright (C) 2008 Renesas Solutions Corp.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include <mach/hardware.h>
+#include <mach/irqs.h>
+
+	.macro  disable_fiq
+	.endm
+
+	.macro  get_irqnr_preamble, base, tmp
+	.endm
+
+	.macro  arch_ret_to_user, tmp1, tmp2
+	.endm
+
+	.macro  get_irqnr_and_base, irqnr, irqstat, base, tmp
+	ldr     \base, =INTFLGA
+	ldr     \irqnr, [\base]
+	cmp	\irqnr, #0
+	beq	1000f
+	/* intevt to irq number */
+	lsr	\irqnr, \irqnr, #0x5
+	subs	\irqnr, \irqnr, #16
+
+1000:
+	.endm
--- /dev/null
+++ work/arch/arm/mach-shmobile/include/mach/gpio.h	2010-01-20 18:59:56.000000000 +0900
@@ -0,0 +1 @@
+/* empty */
--- /dev/null
+++ work/arch/arm/mach-shmobile/include/mach/hardware.h	2010-01-20 18:59:56.000000000 +0900
@@ -0,0 +1,7 @@
+#ifndef __ASM_MACH_HARDWARE_H
+#define __ASM_MACH_HARDWARE_H
+
+/* INTFLGA register - used by low level interrupt code in entry-macro.S */
+#define INTFLGA			0xe6980018
+
+#endif /* __ASM_MACH_HARDWARE_H */
--- /dev/null
+++ work/arch/arm/mach-shmobile/include/mach/io.h	2010-01-20 18:59:56.000000000 +0900
@@ -0,0 +1,9 @@
+#ifndef __ASM_MACH_IO_H
+#define __ASM_MACH_IO_H
+
+#define IO_SPACE_LIMIT		0xffffffff
+
+#define __io(a)			((void __iomem *)(a))
+#define __mem_pci(a)		(a)
+
+#endif /* __ASM_MACH_IO_H */
--- /dev/null
+++ work/arch/arm/mach-shmobile/include/mach/irqs.h	2010-01-21 19:48:34.000000000 +0900
@@ -0,0 +1,10 @@
+#ifndef __ASM_MACH_IRQS_H
+#define __ASM_MACH_IRQS_H
+
+#define NR_IRQS         512
+#define NR_IRQS_LEGACY  8
+
+#define evt2irq(evt)		(((evt) >> 5) - 16)
+#define irq2evt(irq)		(((irq) + 16) << 5)
+
+#endif /* __ASM_MACH_IRQS_H */
--- /dev/null
+++ work/arch/arm/mach-shmobile/include/mach/memory.h	2010-01-20 18:59:56.000000000 +0900
@@ -0,0 +1,7 @@
+#ifndef __ASM_MACH_MEMORY_H
+#define __ASM_MACH_MEMORY_H
+
+#define PHYS_OFFSET	UL(CONFIG_MEMORY_START)
+#define MEM_SIZE	UL(CONFIG_MEMORY_SIZE)
+
+#endif /* __ASM_MACH_MEMORY_H */
--- /dev/null
+++ work/arch/arm/mach-shmobile/include/mach/system.h	2010-01-20 18:59:56.000000000 +0900
@@ -0,0 +1,14 @@
+#ifndef __ASM_ARCH_SYSTEM_H
+#define __ASM_ARCH_SYSTEM_H
+
+static inline void arch_idle(void)
+{
+	cpu_do_idle();
+}
+
+static inline void arch_reset(char mode, const char *cmd)
+{
+	cpu_reset(0);
+}
+
+#endif
--- /dev/null
+++ work/arch/arm/mach-shmobile/include/mach/timex.h	2010-01-20 18:59:56.000000000 +0900
@@ -0,0 +1,6 @@
+#ifndef __ASM_MACH_TIMEX_H
+#define __ASM_MACH_TIMEX_H
+
+#define CLOCK_TICK_RATE		1193180 /* unused i8253 PIT value */
+
+#endif /* __ASM_MACH_TIMEX_H */
--- /dev/null
+++ work/arch/arm/mach-shmobile/include/mach/uncompress.h	2010-01-20 18:59:56.000000000 +0900
@@ -0,0 +1,21 @@
+#ifndef __ASM_MACH_UNCOMPRESS_H
+#define __ASM_MACH_UNCOMPRESS_H
+
+/*
+ * This does not append a newline
+ */
+static void putc(int c)
+{
+}
+
+static inline void flush(void)
+{
+}
+
+static void arch_decomp_setup(void)
+{
+}
+
+#define arch_decomp_wdog()
+
+#endif /* __ASM_MACH_UNCOMPRESS_H */
--- /dev/null
+++ work/arch/arm/mach-shmobile/include/mach/vmalloc.h	2010-01-20 18:59:56.000000000 +0900
@@ -0,0 +1,6 @@
+#ifndef __ASM_MACH_VMALLOC_H
+#define __ASM_MACH_VMALLOC_H
+
+#define VMALLOC_END       (PAGE_OFFSET + 0x24000000)
+
+#endif /* __ASM_MACH_VMALLOC_H */
--- /dev/null
+++ work/arch/arm/mach-shmobile/setup-sh7367.c	2010-01-20 18:59:56.000000000 +0900
@@ -0,0 +1,241 @@
+/*
+ * sh7367 processor support
+ *
+ * Copyright (C) 2010  Magnus Damm
+ * Copyright (C) 2008  Yoshihiro Shimoda
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/platform_device.h>
+#include <linux/delay.h>
+#include <linux/input.h>
+#include <linux/io.h>
+#include <linux/serial_sci.h>
+#include <linux/sh_intc.h>
+#include <linux/sh_timer.h>
+#include <mach/hardware.h>
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+
+static struct plat_sci_port scif0_platform_data = {
+	.mapbase	= 0xe6c40000,
+	.flags		= UPF_BOOT_AUTOCONF | UPF_IOREMAP,
+	.type		= PORT_SCIF,
+	.irqs		= { 80, 80, 80, 80 },
+};
+
+static struct platform_device scif0_device = {
+	.name		= "sh-sci",
+	.id		= 0,
+	.dev		= {
+		.platform_data	= &scif0_platform_data,
+	},
+};
+
+static struct plat_sci_port scif1_platform_data = {
+	.mapbase	= 0xe6c50000,
+	.flags		= UPF_BOOT_AUTOCONF | UPF_IOREMAP,
+	.type		= PORT_SCIF,
+	.irqs           = { 81, 81, 81, 81 },
+};
+
+static struct platform_device scif1_device = {
+	.name		= "sh-sci",
+	.id		= 1,
+	.dev		= {
+		.platform_data	= &scif1_platform_data,
+	},
+};
+
+static struct plat_sci_port scif2_platform_data = {
+	.mapbase	= 0xe6c60000,
+	.flags		= UPF_BOOT_AUTOCONF | UPF_IOREMAP,
+	.type		= PORT_SCIF,
+	.irqs           = { 82, 82, 82, 82 },
+};
+
+static struct platform_device scif2_device = {
+	.name		= "sh-sci",
+	.id		= 2,
+	.dev		= {
+		.platform_data	= &scif2_platform_data,
+	},
+};
+
+static struct plat_sci_port scif3_platform_data = {
+	.mapbase	= 0xe6c70000,
+	.flags		= UPF_BOOT_AUTOCONF | UPF_IOREMAP,
+	.type		= PORT_SCIF,
+	.irqs           = { 83, 83, 83, 83 },
+};
+
+static struct platform_device scif3_device = {
+	.name		= "sh-sci",
+	.id		= 3,
+	.dev		= {
+		.platform_data	= &scif3_platform_data,
+	},
+};
+
+static struct plat_sci_port scif4_platform_data = {
+	.mapbase	= 0xe6c80000,
+	.flags		= UPF_BOOT_AUTOCONF | UPF_IOREMAP,
+	.type		= PORT_SCIF,
+	.irqs           = { 89, 89, 89, 89 },
+};
+
+static struct platform_device scif4_device = {
+	.name		= "sh-sci",
+	.id		= 4,
+	.dev		= {
+		.platform_data	= &scif4_platform_data,
+	},
+};
+
+static struct plat_sci_port scif5_platform_data = {
+	.mapbase	= 0xe6cb0000,
+	.flags		= UPF_BOOT_AUTOCONF | UPF_IOREMAP,
+	.type		= PORT_SCIF,
+	.irqs           = { 90, 90, 90, 90 },
+};
+
+static struct platform_device scif5_device = {
+	.name		= "sh-sci",
+	.id		= 5,
+	.dev		= {
+		.platform_data	= &scif5_platform_data,
+	},
+};
+
+static struct plat_sci_port scif6_platform_data = {
+	.mapbase	= 0xe6c30000,
+	.flags		= UPF_BOOT_AUTOCONF | UPF_IOREMAP,
+	.type		= PORT_SCIF,
+	.irqs           = { 91, 91, 91, 91 },
+};
+
+static struct platform_device scif6_device = {
+	.name		= "sh-sci",
+	.id		= 6,
+	.dev		= {
+		.platform_data	= &scif6_platform_data,
+	},
+};
+
+static struct sh_timer_config cmt10_platform_data = {
+	.name = "CMT10",
+	.channel_offset = 0x10,
+	.timer_bit = 0,
+	.clk = "r_clk",
+	.clockevent_rating = 125,
+	.clocksource_rating = 125,
+};
+
+static struct resource cmt10_resources[] = {
+	[0] = {
+		.name	= "CMT10",
+		.start	= 0xe6138010,
+		.end	= 0xe613801b,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= 72,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device cmt10_device = {
+	.name		= "sh_cmt",
+	.id		= 10,
+	.dev = {
+		.platform_data	= &cmt10_platform_data,
+	},
+	.resource	= cmt10_resources,
+	.num_resources	= ARRAY_SIZE(cmt10_resources),
+};
+
+static struct platform_device *sh7367_early_devices[] __initdata = {
+	&scif0_device,
+	&scif1_device,
+	&scif2_device,
+	&scif3_device,
+	&scif4_device,
+	&scif5_device,
+	&scif6_device,
+	&cmt10_device,
+};
+
+void __init sh7367_add_standard_devices(void)
+{
+	platform_add_devices(sh7367_early_devices,
+			     ARRAY_SIZE(sh7367_early_devices));
+}
+
+#define SYMSTPCR2 0xe6158048
+#define SYMSTPCR2_CMT1 (1 << 29)
+
+void __init sh7367_add_early_devices(void)
+{
+	/* enable clock to CMT1 */
+	__raw_writel(__raw_readl(SYMSTPCR2) & ~SYMSTPCR2_CMT1, SYMSTPCR2);
+
+	early_platform_add_devices(sh7367_early_devices,
+				   ARRAY_SIZE(sh7367_early_devices));
+}
+
+enum {
+	UNUSED = 0,
+
+	/* interrupt sources INTCA */
+
+	SCIFA0, SCIFA1, SCIFA2, SCIFA3, SCIFA4, SCIFA5, SCIFB,
+	CMT10,
+};
+
+static struct intc_vect vectors[] = {
+	INTC_VECT(CMT10, 0xb00),
+	INTC_VECT(SCIFA0, 0xc00), INTC_VECT(SCIFA1, 0xc20),
+	INTC_VECT(SCIFA2, 0xc40), INTC_VECT(SCIFA3, 0xc60),
+	INTC_VECT(SCIFA4, 0xd20), INTC_VECT(SCIFA5, 0xd40),
+	INTC_VECT(SCIFB, 0xd60),
+};
+
+static struct intc_mask_reg mask_registers[] = {
+	{ 0xe6940094, 0xe69400d4, 8, /* IMR5A / IMCR5A */
+	  { 0, 0, 0, 0, SCIFA3, SCIFA2, SCIFA1, SCIFA0 } },
+	{ 0xe6940098, 0xe69400d8, 8, /* IMR6A / IMCR6A */
+	  { SCIFB, SCIFA5, SCIFA4, 0, 0, 0, 0, 0 } },
+	{ 0xe69400a4, 0xe69400e4, 8, /* IMR9A / IMCR9A */
+	  { 0, 0, 0, CMT10, 0, 0, 0, 0 } },
+};
+
+static struct intc_prio_reg prio_registers[] = {
+	{ 0xe6940014, 0, 16, 4, /* IPRFA */ { 0, 0, 0, CMT10 } },
+	{ 0xe6940018, 0, 16, 4, /* IPRGA */ { SCIFA0, SCIFA1,
+					      SCIFA2, SCIFA3 } },
+	{ 0xe6940020, 0, 16, 4, /* IPRIA */ { 0, SCIFA4, 0, 0 } },
+	{ 0xe6940034, 0, 16, 4, /* IPRNA */ { SCIFB, SCIFA5, 0, 0 } },
+};
+
+static DECLARE_INTC_DESC(intc_desc, "sh7367", vectors, NULL, mask_registers,
+			 prio_registers, NULL);
+
+void __init sh7367_init_irq(void)
+{
+	register_intc_controller(&intc_desc);
+}
--- /dev/null
+++ work/arch/arm/mach-shmobile/timer.c	2010-01-20 18:59:56.000000000 +0900
@@ -0,0 +1,46 @@
+/*
+ * SH-Mobile Timer
+ *
+ * Copyright (C) 2010  Magnus Damm
+ * Copyright (C) 2002 - 2009  Paul Mundt
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ */
+#include <linux/platform_device.h>
+#include <asm/mach/time.h>
+
+static void __init shmobile_late_time_init(void)
+{
+	/*
+	 * Make sure all compiled-in early timers register themselves.
+	 *
+	 * Run probe() for two "earlytimer" devices, these will be the
+	 * clockevents and clocksource devices respectively. In the event
+	 * that only a clockevents device is available, we -ENODEV on the
+	 * clocksource and the jiffies clocksource is used transparently
+	 * instead. No error handling is necessary here.
+	 */
+	early_platform_driver_register_all("earlytimer");
+	early_platform_driver_probe("earlytimer", 2, 0);
+}
+
+static void __init shmobile_timer_init(void)
+{
+	late_time_init = shmobile_late_time_init;
+}
+
+struct sys_timer shmobile_timer = {
+	.init		= shmobile_timer_init,
+};
