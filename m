Return-Path: <linux-kernel-owner+w=401wt.eu-S1757382AbZFZXa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382AbZFZXa3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 19:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbZFZXaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 19:30:15 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:4410 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757386AbZFZX3z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 19:29:55 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
From: "Leo (Hao) Chen" <leochen@broadcom.com>
To: "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
cc: "Leo (Hao) Chen" <leochen@broadcom.com>
Date: Fri, 26 Jun 2009 16:29:44 -0700
Subject: [PATCH v1 3/6][ARM]  new ARM SoC support: BCMRing
Thread-Topic: [PATCH v1 3/6][ARM]  new ARM SoC support: BCMRing
Thread-Index: Acn2tfxVk2ALMwQdTG+huTFyxAFtJQ==
Message-ID: <8628FE4E7912BF47A96AE7DD7BAC0AADCB25AE17C5@SJEXCHCCR02.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 665B86680EG7108836-02-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the third patch.  This big patch contains the core arch code in arch/arm/mach-bcmring directory.
Header files in arch/arm/mach-bcmring/include/mach are included as well.

>From 8c38c714343f1cc203c55db8fd28505b1ec4f914 Mon Sep 17 00:00:00 2001
From: Leo Chen <leochen@broadcom.com>
Date: Fri, 26 Jun 2009 15:46:41 -0700
Subject: [PATCH 3/6] add bcmring arch core code and header files

---
 arch/arm/mach-bcmring/Kconfig                      |   40 +
 arch/arm/mach-bcmring/Makefile                     |   10 +
 arch/arm/mach-bcmring/Makefile.boot                |    6 +
 arch/arm/mach-bcmring/arch.c                       |  184 ++
 arch/arm/mach-bcmring/clock.c                      |  229 ++
 arch/arm/mach-bcmring/clock.h                      |   33 +
 arch/arm/mach-bcmring/core.c                       |  358 +++
 arch/arm/mach-bcmring/core.h                       |   75 +
 arch/arm/mach-bcmring/dma.c                        | 3022 ++++++++++++++++++++
 arch/arm/mach-bcmring/early_printk.c               |  105 +
 arch/arm/mach-bcmring/include/cfg_global.h         |   16 +
 arch/arm/mach-bcmring/include/cfg_global_defines.h |   54 +
 arch/arm/mach-bcmring/include/mach/clkdev.h        |    7 +
 arch/arm/mach-bcmring/include/mach/dma.h           |  894 ++++++
 arch/arm/mach-bcmring/include/mach/entry-macro.S   |   94 +
 arch/arm/mach-bcmring/include/mach/hardware.h      |   65 +
 arch/arm/mach-bcmring/include/mach/io.h            |   61 +
 arch/arm/mach-bcmring/include/mach/irqs.h          |  139 +
 arch/arm/mach-bcmring/include/mach/memory.h        |   47 +
 .../mach-bcmring/include/mach/memory_settings.h    |   69 +
 arch/arm/mach-bcmring/include/mach/reg_nand.h      |   65 +
 arch/arm/mach-bcmring/include/mach/reg_umi.h       |  149 +
 arch/arm/mach-bcmring/include/mach/system.h        |   75 +
 arch/arm/mach-bcmring/include/mach/timer.h         |   87 +
 arch/arm/mach-bcmring/include/mach/timex.h         |   25 +
 arch/arm/mach-bcmring/include/mach/uncompress.h    |   53 +
 arch/arm/mach-bcmring/include/mach/vmalloc.h       |   32 +
 arch/arm/mach-bcmring/irq.c                        |  154 +
 arch/arm/mach-bcmring/mm.c                         |  102 +
 arch/arm/mach-bcmring/timer.c                      |   66 +
 30 files changed, 6316 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-bcmring/Kconfig
 create mode 100644 arch/arm/mach-bcmring/Makefile
 create mode 100644 arch/arm/mach-bcmring/Makefile.boot
 create mode 100644 arch/arm/mach-bcmring/arch.c
 create mode 100644 arch/arm/mach-bcmring/clock.c
 create mode 100644 arch/arm/mach-bcmring/clock.h
 create mode 100644 arch/arm/mach-bcmring/core.c
 create mode 100644 arch/arm/mach-bcmring/core.h
 create mode 100644 arch/arm/mach-bcmring/dma.c
 create mode 100644 arch/arm/mach-bcmring/early_printk.c
 create mode 100644 arch/arm/mach-bcmring/include/cfg_global.h
 create mode 100644 arch/arm/mach-bcmring/include/cfg_global_defines.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/clkdev.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/dma.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/entry-macro.S
 create mode 100644 arch/arm/mach-bcmring/include/mach/hardware.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/io.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/irqs.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/memory.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/memory_settings.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/reg_nand.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/reg_umi.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/system.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/timer.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/timex.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/vmalloc.h
 create mode 100644 arch/arm/mach-bcmring/irq.c
 create mode 100644 arch/arm/mach-bcmring/mm.c
 create mode 100644 arch/arm/mach-bcmring/timer.c

diff --git a/arch/arm/mach-bcmring/Kconfig b/arch/arm/mach-bcmring/Kconfig
new file mode 100644
index 0000000..45053c8
--- /dev/null
+++ b/arch/arm/mach-bcmring/Kconfig
@@ -0,0 +1,40 @@
+choice
+       prompt "Processor selection in BCMRING family of devices"
+       depends on ARCH_BCMRING
+       default ARCH_BCM11107
+
+config ARCH_FPGA11107
+       bool "FPGA11107"
+
+config ARCH_BCM11107
+       bool "BCM11107"
+endchoice
+
+menu "BCMRING Options"
+       depends on ARCH_BCMRING
+
+config BCM_ZRELADDR
+       hex "Compressed ZREL ADDR"
+
+config BCM_EARLY_PRINTK
+       bool "Enable early console printk"
+       default n
+       help
+               Enable console printk very early in boot process.
+
+choice
+       prompt "Serial port for early printk and jtag"
+               depends on BCM_EARLY_PRINTK || BCM_DEBUG_PAUSE_JTAG
+               default BCM_EARLY_CONSOLE_UARTA
+
+config BCM_EARLY_CONSOLE_UARTA
+       bool "UART A - Early Console"
+
+config BCM_EARLY_CONSOLE_UARTB
+       bool "UART B - Early Console"
+
+endchoice
+
+endmenu
+
+# source "drivers/char/bcmring/Kconfig"
diff --git a/arch/arm/mach-bcmring/Makefile b/arch/arm/mach-bcmring/Makefile
new file mode 100644
index 0000000..853f6a5
--- /dev/null
+++ b/arch/arm/mach-bcmring/Makefile
@@ -0,0 +1,10 @@
+#
+# Makefile for the linux kernel.
+#
+
+# Object file lists.
+
+obj-y := arch.o mm.o irq.o clock.o core.o timer.o dma.o
+obj-y += csp/
+
+obj-$(CONFIG_BCM_EARLY_PRINTK)  += early_printk.o
diff --git a/arch/arm/mach-bcmring/Makefile.boot b/arch/arm/mach-bcmring/Makefile.boot
new file mode 100644
index 0000000..fb53b28
--- /dev/null
+++ b/arch/arm/mach-bcmring/Makefile.boot
@@ -0,0 +1,6 @@
+# Address where decompressor will be written and eventually executed.
+#
+# default to SDRAM
+zreladdr-y      := $(CONFIG_BCM_ZRELADDR)
+params_phys-y   := 0x00000800
+
diff --git a/arch/arm/mach-bcmring/arch.c b/arch/arm/mach-bcmring/arch.c
new file mode 100644
index 0000000..ed4beb0
--- /dev/null
+++ b/arch/arm/mach-bcmring/arch.c
@@ -0,0 +1,184 @@
+/*****************************************************************************
+* Copyright 2003 - 2008 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/version.h>
+#include <linux/types.h>
+#include <linux/sched.h>
+#include <linux/interrupt.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/spinlock.h>
+#include <linux/module.h>
+
+#include <linux/proc_fs.h>
+#include <linux/sysctl.h>
+
+#include <asm/irq.h>
+#include <asm/setup.h>
+#include <asm/mach-types.h>
+#include <asm/mach/time.h>
+
+#include <asm/mach/arch.h>
+#include <mach/dma.h>
+#include <mach/hardware.h>
+#include <mach/csp/mm_io.h>
+#include <mach/csp/chipcHw_def.h>
+#include <mach/csp/chipcHw_inline.h>
+
+#include <cfg_global.h>
+
+#include "core.h"
+
+HW_DECLARE_SPINLOCK(Arch)
+HW_DECLARE_SPINLOCK(Gpio)
+
+#if defined( CONFIG_DEBUG_SPINLOCK )
+EXPORT_SYMBOL(gGpioRegLock);
+#endif
+
+/* FIXME: temporary solution */
+#define BCM_SYSCTL_REBOOT_WARM               1
+#define CTL_BCM_REBOOT                 112
+
+/* sysctl */
+int gArchWarmReboot = 0; // do a warm reboot on hard reset
+
+static struct ctl_table_header *gSysCtlHeader;
+
+static struct ctl_table gSysCtlReboot[] = {
+   {
+      .ctl_name      = BCM_SYSCTL_REBOOT_WARM,
+      .procname      = "warm",
+      .data          = &gArchWarmReboot,
+      .maxlen        = sizeof( int ),
+      .mode          = 0644,
+      .proc_handler  = &proc_dointvec
+   },
+   {}
+};
+static struct ctl_table gSysCtl[] = {
+   {
+      .ctl_name      = CTL_BCM_REBOOT,
+      .procname      = "reboot",
+      .mode          = 0555,
+      .child         = gSysCtlReboot
+   },
+   {}
+};
+
+extern void bcmring_map_io(void);
+extern void bcmring_init_irq(void);
+extern void bcmring_init_timer(void);
+
+static struct platform_device nand_device = {
+   .name = "bcm-nand",
+   .id = -1,
+};
+
+static struct platform_device *devices[] __initdata =
+{
+   &nand_device,
+};
+
+/****************************************************************************
+*
+*   Called from the customize_machine function in arch/arm/kernel/setup.c
+*
+*   The customize_machine function is tagged as an arch_initcall
+*   (see include/linux/init.h for the order that the various init sections
+*   are called in.
+*
+*****************************************************************************/
+static void __init bcmring_init_machine( void )
+{
+
+   gSysCtlHeader = register_sysctl_table(gSysCtl);
+
+   /* Enable spread spectrum */
+   chipcHw_enableSpreadSpectrum ( );
+
+   platform_add_devices(devices, ARRAY_SIZE(devices));
+
+   bcmring_amba_init();
+
+   dma_init();
+}
+
+/****************************************************************************
+*
+*   Called from setup_arch (in arch/arm/kernel/setup.c) to fixup any tags
+*   passed in by the boot loader.
+*
+*****************************************************************************/
+
+static void __init bcmring_fixup
+(
+    struct machine_desc *desc,
+    struct tag *t,
+    char **cmdline,
+    struct meminfo *mi
+)
+{
+#ifdef CONFIG_BLK_DEV_INITRD
+   printk(KERN_NOTICE "bcmring_fixup\n");
+   t->hdr.tag = ATAG_CORE;
+   t->hdr.size = tag_size(tag_core);
+   t->u.core.flags = 0;
+   t->u.core.pagesize = PAGE_SIZE;
+   t->u.core.rootdev = 31 << 8 | 0;
+   t = tag_next(t);
+
+   t->hdr.tag = ATAG_MEM;
+   t->hdr.size = tag_size(tag_mem32);
+   t->u.mem.start = CFG_GLOBAL_RAM_BASE;
+   t->u.mem.size = CFG_GLOBAL_RAM_SIZE;
+
+   t = tag_next(t);
+
+   t->hdr.tag = ATAG_NONE;
+   t->hdr.size = 0;
+#endif
+}
+
+/****************************************************************************
+*
+*   Timer related information. bcmring_init_timer is called from
+*   time_init (in arch/arm/kernel/time.c).
+*
+*****************************************************************************/
+
+static struct sys_timer bcmring_timer =
+{
+    .init       = bcmring_init_timer,
+};
+
+/****************************************************************************
+*
+*   Machine Description
+*
+*****************************************************************************/
+
+MACHINE_START(BCMRING, "BCMRING")
+   /* Maintainer: Broadcom Corporation */
+   .phys_io = IO_START,
+   .io_pg_offst = (IO_BASE >> 18) & 0xfffc,
+   .fixup = bcmring_fixup,
+   .map_io = bcmring_map_io,
+   .init_irq = bcmring_init_irq,
+   .timer  = &bcmring_timer,
+   .init_machine = bcmring_init_machine
+MACHINE_END
+
diff --git a/arch/arm/mach-bcmring/clock.c b/arch/arm/mach-bcmring/clock.c
new file mode 100644
index 0000000..924d47d
--- /dev/null
+++ b/arch/arm/mach-bcmring/clock.c
@@ -0,0 +1,229 @@
+/*****************************************************************************
+* Copyright 2001 - 2009 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/list.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/string.h>
+#include <linux/clk.h>
+#include <linux/spinlock.h>
+#include <mach/csp/hw_cfg.h>
+#include <mach/csp/chipcHw_def.h>
+#include <mach/csp/chipcHw_reg.h>
+#include <mach/csp/chipcHw_inline.h>
+
+#include <asm/clkdev.h>
+
+#include "clock.h"
+
+#define MIN(a, b)               ((a) < (b) ? (a) : (b))
+#define clk_is_primary(x)       ((x)->type & CLK_TYPE_PRIMARY)
+#define clk_is_pll1(x)          ((x)->type & CLK_TYPE_PLL1)
+#define clk_is_pll2(x)          ((x)->type & CLK_TYPE_PLL2)
+#define clk_is_programmable(x)  ((x)->type & CLK_TYPE_PROGRAMMABLE)
+#define clk_is_bypassable(x)    ((x)->type & CLK_TYPE_BYPASSABLE)
+
+#define clk_is_using_xtal(x)    ((x)->mode & CLK_MODE_XTAL)
+
+static DEFINE_SPINLOCK(clk_lock);
+
+static void __clk_enable(struct clk *clk)
+{
+   if (!clk)
+      return;
+
+   /* enable parent clock first */
+   if (clk->parent)
+      __clk_enable(clk->parent);
+
+   if (clk->use_cnt++ == 0) {
+      if (clk_is_pll1(clk)) { /* PLL1 */
+         chipcHw_pll1Enable(clk->rate_hz, 0);
+      } else if (clk_is_pll2(clk)) { /* PLL2 */
+         chipcHw_pll2Enable(clk->rate_hz);
+      } else if (clk_is_using_xtal(clk)) { /* source is crystal */
+         if (!clk_is_primary(clk)) {
+            chipcHw_bypassClockEnable(clk->csp_id);
+         }
+      } else { /* source is PLL */
+         chipcHw_setClockEnable(clk->csp_id);
+      }
+   }
+}
+
+int clk_enable(struct clk *clk)
+{
+   unsigned long flags;
+
+   if (!clk)
+      return -EINVAL;
+
+   spin_lock_irqsave(&clk_lock, flags);
+   __clk_enable(clk);
+   spin_unlock_irqrestore(&clk_lock, flags);
+
+       return 0;
+}
+EXPORT_SYMBOL(clk_enable);
+
+static void __clk_disable(struct clk *clk)
+{
+   if (!clk)
+      return;
+
+   BUG_ON(clk->use_cnt == 0);
+
+   if (--clk->use_cnt == 0) {
+      if (clk_is_pll1(clk)) { /* PLL1 */
+         chipcHw_pll1Disable();
+      } else if (clk_is_pll2(clk)) { /* PLL2 */
+         chipcHw_pll2Disable();
+      } else if (clk_is_using_xtal(clk)) { /* source is crystal */
+         if (!clk_is_primary(clk)) {
+            chipcHw_bypassClockDisable(clk->csp_id);
+         }
+      } else { /* source is PLL */
+         chipcHw_setClockDisable(clk->csp_id);
+      }
+   }
+
+   if (clk->parent)
+      __clk_disable(clk->parent);
+}
+
+void clk_disable(struct clk *clk)
+{
+   unsigned long flags;
+
+   if (!clk)
+      return;
+
+   spin_lock_irqsave(&clk_lock, flags);
+   __clk_disable(clk);
+   spin_unlock_irqrestore(&clk_lock, flags);
+}
+EXPORT_SYMBOL(clk_disable);
+
+unsigned long clk_get_rate(struct clk *clk)
+{
+   if (!clk)
+      return 0;
+
+       return clk->rate_hz;
+}
+EXPORT_SYMBOL(clk_get_rate);
+
+long clk_round_rate(struct clk *clk, unsigned long rate)
+{
+   unsigned long flags;
+   unsigned long actual;
+   unsigned long rate_hz;
+
+   if (!clk)
+      return -EINVAL;
+
+   if (!clk_is_programmable(clk))
+      return -EINVAL;
+
+   if (clk->use_cnt)
+      return -EBUSY;
+
+   spin_lock_irqsave(&clk_lock, flags);
+   actual = clk->parent->rate_hz;
+   rate_hz = MIN(actual, rate);
+   rate_hz = chipcHw_setClockFrequency(clk->csp_id, rate_hz);
+   clk->rate_hz = rate_hz;
+   spin_unlock_irqrestore(&clk_lock, flags);
+
+   return rate_hz;
+}
+EXPORT_SYMBOL(clk_round_rate);
+
+int clk_set_rate(struct clk *clk, unsigned long rate)
+{
+   unsigned long flags;
+   unsigned long actual;
+   unsigned long rate_hz;
+
+   if (!clk)
+      return -EINVAL;
+
+   if (!clk_is_programmable(clk))
+      return -EINVAL;
+
+   if (clk->use_cnt)
+      return -EBUSY;
+
+   spin_lock_irqsave(&clk_lock, flags);
+   actual = clk->parent->rate_hz;
+   rate_hz = MIN(actual, rate);
+   rate_hz = chipcHw_setClockFrequency(clk->csp_id, rate_hz);
+   clk->rate_hz = rate_hz;
+   spin_unlock_irqrestore(&clk_lock, flags);
+
+   return 0;
+}
+EXPORT_SYMBOL(clk_set_rate);
+
+struct clk *clk_get_parent(struct clk *clk)
+{
+   if (!clk)
+      return NULL;
+
+   return clk->parent;
+}
+EXPORT_SYMBOL(clk_get_parent);
+
+int clk_set_parent(struct clk *clk, struct clk *parent)
+{
+   unsigned long flags;
+   struct clk *old_parent;
+
+   if (!clk || !parent)
+      return -EINVAL;
+
+   if (!clk_is_primary(parent) || !clk_is_bypassable(clk))
+      return -EINVAL;
+
+   /* if more than one user, parent is not allowed */
+   if (clk->use_cnt > 1)
+      return -EBUSY;
+
+   if (clk->parent == parent)
+      return 0;
+
+   spin_lock_irqsave(&clk_lock, flags);
+   old_parent = clk->parent;
+   clk->parent = parent;
+   if (clk_is_using_xtal(parent))
+      clk->mode |= CLK_MODE_XTAL;
+   else
+      clk->mode &= (~CLK_MODE_XTAL);
+
+   /* if clock is active */
+   if (clk->use_cnt != 0) {
+      clk->use_cnt--;
+      /* enable clock with the new parent */
+      __clk_enable(clk);
+      /* disable the old parent */
+      __clk_disable(old_parent);
+   }
+   spin_unlock_irqrestore(&clk_lock, flags);
+
+   return 0;
+}
+EXPORT_SYMBOL(clk_set_parent);
diff --git a/arch/arm/mach-bcmring/clock.h b/arch/arm/mach-bcmring/clock.h
new file mode 100644
index 0000000..7280774
--- /dev/null
+++ b/arch/arm/mach-bcmring/clock.h
@@ -0,0 +1,33 @@
+/*****************************************************************************
+* Copyright 2001 - 2009 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+#include <mach/csp/chipcHw_def.h>
+
+#define CLK_TYPE_PRIMARY         1 /* primary clock must NOT have a parent */
+#define CLK_TYPE_PLL1            2 /* PPL1 */
+#define CLK_TYPE_PLL2            4 /* PPL2 */
+#define CLK_TYPE_PROGRAMMABLE    8 /* programmable clock rate */
+#define CLK_TYPE_BYPASSABLE      16 /* parent can be changed */
+
+#define CLK_MODE_XTAL            1 /* clock source is from crystal */
+
+struct clk {
+   const char *name; /* clock name */
+   unsigned int type; /* clock type */
+   unsigned int mode; /* current mode */
+   volatile int use_bypass; /* indicate if it's in bypass mode */
+   chipcHw_CLOCK_e csp_id; /* clock ID for CSP CHIPC */
+   unsigned long rate_hz; /* clock rate in Hz */
+   unsigned int use_cnt; /* usage count */
+   struct clk *parent; /* parent clock */
+};
diff --git a/arch/arm/mach-bcmring/core.c b/arch/arm/mach-bcmring/core.c
new file mode 100644
index 0000000..c582409
--- /dev/null
+++ b/arch/arm/mach-bcmring/core.c
@@ -0,0 +1,358 @@
+/*
+ *  derived from linux/arch/arm/mach-versatile/core.c
+ *  linux/arch/arm/mach-bcmring/core.c
+ *
+ *  Copyright (C) 1999 - 2003 ARM Limited
+ *  Copyright (C) 2000 Deep Blue Solutions Ltd
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
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+/* Portions copyright Broadcom 2008 */
+
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
+#include <linux/platform_device.h>
+#include <linux/sysdev.h>
+#include <linux/interrupt.h>
+#include <linux/amba/bus.h>
+#include <linux/clocksource.h>
+#include <linux/clockchips.h>
+
+#include <mach/system.h>
+#include <mach/hardware.h>
+#include <asm/clkdev.h>
+#include <asm/io.h>
+#include <asm/irq.h>
+#include <asm/hardware/arm_timer.h>
+#include <asm/mach-types.h>
+
+#include <asm/mach/arch.h>
+#include <asm/mach/flash.h>
+#include <asm/mach/irq.h>
+#include <asm/mach/time.h>
+#include <asm/mach/map.h>
+#include <asm/mach/mmc.h>
+
+#include <cfg_global.h>
+
+#include "core.h"
+#include "clock.h"
+
+#include <csp/secHw.h>
+#include <mach/csp/secHw_def.h>
+#include <mach/csp/chipcHw_inline.h>
+#include <mach/csp/tmrHw_reg.h>
+
+/* DevChip Primecells */
+AMBA_DEVICE(uartA,   "dev:f1", UARTA,    NULL, SZ_4K);
+AMBA_DEVICE(uartB,   "dev:f2", UARTB,    NULL, SZ_4K);
+
+static struct clk pll1_clk = {
+   .name = "PLL1",
+   .type = CLK_TYPE_PRIMARY | CLK_TYPE_PLL1,
+   .rate_hz = 2000000000,
+   .use_cnt = 7,
+};
+
+static struct clk uart_clk = {
+   .name = "UART",
+   .type = CLK_TYPE_PROGRAMMABLE,
+   .csp_id = chipcHw_CLOCK_UART,
+   .rate_hz = HW_CFG_UART_CLK_HZ,
+   .parent = &pll1_clk,
+};
+
+static struct clk_lookup lookups[] = {
+       {       /* UART0 */
+               .dev_id         = "dev:f1",
+               .clk            = &uart_clk,
+       }, {    /* UART1 */
+               .dev_id         = "dev:f2",
+               .clk            = &uart_clk,
+   }
+};
+
+static struct amba_device *amba_devs[] __initdata = {
+       &uartA_device,
+       &uartB_device,
+};
+
+void __init bcmring_amba_init(void)
+{
+  int i;
+  u32 bus_clock;
+
+// Linux is run initially in non-secure mode. Secure peripherals
+// generate FIQ, and must be handled in secure mode. Until we have
+// a linux security monitor implementation, keep everything in
+// non-secure mode.
+   chipcHw_busInterfaceClockEnable(chipcHw_REG_BUS_CLOCK_SPU);
+   secHw_setUnsecure ( secHw_BLK_MASK_CHIP_CONTROL |
+                       secHw_BLK_MASK_KEY_SCAN     |
+                       secHw_BLK_MASK_TOUCH_SCREEN |
+                       secHw_BLK_MASK_UART0        |
+                       secHw_BLK_MASK_UART1        |
+                       secHw_BLK_MASK_WATCHDOG     |
+                       secHw_BLK_MASK_SPUM         |
+                       secHw_BLK_MASK_DDR2         |
+                       secHw_BLK_MASK_SPU          |
+                       secHw_BLK_MASK_PKA          |
+                       secHw_BLK_MASK_RNG          |
+                       secHw_BLK_MASK_RTC          |
+                       secHw_BLK_MASK_OTP          |
+                       secHw_BLK_MASK_BOOT         |
+                       secHw_BLK_MASK_MPU          |
+                       secHw_BLK_MASK_TZCTRL       |
+                       secHw_BLK_MASK_INTR );
+
+
+   // Only the devices attached to the AMBA bus are enabled just before the bus is
+   // scanned and the drivers are loaded. The clocks need to be on for the AMBA bus
+   // driver to access these blocks. The bus is probed, and the drivers are loaded.
+   // FIXME Need to remove enable of PIF once CLCD clock enable used properly in FPGA.
+   bus_clock =  chipcHw_REG_BUS_CLOCK_GE
+               | chipcHw_REG_BUS_CLOCK_SDIO0
+               | chipcHw_REG_BUS_CLOCK_SDIO1;
+
+
+   chipcHw_busInterfaceClockEnable ( bus_clock );
+
+   for (i = 0; i < ARRAY_SIZE(amba_devs); i++) {
+     struct amba_device *d = amba_devs[i];
+     amba_device_register(d, &iomem_resource);
+   }
+
+   for (i = 0; i < ARRAY_SIZE(lookups); i++)
+      clkdev_add(&lookups[i]);
+}
+
+/*
+ * Where is the timer (VA)?
+ */
+#define TIMER0_VA_BASE          MM_IO_BASE_TMR
+#define TIMER1_VA_BASE         (MM_IO_BASE_TMR + 0x20)
+#define TIMER2_VA_BASE         (MM_IO_BASE_TMR + 0x40)
+#define TIMER3_VA_BASE          (MM_IO_BASE_TMR + 0x60)
+
+// Timer 0 - 25 MHz, Timer3 at bus clock rate, typically  150-166 MHz
+#if defined(CONFIG_ARCH_FPGA11107)
+// fpga cpu/bus are currently 30 times slower so scale frequency as well to
+// slow down Linux's sense of time
+#define TIMER0_FREQUENCY_MHZ  (tmrHw_LOW_FREQUENCY_MHZ * 30)
+#define TIMER1_FREQUENCY_MHZ  (tmrHw_LOW_FREQUENCY_MHZ * 30)
+#define TIMER3_FREQUENCY_MHZ  (tmrHw_HIGH_FREQUENCY_MHZ * 30)
+#define TIMER3_FREQUENCY_KHZ   (tmrHw_HIGH_FREQUENCY_HZ / 1000 * 30)
+#else
+#define TIMER0_FREQUENCY_MHZ  tmrHw_LOW_FREQUENCY_MHZ
+#define TIMER1_FREQUENCY_MHZ  tmrHw_LOW_FREQUENCY_MHZ
+#define TIMER3_FREQUENCY_MHZ  tmrHw_HIGH_FREQUENCY_MHZ
+#define TIMER3_FREQUENCY_KHZ  (tmrHw_HIGH_FREQUENCY_HZ / 1000)
+#endif
+
+#define TICKS_PER_uSEC     TIMER0_FREQUENCY_MHZ
+
+/*
+ *  These are useconds NOT ticks.
+ *
+ */
+ #define mSEC_1                          1000
+ #define mSEC_5                          (mSEC_1 * 5)
+ #define mSEC_10                         (mSEC_1 * 10)
+ #define mSEC_25                         (mSEC_1 * 25)
+ #define SEC_1                           (mSEC_1 * 1000)
+
+/*
+ * How long is the timer interval?
+ */
+#define TIMER_INTERVAL (TICKS_PER_uSEC * mSEC_10)
+#if TIMER_INTERVAL >= 0x100000
+#define TIMER_RELOAD   (TIMER_INTERVAL >> 8)
+#define TIMER_DIVISOR  (TIMER_CTRL_DIV256)
+#define TICKS2USECS(x) (256 * (x) / TICKS_PER_uSEC)
+#elif TIMER_INTERVAL >= 0x10000
+#define TIMER_RELOAD   (TIMER_INTERVAL >> 4)           /* Divide by 16 */
+#define TIMER_DIVISOR  (TIMER_CTRL_DIV16)
+#define TICKS2USECS(x) (16 * (x) / TICKS_PER_uSEC)
+#else
+#define TIMER_RELOAD   (TIMER_INTERVAL)
+#define TIMER_DIVISOR  (TIMER_CTRL_DIV1)
+#define TICKS2USECS(x) ((x) / TICKS_PER_uSEC)
+#endif
+
+static void timer_set_mode(enum clock_event_mode mode,
+                          struct clock_event_device *clk)
+{
+       unsigned long ctrl;
+
+       switch(mode) {
+       case CLOCK_EVT_MODE_PERIODIC:
+               writel(TIMER_RELOAD, TIMER0_VA_BASE + TIMER_LOAD);
+
+               ctrl = TIMER_CTRL_PERIODIC;
+               ctrl |= TIMER_DIVISOR | TIMER_CTRL_32BIT | TIMER_CTRL_IE | TIMER_CTRL_ENABLE;
+               break;
+       case CLOCK_EVT_MODE_ONESHOT:
+               /* period set, and timer enabled in 'next_event' hook */
+               ctrl = TIMER_CTRL_ONESHOT;
+               ctrl |= TIMER_DIVISOR | TIMER_CTRL_32BIT | TIMER_CTRL_IE;
+               break;
+       case CLOCK_EVT_MODE_UNUSED:
+       case CLOCK_EVT_MODE_SHUTDOWN:
+       default:
+               ctrl = 0;
+       }
+
+       writel(ctrl, TIMER0_VA_BASE + TIMER_CTRL);
+}
+
+static int timer_set_next_event(unsigned long evt,
+                               struct clock_event_device *unused)
+{
+       unsigned long ctrl = readl(TIMER0_VA_BASE + TIMER_CTRL);
+
+       writel(evt, TIMER0_VA_BASE + TIMER_LOAD);
+       writel(ctrl | TIMER_CTRL_ENABLE, TIMER0_VA_BASE + TIMER_CTRL);
+
+       return 0;
+}
+
+static struct clock_event_device timer0_clockevent =    {
+       .name           = "timer0",
+       .shift          = 32,
+       .features       = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
+       .set_mode       = timer_set_mode,
+       .set_next_event = timer_set_next_event,
+};
+
+/*
+ * IRQ handler for the timer
+ */
+static irqreturn_t bcmring_timer_interrupt(int irq, void *dev_id)
+{
+       struct clock_event_device *evt = &timer0_clockevent;
+
+       writel(1, TIMER0_VA_BASE + TIMER_INTCLR);
+
+       evt->event_handler(evt);
+
+       return IRQ_HANDLED;
+}
+
+static struct irqaction bcmring_timer_irq = {
+       .name           = "bcmring Timer Tick",
+       .flags          = IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+       .handler        = bcmring_timer_interrupt,
+};
+
+static cycle_t bcmring_get_cycles_timer1(void)
+{
+       return ~readl(TIMER1_VA_BASE + TIMER_VALUE);
+}
+
+static cycle_t bcmring_get_cycles_timer3(void)
+{
+       return ~readl(TIMER3_VA_BASE + TIMER_VALUE);
+}
+
+static struct clocksource clocksource_bcmring_timer1 = {
+       .name           = "timer1",
+       .rating         = 200,
+       .read           = bcmring_get_cycles_timer1,
+       .mask           = CLOCKSOURCE_MASK(32),
+       .shift          = 20,
+       .flags          = CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+static struct clocksource clocksource_bcmring_timer3 = {
+       .name           = "timer3",
+       .rating         = 100,
+       .read           = bcmring_get_cycles_timer3,
+       .mask           = CLOCKSOURCE_MASK(32),
+       .shift          = 20,
+       .flags          = CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+static int __init bcmring_clocksource_init(void)
+{
+   /* setup timer1 as free-running clocksource */
+   writel(0, TIMER1_VA_BASE + TIMER_CTRL);
+   writel(0xffffffff, TIMER1_VA_BASE + TIMER_LOAD);
+   writel(0xffffffff, TIMER1_VA_BASE + TIMER_VALUE);
+   writel(TIMER_CTRL_32BIT | TIMER_CTRL_ENABLE | TIMER_CTRL_PERIODIC,
+              TIMER1_VA_BASE + TIMER_CTRL);
+
+   clocksource_bcmring_timer1.mult =
+      clocksource_khz2mult(TIMER1_FREQUENCY_MHZ * 1000, clocksource_bcmring_timer1.shift);
+   clocksource_register(&clocksource_bcmring_timer1);
+
+   /* setup timer3 as free-running clocksource */
+   writel(0, TIMER3_VA_BASE + TIMER_CTRL);
+   writel(0xffffffff, TIMER3_VA_BASE + TIMER_LOAD);
+   writel(0xffffffff, TIMER3_VA_BASE + TIMER_VALUE);
+   writel(TIMER_CTRL_32BIT | TIMER_CTRL_ENABLE | TIMER_CTRL_PERIODIC,
+          TIMER3_VA_BASE + TIMER_CTRL);
+
+   clocksource_bcmring_timer3.mult =
+      clocksource_khz2mult(TIMER3_FREQUENCY_KHZ, clocksource_bcmring_timer3.shift);
+   clocksource_register(&clocksource_bcmring_timer3);
+
+   return 0;
+}
+
+
+/*
+ * Set up timer interrupt, and return the current time in seconds.
+ */
+void __init bcmring_init_timer(void)
+{
+       printk(KERN_INFO"bcmring_init_timer\n");
+#if defined(CONFIG_BCM_SVN_REVISION)
+       printk(KERN_INFO"SVN Revision: "CONFIG_BCM_SVN_REVISION"\n");
+#endif
+       /*
+        * Initialise to a known state (all timers off)
+        */
+       writel(0, TIMER0_VA_BASE + TIMER_CTRL);
+       writel(0, TIMER1_VA_BASE + TIMER_CTRL);
+       writel(0, TIMER2_VA_BASE + TIMER_CTRL);
+       writel(0, TIMER3_VA_BASE + TIMER_CTRL);
+
+       /*
+        * Make irqs happen for the system timer
+        */
+       setup_irq(IRQ_TIMER0, &bcmring_timer_irq);
+
+       bcmring_clocksource_init();
+
+       timer0_clockevent.mult =
+               div_sc(1000000, NSEC_PER_SEC, timer0_clockevent.shift);
+       timer0_clockevent.max_delta_ns =
+               clockevent_delta2ns(0xffffffff, &timer0_clockevent);
+       timer0_clockevent.min_delta_ns =
+               clockevent_delta2ns(0xf, &timer0_clockevent);
+
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27)
+       timer0_clockevent.cpumask = cpumask_of(0);
+#else
+       timer0_clockevent.cpumask = cpumask_of_cpu(0);
+#endif
+       clockevents_register_device(&timer0_clockevent);
+}
+
+struct sys_timer bcmring_timer = {
+       .init           = bcmring_init_timer,
+};
+
diff --git a/arch/arm/mach-bcmring/core.h b/arch/arm/mach-bcmring/core.h
new file mode 100644
index 0000000..afc7b70
--- /dev/null
+++ b/arch/arm/mach-bcmring/core.h
@@ -0,0 +1,75 @@
+/*
+ *  linux/arch/arm/mach-versatile/core.h
+ *
+ *  Copyright (C) 2004 ARM Limited
+ *  Copyright (C) 2000 Deep Blue Solutions Ltd
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
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+/* Portions copyright Broadcom 2008 */
+#ifndef __ASM_ARCH_BCMRING_H
+#define __ASM_ARCH_BCMRING_H
+
+#include <linux/version.h>
+#include <linux/amba/bus.h>
+#include <mach/csp/mm_addr.h>
+
+void __init bcmring_amba_init(void);
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30)
+
+#define AMBA_DEVICE(name,busid,base,plat,size)       \
+static struct amba_device name##_device = {     \
+   .dev = {                                     \
+      .coherent_dma_mask = ~0,                  \
+      .bus_id = busid,                          \
+      .platform_data = plat                     \
+   },                                           \
+   .res = {                                     \
+      .start = MM_ADDR_IO_##base,               \
+               .end = MM_ADDR_IO_##base + (size) - 1,    \
+      .flags = IORESOURCE_MEM                   \
+   },                                           \
+   .dma_mask = ~0,                              \
+   .irq = {                                     \
+      IRQ_##base                                \
+   }                                            \
+   /* .dma             = base##_DMA,*/                               \
+}
+
+#else
+
+#define AMBA_DEVICE(name,initname,base,plat,size)       \
+static struct amba_device name##_device = {     \
+   .dev = {                                     \
+      .coherent_dma_mask = ~0,                  \
+      .init_name = initname,                    \
+      .platform_data = plat                     \
+   },                                           \
+   .res = {                                     \
+      .start = MM_ADDR_IO_##base,               \
+               .end = MM_ADDR_IO_##base + (size) - 1,    \
+      .flags = IORESOURCE_MEM                   \
+   },                                           \
+   .dma_mask = ~0,                              \
+   .irq = {                                     \
+      IRQ_##base                                \
+   }                                            \
+   /* .dma             = base##_DMA,*/                               \
+}
+
+#endif
+
+#endif
diff --git a/arch/arm/mach-bcmring/dma.c b/arch/arm/mach-bcmring/dma.c
new file mode 100644
index 0000000..a144514
--- /dev/null
+++ b/arch/arm/mach-bcmring/dma.c
@@ -0,0 +1,3022 @@
+/*****************************************************************************
+* Copyright 2004 - 2008 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+
+/****************************************************************************/
+/**
+*   @file   dma.c
+*
+*   @brief  Implements the DMA interface.
+*/
+/****************************************************************************/
+
+/* ---- Include Files ---------------------------------------------------- */
+
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
+#include <linux/interrupt.h>
+#include <linux/irqreturn.h>
+#include <linux/proc_fs.h>
+
+#include <mach/timer.h>
+
+#include <linux/mm.h>
+#include <linux/pfn.h>
+#include <asm/atomic.h>
+#include <mach/dma.h>
+
+#ifdef CONFIG_BCM_KNLLOG_IRQ
+#include <linux/broadcom/knllog.h>
+// knllog needs ability to get module and channel from handle
+// csp driver should provide api to get this information
+#include <mach/csp/dmacHw_priv.h>
+#endif
+
+// I don't quite understand why dc4 fails when this is set to 1 and DMA is enabled
+// especially since dc4 doesn't use kmalloc'd memory.
+
+#define ALLOW_MAP_OF_KMALLOC_MEMORY 0
+
+/* ---- Public Variables ------------------------------------------------- */
+
+/* ---- Private Constants and Types -------------------------------------- */
+
+#define MAKE_HANDLE( controllerIdx, channelIdx )    (( (controllerIdx) << 4 ) | (channelIdx) )
+
+#define CONTROLLER_FROM_HANDLE( handle )    (( (handle) >> 4 ) & 0x0f )
+#define CHANNEL_FROM_HANDLE( handle )       (  (handle) & 0x0f )
+
+#define DMA_MAP_DEBUG   0
+
+#if DMA_MAP_DEBUG
+#   define  DMA_MAP_PRINT( fmt, args... )   printk( "%s: " fmt, __func__,  ## args )
+#else
+#   define  DMA_MAP_PRINT( fmt, args... )
+#endif
+
+/* ---- Private Variables ------------------------------------------------ */
+
+static DMA_Global_t             gDMA;
+static struct proc_dir_entry   *gDmaDir;
+
+static  atomic_t    gDmaStatMemTypeKmalloc    = ATOMIC_INIT( 0 );
+static  atomic_t    gDmaStatMemTypeVmalloc    = ATOMIC_INIT( 0 );
+static  atomic_t    gDmaStatMemTypeUser       = ATOMIC_INIT( 0 );
+static  atomic_t    gDmaStatMemTypeCoherent   = ATOMIC_INIT( 0 );
+
+
+DMA_DeviceAttribute_t DMA_gDeviceAttribute[ DMA_NUM_DEVICE_ENTRIES ] =
+{
+    [DMA_DEVICE_MEM_TO_MEM] =
+    {
+        .flags = DMA_DEVICE_FLAG_ON_DMA0 | DMA_DEVICE_FLAG_ON_DMA1,
+        .name = "mem-to-mem",
+        .config =
+        {
+            .srcUpdate                  = dmacHw_SRC_ADDRESS_UPDATE_MODE_INC,
+            .dstUpdate                  = dmacHw_DST_ADDRESS_UPDATE_MODE_INC,
+            .transferType               = dmacHw_TRANSFER_TYPE_MEM_TO_MEM,
+            .transferMode               = dmacHw_TRANSFER_MODE_PERREQUEST,
+            .srcMasterInterface         = dmacHw_SRC_MASTER_INTERFACE_1,
+            .dstMasterInterface         = dmacHw_DST_MASTER_INTERFACE_1,
+            .completeTransferInterrupt  = dmacHw_INTERRUPT_ENABLE,
+            .errorInterrupt             = dmacHw_INTERRUPT_ENABLE,
+            .channelPriority            = dmacHw_CHANNEL_PRIORITY_7,
+            .srcMaxTransactionWidth     = dmacHw_SRC_TRANSACTION_WIDTH_64,
+            .dstMaxTransactionWidth     = dmacHw_DST_TRANSACTION_WIDTH_64,
+
+        },
+    },
+    [DMA_DEVICE_VPM_MEM_TO_MEM] =
+    {
+        .flags = DMA_DEVICE_FLAG_IS_DEDICATED | DMA_DEVICE_FLAG_NO_ISR,
+        .name = "vpm",
+        .dedicatedController = 0,
+        .dedicatedChannel = 0,
+        /* reserve DMA0:0 for VPM */
+    },
+    [DMA_DEVICE_NAND_MEM_TO_MEM] =
+    {
+        .flags = DMA_DEVICE_FLAG_ON_DMA0 | DMA_DEVICE_FLAG_ON_DMA1,
+        .name = "nand",
+        .config =
+        {
+            .srcPeripheralPort          = 0,
+            .dstPeripheralPort          = 0,
+            .srcStatusRegisterAddress   = 0x00000000,
+            .dstStatusRegisterAddress   = 0x00000000,
+            .transferType               = dmacHw_TRANSFER_TYPE_MEM_TO_MEM,
+            .srcMasterInterface         = dmacHw_SRC_MASTER_INTERFACE_1,
+            .dstMasterInterface         = dmacHw_DST_MASTER_INTERFACE_1,
+            .srcMaxTransactionWidth     = dmacHw_SRC_TRANSACTION_WIDTH_32,
+            .dstMaxTransactionWidth     = dmacHw_DST_TRANSACTION_WIDTH_32,
+            .srcMaxBurstWidth           = dmacHw_SRC_BURST_WIDTH_4,
+            .dstMaxBurstWidth           = dmacHw_DST_BURST_WIDTH_4,
+            .completeTransferInterrupt  = dmacHw_INTERRUPT_ENABLE,
+            .errorInterrupt             = dmacHw_INTERRUPT_ENABLE,
+            .channelPriority            = dmacHw_CHANNEL_PRIORITY_6,
+        },
+    },
+    [DMA_DEVICE_PIF_MEM_TO_DEV] = /* PIF TX */
+    {
+        .flags = DMA_DEVICE_FLAG_ON_DMA0 | DMA_DEVICE_FLAG_ON_DMA1
+               | DMA_DEVICE_FLAG_ALLOW_LARGE_FIFO
+               | DMA_DEVICE_FLAG_ALLOC_DMA1_FIRST | DMA_DEVICE_FLAG_PORT_PER_DMAC,
+        .name = "pif_tx",
+        .dmacPort = { 14, 5 },
+        .config =
+        {
+            .srcPeripheralPort          = 0, /* SRC: memory */
+            //.dstPeripheralPort          = 5 or 14
+            .srcStatusRegisterAddress   = 0x00000000,
+            .dstStatusRegisterAddress   = 0x00000000,
+            .srcUpdate                  = dmacHw_SRC_ADDRESS_UPDATE_MODE_INC,
+            .dstUpdate                  = dmacHw_DST_ADDRESS_UPDATE_MODE_INC,
+            .transferType               = dmacHw_TRANSFER_TYPE_MEM_TO_PERIPHERAL,
+            .srcMasterInterface         = dmacHw_SRC_MASTER_INTERFACE_1,
+            .dstMasterInterface         = dmacHw_DST_MASTER_INTERFACE_2,
+            .completeTransferInterrupt  = dmacHw_INTERRUPT_ENABLE,
+            .errorInterrupt             = dmacHw_INTERRUPT_ENABLE,
+            .channelPriority            = dmacHw_CHANNEL_PRIORITY_7,
+            .srcMaxTransactionWidth     = dmacHw_SRC_TRANSACTION_WIDTH_64,
+            .dstMaxTransactionWidth     = dmacHw_DST_TRANSACTION_WIDTH_32,
+            .srcMaxBurstWidth           = dmacHw_SRC_BURST_WIDTH_8,
+            .dstMaxBurstWidth           = dmacHw_DST_BURST_WIDTH_8,
+            .maxDataPerBlock            = 16256,
+        },
+    },
+    [DMA_DEVICE_PIF_DEV_TO_MEM] = /* PIF RX */
+    {
+        .flags = DMA_DEVICE_FLAG_ON_DMA0 | DMA_DEVICE_FLAG_ON_DMA1
+               | DMA_DEVICE_FLAG_ALLOW_LARGE_FIFO
+               //| DMA_DEVICE_FLAG_ALLOC_DMA1_FIRST
+               | DMA_DEVICE_FLAG_PORT_PER_DMAC,
+        .name = "pif_rx",
+        .dmacPort = { 14, 5 },
+        .config =
+        {
+            //.srcPeripheralPort          = 5 or 14
+            .dstPeripheralPort          = 0, /* DST: memory */
+            .srcStatusRegisterAddress   = 0x00000000,
+            .dstStatusRegisterAddress   = 0x00000000,
+            .srcUpdate                  = dmacHw_SRC_ADDRESS_UPDATE_MODE_INC,
+            .dstUpdate                  = dmacHw_DST_ADDRESS_UPDATE_MODE_INC,
+            .transferType               = dmacHw_TRANSFER_TYPE_PERIPHERAL_TO_MEM,
+            .srcMasterInterface         = dmacHw_SRC_MASTER_INTERFACE_2,
+            .dstMasterInterface         = dmacHw_DST_MASTER_INTERFACE_1,
+            .completeTransferInterrupt  = dmacHw_INTERRUPT_ENABLE,
+            .errorInterrupt             = dmacHw_INTERRUPT_ENABLE,
+            .channelPriority            = dmacHw_CHANNEL_PRIORITY_7,
+            .srcMaxTransactionWidth     = dmacHw_SRC_TRANSACTION_WIDTH_32,
+            .dstMaxTransactionWidth     = dmacHw_DST_TRANSACTION_WIDTH_64,
+            .srcMaxBurstWidth           = dmacHw_SRC_BURST_WIDTH_8,
+            .dstMaxBurstWidth           = dmacHw_DST_BURST_WIDTH_8,
+            .maxDataPerBlock            = 16256,
+        },
+    },
+    [DMA_DEVICE_I2S0_DEV_TO_MEM] =
+    {
+       .flags = DMA_DEVICE_FLAG_ON_DMA0,
+       .name = "i2s0_rx",
+       .config =
+       {
+          .srcPeripheralPort            = 0, /* SRC: I2S0 */
+          .dstPeripheralPort            = 0, /* DST: memory */
+          .srcStatusRegisterAddress     = 0,
+          .dstStatusRegisterAddress     = 0,
+          .transferType                 = dmacHw_TRANSFER_TYPE_PERIPHERAL_TO_MEM,
+          .srcMasterInterface           = dmacHw_SRC_MASTER_INTERFACE_1,
+          .dstMasterInterface           = dmacHw_DST_MASTER_INTERFACE_1,
+          .srcMaxTransactionWidth       = dmacHw_SRC_TRANSACTION_WIDTH_16,
+          .dstMaxTransactionWidth       = dmacHw_DST_TRANSACTION_WIDTH_64,
+          .srcMaxBurstWidth             = dmacHw_SRC_BURST_WIDTH_4,
+          .dstMaxBurstWidth             = dmacHw_DST_BURST_WIDTH_0,
+          .blockTransferInterrupt       = dmacHw_INTERRUPT_ENABLE,
+          .completeTransferInterrupt    = dmacHw_INTERRUPT_DISABLE,
+          .errorInterrupt               = dmacHw_INTERRUPT_ENABLE,
+          .channelPriority              = dmacHw_CHANNEL_PRIORITY_7,
+          .transferMode                 = dmacHw_TRANSFER_MODE_CONTINUOUS,
+       },
+    },
+    [DMA_DEVICE_I2S0_MEM_TO_DEV] =
+    {
+       .flags = DMA_DEVICE_FLAG_ON_DMA0,
+       .name = "i2s0_tx",
+       .config =
+       {
+          .srcPeripheralPort            = 0, /* SRC: memory */
+          .dstPeripheralPort            = 1, /* DST: I2S0 */
+          .srcStatusRegisterAddress     = 0,
+          .dstStatusRegisterAddress     = 0,
+          .transferType                 = dmacHw_TRANSFER_TYPE_MEM_TO_PERIPHERAL,
+          .srcMasterInterface           = dmacHw_SRC_MASTER_INTERFACE_1,
+          .dstMasterInterface           = dmacHw_DST_MASTER_INTERFACE_1,
+          .srcMaxTransactionWidth       = dmacHw_SRC_TRANSACTION_WIDTH_64,
+          .dstMaxTransactionWidth       = dmacHw_DST_TRANSACTION_WIDTH_16,
+          .srcMaxBurstWidth             = dmacHw_SRC_BURST_WIDTH_0,
+          .dstMaxBurstWidth             = dmacHw_DST_BURST_WIDTH_4,
+          .blockTransferInterrupt       = dmacHw_INTERRUPT_DISABLE,
+          .completeTransferInterrupt    = dmacHw_INTERRUPT_ENABLE,
+          .errorInterrupt               = dmacHw_INTERRUPT_ENABLE,
+          .channelPriority              = dmacHw_CHANNEL_PRIORITY_7,
+          .transferMode                 = dmacHw_TRANSFER_MODE_PERREQUEST,
+       },
+    },
+    [DMA_DEVICE_I2S1_DEV_TO_MEM] =
+    {
+       .flags = DMA_DEVICE_FLAG_ON_DMA1,
+       .name = "i2s1_rx",
+       .config =
+       {
+          .srcPeripheralPort            = 2, /* SRC: I2S1 */
+          .dstPeripheralPort            = 0, /* DST: memory */
+          .srcStatusRegisterAddress     = 0,
+          .dstStatusRegisterAddress     = 0,
+          .transferType                 = dmacHw_TRANSFER_TYPE_PERIPHERAL_TO_MEM,
+          .srcMasterInterface           = dmacHw_SRC_MASTER_INTERFACE_1,
+          .dstMasterInterface           = dmacHw_DST_MASTER_INTERFACE_1,
+          .srcMaxTransactionWidth       = dmacHw_SRC_TRANSACTION_WIDTH_16,
+          .dstMaxTransactionWidth       = dmacHw_DST_TRANSACTION_WIDTH_64,
+          .srcMaxBurstWidth             = dmacHw_SRC_BURST_WIDTH_4,
+          .dstMaxBurstWidth             = dmacHw_DST_BURST_WIDTH_0,
+          .blockTransferInterrupt       = dmacHw_INTERRUPT_ENABLE,
+          .completeTransferInterrupt    = dmacHw_INTERRUPT_DISABLE,
+          .errorInterrupt               = dmacHw_INTERRUPT_ENABLE,
+          .channelPriority              = dmacHw_CHANNEL_PRIORITY_7,
+          .transferMode                 = dmacHw_TRANSFER_MODE_CONTINUOUS,
+       },
+    },
+    [DMA_DEVICE_I2S1_MEM_TO_DEV] =
+    {
+       .flags = DMA_DEVICE_FLAG_ON_DMA1,
+       .name = "i2s1_tx",
+       .config =
+       {
+          .srcPeripheralPort            = 0, /* SRC: memory */
+          .dstPeripheralPort            = 3, /* DST: I2S1 */
+          .srcStatusRegisterAddress     = 0,
+          .dstStatusRegisterAddress     = 0,
+          .transferType                 = dmacHw_TRANSFER_TYPE_MEM_TO_PERIPHERAL,
+          .srcMasterInterface           = dmacHw_SRC_MASTER_INTERFACE_1,
+          .dstMasterInterface           = dmacHw_DST_MASTER_INTERFACE_1,
+          .srcMaxTransactionWidth       = dmacHw_SRC_TRANSACTION_WIDTH_64,
+          .dstMaxTransactionWidth       = dmacHw_DST_TRANSACTION_WIDTH_16,
+          .srcMaxBurstWidth             = dmacHw_SRC_BURST_WIDTH_0,
+          .dstMaxBurstWidth             = dmacHw_DST_BURST_WIDTH_4,
+          .blockTransferInterrupt       = dmacHw_INTERRUPT_DISABLE,
+          .completeTransferInterrupt    = dmacHw_INTERRUPT_ENABLE,
+          .errorInterrupt               = dmacHw_INTERRUPT_ENABLE,
+          .channelPriority              = dmacHw_CHANNEL_PRIORITY_7,
+          .transferMode                 = dmacHw_TRANSFER_MODE_PERREQUEST,
+       },
+    },
+    [DMA_DEVICE_ESW_MEM_TO_DEV] = /* ESW TX */
+    {
+        .name = "esw_tx",
+        .flags = DMA_DEVICE_FLAG_IS_DEDICATED,
+        .dedicatedController = 1,
+        .dedicatedChannel = 3,
+        .config =
+        {
+            .srcPeripheralPort          = 0,    /* SRC: memory */
+            .dstPeripheralPort          = 1,    /* DST: ESW (MTP) */
+            .completeTransferInterrupt  = dmacHw_INTERRUPT_ENABLE,
+            .errorInterrupt             = dmacHw_INTERRUPT_DISABLE,
+            // DMAx_AHB_SSTATARy
+            .srcStatusRegisterAddress   = 0x00000000,
+            // DMAx_AHB_DSTATARy
+            .dstStatusRegisterAddress   = 0x30490010,
+            // DMAx_AHB_CFGy
+            .channelPriority            = dmacHw_CHANNEL_PRIORITY_7,
+            // DMAx_AHB_CTLy
+            .srcMasterInterface         = dmacHw_SRC_MASTER_INTERFACE_2,
+            .dstMasterInterface         = dmacHw_DST_MASTER_INTERFACE_1,
+            .transferType               = dmacHw_TRANSFER_TYPE_MEM_TO_PERIPHERAL,
+            .srcMaxBurstWidth           = dmacHw_SRC_BURST_WIDTH_0,
+            .dstMaxBurstWidth           = dmacHw_DST_BURST_WIDTH_8,
+            .srcUpdate                  = dmacHw_SRC_ADDRESS_UPDATE_MODE_INC,
+            .dstUpdate                  = dmacHw_DST_ADDRESS_UPDATE_MODE_INC,
+            .srcMaxTransactionWidth     = dmacHw_SRC_TRANSACTION_WIDTH_64,
+            .dstMaxTransactionWidth     = dmacHw_DST_TRANSACTION_WIDTH_64,
+        },
+    },
+    [DMA_DEVICE_ESW_DEV_TO_MEM] = /* ESW RX */
+    {
+        .name = "esw_rx",
+        .flags = DMA_DEVICE_FLAG_IS_DEDICATED,
+        .dedicatedController = 1,
+        .dedicatedChannel = 2,
+        .config =
+        {
+            .srcPeripheralPort          = 0,    /* SRC: ESW (PTM) */
+            .dstPeripheralPort          = 0,    /* DST: memory */
+            .completeTransferInterrupt  = dmacHw_INTERRUPT_ENABLE,
+            .errorInterrupt             = dmacHw_INTERRUPT_DISABLE,
+            // DMAx_AHB_SSTATARy
+            .srcStatusRegisterAddress   = 0x30480010,
+            // DMAx_AHB_DSTATARy
+            .dstStatusRegisterAddress   = 0x00000000,
+            // DMAx_AHB_CFGy
+            .channelPriority            = dmacHw_CHANNEL_PRIORITY_7,
+            // DMAx_AHB_CTLy
+            .srcMasterInterface         = dmacHw_SRC_MASTER_INTERFACE_2,
+            .dstMasterInterface         = dmacHw_DST_MASTER_INTERFACE_1,
+            .transferType               = dmacHw_TRANSFER_TYPE_PERIPHERAL_TO_MEM,
+            .srcMaxBurstWidth           = dmacHw_SRC_BURST_WIDTH_8,
+            .dstMaxBurstWidth           = dmacHw_DST_BURST_WIDTH_0,
+            .srcUpdate                  = dmacHw_SRC_ADDRESS_UPDATE_MODE_INC,
+            .dstUpdate                  = dmacHw_DST_ADDRESS_UPDATE_MODE_INC,
+            .srcMaxTransactionWidth     = dmacHw_SRC_TRANSACTION_WIDTH_64,
+            .dstMaxTransactionWidth     = dmacHw_DST_TRANSACTION_WIDTH_64,
+        },
+    },
+    [DMA_DEVICE_APM_CODEC_A_DEV_TO_MEM] = /* APM Codec A Ingress */
+    {
+        .flags = DMA_DEVICE_FLAG_ON_DMA0,
+        .name = "apm_a_rx",
+        .config =
+        {
+            .srcPeripheralPort          = 2, /* SRC: Codec A Ingress FIFO */
+            .dstPeripheralPort          = 0, /* DST: memory */
+            .srcStatusRegisterAddress   = 0x00000000,
+            .dstStatusRegisterAddress   = 0x00000000,
+            .srcUpdate                  = dmacHw_SRC_ADDRESS_UPDATE_MODE_INC,
+            .dstUpdate                  = dmacHw_DST_ADDRESS_UPDATE_MODE_INC,
+            .transferType               = dmacHw_TRANSFER_TYPE_PERIPHERAL_TO_MEM,
+            .srcMasterInterface         = dmacHw_SRC_MASTER_INTERFACE_2,
+            .dstMasterInterface         = dmacHw_DST_MASTER_INTERFACE_1,
+            .blockTransferInterrupt     = dmacHw_INTERRUPT_ENABLE,
+            .completeTransferInterrupt  = dmacHw_INTERRUPT_DISABLE,
+            .errorInterrupt             = dmacHw_INTERRUPT_ENABLE,
+            .channelPriority            = dmacHw_CHANNEL_PRIORITY_7,
+            .srcMaxTransactionWidth     = dmacHw_SRC_TRANSACTION_WIDTH_32,
+            .dstMaxTransactionWidth     = dmacHw_DST_TRANSACTION_WIDTH_64,
+            .srcMaxBurstWidth           = dmacHw_SRC_BURST_WIDTH_4,
+            .dstMaxBurstWidth           = dmacHw_DST_BURST_WIDTH_4,
+            .transferMode               = dmacHw_TRANSFER_MODE_CONTINUOUS,
+        },
+    },
+    [DMA_DEVICE_APM_CODEC_A_MEM_TO_DEV] = /* APM Codec A Egress */
+    {
+        .flags = DMA_DEVICE_FLAG_ON_DMA0,
+        .name = "apm_a_tx",
+        .config =
+        {
+            .srcPeripheralPort          = 0, /* SRC: memory */
+            .dstPeripheralPort          = 3, /* DST: Codec A Egress FIFO */
+            .srcStatusRegisterAddress   = 0x00000000,
+            .dstStatusRegisterAddress   = 0x00000000,
+            .srcUpdate                  = dmacHw_SRC_ADDRESS_UPDATE_MODE_INC,
+            .dstUpdate                  = dmacHw_DST_ADDRESS_UPDATE_MODE_INC,
+            .transferType               = dmacHw_TRANSFER_TYPE_MEM_TO_PERIPHERAL,
+            .srcMasterInterface         = dmacHw_SRC_MASTER_INTERFACE_1,
+            .dstMasterInterface         = dmacHw_DST_MASTER_INTERFACE_2,
+            .blockTransferInterrupt     = dmacHw_INTERRUPT_DISABLE,
+            .completeTransferInterrupt  = dmacHw_INTERRUPT_ENABLE,
+            .errorInterrupt             = dmacHw_INTERRUPT_ENABLE,
+            .channelPriority            = dmacHw_CHANNEL_PRIORITY_7,
+            .srcMaxTransactionWidth     = dmacHw_SRC_TRANSACTION_WIDTH_64,
+            .dstMaxTransactionWidth     = dmacHw_DST_TRANSACTION_WIDTH_32,
+            .srcMaxBurstWidth           = dmacHw_SRC_BURST_WIDTH_4,
+            .dstMaxBurstWidth           = dmacHw_DST_BURST_WIDTH_4,
+            .transferMode               = dmacHw_TRANSFER_MODE_PERREQUEST,
+        },
+    },
+    [DMA_DEVICE_APM_CODEC_B_DEV_TO_MEM] = /* APM Codec B Ingress */
+    {
+        .flags = DMA_DEVICE_FLAG_ON_DMA0,
+        .name = "apm_b_rx",
+        .config =
+        {
+            .srcPeripheralPort          = 4, /* SRC: Codec B Ingress FIFO */
+            .dstPeripheralPort          = 0, /* DST: memory */
+            .srcStatusRegisterAddress   = 0x00000000,
+            .dstStatusRegisterAddress   = 0x00000000,
+            .srcUpdate                  = dmacHw_SRC_ADDRESS_UPDATE_MODE_INC,
+            .dstUpdate                  = dmacHw_DST_ADDRESS_UPDATE_MODE_INC,
+            .transferType               = dmacHw_TRANSFER_TYPE_PERIPHERAL_TO_MEM,
+            .srcMasterInterface         = dmacHw_SRC_MASTER_INTERFACE_2,
+            .dstMasterInterface         = dmacHw_DST_MASTER_INTERFACE_1,
+            .blockTransferInterrupt     = dmacHw_INTERRUPT_ENABLE,
+            .completeTransferInterrupt  = dmacHw_INTERRUPT_DISABLE,
+            .errorInterrupt             = dmacHw_INTERRUPT_ENABLE,
+            .channelPriority            = dmacHw_CHANNEL_PRIORITY_7,
+            .srcMaxTransactionWidth     = dmacHw_SRC_TRANSACTION_WIDTH_32,
+            .dstMaxTransactionWidth     = dmacHw_DST_TRANSACTION_WIDTH_64,
+            .srcMaxBurstWidth           = dmacHw_SRC_BURST_WIDTH_4,
+            .dstMaxBurstWidth           = dmacHw_DST_BURST_WIDTH_4,
+            .transferMode               = dmacHw_TRANSFER_MODE_CONTINUOUS,
+        },
+    },
+    [DMA_DEVICE_APM_CODEC_B_MEM_TO_DEV] = /* APM Codec B Egress */
+    {
+        .flags = DMA_DEVICE_FLAG_ON_DMA0,
+        .name = "apm_b_tx",
+        .config =
+        {
+            .srcPeripheralPort          = 0, /* SRC: memory */
+            .dstPeripheralPort          = 5, /* DST: Codec B Egress FIFO */
+            .srcStatusRegisterAddress   = 0x00000000,
+            .dstStatusRegisterAddress   = 0x00000000,
+            .srcUpdate                  = dmacHw_SRC_ADDRESS_UPDATE_MODE_INC,
+            .dstUpdate                  = dmacHw_DST_ADDRESS_UPDATE_MODE_INC,
+            .transferType               = dmacHw_TRANSFER_TYPE_MEM_TO_PERIPHERAL,
+            .srcMasterInterface         = dmacHw_SRC_MASTER_INTERFACE_1,
+            .dstMasterInterface         = dmacHw_DST_MASTER_INTERFACE_2,
+            .blockTransferInterrupt     = dmacHw_INTERRUPT_DISABLE,
+            .completeTransferInterrupt  = dmacHw_INTERRUPT_ENABLE,
+            .errorInterrupt             = dmacHw_INTERRUPT_ENABLE,
+            .channelPriority            = dmacHw_CHANNEL_PRIORITY_7,
+            .srcMaxTransactionWidth     = dmacHw_SRC_TRANSACTION_WIDTH_64,
+            .dstMaxTransactionWidth     = dmacHw_DST_TRANSACTION_WIDTH_32,
+            .srcMaxBurstWidth           = dmacHw_SRC_BURST_WIDTH_4,
+            .dstMaxBurstWidth           = dmacHw_DST_BURST_WIDTH_4,
+            .transferMode               = dmacHw_TRANSFER_MODE_PERREQUEST,
+        },
+    },
+    [DMA_DEVICE_APM_CODEC_C_DEV_TO_MEM] = /* APM Codec C Ingress */
+    {
+        .flags = DMA_DEVICE_FLAG_ON_DMA1,
+        .name = "apm_c_rx",
+        .config =
+        {
+            .srcPeripheralPort          = 4, /* SRC: Codec C Ingress FIFO */
+            .dstPeripheralPort          = 0, /* DST: memory */
+            .srcStatusRegisterAddress   = 0x00000000,
+            .dstStatusRegisterAddress   = 0x00000000,
+            .srcUpdate                  = dmacHw_SRC_ADDRESS_UPDATE_MODE_INC,
+            .dstUpdate                  = dmacHw_DST_ADDRESS_UPDATE_MODE_INC,
+            .transferType               = dmacHw_TRANSFER_TYPE_PERIPHERAL_TO_MEM,
+            .srcMasterInterface         = dmacHw_SRC_MASTER_INTERFACE_2,
+            .dstMasterInterface         = dmacHw_DST_MASTER_INTERFACE_1,
+            .blockTransferInterrupt     = dmacHw_INTERRUPT_ENABLE,
+            .completeTransferInterrupt  = dmacHw_INTERRUPT_DISABLE,
+            .errorInterrupt             = dmacHw_INTERRUPT_ENABLE,
+            .channelPriority            = dmacHw_CHANNEL_PRIORITY_7,
+            .srcMaxTransactionWidth     = dmacHw_SRC_TRANSACTION_WIDTH_32,
+            .dstMaxTransactionWidth     = dmacHw_DST_TRANSACTION_WIDTH_64,
+            .srcMaxBurstWidth           = dmacHw_SRC_BURST_WIDTH_4,
+            .dstMaxBurstWidth           = dmacHw_DST_BURST_WIDTH_4,
+            .transferMode               = dmacHw_TRANSFER_MODE_CONTINUOUS,
+        },
+    },
+    [DMA_DEVICE_APM_PCM0_DEV_TO_MEM] =
+    {
+       .flags = DMA_DEVICE_FLAG_ON_DMA0,
+       .name = "pcm0_rx",
+       .config =
+       {
+          .srcPeripheralPort            = 12, /* SRC: PCM0 */
+          .dstPeripheralPort            = 0, /* DST: memory */
+          .srcStatusRegisterAddress     = 0,
+          .dstStatusRegisterAddress     = 0,
+          .transferType                 = dmacHw_TRANSFER_TYPE_PERIPHERAL_TO_MEM,
+          .srcMasterInterface           = dmacHw_SRC_MASTER_INTERFACE_2,
+          .dstMasterInterface           = dmacHw_DST_MASTER_INTERFACE_1,
+          .srcMaxTransactionWidth       = dmacHw_SRC_TRANSACTION_WIDTH_32,
+          .dstMaxTransactionWidth       = dmacHw_DST_TRANSACTION_WIDTH_64,
+          .srcMaxBurstWidth             = dmacHw_SRC_BURST_WIDTH_8,
+          .dstMaxBurstWidth             = dmacHw_DST_BURST_WIDTH_4,
+          .blockTransferInterrupt       = dmacHw_INTERRUPT_ENABLE,
+          .completeTransferInterrupt    = dmacHw_INTERRUPT_DISABLE,
+          .errorInterrupt               = dmacHw_INTERRUPT_ENABLE,
+          .channelPriority              = dmacHw_CHANNEL_PRIORITY_7,
+          .transferMode                 = dmacHw_TRANSFER_MODE_CONTINUOUS,
+       },
+    },
+    [DMA_DEVICE_APM_PCM0_MEM_TO_DEV] =
+    {
+       .flags = DMA_DEVICE_FLAG_ON_DMA0,
+       .name = "pcm0_tx",
+       .config =
+       {
+          .srcPeripheralPort            = 0, /* SRC: memory */
+          .dstPeripheralPort            = 13, /* DST: PCM0 */
+          .srcStatusRegisterAddress     = 0,
+          .dstStatusRegisterAddress     = 0,
+          .transferType                 = dmacHw_TRANSFER_TYPE_MEM_TO_PERIPHERAL,
+          .srcMasterInterface           = dmacHw_SRC_MASTER_INTERFACE_1,
+          .dstMasterInterface           = dmacHw_DST_MASTER_INTERFACE_2,
+          .srcMaxTransactionWidth       = dmacHw_SRC_TRANSACTION_WIDTH_64,
+          .dstMaxTransactionWidth       = dmacHw_DST_TRANSACTION_WIDTH_32,
+          .srcMaxBurstWidth             = dmacHw_SRC_BURST_WIDTH_4,
+          .dstMaxBurstWidth             = dmacHw_DST_BURST_WIDTH_8,
+          .blockTransferInterrupt       = dmacHw_INTERRUPT_DISABLE,
+          .completeTransferInterrupt    = dmacHw_INTERRUPT_ENABLE,
+          .errorInterrupt               = dmacHw_INTERRUPT_ENABLE,
+          .channelPriority              = dmacHw_CHANNEL_PRIORITY_7,
+          .transferMode                 = dmacHw_TRANSFER_MODE_PERREQUEST,
+       },
+    },
+    [DMA_DEVICE_APM_PCM1_DEV_TO_MEM] =
+    {
+       .flags = DMA_DEVICE_FLAG_ON_DMA1,
+       .name = "pcm1_rx",
+       .config =
+       {
+          .srcPeripheralPort            = 14, /* SRC: PCM1 */
+          .dstPeripheralPort            = 0, /* DST: memory */
+          .srcStatusRegisterAddress     = 0,
+          .dstStatusRegisterAddress     = 0,
+          .transferType                 = dmacHw_TRANSFER_TYPE_PERIPHERAL_TO_MEM,
+          .srcMasterInterface           = dmacHw_SRC_MASTER_INTERFACE_2,
+          .dstMasterInterface           = dmacHw_DST_MASTER_INTERFACE_1,
+          .srcMaxTransactionWidth       = dmacHw_SRC_TRANSACTION_WIDTH_32,
+          .dstMaxTransactionWidth       = dmacHw_DST_TRANSACTION_WIDTH_64,
+          .srcMaxBurstWidth             = dmacHw_SRC_BURST_WIDTH_8,
+          .dstMaxBurstWidth             = dmacHw_DST_BURST_WIDTH_4,
+          .blockTransferInterrupt       = dmacHw_INTERRUPT_ENABLE,
+          .completeTransferInterrupt    = dmacHw_INTERRUPT_DISABLE,
+          .errorInterrupt               = dmacHw_INTERRUPT_ENABLE,
+          .channelPriority              = dmacHw_CHANNEL_PRIORITY_7,
+          .transferMode                 = dmacHw_TRANSFER_MODE_CONTINUOUS,
+       },
+    },
+    [DMA_DEVICE_APM_PCM1_MEM_TO_DEV] =
+    {
+       .flags = DMA_DEVICE_FLAG_ON_DMA1,
+       .name = "pcm1_tx",
+       .config =
+       {
+          .srcPeripheralPort            = 0, /* SRC: memory */
+          .dstPeripheralPort            = 15, /* DST: PCM1 */
+          .srcStatusRegisterAddress     = 0,
+          .dstStatusRegisterAddress     = 0,
+          .transferType                 = dmacHw_TRANSFER_TYPE_MEM_TO_PERIPHERAL,
+          .srcMasterInterface           = dmacHw_SRC_MASTER_INTERFACE_1,
+          .dstMasterInterface           = dmacHw_DST_MASTER_INTERFACE_2,
+          .srcMaxTransactionWidth       = dmacHw_SRC_TRANSACTION_WIDTH_64,
+          .dstMaxTransactionWidth       = dmacHw_DST_TRANSACTION_WIDTH_32,
+          .srcMaxBurstWidth             = dmacHw_SRC_BURST_WIDTH_4,
+          .dstMaxBurstWidth             = dmacHw_DST_BURST_WIDTH_8,
+          .blockTransferInterrupt       = dmacHw_INTERRUPT_DISABLE,
+          .completeTransferInterrupt    = dmacHw_INTERRUPT_ENABLE,
+          .errorInterrupt               = dmacHw_INTERRUPT_ENABLE,
+          .channelPriority              = dmacHw_CHANNEL_PRIORITY_7,
+          .transferMode                 = dmacHw_TRANSFER_MODE_PERREQUEST,
+       },
+    },
+    [DMA_DEVICE_SPUM_DEV_TO_MEM] = /* SPUM RX */
+    {
+        .flags = DMA_DEVICE_FLAG_ON_DMA0 | DMA_DEVICE_FLAG_ON_DMA1,
+        .name = "spum_rx",
+        .config =
+        {
+            .srcPeripheralPort          = 6, /* SRC: Codec A Ingress FIFO */
+            .dstPeripheralPort          = 0, /* DST: memory */
+            .srcStatusRegisterAddress   = 0x00000000,
+            .dstStatusRegisterAddress   = 0x00000000,
+            .srcUpdate                  = dmacHw_SRC_ADDRESS_UPDATE_MODE_INC,
+            .dstUpdate                  = dmacHw_DST_ADDRESS_UPDATE_MODE_INC,
+            .transferType               = dmacHw_TRANSFER_TYPE_PERIPHERAL_TO_MEM,
+            .srcMasterInterface         = dmacHw_SRC_MASTER_INTERFACE_2,
+            .dstMasterInterface         = dmacHw_DST_MASTER_INTERFACE_1,
+            .blockTransferInterrupt     = dmacHw_INTERRUPT_DISABLE,
+            .completeTransferInterrupt  = dmacHw_INTERRUPT_ENABLE,
+            .errorInterrupt             = dmacHw_INTERRUPT_ENABLE,
+            .channelPriority            = dmacHw_CHANNEL_PRIORITY_7,
+            .srcMaxTransactionWidth     = dmacHw_SRC_TRANSACTION_WIDTH_32,
+            .dstMaxTransactionWidth     = dmacHw_DST_TRANSACTION_WIDTH_32,
+            /* Busrt size **MUST** be 16 for SPUM to work */
+            .srcMaxBurstWidth           = dmacHw_SRC_BURST_WIDTH_16,
+            .dstMaxBurstWidth           = dmacHw_DST_BURST_WIDTH_16,
+            .transferMode               = dmacHw_TRANSFER_MODE_PERREQUEST,
+            /* on the RX side, SPU needs to be the flow controller */
+            .flowControler              = dmacHw_FLOW_CONTROL_PERIPHERAL,
+        },
+    },
+    [DMA_DEVICE_SPUM_MEM_TO_DEV] = /* SPUM TX */
+    {
+        .flags = DMA_DEVICE_FLAG_ON_DMA0 | DMA_DEVICE_FLAG_ON_DMA1,
+        .name = "spum_tx",
+        .config =
+        {
+            .srcPeripheralPort          = 0, /* SRC: memory */
+            .dstPeripheralPort          = 7, /* DST: SPUM */
+            .srcStatusRegisterAddress   = 0x00000000,
+            .dstStatusRegisterAddress   = 0x00000000,
+            .srcUpdate                  = dmacHw_SRC_ADDRESS_UPDATE_MODE_INC,
+            .dstUpdate                  = dmacHw_DST_ADDRESS_UPDATE_MODE_INC,
+            .transferType               = dmacHw_TRANSFER_TYPE_MEM_TO_PERIPHERAL,
+            .srcMasterInterface         = dmacHw_SRC_MASTER_INTERFACE_1,
+            .dstMasterInterface         = dmacHw_DST_MASTER_INTERFACE_2,
+            .blockTransferInterrupt     = dmacHw_INTERRUPT_DISABLE,
+            .completeTransferInterrupt  = dmacHw_INTERRUPT_ENABLE,
+            .errorInterrupt             = dmacHw_INTERRUPT_ENABLE,
+            .channelPriority            = dmacHw_CHANNEL_PRIORITY_7,
+            .srcMaxTransactionWidth     = dmacHw_SRC_TRANSACTION_WIDTH_32,
+            .dstMaxTransactionWidth     = dmacHw_DST_TRANSACTION_WIDTH_32,
+            /* Busrt size **MUST** be 16 for SPUM to work */
+            .srcMaxBurstWidth           = dmacHw_SRC_BURST_WIDTH_16,
+            .dstMaxBurstWidth           = dmacHw_DST_BURST_WIDTH_16,
+            .transferMode               = dmacHw_TRANSFER_MODE_PERREQUEST,
+        },
+    },
+    [DMA_DEVICE_MEM_TO_VRAM] =
+    {
+        .flags = DMA_DEVICE_FLAG_ON_DMA0 | DMA_DEVICE_FLAG_ON_DMA1,
+        .name = "mem-to-vram",
+        .config =
+        {
+            .srcPeripheralPort          = 0, /* SRC: memory */
+            .srcStatusRegisterAddress   = 0x00000000,
+            .dstStatusRegisterAddress   = 0x00000000,
+            .srcUpdate                  = dmacHw_SRC_ADDRESS_UPDATE_MODE_INC,
+            .dstUpdate                  = dmacHw_DST_ADDRESS_UPDATE_MODE_INC,
+            .transferType               = dmacHw_TRANSFER_TYPE_MEM_TO_MEM,
+            .srcMasterInterface         = dmacHw_SRC_MASTER_INTERFACE_1,
+            .dstMasterInterface         = dmacHw_DST_MASTER_INTERFACE_2,
+            .completeTransferInterrupt  = dmacHw_INTERRUPT_ENABLE,
+            .errorInterrupt             = dmacHw_INTERRUPT_ENABLE,
+            .channelPriority            = dmacHw_CHANNEL_PRIORITY_7,
+            .srcMaxTransactionWidth     = dmacHw_SRC_TRANSACTION_WIDTH_64,
+            .dstMaxTransactionWidth     = dmacHw_DST_TRANSACTION_WIDTH_64,
+            .srcMaxBurstWidth           = dmacHw_SRC_BURST_WIDTH_8,
+            .dstMaxBurstWidth           = dmacHw_DST_BURST_WIDTH_8,
+        },
+    },
+    [DMA_DEVICE_VRAM_TO_MEM] =
+    {
+        .flags = DMA_DEVICE_FLAG_ON_DMA0 | DMA_DEVICE_FLAG_ON_DMA1,
+        .name = "vram-to-mem",
+        .config =
+        {
+            .dstPeripheralPort          = 0, /* DST: memory */
+            .srcStatusRegisterAddress   = 0x00000000,
+            .dstStatusRegisterAddress   = 0x00000000,
+            .srcUpdate                  = dmacHw_SRC_ADDRESS_UPDATE_MODE_INC,
+            .dstUpdate                  = dmacHw_DST_ADDRESS_UPDATE_MODE_INC,
+            .transferType               = dmacHw_TRANSFER_TYPE_MEM_TO_MEM,
+            .srcMasterInterface         = dmacHw_SRC_MASTER_INTERFACE_2,
+            .dstMasterInterface         = dmacHw_DST_MASTER_INTERFACE_1,
+            .completeTransferInterrupt  = dmacHw_INTERRUPT_ENABLE,
+            .errorInterrupt             = dmacHw_INTERRUPT_ENABLE,
+            .channelPriority            = dmacHw_CHANNEL_PRIORITY_7,
+            .srcMaxTransactionWidth     = dmacHw_SRC_TRANSACTION_WIDTH_64,
+            .dstMaxTransactionWidth     = dmacHw_DST_TRANSACTION_WIDTH_64,
+            .srcMaxBurstWidth           = dmacHw_SRC_BURST_WIDTH_8,
+            .dstMaxBurstWidth           = dmacHw_DST_BURST_WIDTH_8,
+        },
+    },
+};
+
+EXPORT_SYMBOL( DMA_gDeviceAttribute );  // primarily for dma-test.c
+
+/* ---- Private Function Prototypes -------------------------------------- */
+
+/* ---- Functions  ------------------------------------------------------- */
+
+/****************************************************************************/
+/**
+*   Displays information for /proc/dma/mem-type
+*/
+/****************************************************************************/
+
+static int dma_proc_read_mem_type( char *buf, char **start, off_t offset, int count, int *eof, void *data)
+{
+    int     len = 0;
+
+    len += sprintf( buf + len, "dma_map_mem statistics\n" );
+    len += sprintf( buf + len, "coherent: %d\n", atomic_read( &gDmaStatMemTypeCoherent ));
+    len += sprintf( buf + len, "kmalloc:  %d\n", atomic_read( &gDmaStatMemTypeKmalloc ));
+    len += sprintf( buf + len, "vmalloc:  %d\n", atomic_read( &gDmaStatMemTypeVmalloc ));
+    len += sprintf( buf + len, "user:     %d\n", atomic_read( &gDmaStatMemTypeUser ));
+
+    return len;
+}
+
+/****************************************************************************/
+/**
+*   Displays information for /proc/dma/channels
+*/
+/****************************************************************************/
+
+static int dma_proc_read_channels( char *buf, char **start, off_t offset, int count, int *eof, void *data)
+{
+    int             controllerIdx;
+    int             channelIdx;
+    int             limit = count - 200;
+    int             len = 0;
+    DMA_Channel_t  *channel;
+
+    if ( down_interruptible( &gDMA.lock ) < 0 )
+    {
+        return -ERESTARTSYS;
+    }
+
+    for ( controllerIdx = 0; controllerIdx < DMA_NUM_CONTROLLERS; controllerIdx++ )
+    {
+        for ( channelIdx = 0; channelIdx < DMA_NUM_CHANNELS; channelIdx++ )
+        {
+            if ( len >= limit )
+            {
+                break;
+            }
+
+            channel = &gDMA.controller[ controllerIdx ].channel[ channelIdx ];
+
+            len += sprintf( buf + len, "%d:%d ", controllerIdx, channelIdx );
+
+            if (( channel->flags & DMA_CHANNEL_FLAG_IS_DEDICATED ) != 0 )
+            {
+                len += sprintf( buf + len, "Dedicated for %s ", DMA_gDeviceAttribute[ channel->devType ].name );
+            }
+            else
+            {
+                len += sprintf( buf + len, "Shared " );
+            }
+
+            if (( channel->flags & DMA_CHANNEL_FLAG_NO_ISR ) != 0 )
+            {
+                len += sprintf( buf + len, "No ISR " );
+            }
+
+            if (( channel->flags & DMA_CHANNEL_FLAG_LARGE_FIFO ) != 0 )
+            {
+                len += sprintf( buf + len, "Fifo: 128 " );
+            }
+            else
+            {
+                len += sprintf( buf + len, "Fifo: 64  " );
+            }
+
+            if (( channel->flags & DMA_CHANNEL_FLAG_IN_USE ) != 0 )
+            {
+                len += sprintf( buf + len, "InUse by %s", DMA_gDeviceAttribute[ channel->devType ].name );
+#if ( DMA_DEBUG_TRACK_RESERVATION )
+                len += sprintf( buf + len, " (%s:%d)", channel->fileName, channel->lineNum );
+#endif
+            }
+            else
+            {
+                len += sprintf( buf + len, "Avail " );
+            }
+
+            if ( channel->lastDevType != DMA_DEVICE_NONE )
+            {
+                len += sprintf( buf + len, "Last use: %s ", DMA_gDeviceAttribute[ channel->lastDevType ].name );
+            }
+
+            len += sprintf( buf + len, "\n" );
+        }
+    }
+    up( &gDMA.lock );
+    *eof = 1;
+
+    return len;
+}
+
+/****************************************************************************/
+/**
+*   Displays information for /proc/dma/devices
+*/
+/****************************************************************************/
+
+static int dma_proc_read_devices( char *buf, char **start, off_t offset, int count, int *eof, void *data)
+{
+    int     limit = count - 200;
+    int     len = 0;
+    int     devIdx;
+
+    if ( down_interruptible( &gDMA.lock ) < 0 )
+    {
+        return -ERESTARTSYS;
+    }
+
+    for ( devIdx = 0; devIdx < DMA_NUM_DEVICE_ENTRIES; devIdx++ )
+    {
+        DMA_DeviceAttribute_t   *devAttr = &DMA_gDeviceAttribute[ devIdx ];
+
+        if ( devAttr->name == NULL )
+        {
+            continue;
+        }
+
+        if ( len >= limit )
+        {
+            break;
+        }
+
+        len += sprintf( buf + len, "%-12s ", devAttr->name );
+
+        if (( devAttr->flags & DMA_DEVICE_FLAG_IS_DEDICATED ) != 0 )
+        {
+            len += sprintf( buf + len, "Dedicated %d:%d ", devAttr->dedicatedController, devAttr->dedicatedChannel );
+        }
+        else
+        {
+            len += sprintf( buf + len, "Shared DMA:" );
+            if (( devAttr->flags & DMA_DEVICE_FLAG_ON_DMA0 ) != 0 )
+            {
+                len += sprintf( buf + len, "0" );
+            }
+            if (( devAttr->flags & DMA_DEVICE_FLAG_ON_DMA1 ) != 0 )
+            {
+                len += sprintf( buf + len, "1" );
+            }
+            len += sprintf( buf + len, " " );
+        }
+        if (( devAttr->flags & DMA_DEVICE_FLAG_NO_ISR ) != 0 )
+        {
+            len += sprintf( buf + len, "NoISR " );
+        }
+        if (( devAttr->flags & DMA_DEVICE_FLAG_ALLOW_LARGE_FIFO ) != 0 )
+        {
+            len += sprintf( buf + len, "Allow-128 " );
+        }
+
+        len += sprintf( buf + len, "Xfer #: %Lu Ticks: %Lu Bytes: %Lu DescLen: %u\n",
+                        devAttr->numTransfers,
+                        devAttr->transferTicks,
+                        devAttr->transferBytes,
+                        devAttr->ring.bytesAllocated );
+
+    }
+
+    up( &gDMA.lock );
+    *eof = 1;
+
+    return len;
+}
+
+/****************************************************************************/
+/**
+*   Determines if a DMA_Device_t is "valid".
+*
+*   @return
+*       TRUE        - dma device is valid
+*       FALSE       - dma device isn't valid
+*/
+/****************************************************************************/
+
+static inline int IsDeviceValid( DMA_Device_t device )
+{
+    return ( device >= 0 ) && ( device < DMA_NUM_DEVICE_ENTRIES );
+}
+
+/****************************************************************************/
+/**
+*   Translates a DMA handle into a pointer to a channel.
+*
+*   @return
+*       non-NULL    - pointer to DMA_Channel_t
+*       NULL        - DMA Handle was invalid
+*/
+/****************************************************************************/
+
+static inline DMA_Channel_t *HandleToChannel( DMA_Handle_t handle )
+{
+    int             controllerIdx;
+    int             channelIdx;
+
+    controllerIdx = CONTROLLER_FROM_HANDLE( handle );
+    channelIdx    = CHANNEL_FROM_HANDLE( handle  );
+
+    if (( controllerIdx > DMA_NUM_CONTROLLERS ) || ( channelIdx > DMA_NUM_CHANNELS ))
+    {
+        return NULL;
+    }
+    return &gDMA.controller[ controllerIdx ].channel[ channelIdx ];
+}
+
+/****************************************************************************/
+/**
+*   Interrupt handler which is called to process DMA interrupts.
+*/
+/****************************************************************************/
+
+static irqreturn_t dma_interrupt_handler( int irq, void *dev_id )
+{
+    DMA_Channel_t          *channel;
+    DMA_DeviceAttribute_t  *devAttr;
+    int                     irqStatus;
+
+    channel = (DMA_Channel_t *)dev_id;
+
+    // Figure out why we were called, and knock down the interrupt
+
+    irqStatus = dmacHw_getInterruptStatus( channel->dmacHwHandle );
+    dmacHw_clearInterrupt( channel->dmacHwHandle );
+
+    if (( channel->devType < 0 ) || ( channel->devType > DMA_NUM_DEVICE_ENTRIES ))
+    {
+        printk( KERN_ERR "dma_interrupt_handler: Invalid devType: %d\n", channel->devType );
+        return IRQ_NONE;
+    }
+    devAttr = &DMA_gDeviceAttribute[ channel->devType ];
+
+#ifdef CONFIG_BCM_KNLLOG_IRQ
+      if (gKnllogIrqSchedEnable & KNLLOG_DMA)
+      {
+         dmacHw_CBLK_t* pCblk = dmacHw_HANDLE_TO_CBLK ( channel->dmacHwHandle );
+         KNLLOG("tstop [%s %u:%u:%u devType=%u bytes=%u]\n",
+            devAttr->name,
+            pCblk->module,
+            pCblk->channel,
+            devAttr->config.channelPriority>>dmacHw_REG_CFG_LO_CH_PRIORITY_SHIFT,
+            channel->devType,
+            devAttr->numBytes);
+      }
+#endif
+
+    // Update stats
+
+    if (( irqStatus & dmacHw_INTERRUPT_STATUS_TRANS ) != 0 )
+    {
+        devAttr->transferTicks += ( timer_get_tick_count() - devAttr->transferStartTime );
+    }
+
+    if (( irqStatus & dmacHw_INTERRUPT_STATUS_ERROR ) != 0 )
+    {
+        printk( KERN_ERR "dma_interrupt_handler: devType :%d DMA error (%s)\n", channel->devType, devAttr->name );
+    }
+    else
+    {
+        devAttr->numTransfers++;
+        devAttr->transferBytes += devAttr->numBytes;
+    }
+
+    // Call any installed handler
+
+    if ( devAttr->devHandler != NULL )
+    {
+        devAttr->devHandler( channel->devType, irqStatus, devAttr->userData );
+    }
+
+    return IRQ_HANDLED;
+}
+
+/****************************************************************************/
+/**
+*   Allocates memory to hold a descriptor ring. The descriptor ring then
+*   needs to be populated by making one or more calls to
+*   dna_add_descriptors.
+*
+*   The returned descriptor ring will be automatically initialized.
+*
+*   @return
+*       0           Descriptor ring was allocated successfully
+*       -EINVAL     Invalid parameters passed in
+*       -ENOMEM     Unable to allocate memory for the desired number of descriptors.
+*/
+/****************************************************************************/
+
+int dma_alloc_descriptor_ring
+(
+    DMA_DescriptorRing_t   *ring,           ///< Descriptor ring to populate
+    int                     numDescriptors  ///< Number of descriptors that need to be allocated.
+)
+{
+    size_t  bytesToAlloc = dmacHw_descriptorLen( numDescriptors );
+
+    if (( ring == NULL ) || ( numDescriptors <= 0 ))
+    {
+        return -EINVAL;
+    }
+
+    ring->physAddr = 0;
+    ring->descriptorsAllocated = 0;
+    ring->bytesAllocated = 0;
+
+    if (( ring->virtAddr = dma_alloc_writecombine( NULL,
+                                                   bytesToAlloc,
+                                                  &ring->physAddr,
+                                                   GFP_KERNEL )) == NULL )
+    {
+        return -ENOMEM;
+    }
+
+    ring->bytesAllocated = bytesToAlloc;
+    ring->descriptorsAllocated = numDescriptors;
+
+    return dma_init_descriptor_ring( ring, numDescriptors );
+}
+EXPORT_SYMBOL( dma_alloc_descriptor_ring );
+
+/****************************************************************************/
+/**
+*   Releases the memory which was previously allocated for a descriptor ring.
+*/
+/****************************************************************************/
+
+void dma_free_descriptor_ring
+(
+    DMA_DescriptorRing_t   *ring           ///< Descriptor to release
+)
+{
+    if ( ring->virtAddr != NULL )
+    {
+        dma_free_writecombine( NULL,
+                               ring->bytesAllocated,
+                               ring->virtAddr,
+                               ring->physAddr );
+    }
+
+    ring->bytesAllocated = 0;
+    ring->descriptorsAllocated = 0;
+    ring->virtAddr = NULL;
+    ring->physAddr = 0;
+}
+EXPORT_SYMBOL( dma_free_descriptor_ring );
+
+/****************************************************************************/
+/**
+*   Initializes a descriptor ring, so that descriptors can be added to it.
+*   Once a descriptor ring has been allocated, it may be reinitialized for
+*   use with additional/different regions of memory.
+*
+*   Note that if 7 descriptors are allocated, it's perfectly acceptable to
+*   initialize the ring with a smaller number of descriptors. The amount
+*   of memory allocated for the descriptor ring will not be reduced, and
+*   the descriptor ring may be reinitialized later
+*
+*   @return
+*       0           Descriptor ring was initialized successfully
+*       -ENOMEM     The descriptor which was passed in has insufficient space
+*                   to hold the desired number of descriptors.
+*/
+/****************************************************************************/
+
+int dma_init_descriptor_ring
+(
+    DMA_DescriptorRing_t   *ring,           ///< Descriptor ring to initialize
+    int                     numDescriptors  ///< Number of descriptors to initialize.
+)
+{
+    if ( ring->virtAddr == NULL )
+    {
+        return -EINVAL;
+    }
+    if ( dmacHw_initDescriptor( ring->virtAddr,
+                                ring->physAddr,
+                                ring->bytesAllocated,
+                                numDescriptors ) < 0 )
+    {
+        printk( KERN_ERR "dma_init_descriptor_ring: dmacHw_initDescriptor failed\n" );
+        return -ENOMEM;
+    }
+
+    return 0;
+}
+EXPORT_SYMBOL( dma_init_descriptor_ring );
+
+/****************************************************************************/
+/**
+*   Determines the number of descriptors which would be required for a
+*   transfer of the indicated memory region.
+*
+*   This function also needs to know which DMA device this transfer will
+*   be destined for, so that the appropriate DMA configuration can be retrieved.
+*   DMA parameters such as transfer width, and whether this is a memory-to-memory
+*   or memory-to-peripheral, etc can all affect the actual number of descriptors
+*   required.
+*
+*   @return
+*       > 0     Returns the number of descriptors required for the indicated transfer
+*       -ENODEV - Device handed in is invalid.
+*       -EINVAL Invalid parameters
+*       -ENOMEM Memory exhausted
+*/
+/****************************************************************************/
+
+int dma_calculate_descriptor_count
+(
+    DMA_Device_t            device,         ///< DMA Device that this will be associated with
+    dma_addr_t              srcData,        ///< Place to get data to write to device
+    dma_addr_t              dstData,        ///< Pointer to device data address
+    size_t                  numBytes        ///< Number of bytes to transfer to the device
+)
+{
+    int                     numDescriptors;
+    DMA_DeviceAttribute_t  *devAttr;
+
+    if ( !IsDeviceValid( device ))
+    {
+        return -ENODEV;
+    }
+    devAttr = &DMA_gDeviceAttribute[ device ];
+
+    if (( numDescriptors = dmacHw_calculateDescriptorCount( &devAttr->config,
+                                                            (void *)srcData,
+                                                            (void *)dstData,
+                                                            numBytes )) < 0 )
+    {
+        printk( KERN_ERR "dma_calculate_descriptor_count: dmacHw_calculateDescriptorCount failed\n" );
+        return -EINVAL;
+    }
+
+    return numDescriptors;
+}
+EXPORT_SYMBOL( dma_calculate_descriptor_count );
+
+/****************************************************************************/
+/**
+*   Adds a region of memory to the descriptor ring. Note that it may take
+*   multiple descriptors for each region of memory. It is the callers
+*   responsibility to allocate a sufficiently large descriptor ring.
+*
+*   @return
+*       0       Descriptors were added successfully
+*       -ENODEV Device handed in is invalid.
+*       -EINVAL Invalid parameters
+*       -ENOMEM Memory exhausted
+*/
+/****************************************************************************/
+
+int dma_add_descriptors
+(
+    DMA_DescriptorRing_t   *ring,           ///< Descriptor ring to add descriptors to
+    DMA_Device_t            device,         ///< DMA Device that descriptors are for
+    dma_addr_t              srcData,        ///< Place to get data (memory or device)
+    dma_addr_t              dstData,        ///< Place to put data (memory or device)
+    size_t                  numBytes        ///< Number of bytes to transfer to the device
+)
+{
+    int rc;
+    DMA_DeviceAttribute_t  *devAttr;
+
+    if ( !IsDeviceValid( device ))
+    {
+        return -ENODEV;
+    }
+    devAttr = &DMA_gDeviceAttribute[ device ];
+
+    rc = dmacHw_setDataDescriptor( &devAttr->config,
+                                   ring->virtAddr,
+                                   (void *)srcData,
+                                   (void *)dstData,
+                                   numBytes );
+    if ( rc < 0 )
+    {
+        printk( KERN_ERR "dma_add_descriptors: dmacHw_setDataDescriptor failed with code: %d\n", rc );
+        return -ENOMEM;
+    }
+
+    return 0;
+}
+EXPORT_SYMBOL( dma_add_descriptors );
+
+/****************************************************************************/
+/**
+*   Sets the descriptor ring associated with a device.
+*
+*   Once set, the descriptor ring will be associated with the device, even
+*   across channel request/free calls. Passing in a NULL descriptor ring
+*   will release any descriptor ring currently associated with the device.
+*
+*   Note: If you call dma_transfer, or one of the other dma_alloc_ functions
+*         the descriptor ring may be released and reallocated.
+*
+*   Note: This function will release the descriptor memory for any current
+*         descriptor ring associated with this device.
+*
+*   @return
+*       0       Descriptors were added successfully
+*       -ENODEV Device handed in is invalid.
+*/
+/****************************************************************************/
+
+int dma_set_device_descriptor_ring
+(
+    DMA_Device_t            device, ///< Device to update the descriptor ring for.
+    DMA_DescriptorRing_t   *ring    ///< Descriptor ring to add descriptors to
+)
+{
+    DMA_DeviceAttribute_t   *devAttr;
+
+    if ( !IsDeviceValid( device ))
+    {
+        return -ENODEV;
+    }
+    devAttr = &DMA_gDeviceAttribute[ device ];
+
+    // Free the previously allocated descriptor ring
+
+    dma_free_descriptor_ring( &devAttr->ring );
+
+    if ( ring != NULL )
+    {
+        // Copy in the new one
+
+        devAttr->ring = *ring;
+    }
+
+    // Set things up so that if dma_transfer is called then this descriptor
+    // ring will get freed.
+
+    devAttr->prevSrcData = 0;
+    devAttr->prevDstData = 0;
+    devAttr->prevNumBytes = 0;
+
+    return 0;
+}
+EXPORT_SYMBOL( dma_set_device_descriptor_ring );
+
+/****************************************************************************/
+/**
+*   Retrieves the descriptor ring associated with a device.
+*
+*   @return
+*       0       Descriptors were added successfully
+*       -ENODEV Device handed in is invalid.
+*/
+/****************************************************************************/
+
+int dma_get_device_descriptor_ring
+(
+    DMA_Device_t            device, ///< Device to retrieve the descriptor ring for.
+    DMA_DescriptorRing_t   *ring    ///< Place to store retrieved ring
+)
+{
+    DMA_DeviceAttribute_t   *devAttr;
+
+    memset( ring, 0, sizeof( *ring ));
+
+    if ( !IsDeviceValid( device ))
+    {
+        return -ENODEV;
+    }
+    devAttr = &DMA_gDeviceAttribute[ device ];
+
+    *ring = devAttr->ring;
+
+    return 0;
+}
+EXPORT_SYMBOL( dma_get_device_descriptor_ring );
+
+/****************************************************************************/
+/**
+*   Configures a DMA channel.
+*
+*   @return
+*       >= 0    - Initialization was successfull.
+*
+*       -EBUSY  - Device is currently being used.
+*       -ENODEV - Device handed in is invalid.
+*/
+/****************************************************************************/
+
+static int ConfigChannel( DMA_Handle_t handle )
+{
+    DMA_Channel_t          *channel;
+    DMA_DeviceAttribute_t  *devAttr;
+    int                     controllerIdx;
+
+    if (( channel = HandleToChannel( handle )) == NULL )
+    {
+        return -ENODEV;
+    }
+    devAttr = &DMA_gDeviceAttribute[ channel->devType ];
+    controllerIdx = CONTROLLER_FROM_HANDLE( handle );
+
+    if (( devAttr->flags & DMA_DEVICE_FLAG_PORT_PER_DMAC ) != 0 )
+    {
+        if ( devAttr->config.transferType == dmacHw_TRANSFER_TYPE_MEM_TO_PERIPHERAL )
+        {
+            devAttr->config.dstPeripheralPort = devAttr->dmacPort[ controllerIdx ];
+        }
+        else
+        if ( devAttr->config.transferType == dmacHw_TRANSFER_TYPE_PERIPHERAL_TO_MEM )
+        {
+            devAttr->config.srcPeripheralPort = devAttr->dmacPort[ controllerIdx ];
+        }
+    }
+
+    if ( dmacHw_configChannel( channel->dmacHwHandle, &devAttr->config ) != 0 )
+    {
+        printk( KERN_ERR "ConfigChannel: dmacHw_configChannel failed\n" );
+        return -EIO;
+    }
+
+    return 0;
+}
+
+/****************************************************************************/
+/**
+*   Intializes all of the data structures associated with the DMA.
+*   @return
+*       >= 0    - Initialization was successfull.
+*
+*       -EBUSY  - Device is currently being used.
+*       -ENODEV - Device handed in is invalid.
+*/
+/****************************************************************************/
+
+int dma_init( void )
+{
+    int             rc = 0;
+    int             controllerIdx;
+    int             channelIdx;
+    DMA_Device_t    devIdx;
+    DMA_Channel_t  *channel;
+    DMA_Handle_t    dedicatedHandle;
+
+    memset( &gDMA, 0, sizeof( gDMA ));
+
+    init_MUTEX_LOCKED( &gDMA.lock );
+    init_waitqueue_head( &gDMA.freeChannelQ );
+
+    // Initialize the Hardware
+
+    dmacHw_initDma();
+
+    // Start off by marking all of the DMA channels as shared.
+
+    for ( controllerIdx = 0; controllerIdx < DMA_NUM_CONTROLLERS; controllerIdx++ )
+    {
+        for ( channelIdx = 0; channelIdx < DMA_NUM_CHANNELS; channelIdx++ )
+        {
+            channel = &gDMA.controller[ controllerIdx ].channel[ channelIdx ];
+
+            channel->flags = 0;
+            channel->devType = DMA_DEVICE_NONE;
+            channel->lastDevType = DMA_DEVICE_NONE;
+
+#if ( DMA_DEBUG_TRACK_RESERVATION )
+            channel->fileName = "";
+            channel->lineNum = 0;
+#endif
+
+            channel->dmacHwHandle = dmacHw_getChannelHandle( dmacHw_MAKE_CHANNEL_ID( controllerIdx, channelIdx ));
+            dmacHw_initChannel( channel->dmacHwHandle );
+        }
+    }
+
+    // Record any special attributes that channels may have
+
+    gDMA.controller[0].channel[0].flags |= DMA_CHANNEL_FLAG_LARGE_FIFO;
+    gDMA.controller[0].channel[1].flags |= DMA_CHANNEL_FLAG_LARGE_FIFO;
+    gDMA.controller[1].channel[0].flags |= DMA_CHANNEL_FLAG_LARGE_FIFO;
+    gDMA.controller[1].channel[1].flags |= DMA_CHANNEL_FLAG_LARGE_FIFO;
+
+    // Now walk through and record the dedicated channels.
+
+    for ( devIdx = 0; devIdx < DMA_NUM_DEVICE_ENTRIES; devIdx++ )
+    {
+        DMA_DeviceAttribute_t *devAttr = &DMA_gDeviceAttribute[ devIdx ];
+
+        if ((( devAttr->flags & DMA_DEVICE_FLAG_NO_ISR ) != 0 )
+        &&  (( devAttr->flags & DMA_DEVICE_FLAG_IS_DEDICATED ) == 0 ))
+        {
+            printk( KERN_ERR "DMA Device: %s Can only request NO_ISR for dedicated devices\n", devAttr->name );
+            rc = -EINVAL;
+            goto out;
+        }
+
+        if (( devAttr->flags & DMA_DEVICE_FLAG_IS_DEDICATED ) != 0 )
+        {
+            // This is a dedicated device. Mark the channel as being reserved.
+
+            if ( devAttr->dedicatedController >= DMA_NUM_CONTROLLERS )
+            {
+                printk( KERN_ERR "DMA Device: %s DMA Controller %d is out of range\n",
+                        devAttr->name, devAttr->dedicatedController );
+                rc = -EINVAL;
+                goto out;
+            }
+
+            if ( devAttr->dedicatedChannel >= DMA_NUM_CHANNELS )
+            {
+                printk( KERN_ERR "DMA Device: %s DMA Channel %d is out of range\n",
+                        devAttr->name, devAttr->dedicatedChannel );
+                rc = -EINVAL;
+                goto out;
+            }
+
+            dedicatedHandle = MAKE_HANDLE( devAttr->dedicatedController, devAttr->dedicatedChannel );
+            channel = HandleToChannel( dedicatedHandle );
+
+            if (( channel->flags & DMA_CHANNEL_FLAG_IS_DEDICATED ) != 0 )
+            {
+                printk( "DMA Device: %s attempting to use same DMA Controller:Channel (%d:%d) as %s\n",
+                        devAttr->name, devAttr->dedicatedController, devAttr->dedicatedChannel,
+                        DMA_gDeviceAttribute[ channel->devType ].name );
+                rc = -EBUSY;
+                goto out;
+            }
+
+            channel->flags |= DMA_CHANNEL_FLAG_IS_DEDICATED;
+            channel->devType = devIdx;
+
+            if ( devAttr->flags & DMA_DEVICE_FLAG_NO_ISR )
+            {
+                channel->flags |= DMA_CHANNEL_FLAG_NO_ISR;
+            }
+
+            // For dedicated channels, we can go ahead and configure the DMA channel now
+            // as well.
+
+            ConfigChannel( dedicatedHandle );
+        }
+    }
+
+    // Go through and register the interrupt handlers
+
+    for ( controllerIdx = 0; controllerIdx < DMA_NUM_CONTROLLERS; controllerIdx++ )
+    {
+        for ( channelIdx = 0; channelIdx < DMA_NUM_CHANNELS; channelIdx++ )
+        {
+            channel = &gDMA.controller[ controllerIdx ].channel[ channelIdx ];
+
+            if (( channel->flags & DMA_CHANNEL_FLAG_NO_ISR ) == 0 )
+            {
+                snprintf( channel->name, sizeof( channel->name ), "dma %d:%d %s", controllerIdx, channelIdx,
+                          channel->devType == DMA_DEVICE_NONE ? "" : DMA_gDeviceAttribute[ channel->devType ].name );
+
+                if (( rc = request_irq( IRQ_DMA0C0 + ( controllerIdx * DMA_NUM_CHANNELS ) + channelIdx,
+                                        dma_interrupt_handler,
+                                        IRQF_DISABLED, channel->name, channel )) != 0 )
+                {
+                    printk( KERN_ERR "request_irq for IRQ_DMA%dC%d failed\n", controllerIdx, channelIdx );
+                }
+            }
+        }
+    }
+
+    // Create /proc/dma/channels and /proc/dma/devices
+
+    gDmaDir = create_proc_entry( "dma", S_IFDIR | S_IRUGO | S_IXUGO, NULL );
+
+    if ( gDmaDir == NULL )
+    {
+        printk( KERN_ERR "Unable to create /proc/dma\n" );
+    }
+    else
+    {
+        create_proc_read_entry( "channels", 0, gDmaDir, dma_proc_read_channels, NULL );
+        create_proc_read_entry( "devices",  0, gDmaDir, dma_proc_read_devices,  NULL );
+        create_proc_read_entry( "mem-type", 0, gDmaDir, dma_proc_read_mem_type,  NULL );
+    }
+
+out:
+
+    up( &gDMA.lock );
+
+    return rc;
+}
+
+/****************************************************************************/
+/**
+*   Reserves a channel for use with @a dev. If the device is setup to use
+*   a shared channel, then this function will block until a free channel
+*   becomes available.
+*
+*   @return
+*       >= 0    - A valid DMA Handle.
+*       -EBUSY  - Device is currently being used.
+*       -ENODEV - Device handed in is invalid.
+*/
+/****************************************************************************/
+
+#if ( DMA_DEBUG_TRACK_RESERVATION )
+DMA_Handle_t dma_request_channel_dbg
+(
+    DMA_Device_t    dev,
+    const char     *fileName,
+    int             lineNum
+)
+#else
+DMA_Handle_t dma_request_channel
+(
+    DMA_Device_t dev
+)
+#endif
+{
+    DMA_Handle_t            handle;
+    DMA_DeviceAttribute_t  *devAttr;
+    DMA_Channel_t          *channel;
+    int                     controllerIdx;
+    int                     controllerIdx2;
+    int                     channelIdx;
+
+    if ( down_interruptible( &gDMA.lock ) < 0 )
+    {
+        return -ERESTARTSYS;
+    }
+
+    if (( dev < 0 ) || ( dev >= DMA_NUM_DEVICE_ENTRIES ))
+    {
+        handle = -ENODEV;
+        goto out;
+    }
+    devAttr = &DMA_gDeviceAttribute[ dev ];
+
+#if ( DMA_DEBUG_TRACK_RESERVATION )
+     {
+        char *s;
+
+        if (( s = strrchr( fileName, '/' )) != NULL )
+        {
+           fileName = s+1;
+        }
+     }
+#endif
+    if (( devAttr->flags & DMA_DEVICE_FLAG_IN_USE ) != 0 )
+    {
+        // This device has already been requested and not been freed
+
+        printk( KERN_ERR "%s: device %s is already requested\n", __func__, devAttr->name );
+        handle = -EBUSY;
+        goto out;
+    }
+
+    if (( devAttr->flags & DMA_DEVICE_FLAG_IS_DEDICATED ) != 0 )
+    {
+        // This device has a dedicated channel.
+
+        channel = &gDMA.controller[ devAttr->dedicatedController ].channel[ devAttr->dedicatedChannel ];
+        if (( channel->flags & DMA_CHANNEL_FLAG_IN_USE ) != 0 )
+        {
+            handle = -EBUSY;
+            goto out;
+        }
+
+        channel->flags |= DMA_CHANNEL_FLAG_IN_USE;
+        devAttr->flags |= DMA_DEVICE_FLAG_IN_USE;
+
+#if ( DMA_DEBUG_TRACK_RESERVATION )
+        channel->fileName = fileName;
+        channel->lineNum = lineNum;
+#endif
+        handle = MAKE_HANDLE( devAttr->dedicatedController, devAttr->dedicatedChannel );
+        goto out;
+    }
+
+    // This device needs to use one of the shared channels.
+
+    handle = DMA_INVALID_HANDLE;
+    while ( handle == DMA_INVALID_HANDLE )
+    {
+        // Scan through the shared channels and see if one is available
+
+        for ( controllerIdx2 = 0; controllerIdx2 < DMA_NUM_CONTROLLERS; controllerIdx2++ )
+        {
+            // Check to see if we should try on controller 1 first.
+
+            controllerIdx = controllerIdx2;
+            if (( devAttr->flags & DMA_DEVICE_FLAG_ALLOC_DMA1_FIRST ) != 0 )
+            {
+                controllerIdx = 1 - controllerIdx;
+            }
+
+            // See if the device is available on the controller being tested
+
+            if (( devAttr->flags & ( DMA_DEVICE_FLAG_ON_DMA0 << controllerIdx )) != 0 )
+            {
+                for ( channelIdx = 0; channelIdx < DMA_NUM_CHANNELS; channelIdx++ )
+                {
+                    channel = &gDMA.controller[ controllerIdx ].channel[ channelIdx ];
+
+                    if ((( channel->flags & DMA_CHANNEL_FLAG_IS_DEDICATED ) == 0 )
+                    &&  (( channel->flags & DMA_CHANNEL_FLAG_IN_USE ) == 0 ))
+                    {
+                        if ((( channel->flags & DMA_CHANNEL_FLAG_LARGE_FIFO ) != 0 )
+                        &&  (( devAttr->flags & DMA_DEVICE_FLAG_ALLOW_LARGE_FIFO ) == 0 ))
+                        {
+                            // This channel is a large fifo - don't tie it up
+                            // with devices that we don't want using it.
+
+                            continue;
+                        }
+
+                        channel->flags |= DMA_CHANNEL_FLAG_IN_USE;
+                        channel->devType = dev;
+                        devAttr->flags |= DMA_DEVICE_FLAG_IN_USE;
+
+#if ( DMA_DEBUG_TRACK_RESERVATION )
+                        channel->fileName = fileName;
+                        channel->lineNum = lineNum;
+#endif
+                        handle = MAKE_HANDLE( controllerIdx, channelIdx );
+
+                        // Now that we've reserved the channel - we can go ahead and configure it
+
+
+                        if ( ConfigChannel( handle ) != 0 )
+                        {
+                            handle = -EIO;
+                            printk( KERN_ERR "dma_request_channel: ConfigChannel failed\n" );
+                        }
+                        goto out;
+                    }
+                }
+            }
+        }
+
+        // No channels are currently available. Let's wait for one to free up.
+
+        {
+            DEFINE_WAIT( wait );
+
+            prepare_to_wait( &gDMA.freeChannelQ, &wait, TASK_INTERRUPTIBLE );
+            up( &gDMA.lock );
+            schedule();
+            finish_wait( &gDMA.freeChannelQ, &wait );
+
+            if (signal_pending(current))
+            {
+                // We don't currently hold gDMA.lock, so we return directly
+
+                return -ERESTARTSYS;
+            }
+        }
+
+        if ( down_interruptible( &gDMA.lock ))
+        {
+            return -ERESTARTSYS;
+        }
+    }
+
+out:
+    up( &gDMA.lock );
+
+    return handle;
+}
+
+// Create both _dbg and non _dbg functions for modules.
+
+#if ( DMA_DEBUG_TRACK_RESERVATION )
+#undef dma_request_channel
+DMA_Handle_t dma_request_channel
+(
+    DMA_Device_t dev
+)
+{
+    return dma_request_channel_dbg( dev, __FILE__, __LINE__ );
+}
+
+EXPORT_SYMBOL( dma_request_channel_dbg );
+#endif
+EXPORT_SYMBOL( dma_request_channel );
+
+/****************************************************************************/
+/**
+*   Frees a previously allocated DMA Handle.
+*/
+/****************************************************************************/
+
+int dma_free_channel
+(
+    DMA_Handle_t handle    ///< DMA handle.
+)
+{
+    int                     rc = 0;
+    DMA_Channel_t          *channel;
+    DMA_DeviceAttribute_t  *devAttr;
+
+    if ( down_interruptible( &gDMA.lock ) < 0 )
+    {
+        return -ERESTARTSYS;
+    }
+
+    if (( channel = HandleToChannel( handle )) == NULL )
+    {
+        rc = -EINVAL;
+        goto out;
+    }
+
+    devAttr = &DMA_gDeviceAttribute[ channel->devType ];
+
+    if (( channel->flags & DMA_CHANNEL_FLAG_IS_DEDICATED ) == 0 )
+    {
+        channel->lastDevType = channel->devType;
+        channel->devType = DMA_DEVICE_NONE;
+    }
+    channel->flags &= ~DMA_CHANNEL_FLAG_IN_USE;
+    devAttr->flags &= ~DMA_DEVICE_FLAG_IN_USE;
+
+out:
+    up( &gDMA.lock );
+
+    wake_up_interruptible( &gDMA.freeChannelQ );
+
+    return rc;
+}
+EXPORT_SYMBOL( dma_free_channel );
+
+/****************************************************************************/
+/**
+*   Determines if a given device has been configured as using a shared
+*   channel.
+*
+*   @return
+*       0           Device uses a dedicated channel
+*       > zero      Device uses a shared channel
+*       < zero      Error code
+*/
+/****************************************************************************/
+
+int dma_device_is_channel_shared
+(
+    DMA_Device_t device     ///< Device to check.
+)
+{
+    DMA_DeviceAttribute_t  *devAttr;
+
+    if ( !IsDeviceValid( device ))
+    {
+        return -ENODEV;
+    }
+    devAttr = &DMA_gDeviceAttribute[ device ];
+
+    return (( devAttr->flags & DMA_DEVICE_FLAG_IS_DEDICATED ) == 0 );
+}
+EXPORT_SYMBOL( dma_device_is_channel_shared );
+
+/****************************************************************************/
+/**
+*   Allocates buffers for the descriptors. This is normally done automatically
+*   but needs to be done explicitly when initiating a dma from interrupt
+*   context.
+*
+*   @return
+*       0       Descriptors were allocated successfully
+*       -EINVAL Invalid device type for this kind of transfer
+*               (i.e. the device is _MEM_TO_DEV and not _DEV_TO_MEM)
+*       -ENOMEM Memory exhausted
+*/
+/****************************************************************************/
+
+int dma_alloc_descriptors
+(
+    DMA_Handle_t            handle,         ///< DMA Handle
+    dmacHw_TRANSFER_TYPE_e  transferType,   ///< Type of transfer being performed
+    dma_addr_t              srcData,        ///< Place to get data to write to device
+    dma_addr_t              dstData,        ///< Pointer to device data address
+    size_t                  numBytes        ///< Number of bytes to transfer to the device
+)
+{
+    DMA_Channel_t          *channel;
+    DMA_DeviceAttribute_t  *devAttr;
+    int                     numDescriptors;
+    size_t                  ringBytesRequired;
+    int                     rc = 0;
+
+    if (( channel = HandleToChannel( handle )) == NULL )
+    {
+        return -ENODEV;
+    }
+
+    devAttr = &DMA_gDeviceAttribute[ channel->devType ];
+
+    if ( devAttr->config.transferType != transferType )
+    {
+        return -EINVAL;
+    }
+
+    // Figure out how many descriptors we need.
+
+    //printk( "srcData: 0x%08x dstData: 0x%08x, numBytes: %d\n",
+    //        srcData, dstData, numBytes );
+
+    if (( numDescriptors = dmacHw_calculateDescriptorCount( &devAttr->config,
+                                                            (void *)srcData,
+                                                            (void *)dstData,
+                                                            numBytes )) < 0 )
+    {
+        printk( KERN_ERR "%s: dmacHw_calculateDescriptorCount failed\n", __func__ );
+        return -EINVAL;
+    }
+
+    // Check to see if we can reuse the existing descriptor ring, or if we need to allocate
+    // a new one.
+
+    ringBytesRequired = dmacHw_descriptorLen( numDescriptors );
+
+    //printk( "ringBytesRequired: %d\n", ringBytesRequired );
+
+    if ( ringBytesRequired > devAttr->ring.bytesAllocated )
+    {
+        // Make sure that this code path is never taken from interrupt context.
+        // It's OK for an interrupt to initiate a DMA transfer, but the descriptor
+        // allocation needs to have already been done.
+
+        might_sleep();
+
+        // Free the old descriptor ring and allocate a new one.
+
+        dma_free_descriptor_ring( &devAttr->ring );
+
+        // And allocate a new one.
+
+        if (( rc = dma_alloc_descriptor_ring( &devAttr->ring, numDescriptors )) < 0 )
+        {
+            printk( KERN_ERR "%s: dma_alloc_descriptor_ring( %d ) failed\n", __func__, numDescriptors );
+            return rc;
+        }
+        // Setup the descriptor for this transfer
+
+        if ( dmacHw_initDescriptor( devAttr->ring.virtAddr,
+                                    devAttr->ring.physAddr,
+                                    devAttr->ring.bytesAllocated,
+                                    numDescriptors ) < 0 )
+        {
+           printk( KERN_ERR "%s: dmacHw_initDescriptor failed\n", __func__ );
+           return -EINVAL;
+        }
+    }
+    else
+    {
+        // We've already got enough ring buffer allocated. All we need to do is reset
+        // any control information, just in case the previous DMA was stopped.
+
+        dmacHw_resetDescriptorControl( devAttr->ring.virtAddr );
+    }
+
+    // dma_alloc/free both set the prevSrc/DstData to 0. If they happen to be the same
+    // as last time, then we don't need to call setDataDescriptor again.
+
+    if ( dmacHw_setDataDescriptor( &devAttr->config,
+                                   devAttr->ring.virtAddr,
+                                   (void *)srcData,
+                                   (void *)dstData,
+                                   numBytes ) < 0 )
+    {
+        printk( KERN_ERR "%s: dmacHw_setDataDescriptor failed\n", __func__ );
+        return -EINVAL;
+    }
+
+    // Remember the critical information for this transfer so that we can eliminate
+    // another call to dma_alloc_descriptors if the caller reuses the same buffers
+
+    devAttr->prevSrcData = srcData;
+    devAttr->prevDstData = dstData;
+    devAttr->prevNumBytes = numBytes;
+
+    return 0;
+}
+EXPORT_SYMBOL( dma_alloc_descriptors );
+
+/****************************************************************************/
+/**
+*   Allocates and sets up descriptors for a double buffered circular buffer.
+*
+*   This is primarily intended to be used for things like the ingress samples
+*   from a microphone.
+*
+*   @return
+*       > 0     Number of descriptors actually allocated.
+*       -EINVAL Invalid device type for this kind of transfer
+*               (i.e. the device is _MEM_TO_DEV and not _DEV_TO_MEM)
+*       -ENOMEM Memory exhausted
+*/
+/****************************************************************************/
+
+int dma_alloc_double_dst_descriptors
+(
+    DMA_Handle_t            handle,         ///< DMA Handle
+    dma_addr_t              srcData,        ///< Physical address of source data
+    dma_addr_t              dstData1,       ///< Physical address of first destination buffer
+    dma_addr_t              dstData2,       ///< Physical address of second destination buffer
+    size_t                  numBytes        ///< Number of bytes in each destination buffer
+)
+{
+    DMA_Channel_t          *channel;
+    DMA_DeviceAttribute_t  *devAttr;
+    int                     numDst1Descriptors;
+    int                     numDst2Descriptors;
+    int                     numDescriptors;
+    size_t                  ringBytesRequired;
+    int                     rc = 0;
+
+    if (( channel = HandleToChannel( handle )) == NULL )
+    {
+        return -ENODEV;
+    }
+
+    devAttr = &DMA_gDeviceAttribute[ channel->devType ];
+
+    // Figure out how many descriptors we need.
+
+    //printk( "srcData: 0x%08x dstData: 0x%08x, numBytes: %d\n",
+    //        srcData, dstData, numBytes );
+
+    if (( numDst1Descriptors = dmacHw_calculateDescriptorCount( &devAttr->config,
+                                                                (void *)srcData,
+                                                                (void *)dstData1,
+                                                                numBytes )) < 0 )
+    {
+        return -EINVAL;
+    }
+    if (( numDst2Descriptors = dmacHw_calculateDescriptorCount( &devAttr->config,
+                                                                (void *)srcData,
+                                                                (void *)dstData2,
+                                                                numBytes )) < 0 )
+    {
+        return -EINVAL;
+    }
+    numDescriptors = numDst1Descriptors + numDst2Descriptors;
+    //printk( "numDescriptors: %d\n", numDescriptors );
+
+    // Check to see if we can reuse the existing descriptor ring, or if we need to allocate
+    // a new one.
+
+    ringBytesRequired = dmacHw_descriptorLen( numDescriptors );
+
+    //printk( "ringBytesRequired: %d\n", ringBytesRequired );
+
+    if ( ringBytesRequired > devAttr->ring.bytesAllocated )
+    {
+        // Make sure that this code path is never taken from interrupt context.
+        // It's OK for an interrupt to initiate a DMA transfer, but the descriptor
+        // allocation needs to have already been done.
+
+        might_sleep();
+
+        // Free the old descriptor ring and allocate a new one.
+
+        dma_free_descriptor_ring( &devAttr->ring );
+
+        // And allocate a new one.
+
+        if (( rc = dma_alloc_descriptor_ring( &devAttr->ring, numDescriptors )) < 0 )
+        {
+            printk( KERN_ERR "%s: dma_alloc_descriptor_ring( %d ) failed\n", __func__, ringBytesRequired );
+            return rc;
+        }
+    }
+
+    // Setup the descriptor for this transfer. Since this function is used with
+    // CONTINUOUS DMA operations, we need to reinitialize every time, otherwise
+    // setDataDescriptor will keep trying to append onto the end.
+
+    if ( dmacHw_initDescriptor( devAttr->ring.virtAddr,
+                                devAttr->ring.physAddr,
+                                devAttr->ring.bytesAllocated,
+                                numDescriptors ) < 0 )
+    {
+       printk( KERN_ERR "%s: dmacHw_initDescriptor failed\n", __func__ );
+       return -EINVAL;
+    }
+
+    // dma_alloc/free both set the prevSrc/DstData to 0. If they happen to be the same
+    // as last time, then we don't need to call setDataDescriptor again.
+
+    if ( dmacHw_setDataDescriptor( &devAttr->config,
+                                   devAttr->ring.virtAddr,
+                                   (void *)srcData,
+                                   (void *)dstData1,
+                                   numBytes ) < 0 )
+    {
+        printk( KERN_ERR "%s: dmacHw_setDataDescriptor 1 failed\n", __func__ );
+        return -EINVAL;
+    }
+    if ( dmacHw_setDataDescriptor( &devAttr->config,
+                                   devAttr->ring.virtAddr,
+                                   (void *)srcData,
+                                   (void *)dstData2,
+                                   numBytes ) < 0 )
+    {
+        printk( KERN_ERR "%s: dmacHw_setDataDescriptor 2 failed\n", __func__ );
+        return -EINVAL;
+    }
+
+    // You should use dma_start_transfer rather than dma_transfer_xxx so we don't
+    // try to make the 'prev' variables right.
+
+    devAttr->prevSrcData = 0;
+    devAttr->prevDstData = 0;
+    devAttr->prevNumBytes = 0;
+
+    return numDescriptors;
+}
+EXPORT_SYMBOL( dma_alloc_double_dst_descriptors );
+
+/****************************************************************************/
+/**
+*   Initiates a transfer when the descriptors have already been setup.
+*
+*   This is a special case, and normally, the dma_transfer_xxx functions should
+*   be used.
+*
+*   @return
+*       0       Transfer was started successfully
+*       -ENODEV Invalid handle
+*/
+/****************************************************************************/
+
+int dma_start_transfer( DMA_Handle_t handle )
+{
+    DMA_Channel_t          *channel;
+    DMA_DeviceAttribute_t  *devAttr;
+
+    if (( channel = HandleToChannel( handle )) == NULL )
+    {
+        return -ENODEV;
+    }
+    devAttr = &DMA_gDeviceAttribute[ channel->devType ];
+
+    dmacHw_initiateTransfer( channel->dmacHwHandle, &devAttr->config, devAttr->ring.virtAddr );
+
+    // Since we got this far, everything went successfully
+
+    return 0;
+}
+EXPORT_SYMBOL( dma_start_transfer );
+
+/****************************************************************************/
+/**
+*   Stops a previously started DMA transfer.
+*
+*   @return
+*       0       Transfer was stopped successfully
+*       -ENODEV Invalid handle
+*/
+/****************************************************************************/
+
+int dma_stop_transfer( DMA_Handle_t handle )
+{
+    DMA_Channel_t          *channel;
+
+    if (( channel = HandleToChannel( handle )) == NULL )
+    {
+        return -ENODEV;
+    }
+
+    dmacHw_stopTransfer( channel->dmacHwHandle );
+
+    return 0;
+}
+EXPORT_SYMBOL( dma_stop_transfer );
+
+/****************************************************************************/
+/**
+*   Waits for a DMA to complete by polling. This function is only intended
+*   to be used for testing. Interrupts should be used for most DMA operations.
+*/
+/****************************************************************************/
+
+int dma_wait_transfer_done( DMA_Handle_t handle )
+{
+    DMA_Channel_t              *channel;
+    dmacHw_TRANSFER_STATUS_e    status;
+
+    if (( channel = HandleToChannel( handle )) == NULL )
+    {
+        return -ENODEV;
+    }
+
+    while (( status = dmacHw_transferCompleted( channel->dmacHwHandle )) == dmacHw_TRANSFER_STATUS_BUSY )
+    {
+        ;
+    }
+
+    if ( status == dmacHw_TRANSFER_STATUS_ERROR )
+    {
+        printk( KERN_ERR "%s: DMA transfer failed\n", __func__ );
+        return -EIO;
+    }
+    return 0;
+}
+EXPORT_SYMBOL( dma_wait_transfer_done );
+
+/****************************************************************************/
+/**
+*   Initiates a DMA, allocating the descriptors as required.
+*
+*   @return
+*       0       Transfer was started successfully
+*       -EINVAL Invalid device type for this kind of transfer
+*               (i.e. the device is _DEV_TO_MEM and not _MEM_TO_DEV)
+*/
+/****************************************************************************/
+
+int dma_transfer
+(
+    DMA_Handle_t            handle,         ///< DMA Handle
+    dmacHw_TRANSFER_TYPE_e  transferType,   ///< Type of transfer being performed
+    dma_addr_t              srcData,        ///< Place to get data to write to device
+    dma_addr_t              dstData,        ///< Pointer to device data address
+    size_t                  numBytes        ///< Number of bytes to transfer to the device
+)
+{
+    DMA_Channel_t          *channel;
+    DMA_DeviceAttribute_t  *devAttr;
+    int                     rc = 0;
+
+    if (( channel = HandleToChannel( handle )) == NULL )
+    {
+        return -ENODEV;
+    }
+
+    devAttr = &DMA_gDeviceAttribute[ channel->devType ];
+
+    if ( devAttr->config.transferType != transferType )
+    {
+        return -EINVAL;
+    }
+
+    // We keep track of the information about the previous request for this
+    // device, and if the attributes match, then we can use the descriptors we setup
+    // the last time, and not have to reinitialize everything.
+
+#if 0
+    if (( numBytes != devAttr->prevNumBytes )
+    ||  ( srcData  != devAttr->prevSrcData )
+    ||  ( dstData  != devAttr->prevDstData ))
+#endif
+    {
+        if (( rc = dma_alloc_descriptors( handle, transferType, srcData, dstData, numBytes )) != 0 )
+        {
+            return rc;
+        }
+    }
+
+    // And kick off the transfer
+
+    devAttr->numBytes = numBytes;
+    devAttr->transferStartTime = timer_get_tick_count();
+
+#ifdef CONFIG_BCM_KNLLOG_IRQ
+      if (gKnllogIrqSchedEnable & KNLLOG_DMA)
+      {
+         dmacHw_CBLK_t* pCblk = dmacHw_HANDLE_TO_CBLK ( channel->dmacHwHandle );
+         KNLLOG("tstart [%s %u:%u:%u devType=%u bytes=%u]\n",
+            devAttr->name,
+            pCblk->module,
+            pCblk->channel,
+            devAttr->config.channelPriority>>dmacHw_REG_CFG_LO_CH_PRIORITY_SHIFT,
+            channel->devType,
+            devAttr->numBytes);
+      }
+#endif
+    dmacHw_initiateTransfer( channel->dmacHwHandle, &devAttr->config, devAttr->ring.virtAddr );
+
+    // Since we got this far, everything went successfully
+
+    return 0;
+}
+EXPORT_SYMBOL( dma_transfer );
+
+/****************************************************************************/
+/**
+*   Set the callback function which will be called when a transfer completes.
+*   If a NULL callback function is set, then no callback will occur.
+*
+*   @note   @a devHandler will be called from IRQ context.
+*
+*   @return
+*       0       - Success
+*       -ENODEV - Device handed in is invalid.
+*/
+/****************************************************************************/
+
+int dma_set_device_handler
+(
+    DMA_Device_t         dev,           ///< Device to set the callback for.
+    DMA_DeviceHandler_t  devHandler,    ///< Function to call when the DMA completes
+    void                *userData       ///< Pointer which will be passed to devHandler.
+)
+{
+    DMA_DeviceAttribute_t  *devAttr;
+    unsigned long           flags;
+
+    if ( !IsDeviceValid( dev ))
+    {
+        return -ENODEV;
+    }
+    devAttr = &DMA_gDeviceAttribute[ dev ];
+
+    local_irq_save( flags);
+
+    devAttr->userData   = userData;
+    devAttr->devHandler = devHandler;
+
+    local_irq_restore( flags );
+
+    return 0;
+}
+EXPORT_SYMBOL( dma_set_device_handler );
+
+/****************************************************************************/
+/**
+*   Initializes a memory mapping structure
+*/
+/****************************************************************************/
+
+int dma_init_mem_map( DMA_MemMap_t *memMap )
+{
+    memset( memMap, 0, sizeof( *memMap ));
+
+    init_MUTEX( &memMap->lock );
+
+    return 0;
+}
+EXPORT_SYMBOL( dma_init_mem_map );
+
+/****************************************************************************/
+/**
+*   Releases any memory currently being held by a memory mapping structure.
+*/
+/****************************************************************************/
+
+int dma_term_mem_map( DMA_MemMap_t *memMap )
+{
+    down( &memMap->lock );  // Just being paranoid
+
+    // Free up any allocated memory
+
+    //...
+
+    up( &memMap->lock );
+    memset( memMap, 0, sizeof( *memMap ));
+
+    return 0;
+}
+EXPORT_SYMBOL( dma_term_mem_map );
+
+#if 0
+/****************************************************************************/
+/**
+*   Helper function which maps in a vmalloc'd reagion of memory
+*
+*   @return
+*/
+/****************************************************************************/
+
+static int dma_map_mem_vmalloc( DMA_MemMap_t *memMap, uint8_t *mem, size_t count, enum dma_data_direction dir )
+{
+    int             numPages;
+    size_t          bytesRemaining;
+    DMA_Segment_t  *segment;
+    DMA_Segment_t  *endSegment;
+
+    numPages = ( count + offset + PAGE_SIZE - 1 ) >> PAGE_SHIFT;
+
+    // Run through the pages and figure out the physical address for each page, and amalgamate
+    // pages which are next to each other.
+
+    if ( numPages > memMap->numSegmentsAllocated )
+    {
+        kfree( memMap->segment );
+        if (( memMap->segment = kmalloc( numPages * sizeof( memMap->segment[0] ), GFP_KERNEL )) == NULL )
+        {
+            return -ENOMEM;
+        }
+        memMap->numSegmentsAllocated = numPages;
+    }
+
+    segment = memMap->segment;
+
+    // Setup the first segment (which may not start at te beginning of a page)
+
+    segment->physAddr = ( vmalloc_to_pfn( mem ) << PAGE_SHIFT ) + offset;
+    segment->numBytes = PAGE_SIZE - offset;
+    if ( segment->numBytes > count )
+    {
+        segment->numBytes = count;
+    }
+    bytesRemaining = count - segment->numBytes;
+    dma_sync_single_for_cpu( NULL, segment->physAddr, segment->numBytes, dir );
+
+    mem += segment->numBytes;
+
+    // Setup the remaining segments (which all start at a page boundary)
+
+    while ( bytesRemaining > 0 )
+    {
+        dma_addr_t  physAddr = ( vmalloc_to_pfn( mem ) << PAGE_SHIFT );
+        size_t      bytesThisTime = bytesRemaining;
+
+        if ( bytesThisTime > PAGE_SIZE )
+        {
+            bytesThisTime = PAGE_SIZE;
+        }
+
+        dma_sync_single_for_cpu( NULL, physAddr, bytesThisTime, dir );
+
+        if ( physAddr == ( segment->physAddr + segment->numBytes ))
+        {
+            segment->numBytes += bytesThisTime;
+        }
+        else
+        {
+            segment++;
+
+            segment->physAddr = physAddr;
+            segment->numBytes = bytesThisTime;
+        }
+        bytesRemaining -= bytesThisTime;
+        mem += bytesThisTime;
+    }
+    segment++;
+    endSegment = segment;
+
+    memMap->numSegmentsUsed = endSegment - memMap->segment;
+
+    return 0;
+}
+#endif
+
+/****************************************************************************/
+/**
+*   Looks at a memory address and categorizes it.
+*
+*   @return One of the values from the DMA_MemType_t enumeration.
+*/
+/****************************************************************************/
+
+DMA_MemType_t dma_mem_type( void *addr )
+{
+    unsigned long   addrVal = (unsigned long)addr;
+
+    if ( addrVal >= VMALLOC_END )
+    {
+        // NOTE: DMA virtual memory space starts at 0xFFxxxxxx
+
+        // dma_alloc_xxx pages are physically and virtually contiguous
+
+        return DMA_MEM_TYPE_DMA;
+    }
+
+    // Technically, we could add one more classification. Addresses between VMALLOC_END
+    // and the beginning of the DMA virtual address could be considered to be I/O space.
+    // Right now, nobody cares about this particular classification, so we ignore it.
+
+    if ( is_vmalloc_addr( addr ))
+    {
+        // Address comes from the vmalloc'd region. Pages are virtually
+        // contiguous but NOT physically contiguous
+
+        return DMA_MEM_TYPE_VMALLOC;
+    }
+
+    if ( addrVal >= PAGE_OFFSET )
+    {
+        // PAGE_OFFSET is typically 0xC0000000
+
+        // kmalloc'd pages are physically contiguous
+
+        return DMA_MEM_TYPE_KMALLOC;
+    }
+
+    return DMA_MEM_TYPE_USER;
+}
+EXPORT_SYMBOL( dma_mem_type );
+
+/****************************************************************************/
+/**
+*   Looks at a memory address and determines if we support DMA'ing to/from
+*   that type of memory.
+*
+*   @return boolean -
+*               return value != 0 means dma supported
+*               return value == 0 means dma not supported
+*/
+/****************************************************************************/
+
+int dma_mem_supports_dma( void *addr )
+{
+    DMA_MemType_t   memType = dma_mem_type( addr );
+
+    return ( memType == DMA_MEM_TYPE_DMA )
+#if ALLOW_MAP_OF_KMALLOC_MEMORY
+        || ( memType == DMA_MEM_TYPE_KMALLOC )
+#endif
+        || ( memType == DMA_MEM_TYPE_USER )
+            ;
+}
+EXPORT_SYMBOL( dma_mem_supports_dma );
+
+/****************************************************************************/
+/**
+*   Maps in a memory region such that it can be used for performing a DMA.
+*
+*   @return
+*/
+/****************************************************************************/
+
+int dma_map_start
+(
+    DMA_MemMap_t           *memMap, ///< Stores state information about the map
+    enum dma_data_direction dir     ///< Direction that the mapping will be going
+)
+{
+    int     rc;
+
+    down( &memMap->lock );
+
+    DMA_MAP_PRINT( "memMap: %p\n", memMap );
+
+    if ( memMap->inUse )
+    {
+        printk( KERN_ERR "%s: memory map %p is already being used\n", __func__, memMap );
+        rc = -EBUSY;
+        goto out;
+    }
+
+    memMap->inUse = 1;
+    memMap->dir = dir;
+    memMap->numRegionsUsed = 0;
+
+    rc = 0;
+
+out:
+
+    DMA_MAP_PRINT( "returning %d", rc );
+
+    up( &memMap->lock );
+
+    return rc;
+}
+EXPORT_SYMBOL( dma_map_start );
+
+/****************************************************************************/
+/**
+*   Adds a segment of memory to a memory map. Each segment is both
+*   physically and virtually contiguous.
+*
+*   @return     0 on success, error code otherwise.
+*/
+/****************************************************************************/
+
+static int dma_map_add_segment
+(
+    DMA_MemMap_t    *memMap,    ///< Stores state information about the map
+    DMA_Region_t    *region,    ///< Region that the segment belongs to
+    void            *virtAddr,  ///< Virtual address of the segment being added
+    dma_addr_t       physAddr,  ///< Physical address of the segment being added
+    size_t           numBytes    ///< Number of bytes of the segment being added
+)
+{
+    DMA_Segment_t  *segment;
+
+    DMA_MAP_PRINT( "memMap:%p va:%p pa:0x%x #:%d\n", memMap, virtAddr, physAddr, numBytes );
+
+    // Sanity check
+
+    if (( (unsigned long)virtAddr < (unsigned long)region->virtAddr )
+    ||  ( ((unsigned long)virtAddr + numBytes )) > ((unsigned long)region->virtAddr + region->numBytes ))
+    {
+        printk( KERN_ERR "%s: virtAddr %p is outside region @ %p len: %d\n", __func__, virtAddr, region->virtAddr, region->numBytes );
+        return -EINVAL;
+    }
+
+    if ( region->numSegmentsUsed > 0 )
+    {
+        // Check to see if this segment is physically contiguous with the previous one
+
+        segment = &region->segment[ region->numSegmentsUsed - 1 ];
+
+        if (( segment->physAddr + segment->numBytes ) == physAddr )
+        {
+            // It is - just add on to the end
+
+            DMA_MAP_PRINT( "appending %d bytes to last segment\n", numBytes );
+
+            segment->numBytes += numBytes;
+
+            return 0;
+        }
+    }
+
+    // Reallocate to hold more segments, if required.
+
+    if ( region->numSegmentsUsed >= region->numSegmentsAllocated )
+    {
+        DMA_Segment_t  *newSegment;
+        size_t          oldSize = region->numSegmentsAllocated * sizeof( *newSegment );
+        int             newAlloc = region->numSegmentsAllocated + 4;
+        size_t          newSize = newAlloc * sizeof( *newSegment );
+
+        if (( newSegment = kmalloc( newSize, GFP_KERNEL )) == NULL )
+        {
+            return -ENOMEM;
+        }
+        memcpy( newSegment, region->segment, oldSize );
+        memset( &((uint8_t *)newSegment)[ oldSize ], 0, newSize - oldSize );
+        kfree( region->segment );
+
+        region->numSegmentsAllocated = newAlloc;
+        region->segment = newSegment;
+    }
+
+    segment = &region->segment[ region->numSegmentsUsed ];
+    region->numSegmentsUsed++;
+
+    segment->virtAddr = virtAddr;
+    segment->physAddr = physAddr;
+    segment->numBytes = numBytes;
+
+    DMA_MAP_PRINT( "returning success\n" );
+
+    return 0;
+}
+
+/****************************************************************************/
+/**
+*   Adds a region of memory to a memory map. Each region is virtually
+*   contiguous, but not necessarily physically contiguous.
+*
+*   @return     0 on success, error code otherwise.
+*/
+/****************************************************************************/
+
+int dma_map_add_region
+(
+    DMA_MemMap_t           *memMap,     ///< Stores state information about the map
+    void                   *mem,        ///< Virtual address that we want to get a map of
+    size_t                  numBytes    ///< Number of bytes being mapped
+)
+{
+    unsigned long   addr = (unsigned long)mem;
+    unsigned int    offset;
+    int             rc = 0;
+    DMA_Region_t   *region;
+    dma_addr_t      physAddr;
+
+    down( &memMap->lock );
+
+    DMA_MAP_PRINT( "memMap:%p va:%p #:%d\n", memMap, mem, numBytes );
+
+    if ( !memMap->inUse )
+    {
+        printk( KERN_ERR "%s: Make sure you call dma_map_start first\n", __func__ );
+        rc = -EINVAL;
+        goto out;
+    }
+
+    // Reallocate to hold more regions.
+
+    if ( memMap->numRegionsUsed >= memMap->numRegionsAllocated )
+    {
+        DMA_Region_t   *newRegion;
+        size_t          oldSize = memMap->numRegionsAllocated * sizeof( *newRegion );
+        int             newAlloc = memMap->numRegionsAllocated + 4;
+        size_t          newSize = newAlloc * sizeof( *newRegion );
+
+        if (( newRegion = kmalloc( newSize, GFP_KERNEL )) == NULL )
+        {
+            rc = -ENOMEM;
+            goto out;
+        }
+        memcpy( newRegion, memMap->region, oldSize );
+        memset( &((uint8_t *)newRegion)[ oldSize ], 0, newSize - oldSize );
+
+        kfree( memMap->region );
+
+        memMap->numRegionsAllocated = newAlloc;
+        memMap->region = newRegion;
+    }
+
+    region = &memMap->region[ memMap->numRegionsUsed ];
+    memMap->numRegionsUsed++;
+
+    offset = addr & ~PAGE_MASK;
+
+    region->memType = dma_mem_type( mem );
+    region->virtAddr = mem;
+    region->numBytes = numBytes;
+    region->numSegmentsUsed = 0;
+    region->numLockedPages = 0;
+    region->lockedPages = NULL;
+
+    switch ( region->memType )
+    {
+        case DMA_MEM_TYPE_VMALLOC:
+        {
+            atomic_inc( &gDmaStatMemTypeVmalloc );
+
+            // printk( KERN_ERR "%s: vmalloc'd pages are not supported\n", __func__ );
+
+            // vmalloc'd pages are not physically contiguous
+
+            rc = -EINVAL;
+            break;
+        }
+
+        case DMA_MEM_TYPE_KMALLOC:
+        {
+            atomic_inc( &gDmaStatMemTypeKmalloc );
+
+            // kmalloc'd pages are physically contiguous, so they'll have exactly
+            // one segment
+
+            #if ALLOW_MAP_OF_KMALLOC_MEMORY
+            physAddr = dma_map_single( NULL, mem, numBytes, memMap->dir );
+            rc = dma_map_add_segment( memMap, region, mem, physAddr, numBytes );
+            #else
+            rc = -EINVAL;
+            #endif
+            break;
+        }
+
+        case DMA_MEM_TYPE_DMA:
+        {
+            // dma_alloc_xxx pages are physically contiguous
+
+            atomic_inc( &gDmaStatMemTypeCoherent );
+
+            physAddr = ( vmalloc_to_pfn( mem ) << PAGE_SHIFT ) + offset;
+
+            dma_sync_single_for_cpu( NULL, physAddr, numBytes, memMap->dir );
+            rc = dma_map_add_segment( memMap, region, mem, physAddr, numBytes);
+            break;
+        }
+
+        case DMA_MEM_TYPE_USER:
+        {
+            size_t       firstPageOffset;
+            size_t       firstPageSize;
+            struct page **pages;
+            struct task_struct  *userTask;
+
+            atomic_inc( &gDmaStatMemTypeUser );
+
+#if 1
+            // If the pages are user pages, then the dma_mem_map_set_user_task function
+            // must have been previously called.
+
+            if ( memMap->userTask == NULL )
+            {
+                printk( KERN_ERR "%s: must call dma_mem_map_set_user_task when using user-mode memory\n", __func__ );
+                return -EINVAL;
+            }
+
+            // User pages need to be locked.
+
+            firstPageOffset = (unsigned long)region->virtAddr & ( PAGE_SIZE - 1 );
+            firstPageSize   = PAGE_SIZE - firstPageOffset;
+
+            region->numLockedPages = ( firstPageOffset
+                                     + region->numBytes + PAGE_SIZE - 1 ) / PAGE_SIZE;
+            pages = kmalloc( region->numLockedPages * sizeof( struct page * ), GFP_KERNEL );
+
+            if ( pages == NULL )
+            {
+                region->numLockedPages = 0;
+                return -ENOMEM;
+            }
+
+            userTask = memMap->userTask;
+
+            down_read( &userTask->mm->mmap_sem );
+            rc = get_user_pages( userTask,                          // task
+                                 userTask->mm,                      // mm
+                                 (unsigned long)region->virtAddr,   // start
+                                 region->numLockedPages,            // len
+                                 memMap->dir == DMA_FROM_DEVICE,    // write
+                                 0,                                 // force
+                                 pages,                             // pages (array of pointers to page)
+                                 NULL );                            // vmas
+            up_read( &userTask->mm->mmap_sem );
+
+            if ( rc != region->numLockedPages )
+            {
+                kfree( pages );
+                region->numLockedPages = 0;
+
+                if ( rc >= 0 )
+                {
+                    rc = -EINVAL;
+                }
+            }
+            else
+            {
+                uint8_t *virtAddr = region->virtAddr;
+                size_t   bytesRemaining;
+                int      pageIdx;
+
+                rc = 0; // Since get_user_pages returns +ve number
+
+                region->lockedPages = pages;
+
+                // We've locked the user pages. Now we need to walk them and figure
+                // out the physical addresses.
+
+                // The first page may be partial
+
+                dma_map_add_segment( memMap,
+                                     region,
+                                     virtAddr,
+                                     PFN_PHYS( page_to_pfn( pages[0] )) + firstPageOffset,
+                                     firstPageSize );
+
+                virtAddr += firstPageSize;
+                bytesRemaining = region->numBytes - firstPageSize;
+
+                for ( pageIdx = 1; pageIdx < region->numLockedPages; pageIdx++ )
+                {
+                    size_t  bytesThisPage = ( bytesRemaining > PAGE_SIZE ? PAGE_SIZE : bytesRemaining );
+
+                    DMA_MAP_PRINT( "pageIdx:%d pages[pageIdx]=%p pfn=%u phys=%u\n",
+                                   pageIdx,
+                                   pages[pageIdx],
+                                   page_to_pfn( pages[pageIdx] ),
+                                   PFN_PHYS( page_to_pfn( pages[pageIdx] )));
+
+                    dma_map_add_segment( memMap,
+                                         region,
+                                         virtAddr,
+                                         PFN_PHYS( page_to_pfn( pages[pageIdx] )),
+                                         bytesThisPage );
+
+                    virtAddr += bytesThisPage;
+                    bytesRemaining -= bytesThisPage;
+                }
+            }
+#else
+            printk( KERN_ERR "%s: User mode pages are not yet supported\n", __func__ );
+
+            // user pages are not physically contiguous
+
+            rc = -EINVAL;
+#endif
+            break;
+        }
+
+        default:
+        {
+            printk( KERN_ERR "%s: Unsupported memory type: %d\n", __func__, region->memType );
+
+            rc = -EINVAL;
+            break;
+        }
+    }
+
+    if ( rc != 0 )
+    {
+        memMap->numRegionsUsed--;
+    }
+
+out:
+
+    DMA_MAP_PRINT( "returning %d\n", rc );
+
+    up( &memMap->lock );
+
+    return rc;
+}
+EXPORT_SYMBOL( dma_map_add_segment );
+
+/****************************************************************************/
+/**
+*   Maps in a memory region such that it can be used for performing a DMA.
+*
+*   @return     0 on success, error code otherwise.
+*/
+/****************************************************************************/
+
+int dma_map_mem
+(
+    DMA_MemMap_t           *memMap,     ///< Stores state information about the map
+    void                   *mem,        ///< Virtual address that we want to get a map of
+    size_t                  numBytes,   ///< Number of bytes being mapped
+    enum dma_data_direction dir         ///< Direction that the mapping will be going
+)
+{
+    int rc;
+
+    if (( rc = dma_map_start( memMap, dir )) == 0 )
+    {
+        if (( rc = dma_map_add_region( memMap, mem, numBytes )) < 0 )
+        {
+            // Since the add fails, this function will fail, and the caller won't
+            // call unmap, so we need to do it here.
+
+            dma_unmap( memMap, 0 );
+        }
+    }
+
+    return rc;
+}
+EXPORT_SYMBOL( dma_map_mem );
+
+/****************************************************************************/
+/**
+*   Setup a descriptor ring for a given memory map.
+*
+*   It is assumed that the descriptor ring has already been initialized, and
+*   this routine will only reallocate a new descriptor ring if the existing
+*   one is too small.
+*
+*   @return     0 on success, error code otherwise.
+*/
+/****************************************************************************/
+
+int dma_map_create_descriptor_ring
+(
+    DMA_Device_t            dev,        ///< DMA device (where the ring is stored)
+    DMA_MemMap_t           *memMap,     ///< Memory map that will be used
+    dma_addr_t              devPhysAddr ///< Physical address of device
+)
+{
+    int                     rc;
+    int                     numDescriptors;
+    DMA_DeviceAttribute_t  *devAttr;
+    DMA_Region_t           *region;
+    DMA_Segment_t          *segment;
+    dma_addr_t              srcPhysAddr;
+    dma_addr_t              dstPhysAddr;
+    int                     regionIdx;
+    int                     segmentIdx;
+
+    devAttr = &DMA_gDeviceAttribute[ dev ];
+
+    down( &memMap->lock );
+
+    // Figure out how many descriptors we need
+
+    numDescriptors = 0;
+    for ( regionIdx = 0; regionIdx < memMap->numRegionsUsed; regionIdx++ )
+    {
+        region = &memMap->region[ regionIdx ];
+
+        for ( segmentIdx = 0; segmentIdx < region->numSegmentsUsed; segmentIdx++ )
+        {
+            segment = &region->segment[segmentIdx];
+
+            if ( memMap->dir == DMA_TO_DEVICE )
+            {
+                srcPhysAddr = segment->physAddr;
+                dstPhysAddr = devPhysAddr;
+            }
+            else
+            {
+                srcPhysAddr = devPhysAddr;
+                dstPhysAddr = segment->physAddr;
+            }
+
+            if (( rc = dma_calculate_descriptor_count( dev, srcPhysAddr, dstPhysAddr, segment->numBytes )) < 0 )
+            {
+                printk( KERN_ERR "%s: dma_calculate_descriptor_count failed: %d\n", __func__, rc );
+                goto out;
+            }
+            numDescriptors += rc;
+        }
+    }
+
+    // Adjust the size of the ring, if it isn't big enough
+
+    if ( numDescriptors > devAttr->ring.descriptorsAllocated )
+    {
+        dma_free_descriptor_ring( &devAttr->ring );
+        if (( rc = dma_alloc_descriptor_ring( &devAttr->ring, numDescriptors )) < 0 )
+        {
+            printk( KERN_ERR "%s: dma_alloc_descriptor_ring failed: %d\n", __func__, rc );
+            goto out;
+        }
+    }
+    else
+    {
+        if (( rc = dma_init_descriptor_ring( &devAttr->ring, numDescriptors )) < 0 )
+        {
+            printk( KERN_ERR "%s: dma_init_descriptor_ring failed: %d\n", __func__, rc );
+            goto out;
+        }
+    }
+
+    // Populate the descriptors
+
+    for ( regionIdx = 0; regionIdx < memMap->numRegionsUsed; regionIdx++ )
+    {
+        region = &memMap->region[ regionIdx ];
+
+        for ( segmentIdx = 0; segmentIdx < region->numSegmentsUsed; segmentIdx++ )
+        {
+            segment = &region->segment[ segmentIdx ];
+
+        if ( memMap->dir == DMA_TO_DEVICE )
+        {
+            srcPhysAddr = segment->physAddr;
+            dstPhysAddr = devPhysAddr;
+        }
+        else
+        {
+            srcPhysAddr = devPhysAddr;
+            dstPhysAddr = segment->physAddr;
+        }
+
+        if (( rc = dma_add_descriptors( &devAttr->ring, dev, srcPhysAddr, dstPhysAddr, segment->numBytes )) < 0 )
+        {
+            printk( KERN_ERR "%s: dma_add_descriptors failed: %d\n", __func__, rc );
+            goto out;
+        }
+    }
+    }
+
+    rc = 0;
+
+out:
+
+    up( &memMap->lock );
+    return rc;
+}
+EXPORT_SYMBOL( dma_map_create_descriptor_ring );
+
+/****************************************************************************/
+/**
+*   Maps in a memory region such that it can be used for performing a DMA.
+*
+*   @return
+*/
+/****************************************************************************/
+
+int dma_unmap
+(
+    DMA_MemMap_t       *memMap, ///< Stores state information about the map
+    int                 dirtied ///< non-zero if any of the pages were modified
+)
+{
+    int             regionIdx;
+    int             segmentIdx;
+    DMA_Region_t   *region;
+    DMA_Segment_t  *segment;
+
+    for ( regionIdx = 0; regionIdx < memMap->numRegionsUsed; regionIdx++ )
+    {
+        region = &memMap->region[ regionIdx ];
+
+        for ( segmentIdx = 0; segmentIdx < region->numSegmentsUsed; segmentIdx++ )
+        {
+            segment = &region->segment[ segmentIdx ];
+
+            switch ( region->memType )
+            {
+                case DMA_MEM_TYPE_VMALLOC:
+                {
+                    printk( KERN_ERR "%s: vmalloc'd pages are not yet supported\n", __func__ );
+                    return -EINVAL;
+                }
+
+                case DMA_MEM_TYPE_KMALLOC:
+                {
+                    #if ALLOW_MAP_OF_KMALLOC_MEMORY
+                    dma_unmap_single( NULL, segment->physAddr, segment->numBytes, memMap->dir );
+                    #endif
+                    break;
+                }
+
+                case DMA_MEM_TYPE_DMA:
+                {
+                    dma_sync_single_for_cpu( NULL, segment->physAddr, segment->numBytes, memMap->dir );
+                    break;
+                }
+
+                case DMA_MEM_TYPE_USER:
+                {
+                    // Nothing to do here.
+
+                    break;
+                }
+
+                default:
+                {
+                    printk( KERN_ERR "%s: Unsupported memory type: %d\n", __func__, region->memType );
+                    return -EINVAL;
+                }
+            }
+
+            segment->virtAddr = NULL;
+            segment->physAddr = 0;
+            segment->numBytes = 0;
+        }
+
+        if ( region->numLockedPages > 0 )
+        {
+            int     pageIdx;
+
+            // Some user pages were locked. We need to go and unlock them now.
+
+            for ( pageIdx = 0; pageIdx < region->numLockedPages; pageIdx++ )
+            {
+                struct page *page = region->lockedPages[ pageIdx ];
+
+                if ( memMap->dir == DMA_FROM_DEVICE )
+                {
+                    SetPageDirty( page );
+                }
+                page_cache_release( page );
+            }
+            kfree( region->lockedPages );
+            region->numLockedPages = 0;
+            region->lockedPages = NULL;
+        }
+
+        region->memType  = DMA_MEM_TYPE_NONE;
+        region->virtAddr = NULL;
+        region->numBytes = 0;
+        region->numSegmentsUsed = 0;
+    }
+    memMap->userTask = NULL;
+    memMap->numRegionsUsed = 0;
+    memMap->inUse = 0;
+
+    up( &memMap->lock );
+
+    return 0;
+}
+EXPORT_SYMBOL( dma_unmap );
+
diff --git a/arch/arm/mach-bcmring/early_printk.c b/arch/arm/mach-bcmring/early_printk.c
new file mode 100644
index 0000000..88954e3
--- /dev/null
+++ b/arch/arm/mach-bcmring/early_printk.c
@@ -0,0 +1,105 @@
+/*****************************************************************************
+* Copyright 2005 - 2008 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+
+
+#if defined( CONFIG_BCM_EARLY_PRINTK ) || defined( CONFIG_KGDB )
+
+/* ---- Include Files ---------------------------------------------------- */
+#include <linux/console.h>
+#include <linux/init.h>
+#include <csp/uartHw.h>
+
+/* ---- External Variable Declarations ----------------------------------- */
+/* ---- External Function Prototypes ------------------------------------- */
+
+/* ---- Public Variables ------------------------------------------------- */
+/* ---- Private Constants and Types -------------------------------------- */
+#if defined( CONFIG_BCM_EARLY_CONSOLE_UARTA )
+#define EARLY_PRINTK_UART_NUM 0
+#endif
+#if defined( CONFIG_BCM_EARLY_CONSOLE_UARTB )
+#define EARLY_PRINTK_UART_NUM 1
+#endif
+
+/* ---- Private Variables ------------------------------------------------ */
+static  int bcm_early_console_enabled = 0;
+
+/* ---- Private Function Prototypes -------------------------------------- */
+/* ==== Public Functions ================================================= */
+
+static int __init bcm_early_console_setup( struct console *co, char *options )
+{
+   /* Initialize the UART to 115K, 8N1 */
+   uartHw_Init( EARLY_PRINTK_UART_NUM, 115200 );
+
+   return 0;
+}
+
+static void bcm_early_console_putc( char ch )
+{
+   /* Put the character in the TX Fifo of the UART */
+   uartHw_TxFifoPut( EARLY_PRINTK_UART_NUM, ch );
+}
+
+static void bcm_early_console_write( struct console *co, const char *s, u_int count )
+{
+   /*
+   ** Write the characters out the UART, adding \r where necessary .
+   ** At end, wait for fifo to be idle so all characters are out UART before continuing.
+   */
+   if ( bcm_early_console_enabled )
+   {
+      while ( count > 0 )
+      {
+         if ( *s == '\n' )
+         {
+            bcm_early_console_putc( '\r' );
+         }
+         bcm_early_console_putc( *s );
+
+         s++;
+         count--;
+      }
+      uartHw_TxWaitIdle( EARLY_PRINTK_UART_NUM );
+   }
+}
+
+static struct console bcm_early_console =
+{
+   name:   "econ",
+   write:  bcm_early_console_write,
+   setup:  bcm_early_console_setup,
+   flags:  CON_PRINTBUFFER,
+   index:  -1,
+};
+
+void bcm_install_early_console( void )
+{
+   bcm_early_console_enabled = 1;
+   register_console( &bcm_early_console );
+}
+
+void bcm_uninstall_early_console( void )
+{
+   /*
+   ** We don't call unregister here, because we get get enabled when
+   ** KGDB is used. KGDB registers it's own console and since we register
+   ** first the notion of "preferred" console gets lost.
+   */
+   bcm_early_console_enabled = 0;
+}
+
+#endif
+
diff --git a/arch/arm/mach-bcmring/include/cfg_global.h b/arch/arm/mach-bcmring/include/cfg_global.h
new file mode 100644
index 0000000..c71ed0a
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/cfg_global.h
@@ -0,0 +1,16 @@
+#ifndef _CFG_GLOBAL_H_
+#define _CFG_GLOBAL_H_
+
+#include <cfg_global_defines.h>
+
+#define CFG_GLOBAL_CHIP                         BCM11107
+#define CFG_GLOBAL_CHIP_FAMILY                  CFG_GLOBAL_CHIP_FAMILY_BCMRING
+#define CFG_GLOBAL_CHIP_REV                     0xA0
+#define CFG_GLOBAL_CPU                          ARM11
+#define CFG_GLOBAL_CPU_ENDIAN                   le
+#define CFG_GLOBAL_RAM_SIZE                     0x10000000
+#define CFG_GLOBAL_RAM_BASE                     0x00000000
+#define CFG_GLOBAL_RAM_RESERVED_SIZE            0x000000
+#define CFG_GLOBAL_RTLSIM_SUPPORT               1
+
+#endif /* _CFG_GLOBAL_H_ */
diff --git a/arch/arm/mach-bcmring/include/cfg_global_defines.h b/arch/arm/mach-bcmring/include/cfg_global_defines.h
new file mode 100644
index 0000000..dbc04d0
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/cfg_global_defines.h
@@ -0,0 +1,54 @@
+/*****************************************************************************
+* Copyright 2006 - 2008 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+
+
+#ifndef CFG_GLOBAL_DEFINES_H
+#define CFG_GLOBAL_DEFINES_H
+
+/* CPU */
+#define   ARMEB  1
+#define   MIPS32 2
+#define   ARM9   3
+#define   ARM11  4
+
+/* CHIP */
+#define BCM1103 1
+
+#define BCM1191 4
+#define BCM2153 5
+#define BCM2820 6
+
+#define BCM2826 8
+#define FPGA11107 9
+#define BCM11107   10
+#define BCM11109   11
+#define BCM11170   12
+#define BCM11110   13
+#define BCM11211   14
+
+/* CFG_GLOBAL_CHIP_FAMILY types */
+#define CFG_GLOBAL_CHIP_FAMILY_NONE        0
+#define CFG_GLOBAL_CHIP_FAMILY_BCM116X     2
+#define CFG_GLOBAL_CHIP_FAMILY_BCMRING     4
+#define CFG_GLOBAL_CHIP_FAMILY_BCM1103     8
+
+/* CFG_GLOBAL_ROOT_FILE_SYSTEM */
+#define JFFS2_RFS      1
+#define CRAMFS_RFS     2
+#define INITRAMFS      3
+
+#define IMAGE_HEADER_SIZE_CHECKSUM    4
+#endif
+
diff --git a/arch/arm/mach-bcmring/include/mach/clkdev.h b/arch/arm/mach-bcmring/include/mach/clkdev.h
new file mode 100644
index 0000000..04b37a8
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/clkdev.h
@@ -0,0 +1,7 @@
+#ifndef __ASM_MACH_CLKDEV_H
+#define __ASM_MACH_CLKDEV_H
+
+#define __clk_get(clk) ({ 1; })
+#define __clk_put(clk) do { } while (0)
+
+#endif
diff --git a/arch/arm/mach-bcmring/include/mach/dma.h b/arch/arm/mach-bcmring/include/mach/dma.h
new file mode 100644
index 0000000..e1fd27e
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/dma.h
@@ -0,0 +1,894 @@
+/*****************************************************************************
+* Copyright 2004 - 2008 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+
+/****************************************************************************/
+/**
+*   @file   dma.h
+*
+*   @brief  API definitions for the linux DMA interface.
+*/
+/****************************************************************************/
+
+#if !defined( ASM_ARM_ARCH_BCMRING_DMA_H )
+#define ASM_ARM_ARCH_BCMRING_DMA_H
+
+/* ---- Include Files ---------------------------------------------------- */
+
+#include <linux/kernel.h>
+#include <linux/wait.h>
+#include <linux/semaphore.h>
+#include <csp/dmacHw.h>
+#include <mach/timer.h>
+#include <linux/scatterlist.h>
+#include <linux/dma-mapping.h>
+#include <linux/mm.h>
+#include <linux/vmalloc.h>
+#include <linux/pagemap.h>
+
+/* ---- Constants and Types ---------------------------------------------- */
+
+// If DMA_DEBUG_TRACK_RESERVATION is set to a non-zero value, then the filename
+// and line number of the reservation request will be recorded in the channel table
+
+#define DMA_DEBUG_TRACK_RESERVATION   1
+
+#define DMA_NUM_CONTROLLERS     2
+#define DMA_NUM_CHANNELS        8   // per controller
+
+typedef enum
+{
+    DMA_DEVICE_MEM_TO_MEM,              // For memory to memory transfers
+    DMA_DEVICE_I2S0_DEV_TO_MEM,
+    DMA_DEVICE_I2S0_MEM_TO_DEV,
+    DMA_DEVICE_I2S1_DEV_TO_MEM,
+    DMA_DEVICE_I2S1_MEM_TO_DEV,
+    DMA_DEVICE_APM_CODEC_A_DEV_TO_MEM,
+    DMA_DEVICE_APM_CODEC_A_MEM_TO_DEV,
+    DMA_DEVICE_APM_CODEC_B_DEV_TO_MEM,
+    DMA_DEVICE_APM_CODEC_B_MEM_TO_DEV,
+    DMA_DEVICE_APM_CODEC_C_DEV_TO_MEM,  // Additional mic input for beam-forming
+    DMA_DEVICE_APM_PCM0_DEV_TO_MEM,
+    DMA_DEVICE_APM_PCM0_MEM_TO_DEV,
+    DMA_DEVICE_APM_PCM1_DEV_TO_MEM,
+    DMA_DEVICE_APM_PCM1_MEM_TO_DEV,
+    DMA_DEVICE_SPUM_DEV_TO_MEM,
+    DMA_DEVICE_SPUM_MEM_TO_DEV,
+    DMA_DEVICE_SPIH_DEV_TO_MEM,
+    DMA_DEVICE_SPIH_MEM_TO_DEV,
+    DMA_DEVICE_UART_A_DEV_TO_MEM,
+    DMA_DEVICE_UART_A_MEM_TO_DEV,
+    DMA_DEVICE_UART_B_DEV_TO_MEM,
+    DMA_DEVICE_UART_B_MEM_TO_DEV,
+    DMA_DEVICE_PIF_MEM_TO_DEV,
+    DMA_DEVICE_PIF_DEV_TO_MEM,
+    DMA_DEVICE_ESW_DEV_TO_MEM,
+    DMA_DEVICE_ESW_MEM_TO_DEV,
+    DMA_DEVICE_VPM_MEM_TO_MEM,
+    DMA_DEVICE_CLCD_MEM_TO_MEM,
+    DMA_DEVICE_NAND_MEM_TO_MEM,
+    DMA_DEVICE_MEM_TO_VRAM,
+    DMA_DEVICE_VRAM_TO_MEM,
+
+    // Add new entries before this line.
+
+    DMA_NUM_DEVICE_ENTRIES,
+    DMA_DEVICE_NONE = 0xff,    // Special value to indicate that no device is currently assigned.
+
+} DMA_Device_t;
+
+/****************************************************************************
+*
+*   The DMA_Handle_t is the primary object used by callers of the API.
+*
+*****************************************************************************/
+
+#define DMA_INVALID_HANDLE  ((DMA_Handle_t) -1)
+
+typedef     int DMA_Handle_t;
+
+/****************************************************************************
+*
+*   The DMA_DescriptorRing_t contains a ring of descriptors which is used
+*   to point to regions of memory.
+*
+*****************************************************************************/
+
+typedef struct
+{
+    void       *virtAddr;               ///< Virtual Address of the descriptor ring
+    dma_addr_t  physAddr;               ///< Physical address of the descriptor ring
+    int         descriptorsAllocated;   ///< Number of descriptors allocated in the descriptor ring
+    size_t      bytesAllocated;         ///< Number of bytes allocated in the descriptor ring
+
+} DMA_DescriptorRing_t;
+
+/****************************************************************************
+*
+*   The DMA_MemType_t and DMA_MemMap_t are helper structures used to setup
+*   DMA chains from a variety of memory sources.
+*
+*****************************************************************************/
+
+#define DMA_MEM_MAP_MIN_SIZE    4096    // Pages less than this size are better
+                                        // off not being DMA'd.
+
+typedef enum
+{
+    DMA_MEM_TYPE_NONE,      // Not a valid setting
+    DMA_MEM_TYPE_VMALLOC,   // Memory came from vmalloc call
+    DMA_MEM_TYPE_KMALLOC,   // Memory came from kmalloc call
+    DMA_MEM_TYPE_DMA,       // Memory came from dma_alloc_xxx call
+    DMA_MEM_TYPE_USER,      // Memory came from user space.
+
+} DMA_MemType_t;
+
+// A segment represents a physically and virtually contiguous chunk of memory.
+// i.e. each segment can be DMA'd
+//
+// A user of the DMA code will add memory regions. Each region may need to be
+// represented by one or more segments.
+
+typedef struct
+{
+    void                   *virtAddr;   // Virtual address used for this segment
+    dma_addr_t              physAddr;   // Physical address this segment maps to
+    size_t                  numBytes;   // Size of the segment, in bytes
+
+} DMA_Segment_t;
+
+// A region represents a virtually contiguous chunk of memory, which may be
+// made up of multiple segments.
+
+typedef struct
+{
+    DMA_MemType_t           memType;
+    void                   *virtAddr;
+    size_t                  numBytes;
+
+    // Each region (virtually contiguous) consists of one or more segments. Each
+    // segment is virtually and physically contiguous.
+
+    int                     numSegmentsUsed;
+    int                     numSegmentsAllocated;
+    DMA_Segment_t          *segment;
+
+    // When a region corresponds to user memory, we need to lock all of the pages
+    // down before we can figure out the physical addresses. The lockedPage array contains
+    // the pages that were locked, and which subsequently need to be unlocked once the
+    // memory is unmapped.
+
+    unsigned                numLockedPages;
+    struct page           **lockedPages;
+
+} DMA_Region_t;
+
+typedef struct
+{
+    int                     inUse;      // Is this mapping currently being used?
+    struct semaphore        lock;       // Acquired when using this structure
+    enum dma_data_direction dir;        // Direction this transfer is intended for
+
+    // In the event that we're mapping user memory, we need to know which task
+    // the memory is for, so that we can obtain the correct mm locks.
+
+    struct task_struct     *userTask;
+
+    int                     numRegionsUsed;
+    int                     numRegionsAllocated;
+    DMA_Region_t           *region;
+
+} DMA_MemMap_t;
+
+/****************************************************************************
+*
+*   The DMA_DeviceAttribute_t contains information which describes a
+*   particular DMA device (or peripheral).
+*
+*   It is anticipated that the arrary of DMA_DeviceAttribute_t's will be
+*   statically initialized.
+*
+*****************************************************************************/
+
+// The device handler is called whenever a DMA operation completes. The reaon
+// for it to be called will be a bitmask with one or more of the following bits
+// set.
+
+#define DMA_HANDLER_REASON_BLOCK_COMPLETE       dmacHw_INTERRUPT_STATUS_BLOCK
+#define DMA_HANDLER_REASON_TRANSFER_COMPLETE    dmacHw_INTERRUPT_STATUS_TRANS
+#define DMA_HANDLER_REASON_ERROR                dmacHw_INTERRUPT_STATUS_ERROR
+
+typedef void (*DMA_DeviceHandler_t)( DMA_Device_t dev, int reason, void *userData );
+
+#define DMA_DEVICE_FLAG_ON_DMA0             0x00000001
+#define DMA_DEVICE_FLAG_ON_DMA1             0x00000002
+#define DMA_DEVICE_FLAG_PORT_PER_DMAC       0x00000004  // If set, it means that the port used on DMAC0 is different from the port used on DMAC1
+#define DMA_DEVICE_FLAG_ALLOC_DMA1_FIRST    0x00000008  // If set, allocate from DMA1 before allocating from DMA0
+#define DMA_DEVICE_FLAG_IS_DEDICATED        0x00000100
+#define DMA_DEVICE_FLAG_NO_ISR              0x00000200
+#define DMA_DEVICE_FLAG_ALLOW_LARGE_FIFO    0x00000400
+#define DMA_DEVICE_FLAG_IN_USE              0x00000800  // If set, device is in use on a channel
+
+// Note: Some DMA devices can be used from multiple DMA Controllers. The bitmask is used to
+//       determine which DMA controllers a given device can be used from, and the interface
+//       array determeines the actual interface number to use for a given controller.
+
+typedef struct
+{
+    uint32_t        flags;              // Bitmask of DMA_DEVICE_FLAG_xxx constants
+    uint8_t         dedicatedController;// Controller number to use if DMA_DEVICE_FLAG_IS_DEDICATED is set.
+    uint8_t         dedicatedChannel;   // Channel number to use if DMA_DEVICE_FLAG_IS_DEDICATED is set.
+    const char     *name;               // Will show up in the /proc entry
+
+    uint32_t        dmacPort[DMA_NUM_CONTROLLERS]; // Specifies the port number when DMA_DEVICE_FLAG_PORT_PER_DMAC flag is set
+
+    dmacHw_CONFIG_t config;             // Configuration to use when DMA'ing using this device
+
+    void               *userData;       // Passed to the devHandler
+    DMA_DeviceHandler_t devHandler;     // Called when DMA operations finish.
+
+    timer_tick_count_t  transferStartTime;// Time the current transfer was started
+
+    // The following statistical information will be collected and presented in a proc entry.
+    // Note: With a contiuous bandwidth of 1 Gb/sec, it would take 584 years to overflow
+    //       a 64 bit counter.
+
+    uint64_t            numTransfers;   // Number of DMA transfers performed
+    uint64_t            transferTicks;  // Total time spent doing DMA transfers (measured in timer_tick_count_t's)
+    uint64_t            transferBytes;  // Total bytes transferred
+    uint32_t            timesBlocked;   // Number of times a channel was unavailable
+    uint32_t            numBytes;       // Last transfer size
+
+    // It's not possible to free memory which is allocated for the descriptors from within
+    // the ISR. So make the presumption that a given device will tend to use the
+    // same sized buffers over and over again, and we keep them around.
+
+    DMA_DescriptorRing_t    ring;       // Ring of descriptors allocated for this device
+
+    // We stash away some of the information from the previous transfer. If back-to-back
+    // transfers are performed from the same buffer, then we don't have to keep re-initializing
+    // the descriptor buffers.
+
+    uint32_t            prevNumBytes;
+    dma_addr_t          prevSrcData;
+    dma_addr_t          prevDstData;
+
+} DMA_DeviceAttribute_t;
+
+
+/****************************************************************************
+*
+*   DMA_Channel_t, DMA_Controller_t, and DMA_State_t are really internal
+*   data structures and don't belong in this header file, but are included
+*   merely for discussion.
+*
+*   By the time this is implemented, these structures will be moved out into
+*   the appropriate C source file instead.
+*
+*****************************************************************************/
+
+/****************************************************************************
+*
+*   The DMA_Channel_t contains state information about each DMA channel. Some
+*   of the channels are dedicated. Non-dedicated channels are shared
+*   amongst the other devices.
+*
+*****************************************************************************/
+
+#define DMA_CHANNEL_FLAG_IN_USE         0x00000001
+#define DMA_CHANNEL_FLAG_IS_DEDICATED   0x00000002
+#define DMA_CHANNEL_FLAG_NO_ISR         0x00000004
+#define DMA_CHANNEL_FLAG_LARGE_FIFO     0x00000008
+
+typedef struct
+{
+    uint32_t        flags;      // bitmask of DMA_CHANNEL_FLAG_xxx constants
+    DMA_Device_t    devType;    // Device this channel is currently reserved for
+    DMA_Device_t    lastDevType;// Device type that used this previously
+    char            name[ 20 ]; // Name passed onto request_irq
+
+#if ( DMA_DEBUG_TRACK_RESERVATION )
+    const char     *fileName;   // Place where channel reservation took place
+    int             lineNum;    // Place where channel reservation took place
+#endif
+    dmacHw_HANDLE_t dmacHwHandle;   // low level channel handle.
+
+} DMA_Channel_t;
+
+/****************************************************************************
+*
+*   The DMA_Controller_t contains state information about each DMA controller.
+*
+*   The freeChannelQ is stored in the controller data structure rather than
+*   the channel data structure since several of the devices are accessible
+*   from multiple controllers, and there is no way to know which controller
+*   will become available first.
+*
+*****************************************************************************/
+
+typedef struct
+{
+    DMA_Channel_t       channel[ DMA_NUM_CHANNELS ];
+
+} DMA_Controller_t;
+
+/****************************************************************************
+*
+*   The DMA_Global_t contains all of the global state information used by
+*   the DMA code.
+*
+*   Callers which need to allocate a shared channel will be queued up
+*   on the freeChannelQ until a channel becomes available.
+*
+*****************************************************************************/
+
+typedef struct
+{
+    struct semaphore    lock;   // acquired when manipulating table entries
+    wait_queue_head_t   freeChannelQ;
+
+    DMA_Controller_t    controller[ DMA_NUM_CONTROLLERS ];
+
+} DMA_Global_t;
+
+/* ---- Variable Externs ------------------------------------------------- */
+
+extern  DMA_DeviceAttribute_t    DMA_gDeviceAttribute[ DMA_NUM_DEVICE_ENTRIES ];
+
+/* ---- Function Prototypes ---------------------------------------------- */
+
+#if defined( __KERNEL__ )
+
+/****************************************************************************/
+/**
+*   Initializes the DMA module.
+*
+*   @return
+*       0       - Success
+*       < 0     - Error
+*/
+/****************************************************************************/
+
+int dma_init( void );
+
+#if ( DMA_DEBUG_TRACK_RESERVATION )
+DMA_Handle_t dma_request_channel_dbg( DMA_Device_t dev, const char *fileName, int lineNum );
+#define dma_request_channel( dev )  dma_request_channel_dbg( dev, __FILE__, __LINE__ )
+#else
+
+/****************************************************************************/
+/**
+*   Reserves a channel for use with @a dev. If the device is setup to use
+*   a shared channel, then this function will block until a free channel
+*   becomes available.
+*
+*   @return
+*       >= 0    - A valid DMA Handle.
+*       -EBUSY  - Device is currently being used.
+*       -ENODEV - Device handed in is invalid.
+*/
+/****************************************************************************/
+
+DMA_Handle_t dma_request_channel
+(
+    DMA_Device_t dev    ///< Device to use with the allocated channel.
+);
+#endif
+
+/****************************************************************************/
+/**
+*   Frees a previously allocated DMA Handle.
+*
+*   @return
+*        0      - DMA Handle was released successfully.
+*       -EINVAL - Invalid DMA handle
+*/
+/****************************************************************************/
+
+int dma_free_channel
+(
+    DMA_Handle_t channel    ///< DMA handle.
+);
+
+/****************************************************************************/
+/**
+*   Determines if a given device has been configured as using a shared
+*   channel.
+*
+*   @return boolean
+*       0           Device uses a dedicated channel
+*       non-zero    Device uses a shared channel
+*/
+/****************************************************************************/
+
+int dma_device_is_channel_shared
+(
+    DMA_Device_t dev    ///< Device to check.
+);
+
+/****************************************************************************/
+/**
+*   Allocates memory to hold a descriptor ring. The descriptor ring then
+*   needs to be populated by making one or more calls to
+*   dna_add_descriptors.
+*
+*   The returned descriptor ring will be automatically initialized.
+*
+*   @return
+*       0           Descriptor ring was allocated successfully
+*       -ENOMEM     Unable to allocate memory for the desired number of descriptors.
+*/
+/****************************************************************************/
+
+int dma_alloc_descriptor_ring
+(
+    DMA_DescriptorRing_t   *ring,           ///< Descriptor ring to populate
+    int                     numDescriptors  ///< Number of descriptors that need to be allocated.
+);
+
+/****************************************************************************/
+/**
+*   Releases the memory which was previously allocated for a descriptor ring.
+*/
+/****************************************************************************/
+
+void dma_free_descriptor_ring
+(
+    DMA_DescriptorRing_t   *ring            ///< Descriptor to release
+);
+
+/****************************************************************************/
+/**
+*   Initializes a descriptor ring, so that descriptors can be added to it.
+*   Once a descriptor ring has been allocated, it may be reinitialized for
+*   use with additional/different regions of memory.
+*
+*   Note that if 7 descriptors are allocated, it's perfectly acceptable to
+*   initialize the ring with a smaller number of descriptors. The amount
+*   of memory allocated for the descriptor ring will not be reduced, and
+*   the descriptor ring may be reinitialized later
+*
+*   @return
+*       0           Descriptor ring was initialized successfully
+*       -ENOMEM     The descriptor which was passed in has insufficient space
+*                   to hold the desired number of descriptors.
+*/
+/****************************************************************************/
+
+int dma_init_descriptor_ring
+(
+    DMA_DescriptorRing_t   *ring,           ///< Descriptor ring to initialize
+    int                     numDescriptors  ///< Number of descriptors to initialize.
+);
+
+/****************************************************************************/
+/**
+*   Determines the number of descriptors which would be required for a
+*   transfer of the indicated memory region.
+*
+*   This function also needs to know which DMA device this transfer will
+*   be destined for, so that the appropriate DMA configuration can be retrieved.
+*   DMA parameters such as transfer width, and whether this is a memory-to-memory
+*   or memory-to-peripheral, etc can all affect the actual number of descriptors
+*   required.
+*
+*   @return
+*       > 0     Returns the number of descriptors required for the indicated transfer
+*       -EINVAL Invalid device type for this kind of transfer
+*               (i.e. the device is _MEM_TO_DEV and not _DEV_TO_MEM)
+*       -ENOMEM Memory exhausted
+*/
+/****************************************************************************/
+
+int dma_calculate_descriptor_count
+(
+    DMA_Device_t            device,         ///< DMA Device that this will be associated with
+    dma_addr_t              srcData,        ///< Place to get data to write to device
+    dma_addr_t              dstData,        ///< Pointer to device data address
+    size_t                  numBytes        ///< Number of bytes to transfer to the device
+);
+
+/****************************************************************************/
+/**
+*   Adds a region of memory to the descriptor ring. Note that it may take
+*   multiple descriptors for each region of memory. It is the callers
+*   responsibility to allocate a sufficiently large descriptor ring.
+*
+*   @return
+*       0       Descriptors were added successfully
+*       -EINVAL Invalid device type for this kind of transfer
+*               (i.e. the device is _MEM_TO_DEV and not _DEV_TO_MEM)
+*       -ENOMEM Memory exhausted
+*/
+/****************************************************************************/
+
+int dma_add_descriptors
+(
+    DMA_DescriptorRing_t   *ring,           ///< Descriptor ring to add descriptors to
+    DMA_Device_t            device,         ///< DMA Device that descriptors are for
+    dma_addr_t              srcData,        ///< Place to get data (memory or device)
+    dma_addr_t              dstData,        ///< Place to put data (memory or device)
+    size_t                  numBytes        ///< Number of bytes to transfer to the device
+);
+
+/****************************************************************************/
+/**
+*   Sets the descriptor ring associated with a device.
+*
+*   Once set, the descriptor ring will be associated with the device, even
+*   across channel request/free calls. Passing in a NULL descriptor ring
+*   will release any descriptor ring currently associated with the device.
+*
+*   Note: If you call dma_transfer, or one of the other dma_alloc_ functions
+*         the descriptor ring may be released and reallocated.
+*
+*   Note: This function will release the descriptor memory for any current
+*         descriptor ring associated with this device.
+*/
+/****************************************************************************/
+
+int dma_set_device_descriptor_ring
+(
+    DMA_Device_t            device, ///< Device to update the descriptor ring for.
+    DMA_DescriptorRing_t   *ring    ///< Descriptor ring to add descriptors to
+);
+
+/****************************************************************************/
+/**
+*   Retrieves the descriptor ring associated with a device.
+*/
+/****************************************************************************/
+
+int dma_get_device_descriptor_ring
+(
+    DMA_Device_t            device, ///< Device to retrieve the descriptor ring for.
+    DMA_DescriptorRing_t   *ring    ///< Place to store retrieved ring
+);
+
+/****************************************************************************/
+/**
+*   Allocates buffers for the descriptors. This is normally done automatically
+*   but needs to be done explicitly when initiating a dma from interrupt
+*   context.
+*
+*   @return
+*       0       Descriptors were allocated successfully
+*       -EINVAL Invalid device type for this kind of transfer
+*               (i.e. the device is _MEM_TO_DEV and not _DEV_TO_MEM)
+*       -ENOMEM Memory exhausted
+*/
+/****************************************************************************/
+
+int dma_alloc_descriptors
+(
+    DMA_Handle_t            handle,         ///< DMA Handle
+    dmacHw_TRANSFER_TYPE_e  transferType,   ///< Type of transfer being performed
+    dma_addr_t              srcData,        ///< Place to get data to write to device
+    dma_addr_t              dstData,        ///< Pointer to device data address
+    size_t                  numBytes        ///< Number of bytes to transfer to the device
+);
+
+/****************************************************************************/
+/**
+*   Allocates and sets up descriptors for a double buffered circular buffer.
+*
+*   This is primarily intended to be used for things like the ingress samples
+*   from a microphone.
+*
+*   @return
+*       > 0     Number of descriptors actually allocated.
+*       -EINVAL Invalid device type for this kind of transfer
+*               (i.e. the device is _MEM_TO_DEV and not _DEV_TO_MEM)
+*       -ENOMEM Memory exhausted
+*/
+/****************************************************************************/
+
+int dma_alloc_double_dst_descriptors
+(
+    DMA_Handle_t            handle,         ///< DMA Handle
+    dma_addr_t              srcData,        ///< Physical address of source data
+    dma_addr_t              dstData1,       ///< Physical address of first destination buffer
+    dma_addr_t              dstData2,       ///< Physical address of second destination buffer
+    size_t                  numBytes        ///< Number of bytes in each destination buffer
+);
+
+/****************************************************************************/
+/**
+*   Initializes a DMA_MemMap_t data structure
+*/
+/****************************************************************************/
+
+int dma_init_mem_map
+(
+    DMA_MemMap_t           *memMap  ///< Stores state information about the map
+);
+
+/****************************************************************************/
+/**
+*   Releases any memory currently being held by a memory mapping structure.
+*/
+/****************************************************************************/
+
+int dma_term_mem_map
+(
+    DMA_MemMap_t           *memMap  ///< Stores state information about the map
+);
+
+/****************************************************************************/
+/**
+*   Looks at a memory address and categorizes it.
+*
+*   @return One of the values from the DMA_MemType_t enumeration.
+*/
+/****************************************************************************/
+
+DMA_MemType_t dma_mem_type( void *addr );
+
+/****************************************************************************/
+/**
+*   Sets the process (aka userTask) associated with a mem map. This is
+*   required if user-mode segments will be added to the mapping.
+*/
+/****************************************************************************/
+
+static inline void dma_mem_map_set_user_task( DMA_MemMap_t *memMap, struct task_struct *task )
+{
+    memMap->userTask = task;
+}
+
+/****************************************************************************/
+/**
+*   Looks at a memory address and determines if we support DMA'ing to/from
+*   that type of memory.
+*
+*   @return boolean -
+*               return value != 0 means dma supported
+*               return value == 0 means dma not supported
+*/
+/****************************************************************************/
+
+int dma_mem_supports_dma( void *addr );
+
+/****************************************************************************/
+/**
+*   Initializes a memory map for use. Since this function acquires a
+*   sempaphore within the memory map, it is VERY important that dma_unmap
+*   be called when you're finished using the map.
+*/
+/****************************************************************************/
+
+int dma_map_start
+(
+    DMA_MemMap_t           *memMap, ///< Stores state information about the map
+    enum dma_data_direction dir     ///< Direction that the mapping will be going
+);
+
+/****************************************************************************/
+/**
+*   Adds a segment of memory to a memory map.
+*
+*   @return     0 on success, error code otherwise.
+*/
+/****************************************************************************/
+
+int dma_map_add_region
+(
+    DMA_MemMap_t           *memMap,     ///< Stores state information about the map
+    void                   *mem,        ///< Virtual address that we want to get a map of
+    size_t                  numBytes    ///< Number of bytes being mapped
+);
+
+/****************************************************************************/
+/**
+*   Creates a descriptor ring from a memory mapping.
+*
+*   @return 0 on sucess, error code otherwise.
+*/
+/****************************************************************************/
+
+int dma_map_create_descriptor_ring
+(
+    DMA_Device_t            dev,        ///< DMA device (where the ring is stored)
+    DMA_MemMap_t           *memMap,     ///< Memory map that will be used
+    dma_addr_t              devPhysAddr ///< Physical address of device
+);
+
+/****************************************************************************/
+/**
+*   Maps in a memory region such that it can be used for performing a DMA.
+*
+*   @return
+*/
+/****************************************************************************/
+
+int dma_map_mem
+(
+    DMA_MemMap_t           *memMap, ///< Stores state information about the map
+    void                   *addr,   ///< Virtual address that we want to get a map of
+    size_t                  count,  ///< Number of bytes being mapped
+    enum dma_data_direction dir     ///< Direction that the mapping will be going
+);
+
+/****************************************************************************/
+/**
+*   Maps in a memory region such that it can be used for performing a DMA.
+*
+*   @return
+*/
+/****************************************************************************/
+
+int dma_unmap
+(
+    DMA_MemMap_t       *memMap, ///< Stores state information about the map
+    int                 dirtied ///< non-zero if any of the pages were modified
+);
+
+/****************************************************************************/
+/**
+*   Initiates a transfer when the descriptors have already been setup.
+*
+*   This is a special case, and normally, the dma_transfer_xxx functions should
+*   be used.
+*
+*   @return
+*       0       Transfer was started successfully
+*       -ENODEV Invalid handle
+*/
+/****************************************************************************/
+
+int dma_start_transfer( DMA_Handle_t handle );
+
+/****************************************************************************/
+/**
+*   Stops a previously started DMA transfer.
+*
+*   @return
+*       0       Transfer was stopped successfully
+*       -ENODEV Invalid handle
+*/
+/****************************************************************************/
+
+int dma_stop_transfer( DMA_Handle_t handle );
+
+/****************************************************************************/
+/**
+*   Waits for a DMA to complete by polling. This function is only intended
+*   to be used for testing. Interrupts should be used for most DMA operations.
+*/
+/****************************************************************************/
+
+int dma_wait_transfer_done( DMA_Handle_t handle );
+
+/****************************************************************************/
+/**
+*   Initiates a DMA transfer
+*
+*   @return
+*       0       Transfer was started successfully
+*       -EINVAL Invalid device type for this kind of transfer
+*               (i.e. the device is _MEM_TO_DEV and not _DEV_TO_MEM)
+*/
+/****************************************************************************/
+
+int dma_transfer
+(
+    DMA_Handle_t            handle,         ///< DMA Handle
+    dmacHw_TRANSFER_TYPE_e  transferType,   ///< Type of transfer being performed
+    dma_addr_t              srcData,        ///< Place to get data to write to device
+    dma_addr_t              dstData,        ///< Pointer to device data address
+    size_t                  numBytes        ///< Number of bytes to transfer to the device
+);
+
+/****************************************************************************/
+/**
+*   Initiates a transfer from memory to a device.
+*
+*   @return
+*       0       Transfer was started successfully
+*       -EINVAL Invalid device type for this kind of transfer
+*               (i.e. the device is _DEV_TO_MEM and not _MEM_TO_DEV)
+*/
+/****************************************************************************/
+
+static inline int dma_transfer_to_device
+(
+    DMA_Handle_t handle,    ///< DMA Handle
+    dma_addr_t   srcData,   ///< Place to get data to write to device (physical address)
+    dma_addr_t   dstData,   ///< Pointer to device data address (physical address)
+    size_t       numBytes   ///< Number of bytes to transfer to the device
+)
+{
+    return dma_transfer( handle,
+                         dmacHw_TRANSFER_TYPE_MEM_TO_PERIPHERAL,
+                         srcData,
+                         dstData,
+                         numBytes );
+}
+
+/****************************************************************************/
+/**
+*   Initiates a transfer from a device to memory.
+*
+*   @return
+*       0       Transfer was started successfully
+*       -EINVAL Invalid device type for this kind of transfer
+*               (i.e. the device is _MEM_TO_DEV and not _DEV_TO_MEM)
+*/
+/****************************************************************************/
+
+static inline int dma_transfer_from_device
+(
+    DMA_Handle_t handle,    ///< DMA Handle
+    dma_addr_t   srcData,   ///< Pointer to the device data address (physical address)
+    dma_addr_t   dstData,   ///< Place to store data retrieved from the device (physical address)
+    size_t       numBytes   ///< Number of bytes to retrieve from the device
+)
+{
+    return dma_transfer( handle,
+                         dmacHw_TRANSFER_TYPE_PERIPHERAL_TO_MEM,
+                         srcData,
+                         dstData,
+                         numBytes );
+}
+
+/****************************************************************************/
+/**
+*   Initiates a memory to memory transfer.
+*
+*   @return
+*       0       Transfer was started successfully
+*       -EINVAL Invalid device type for this kind of transfer
+*               (i.e. the device wasn't DMA_DEVICE_MEM_TO_MEM)
+*/
+/****************************************************************************/
+
+static inline int dma_transfer_mem_to_mem
+(
+    DMA_Handle_t handle,    ///< DMA Handle
+    dma_addr_t   srcData,   ///< Place to transfer data from (physical address)
+    dma_addr_t   dstData,   ///< Place to transfer data to (physical address)
+    size_t       numBytes   ///< Number of bytes to transfer
+)
+{
+    return dma_transfer( handle,
+                         dmacHw_TRANSFER_TYPE_MEM_TO_MEM,
+                         srcData,
+                         dstData,
+                         numBytes );
+}
+
+/****************************************************************************/
+/**
+*   Set the callback function which will be called when a transfer completes.
+*   If a NULL callback function is set, then no callback will occur.
+*
+*   @note   @a devHandler will be called from IRQ context.
+*
+*   @return
+*       0       - Success
+*       -ENODEV - Device handed in is invalid.
+*/
+/****************************************************************************/
+
+int dma_set_device_handler
+(
+    DMA_Device_t         dev,           ///< Device to set the callback for.
+    DMA_DeviceHandler_t  devHandler,    ///< Function to call when the DMA completes
+    void                *userData       ///< Pointer which will be passed to devHandler.
+);
+
+#endif
+
+#endif  /* ASM_ARM_ARCH_BCMRING_DMA_H */
+
diff --git a/arch/arm/mach-bcmring/include/mach/entry-macro.S b/arch/arm/mach-bcmring/include/mach/entry-macro.S
new file mode 100644
index 0000000..6201bb0
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/entry-macro.S
@@ -0,0 +1,94 @@
+/*****************************************************************************
+* Copyright 2006 - 2008 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+
+
+/*
+ *
+ * Low-level IRQ helper macros for BCM116X-based platforms
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+#include <mach/irqs.h>
+#include <mach/hardware.h>
+#include <mach/irqs.h>
+#include <mach/csp/mm_io.h>
+
+               .macro  disable_fiq
+               .endm
+
+               .macro  get_irqnr_and_base, irqnr, irqstat, base, tmp
+               ldr     \base, =(MM_IO_BASE_INTC0)
+               ldr     \irqstat, [\base, #0]           @ get status
+                ldr     \irqnr, [\base, #0x10]          @ mask with enable register
+                ands    \irqstat, \irqstat, \irqnr
+               mov     \irqnr, #IRQ_INTC0_START
+               cmp     \irqstat, #0
+               bne     1001f
+
+               ldr     \base, =(MM_IO_BASE_INTC1)
+               ldr     \irqstat, [\base, #0]           @ get status
+                ldr     \irqnr, [\base, #0x10]          @ mask with enable register
+                ands    \irqstat, \irqstat, \irqnr
+               mov     \irqnr, #IRQ_INTC1_START
+               cmp     \irqstat, #0
+               bne     1001f
+
+               ldr     \base, =(MM_IO_BASE_SINTC)
+               ldr     \irqstat, [\base, #0]           @ get status
+                ldr     \irqnr, [\base, #0x10]          @ mask with enable register
+                ands    \irqstat, \irqstat, \irqnr
+               mov     \irqnr, #0xffffffff             @ code meaning no interrupt bits set
+               cmp     \irqstat, #0
+               beq     1002f
+
+               mov     \irqnr, #IRQ_SINTC_START        @ something is set, so fixup return value
+
+1001:
+               movs    \tmp, \irqstat, lsl #16
+               movne   \irqstat, \tmp
+               addeq   \irqnr, \irqnr, #16
+
+               movs    \tmp, \irqstat, lsl #8
+               movne   \irqstat, \tmp
+               addeq   \irqnr, \irqnr, #8
+
+               movs    \tmp, \irqstat, lsl #4
+               movne   \irqstat, \tmp
+               addeq   \irqnr, \irqnr, #4
+
+               movs    \tmp, \irqstat, lsl #2
+               movne   \irqstat, \tmp
+               addeq   \irqnr, \irqnr, #2
+
+               movs    \tmp, \irqstat, lsl #1
+               addeq   \irqnr, \irqnr, #1
+               orrs    \base, \base, #1
+
+1002:           @ irqnr will be set to 0xffffffff if no irq bits are set
+               .endm
+
+
+               .macro  get_irqnr_preamble, base, tmp
+               .endm
+
+               .macro  arch_ret_to_user, tmp1, tmp2
+               .endm
+
+               .macro  irq_prio_table
+               .endm
+
+
diff --git a/arch/arm/mach-bcmring/include/mach/hardware.h b/arch/arm/mach-bcmring/include/mach/hardware.h
new file mode 100644
index 0000000..65f853b
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/hardware.h
@@ -0,0 +1,65 @@
+/*
+ *
+ *  This file contains the hardware definitions of the BCM116X.
+ *
+ *  Copyright (C) 1999 ARM Limited.
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
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+#ifndef __ASM_ARCH_HARDWARE_H
+#define __ASM_ARCH_HARDWARE_H
+
+#include <asm/sizes.h>
+#include <mach/memory.h>
+#include <cfg_global.h>
+#include <mach/csp/mm_io.h>
+
+/* Hardware addresses of major areas.
+ *  *_START is the physical address
+ *  *_SIZE  is the size of the region
+ *  *_BASE  is the virtual address
+ */
+#define RAM_START               PHYS_OFFSET
+
+//#define RAM_SIZE                SZ_32M
+#define RAM_SIZE                (CFG_GLOBAL_RAM_SIZE-CFG_GLOBAL_RAM_SIZE_RESERVED)
+#define RAM_BASE                PAGE_OFFSET
+
+#define pcibios_assign_all_busses()    1
+
+// Macros to make managing spinlocks a bit more controlled in terms of naming.
+// See reg_gpio.h, reg_irq.h, arch.c, gpio.c for example usage.
+#if defined( __KERNEL__ )
+#define HW_DECLARE_SPINLOCK(name)  spinlock_t g##name##RegLock = SPIN_LOCK_UNLOCKED;
+#define HW_EXTERN_SPINLOCK(name)   extern spinlock_t g##name##RegLock;
+#define HW_IRQ_SAVE(name, val)     spin_lock_irqsave(&g##name##RegLock,(val))
+#define HW_IRQ_RESTORE(name, val)  spin_unlock_irqrestore(&g##name##RegLock,(val))
+#else
+#define HW_DECLARE_SPINLOCK(name)
+#define HW_EXTERN_SPINLOCK(name)
+#define HW_IRQ_SAVE(name, val)     {(void)(name);(void)(val);}
+#define HW_IRQ_RESTORE(name, val)  {(void)(name);(void)(val);}
+#endif
+
+#define IO_START MM_IO_START
+#define IO_BASE  MM_IO_BASE
+#ifndef HW_IO_PHYS_TO_VIRT
+#define HW_IO_PHYS_TO_VIRT MM_IO_PHYS_TO_VIRT
+#endif
+#define HW_IO_VIRT_TO_PHYS MM_IO_VIRT_TO_PHYS
+
+
+#endif
+
diff --git a/arch/arm/mach-bcmring/include/mach/io.h b/arch/arm/mach-bcmring/include/mach/io.h
new file mode 100644
index 0000000..d3513b9
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/io.h
@@ -0,0 +1,61 @@
+/*
+ *
+ *  Copyright (C) 1999 ARM Limited
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
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+#ifndef __ASM_ARM_ARCH_IO_H
+#define __ASM_ARM_ARCH_IO_H
+
+#include <mach/hardware.h>
+
+#define IO_SPACE_LIMIT 0xffffffff
+
+#define __io(a)         ((void __iomem *)HW_IO_PHYS_TO_VIRT(a))
+
+// Do not enable mem_pci for a big endian arm architecture or unexpected byteswaps will
+// happen in readw/writew etc.
+//#define __mem_pci(a)         ((unsigned long)(a))
+
+//#define __mem_isa(a)         (PCI_MEMORY_VADDR + (unsigned long)(a))
+
+
+#define readb(c)        __raw_readb(c)
+#define readw(c)        __raw_readw(c)
+#define readl(c)        __raw_readl(c)
+#define readb_relaxed(addr) readb(addr)
+#define readw_relaxed(addr) readw(addr)
+#define readl_relaxed(addr) readl(addr)
+
+#define readsb(p,d,l)   __raw_readsb(p,d,l)
+#define readsw(p,d,l)   __raw_readsw(p,d,l)
+#define readsl(p,d,l)   __raw_readsl(p,d,l)
+
+#define writeb(v,c)     __raw_writeb(v,c)
+#define writew(v,c)     __raw_writew(v,c)
+#define writel(v,c)     __raw_writel(v,c)
+
+#define writesb(p,d,l)  __raw_writesb(p,d,l)
+#define writesw(p,d,l)  __raw_writesw(p,d,l)
+#define writesl(p,d,l)  __raw_writesl(p,d,l)
+
+#define memset_io(c,v,l)    _memset_io((c),(v),(l))
+#define memcpy_fromio(a,c,l)    _memcpy_fromio((a),(c),(l))
+#define memcpy_toio(c,a,l)  _memcpy_toio((c),(a),(l))
+
+#define eth_io_copy_and_sum(s,c,l,b) \
+                eth_copy_and_sum((s),(c),(l),(b))
+
+#endif
diff --git a/arch/arm/mach-bcmring/include/mach/irqs.h b/arch/arm/mach-bcmring/include/mach/irqs.h
new file mode 100644
index 0000000..0bb97be
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/irqs.h
@@ -0,0 +1,139 @@
+/*
+ *  Copyright (C) 2007 Broadcom
+ *  Copyright (C) 1999 ARM Limited
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
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#if !defined( ARCH_BCMRING_IRQS_H )
+#define ARCH_BCMRING_IRQS_H
+
+// INTC0 - interrupt controller 0
+#define IRQ_INTC0_START     0
+#define IRQ_DMA0C0          0     // DMA0 channel 0 interrupt
+#define IRQ_DMA0C1          1     // DMA0 channel 1 interrupt
+#define IRQ_DMA0C2          2     // DMA0 channel 2 interrupt
+#define IRQ_DMA0C3          3     // DMA0 channel 3 interrupt
+#define IRQ_DMA0C4          4     // DMA0 channel 4 interrupt
+#define IRQ_DMA0C5          5     // DMA0 channel 5 interrupt
+#define IRQ_DMA0C6          6     // DMA0 channel 6 interrupt
+#define IRQ_DMA0C7          7     // DMA0 channel 7 interrupt
+#define IRQ_DMA1C0          8     // DMA1 channel 0 interrupt
+#define IRQ_DMA1C1          9     // DMA1 channel 1 interrupt
+#define IRQ_DMA1C2         10     // DMA1 channel 2 interrupt
+#define IRQ_DMA1C3         11     // DMA1 channel 3 interrupt
+#define IRQ_DMA1C4         12     // DMA1 channel 4 interrupt
+#define IRQ_DMA1C5         13     // DMA1 channel 5 interrupt
+#define IRQ_DMA1C6         14     // DMA1 channel 6 interrupt
+#define IRQ_DMA1C7         15     // DMA1 channel 7 interrupt
+#define IRQ_VPM            16     // Voice process module interrupt
+#define IRQ_USBHD2         17     // USB host2/device2 interrupt
+#define IRQ_USBH1          18     // USB1 host interrupt
+#define IRQ_USBD           19     // USB device interrupt
+#define IRQ_SDIOH0         20     // SDIO0 host interrupt
+#define IRQ_SDIOH1         21     // SDIO1 host interrupt
+#define IRQ_TIMER0         22     // Timer0 interrupt
+#define IRQ_TIMER1         23     // Timer1 interrupt
+#define IRQ_TIMER2         24     // Timer2 interrupt
+#define IRQ_TIMER3         25     // Timer3 interrupt
+#define IRQ_SPIH           26     // SPI host interrupt
+#define IRQ_ESW            27     // Ethernet switch interrupt
+#define IRQ_APM            28     // Audio process module interrupt
+#define IRQ_GE             29     // Graphic engine interrupt
+#define IRQ_CLCD           30     // LCD Controller interrupt
+#define IRQ_PIF            31     // Peripheral interface interrupt
+#define IRQ_INTC0_END      31
+
+// INTC1 - interrupt controller 1
+#define IRQ_INTC1_START    32
+#define IRQ_GPIO0          32     //  0 GPIO bit 31//0 combined interrupt
+#define IRQ_GPIO1          33     //  1 GPIO bit 64//32 combined interrupt
+#define IRQ_I2S0           34     //  2 I2S0 interrupt
+#define IRQ_I2S1           35     //  3 I2S1 interrupt
+#define IRQ_I2CH           36     //  4 I2C host interrupt
+#define IRQ_I2CS           37     //  5 I2C slave interrupt
+#define IRQ_SPIS           38     //  6 SPI slave interrupt
+#define IRQ_GPHY           39     //  7 Gigabit Phy interrupt
+#define IRQ_FLASHC         40     //  8 Flash controller interrupt
+#define IRQ_COMMTX         41     //  9 ARM DDC transmit interrupt
+#define IRQ_COMMRX         42     // 10 ARM DDC receive interrupt
+#define IRQ_PMUIRQ         43     // 11 ARM performance monitor interrupt
+#define IRQ_UARTB          44     // 12 UARTB
+#define IRQ_WATCHDOG       45     // 13 Watchdog timer interrupt
+#define IRQ_UARTA          46     // 14 UARTA
+#define IRQ_TSC            47     // 15 Touch screen controller interrupt
+#define IRQ_KEYC           48     // 16 Key pad controller interrupt
+#define IRQ_DMPU           49     // 17 DDR2 memory partition interrupt
+#define IRQ_VMPU           50     // 18 VRAM memory partition interrupt
+#define IRQ_FMPU           51     // 19 Flash memory parition unit interrupt
+#define IRQ_RNG            52     // 20 Random number generator interrupt
+#define IRQ_RTC0           53     // 21 Real time clock periodic interrupt
+#define IRQ_RTC1           54     // 22 Real time clock one-shot interrupt
+#define IRQ_SPUM           55     // 23 Secure process module interrupt
+#define IRQ_VDEC           56     // 24 Hantro video decoder interrupt
+#define IRQ_RTC2           57     // 25 Real time clock tamper interrupt
+#define IRQ_DDRP           58     // 26 DDR Panic interrupt
+#define IRQ_INTC1_END      58
+
+// SINTC secure int controller
+#define IRQ_SINTC_START    59
+#define IRQ_SEC_WATCHDOG   59     //  0 Watchdog timer interrupt
+#define IRQ_SEC_UARTA      60     //  1 UARTA interrupt
+#define IRQ_SEC_TSC        61     //  2 Touch screen controller interrupt
+#define IRQ_SEC_KEYC       62     //  3 Key pad controller interrupt
+#define IRQ_SEC_DMPU       63     //  4 DDR2 memory partition interrupt
+#define IRQ_SEC_VMPU       64     //  5 VRAM memory partition interrupt
+#define IRQ_SEC_FMPU       65     //  6 Flash memory parition unit interrupt
+#define IRQ_SEC_RNG        66     //  7 Random number generator interrupt
+#define IRQ_SEC_RTC0       67     //  8 Real time clock periodic interrupt
+#define IRQ_SEC_RTC1       68     //  9 Real time clock one-shot interrupt
+#define IRQ_SEC_SPUM       69     // 10 Secure process module interrupt
+#define IRQ_SEC_TIMER0     70     // 11 Secure timer0 interrupt
+#define IRQ_SEC_TIMER1     71     // 12 Secure timer1 interrupt
+#define IRQ_SEC_TIMER2     72     // 13 Secure timer2 interrupt
+#define IRQ_SEC_TIMER3     73     // 14 Secure timer3 interrupt
+#define IRQ_SEC_RTC2       74     // 15 Real time clock tamper interrupt
+
+#define IRQ_SINTC_END      74
+
+// Note: there are 3 INTC registers of 32 bits each. So internal IRQs could go from 0-95
+//       Since IRQs are typically viewed in decimal, we start the gpio based IRQs off at 100
+//       to make the mapping easy for humans to decipher.
+
+#define IRQ_GPIO_0                  100
+
+#define NUM_INTERNAL_IRQS          (IRQ_SINTC_END+1)
+
+
+// I couldn't get the gpioHw_reg.h file to be included cleanly, so I hardcoded it
+//#define NUM_GPIO_IRQS               GPIOHW_TOTAL_NUM_PINS
+#define NUM_GPIO_IRQS               62
+
+#define NR_IRQS                     (IRQ_GPIO_0 + NUM_GPIO_IRQS)
+
+#define IRQ_UNKNOWN                 -1
+
+
+// Tune these bits to preclude noisy or unsupported interrupt sources as required.
+#define IRQ_INTC0_VALID_MASK        0xffffffff
+#define IRQ_INTC1_VALID_MASK        0x07ffffff
+#define IRQ_SINTC_VALID_MASK        0x0000ffff
+
+
+#define  gpio_to_irq( gpio )        ((gpio) + IRQ_GPIO_0 )
+#define  irq_to_gpio( irq )         ((irq) - IRQ_GPIO_0 )
+
+#endif  // ARCH_BCMRING_IRQS_H
+
diff --git a/arch/arm/mach-bcmring/include/mach/memory.h b/arch/arm/mach-bcmring/include/mach/memory.h
new file mode 100644
index 0000000..3e35fc1
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/memory.h
@@ -0,0 +1,47 @@
+/*****************************************************************************
+* Copyright 2005 - 2008 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+
+
+#ifndef __ASM_ARCH_MEMORY_H
+#define __ASM_ARCH_MEMORY_H
+
+#include <cfg_global.h>
+
+/*
+ * Physical vs virtual RAM address space conversion.  These are
+ * private definitions which should NOT be used outside memory.h
+ * files.  Use virt_to_phys/phys_to_virt/__pa/__va instead.
+ */
+
+#define PHYS_OFFSET CFG_GLOBAL_RAM_BASE
+
+/*
+ * Maximum DMA memory allowed is 14M
+ */
+#define CONSISTENT_DMA_SIZE (SZ_16M - SZ_2M)
+
+/*
+ * DEPRECATED: See include/asm/memory.h
+ *
+ * Virtual view <-> DMA view memory address translations
+ * virt_to_bus: Used to translate the virtual address to an
+ *              address suitable to be passed to set_dma_addr
+ * bus_to_virt: Used to convert an address for DMA operations
+ *              to an address that the kernel can use.
+ */
+#define __virt_to_bus(x) __virt_to_phys(x)
+#define __bus_to_virt(x) __phys_to_virt(x)
+
+#endif
diff --git a/arch/arm/mach-bcmring/include/mach/memory_settings.h b/arch/arm/mach-bcmring/include/mach/memory_settings.h
new file mode 100644
index 0000000..cee1a6c
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/memory_settings.h
@@ -0,0 +1,69 @@
+/*****************************************************************************
+* Copyright 2004 - 2008 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+#ifndef MEMORY_SETTINGS_H
+#define MEMORY_SETTINGS_H
+
+// ---- Include Files ----------------------------------------
+// ---- Constants and Types ----------------------------------
+
+// Memory devices
+//
+/* NAND Flash timing for 166 MHz setting */
+#define HW_CFG_NAND_tBTA  ( 5 << 16 ) /* Bus turnaround cycle (n)        0-7  (30 ns) */
+#define HW_CFG_NAND_tWP   ( 4 << 11 ) /* Write pulse width cycle (n+1)   0-31 (25 ns) */
+#define HW_CFG_NAND_tWR   ( 1 << 9  ) /* Write recovery cycle (n+1)      0-3  (10 ns) */
+#define HW_CFG_NAND_tAS   ( 0 << 7  ) /* Write address setup cycle (n+1) 0-3  ( 0 ns) */
+#define HW_CFG_NAND_tOE   ( 3 << 5  ) /* Output enable delay cycle (n)   0-3  (15 ns) */
+#define HW_CFG_NAND_tRC   ( 7 << 0  ) /* Read access cycle (n+2)         0-31 (50 ns) */
+
+#define HW_CFG_NAND_TCR ( HW_CFG_NAND_tBTA \
+                        | HW_CFG_NAND_tWP  \
+                        | HW_CFG_NAND_tWR  \
+                        | HW_CFG_NAND_tAS  \
+                        | HW_CFG_NAND_tOE  \
+                        | HW_CFG_NAND_tRC )
+
+/* NOR Flash timing for 166 MHz setting */
+#define HW_CFG_NOR_TPRC_TWLC ( 0 << 19 ) /* Page read access cycle / Burst write latency (n+2 / n+1) (max 25ns) */
+#define HW_CFG_NOR_TBTA      ( 0 << 16 ) /* Bus turnaround cycle (n)                                 (DNA)      */
+#define HW_CFG_NOR_TWP       ( 6 << 11 ) /* Write pulse width cycle (n+1)                            (35ns)     */
+#define HW_CFG_NOR_TWR       ( 0 << 9  ) /* Write recovery cycle (n+1)                               (0ns)      */
+#define HW_CFG_NOR_TAS       ( 0 << 7  ) /* Write address setup cycle (n+1)                          (0ns)      */
+#define HW_CFG_NOR_TOE       ( 0 << 5  ) /* Output enable delay cycle (n)                            (max 25ns) */
+#define HW_CFG_NOR_TRC_TLC   ( 0x10 << 0  ) /* Read access cycle / Burst read latency (n+2 / n+1)       (100ns)    */
+
+#define HW_CFG_FLASH0_TCR ( HW_CFG_NOR_TPRC_TWLC \
+                          | HW_CFG_NOR_TBTA      \
+                          | HW_CFG_NOR_TWP       \
+                          | HW_CFG_NOR_TWR       \
+                          | HW_CFG_NOR_TAS       \
+                          | HW_CFG_NOR_TOE       \
+                          | HW_CFG_NOR_TRC_TLC )
+#define HW_CFG_FLASH1_TCR    HW_CFG_FLASH0_TCR
+#define HW_CFG_FLASH2_TCR    HW_CFG_FLASH0_TCR
+
+// SDRAM Settings
+//
+// #define HW_CFG_SDRAM_CAS_LATENCY        5   // Default 5, Values [3..6]
+// #define HW_CFG_SDRAM_CHIP_SELECT_CNT    1   // Default 1, Vaules [1..2]
+// #define HW_CFG_SDRAM_SPEED_GRADE        667 // Default 667, Values [400,533,667,800]
+// #define HW_CFG_SDRAM_WIDTH_BITS         16  // Default 16, Vaules [8,16]
+//
+#define HW_CFG_SDRAM_SIZE_BYTES         0x10000000  // Total memory, not per device size
+
+// ---- Variable Externs -------------------------------------
+// ---- Function Prototypes ----------------------------------
+
+#endif /* MEMORY_SETTINGS_H */
diff --git a/arch/arm/mach-bcmring/include/mach/reg_nand.h b/arch/arm/mach-bcmring/include/mach/reg_nand.h
new file mode 100644
index 0000000..e7853cc
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/reg_nand.h
@@ -0,0 +1,65 @@
+/*****************************************************************************
+* Copyright 2001 - 2008 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+
+
+
+/*
+*
+*****************************************************************************
+*
+*  REG_NAND.h
+*
+*  PURPOSE:
+*
+*     This file contains definitions for the nand registers:
+*
+*  NOTES:
+*
+*****************************************************************************/
+
+
+#if !defined( __ASM_ARCH_REG_NAND_H )
+#define __ASM_ARCH_REG_NAND_H
+
+/* ---- Include Files ---------------------------------------------------- */
+#include <csp/reg.h>
+#include <mach/reg_umi.h>
+
+/* ---- Constants and Types ---------------------------------------------- */
+
+#define HW_NAND_BASE       MM_IO_BASE_NAND   // NAND Flash
+
+// DMA accesses by the bootstrap need hard nonvirtual addresses
+#define REG_NAND_CMD            __REG16( HW_NAND_BASE + 0 )
+#define REG_NAND_ADDR           __REG16( HW_NAND_BASE + 4 )
+
+#define REG_NAND_PHYS_DATA16   (HW_NAND_BASE + 8)
+#define REG_NAND_PHYS_DATA8    (HW_NAND_BASE + 8)
+#define REG_NAND_DATA16         __REG16( REG_NAND_PHYS_DATA16 )
+#define REG_NAND_DATA8          __REG8 ( REG_NAND_PHYS_DATA8 )
+
+/* use appropriate offset to make sure it start at the 1K boundary */
+#define REG_NAND_PHYS_DATA_DMA   (HW_NAND_BASE + 0x400)
+#define REG_NAND_DATA_DMA         __REG32( REG_NAND_PHYS_DATA_DMA )
+
+/* Linux DMA requires physical address of the data register */
+#define REG_NAND_DATA16_PADDR    HW_IO_VIRT_TO_PHYS( REG_NAND_PHYS_DATA16 )
+#define REG_NAND_DATA8_PADDR     HW_IO_VIRT_TO_PHYS( REG_NAND_PHYS_DATA8 )
+#define REG_NAND_DATA_PADDR      HW_IO_VIRT_TO_PHYS( REG_NAND_PHYS_DATA_DMA )
+
+#define NAND_BUS_16BIT()        ( 0 )
+#define NAND_BUS_8BIT()         ( !NAND_BUS_16BIT() )
+
+#endif
diff --git a/arch/arm/mach-bcmring/include/mach/reg_umi.h b/arch/arm/mach-bcmring/include/mach/reg_umi.h
new file mode 100644
index 0000000..8d0820e
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/reg_umi.h
@@ -0,0 +1,149 @@
+/*****************************************************************************
+* Copyright 2005 - 2008 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+
+
+
+/*
+*
+*****************************************************************************
+*
+*  REG_UMI.h
+*
+*  PURPOSE:
+*
+*     This file contains definitions for the nand registers:
+*
+*  NOTES:
+*
+*****************************************************************************/
+
+
+#if !defined( __ASM_ARCH_REG_UMI_H )
+#define __ASM_ARCH_REG_UMI_H
+
+/* ---- Include Files ---------------------------------------------------- */
+#include <csp/reg.h>
+#include <mach/csp/mm_io.h>
+
+/* ---- Constants and Types ---------------------------------------------- */
+
+#define HW_UMI_BASE       MM_IO_BASE_UMI   // Unified Memory Interface Ctrl Register
+
+#define REG_UMI_FLASH0_TCR         __REG32( HW_UMI_BASE  + 0x00 )     // Flash bank 0 timing and control register
+#define REG_UMI_FLASH1_TCR         __REG32( HW_UMI_BASE  + 0x04 )     // Flash bank 1 timing and control register
+#define REG_UMI_FLASH2_TCR         __REG32( HW_UMI_BASE  + 0x08 )     // Flash bank 2 timing and control register
+#define REG_UMI_MMD_ICR            __REG32( HW_UMI_BASE  + 0x0c )     // MMD interface and control register
+#define REG_UMI_NAND_TCR           __REG32( HW_UMI_BASE  + 0x18 )     // NAND timing and control register
+#define REG_UMI_NAND_RCSR          __REG32( HW_UMI_BASE  + 0x1c )     // NAND ready/chip select register
+#define REG_UMI_NAND_ECC_CSR       __REG32( HW_UMI_BASE  + 0x20 )     // NAND ECC control & status register
+#define REG_UMI_NAND_ECC_DATA      __REG32( HW_UMI_BASE  + 0x24 )     // NAND ECC data register XXB2B1B0
+#define REG_UMI_BCH_N              __REG32( HW_UMI_BASE  + 0x40 )     // BCH ECC Parameter N
+#define REG_UMI_BCH_K              __REG32( HW_UMI_BASE  + 0x44 )     // BCH ECC Parameter T
+#define REG_UMI_BCH_T              __REG32( HW_UMI_BASE  + 0x48 )     // BCH ECC Parameter K
+#define REG_UMI_BCH_CTRL_STATUS    __REG32( HW_UMI_BASE  + 0x4C )     // BCH ECC Contro Status
+#define REG_UMI_BCH_WR_ECC_0       __REG32( HW_UMI_BASE  + 0x50 )     // BCH WR ECC 31:0
+#define REG_UMI_BCH_WR_ECC_1       __REG32( HW_UMI_BASE  + 0x54 )     // BCH WR ECC 63:32
+#define REG_UMI_BCH_WR_ECC_2       __REG32( HW_UMI_BASE  + 0x58 )     // BCH WR ECC 95:64
+#define REG_UMI_BCH_WR_ECC_3       __REG32( HW_UMI_BASE  + 0x5c )     // BCH WR ECC 127:96
+#define REG_UMI_BCH_WR_ECC_4       __REG32( HW_UMI_BASE  + 0x60 )     // BCH WR ECC 155:128
+#define REG_UMI_BCH_RD_ERR_LOC_1_0 __REG32( HW_UMI_BASE  + 0x64 )     // BCH Read Error Location 1,0
+#define REG_UMI_BCH_RD_ERR_LOC_3_2 __REG32( HW_UMI_BASE  + 0x68 )     // BCH Read Error Location 3,2
+#define REG_UMI_BCH_RD_ERR_LOC_5_4 __REG32( HW_UMI_BASE  + 0x6c )     // BCH Read Error Location 5,4
+#define REG_UMI_BCH_RD_ERR_LOC_7_6 __REG32( HW_UMI_BASE  + 0x70 )     // BCH Read Error Location 7,6
+#define REG_UMI_BCH_RD_ERR_LOC_9_8 __REG32( HW_UMI_BASE  + 0x74 )     // BCH Read Error Location 9,8
+#define REG_UMI_BCH_RD_ERR_LOC_B_A __REG32( HW_UMI_BASE  + 0x78 )     // BCH Read Error Location 11,10
+
+// REG_UMI_FLASH0/1/2_TCR, REG_UMI_SRAM0/1_TCR bits
+#define REG_UMI_TCR_WAITEN              0x80000000          // Enable wait pin during burst write or read
+#define REG_UMI_TCR_LOWFREQ             0x40000000          // Enable mem ctrlr to work iwth ext mem of lower freq than AHB clk
+#define REG_UMI_TCR_MEMTYPE_SYNCWRITE   0x20000000          // 1=synch write, 0=async write
+#define REG_UMI_TCR_MEMTYPE_SYNCREAD    0x10000000          // 1=synch read, 0=async read
+#define REG_UMI_TCR_MEMTYPE_PAGEREAD    0x08000000          // 1=page mode read, 0=normal mode read
+#define REG_UMI_TCR_MEMTYPE_PGSZ_MASK   0x07000000          // page size/burst size (wrap only)
+#define REG_UMI_TCR_MEMTYPE_PGSZ_4      0x00000000          // 4 word
+#define REG_UMI_TCR_MEMTYPE_PGSZ_8      0x01000000          // 8 word
+#define REG_UMI_TCR_MEMTYPE_PGSZ_16     0x02000000          // 16 word
+#define REG_UMI_TCR_MEMTYPE_PGSZ_32     0x03000000          // 32 word
+#define REG_UMI_TCR_MEMTYPE_PGSZ_64     0x04000000          // 64 word
+#define REG_UMI_TCR_MEMTYPE_PGSZ_128    0x05000000          // 128 word
+#define REG_UMI_TCR_MEMTYPE_PGSZ_256    0x06000000          // 256 word
+#define REG_UMI_TCR_MEMTYPE_PGSZ_512    0x07000000          // 512 word
+#define REG_UMI_TCR_TPRC_TWLC_MASK      0x00f80000          // Page read access cycle / Burst write latency (n+2 / n+1)
+#define REG_UMI_TCR_TBTA_MASK           0x00070000          // Bus turnaround cycle (n)
+#define REG_UMI_TCR_TWP_MASK            0x0000f800          // Write pulse width cycle (n+1)
+#define REG_UMI_TCR_TWR_MASK            0x00000600          // Write recovery cycle (n+1)
+#define REG_UMI_TCR_TAS_MASK            0x00000180          // Write address setup cycle (n+1)
+#define REG_UMI_TCR_TOE_MASK            0x00000060          // Output enable delay cycle (n)
+#define REG_UMI_TCR_TRC_TLC_MASK        0x0000001f          // Read access cycle / Burst read latency (n+2 / n+1)
+
+
+// REG_UMI_MMD_ICR bits
+#define REG_UMI_MMD_ICR_FLASH_WP            0x8000          // Flash write protection pin control
+#define REG_UMI_MMD_ICR_XHCS                0x4000          // Extend hold time for sram0, sram1 csn (39 MHz operation)
+#define REG_UMI_MMD_ICR_SDRAM2EN            0x2000          // Enable SDRAM 2 interface control
+#define REG_UMI_MMD_ICR_INST512             0x1000          // Enable merge of flash banks 0/1 to 512 MBit bank
+#define REG_UMI_MMD_ICR_DATA512             0x0800          // Enable merge of flash banks 1/2 to 512 MBit bank
+#define REG_UMI_MMD_ICR_SDRAMEN             0x0400          // Enable SDRAM interface control
+#define REG_UMI_MMD_ICR_WAITPOL             0x0200          // Polarity of busy state of Burst Wait Signal
+#define REG_UMI_MMD_ICR_BCLKSTOP            0x0100          // Enable burst clock stopped when not accessing external burst flash/sram
+#define REG_UMI_MMD_ICR_PERI1EN             0x0080          // Enable the peri1_csn to replace flash1_csn in 512 Mb flash mode
+#define REG_UMI_MMD_ICR_PERI2EN             0x0040          // Enable the peri2_csn to replace sdram_csn
+#define REG_UMI_MMD_ICR_PERI3EN             0x0020          // Enable the peri3_csn to replace sdram2_csn
+#define REG_UMI_MMD_ICR_MRSB1               0x0010          // Enable sram bank1 for H/W controlled MRS
+#define REG_UMI_MMD_ICR_MRSB0               0x0008          // Enable sram bank0 for H/W controlled MRS
+#define REG_UMI_MMD_ICR_MRSPOL              0x0004          // Polarity for assert3ed state of H/W controlled MRS
+#define REG_UMI_MMD_ICR_MRSMODE             0x0002          // 0: S/W controllable ZZ/MRS/CRE/P-Mode pin
+                                                            // 1: H/W controlled ZZ/MRS/CRE/P-Mode, same timing as CS
+#define REG_UMI_MMD_ICR_MRSSTATE            0x0001          // MRS state for S/W controlled mode
+
+// REG_UMI_NAND_TCR bits
+#define REG_UMI_NAND_TCR_CS_SWCTRL          0x80000000      // Enable software to control CS
+#define REG_UMI_NAND_TCR_WORD16             0x40000000      // 16-bit nand wordsize if set
+#define REG_UMI_NAND_TCR_TBTA_MASK          0x00070000      // Bus turnaround cycle (n)
+#define REG_UMI_NAND_TCR_TWP_MASK           0x0000f800      // Write pulse width cycle (n+1)
+#define REG_UMI_NAND_TCR_TWR_MASK           0x00000600      // Write recovery cycle (n+1)
+#define REG_UMI_NAND_TCR_TAS_MASK           0x00000180      // Write address setup cycle (n+1)
+#define REG_UMI_NAND_TCR_TOE_MASK           0x00000060      // Output enable delay cycle (n)
+#define REG_UMI_NAND_TCR_TRC_TLC_MASK       0x0000001f      // Read access cycle (n+2)
+
+// REG_UMI_NAND_RCSR bits
+#define REG_UMI_NAND_RCSR_RDY               0x02            // Status: Ready=1, Busy=0
+#define REG_UMI_NAND_RCSR_CS_ASSERTED       0x01            // Keep CS asserted during operation
+
+// REG_UMI_NAND_ECC_CSR bits
+#define REG_UMI_NAND_ECC_CSR_NANDINT        0x80000000      // Interrupt status - read-only
+#define REG_UMI_NAND_ECC_CSR_ECCINT_RAW     0x00800000      // Read: Status of ECC done, Write: clear ECC interrupt
+#define REG_UMI_NAND_ECC_CSR_RBINT_RAW      0x00400000      // Read: Status of R/B, Write: clear R/B interrupt
+#define REG_UMI_NAND_ECC_CSR_ECCINT_ENABLE  0x00008000      // 1 = Enable ECC Interrupt
+#define REG_UMI_NAND_ECC_CSR_RBINT_ENABLE   0x00004000      // 1 = Assert interrupt at rising edge of R/B_
+#define REG_UMI_NAND_ECC_CSR_256BYTE        0x00000080      // Calculate ECC by 0=512 bytes, 1=256 bytes
+#define REG_UMI_NAND_ECC_CSR_ECC_ENABLE     0x00000001      // Enable ECC in hardware
+
+// REG_UMI_BCH_CTRL_STATUS bits
+#define REG_UMI_BCH_CTRL_STATUS_NB_CORR_ERROR 0x00F00000    // Indicate Number of correctable errors detected
+#define REG_UMI_BCH_CTRL_STATUS_UNCORR_ERR    0x00080000    // Indicate Errors detected during read but uncorrectable
+#define REG_UMI_BCH_CTRL_STATUS_CORR_ERR      0x00040000    // Indicate Errors detected during read and are correctable
+#define REG_UMI_BCH_CTRL_STATUS_RD_ECC_VALID  0x00020000    // Flag indicates BCH's ECC status of read process are valid
+#define REG_UMI_BCH_CTRL_STATUS_WR_ECC_VALID  0x00010000    // Flag indicates BCH's ECC status of write process are valid
+#define REG_UMI_BCH_CTRL_STATUS_PAUSE_ECC_DEC 0x00000010    // Pause ECC calculation
+#define REG_UMI_BCH_CTRL_STATUS_INT_EN        0x00000004    // Enable Interrupt
+#define REG_UMI_BCH_CTRL_STATUS_ECC_RD_EN     0x00000002    // Enable ECC during read
+#define REG_UMI_BCH_CTRL_STATUS_ECC_WR_EN     0x00000001    // Enable ECC during write
+#define REG_UMI_BCH_ERR_LOC_MASK              0x00001FFF    // Mask for location
+#define REG_UMI_BCH_ERR_LOC_BYTE              0x00000007    // location within a byte
+#define REG_UMI_BCH_ERR_LOC_WORD              0x00000018    // location within a word
+#define REG_UMI_BCH_ERR_LOC_PAGE              0x00001FE0    // location within a page (512 byte)
+#define REG_UMI_BCH_ERR_LOC_ADDR(index)     ( __REG32( HW_UMI_BASE + 0x64 + (index / 2)*4 ) >> ( (index % 2) * 16 ) )
+#endif
diff --git a/arch/arm/mach-bcmring/include/mach/system.h b/arch/arm/mach-bcmring/include/mach/system.h
new file mode 100644
index 0000000..0698744
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/system.h
@@ -0,0 +1,75 @@
+/*
+ *
+ *  Copyright (C) 1999 ARM Limited
+ *  Copyright (C) 2000 Deep Blue Solutions Ltd
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
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+#ifndef __ASM_ARCH_SYSTEM_H
+#define __ASM_ARCH_SYSTEM_H
+
+#include <mach/csp/chipcHw_inline.h>
+
+#if defined( CONFIG_BCM_IDLE_PROFILER_SUPPORT )
+#include <linux/broadcom/idle_prof.h>
+#include <mach/timer.h>
+#endif
+
+extern int gArchWarmReboot;
+
+static inline void arch_idle(void)
+{
+#if defined( CONFIG_BCM_IDLE_PROFILER_SUPPORT )
+    u32 idle_enter, idle_leave;
+
+    idle_enter = timer_get_tick_count();
+#endif
+       cpu_do_idle();
+#if defined( CONFIG_BCM_IDLE_PROFILER_SUPPORT )
+    idle_leave = timer_get_tick_count();
+    idle_count += (idle_leave - idle_enter);
+#endif
+}
+
+static inline void arch_reset(char mode, char *cmd)
+{
+   printk("arch_reset:%c %x\n", mode, gArchWarmReboot);
+
+   if (mode == 'h')
+   {
+      /* Reboot configured in proc entry */
+      if (gArchWarmReboot)
+      {
+         printk("warm reset\n");
+         /* Issue Warm reset (do not reset ethernet switch, keep alive) */
+         chipcHw_reset(chipcHw_REG_SOFT_RESET_CHIP_WARM);
+      }
+      else
+      {
+         /* Force reset of everything */
+         printk("force reset\n");
+         chipcHw_reset(chipcHw_REG_SOFT_RESET_CHIP_SOFT);
+      }
+   }
+   else
+   {
+      /* Force reset of everything */
+      printk("force reset\n");
+      chipcHw_reset(chipcHw_REG_SOFT_RESET_CHIP_SOFT);
+   }
+}
+
+#endif
+
diff --git a/arch/arm/mach-bcmring/include/mach/timer.h b/arch/arm/mach-bcmring/include/mach/timer.h
new file mode 100644
index 0000000..780d9aa
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/timer.h
@@ -0,0 +1,87 @@
+/*****************************************************************************
+* Copyright 2004 - 2008 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+
+
+
+/*
+*
+*****************************************************************************
+*
+*  timer.h
+*
+*  PURPOSE:
+*
+*
+*
+*  NOTES:
+*
+*****************************************************************************/
+
+
+#if !defined( BCM_LINUX_TIMER_H )
+#define BCM_LINUX_TIMER_H
+
+#if defined( __KERNEL__ )
+
+/* ---- Include Files ---------------------------------------------------- */
+/* ---- Constants and Types ---------------------------------------------- */
+
+typedef unsigned int timer_tick_count_t;
+typedef unsigned int timer_tick_rate_t;
+typedef unsigned int timer_msec_t;
+
+
+/* ---- Variable Externs ------------------------------------------------- */
+/* ---- Function Prototypes ---------------------------------------------- */
+
+
+/****************************************************************************
+*
+*  timer_get_tick_count
+*
+*
+***************************************************************************/
+timer_tick_count_t timer_get_tick_count( void );
+
+
+/****************************************************************************
+*
+*  timer_get_tick_rate
+*
+*
+***************************************************************************/
+timer_tick_rate_t timer_get_tick_rate( void );
+
+
+/****************************************************************************
+*
+*  timer_get_msec
+*
+*
+***************************************************************************/
+timer_msec_t timer_get_msec( void );
+
+
+/****************************************************************************
+*
+*  timer_ticks_to_msec
+*
+*
+***************************************************************************/
+timer_msec_t timer_ticks_to_msec( timer_tick_count_t ticks );
+
+
+#endif   /* __KERNEL__ */
+#endif  /* BCM_LINUX_TIMER_H */
diff --git a/arch/arm/mach-bcmring/include/mach/timex.h b/arch/arm/mach-bcmring/include/mach/timex.h
new file mode 100644
index 0000000..cf006df
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/timex.h
@@ -0,0 +1,25 @@
+/*
+ *
+ *  Integrator architecture timex specifications
+ *
+ *  Copyright (C) 1999 ARM Limited
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
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+/*
+ * Specifies the number of ticks per second
+ */
+#define CLOCK_TICK_RATE                100000 //REG_SMT_TICKS_PER_SEC
diff --git a/arch/arm/mach-bcmring/include/mach/uncompress.h b/arch/arm/mach-bcmring/include/mach/uncompress.h
new file mode 100644
index 0000000..0c008db
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/uncompress.h
@@ -0,0 +1,53 @@
+/*****************************************************************************
+* Copyright 2005 - 2008 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+// The piggy build defines __KERNEL__ but can't actually
+// work with kernel code in general, especially the static inline functions.
+// -Dstatic= is set for the misc.c compile, and this causes unnecessary includes
+// of "static inline" functions (just "inline" are included by mistake).
+// So we have to be careful to not call much kernel code from the piggy build.
+// We want the simplified REG_LOCAL_IRQ_SAVE/RESTORE macros from reg.h for
+// this reason and also because piggy doesn't need protection since it is
+// effectively single threaded boot code.
+// uartHw.h below includes  uartHw_inline.h which includes reg.h which brings
+// in too much kernel code for piggy unless we define STANDALONE.
+#define STANDALONE
+
+/*
+ * Map IO 1 to 1 with physical addresses.
+ * Do not move this below the include of mm_io.h
+ */
+#undef MM_IO_PHYS_TO_VIRT
+#define MM_IO_PHYS_TO_VIRT(x)  (x)
+#include <mach/csp/mm_io.h>
+#include <csp/uartHw.h>
+
+/*
+ * This does not append a newline
+ */
+static inline void putc(int c)
+{
+   /* Send out UARTA */
+   uartHw_TxFifoPut( 0, c );
+}
+
+static inline void flush(void)
+{
+   /* Flush UARTA */
+   uartHw_TxWaitIdle( 0 );
+}
+
+#define arch_decomp_setup()
+#define arch_decomp_wdog()
+
diff --git a/arch/arm/mach-bcmring/include/mach/vmalloc.h b/arch/arm/mach-bcmring/include/mach/vmalloc.h
new file mode 100644
index 0000000..58c2a93
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/vmalloc.h
@@ -0,0 +1,32 @@
+/*
+ *
+ *  Copyright (C) 2000 Russell King.
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
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+/*
+ * Just any arbitrary offset to the start of the vmalloc VM area: the
+ * current 8MB value just means that there will be a 8MB "hole" after the
+ * physical memory until the kernel virtual memory starts.  That means that
+ * any out-of-bounds memory accesses will hopefully be caught.
+ * The vmalloc() routines leaves a hole of 4kB between each vmalloced
+ * area for the same reason. ;)
+ */
+#define VMALLOC_OFFSET   (8*1024*1024)
+#define VMALLOC_START    (((unsigned long)high_memory + VMALLOC_OFFSET) & ~(VMALLOC_OFFSET-1))
+#define VMALLOC_VMADDR(x) ((unsigned long)(x))
+/* We have a range of 0xC0000000 to 0xDFFFFFFF minus the VMALLOC and high_memory area available for virtual memory */
+#define VMALLOC_END       (PAGE_OFFSET + 0x1F000000)
diff --git a/arch/arm/mach-bcmring/irq.c b/arch/arm/mach-bcmring/irq.c
new file mode 100644
index 0000000..8a07287
--- /dev/null
+++ b/arch/arm/mach-bcmring/irq.c
@@ -0,0 +1,154 @@
+/*
+ *
+ *  Copyright (C) 1999 ARM Limited
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
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+#include <linux/init.h>
+#include <linux/stddef.h>
+#include <linux/list.h>
+#include <linux/timer.h>
+#include <linux/version.h>
+
+#include <mach/hardware.h>
+#include <asm/io.h>
+#include <asm/irq.h>
+
+#include <asm/mach/irq.h>
+#include <mach/csp/intcHw_reg.h>
+#include <mach/csp/mm_io.h>
+// #include <mach/reg_gpio.h>  // for brcm_init_gpio prototype
+
+
+static void bcmring_mask_irq0(unsigned int irq)
+{
+       writel(1 << (irq - IRQ_INTC0_START), MM_IO_BASE_INTC0 + INTCHW_INTENCLEAR);
+}
+static void bcmring_unmask_irq0(unsigned int irq)
+{
+       writel(1 << (irq - IRQ_INTC0_START), MM_IO_BASE_INTC0 + INTCHW_INTENABLE);
+}
+static void bcmring_mask_irq1(unsigned int irq)
+{
+       writel(1 << (irq - IRQ_INTC1_START), MM_IO_BASE_INTC1 + INTCHW_INTENCLEAR);
+}
+static void bcmring_unmask_irq1(unsigned int irq)
+{
+       writel(1 << (irq - IRQ_INTC1_START), MM_IO_BASE_INTC1 + INTCHW_INTENABLE);
+}
+static void bcmring_mask_irq2(unsigned int irq)
+{
+       writel(1 << (irq - IRQ_SINTC_START), MM_IO_BASE_SINTC + INTCHW_INTENCLEAR);
+}
+static void bcmring_unmask_irq2(unsigned int irq)
+{
+       writel(1 << (irq - IRQ_SINTC_START), MM_IO_BASE_SINTC + INTCHW_INTENABLE);
+}
+
+static struct irq_chip bcmring_irq0_chip = {
+   .typename = "ARM-INTC0",
+   .ack = bcmring_mask_irq0,
+   .mask = bcmring_mask_irq0,     /* mask a specific interrupt, blocking its delivery. */
+   .unmask = bcmring_unmask_irq0, /* unmaks an interrupt */
+};
+
+static struct irq_chip bcmring_irq1_chip = {
+   .typename = "ARM-INTC1",
+   .ack = bcmring_mask_irq1,
+   .mask = bcmring_mask_irq1,
+   .unmask = bcmring_unmask_irq1,
+};
+
+static struct irq_chip bcmring_irq2_chip = {
+   .typename = "ARM-SINTC",
+   .ack = bcmring_mask_irq2,
+   .mask = bcmring_mask_irq2,
+   .unmask = bcmring_unmask_irq2,
+};
+
+
+static void vic_init(void __iomem *base, struct irq_chip *chip, unsigned int irq_start, unsigned int vic_sources)
+{
+    unsigned int i;
+    for ( i = 0; i < 32; i++ )
+    {
+                 unsigned int irq = irq_start + i;
+        set_irq_chip( irq, chip );
+                 set_irq_chip_data(irq, base);
+
+                 if (vic_sources & (1 << i))
+        {
+            set_irq_handler( irq, handle_level_irq );
+            set_irq_flags( irq, IRQF_VALID | IRQF_PROBE );
+        }
+    }
+    writel(0, base + INTCHW_INTSELECT);
+    writel(0, base + INTCHW_INTENABLE);
+    writel(~0, base + INTCHW_INTENCLEAR);
+    writel(0, base + INTCHW_IRQSTATUS);
+    writel(~0, base + INTCHW_SOFTINTCLEAR);
+
+#if 0
+
+   // FUTURE - we may want to enable the auto vector
+   // functionality some day and this means that we
+   // could write an interrupt number into the address
+   // registers, and get_irqnr_and_base could use
+   // that information.
+
+       /*
+        * Make sure we clear all existing interrupts
+        */
+       writel(0, base + INTCHW_ADDRESS);
+       for (i = 0; i < 36; i++)
+   {
+               unsigned int value = readl(base + INTCHW_ADDRESS);
+               writel(value, base + INTCHW_ADDRESS);
+       }
+
+   // Instead of vector addresses, store the irq number (from 0) in the address
+   // registers, and when an irq happens, read the number from the sole address
+   // register that tells us the source of the interrupt. This avoids complicated
+   // code in the low level assember macro get_irqnr_and base.
+       for (i = 0; i < 32; i++)
+   {
+               void __iomem *reg = base + INTCHW_VECTADDR0 + (i * 4);
+               writel(i, reg);
+       }
+#endif
+}
+
+
+void __init bcmring_init_irq( void )
+{
+    vic_init((void __iomem *)MM_IO_BASE_INTC0, &bcmring_irq0_chip, IRQ_INTC0_START, IRQ_INTC0_VALID_MASK);
+    vic_init((void __iomem *)MM_IO_BASE_INTC1, &bcmring_irq1_chip, IRQ_INTC1_START, IRQ_INTC1_VALID_MASK);
+    vic_init((void __iomem *)MM_IO_BASE_SINTC, &bcmring_irq2_chip, IRQ_SINTC_START, IRQ_SINTC_VALID_MASK);
+
+    // special cases
+    if (INTCHW_INTC1_GPIO0 & IRQ_INTC1_VALID_MASK)
+    {
+        set_irq_handler( IRQ_GPIO0, handle_simple_irq );
+    }
+    if (INTCHW_INTC1_GPIO1 & IRQ_INTC1_VALID_MASK)
+    {
+        set_irq_handler( IRQ_GPIO1, handle_simple_irq );
+    }
+
+#if defined( CONFIG_HAVE_GPIO_LIB )
+   brcm_init_gpio();
+#endif
+}
+
diff --git a/arch/arm/mach-bcmring/mm.c b/arch/arm/mach-bcmring/mm.c
new file mode 100644
index 0000000..c417544
--- /dev/null
+++ b/arch/arm/mach-bcmring/mm.c
@@ -0,0 +1,102 @@
+/*****************************************************************************
+* Copyright 2003 - 2008 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+
+
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/ioport.h>
+#include <linux/platform_device.h>
+#include <linux/serial_8250.h>
+
+#include <asm/io.h>
+#include <asm/pgtable.h>
+#include <asm/page.h>
+
+#include <asm/mach/map.h>
+#include <asm/pgalloc.h>
+
+#include <linux/serial.h>
+#include <linux/serial_core.h>
+
+#include <mach/hardware.h>
+#include <mach/csp/mm_io.h>
+
+#define IO_DESC(va, sz) { .virtual = va, \
+                          .pfn = __phys_to_pfn(HW_IO_VIRT_TO_PHYS(va)), \
+                          .length = sz, \
+                          .type = MT_DEVICE }
+
+#define MEM_DESC(va, sz) { .virtual = va, \
+                          .pfn = __phys_to_pfn(HW_IO_VIRT_TO_PHYS(va)), \
+                          .length = sz, \
+                          .type = MT_MEMORY }
+
+static struct map_desc bcmring_io_desc[] __initdata =
+{
+    IO_DESC( MM_IO_BASE_NAND, SZ_64K  ),  // phys:0x28000000-0x28000FFF  virt:0xE8000000-0xE8000FFF  size:0x00010000
+    IO_DESC( MM_IO_BASE_UMI, SZ_64K  ),   // phys:0x2C000000-0x2C000FFF  virt:0xEC000000-0xEC000FFF  size:0x00010000
+
+    IO_DESC( MM_IO_BASE_BROM, SZ_64K  ),     // phys:0x30000000-0x3000FFFF  virt:0xF3000000-0xF300FFFF  size:0x00010000
+    MEM_DESC( MM_IO_BASE_ARAM, SZ_1M  ),     // phys:0x31000000-0x31FFFFFF  virt:0xF3100000-0xF31FFFFF  size:0x01000000
+    IO_DESC( MM_IO_BASE_DMA0, SZ_1M  ),      // phys:0x32000000-0x32FFFFFF  virt:0xF3200000-0xF32FFFFF  size:0x01000000
+    IO_DESC( MM_IO_BASE_DMA1, SZ_1M  ),      // phys:0x33000000-0x33FFFFFF  virt:0xF3300000-0xF33FFFFF  size:0x01000000
+    IO_DESC( MM_IO_BASE_ESW, SZ_1M  ),       // phys:0x34000000-0x34FFFFFF  virt:0xF3400000-0xF34FFFFF  size:0x01000000
+    IO_DESC( MM_IO_BASE_CLCD, SZ_1M  ),      // phys:0x35000000-0x35FFFFFF  virt:0xF3500000-0xF35FFFFF  size:0x01000000
+    IO_DESC( MM_IO_BASE_APM, SZ_1M  ),       // phys:0x36000000-0x36FFFFFF  virt:0xF3600000-0xF36FFFFF  size:0x01000000
+    IO_DESC( MM_IO_BASE_SPUM, SZ_1M  ),      // phys:0x37000000-0x37FFFFFF  virt:0xF3700000-0xF37FFFFF  size:0x01000000
+    IO_DESC( MM_IO_BASE_VPM_PROG, SZ_1M  ),  // phys:0x38000000-0x38FFFFFF  virt:0xF3800000-0xF38FFFFF  size:0x01000000
+    IO_DESC( MM_IO_BASE_VPM_DATA, SZ_1M  ),  // phys:0x3A000000-0x3AFFFFFF  virt:0xF3A00000-0xF3AFFFFF  size:0x01000000
+
+    IO_DESC( MM_IO_BASE_VRAM, SZ_64K  ),  // phys:0x40000000-0x4000FFFF  virt:0xF4000000-0xF400FFFF  size:0x00010000
+    IO_DESC( MM_IO_BASE_CHIPC,  SZ_16M ), // phys:0x80000000-0x80FFFFFF  virt:0xF8000000-0xF8FFFFFF  size:0x01000000
+    IO_DESC( MM_IO_BASE_VPM_EXTMEM_RSVD,
+          SZ_16M ),                       // phys:0x0F000000-0x0FFFFFFF  virt:0xF0000000-0xF0FFFFFF  size:0x01000000
+};
+
+void __init bcmring_map_io( void )
+{
+
+       iotable_init( bcmring_io_desc, ARRAY_SIZE( bcmring_io_desc ));
+
+#if defined( CONFIG_BCM_EARLY_PRINTK )
+    {
+        /*
+         * Now that the I/O space has been setup, we can install our
+         * "early" console device.
+         */
+
+        extern void bcm_install_early_console( void );
+
+        /*
+         * We need to call flush_tlb_all before printing will actually work.
+         * (I'm not sure exactly why). This is done by paging_init
+         * after map_io is called, but because we're in map_io we need to do
+         * it if we're going to get already buffered stuff to be printed.
+         */
+
+        flush_tlb_all();
+
+        /*
+         * Install a console, so that we can get early printk's to work before
+         * interrupts are enabled.
+         */
+
+        bcm_install_early_console();
+    }
+#endif
+}
+
diff --git a/arch/arm/mach-bcmring/timer.c b/arch/arm/mach-bcmring/timer.c
new file mode 100644
index 0000000..bea7f4b
--- /dev/null
+++ b/arch/arm/mach-bcmring/timer.c
@@ -0,0 +1,66 @@
+/*****************************************************************************
+* Copyright 2003 - 2008 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+
+
+
+#include <linux/version.h>
+#include <linux/types.h>
+#include <linux/module.h>
+#include <csp/tmrHw.h>
+
+#include <mach/timer.h>
+// The core.c file initializes timers 1 and 3 as a linux clocksource.
+// The real time clock should probably be the real linux clocksource.
+// In the meantime, this file should agree with core.c as to the
+// profiling timer. If the clocksource is moved to rtc later, then
+// we can init the profiling timer here instead.
+
+// Timer 1 provides 25MHz resolution syncrhonized to scheduling and APM timing
+// Timer 3 provides bus freqeuncy sychronized to ACLK, but spread spectrum will
+// affect synchronization with scheduling and APM timing.
+
+#define PROF_TIMER 1
+
+timer_tick_rate_t timer_get_tick_rate(void)
+{
+       return tmrHw_getCountRate(PROF_TIMER);
+}
+
+timer_tick_count_t timer_get_tick_count(void)
+{
+   return tmrHw_GetCurrentCount(PROF_TIMER);   // change downcounter to upcounter
+}
+
+timer_msec_t timer_ticks_to_msec(timer_tick_count_t ticks)
+{
+   static int tickRateMsec = 0;
+
+   if ( tickRateMsec == 0 )
+   {
+      tickRateMsec = timer_get_tick_rate() / 1000;
+   }
+
+   return ( ticks / tickRateMsec );
+}
+
+timer_msec_t timer_get_msec(void)
+{
+       return timer_ticks_to_msec(timer_get_tick_count());
+}
+
+EXPORT_SYMBOL(timer_get_tick_count);
+EXPORT_SYMBOL(timer_ticks_to_msec);
+EXPORT_SYMBOL(timer_get_tick_rate);
+EXPORT_SYMBOL(timer_get_msec);
--
1.6.0.6


Leo Hao Chen
Software Engineer
Broadcom Canada Inc.


