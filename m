Return-Path: <linux-kernel-owner+w=401wt.eu-S1754079AbXLFMnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbXLFMnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:43:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754201AbXLFMl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:41:57 -0500
Received: from nic2.axis.se ([193.13.178.10]:35711 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754129AbXLFMlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:41:49 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <9ef4cbe1bafad71ac50beab1b60a8ac98848034b.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Date: Thu, 29 Nov 2007 17:11:23 +0100
Subject: [PATCH 04/47] Add new machine dependent files for Etrax-FS and Artpec-3.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The two chips are somewhat different, and needs different handling.
Adds handing of the dma, dram initialization, hardware settings, io,
memory arbiter and pinmux

Also moves the dma, dram initialization and io from CRIS v32 common files.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v32/kernel/dma.c          |  224 -----------
 arch/cris/arch-v32/kernel/io.c           |  153 -------
 arch/cris/arch-v32/lib/dram_init.S       |  119 ------
 arch/cris/arch-v32/mach-a3/Kconfig       |  110 +++++
 arch/cris/arch-v32/mach-a3/Makefile      |   11 +
 arch/cris/arch-v32/mach-a3/arbiter.c     |  634 ++++++++++++++++++++++++++++++
 arch/cris/arch-v32/mach-a3/cpufreq.c     |  153 +++++++
 arch/cris/arch-v32/mach-a3/dma.c         |  185 +++++++++
 arch/cris/arch-v32/mach-a3/dram_init.S   |  104 +++++
 arch/cris/arch-v32/mach-a3/hw_settings.S |   51 +++
 arch/cris/arch-v32/mach-a3/io.c          |  150 +++++++
 arch/cris/arch-v32/mach-a3/pinmux.c      |  386 ++++++++++++++++++
 arch/cris/arch-v32/mach-a3/vcs_hook.c    |  103 +++++
 arch/cris/arch-v32/mach-a3/vcs_hook.h    |   58 +++
 arch/cris/arch-v32/mach-fs/Kconfig       |  216 ++++++++++
 arch/cris/arch-v32/mach-fs/Makefile      |   11 +
 arch/cris/arch-v32/mach-fs/arbiter.c     |  404 +++++++++++++++++++
 arch/cris/arch-v32/mach-fs/cpufreq.c     |  146 +++++++
 arch/cris/arch-v32/mach-fs/dma.c         |  230 +++++++++++
 arch/cris/arch-v32/mach-fs/dram_init.S   |  116 ++++++
 arch/cris/arch-v32/mach-fs/hw_settings.S |   70 ++++
 arch/cris/arch-v32/mach-fs/io.c          |  191 +++++++++
 arch/cris/arch-v32/mach-fs/pinmux.c      |  309 +++++++++++++++
 arch/cris/arch-v32/mach-fs/vcs_hook.c    |  100 +++++
 arch/cris/arch-v32/mach-fs/vcs_hook.h    |   42 ++
 25 files changed, 3780 insertions(+), 496 deletions(-)
 delete mode 100644 arch/cris/arch-v32/kernel/dma.c
 delete mode 100644 arch/cris/arch-v32/kernel/io.c
 delete mode 100644 arch/cris/arch-v32/lib/dram_init.S
 create mode 100644 arch/cris/arch-v32/mach-a3/Kconfig
 create mode 100644 arch/cris/arch-v32/mach-a3/Makefile
 create mode 100644 arch/cris/arch-v32/mach-a3/arbiter.c
 create mode 100644 arch/cris/arch-v32/mach-a3/cpufreq.c
 create mode 100644 arch/cris/arch-v32/mach-a3/dma.c
 create mode 100644 arch/cris/arch-v32/mach-a3/dram_init.S
 create mode 100644 arch/cris/arch-v32/mach-a3/hw_settings.S
 create mode 100644 arch/cris/arch-v32/mach-a3/io.c
 create mode 100644 arch/cris/arch-v32/mach-a3/pinmux.c
 create mode 100644 arch/cris/arch-v32/mach-a3/vcs_hook.c
 create mode 100644 arch/cris/arch-v32/mach-a3/vcs_hook.h
 create mode 100644 arch/cris/arch-v32/mach-fs/Kconfig
 create mode 100644 arch/cris/arch-v32/mach-fs/Makefile
 create mode 100644 arch/cris/arch-v32/mach-fs/arbiter.c
 create mode 100644 arch/cris/arch-v32/mach-fs/cpufreq.c
 create mode 100644 arch/cris/arch-v32/mach-fs/dma.c
 create mode 100644 arch/cris/arch-v32/mach-fs/dram_init.S
 create mode 100644 arch/cris/arch-v32/mach-fs/hw_settings.S
 create mode 100644 arch/cris/arch-v32/mach-fs/io.c
 create mode 100644 arch/cris/arch-v32/mach-fs/pinmux.c
 create mode 100644 arch/cris/arch-v32/mach-fs/vcs_hook.c
 create mode 100644 arch/cris/arch-v32/mach-fs/vcs_hook.h

diff --git a/arch/cris/arch-v32/kernel/dma.c b/arch/cris/arch-v32/kernel/dma.c
deleted file mode 100644
index 570e191..0000000
--- a/arch/cris/arch-v32/kernel/dma.c
+++ /dev/null
@@ -1,224 +0,0 @@
-/* Wrapper for DMA channel allocator that starts clocks etc */
-
-#include <linux/kernel.h>
-#include <linux/spinlock.h>
-#include <asm/dma.h>
-#include <asm/arch/hwregs/reg_map.h>
-#include <asm/arch/hwregs/reg_rdwr.h>
-#include <asm/arch/hwregs/marb_defs.h>
-#include <asm/arch/hwregs/config_defs.h>
-#include <asm/arch/hwregs/strmux_defs.h>
-#include <linux/errno.h>
-#include <asm/system.h>
-#include <asm/arch/arbiter.h>
-
-static char used_dma_channels[MAX_DMA_CHANNELS];
-static const char * used_dma_channels_users[MAX_DMA_CHANNELS];
-
-static DEFINE_SPINLOCK(dma_lock);
-
-int crisv32_request_dma(unsigned int dmanr, const char * device_id,
-                        unsigned options, unsigned int bandwidth,
-			enum dma_owner owner)
-{
-	unsigned long flags;
-	reg_config_rw_clk_ctrl clk_ctrl;
-	reg_strmux_rw_cfg strmux_cfg;
-
-        if (crisv32_arbiter_allocate_bandwidth(dmanr,
-					       options & DMA_INT_MEM ? INT_REGION : EXT_REGION,
-                                              bandwidth))
-          return -ENOMEM;
-
-	spin_lock_irqsave(&dma_lock, flags);
-
-	if (used_dma_channels[dmanr]) {
-		spin_unlock_irqrestore(&dma_lock, flags);
-		if (options & DMA_VERBOSE_ON_ERROR) {
-			printk("Failed to request DMA %i for %s, already allocated by %s\n", dmanr, device_id, used_dma_channels_users[dmanr]);
-		}
-		if (options & DMA_PANIC_ON_ERROR)
-			panic("request_dma error!");
-		return -EBUSY;
-	}
-	clk_ctrl = REG_RD(config, regi_config, rw_clk_ctrl);
-	strmux_cfg = REG_RD(strmux, regi_strmux, rw_cfg);
-
-	switch(dmanr)
-	{
-	case 0:
-	case 1:
-		clk_ctrl.dma01_eth0 = 1;
-		break;
-	case 2:
-	case 3:
-		clk_ctrl.dma23 = 1;
-		break;
-	case 4:
-	case 5:
-		clk_ctrl.dma45 = 1;
-		break;
-	case 6:
-	case 7:
-		clk_ctrl.dma67 = 1;
-		break;
-	case 8:
-	case 9:
-		clk_ctrl.dma89_strcop = 1;
-		break;
-#if MAX_DMA_CHANNELS-1 != 9
-#error Check dma.c
-#endif
-	default:
-		spin_unlock_irqrestore(&dma_lock, flags);
-		if (options & DMA_VERBOSE_ON_ERROR) {
-			printk("Failed to request DMA %i for %s, only 0-%i valid)\n", dmanr, device_id, MAX_DMA_CHANNELS-1);
-		}
-
-		if (options & DMA_PANIC_ON_ERROR)
-			panic("request_dma error!");
-		return -EINVAL;
-	}
-
-	switch(owner)
-	{
-	case dma_eth0:
-		if (dmanr == 0)
-			strmux_cfg.dma0 = regk_strmux_eth0;
-		else if (dmanr == 1)
-			strmux_cfg.dma1 = regk_strmux_eth0;
-		else
-			panic("Invalid DMA channel for eth0\n");
-		break;
-	case dma_eth1:
-		if (dmanr == 6)
-			strmux_cfg.dma6 = regk_strmux_eth1;
-		else if (dmanr == 7)
-			strmux_cfg.dma7 = regk_strmux_eth1;
-		else
-			panic("Invalid DMA channel for eth1\n");
-		break;
-	case dma_iop0:
-		if (dmanr == 2)
-			strmux_cfg.dma2 = regk_strmux_iop0;
-		else if (dmanr == 3)
-			strmux_cfg.dma3 = regk_strmux_iop0;
-		else
-			panic("Invalid DMA channel for iop0\n");
-		break;
-	case dma_iop1:
-		if (dmanr == 4)
-			strmux_cfg.dma4 = regk_strmux_iop1;
-		else if (dmanr == 5)
-			strmux_cfg.dma5 = regk_strmux_iop1;
-		else
-			panic("Invalid DMA channel for iop1\n");
-		break;
-	case dma_ser0:
-		if (dmanr == 6)
-			strmux_cfg.dma6 = regk_strmux_ser0;
-		else if (dmanr == 7)
-			strmux_cfg.dma7 = regk_strmux_ser0;
-		else
-			panic("Invalid DMA channel for ser0\n");
-		break;
-	case dma_ser1:
-		if (dmanr == 4)
-			strmux_cfg.dma4 = regk_strmux_ser1;
-		else if (dmanr == 5)
-			strmux_cfg.dma5 = regk_strmux_ser1;
-		else
-			panic("Invalid DMA channel for ser1\n");
-		break;
-	case dma_ser2:
-		if (dmanr == 2)
-			strmux_cfg.dma2 = regk_strmux_ser2;
-		else if (dmanr == 3)
-			strmux_cfg.dma3 = regk_strmux_ser2;
-		else
-			panic("Invalid DMA channel for ser2\n");
-		break;
-	case dma_ser3:
-		if (dmanr == 8)
-			strmux_cfg.dma8 = regk_strmux_ser3;
-		else if (dmanr == 9)
-			strmux_cfg.dma9 = regk_strmux_ser3;
-		else
-			panic("Invalid DMA channel for ser3\n");
-		break;
-	case dma_sser0:
-		if (dmanr == 4)
-			strmux_cfg.dma4 = regk_strmux_sser0;
-		else if (dmanr == 5)
-			strmux_cfg.dma5 = regk_strmux_sser0;
-		else
-			panic("Invalid DMA channel for sser0\n");
-		break;
-	case dma_sser1:
-		if (dmanr == 6)
-			strmux_cfg.dma6 = regk_strmux_sser1;
-		else if (dmanr == 7)
-			strmux_cfg.dma7 = regk_strmux_sser1;
-		else
-			panic("Invalid DMA channel for sser1\n");
-		break;
-	case dma_ata:
-		if (dmanr == 2)
-			strmux_cfg.dma2 = regk_strmux_ata;
-		else if (dmanr == 3)
-			strmux_cfg.dma3 = regk_strmux_ata;
-		else
-			panic("Invalid DMA channel for ata\n");
-		break;
-	case dma_strp:
-		if (dmanr == 8)
-			strmux_cfg.dma8 = regk_strmux_strcop;
-		else if (dmanr == 9)
-			strmux_cfg.dma9 = regk_strmux_strcop;
-		else
-			panic("Invalid DMA channel for strp\n");
-		break;
-	case dma_ext0:
-		if (dmanr == 6)
-			strmux_cfg.dma6 = regk_strmux_ext0;
-		else
-			panic("Invalid DMA channel for ext0\n");
-		break;
-	case dma_ext1:
-		if (dmanr == 7)
-			strmux_cfg.dma7 = regk_strmux_ext1;
-		else
-			panic("Invalid DMA channel for ext1\n");
-		break;
-	case dma_ext2:
-		if (dmanr == 2)
-			strmux_cfg.dma2 = regk_strmux_ext2;
-		else if (dmanr == 8)
-			strmux_cfg.dma8 = regk_strmux_ext2;
-		else
-			panic("Invalid DMA channel for ext2\n");
-		break;
-	case dma_ext3:
-		if (dmanr == 3)
-			strmux_cfg.dma3 = regk_strmux_ext3;
-		else if (dmanr == 9)
-			strmux_cfg.dma9 = regk_strmux_ext2;
-		else
-			panic("Invalid DMA channel for ext2\n");
-		break;
-	}
-
-	used_dma_channels[dmanr] = 1;
-	used_dma_channels_users[dmanr] = device_id;
-	REG_WR(config, regi_config, rw_clk_ctrl, clk_ctrl);
-	REG_WR(strmux, regi_strmux, rw_cfg, strmux_cfg);
-	spin_unlock_irqrestore(&dma_lock,flags);
-	return 0;
-}
-
-void crisv32_free_dma(unsigned int dmanr)
-{
-	spin_lock(&dma_lock);
-	used_dma_channels[dmanr] = 0;
-	spin_unlock(&dma_lock);
-}
diff --git a/arch/cris/arch-v32/kernel/io.c b/arch/cris/arch-v32/kernel/io.c
deleted file mode 100644
index a22a9e0..0000000
--- a/arch/cris/arch-v32/kernel/io.c
+++ /dev/null
@@ -1,153 +0,0 @@
-/*
- * Helper functions for I/O pins.
- *
- * Copyright (c) 2004 Axis Communications AB.
- */
-
-#include <linux/types.h>
-#include <linux/errno.h>
-#include <linux/init.h>
-#include <linux/string.h>
-#include <linux/ctype.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <asm/io.h>
-#include <asm/arch/pinmux.h>
-#include <asm/arch/hwregs/gio_defs.h>
-
-struct crisv32_ioport crisv32_ioports[] =
-{
-	{
-		(unsigned long*)REG_ADDR(gio, regi_gio, rw_pa_oe),
-		(unsigned long*)REG_ADDR(gio, regi_gio, rw_pa_dout),
-		(unsigned long*)REG_ADDR(gio, regi_gio, r_pa_din),
-		8
-	},
-	{
-		(unsigned long*)REG_ADDR(gio, regi_gio, rw_pb_oe),
-		(unsigned long*)REG_ADDR(gio, regi_gio, rw_pb_dout),
-		(unsigned long*)REG_ADDR(gio, regi_gio, r_pb_din),
-		18
-	},
-	{
-		(unsigned long*)REG_ADDR(gio, regi_gio, rw_pc_oe),
-		(unsigned long*)REG_ADDR(gio, regi_gio, rw_pc_dout),
-		(unsigned long*)REG_ADDR(gio, regi_gio, r_pc_din),
-		18
-	},
-	{
-		(unsigned long*)REG_ADDR(gio, regi_gio, rw_pd_oe),
-		(unsigned long*)REG_ADDR(gio, regi_gio, rw_pd_dout),
-		(unsigned long*)REG_ADDR(gio, regi_gio, r_pd_din),
-		18
-	},
-	{
-		(unsigned long*)REG_ADDR(gio, regi_gio, rw_pe_oe),
-		(unsigned long*)REG_ADDR(gio, regi_gio, rw_pe_dout),
-		(unsigned long*)REG_ADDR(gio, regi_gio, r_pe_din),
-		18
-	}
-};
-
-#define NBR_OF_PORTS ARRAY_SIZE(crisv32_ioports)
-
-struct crisv32_iopin crisv32_led1_green;
-struct crisv32_iopin crisv32_led1_red;
-struct crisv32_iopin crisv32_led2_green;
-struct crisv32_iopin crisv32_led2_red;
-struct crisv32_iopin crisv32_led3_green;
-struct crisv32_iopin crisv32_led3_red;
-
-/* Dummy port used when green LED and red LED is on the same bit */
-static unsigned long io_dummy;
-static struct crisv32_ioport dummy_port =
-{
-	&io_dummy,
-	&io_dummy,
-	&io_dummy,
-	18
-};
-static struct crisv32_iopin dummy_led =
-{
-	&dummy_port,
-	0
-};
-
-static int __init crisv32_io_init(void)
-{
-	int ret = 0;
-	/* Initialize LEDs */
-	ret += crisv32_io_get_name(&crisv32_led1_green, CONFIG_ETRAX_LED1G);
-	ret += crisv32_io_get_name(&crisv32_led1_red, CONFIG_ETRAX_LED1R);
-	ret += crisv32_io_get_name(&crisv32_led2_green, CONFIG_ETRAX_LED2G);
-	ret += crisv32_io_get_name(&crisv32_led2_red, CONFIG_ETRAX_LED2R);
-	ret += crisv32_io_get_name(&crisv32_led3_green, CONFIG_ETRAX_LED3G);
-	ret += crisv32_io_get_name(&crisv32_led3_red, CONFIG_ETRAX_LED3R);
-	crisv32_io_set_dir(&crisv32_led1_green, crisv32_io_dir_out);
-	crisv32_io_set_dir(&crisv32_led1_red, crisv32_io_dir_out);
-	crisv32_io_set_dir(&crisv32_led2_green, crisv32_io_dir_out);
-	crisv32_io_set_dir(&crisv32_led2_red, crisv32_io_dir_out);
-	crisv32_io_set_dir(&crisv32_led3_green, crisv32_io_dir_out);
-	crisv32_io_set_dir(&crisv32_led3_red, crisv32_io_dir_out);
-
-	if (!strcmp(CONFIG_ETRAX_LED1G, CONFIG_ETRAX_LED1R))
-		crisv32_led1_red = dummy_led;
-	if (!strcmp(CONFIG_ETRAX_LED2G, CONFIG_ETRAX_LED2R))
-		crisv32_led2_red = dummy_led;
-
-	return ret;
-}
-
-__initcall(crisv32_io_init);
-
-int crisv32_io_get(struct crisv32_iopin* iopin,
-                   unsigned int port, unsigned int pin)
-{
-	if (port > NBR_OF_PORTS)
-		return -EINVAL;
-	if (port > crisv32_ioports[port].pin_count)
-		return -EINVAL;
-
-	iopin->bit = 1 << pin;
-	iopin->port = &crisv32_ioports[port];
-
-	if (crisv32_pinmux_alloc(port, pin, pin, pinmux_gpio))
-		return -EIO;
-
-	return 0;
-}
-
-int crisv32_io_get_name(struct crisv32_iopin* iopin,
-                         char* name)
-{
-	int port;
-	int pin;
-
-	if (toupper(*name) == 'P')
-		name++;
-
-	if (toupper(*name) < 'A' || toupper(*name) > 'E')
-		return -EINVAL;
-
-	port = toupper(*name) - 'A';
-	name++;
-	pin = simple_strtoul(name, NULL, 10);
-
-	if (pin < 0 || pin > crisv32_ioports[port].pin_count)
-		return -EINVAL;
-
-	iopin->bit = 1 << pin;
-	iopin->port = &crisv32_ioports[port];
-
-	if (crisv32_pinmux_alloc(port, pin, pin, pinmux_gpio))
-		return -EIO;
-
-	return 0;
-}
-
-#ifdef CONFIG_PCI
-/* PCI I/O access stuff */
-struct cris_io_operations* cris_iops = NULL;
-EXPORT_SYMBOL(cris_iops);
-#endif
-
diff --git a/arch/cris/arch-v32/lib/dram_init.S b/arch/cris/arch-v32/lib/dram_init.S
deleted file mode 100644
index 218fbe2..0000000
--- a/arch/cris/arch-v32/lib/dram_init.S
+++ /dev/null
@@ -1,119 +0,0 @@
-/* $Id: dram_init.S,v 1.4 2005/04/24 18:48:32 starvik Exp $
- *
- * DRAM/SDRAM initialization - alter with care
- * This file is intended to be included from other assembler files
- *
- * Note: This file may not modify r8 or r9 because they are used to
- * carry information from the decompresser to the kernel
- *
- * Copyright (C) 2000-2003 Axis Communications AB
- *
- * Authors:  Mikael Starvik (starvik@axis.com)
- */
-
-/* Just to be certain the config file is included, we include it here
- * explicitly instead of depending on it being included in the file that
- * uses this code.
- */
-
-#include <asm/arch/hwregs/asm/reg_map_asm.h>
-#include <asm/arch/hwregs/asm/bif_core_defs_asm.h>
-
-	;; WARNING! The registers r8 and r9 are used as parameters carrying
-	;; information from the decompressor (if the kernel was compressed).
-	;; They should not be used in the code below.
-
-	; Refer to BIF MDS for a description of SDRAM initialization
-
-	; Bank configuration
-	move.d   REG_ADDR(bif_core, regi_bif_core, rw_sdram_cfg_grp0), $r0
-	move.d   CONFIG_ETRAX_SDRAM_GRP0_CONFIG, $r1
-	move.d   $r1, [$r0]
-	move.d   REG_ADDR(bif_core, regi_bif_core, rw_sdram_cfg_grp1), $r0
-	move.d   CONFIG_ETRAX_SDRAM_GRP1_CONFIG, $r1
-	move.d   $r1, [$r0]
-
-	; Calculate value of mrs_data
-	; CAS latency = 2 && bus_width = 32 => 0x40
-	; CAS latency = 3 && bus_width = 32 => 0x60
-	; CAS latency = 2 && bus_width = 16 => 0x20
-	; CAS latency = 3 && bus_width = 16 => 0x30
-
-	; Check if value is already supplied in kernel config
-	move.d   CONFIG_ETRAX_SDRAM_COMMAND, $r2
-	bne	 _set_timing
-	nop
-
-	move.d   0x40, $r4       ; Assume 32 bits and CAS latency = 2
-	move.d   CONFIG_ETRAX_SDRAM_TIMING, $r1
- 	and.d    0x07, $r1       ; Get CAS latency
-	cmpq	 2, $r1		 ; CL = 2 ?
-	beq	 _bw_check
-	nop
-	move.d   0x60, $r4
-
-_bw_check:
-	; Assume that group 0 width is equal to group 1. This assumption
-	; is wrong for a group 1 only hardware (such as the grand old
-	; StorPoint+).
-	move.d   CONFIG_ETRAX_SDRAM_GRP0_CONFIG, $r1
-	and.d    0x200, $r1	; DRAM width is bit 9
-	beq      _set_timing
-	lslq	 2, $r4		;  mrs_data starts at bit 2
-	lsrq     1, $r4		;  16 bits. Shift down value.
-
-	; Set timing parameters (refresh off to avoid Guinness TR 83)
-_set_timing:
-	move.d   CONFIG_ETRAX_SDRAM_TIMING, $r1
-	and.d    ~(3 << reg_bif_core_rw_sdram_timing___ref___lsb), $r1
-	move.d   REG_ADDR(bif_core, regi_bif_core, rw_sdram_timing), $r0
-	move.d   $r1, [$r0]
-
-	; Issue NOP command
-	move.d REG_ADDR(bif_core, regi_bif_core, rw_sdram_cmd), $r5
-	moveq regk_bif_core_nop, $r1
-	move.d $r1, [$r5]
-
-	; Wait 200us
-	move.d   10000, $r2
-1:	bne      1b
-	subq     1, $r2
-
-	; Issue initialization command sequence
-	move.d   _sdram_commands_start, $r2
-	and.d    0x000fffff, $r2 ; Make sure commands are read from flash
-	move.d   _sdram_commands_end,  $r3
-	and.d    0x000fffff, $r3
-1:	clear.d  $r6
-	move.b   [$r2+], $r6 	; Load command
-	or.d     $r4, $r6	; Add calculated mrs
-	move.d   $r6, [$r5]	; Write rw_sdram_cmd
-	; Wait 80 ns between each command
-	move.d	 4000, $r7
-2:	bne	 2b
-	subq	 1, $r7
-	cmp.d    $r2, $r3	; Last command?
-	bne      1b
-	nop
-
-	; Start refresh
-	move.d   CONFIG_ETRAX_SDRAM_TIMING, $r1
-	move.d   REG_ADDR(bif_core, regi_bif_core, rw_sdram_timing), $r0
-	move.d   $r1, [$r0]
-
-	; Initialization finished
-	ba       _sdram_commands_end
-	nop
-
-_sdram_commands_start:
-	.byte   regk_bif_core_pre ; Precharge
-	.byte   regk_bif_core_ref ; refresh
-	.byte   regk_bif_core_ref ; refresh
-	.byte   regk_bif_core_ref ; refresh
-	.byte   regk_bif_core_ref ; refresh
-	.byte   regk_bif_core_ref ; refresh
-	.byte   regk_bif_core_ref ; refresh
-	.byte   regk_bif_core_ref ; refresh
-	.byte   regk_bif_core_ref ; refresh
-	.byte   regk_bif_core_mrs ; mrs
-_sdram_commands_end:
diff --git a/arch/cris/arch-v32/mach-a3/Kconfig b/arch/cris/arch-v32/mach-a3/Kconfig
new file mode 100644
index 0000000..a4df06d
--- /dev/null
+++ b/arch/cris/arch-v32/mach-a3/Kconfig
@@ -0,0 +1,110 @@
+if CRIS_MACH_ARTPEC3
+
+menu "Artpec-3 options"
+       depends on CRIS_MACH_ARTPEC3
+
+config ETRAX_DRAM_VIRTUAL_BASE
+	hex
+	default "c0000000"
+
+config ETRAX_L2CACHE
+       bool
+       default y
+
+config ETRAX_SERIAL_PORTS
+       int
+       default 5
+
+config ETRAX_DDR
+       bool
+       default y
+
+config ETRAX_DDR2_MRS
+	hex "DDR2 MRS"
+	default "0"
+
+config ETRAX_DDR2_TIMING
+	hex "DDR2 SDRAM timing"
+	default "0"
+	help
+	  SDRAM timing parameters.
+
+config ETRAX_DDR2_CONFIG
+	hex "DDR2 config"
+	default "0"
+
+config ETRAX_PIO_CE0_CFG
+       hex "PIO CE0 configuration"
+       default "0"
+
+config ETRAX_PIO_CE1_CFG
+       hex "PIO CE1 configuration"
+       default "0"
+
+config ETRAX_PIO_CE2_CFG
+       hex "PIO CE2 configuration"
+       default "0"
+
+config ETRAX_DEF_GIO_PA_OE
+	hex "GIO_PA_OE"
+	default "00000000"
+	help
+	  Configures the direction of general port A bits.  1 is out, 0 is in.
+	  This is often totally different depending on the product used.
+	  There are some guidelines though - if you know that only LED's are
+	  connected to port PA, then they are usually connected to bits 2-4
+	  and you can therefore use 1c.  On other boards which don't have the
+	  LED's at the general ports, these bits are used for all kinds of
+	  stuff.  If you don't know what to use, it is always safe to put all
+	  as inputs, although floating inputs isn't good.
+
+config ETRAX_DEF_GIO_PA_OUT
+	hex "GIO_PA_OUT"
+	default "00000000"
+	help
+	  Configures the initial data for the general port A bits.  Most
+	  products should use 00 here.
+
+config ETRAX_DEF_GIO_PB_OE
+	hex "GIO_PB_OE"
+	default "000000000"
+	help
+	  Configures the direction of general port B bits.  1 is out, 0 is in.
+	  This is often totally different depending on the product used.
+	  There are some guidelines though - if you know that only LED's are
+	  connected to port PA, then they are usually connected to bits 2-4
+	  and you can therefore use 1c.  On other boards which don't have the
+	  LED's at the general ports, these bits are used for all kinds of
+	  stuff.  If you don't know what to use, it is always safe to put all
+	  as inputs, although floating inputs isn't good.
+
+config ETRAX_DEF_GIO_PB_OUT
+	hex "GIO_PB_OUT"
+	default "000000000"
+	help
+	  Configures the initial data for the general port B bits.  Most
+	  products should use 00000 here.
+
+config ETRAX_DEF_GIO_PC_OE
+	hex "GIO_PC_OE"
+	default "00000"
+	help
+	  Configures the direction of general port C bits.  1 is out, 0 is in.
+	  This is often totally different depending on the product used.
+	  There are some guidelines though - if you know that only LED's are
+	  connected to port PA, then they are usually connected to bits 2-4
+	  and you can therefore use 1c.  On other boards which don't have the
+	  LED's at the general ports, these bits are used for all kinds of
+	  stuff.  If you don't know what to use, it is always safe to put all
+	  as inputs, although floating inputs isn't good.
+
+config ETRAX_DEF_GIO_PC_OUT
+	hex "GIO_PC_OUT"
+	default "00000"
+	help
+	  Configures the initial data for the general port C bits.  Most
+	  products should use 00000 here.
+
+endmenu
+
+endif
diff --git a/arch/cris/arch-v32/mach-a3/Makefile b/arch/cris/arch-v32/mach-a3/Makefile
new file mode 100644
index 0000000..41fa6a6
--- /dev/null
+++ b/arch/cris/arch-v32/mach-a3/Makefile
@@ -0,0 +1,11 @@
+# $Id: Makefile,v 1.3 2007/03/13 11:57:46 starvik Exp $
+#
+# Makefile for the linux kernel.
+#
+
+obj-y   := dma.o pinmux.o io.o arbiter.o
+obj-$(CONFIG_ETRAX_VCS_SIM) += vcs_hook.o
+obj-$(CONFIG_CPU_FREQ)   += cpufreq.o
+
+clean:
+
diff --git a/arch/cris/arch-v32/mach-a3/arbiter.c b/arch/cris/arch-v32/mach-a3/arbiter.c
new file mode 100644
index 0000000..b92fd7e
--- /dev/null
+++ b/arch/cris/arch-v32/mach-a3/arbiter.c
@@ -0,0 +1,634 @@
+/*
+ * Memory arbiter functions. Allocates bandwidth through the
+ * arbiter and sets up arbiter breakpoints.
+ *
+ * The algorithm first assigns slots to the clients that has specified
+ * bandwith (e.g. ethernet) and then the remaining slots are divided
+ * on all the active clients.
+ *
+ * Copyright (c) 2004-2007 Axis Communications AB.
+ *
+ * The artpec-3 has two arbiters. The memory hierarchy looks like this:
+ *
+ *
+ * CPU DMAs
+ *  |   |
+ *  |   |
+ * --------------    ------------------
+ * | foo arbiter|----| Internal memory|
+ * --------------    ------------------
+ *      |
+ * --------------
+ * | L2 cache   |
+ * --------------
+ *             |
+ * h264 etc    |
+ *    |        |
+ *    |        |
+ * --------------
+ * | bar arbiter|
+ * --------------
+ *       |
+ * ---------
+ * | SDRAM |
+ * ---------
+ *
+ */
+
+#include <hwregs/reg_map.h>
+#include <hwregs/reg_rdwr.h>
+#include <hwregs/marb_foo_defs.h>
+#include <hwregs/marb_bar_defs.h>
+#include <arbiter.h>
+#include <hwregs/intr_vect.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/signal.h>
+#include <linux/errno.h>
+#include <linux/spinlock.h>
+#include <asm/io.h>
+#include <asm/irq_regs.h>
+
+#define D(x)
+
+struct crisv32_watch_entry {
+  unsigned long instance;
+  watch_callback *cb;
+  unsigned long start;
+  unsigned long end;
+  int used;
+};
+
+#define NUMBER_OF_BP 4
+#define SDRAM_BANDWIDTH 400000000
+#define INTMEM_BANDWIDTH 400000000
+#define NBR_OF_SLOTS 64
+#define NBR_OF_REGIONS 2
+#define NBR_OF_CLIENTS 15
+#define ARBITERS 2
+#define UNASSIGNED 100
+
+struct arbiter {
+  unsigned long instance;
+  int nbr_regions;
+  int nbr_clients;
+  int requested_slots[NBR_OF_REGIONS][NBR_OF_CLIENTS];
+  int active_clients[NBR_OF_REGIONS][NBR_OF_CLIENTS];
+};
+
+static struct crisv32_watch_entry watches[ARBITERS][NUMBER_OF_BP] =
+{
+  {
+  {regi_marb_foo_bp0},
+  {regi_marb_foo_bp1},
+  {regi_marb_foo_bp2},
+  {regi_marb_foo_bp3}
+  },
+  {
+  {regi_marb_bar_bp0},
+  {regi_marb_bar_bp1},
+  {regi_marb_bar_bp2},
+  {regi_marb_bar_bp3}
+  }
+};
+
+struct arbiter arbiters[ARBITERS] =
+{
+  { /* L2 cache arbiter */
+    .instance = regi_marb_foo,
+    .nbr_regions = 2,
+    .nbr_clients = 15
+  },
+  { /* DDR2 arbiter */
+    .instance = regi_marb_bar,
+    .nbr_regions = 1,
+    .nbr_clients = 9
+  }
+};
+
+static int max_bandwidth[NBR_OF_REGIONS] = {SDRAM_BANDWIDTH, INTMEM_BANDWIDTH};
+
+DEFINE_SPINLOCK(arbiter_lock);
+
+static irqreturn_t
+crisv32_foo_arbiter_irq(int irq, void *dev_id);
+static irqreturn_t
+crisv32_bar_arbiter_irq(int irq, void *dev_id);
+
+/*
+ * "I'm the arbiter, I know the score.
+ *  From square one I'll be watching all 64."
+ * (memory arbiter slots, that is)
+ *
+ *  Or in other words:
+ * Program the memory arbiter slots for "region" according to what's
+ * in requested_slots[] and active_clients[], while minimizing
+ * latency. A caller may pass a non-zero positive amount for
+ * "unused_slots", which must then be the unallocated, remaining
+ * number of slots, free to hand out to any client.
+ */
+
+static void crisv32_arbiter_config(int arbiter, int region, int unused_slots)
+{
+	int slot;
+	int client;
+	int interval = 0;
+
+	/*
+	 * This vector corresponds to the hardware arbiter slots (see
+	 * the hardware documentation for semantics). We initialize
+	 * each slot with a suitable sentinel value outside the valid
+	 * range {0 .. NBR_OF_CLIENTS - 1} and replace them with
+	 * client indexes. Then it's fed to the hardware.
+	 */
+	s8 val[NBR_OF_SLOTS];
+
+	for (slot = 0; slot < NBR_OF_SLOTS; slot++)
+	    val[slot] = -1;
+
+	for (client = 0; client < arbiters[arbiter].nbr_clients; client++) {
+	    int pos;
+	    /* Allocate the requested non-zero number of slots, but
+	     * also give clients with zero-requests one slot each
+	     * while stocks last. We do the latter here, in client
+	     * order. This makes sure zero-request clients are the
+	     * first to get to any spare slots, else those slots
+	     * could, when bandwidth is allocated close to the limit,
+	     * all be allocated to low-index non-zero-request clients
+	     * in the default-fill loop below. Another positive but
+	     * secondary effect is a somewhat better spread of the
+	     * zero-bandwidth clients in the vector, avoiding some of
+	     * the latency that could otherwise be caused by the
+	     * partitioning of non-zero-bandwidth clients at low
+	     * indexes and zero-bandwidth clients at high
+	     * indexes. (Note that this spreading can only affect the
+	     * unallocated bandwidth.)  All the above only matters for
+	     * memory-intensive situations, of course.
+	     */
+	    if (!arbiters[arbiter].requested_slots[region][client]) {
+		/*
+		 * Skip inactive clients. Also skip zero-slot
+		 * allocations in this pass when there are no known
+		 * free slots.
+		 */
+		if (!arbiters[arbiter].active_clients[region][client] ||
+				unused_slots <= 0)
+			continue;
+
+		unused_slots--;
+
+		/* Only allocate one slot for this client. */
+		interval = NBR_OF_SLOTS;
+	    } else
+		interval = NBR_OF_SLOTS /
+			arbiters[arbiter].requested_slots[region][client];
+
+	    pos = 0;
+	    while (pos < NBR_OF_SLOTS) {
+		if (val[pos] >= 0)
+		   pos++;
+		else {
+			val[pos] = client;
+			pos += interval;
+		}
+	    }
+	}
+
+	client = 0;
+	for (slot = 0; slot < NBR_OF_SLOTS; slot++) {
+		/*
+		 * Allocate remaining slots in round-robin
+		 * client-number order for active clients. For this
+		 * pass, we ignore requested bandwidth and previous
+		 * allocations.
+		 */
+		if (val[slot] < 0) {
+			int first = client;
+			while (!arbiters[arbiter].active_clients[region][client]) {
+				client = (client + 1) %
+					arbiters[arbiter].nbr_clients;
+				if (client == first)
+				   break;
+			}
+			val[slot] = client;
+			client = (client + 1) % arbiters[arbiter].nbr_clients;
+		}
+		if (arbiter == 0) {
+			if (region == EXT_REGION)
+				REG_WR_INT_VECT(marb_foo, regi_marb_foo,
+					rw_l2_slots, slot, val[slot]);
+			else if (region == INT_REGION)
+				REG_WR_INT_VECT(marb_foo, regi_marb_foo,
+					rw_intm_slots, slot, val[slot]);
+		} else {
+			REG_WR_INT_VECT(marb_bar, regi_marb_bar,
+				rw_ddr2_slots, slot, val[slot]);
+		}
+	}
+}
+
+extern char _stext, _etext;
+
+static void crisv32_arbiter_init(void)
+{
+	static int initialized;
+
+	if (initialized)
+		return;
+
+	initialized = 1;
+
+	/*
+	 * CPU caches are always set to active, but with zero
+	 * bandwidth allocated. It should be ok to allocate zero
+	 * bandwidth for the caches, because DMA for other channels
+	 * will supposedly finish, once their programmed amount is
+	 * done, and then the caches will get access according to the
+	 * "fixed scheme" for unclaimed slots. Though, if for some
+	 * use-case somewhere, there's a maximum CPU latency for
+	 * e.g. some interrupt, we have to start allocating specific
+	 * bandwidth for the CPU caches too.
+	 */
+	arbiters[0].active_clients[EXT_REGION][11] = 1;
+	arbiters[0].active_clients[EXT_REGION][12] = 1;
+	crisv32_arbiter_config(0, EXT_REGION, 0);
+	crisv32_arbiter_config(0, INT_REGION, 0);
+	crisv32_arbiter_config(1, EXT_REGION, 0);
+
+	if (request_irq(MEMARB_FOO_INTR_VECT, crisv32_foo_arbiter_irq,
+			IRQF_DISABLED, "arbiter", NULL))
+		printk(KERN_ERR "Couldn't allocate arbiter IRQ\n");
+
+	if (request_irq(MEMARB_BAR_INTR_VECT, crisv32_bar_arbiter_irq,
+			IRQF_DISABLED, "arbiter", NULL))
+		printk(KERN_ERR "Couldn't allocate arbiter IRQ\n");
+
+#ifndef CONFIG_ETRAX_KGDB
+	/* Global watch for writes to kernel text segment. */
+	crisv32_arbiter_watch(virt_to_phys(&_stext), &_etext - &_stext,
+		MARB_CLIENTS(arbiter_all_clients, arbiter_bar_all_clients),
+			      arbiter_all_write, NULL);
+#endif
+
+	/* Set up max burst sizes by default */
+	REG_WR_INT(marb_bar, regi_marb_bar, rw_h264_rd_burst, 3);
+	REG_WR_INT(marb_bar, regi_marb_bar, rw_h264_wr_burst, 3);
+	REG_WR_INT(marb_bar, regi_marb_bar, rw_ccd_burst, 3);
+	REG_WR_INT(marb_bar, regi_marb_bar, rw_vin_wr_burst, 3);
+	REG_WR_INT(marb_bar, regi_marb_bar, rw_vin_rd_burst, 3);
+	REG_WR_INT(marb_bar, regi_marb_bar, rw_sclr_rd_burst, 3);
+	REG_WR_INT(marb_bar, regi_marb_bar, rw_vout_burst, 3);
+	REG_WR_INT(marb_bar, regi_marb_bar, rw_sclr_fifo_burst, 3);
+	REG_WR_INT(marb_bar, regi_marb_bar, rw_l2cache_burst, 3);
+}
+
+int crisv32_arbiter_allocate_bandwith(int client, int region,
+				      unsigned long bandwidth)
+{
+	int i;
+	int total_assigned = 0;
+	int total_clients = 0;
+	int req;
+	int arbiter = 0;
+
+	crisv32_arbiter_init();
+
+	if (client & 0xffff0000) {
+		arbiter = 1;
+		client >>= 16;
+	}
+
+	for (i = 0; i < arbiters[arbiter].nbr_clients; i++) {
+		total_assigned += arbiters[arbiter].requested_slots[region][i];
+		total_clients += arbiters[arbiter].active_clients[region][i];
+	}
+
+	/* Avoid division by 0 for 0-bandwidth requests. */
+	req = bandwidth == 0
+		? 0 : NBR_OF_SLOTS / (max_bandwidth[region] / bandwidth);
+
+	/*
+	 * We make sure that there are enough slots only for non-zero
+	 * requests. Requesting 0 bandwidth *may* allocate slots,
+	 * though if all bandwidth is allocated, such a client won't
+	 * get any and will have to rely on getting memory access
+	 * according to the fixed scheme that's the default when one
+	 * of the slot-allocated clients doesn't claim their slot.
+	 */
+	if (total_assigned + req > NBR_OF_SLOTS)
+	   return -ENOMEM;
+
+	arbiters[arbiter].active_clients[region][client] = 1;
+	arbiters[arbiter].requested_slots[region][client] = req;
+	crisv32_arbiter_config(arbiter, region, NBR_OF_SLOTS - total_assigned);
+
+	/* Propagate allocation from foo to bar */
+	if (arbiter == 0)
+		crisv32_arbiter_allocate_bandwith(8 << 16,
+			EXT_REGION, bandwidth);
+	return 0;
+}
+
+/*
+ * Main entry for bandwidth deallocation.
+ *
+ * Strictly speaking, for a somewhat constant set of clients where
+ * each client gets a constant bandwidth and is just enabled or
+ * disabled (somewhat dynamically), no action is necessary here to
+ * avoid starvation for non-zero-allocation clients, as the allocated
+ * slots will just be unused. However, handing out those unused slots
+ * to active clients avoids needless latency if the "fixed scheme"
+ * would give unclaimed slots to an eager low-index client.
+ */
+
+void crisv32_arbiter_deallocate_bandwidth(int client, int region)
+{
+	int i;
+	int total_assigned = 0;
+	int arbiter = 0;
+
+	if (client & 0xffff0000)
+		arbiter = 1;
+
+	arbiters[arbiter].requested_slots[region][client] = 0;
+	arbiters[arbiter].active_clients[region][client] = 0;
+
+	for (i = 0; i < arbiters[arbiter].nbr_clients; i++)
+		total_assigned += arbiters[arbiter].requested_slots[region][i];
+
+	crisv32_arbiter_config(arbiter, region, NBR_OF_SLOTS - total_assigned);
+}
+
+int crisv32_arbiter_watch(unsigned long start, unsigned long size,
+			  unsigned long clients, unsigned long accesses,
+			  watch_callback *cb)
+{
+	int i;
+	int arbiter;
+	int used[2];
+	int ret = 0;
+
+	crisv32_arbiter_init();
+
+	if (start > 0x80000000) {
+		printk(KERN_ERR "Arbiter: %lX doesn't look like a "
+			"physical address", start);
+		return -EFAULT;
+	}
+
+	spin_lock(&arbiter_lock);
+
+	if (clients & 0xffff)
+		used[0] = 1;
+	if (clients & 0xffff0000)
+		used[1] = 1;
+
+	for (arbiter = 0; arbiter < ARBITERS; arbiter++) {
+		if (!used[arbiter])
+			continue;
+
+		for (i = 0; i < NUMBER_OF_BP; i++) {
+			if (!watches[arbiter][i].used) {
+				unsigned intr_mask;
+				if (arbiter)
+					intr_mask = REG_RD_INT(marb_bar,
+						regi_marb_bar, rw_intr_mask);
+				else
+					intr_mask = REG_RD_INT(marb_foo,
+						regi_marb_foo, rw_intr_mask);
+
+				watches[arbiter][i].used = 1;
+				watches[arbiter][i].start = start;
+				watches[arbiter][i].end = start + size;
+				watches[arbiter][i].cb = cb;
+
+				ret |= (i + 1) << (arbiter + 8);
+				if (arbiter) {
+					REG_WR_INT(marb_bar_bp,
+						watches[arbiter][i].instance,
+						rw_first_addr,
+						watches[arbiter][i].start);
+					REG_WR_INT(marb_bar_bp,
+						watches[arbiter][i].instance,
+						rw_last_addr,
+						watches[arbiter][i].end);
+					REG_WR_INT(marb_bar_bp,
+						watches[arbiter][i].instance,
+						rw_op, accesses);
+					REG_WR_INT(marb_bar_bp,
+						watches[arbiter][i].instance,
+						rw_clients,
+						clients & 0xffff);
+				} else {
+					REG_WR_INT(marb_foo_bp,
+						watches[arbiter][i].instance,
+						rw_first_addr,
+						watches[arbiter][i].start);
+					REG_WR_INT(marb_foo_bp,
+						watches[arbiter][i].instance,
+						rw_last_addr,
+						watches[arbiter][i].end);
+					REG_WR_INT(marb_foo_bp,
+						watches[arbiter][i].instance,
+						rw_op, accesses);
+					REG_WR_INT(marb_foo_bp,
+						watches[arbiter][i].instance,
+						rw_clients, clients >> 16);
+				}
+
+				if (i == 0)
+					intr_mask |= 1;
+				else if (i == 1)
+					intr_mask |= 2;
+				else if (i == 2)
+					intr_mask |= 4;
+				else if (i == 3)
+					intr_mask |= 8;
+
+				if (arbiter)
+					REG_WR_INT(marb_bar, regi_marb_bar,
+						rw_intr_mask, intr_mask);
+				else
+					REG_WR_INT(marb_foo, regi_marb_foo,
+						rw_intr_mask, intr_mask);
+
+				spin_unlock(&arbiter_lock);
+
+				break;
+			}
+		}
+	}
+	spin_unlock(&arbiter_lock);
+	if (ret)
+		return ret;
+	else
+		return -ENOMEM;
+}
+
+int crisv32_arbiter_unwatch(int id)
+{
+	int arbiter;
+	int intr_mask;
+
+	crisv32_arbiter_init();
+
+	spin_lock(&arbiter_lock);
+
+	for (arbiter = 0; arbiter < ARBITERS; arbiter++) {
+		int id2;
+
+		if (arbiter)
+			intr_mask = REG_RD_INT(marb_bar, regi_marb_bar,
+				rw_intr_mask);
+		else
+			intr_mask = REG_RD_INT(marb_foo, regi_marb_foo,
+				rw_intr_mask);
+
+		id2 = (id & (0xff << (arbiter + 8))) >> (arbiter + 8);
+		if (id2 == 0)
+			continue;
+		id2--;
+		if ((id2 >= NUMBER_OF_BP) || (!watches[arbiter][id2].used)) {
+			spin_unlock(&arbiter_lock);
+			return -EINVAL;
+		}
+
+		memset(&watches[arbiter][id2], 0,
+			sizeof(struct crisv32_watch_entry));
+
+		if (id2 == 0)
+			intr_mask &= ~1;
+		else if (id2 == 1)
+			intr_mask &= ~2;
+		else if (id2 == 2)
+			intr_mask &= ~4;
+		else if (id2 == 3)
+			intr_mask &= ~8;
+
+		if (arbiter)
+			REG_WR_INT(marb_bar, regi_marb_bar, rw_intr_mask,
+				intr_mask);
+		else
+			REG_WR_INT(marb_foo, regi_marb_foo, rw_intr_mask,
+				intr_mask);
+	}
+
+	spin_unlock(&arbiter_lock);
+	return 0;
+}
+
+extern void show_registers(struct pt_regs *regs);
+
+
+static irqreturn_t
+crisv32_foo_arbiter_irq(int irq, void *dev_id)
+{
+	reg_marb_foo_r_masked_intr masked_intr =
+		REG_RD(marb_foo, regi_marb_foo, r_masked_intr);
+	reg_marb_foo_bp_r_brk_clients r_clients;
+	reg_marb_foo_bp_r_brk_addr r_addr;
+	reg_marb_foo_bp_r_brk_op r_op;
+	reg_marb_foo_bp_r_brk_first_client r_first;
+	reg_marb_foo_bp_r_brk_size r_size;
+	reg_marb_foo_bp_rw_ack ack = {0};
+	reg_marb_foo_rw_ack_intr ack_intr = {
+		.bp0 = 1, .bp1 = 1, .bp2 = 1, .bp3 = 1
+	};
+	struct crisv32_watch_entry *watch;
+	unsigned arbiter = (unsigned)dev_id;
+
+	masked_intr = REG_RD(marb_foo, regi_marb_foo, r_masked_intr);
+
+	if (masked_intr.bp0)
+		watch = &watches[arbiter][0];
+	else if (masked_intr.bp1)
+		watch = &watches[arbiter][1];
+	else if (masked_intr.bp2)
+		watch = &watches[arbiter][2];
+	else if (masked_intr.bp3)
+		watch = &watches[arbiter][3];
+	else
+		return IRQ_NONE;
+
+	/* Retrieve all useful information and print it. */
+	r_clients = REG_RD(marb_foo_bp, watch->instance, r_brk_clients);
+	r_addr = REG_RD(marb_foo_bp, watch->instance, r_brk_addr);
+	r_op = REG_RD(marb_foo_bp, watch->instance, r_brk_op);
+	r_first = REG_RD(marb_foo_bp, watch->instance, r_brk_first_client);
+	r_size = REG_RD(marb_foo_bp, watch->instance, r_brk_size);
+
+	printk(KERN_DEBUG "Arbiter IRQ\n");
+	printk(KERN_DEBUG "Clients %X addr %X op %X first %X size %X\n",
+	       REG_TYPE_CONV(int, reg_marb_foo_bp_r_brk_clients, r_clients),
+	       REG_TYPE_CONV(int, reg_marb_foo_bp_r_brk_addr, r_addr),
+	       REG_TYPE_CONV(int, reg_marb_foo_bp_r_brk_op, r_op),
+	       REG_TYPE_CONV(int, reg_marb_foo_bp_r_brk_first_client, r_first),
+	       REG_TYPE_CONV(int, reg_marb_foo_bp_r_brk_size, r_size));
+
+	REG_WR(marb_foo_bp, watch->instance, rw_ack, ack);
+	REG_WR(marb_foo, regi_marb_foo, rw_ack_intr, ack_intr);
+
+	printk(KERN_DEBUG "IRQ occured at %X\n", (unsigned)get_irq_regs());
+
+	if (watch->cb)
+		watch->cb();
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t
+crisv32_bar_arbiter_irq(int irq, void *dev_id)
+{
+	reg_marb_bar_r_masked_intr masked_intr =
+		REG_RD(marb_bar, regi_marb_bar, r_masked_intr);
+	reg_marb_bar_bp_r_brk_clients r_clients;
+	reg_marb_bar_bp_r_brk_addr r_addr;
+	reg_marb_bar_bp_r_brk_op r_op;
+	reg_marb_bar_bp_r_brk_first_client r_first;
+	reg_marb_bar_bp_r_brk_size r_size;
+	reg_marb_bar_bp_rw_ack ack = {0};
+	reg_marb_bar_rw_ack_intr ack_intr = {
+		.bp0 = 1, .bp1 = 1, .bp2 = 1, .bp3 = 1
+	};
+	struct crisv32_watch_entry *watch;
+	unsigned arbiter = (unsigned)dev_id;
+
+	masked_intr = REG_RD(marb_bar, regi_marb_bar, r_masked_intr);
+
+	if (masked_intr.bp0)
+		watch = &watches[arbiter][0];
+	else if (masked_intr.bp1)
+		watch = &watches[arbiter][1];
+	else if (masked_intr.bp2)
+		watch = &watches[arbiter][2];
+	else if (masked_intr.bp3)
+		watch = &watches[arbiter][3];
+	else
+		return IRQ_NONE;
+
+	/* Retrieve all useful information and print it. */
+	r_clients = REG_RD(marb_bar_bp, watch->instance, r_brk_clients);
+	r_addr = REG_RD(marb_bar_bp, watch->instance, r_brk_addr);
+	r_op = REG_RD(marb_bar_bp, watch->instance, r_brk_op);
+	r_first = REG_RD(marb_bar_bp, watch->instance, r_brk_first_client);
+	r_size = REG_RD(marb_bar_bp, watch->instance, r_brk_size);
+
+	printk(KERN_DEBUG "Arbiter IRQ\n");
+	printk(KERN_DEBUG "Clients %X addr %X op %X first %X size %X\n",
+	       REG_TYPE_CONV(int, reg_marb_bar_bp_r_brk_clients, r_clients),
+	       REG_TYPE_CONV(int, reg_marb_bar_bp_r_brk_addr, r_addr),
+	       REG_TYPE_CONV(int, reg_marb_bar_bp_r_brk_op, r_op),
+	       REG_TYPE_CONV(int, reg_marb_bar_bp_r_brk_first_client, r_first),
+	       REG_TYPE_CONV(int, reg_marb_bar_bp_r_brk_size, r_size));
+
+	REG_WR(marb_bar_bp, watch->instance, rw_ack, ack);
+	REG_WR(marb_bar, regi_marb_bar, rw_ack_intr, ack_intr);
+
+	printk(KERN_DEBUG "IRQ occured at %X\n", (unsigned)get_irq_regs()->erp);
+
+	if (watch->cb)
+		watch->cb();
+
+	return IRQ_HANDLED;
+}
+
diff --git a/arch/cris/arch-v32/mach-a3/cpufreq.c b/arch/cris/arch-v32/mach-a3/cpufreq.c
new file mode 100644
index 0000000..8e5a3ca
--- /dev/null
+++ b/arch/cris/arch-v32/mach-a3/cpufreq.c
@@ -0,0 +1,153 @@
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/cpufreq.h>
+#include <hwregs/reg_map.h>
+#include <hwregs/reg_rdwr.h>
+#include <hwregs/clkgen_defs.h>
+#include <hwregs/ddr2_defs.h>
+
+static int
+cris_sdram_freq_notifier(struct notifier_block *nb, unsigned long val,
+	void *data);
+
+static struct notifier_block cris_sdram_freq_notifier_block = {
+	.notifier_call = cris_sdram_freq_notifier
+};
+
+static struct cpufreq_frequency_table cris_freq_table[] = {
+	{0x01,	6000},
+	{0x02,	200000},
+	{0,	CPUFREQ_TABLE_END},
+};
+
+static unsigned int cris_freq_get_cpu_frequency(unsigned int cpu)
+{
+	reg_clkgen_rw_clk_ctrl clk_ctrl;
+	clk_ctrl = REG_RD(clkgen, regi_clkgen, rw_clk_ctrl);
+	return clk_ctrl.pll ? 200000 : 6000;
+}
+
+static void cris_freq_set_cpu_state(unsigned int state)
+{
+	int i = 0;
+	struct cpufreq_freqs freqs;
+	reg_clkgen_rw_clk_ctrl clk_ctrl;
+	clk_ctrl = REG_RD(clkgen, regi_clkgen, rw_clk_ctrl);
+
+#ifdef CONFIG_SMP
+	for_each_present_cpu(i)
+#endif
+	{
+		freqs.old = cris_freq_get_cpu_frequency(i);
+		freqs.new = cris_freq_table[state].frequency;
+		freqs.cpu = i;
+	}
+
+	cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
+
+	local_irq_disable();
+
+	/* Even though we may be SMP they will share the same clock
+	 * so all settings are made on CPU0. */
+	if (cris_freq_table[state].frequency == 200000)
+		clk_ctrl.pll = 1;
+	else
+		clk_ctrl.pll = 0;
+	REG_WR(clkgen, regi_clkgen, rw_clk_ctrl, clk_ctrl);
+
+	local_irq_enable();
+
+	cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
+};
+
+static int cris_freq_verify(struct cpufreq_policy *policy)
+{
+	return cpufreq_frequency_table_verify(policy, &cris_freq_table[0]);
+}
+
+static int cris_freq_target(struct cpufreq_policy *policy,
+			    unsigned int target_freq,
+			    unsigned int relation)
+{
+	unsigned int newstate = 0;
+
+	if (cpufreq_frequency_table_target(policy, cris_freq_table,
+			target_freq, relation, &newstate))
+		return -EINVAL;
+
+	cris_freq_set_cpu_state(newstate);
+
+	return 0;
+}
+
+static int cris_freq_cpu_init(struct cpufreq_policy *policy)
+{
+	int result;
+
+	/* cpuinfo and default policy values */
+	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
+	policy->cpuinfo.transition_latency = 1000000; /* 1ms */
+	policy->cur = cris_freq_get_cpu_frequency(0);
+
+	result = cpufreq_frequency_table_cpuinfo(policy, cris_freq_table);
+	if (result)
+		return (result);
+
+	cpufreq_frequency_table_get_attr(cris_freq_table, policy->cpu);
+
+	return 0;
+}
+
+
+static int cris_freq_cpu_exit(struct cpufreq_policy *policy)
+{
+	cpufreq_frequency_table_put_attr(policy->cpu);
+	return 0;
+}
+
+
+static struct freq_attr *cris_freq_attr[] = {
+	&cpufreq_freq_attr_scaling_available_freqs,
+	NULL,
+};
+
+static struct cpufreq_driver cris_freq_driver = {
+	.get	= cris_freq_get_cpu_frequency,
+	.verify	= cris_freq_verify,
+	.target	= cris_freq_target,
+	.init	= cris_freq_cpu_init,
+	.exit	= cris_freq_cpu_exit,
+	.name	= "cris_freq",
+	.owner	= THIS_MODULE,
+	.attr	= cris_freq_attr,
+};
+
+static int __init cris_freq_init(void)
+{
+	int ret;
+	ret = cpufreq_register_driver(&cris_freq_driver);
+	cpufreq_register_notifier(&cris_sdram_freq_notifier_block,
+		CPUFREQ_TRANSITION_NOTIFIER);
+	return ret;
+}
+
+static int
+cris_sdram_freq_notifier(struct notifier_block *nb, unsigned long val,
+	void *data)
+{
+	int i;
+	struct cpufreq_freqs *freqs = data;
+	if (val == CPUFREQ_PRECHANGE) {
+		reg_ddr2_rw_cfg cfg =
+		  REG_RD(ddr2, regi_ddr2_ctrl, rw_cfg);
+		cfg.ref_interval = (freqs->new == 200000 ? 1560 : 46);
+
+		if (freqs->new == 200000)
+			for (i = 0; i < 50000; i++);
+		REG_WR(bif_core, regi_bif_core, rw_sdram_timing, timing);
+	}
+	return 0;
+}
+
+
+module_init(cris_freq_init);
diff --git a/arch/cris/arch-v32/mach-a3/dma.c b/arch/cris/arch-v32/mach-a3/dma.c
new file mode 100644
index 0000000..0c19fed
--- /dev/null
+++ b/arch/cris/arch-v32/mach-a3/dma.c
@@ -0,0 +1,185 @@
+/* Wrapper for DMA channel allocator that starts clocks etc */
+
+#include <linux/kernel.h>
+#include <linux/spinlock.h>
+#include <asm/arch/mach/dma.h>
+#include <hwregs/reg_map.h>
+#include <hwregs/reg_rdwr.h>
+#include <hwregs/marb_defs.h>
+#include <hwregs/clkgen_defs.h>
+#include <hwregs/strmux_defs.h>
+#include <linux/errno.h>
+#include <asm/system.h>
+#include <arbiter.h>
+
+static char used_dma_channels[MAX_DMA_CHANNELS];
+static const char *used_dma_channels_users[MAX_DMA_CHANNELS];
+
+static DEFINE_SPINLOCK(dma_lock);
+
+int crisv32_request_dma(unsigned int dmanr, const char *device_id,
+	unsigned options, unsigned int bandwidth, enum dma_owner owner)
+{
+	unsigned long flags;
+	reg_clkgen_rw_clk_ctrl clk_ctrl;
+	reg_strmux_rw_cfg strmux_cfg;
+
+	if (crisv32_arbiter_allocate_bandwith(dmanr,
+			options & DMA_INT_MEM ? INT_REGION : EXT_REGION,
+			bandwidth))
+		return -ENOMEM;
+
+	spin_lock_irqsave(&dma_lock, flags);
+
+	if (used_dma_channels[dmanr]) {
+		spin_unlock_irqrestore(&dma_lock, flags);
+		if (options & DMA_VERBOSE_ON_ERROR)
+			printk(KERN_ERR "Failed to request DMA %i for %s, "
+				"already allocated by %s\n",
+				dmanr,
+				device_id,
+				used_dma_channels_users[dmanr]);
+
+		if (options & DMA_PANIC_ON_ERROR)
+			panic("request_dma error!");
+		spin_unlock_irqrestore(&dma_lock, flags);
+		return -EBUSY;
+	}
+	clk_ctrl = REG_RD(clkgen, regi_clkgen, rw_clk_ctrl);
+	strmux_cfg = REG_RD(strmux, regi_strmux, rw_cfg);
+
+	switch (dmanr) {
+	case 0:
+	case 1:
+		clk_ctrl.dma0_1_eth = 1;
+		break;
+	case 2:
+	case 3:
+		clk_ctrl.dma2_3_strcop = 1;
+		break;
+	case 4:
+	case 5:
+		clk_ctrl.dma4_5_iop = 1;
+		break;
+	case 6:
+	case 7:
+		clk_ctrl.sser_ser_dma6_7 = 1;
+		break;
+	case 9:
+	case 11:
+		clk_ctrl.dma9_11 = 1;
+		break;
+#if MAX_DMA_CHANNELS-1 != 11
+#error Check dma.c
+#endif
+	default:
+		spin_unlock_irqrestore(&dma_lock, flags);
+		if (options & DMA_VERBOSE_ON_ERROR)
+			printk(KERN_ERR "Failed to request DMA %i for %s, "
+				"only 0-%i valid)\n",
+				dmanr, device_id, MAX_DMA_CHANNELS-1);
+
+		if (options & DMA_PANIC_ON_ERROR)
+			panic("request_dma error!");
+		return -EINVAL;
+	}
+
+	switch (owner) {
+	case dma_eth:
+		if (dmanr == 0)
+			strmux_cfg.dma0 = regk_strmux_eth;
+		else if (dmanr == 1)
+			strmux_cfg.dma1 = regk_strmux_eth;
+		else
+			panic("Invalid DMA channel for eth\n");
+		break;
+	case dma_ser0:
+		if (dmanr == 0)
+			strmux_cfg.dma0 = regk_strmux_ser0;
+		else if (dmanr == 1)
+			strmux_cfg.dma1 = regk_strmux_ser0;
+		else
+			panic("Invalid DMA channel for ser0\n");
+		break;
+	case dma_ser3:
+		if (dmanr == 2)
+			strmux_cfg.dma2 = regk_strmux_ser3;
+		else if (dmanr == 3)
+			strmux_cfg.dma3 = regk_strmux_ser3;
+		else
+			panic("Invalid DMA channel for ser3\n");
+		break;
+	case dma_strp:
+		if (dmanr == 2)
+			strmux_cfg.dma2 = regk_strmux_strcop;
+		else if (dmanr == 3)
+			strmux_cfg.dma3 = regk_strmux_strcop;
+		else
+			panic("Invalid DMA channel for strp\n");
+		break;
+	case dma_ser1:
+		if (dmanr == 4)
+			strmux_cfg.dma4 = regk_strmux_ser1;
+		else if (dmanr == 5)
+			strmux_cfg.dma5 = regk_strmux_ser1;
+		else
+			panic("Invalid DMA channel for ser1\n");
+		break;
+	case dma_iop:
+		if (dmanr == 4)
+			strmux_cfg.dma4 = regk_strmux_iop;
+		else if (dmanr == 5)
+			strmux_cfg.dma5 = regk_strmux_iop;
+		else
+			panic("Invalid DMA channel for iop\n");
+		break;
+	case dma_ser2:
+		if (dmanr == 6)
+			strmux_cfg.dma6 = regk_strmux_ser2;
+		else if (dmanr == 7)
+			strmux_cfg.dma7 = regk_strmux_ser2;
+		else
+			panic("Invalid DMA channel for ser2\n");
+		break;
+	case dma_sser:
+		if (dmanr == 6)
+			strmux_cfg.dma6 = regk_strmux_sser;
+		else if (dmanr == 7)
+			strmux_cfg.dma7 = regk_strmux_sser;
+		else
+			panic("Invalid DMA channel for sser\n");
+		break;
+	case dma_ser4:
+		if (dmanr == 9)
+			strmux_cfg.dma9 = regk_strmux_ser4;
+		else
+			panic("Invalid DMA channel for ser4\n");
+		break;
+	case dma_jpeg:
+		if (dmanr == 9)
+			strmux_cfg.dma9 = regk_strmux_jpeg;
+		else
+			panic("Invalid DMA channel for JPEG\n");
+		break;
+	case dma_h264:
+		if (dmanr == 11)
+			strmux_cfg.dma11 = regk_strmux_h264;
+		else
+			panic("Invalid DMA channel for H264\n");
+		break;
+	}
+
+	used_dma_channels[dmanr] = 1;
+	used_dma_channels_users[dmanr] = device_id;
+	REG_WR(clkgen, regi_clkgen, rw_clk_ctrl, clk_ctrl);
+	REG_WR(strmux, regi_strmux, rw_cfg, strmux_cfg);
+	spin_unlock_irqrestore(&dma_lock, flags);
+	return 0;
+}
+
+void crisv32_free_dma(unsigned int dmanr)
+{
+	spin_lock(&dma_lock);
+	used_dma_channels[dmanr] = 0;
+	spin_unlock(&dma_lock);
+}
diff --git a/arch/cris/arch-v32/mach-a3/dram_init.S b/arch/cris/arch-v32/mach-a3/dram_init.S
new file mode 100644
index 0000000..94d6b41
--- /dev/null
+++ b/arch/cris/arch-v32/mach-a3/dram_init.S
@@ -0,0 +1,104 @@
+/*
+ * DDR SDRAM initialization - alter with care
+ * This file is intended to be included from other assembler files
+ *
+ * Note: This file may not modify r8 or r9 because they are used to
+ * carry information from the decompresser to the kernel
+ *
+ * Copyright (C) 2005-2007 Axis Communications AB
+ *
+ * Authors:  Mikael Starvik <starvik@axis.com>
+ */
+
+/* Just to be certain the config file is included, we include it here
+ * explicitely instead of depending on it being included in the file that
+ * uses this code.
+ */
+
+#include <hwregs/asm/reg_map_asm.h>
+#include <hwregs/asm/ddr2_defs_asm.h>
+
+	;; WARNING! The registers r8 and r9 are used as parameters carrying
+	;; information from the decompressor (if the kernel was compressed).
+	;; They should not be used in the code below.
+
+	;; Refer to ddr2 MDS for initialization sequence
+
+	; Start clock
+	move.d   REG_ADDR(ddr2, regi_ddr2_ctrl, rw_phy_cfg), $r0
+	move.d   REG_STATE(ddr2, rw_phy_cfg, en, yes), $r1
+	move.d   $r1, [$r0]
+
+	; Reset phy and start calibration
+	move.d   REG_ADDR(ddr2, regi_ddr2_ctrl, rw_phy_ctrl), $r0
+	move.d   REG_STATE(ddr2, rw_phy_ctrl, rst, yes) | \
+		 REG_STATE(ddr2, rw_phy_ctrl, cal_rst, yes), $r1
+	move.d   $r1, [$r0]
+	move.d	 REG_STATE(ddr2, rw_phy_ctrl, cal_start, yes), $r1
+	move.d   $r1, [$r0]
+
+	; 2. Wait 200us
+	move.d   10000, $r2
+1:	bne      1b
+	subq     1, $r2
+
+	; Issue commands
+	move.d   REG_ADDR(ddr2, regi_ddr2_ctrl, rw_ctrl), $r0
+	move.d   sdram_commands_start, $r2
+command_loop:
+	movu.b  [$r2+], $r1
+	movu.w  [$r2+], $r3
+do_cmd:
+	lslq     16, $r1
+	or.d     $r3, $r1
+	move.d   $r1, [$r0]
+	cmp.d    sdram_commands_end, $r2
+	blo      command_loop
+	nop
+
+	; Set timing
+	move.d   REG_ADDR(ddr2, regi_ddr2_ctrl, rw_timing), $r0
+	move.d   CONFIG_ETRAX_DDR2_TIMING, $r1
+	move.d   $r1, [$r0]
+
+	; Set latency
+	move.d   REG_ADDR(ddr2, regi_ddr2_ctrl, rw_latency), $r0
+	move.d   0x13, $r1
+	move.d   $r1, [$r0]
+
+	; Set configuration
+	move.d   REG_ADDR(ddr2, regi_ddr2_ctrl, rw_cfg), $r0
+	move.d   CONFIG_ETRAX_DDR2_CONFIG, $r1
+	move.d   $r1, [$r0]
+
+	ba after_sdram_commands
+	nop
+
+sdram_commands_start:
+	.byte regk_ddr2_deselect
+	.word 0
+	.byte regk_ddr2_pre
+	.word regk_ddr2_pre_all
+	.byte regk_ddr2_emrs2
+	.word 0
+	.byte regk_ddr2_emrs3
+	.word 0
+	.byte regk_ddr2_emrs
+	.word regk_ddr2_dll_en
+	.byte regk_ddr2_mrs
+	.word regk_ddr2_dll_rst
+	.byte regk_ddr2_pre
+	.word regk_ddr2_pre_all
+	.byte regk_ddr2_ref
+	.word 0
+	.byte regk_ddr2_ref
+	.word 0
+	.byte regk_ddr2_mrs
+	.word CONFIG_ETRAX_DDR2_MRS & 0xffff
+	.byte regk_ddr2_emrs
+	.word regk_ddr2_ocd_default | regk_ddr2_dll_en
+	.byte regk_ddr2_emrs
+	.word regk_ddr2_ocd_exit | regk_ddr2_dll_en | (CONFIG_ETRAX_DDR2_MRS >> 16)
+sdram_commands_end:
+	.align 1
+after_sdram_commands:
diff --git a/arch/cris/arch-v32/mach-a3/hw_settings.S b/arch/cris/arch-v32/mach-a3/hw_settings.S
new file mode 100644
index 0000000..258a632
--- /dev/null
+++ b/arch/cris/arch-v32/mach-a3/hw_settings.S
@@ -0,0 +1,51 @@
+/*
+ * This table is used by some tools to extract hardware parameters.
+ * The table should be included in the kernel and the decompressor.
+ * Don't forget to update the tools if you change this table.
+ *
+ * Copyright (C) 2001-2007 Axis Communications AB
+ *
+ * Authors:  Mikael Starvik <starvik@axis.com>
+ */
+
+#include <hwregs/asm/reg_map_asm.h>
+#include <hwregs/asm/ddr2_defs_asm.h>
+#include <hwregs/asm/gio_defs_asm.h>
+
+	.ascii "HW_PARAM_MAGIC" ; Magic number
+	.dword 0xc0004000	; Kernel start address
+
+	; Debug port
+#ifdef CONFIG_ETRAX_DEBUG_PORT0
+	.dword 0
+#elif defined(CONFIG_ETRAX_DEBUG_PORT1)
+	.dword 1
+#elif defined(CONFIG_ETRAX_DEBUG_PORT2)
+	.dword 2
+#elif defined(CONFIG_ETRAX_DEBUG_PORT3)
+	.dword 3
+#else
+	.dword 4 ; No debug
+#endif
+
+	; Register values
+	.dword REG_ADDR(ddr2, regi_ddr2_ctrl, rw_cfg)
+	.dword CONFIG_ETRAX_DDR2_CONFIG
+	.dword REG_ADDR(ddr2, regi_ddr2_ctrl, rw_timing)
+	.dword CONFIG_ETRAX_DDR2_TIMING
+	.dword CONFIG_ETRAX_DDR2_MRS
+
+	.dword REG_ADDR(gio, regi_gio, rw_pa_dout)
+	.dword CONFIG_ETRAX_DEF_GIO_PA_OUT
+	.dword REG_ADDR(gio, regi_gio, rw_pa_oe)
+	.dword CONFIG_ETRAX_DEF_GIO_PA_OE
+	.dword REG_ADDR(gio, regi_gio, rw_pb_dout)
+	.dword CONFIG_ETRAX_DEF_GIO_PB_OUT
+	.dword REG_ADDR(gio, regi_gio, rw_pb_oe)
+	.dword CONFIG_ETRAX_DEF_GIO_PB_OE
+	.dword REG_ADDR(gio, regi_gio, rw_pc_dout)
+	.dword CONFIG_ETRAX_DEF_GIO_PC_OUT
+	.dword REG_ADDR(gio, regi_gio, rw_pc_oe)
+	.dword CONFIG_ETRAX_DEF_GIO_PC_OE
+
+	.dword 0 ; No more register values
diff --git a/arch/cris/arch-v32/mach-a3/io.c b/arch/cris/arch-v32/mach-a3/io.c
new file mode 100644
index 0000000..5e6c1aa
--- /dev/null
+++ b/arch/cris/arch-v32/mach-a3/io.c
@@ -0,0 +1,150 @@
+/*
+ * Helper functions for I/O pins.
+ *
+ * Copyright (c) 2005-2007 Axis Communications AB.
+ */
+
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/string.h>
+#include <linux/ctype.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <asm/io.h>
+#include <asm/arch/mach/pinmux.h>
+#include <hwregs/gio_defs.h>
+
+struct crisv32_ioport crisv32_ioports[] = {
+	{
+		(unsigned long *)REG_ADDR(gio, regi_gio, rw_pa_oe),
+		(unsigned long *)REG_ADDR(gio, regi_gio, rw_pa_dout),
+		(unsigned long *)REG_ADDR(gio, regi_gio, r_pa_din),
+		32
+	},
+	{
+		(unsigned long *)REG_ADDR(gio, regi_gio, rw_pb_oe),
+		(unsigned long *)REG_ADDR(gio, regi_gio, rw_pb_dout),
+		(unsigned long *)REG_ADDR(gio, regi_gio, r_pb_din),
+		32
+	},
+	{
+		(unsigned long *)REG_ADDR(gio, regi_gio, rw_pc_oe),
+		(unsigned long *)REG_ADDR(gio, regi_gio, rw_pc_dout),
+		(unsigned long *)REG_ADDR(gio, regi_gio, r_pc_din),
+		16
+	},
+};
+
+#define NBR_OF_PORTS sizeof(crisv32_ioports)/sizeof(struct crisv32_ioport)
+
+struct crisv32_iopin crisv32_led_net0_green;
+struct crisv32_iopin crisv32_led_net0_red;
+struct crisv32_iopin crisv32_led2_green;
+struct crisv32_iopin crisv32_led2_red;
+struct crisv32_iopin crisv32_led3_green;
+struct crisv32_iopin crisv32_led3_red;
+
+/* Dummy port used when green LED and red LED is on the same bit */
+static unsigned long io_dummy;
+static struct crisv32_ioport dummy_port = {
+	&io_dummy,
+	&io_dummy,
+	&io_dummy,
+	32
+};
+static struct crisv32_iopin dummy_led = {
+	&dummy_port,
+	0
+};
+
+static int __init crisv32_io_init(void)
+{
+	int ret = 0;
+
+	u32 i;
+
+	/* Locks *should* be dynamically initialized. */
+	for (i = 0; i < ARRAY_SIZE(crisv32_ioports); i++)
+		spin_lock_init(&crisv32_ioports[i].lock);
+	spin_lock_init(&dummy_port.lock);
+
+	/* Initialize LEDs */
+#if (defined(CONFIG_ETRAX_NBR_LED_GRP_ONE) || defined(CONFIG_ETRAX_NBR_LED_GRP_TWO))
+	ret += crisv32_io_get_name(&crisv32_led_net0_green,
+		CONFIG_ETRAX_LED_G_NET0);
+	crisv32_io_set_dir(&crisv32_led_net0_green, crisv32_io_dir_out);
+	if (strcmp(CONFIG_ETRAX_LED_G_NET0, CONFIG_ETRAX_LED_R_NET0)) {
+		ret += crisv32_io_get_name(&crisv32_led_net0_red,
+			CONFIG_ETRAX_LED_R_NET0);
+		crisv32_io_set_dir(&crisv32_led_net0_red, crisv32_io_dir_out);
+	} else
+		crisv32_led_net0_red = dummy_led;
+#endif
+
+	ret += crisv32_io_get_name(&crisv32_led2_green, CONFIG_ETRAX_V32_LED2G);
+	ret += crisv32_io_get_name(&crisv32_led2_red, CONFIG_ETRAX_V32_LED2R);
+	ret += crisv32_io_get_name(&crisv32_led3_green, CONFIG_ETRAX_V32_LED3G);
+	ret += crisv32_io_get_name(&crisv32_led3_red, CONFIG_ETRAX_V32_LED3R);
+
+	crisv32_io_set_dir(&crisv32_led2_green, crisv32_io_dir_out);
+	crisv32_io_set_dir(&crisv32_led2_red, crisv32_io_dir_out);
+	crisv32_io_set_dir(&crisv32_led3_green, crisv32_io_dir_out);
+	crisv32_io_set_dir(&crisv32_led3_red, crisv32_io_dir_out);
+
+	return ret;
+}
+
+__initcall(crisv32_io_init);
+
+int crisv32_io_get(struct crisv32_iopin *iopin,
+	unsigned int port, unsigned int pin)
+{
+	if (port > NBR_OF_PORTS)
+		return -EINVAL;
+	if (port > crisv32_ioports[port].pin_count)
+		return -EINVAL;
+
+	iopin->bit = 1 << pin;
+	iopin->port = &crisv32_ioports[port];
+
+	if (crisv32_pinmux_alloc(port, pin, pin, pinmux_gpio))
+		return -EIO;
+
+	return 0;
+}
+
+int crisv32_io_get_name(struct crisv32_iopin *iopin,
+	const char *name)
+{
+	int port;
+	int pin;
+
+	if (toupper(*name) == 'P')
+		name++;
+
+	if (toupper(*name) < 'A' || toupper(*name) > 'E')
+		return -EINVAL;
+
+	port = toupper(*name) - 'A';
+	name++;
+	pin = simple_strtoul(name, NULL, 10);
+
+	if (pin < 0 || pin > crisv32_ioports[port].pin_count)
+		return -EINVAL;
+
+	iopin->bit = 1 << pin;
+	iopin->port = &crisv32_ioports[port];
+
+	if (crisv32_pinmux_alloc(port, pin, pin, pinmux_gpio))
+		return -EIO;
+
+	return 0;
+}
+
+#ifdef CONFIG_PCI
+/* PCI I/O access stuff */
+struct cris_io_operations *cris_iops = NULL;
+EXPORT_SYMBOL(cris_iops);
+#endif
+
diff --git a/arch/cris/arch-v32/mach-a3/pinmux.c b/arch/cris/arch-v32/mach-a3/pinmux.c
new file mode 100644
index 0000000..0a28c9b
--- /dev/null
+++ b/arch/cris/arch-v32/mach-a3/pinmux.c
@@ -0,0 +1,386 @@
+/*
+ * Allocator for I/O pins. All pins are allocated to GPIO at bootup.
+ * Unassigned pins and GPIO pins can be allocated to a fixed interface
+ * or the I/O processor instead.
+ *
+ * Copyright (c) 2005-2007 Axis Communications AB.
+ */
+
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/spinlock.h>
+#include <hwregs/reg_map.h>
+#include <hwregs/reg_rdwr.h>
+#include <pinmux.h>
+#include <hwregs/pinmux_defs.h>
+#include <hwregs/clkgen_defs.h>
+
+#undef DEBUG
+
+#define PINS 80
+#define PORT_PINS 32
+#define PORTS 3
+
+static char pins[PINS];
+static DEFINE_SPINLOCK(pinmux_lock);
+
+static void crisv32_pinmux_set(int port);
+
+int
+crisv32_pinmux_init(void)
+{
+	static int initialized;
+
+	if (!initialized) {
+		initialized = 1;
+		REG_WR_INT(pinmux, regi_pinmux, rw_hwprot, 0);
+		crisv32_pinmux_alloc(PORT_A, 0, 31, pinmux_gpio);
+		crisv32_pinmux_alloc(PORT_B, 0, 31, pinmux_gpio);
+		crisv32_pinmux_alloc(PORT_C, 0, 15, pinmux_gpio);
+	}
+
+	return 0;
+}
+
+int
+crisv32_pinmux_alloc(int port, int first_pin, int last_pin, enum pin_mode mode)
+{
+	int i;
+	unsigned long flags;
+
+	crisv32_pinmux_init();
+
+	if (port >= PORTS)
+		return -EINVAL;
+
+	spin_lock_irqsave(&pinmux_lock, flags);
+
+	for (i = first_pin; i <= last_pin; i++) {
+		if ((pins[port * PORT_PINS + i] != pinmux_none) &&
+		    (pins[port * PORT_PINS + i] != pinmux_gpio) &&
+		    (pins[port * PORT_PINS + i] != mode)) {
+			spin_unlock_irqrestore(&pinmux_lock, flags);
+#ifdef DEBUG
+			panic("Pinmux alloc failed!\n");
+#endif
+			return -EPERM;
+		}
+	}
+
+	for (i = first_pin; i <= last_pin; i++)
+		pins[port * PORT_PINS + i] = mode;
+
+	crisv32_pinmux_set(port);
+
+	spin_unlock_irqrestore(&pinmux_lock, flags);
+
+	return 0;
+}
+
+int
+crisv32_pinmux_alloc_fixed(enum fixed_function function)
+{
+	int ret = -EINVAL;
+	char saved[sizeof pins];
+	unsigned long flags;
+
+	spin_lock_irqsave(&pinmux_lock, flags);
+
+	/* Save internal data for recovery */
+	memcpy(saved, pins, sizeof pins);
+
+	crisv32_pinmux_init(); /* must be done before we read rw_hwprot */
+
+	reg_pinmux_rw_hwprot hwprot = REG_RD(pinmux, regi_pinmux, rw_hwprot);
+	reg_clkgen_rw_clk_ctrl clk_ctrl = REG_RD(clkgen, regi_clkgen,
+		rw_clk_ctrl);
+
+	switch (function) {
+	case pinmux_eth:
+		clk_ctrl.eth = regk_clkgen_yes;
+		clk_ctrl.dma0_1_eth = regk_clkgen_yes;
+		ret = crisv32_pinmux_alloc(PORT_B, 8, 23, pinmux_fixed);
+		ret |= crisv32_pinmux_alloc(PORT_B, 24, 25, pinmux_fixed);
+		hwprot.eth = hwprot.eth_mdio = regk_pinmux_yes;
+		break;
+	case pinmux_geth:
+		ret = crisv32_pinmux_alloc(PORT_B, 0, 7, pinmux_fixed);
+		hwprot.geth = regk_pinmux_yes;
+		break;
+	case pinmux_tg_cmos:
+		clk_ctrl.ccd_tg_100 = clk_ctrl.ccd_tg_200 = regk_clkgen_yes;
+		ret = crisv32_pinmux_alloc(PORT_B, 27, 29, pinmux_fixed);
+		hwprot.tg_clk = regk_pinmux_yes;
+		break;
+	case pinmux_tg_ccd:
+		clk_ctrl.ccd_tg_100 = clk_ctrl.ccd_tg_200 = regk_clkgen_yes;
+		ret = crisv32_pinmux_alloc(PORT_B, 27, 31, pinmux_fixed);
+		ret |= crisv32_pinmux_alloc(PORT_C, 0, 15, pinmux_fixed);
+		hwprot.tg = hwprot.tg_clk = regk_pinmux_yes;
+		break;
+	case pinmux_vout:
+		clk_ctrl.strdma0_2_video = regk_clkgen_yes;
+		ret = crisv32_pinmux_alloc(PORT_A, 8, 18, pinmux_fixed);
+		hwprot.vout = hwprot.vout_sync = regk_pinmux_yes;
+		break;
+	case pinmux_ser1:
+		clk_ctrl.sser_ser_dma6_7 = regk_clkgen_yes;
+		ret = crisv32_pinmux_alloc(PORT_A, 24, 25, pinmux_fixed);
+		hwprot.ser1 = regk_pinmux_yes;
+		break;
+	case pinmux_ser2:
+		clk_ctrl.sser_ser_dma6_7 = regk_clkgen_yes;
+		ret = crisv32_pinmux_alloc(PORT_A, 26, 27, pinmux_fixed);
+		hwprot.ser2 = regk_pinmux_yes;
+		break;
+	case pinmux_ser3:
+		clk_ctrl.sser_ser_dma6_7 = regk_clkgen_yes;
+		ret = crisv32_pinmux_alloc(PORT_A, 28, 29, pinmux_fixed);
+		hwprot.ser3 = regk_pinmux_yes;
+		break;
+	case pinmux_ser4:
+		clk_ctrl.sser_ser_dma6_7 = regk_clkgen_yes;
+		ret = crisv32_pinmux_alloc(PORT_A, 30, 31, pinmux_fixed);
+		hwprot.ser4 = regk_pinmux_yes;
+		break;
+	case pinmux_sser:
+		clk_ctrl.sser_ser_dma6_7 = regk_clkgen_yes;
+		ret = crisv32_pinmux_alloc(PORT_A, 19, 23, pinmux_fixed);
+		hwprot.sser = regk_pinmux_yes;
+		break;
+	case pinmux_pio:
+		hwprot.pio = regk_pinmux_yes;
+		ret = 0;
+		break;
+	case pinmux_pwm0:
+		ret = crisv32_pinmux_alloc(PORT_A, 30, 30, pinmux_fixed);
+		hwprot.pwm0 = regk_pinmux_yes;
+		break;
+	case pinmux_pwm1:
+		ret = crisv32_pinmux_alloc(PORT_A, 31, 31, pinmux_fixed);
+		hwprot.pwm1 = regk_pinmux_yes;
+		break;
+	case pinmux_pwm2:
+		ret = crisv32_pinmux_alloc(PORT_B, 26, 26, pinmux_fixed);
+		hwprot.pwm2 = regk_pinmux_yes;
+		break;
+	case pinmux_i2c0:
+		ret = crisv32_pinmux_alloc(PORT_A, 0, 1, pinmux_fixed);
+		hwprot.i2c0 = regk_pinmux_yes;
+		break;
+	case pinmux_i2c1:
+		ret = crisv32_pinmux_alloc(PORT_A, 2, 3, pinmux_fixed);
+		hwprot.i2c1 = regk_pinmux_yes;
+		break;
+	case pinmux_i2c1_3wire:
+		ret = crisv32_pinmux_alloc(PORT_A, 2, 3, pinmux_fixed);
+		ret |= crisv32_pinmux_alloc(PORT_A, 7, 7, pinmux_fixed);
+		hwprot.i2c1 = hwprot.i2c1_sen = regk_pinmux_yes;
+		break;
+	case pinmux_i2c1_sda1:
+		ret = crisv32_pinmux_alloc(PORT_A, 2, 4, pinmux_fixed);
+		hwprot.i2c1 = hwprot.i2c1_sda1 = regk_pinmux_yes;
+		break;
+	case pinmux_i2c1_sda2:
+		ret = crisv32_pinmux_alloc(PORT_A, 2, 3, pinmux_fixed);
+		ret |= crisv32_pinmux_alloc(PORT_A, 5, 5, pinmux_fixed);
+		hwprot.i2c1 = hwprot.i2c1_sda2 = regk_pinmux_yes;
+		break;
+	case pinmux_i2c1_sda3:
+		ret = crisv32_pinmux_alloc(PORT_A, 2, 3, pinmux_fixed);
+		ret |= crisv32_pinmux_alloc(PORT_A, 6, 6, pinmux_fixed);
+		hwprot.i2c1 = hwprot.i2c1_sda3 = regk_pinmux_yes;
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	if (!ret) {
+		REG_WR(pinmux, regi_pinmux, rw_hwprot, hwprot);
+		REG_WR(clkgen, regi_clkgen, rw_clk_ctrl, clk_ctrl);
+	} else
+		memcpy(pins, saved, sizeof pins);
+
+  spin_unlock_irqrestore(&pinmux_lock, flags);
+
+  return ret;
+}
+
+void
+crisv32_pinmux_set(int port)
+{
+	int i;
+	int gpio_val = 0;
+	int iop_val = 0;
+	int pin = port * PORT_PINS;
+
+	for (i = 0; (i < PORT_PINS) && (pin < PINS); i++, pin++) {
+		if (pins[pin] == pinmux_gpio)
+			gpio_val |= (1 << i);
+		else if (pins[pin] == pinmux_iop)
+			iop_val |= (1 << i);
+	}
+
+	REG_WRITE(int, regi_pinmux + REG_RD_ADDR_pinmux_rw_gio_pa + 4 * port,
+		gpio_val);
+	REG_WRITE(int, regi_pinmux + REG_RD_ADDR_pinmux_rw_iop_pa + 4 * port,
+		iop_val);
+
+#ifdef DEBUG
+       crisv32_pinmux_dump();
+#endif
+}
+
+int
+crisv32_pinmux_dealloc(int port, int first_pin, int last_pin)
+{
+	int i;
+	unsigned long flags;
+
+	crisv32_pinmux_init();
+
+	if (port > PORTS)
+		return -EINVAL;
+
+	spin_lock_irqsave(&pinmux_lock, flags);
+
+	for (i = first_pin; i <= last_pin; i++)
+		pins[port * PORT_PINS + i] = pinmux_none;
+
+	crisv32_pinmux_set(port);
+	spin_unlock_irqrestore(&pinmux_lock, flags);
+
+	return 0;
+}
+
+int
+crisv32_pinmux_dealloc_fixed(enum fixed_function function)
+{
+	int ret = -EINVAL;
+	char saved[sizeof pins];
+	unsigned long flags;
+
+	spin_lock_irqsave(&pinmux_lock, flags);
+
+	/* Save internal data for recovery */
+	memcpy(saved, pins, sizeof pins);
+
+	crisv32_pinmux_init(); /* must be done before we read rw_hwprot */
+
+	reg_pinmux_rw_hwprot hwprot = REG_RD(pinmux, regi_pinmux, rw_hwprot);
+
+	switch (function) {
+	case pinmux_eth:
+		ret = crisv32_pinmux_dealloc(PORT_B, 8, 23);
+		ret |= crisv32_pinmux_dealloc(PORT_B, 24, 25);
+		ret |= crisv32_pinmux_dealloc(PORT_B, 0, 7);
+		hwprot.eth = hwprot.eth_mdio = hwprot.geth = regk_pinmux_no;
+		break;
+	case pinmux_tg_cmos:
+		ret = crisv32_pinmux_dealloc(PORT_B, 27, 29);
+		hwprot.tg_clk = regk_pinmux_no;
+		break;
+	case pinmux_tg_ccd:
+		ret = crisv32_pinmux_dealloc(PORT_B, 27, 31);
+		ret |= crisv32_pinmux_dealloc(PORT_C, 0, 15);
+		hwprot.tg = hwprot.tg_clk = regk_pinmux_no;
+		break;
+	case pinmux_vout:
+		ret = crisv32_pinmux_dealloc(PORT_A, 8, 18);
+		hwprot.vout = hwprot.vout_sync = regk_pinmux_no;
+		break;
+	case pinmux_ser1:
+		ret = crisv32_pinmux_dealloc(PORT_A, 24, 25);
+		hwprot.ser1 = regk_pinmux_no;
+		break;
+	case pinmux_ser2:
+		ret = crisv32_pinmux_dealloc(PORT_A, 26, 27);
+		hwprot.ser2 = regk_pinmux_no;
+		break;
+	case pinmux_ser3:
+		ret = crisv32_pinmux_dealloc(PORT_A, 28, 29);
+		hwprot.ser3 = regk_pinmux_no;
+		break;
+	case pinmux_ser4:
+		ret = crisv32_pinmux_dealloc(PORT_A, 30, 31);
+		hwprot.ser4 = regk_pinmux_no;
+		break;
+	case pinmux_sser:
+		ret = crisv32_pinmux_dealloc(PORT_A, 19, 23);
+		hwprot.sser = regk_pinmux_no;
+		break;
+	case pinmux_pwm0:
+		ret = crisv32_pinmux_dealloc(PORT_A, 30, 30);
+		hwprot.pwm0 = regk_pinmux_no;
+		break;
+	case pinmux_pwm1:
+		ret = crisv32_pinmux_dealloc(PORT_A, 31, 31);
+		hwprot.pwm1 = regk_pinmux_no;
+		break;
+	case pinmux_pwm2:
+		ret = crisv32_pinmux_dealloc(PORT_B, 26, 26);
+		hwprot.pwm2 = regk_pinmux_no;
+		break;
+	case pinmux_i2c0:
+		ret = crisv32_pinmux_dealloc(PORT_A, 0, 1);
+		hwprot.i2c0 = regk_pinmux_no;
+		break;
+	case pinmux_i2c1:
+		ret = crisv32_pinmux_dealloc(PORT_A, 2, 3);
+		hwprot.i2c1 = regk_pinmux_no;
+		break;
+	case pinmux_i2c1_3wire:
+		ret = crisv32_pinmux_dealloc(PORT_A, 2, 3);
+		ret |= crisv32_pinmux_dealloc(PORT_A, 7, 7);
+		hwprot.i2c1 = hwprot.i2c1_sen = regk_pinmux_no;
+		break;
+	case pinmux_i2c1_sda1:
+		ret = crisv32_pinmux_dealloc(PORT_A, 2, 4);
+		hwprot.i2c1_sda1 = regk_pinmux_no;
+		break;
+	case pinmux_i2c1_sda2:
+		ret = crisv32_pinmux_dealloc(PORT_A, 2, 3);
+		ret |= crisv32_pinmux_dealloc(PORT_A, 5, 5);
+		hwprot.i2c1_sda2 = regk_pinmux_no;
+		break;
+	case pinmux_i2c1_sda3:
+		ret = crisv32_pinmux_dealloc(PORT_A, 2, 3);
+		ret |= crisv32_pinmux_dealloc(PORT_A, 6, 6);
+		hwprot.i2c1_sda3 = regk_pinmux_no;
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	if (!ret)
+		REG_WR(pinmux, regi_pinmux, rw_hwprot, hwprot);
+	else
+		memcpy(pins, saved, sizeof pins);
+
+  spin_unlock_irqrestore(&pinmux_lock, flags);
+
+  return ret;
+}
+
+void
+crisv32_pinmux_dump(void)
+{
+	int i, j;
+	int pin = 0;
+
+	crisv32_pinmux_init();
+
+	for (i = 0; i < PORTS; i++) {
+		pin++;
+		printk(KERN_DEBUG "Port %c\n", 'A'+i);
+		for (j = 0; (j < PORT_PINS) && (pin < PINS); j++, pin++)
+			printk(KERN_DEBUG
+				"  Pin %d = %d\n", j, pins[i * PORT_PINS + j]);
+	}
+}
+
+__initcall(crisv32_pinmux_init);
diff --git a/arch/cris/arch-v32/mach-a3/vcs_hook.c b/arch/cris/arch-v32/mach-a3/vcs_hook.c
new file mode 100644
index 0000000..58b1a54
--- /dev/null
+++ b/arch/cris/arch-v32/mach-a3/vcs_hook.c
@@ -0,0 +1,103 @@
+/*
+ * Simulator hook mechanism
+ */
+
+#include "vcs_hook.h"
+#include <asm/io.h>
+#include <stdarg.h>
+
+#define HOOK_TRIG_ADDR      0xb7000000
+#define HOOK_MEM_BASE_ADDR  0xce000000
+
+static volatile unsigned *hook_base;
+
+#define HOOK_DATA(offset) hook_base[offset]
+#define VHOOK_DATA(offset) hook_base[offset]
+#define HOOK_TRIG(funcid) \
+	do { \
+		*((unsigned *) HOOK_TRIG_ADDR) = funcid; \
+	} while (0)
+#define HOOK_DATA_BYTE(offset) ((unsigned char *)hook_base)[offset]
+
+static void hook_init(void)
+{
+	static int first = 1;
+	if (first) {
+		first = 0;
+		hook_base = ioremap(HOOK_MEM_BASE_ADDR, 8192);
+	}
+}
+
+static unsigned hook_trig(unsigned id)
+{
+	unsigned ret;
+
+	/* preempt_disable(); */
+
+	/* Dummy read from mem to make sure data has propagated to memory
+	 * before trigging */
+	ret = *hook_base;
+
+	/* trigger hook */
+	HOOK_TRIG(id);
+
+	/* wait for call to finish */
+	while (VHOOK_DATA(0) > 0) ;
+
+	/* extract return value */
+
+	ret = VHOOK_DATA(1);
+
+	return ret;
+}
+
+int hook_call(unsigned id, unsigned pcnt, ...)
+{
+	va_list ap;
+	int i;
+	unsigned ret;
+
+	hook_init();
+
+	HOOK_DATA(0) = id;
+
+	va_start(ap, pcnt);
+	for (i = 1; i <= pcnt; i++)
+		HOOK_DATA(i) = va_arg(ap, unsigned);
+	va_end(ap);
+
+	ret = hook_trig(id);
+
+	return ret;
+}
+
+int hook_call_str(unsigned id, unsigned size, const char *str)
+{
+	int i;
+	unsigned ret;
+
+	hook_init();
+
+	HOOK_DATA(0) = id;
+	HOOK_DATA(1) = size;
+
+	for (i = 0; i < size; i++)
+		HOOK_DATA_BYTE(8 + i) = str[i];
+	HOOK_DATA_BYTE(8 + i) = 0;
+
+	ret = hook_trig(id);
+
+	return ret;
+}
+
+void print_str(const char *str)
+{
+	int i;
+	/* find null at end of string */
+	for (i = 1; str[i]; i++) ;
+	hook_call(hook_print_str, i, str);
+}
+
+void CPU_WATCHDOG_TIMEOUT(unsigned t)
+{
+}
diff --git a/arch/cris/arch-v32/mach-a3/vcs_hook.h b/arch/cris/arch-v32/mach-a3/vcs_hook.h
new file mode 100644
index 0000000..8b73d0e
--- /dev/null
+++ b/arch/cris/arch-v32/mach-a3/vcs_hook.h
@@ -0,0 +1,58 @@
+/*
+ * Simulator hook call mechanism
+ */
+
+#ifndef __hook_h__
+#define __hook_h__
+
+int hook_call(unsigned id, unsigned pcnt, ...);
+int hook_call_str(unsigned id, unsigned size, const char *str);
+
+enum hook_ids {
+  hook_debug_on = 1,
+  hook_debug_off,
+  hook_stop_sim_ok,
+  hook_stop_sim_fail,
+  hook_alloc_shared,
+  hook_ptr_shared,
+  hook_free_shared,
+  hook_file2shared,
+  hook_cmp_shared,
+  hook_print_params,
+  hook_sim_time,
+  hook_stop_sim,
+  hook_kick_dog,
+  hook_dog_timeout,
+  hook_rand,
+  hook_srand,
+  hook_rand_range,
+  hook_print_str,
+  hook_print_hex,
+  hook_cmp_offset_shared,
+  hook_fill_random_shared,
+  hook_alloc_random_data,
+  hook_calloc_random_data,
+  hook_print_int,
+  hook_print_uint,
+  hook_fputc,
+  hook_init_fd,
+  hook_sbrk,
+  hook_print_context_descr,
+  hook_print_data_descr,
+  hook_print_group_descr,
+  hook_fill_shared,
+  hook_sl_srand,
+  hook_sl_rand_irange,
+  hook_sl_rand_urange,
+  hook_sl_sh_malloc_aligned,
+  hook_sl_sh_calloc_aligned,
+  hook_sl_sh_alloc_random_data,
+  hook_sl_sh_file2mem,
+  hook_sl_vera_mbox_handle,
+  hook_sl_vera_mbox_put,
+  hook_sl_vera_mbox_get,
+  hook_sl_system,
+  hook_sl_sh_hexdump
+};
+
+#endif
diff --git a/arch/cris/arch-v32/mach-fs/Kconfig b/arch/cris/arch-v32/mach-fs/Kconfig
new file mode 100644
index 0000000..f6d7447
--- /dev/null
+++ b/arch/cris/arch-v32/mach-fs/Kconfig
@@ -0,0 +1,216 @@
+if ETRAXFS
+
+menu "ETRAX FS options"
+       depends on ETRAXFS
+
+config ETRAX_DRAM_VIRTUAL_BASE
+	hex
+	depends on ETRAX_ARCH_V32
+	default "c0000000"
+
+config ETRAX_SERIAL_PORTS
+       int
+       default 4
+
+config ETRAX_MEM_GRP1_CONFIG
+	hex "MEM_GRP1_CONFIG"
+	depends on ETRAX_ARCH_V32
+	default "4044a"
+	help
+	  Waitstates for flash. The default value is suitable for the
+	  standard flashes used in axis products (120 ns).
+
+config ETRAX_MEM_GRP2_CONFIG
+	hex "MEM_GRP2_CONFIG"
+	depends on ETRAX_ARCH_V32
+	default "0"
+	help
+	  Waitstates for SRAM. 0 is a good choice for most Axis products.
+
+config ETRAX_MEM_GRP3_CONFIG
+	hex "MEM_GRP3_CONFIG"
+	depends on ETRAX_ARCH_V32
+	default "0"
+	help
+	  Waitstates for CSP0-3. 0 is a good choice for most Axis products.
+	  It may need to be changed if external devices such as extra
+	  register-mapped LEDs are used.
+
+config ETRAX_MEM_GRP4_CONFIG
+	hex "MEM_GRP4_CONFIG"
+	depends on ETRAX_ARCH_V32
+	default "0"
+	help
+	  Waitstates for CSP4-6. 0 is a good choice for most Axis products.
+
+config ETRAX_SDRAM_GRP0_CONFIG
+	hex "SDRAM_GRP0_CONFIG"
+	depends on ETRAX_ARCH_V32
+	default "336"
+	help
+	  SDRAM configuration for group 0. The value depends on the
+	  hardware configuration. The default value is suitable
+	  for 32 MB organized as two 16 bits chips (e.g. Axis
+	  part number 18550) connected as one 32 bit device (i.e. in
+	  the same group).
+
+config ETRAX_SDRAM_GRP1_CONFIG
+	hex "SDRAM_GRP1_CONFIG"
+	depends on ETRAX_ARCH_V32
+	default "0"
+	help
+	  SDRAM configuration for group 1. The defult value is 0
+	  because group 1 is not used in the default configuration,
+	  described in the help for SDRAM_GRP0_CONFIG.
+
+config ETRAX_SDRAM_TIMING
+	hex "SDRAM_TIMING"
+	depends on ETRAX_ARCH_V32
+	default "104a"
+	help
+	  SDRAM timing parameters. The default value is ok for
+	  most hardwares but large SDRAMs may require a faster
+	  refresh (a.k.a 8K refresh). The default value implies
+	  100MHz clock and SDR mode.
+
+config ETRAX_SDRAM_COMMAND
+	hex "SDRAM_COMMAND"
+	depends on ETRAX_ARCH_V32
+	default "0"
+	help
+	  SDRAM command. Should be 0 unless you really know what
+	  you are doing (may be != 0 for unusual address line
+	  mappings such as in a MCM)..
+
+config ETRAX_DEF_GIO_PA_OE
+	hex "GIO_PA_OE"
+	depends on ETRAX_ARCH_V32
+	default "1c"
+	help
+	  Configures the direction of general port A bits.  1 is out, 0 is in.
+	  This is often totally different depending on the product used.
+	  There are some guidelines though - if you know that only LED's are
+	  connected to port PA, then they are usually connected to bits 2-4
+	  and you can therefore use 1c.  On other boards which don't have the
+	  LED's at the general ports, these bits are used for all kinds of
+	  stuff.  If you don't know what to use, it is always safe to put all
+	  as inputs, although floating inputs isn't good.
+
+config ETRAX_DEF_GIO_PA_OUT
+	hex "GIO_PA_OUT"
+	depends on ETRAX_ARCH_V32
+	default "00"
+	help
+	  Configures the initial data for the general port A bits.  Most
+	  products should use 00 here.
+
+config ETRAX_DEF_GIO_PB_OE
+	hex "GIO_PB_OE"
+	depends on ETRAX_ARCH_V32
+	default "00000"
+	help
+	  Configures the direction of general port B bits.  1 is out, 0 is in.
+	  This is often totally different depending on the product used.
+	  There are some guidelines though - if you know that only LED's are
+	  connected to port PA, then they are usually connected to bits 2-4
+	  and you can therefore use 1c.  On other boards which don't have the
+	  LED's at the general ports, these bits are used for all kinds of
+	  stuff.  If you don't know what to use, it is always safe to put all
+	  as inputs, although floating inputs isn't good.
+
+config ETRAX_DEF_GIO_PB_OUT
+	hex "GIO_PB_OUT"
+	depends on ETRAX_ARCH_V32
+	default "00000"
+	help
+	  Configures the initial data for the general port B bits.  Most
+	  products should use 00000 here.
+
+config ETRAX_DEF_GIO_PC_OE
+	hex "GIO_PC_OE"
+	depends on ETRAX_ARCH_V32
+	default "00000"
+	help
+	  Configures the direction of general port C bits.  1 is out, 0 is in.
+	  This is often totally different depending on the product used.
+	  There are some guidelines though - if you know that only LED's are
+	  connected to port PA, then they are usually connected to bits 2-4
+	  and you can therefore use 1c.  On other boards which don't have the
+	  LED's at the general ports, these bits are used for all kinds of
+	  stuff.  If you don't know what to use, it is always safe to put all
+	  as inputs, although floating inputs isn't good.
+
+config ETRAX_DEF_GIO_PC_OUT
+	hex "GIO_PC_OUT"
+	depends on ETRAX_ARCH_V32
+	default "00000"
+	help
+	  Configures the initial data for the general port C bits.  Most
+	  products should use 00000 here.
+
+config ETRAX_DEF_GIO_PD_OE
+	hex "GIO_PD_OE"
+	depends on ETRAX_ARCH_V32
+	default "00000"
+	help
+	  Configures the direction of general port D bits.  1 is out, 0 is in.
+	  This is often totally different depending on the product used.
+	  There are some guidelines though - if you know that only LED's are
+	  connected to port PA, then they are usually connected to bits 2-4
+	  and you can therefore use 1c.  On other boards which don't have the
+	  LED's at the general ports, these bits are used for all kinds of
+	  stuff.  If you don't know what to use, it is always safe to put all
+	  as inputs, although floating inputs isn't good.
+
+config ETRAX_DEF_GIO_PD_OUT
+	hex "GIO_PD_OUT"
+	depends on ETRAX_ARCH_V32
+	default "00000"
+	help
+	  Configures the initial data for the general port D bits.  Most
+	  products should use 00000 here.
+
+config ETRAX_DEF_GIO_PE_OE
+	hex "GIO_PE_OE"
+	depends on ETRAX_ARCH_V32
+	default "00000"
+	help
+	  Configures the direction of general port E bits.  1 is out, 0 is in.
+	  This is often totally different depending on the product used.
+	  There are some guidelines though - if you know that only LED's are
+	  connected to port PA, then they are usually connected to bits 2-4
+	  and you can therefore use 1c.  On other boards which don't have the
+	  LED's at the general ports, these bits are used for all kinds of
+	  stuff.  If you don't know what to use, it is always safe to put all
+	  as inputs, although floating inputs isn't good.
+
+config ETRAX_DEF_GIO_PE_OUT
+	hex "GIO_PE_OUT"
+	depends on ETRAX_ARCH_V32
+	default "00000"
+	help
+	  Configures the initial data for the general port E bits.  Most
+	  products should use 00000 here.
+
+config ETRAX_DEF_GIO_PV_OE
+	hex "GIO_PV_OE"
+	depends on ETRAX_VIRTUAL_GPIO
+	default "0000"
+	help
+	  Configures the direction of virtual general port V bits. 1 is out,
+	  0 is in. This is often totally different depending on the product
+	  used. These bits are used for all kinds of stuff. If you don't know
+	  what to use, it is always safe to put all as inputs, although
+	  floating inputs isn't good.
+
+config ETRAX_DEF_GIO_PV_OUT
+	hex "GIO_PV_OUT"
+	depends on ETRAX_VIRTUAL_GPIO
+	default "0000"
+	help
+	  Configures the initial data for the virtual general port V bits.
+	  Most products should use 0000 here.
+
+endmenu
+
+endif
diff --git a/arch/cris/arch-v32/mach-fs/Makefile b/arch/cris/arch-v32/mach-fs/Makefile
new file mode 100644
index 0000000..4ff407a
--- /dev/null
+++ b/arch/cris/arch-v32/mach-fs/Makefile
@@ -0,0 +1,11 @@
+# $Id: Makefile,v 1.3 2007/03/13 11:57:46 starvik Exp $
+#
+# Makefile for the linux kernel.
+#
+
+obj-y   := dma.o pinmux.o io.o arbiter.o
+bj-$(CONFIG_ETRAX_VCS_SIM) += vcs_hook.o
+obj-$(CONFIG_CPU_FREQ)   += cpufreq.o
+
+clean:
+
diff --git a/arch/cris/arch-v32/mach-fs/arbiter.c b/arch/cris/arch-v32/mach-fs/arbiter.c
new file mode 100644
index 0000000..84d31bd
--- /dev/null
+++ b/arch/cris/arch-v32/mach-fs/arbiter.c
@@ -0,0 +1,404 @@
+/*
+ * Memory arbiter functions. Allocates bandwidth through the
+ * arbiter and sets up arbiter breakpoints.
+ *
+ * The algorithm first assigns slots to the clients that has specified
+ * bandwidth (e.g. ethernet) and then the remaining slots are divided
+ * on all the active clients.
+ *
+ * Copyright (c) 2004-2007 Axis Communications AB.
+ */
+
+#include <hwregs/reg_map.h>
+#include <hwregs/reg_rdwr.h>
+#include <hwregs/marb_defs.h>
+#include <arbiter.h>
+#include <hwregs/intr_vect.h>
+#include <linux/interrupt.h>
+#include <linux/signal.h>
+#include <linux/errno.h>
+#include <linux/spinlock.h>
+#include <asm/io.h>
+#include <asm/irq_regs.h>
+
+struct crisv32_watch_entry {
+	unsigned long instance;
+	watch_callback *cb;
+	unsigned long start;
+	unsigned long end;
+	int used;
+};
+
+#define NUMBER_OF_BP 4
+#define NBR_OF_CLIENTS 14
+#define NBR_OF_SLOTS 64
+#define SDRAM_BANDWIDTH 100000000	/* Some kind of expected value */
+#define INTMEM_BANDWIDTH 400000000
+#define NBR_OF_REGIONS 2
+
+static struct crisv32_watch_entry watches[NUMBER_OF_BP] = {
+	{regi_marb_bp0},
+	{regi_marb_bp1},
+	{regi_marb_bp2},
+	{regi_marb_bp3}
+};
+
+static u8 requested_slots[NBR_OF_REGIONS][NBR_OF_CLIENTS];
+static u8 active_clients[NBR_OF_REGIONS][NBR_OF_CLIENTS];
+static int max_bandwidth[NBR_OF_REGIONS] =
+    { SDRAM_BANDWIDTH, INTMEM_BANDWIDTH };
+
+DEFINE_SPINLOCK(arbiter_lock);
+
+static irqreturn_t crisv32_arbiter_irq(int irq, void *dev_id);
+
+/*
+ * "I'm the arbiter, I know the score.
+ *  From square one I'll be watching all 64."
+ * (memory arbiter slots, that is)
+ *
+ *  Or in other words:
+ * Program the memory arbiter slots for "region" according to what's
+ * in requested_slots[] and active_clients[], while minimizing
+ * latency. A caller may pass a non-zero positive amount for
+ * "unused_slots", which must then be the unallocated, remaining
+ * number of slots, free to hand out to any client.
+ */
+
+static void crisv32_arbiter_config(int region, int unused_slots)
+{
+	int slot;
+	int client;
+	int interval = 0;
+
+	/*
+	 * This vector corresponds to the hardware arbiter slots (see
+	 * the hardware documentation for semantics). We initialize
+	 * each slot with a suitable sentinel value outside the valid
+	 * range {0 .. NBR_OF_CLIENTS - 1} and replace them with
+	 * client indexes. Then it's fed to the hardware.
+	 */
+	s8 val[NBR_OF_SLOTS];
+
+	for (slot = 0; slot < NBR_OF_SLOTS; slot++)
+		val[slot] = -1;
+
+	for (client = 0; client < NBR_OF_CLIENTS; client++) {
+		int pos;
+		/* Allocate the requested non-zero number of slots, but
+		 * also give clients with zero-requests one slot each
+		 * while stocks last. We do the latter here, in client
+		 * order. This makes sure zero-request clients are the
+		 * first to get to any spare slots, else those slots
+		 * could, when bandwidth is allocated close to the limit,
+		 * all be allocated to low-index non-zero-request clients
+		 * in the default-fill loop below. Another positive but
+		 * secondary effect is a somewhat better spread of the
+		 * zero-bandwidth clients in the vector, avoiding some of
+		 * the latency that could otherwise be caused by the
+		 * partitioning of non-zero-bandwidth clients at low
+		 * indexes and zero-bandwidth clients at high
+		 * indexes. (Note that this spreading can only affect the
+		 * unallocated bandwidth.)  All the above only matters for
+		 * memory-intensive situations, of course.
+		 */
+		if (!requested_slots[region][client]) {
+			/*
+			 * Skip inactive clients. Also skip zero-slot
+			 * allocations in this pass when there are no known
+			 * free slots.
+			 */
+			if (!active_clients[region][client]
+			    || unused_slots <= 0)
+				continue;
+
+			unused_slots--;
+
+			/* Only allocate one slot for this client. */
+			interval = NBR_OF_SLOTS;
+		} else
+			interval =
+			    NBR_OF_SLOTS / requested_slots[region][client];
+
+		pos = 0;
+		while (pos < NBR_OF_SLOTS) {
+			if (val[pos] >= 0)
+				pos++;
+			else {
+				val[pos] = client;
+				pos += interval;
+			}
+		}
+	}
+
+	client = 0;
+	for (slot = 0; slot < NBR_OF_SLOTS; slot++) {
+		/*
+		 * Allocate remaining slots in round-robin
+		 * client-number order for active clients. For this
+		 * pass, we ignore requested bandwidth and previous
+		 * allocations.
+		 */
+		if (val[slot] < 0) {
+			int first = client;
+			while (!active_clients[region][client]) {
+				client = (client + 1) % NBR_OF_CLIENTS;
+				if (client == first)
+					break;
+			}
+			val[slot] = client;
+			client = (client + 1) % NBR_OF_CLIENTS;
+		}
+		if (region == EXT_REGION)
+			REG_WR_INT_VECT(marb, regi_marb, rw_ext_slots, slot,
+					val[slot]);
+		else if (region == INT_REGION)
+			REG_WR_INT_VECT(marb, regi_marb, rw_int_slots, slot,
+					val[slot]);
+	}
+}
+
+extern char _stext, _etext;
+
+static void crisv32_arbiter_init(void)
+{
+	static int initialized;
+
+	if (initialized)
+		return;
+
+	initialized = 1;
+
+	/*
+	 * CPU caches are always set to active, but with zero
+	 * bandwidth allocated. It should be ok to allocate zero
+	 * bandwidth for the caches, because DMA for other channels
+	 * will supposedly finish, once their programmed amount is
+	 * done, and then the caches will get access according to the
+	 * "fixed scheme" for unclaimed slots. Though, if for some
+	 * use-case somewhere, there's a maximum CPU latency for
+	 * e.g. some interrupt, we have to start allocating specific
+	 * bandwidth for the CPU caches too.
+	 */
+	active_clients[EXT_REGION][10] = active_clients[EXT_REGION][11] = 1;
+	crisv32_arbiter_config(EXT_REGION, 0);
+	crisv32_arbiter_config(INT_REGION, 0);
+
+	if (request_irq(MEMARB_INTR_VECT, crisv32_arbiter_irq, IRQF_DISABLED,
+			"arbiter", NULL))
+		printk(KERN_ERR "Couldn't allocate arbiter IRQ\n");
+
+#ifndef CONFIG_ETRAX_KGDB
+	/* Global watch for writes to kernel text segment. */
+	crisv32_arbiter_watch(virt_to_phys(&_stext), &_etext - &_stext,
+			      arbiter_all_clients, arbiter_all_write, NULL);
+#endif
+}
+
+/* Main entry for bandwidth allocation. */
+
+int crisv32_arbiter_allocate_bandwidth(int client, int region,
+				       unsigned long bandwidth)
+{
+	int i;
+	int total_assigned = 0;
+	int total_clients = 0;
+	int req;
+
+	crisv32_arbiter_init();
+
+	for (i = 0; i < NBR_OF_CLIENTS; i++) {
+		total_assigned += requested_slots[region][i];
+		total_clients += active_clients[region][i];
+	}
+
+	/* Avoid division by 0 for 0-bandwidth requests. */
+	req = bandwidth == 0
+	    ? 0 : NBR_OF_SLOTS / (max_bandwidth[region] / bandwidth);
+
+	/*
+	 * We make sure that there are enough slots only for non-zero
+	 * requests. Requesting 0 bandwidth *may* allocate slots,
+	 * though if all bandwidth is allocated, such a client won't
+	 * get any and will have to rely on getting memory access
+	 * according to the fixed scheme that's the default when one
+	 * of the slot-allocated clients doesn't claim their slot.
+	 */
+	if (total_assigned + req > NBR_OF_SLOTS)
+		return -ENOMEM;
+
+	active_clients[region][client] = 1;
+	requested_slots[region][client] = req;
+	crisv32_arbiter_config(region, NBR_OF_SLOTS - total_assigned);
+
+	return 0;
+}
+
+/*
+ * Main entry for bandwidth deallocation.
+ *
+ * Strictly speaking, for a somewhat constant set of clients where
+ * each client gets a constant bandwidth and is just enabled or
+ * disabled (somewhat dynamically), no action is necessary here to
+ * avoid starvation for non-zero-allocation clients, as the allocated
+ * slots will just be unused. However, handing out those unused slots
+ * to active clients avoids needless latency if the "fixed scheme"
+ * would give unclaimed slots to an eager low-index client.
+ */
+
+void crisv32_arbiter_deallocate_bandwidth(int client, int region)
+{
+	int i;
+	int total_assigned = 0;
+
+	requested_slots[region][client] = 0;
+	active_clients[region][client] = 0;
+
+	for (i = 0; i < NBR_OF_CLIENTS; i++)
+		total_assigned += requested_slots[region][i];
+
+	crisv32_arbiter_config(region, NBR_OF_SLOTS - total_assigned);
+}
+
+int crisv32_arbiter_watch(unsigned long start, unsigned long size,
+			  unsigned long clients, unsigned long accesses,
+			  watch_callback *cb)
+{
+	int i;
+
+	crisv32_arbiter_init();
+
+	if (start > 0x80000000) {
+		printk(KERN_ERR "Arbiter: %lX doesn't look like a "
+			"physical address", start);
+		return -EFAULT;
+	}
+
+	spin_lock(&arbiter_lock);
+
+	for (i = 0; i < NUMBER_OF_BP; i++) {
+		if (!watches[i].used) {
+			reg_marb_rw_intr_mask intr_mask =
+			    REG_RD(marb, regi_marb, rw_intr_mask);
+
+			watches[i].used = 1;
+			watches[i].start = start;
+			watches[i].end = start + size;
+			watches[i].cb = cb;
+
+			REG_WR_INT(marb_bp, watches[i].instance, rw_first_addr,
+				   watches[i].start);
+			REG_WR_INT(marb_bp, watches[i].instance, rw_last_addr,
+				   watches[i].end);
+			REG_WR_INT(marb_bp, watches[i].instance, rw_op,
+				   accesses);
+			REG_WR_INT(marb_bp, watches[i].instance, rw_clients,
+				   clients);
+
+			if (i == 0)
+				intr_mask.bp0 = regk_marb_yes;
+			else if (i == 1)
+				intr_mask.bp1 = regk_marb_yes;
+			else if (i == 2)
+				intr_mask.bp2 = regk_marb_yes;
+			else if (i == 3)
+				intr_mask.bp3 = regk_marb_yes;
+
+			REG_WR(marb, regi_marb, rw_intr_mask, intr_mask);
+			spin_unlock(&arbiter_lock);
+
+			return i;
+		}
+	}
+	spin_unlock(&arbiter_lock);
+	return -ENOMEM;
+}
+
+int crisv32_arbiter_unwatch(int id)
+{
+	reg_marb_rw_intr_mask intr_mask = REG_RD(marb, regi_marb, rw_intr_mask);
+
+	crisv32_arbiter_init();
+
+	spin_lock(&arbiter_lock);
+
+	if ((id < 0) || (id >= NUMBER_OF_BP) || (!watches[id].used)) {
+		spin_unlock(&arbiter_lock);
+		return -EINVAL;
+	}
+
+	memset(&watches[id], 0, sizeof(struct crisv32_watch_entry));
+
+	if (id == 0)
+		intr_mask.bp0 = regk_marb_no;
+	else if (id == 1)
+		intr_mask.bp2 = regk_marb_no;
+	else if (id == 2)
+		intr_mask.bp2 = regk_marb_no;
+	else if (id == 3)
+		intr_mask.bp3 = regk_marb_no;
+
+	REG_WR(marb, regi_marb, rw_intr_mask, intr_mask);
+
+	spin_unlock(&arbiter_lock);
+	return 0;
+}
+
+extern void show_registers(struct pt_regs *regs);
+
+static irqreturn_t crisv32_arbiter_irq(int irq, void *dev_id)
+{
+	reg_marb_r_masked_intr masked_intr =
+	    REG_RD(marb, regi_marb, r_masked_intr);
+	reg_marb_bp_r_brk_clients r_clients;
+	reg_marb_bp_r_brk_addr r_addr;
+	reg_marb_bp_r_brk_op r_op;
+	reg_marb_bp_r_brk_first_client r_first;
+	reg_marb_bp_r_brk_size r_size;
+	reg_marb_bp_rw_ack ack = { 0 };
+	reg_marb_rw_ack_intr ack_intr = {
+		.bp0 = 1, .bp1 = 1, .bp2 = 1, .bp3 = 1
+	};
+	struct crisv32_watch_entry *watch;
+
+	if (masked_intr.bp0) {
+		watch = &watches[0];
+		ack_intr.bp0 = regk_marb_yes;
+	} else if (masked_intr.bp1) {
+		watch = &watches[1];
+		ack_intr.bp1 = regk_marb_yes;
+	} else if (masked_intr.bp2) {
+		watch = &watches[2];
+		ack_intr.bp2 = regk_marb_yes;
+	} else if (masked_intr.bp3) {
+		watch = &watches[3];
+		ack_intr.bp3 = regk_marb_yes;
+	} else {
+		return IRQ_NONE;
+	}
+
+	/* Retrieve all useful information and print it. */
+	r_clients = REG_RD(marb_bp, watch->instance, r_brk_clients);
+	r_addr = REG_RD(marb_bp, watch->instance, r_brk_addr);
+	r_op = REG_RD(marb_bp, watch->instance, r_brk_op);
+	r_first = REG_RD(marb_bp, watch->instance, r_brk_first_client);
+	r_size = REG_RD(marb_bp, watch->instance, r_brk_size);
+
+	printk(KERN_INFO "Arbiter IRQ\n");
+	printk(KERN_INFO "Clients %X addr %X op %X first %X size %X\n",
+	       REG_TYPE_CONV(int, reg_marb_bp_r_brk_clients, r_clients),
+	       REG_TYPE_CONV(int, reg_marb_bp_r_brk_addr, r_addr),
+	       REG_TYPE_CONV(int, reg_marb_bp_r_brk_op, r_op),
+	       REG_TYPE_CONV(int, reg_marb_bp_r_brk_first_client, r_first),
+	       REG_TYPE_CONV(int, reg_marb_bp_r_brk_size, r_size));
+
+	REG_WR(marb_bp, watch->instance, rw_ack, ack);
+	REG_WR(marb, regi_marb, rw_ack_intr, ack_intr);
+
+	printk(KERN_INFO "IRQ occured at %lX\n", get_irq_regs()->erp);
+
+	if (watch->cb)
+		watch->cb();
+
+	return IRQ_HANDLED;
+}
diff --git a/arch/cris/arch-v32/mach-fs/cpufreq.c b/arch/cris/arch-v32/mach-fs/cpufreq.c
new file mode 100644
index 0000000..20f8342
--- /dev/null
+++ b/arch/cris/arch-v32/mach-fs/cpufreq.c
@@ -0,0 +1,146 @@
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/cpufreq.h>
+#include <asm/arch/hwregs/reg_map.h>
+#include <asm/arch/hwregs/reg_rdwr.h>
+#include <asm/arch/hwregs/config_defs.h>
+#include <asm/arch/hwregs/bif_core_defs.h>
+
+static int
+cris_sdram_freq_notifier(struct notifier_block *nb, unsigned long val,
+			 void *data);
+
+static struct notifier_block cris_sdram_freq_notifier_block = {
+	.notifier_call = cris_sdram_freq_notifier
+};
+
+static struct cpufreq_frequency_table cris_freq_table[] = {
+	{0x01, 6000},
+	{0x02, 200000},
+	{0, CPUFREQ_TABLE_END},
+};
+
+static unsigned int cris_freq_get_cpu_frequency(unsigned int cpu)
+{
+	reg_config_rw_clk_ctrl clk_ctrl;
+	clk_ctrl = REG_RD(config, regi_config, rw_clk_ctrl);
+	return clk_ctrl.pll ? 200000 : 6000;
+}
+
+static void cris_freq_set_cpu_state(unsigned int state)
+{
+	int i;
+	struct cpufreq_freqs freqs;
+	reg_config_rw_clk_ctrl clk_ctrl;
+	clk_ctrl = REG_RD(config, regi_config, rw_clk_ctrl);
+
+	for_each_cpu(i) {
+		freqs.old = cris_freq_get_cpu_frequency(i);
+		freqs.new = cris_freq_table[state].frequency;
+		freqs.cpu = i;
+	}
+
+	cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
+
+	local_irq_disable();
+
+	/* Even though we may be SMP they will share the same clock
+	 * so all settings are made on CPU0. */
+	if (cris_freq_table[state].frequency == 200000)
+		clk_ctrl.pll = 1;
+	else
+		clk_ctrl.pll = 0;
+	REG_WR(config, regi_config, rw_clk_ctrl, clk_ctrl);
+
+	local_irq_enable();
+
+	cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
+};
+
+static int cris_freq_verify(struct cpufreq_policy *policy)
+{
+	return cpufreq_frequency_table_verify(policy, &cris_freq_table[0]);
+}
+
+static int cris_freq_target(struct cpufreq_policy *policy,
+			    unsigned int target_freq, unsigned int relation)
+{
+	unsigned int newstate = 0;
+
+	if (cpufreq_frequency_table_target
+	    (policy, cris_freq_table, target_freq, relation, &newstate))
+		return -EINVAL;
+
+	cris_freq_set_cpu_state(newstate);
+
+	return 0;
+}
+
+static int cris_freq_cpu_init(struct cpufreq_policy *policy)
+{
+	int result;
+
+	/* cpuinfo and default policy values */
+	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
+	policy->cpuinfo.transition_latency = 1000000;	/* 1ms */
+	policy->cur = cris_freq_get_cpu_frequency(0);
+
+	result = cpufreq_frequency_table_cpuinfo(policy, cris_freq_table);
+	if (result)
+		return (result);
+
+	cpufreq_frequency_table_get_attr(cris_freq_table, policy->cpu);
+
+	return 0;
+}
+
+static int cris_freq_cpu_exit(struct cpufreq_policy *policy)
+{
+	cpufreq_frequency_table_put_attr(policy->cpu);
+	return 0;
+}
+
+static struct freq_attr *cris_freq_attr[] = {
+	&cpufreq_freq_attr_scaling_available_freqs,
+	NULL,
+};
+
+static struct cpufreq_driver cris_freq_driver = {
+	.get = cris_freq_get_cpu_frequency,
+	.verify = cris_freq_verify,
+	.target = cris_freq_target,
+	.init = cris_freq_cpu_init,
+	.exit = cris_freq_cpu_exit,
+	.name = "cris_freq",
+	.owner = THIS_MODULE,
+	.attr = cris_freq_attr,
+};
+
+static int __init cris_freq_init(void)
+{
+	int ret;
+	ret = cpufreq_register_driver(&cris_freq_driver);
+	cpufreq_register_notifier(&cris_sdram_freq_notifier_block,
+				  CPUFREQ_TRANSITION_NOTIFIER);
+	return ret;
+}
+
+static int
+cris_sdram_freq_notifier(struct notifier_block *nb, unsigned long val,
+			 void *data)
+{
+	int i;
+	struct cpufreq_freqs *freqs = data;
+	if (val == CPUFREQ_PRECHANGE) {
+		reg_bif_core_rw_sdram_timing timing =
+		    REG_RD(bif_core, regi_bif_core, rw_sdram_timing);
+		timing.cpd = (freqs->new == 200000 ? 0 : 1);
+
+		if (freqs->new == 200000)
+			for (i = 0; i < 50000; i++) ;
+		REG_WR(bif_core, regi_bif_core, rw_sdram_timing, timing);
+	}
+	return 0;
+}
+
+module_init(cris_freq_init);
diff --git a/arch/cris/arch-v32/mach-fs/dma.c b/arch/cris/arch-v32/mach-fs/dma.c
new file mode 100644
index 0000000..a6acf4e
--- /dev/null
+++ b/arch/cris/arch-v32/mach-fs/dma.c
@@ -0,0 +1,230 @@
+/* Wrapper for DMA channel allocator that starts clocks etc */
+
+#include <linux/kernel.h>
+#include <linux/spinlock.h>
+#include <asm/dma.h>
+#include <hwregs/reg_map.h>
+#include <hwregs/reg_rdwr.h>
+#include <hwregs/marb_defs.h>
+#include <hwregs/config_defs.h>
+#include <hwregs/strmux_defs.h>
+#include <linux/errno.h>
+#include <asm/system.h>
+#include <asm/arch/mach/arbiter.h>
+
+static char used_dma_channels[MAX_DMA_CHANNELS];
+static const char *used_dma_channels_users[MAX_DMA_CHANNELS];
+
+static DEFINE_SPINLOCK(dma_lock);
+
+int crisv32_request_dma(unsigned int dmanr, const char *device_id,
+			unsigned options, unsigned int bandwidth,
+			enum dma_owner owner)
+{
+	unsigned long flags;
+	reg_config_rw_clk_ctrl clk_ctrl;
+	reg_strmux_rw_cfg strmux_cfg;
+
+	if (crisv32_arbiter_allocate_bandwidth(dmanr,
+					       options & DMA_INT_MEM ?
+					       INT_REGION : EXT_REGION,
+					       bandwidth))
+		return -ENOMEM;
+
+	spin_lock_irqsave(&dma_lock, flags);
+
+	if (used_dma_channels[dmanr]) {
+		spin_unlock_irqrestore(&dma_lock, flags);
+		if (options & DMA_VERBOSE_ON_ERROR) {
+			printk(KERN_ERR "Failed to request DMA %i for %s, "
+				"already allocated by %s\n",
+				dmanr,
+				device_id,
+				used_dma_channels_users[dmanr]);
+		}
+		if (options & DMA_PANIC_ON_ERROR)
+			panic("request_dma error!");
+		spin_unlock_irqrestore(&dma_lock, flags);
+		return -EBUSY;
+	}
+	clk_ctrl = REG_RD(config, regi_config, rw_clk_ctrl);
+	strmux_cfg = REG_RD(strmux, regi_strmux, rw_cfg);
+
+	switch (dmanr) {
+	case 0:
+	case 1:
+		clk_ctrl.dma01_eth0 = 1;
+		break;
+	case 2:
+	case 3:
+		clk_ctrl.dma23 = 1;
+		break;
+	case 4:
+	case 5:
+		clk_ctrl.dma45 = 1;
+		break;
+	case 6:
+	case 7:
+		clk_ctrl.dma67 = 1;
+		break;
+	case 8:
+	case 9:
+		clk_ctrl.dma89_strcop = 1;
+		break;
+#if MAX_DMA_CHANNELS-1 != 9
+#error Check dma.c
+#endif
+	default:
+		spin_unlock_irqrestore(&dma_lock, flags);
+		if (options & DMA_VERBOSE_ON_ERROR) {
+			printk(KERN_ERR "Failed to request DMA %i for %s, "
+				"only 0-%i valid)\n",
+				dmanr, device_id, MAX_DMA_CHANNELS - 1);
+		}
+
+		if (options & DMA_PANIC_ON_ERROR)
+			panic("request_dma error!");
+		return -EINVAL;
+	}
+
+	switch (owner) {
+	case dma_eth0:
+		if (dmanr == 0)
+			strmux_cfg.dma0 = regk_strmux_eth0;
+		else if (dmanr == 1)
+			strmux_cfg.dma1 = regk_strmux_eth0;
+		else
+			panic("Invalid DMA channel for eth0\n");
+		break;
+	case dma_eth1:
+		if (dmanr == 6)
+			strmux_cfg.dma6 = regk_strmux_eth1;
+		else if (dmanr == 7)
+			strmux_cfg.dma7 = regk_strmux_eth1;
+		else
+			panic("Invalid DMA channel for eth1\n");
+		break;
+	case dma_iop0:
+		if (dmanr == 2)
+			strmux_cfg.dma2 = regk_strmux_iop0;
+		else if (dmanr == 3)
+			strmux_cfg.dma3 = regk_strmux_iop0;
+		else
+			panic("Invalid DMA channel for iop0\n");
+		break;
+	case dma_iop1:
+		if (dmanr == 4)
+			strmux_cfg.dma4 = regk_strmux_iop1;
+		else if (dmanr == 5)
+			strmux_cfg.dma5 = regk_strmux_iop1;
+		else
+			panic("Invalid DMA channel for iop1\n");
+		break;
+	case dma_ser0:
+		if (dmanr == 6)
+			strmux_cfg.dma6 = regk_strmux_ser0;
+		else if (dmanr == 7)
+			strmux_cfg.dma7 = regk_strmux_ser0;
+		else
+			panic("Invalid DMA channel for ser0\n");
+		break;
+	case dma_ser1:
+		if (dmanr == 4)
+			strmux_cfg.dma4 = regk_strmux_ser1;
+		else if (dmanr == 5)
+			strmux_cfg.dma5 = regk_strmux_ser1;
+		else
+			panic("Invalid DMA channel for ser1\n");
+		break;
+	case dma_ser2:
+		if (dmanr == 2)
+			strmux_cfg.dma2 = regk_strmux_ser2;
+		else if (dmanr == 3)
+			strmux_cfg.dma3 = regk_strmux_ser2;
+		else
+			panic("Invalid DMA channel for ser2\n");
+		break;
+	case dma_ser3:
+		if (dmanr == 8)
+			strmux_cfg.dma8 = regk_strmux_ser3;
+		else if (dmanr == 9)
+			strmux_cfg.dma9 = regk_strmux_ser3;
+		else
+			panic("Invalid DMA channel for ser3\n");
+		break;
+	case dma_sser0:
+		if (dmanr == 4)
+			strmux_cfg.dma4 = regk_strmux_sser0;
+		else if (dmanr == 5)
+			strmux_cfg.dma5 = regk_strmux_sser0;
+		else
+			panic("Invalid DMA channel for sser0\n");
+		break;
+	case dma_sser1:
+		if (dmanr == 6)
+			strmux_cfg.dma6 = regk_strmux_sser1;
+		else if (dmanr == 7)
+			strmux_cfg.dma7 = regk_strmux_sser1;
+		else
+			panic("Invalid DMA channel for sser1\n");
+		break;
+	case dma_ata:
+		if (dmanr == 2)
+			strmux_cfg.dma2 = regk_strmux_ata;
+		else if (dmanr == 3)
+			strmux_cfg.dma3 = regk_strmux_ata;
+		else
+			panic("Invalid DMA channel for ata\n");
+		break;
+	case dma_strp:
+		if (dmanr == 8)
+			strmux_cfg.dma8 = regk_strmux_strcop;
+		else if (dmanr == 9)
+			strmux_cfg.dma9 = regk_strmux_strcop;
+		else
+			panic("Invalid DMA channel for strp\n");
+		break;
+	case dma_ext0:
+		if (dmanr == 6)
+			strmux_cfg.dma6 = regk_strmux_ext0;
+		else
+			panic("Invalid DMA channel for ext0\n");
+		break;
+	case dma_ext1:
+		if (dmanr == 7)
+			strmux_cfg.dma7 = regk_strmux_ext1;
+		else
+			panic("Invalid DMA channel for ext1\n");
+		break;
+	case dma_ext2:
+		if (dmanr == 2)
+			strmux_cfg.dma2 = regk_strmux_ext2;
+		else if (dmanr == 8)
+			strmux_cfg.dma8 = regk_strmux_ext2;
+		else
+			panic("Invalid DMA channel for ext2\n");
+		break;
+	case dma_ext3:
+		if (dmanr == 3)
+			strmux_cfg.dma3 = regk_strmux_ext3;
+		else if (dmanr == 9)
+			strmux_cfg.dma9 = regk_strmux_ext2;
+		else
+			panic("Invalid DMA channel for ext2\n");
+		break;
+	}
+
+	used_dma_channels[dmanr] = 1;
+	used_dma_channels_users[dmanr] = device_id;
+	REG_WR(config, regi_config, rw_clk_ctrl, clk_ctrl);
+	REG_WR(strmux, regi_strmux, rw_cfg, strmux_cfg);
+	spin_unlock_irqrestore(&dma_lock, flags);
+	return 0;
+}
+
+void crisv32_free_dma(unsigned int dmanr)
+{
+	spin_lock(&dma_lock);
+	used_dma_channels[dmanr] = 0;
+	spin_unlock(&dma_lock);
+}
diff --git a/arch/cris/arch-v32/mach-fs/dram_init.S b/arch/cris/arch-v32/mach-fs/dram_init.S
new file mode 100644
index 0000000..6fbad33
--- /dev/null
+++ b/arch/cris/arch-v32/mach-fs/dram_init.S
@@ -0,0 +1,116 @@
+/*
+ * DRAM/SDRAM initialization - alter with care
+ * This file is intended to be included from other assembler files
+ *
+ * Note: This file may not modify r8 or r9 because they are used to
+ * carry information from the decompresser to the kernel
+ *
+ * Copyright (C) 2000-2007 Axis Communications AB
+ *
+ * Authors:  Mikael Starvik <starvik@axis.com>
+ */
+
+/* Just to be certain the config file is included, we include it here
+ * explicitely instead of depending on it being included in the file that
+ * uses this code.
+ */
+
+#include <hwregs/asm/reg_map_asm.h>
+#include <hwregs/asm/bif_core_defs_asm.h>
+
+	;; WARNING! The registers r8 and r9 are used as parameters carrying
+	;; information from the decompressor (if the kernel was compressed).
+	;; They should not be used in the code below.
+
+	; Refer to BIF MDS for a description of SDRAM initialization
+
+	; Bank configuration
+	move.d   REG_ADDR(bif_core, regi_bif_core, rw_sdram_cfg_grp0), $r0
+	move.d   CONFIG_ETRAX_SDRAM_GRP0_CONFIG, $r1
+	move.d   $r1, [$r0]
+	move.d   REG_ADDR(bif_core, regi_bif_core, rw_sdram_cfg_grp1), $r0
+	move.d   CONFIG_ETRAX_SDRAM_GRP1_CONFIG, $r1
+	move.d   $r1, [$r0]
+
+	; Calculate value of mrs_data
+	; CAS latency = 2 && bus_width = 32 => 0x40
+	; CAS latency = 3 && bus_width = 32 => 0x60
+	; CAS latency = 2 && bus_width = 16 => 0x20
+	; CAS latency = 3 && bus_width = 16 => 0x30
+
+	; Check if value is already supplied in kernel config
+	move.d   CONFIG_ETRAX_SDRAM_COMMAND, $r2
+	bne	 _set_timing
+	nop
+
+	move.d   0x40, $r4       ; Assume 32 bits and CAS latency = 2
+	move.d   CONFIG_ETRAX_SDRAM_TIMING, $r1
+	and.d    0x07, $r1       ; Get CAS latency
+	cmpq	 2, $r1		 ; CL = 2 ?
+	beq	 _bw_check
+	nop
+	move.d   0x60, $r4
+
+_bw_check:
+	; Assume that group 0 width is equal to group 1. This assumption
+	; is wrong for a group 1 only hardware (such as the grand old
+	; StorPoint+).
+	move.d   CONFIG_ETRAX_SDRAM_GRP0_CONFIG, $r1
+	and.d    0x200, $r1	; DRAM width is bit 9
+	beq      _set_timing
+	lslq	 2, $r4		;  mrs_data starts at bit 2
+	lsrq     1, $r4		;  16 bits. Shift down value.
+
+	; Set timing parameters (refresh off to avoid Guinness TR 83)
+_set_timing:
+	move.d   CONFIG_ETRAX_SDRAM_TIMING, $r1
+	and.d    ~(3 << reg_bif_core_rw_sdram_timing___ref___lsb), $r1
+	move.d   REG_ADDR(bif_core, regi_bif_core, rw_sdram_timing), $r0
+	move.d   $r1, [$r0]
+
+	; Issue NOP command
+	move.d REG_ADDR(bif_core, regi_bif_core, rw_sdram_cmd), $r5
+	moveq regk_bif_core_nop, $r1
+	move.d $r1, [$r5]
+
+	; Wait 200us
+	move.d   10000, $r2
+1:	bne      1b
+	subq     1, $r2
+
+	; Issue initialization command sequence
+	lapc     _sdram_commands_start, $r2
+	lapc     _sdram_commands_end,  $r3
+1:	clear.d  $r6
+	move.b   [$r2+], $r6	; Load command
+	or.d     $r4, $r6	; Add calculated mrs
+	move.d   $r6, [$r5]	; Write rw_sdram_cmd
+	; Wait 80 ns between each command
+	move.d	 4000, $r7
+2:	bne	 2b
+	subq	 1, $r7
+	cmp.d    $r2, $r3	; Last command?
+	bne      1b
+	nop
+
+	; Start refresh
+	move.d   CONFIG_ETRAX_SDRAM_TIMING, $r1
+	move.d   REG_ADDR(bif_core, regi_bif_core, rw_sdram_timing), $r0
+	move.d   $r1, [$r0]
+
+	; Initialization finished
+	ba       _sdram_commands_end
+	nop
+
+_sdram_commands_start:
+	.byte   regk_bif_core_pre ; Precharge
+	.byte   regk_bif_core_ref ; refresh
+	.byte   regk_bif_core_ref ; refresh
+	.byte   regk_bif_core_ref ; refresh
+	.byte   regk_bif_core_ref ; refresh
+	.byte   regk_bif_core_ref ; refresh
+	.byte   regk_bif_core_ref ; refresh
+	.byte   regk_bif_core_ref ; refresh
+	.byte   regk_bif_core_ref ; refresh
+	.byte   regk_bif_core_mrs ; mrs
+_sdram_commands_end:
diff --git a/arch/cris/arch-v32/mach-fs/hw_settings.S b/arch/cris/arch-v32/mach-fs/hw_settings.S
new file mode 100644
index 0000000..8bde93c
--- /dev/null
+++ b/arch/cris/arch-v32/mach-fs/hw_settings.S
@@ -0,0 +1,70 @@
+/*
+ * This table is used by some tools to extract hardware parameters.
+ * The table should be included in the kernel and the decompressor.
+ * Don't forget to update the tools if you change this table.
+ *
+ * Copyright (C) 2001-2007 Axis Communications AB
+ *
+ * Authors:  Mikael Starvik <starvik@axis.com>
+ */
+
+#include <hwregs/asm/reg_map_asm.h>
+#include <hwregs/asm/bif_core_defs_asm.h>
+#include <hwregs/asm/gio_defs_asm.h>
+
+	.ascii "HW_PARAM_MAGIC" ; Magic number
+	.dword 0xc0004000	; Kernel start address
+
+	; Debug port
+#ifdef CONFIG_ETRAX_DEBUG_PORT0
+	.dword 0
+#elif defined(CONFIG_ETRAX_DEBUG_PORT1)
+	.dword 1
+#elif defined(CONFIG_ETRAX_DEBUG_PORT2)
+	.dword 2
+#elif defined(CONFIG_ETRAX_DEBUG_PORT3)
+	.dword 3
+#else
+	.dword 4 ; No debug
+#endif
+
+	; Register values
+	.dword REG_ADDR(bif_core, regi_bif_core, rw_grp1_cfg)
+	.dword CONFIG_ETRAX_MEM_GRP1_CONFIG
+	.dword REG_ADDR(bif_core, regi_bif_core, rw_grp2_cfg)
+	.dword CONFIG_ETRAX_MEM_GRP2_CONFIG
+	.dword REG_ADDR(bif_core, regi_bif_core, rw_grp3_cfg)
+	.dword CONFIG_ETRAX_MEM_GRP3_CONFIG
+	.dword REG_ADDR(bif_core, regi_bif_core, rw_grp4_cfg)
+	.dword CONFIG_ETRAX_MEM_GRP4_CONFIG
+	.dword REG_ADDR(bif_core, regi_bif_core, rw_sdram_cfg_grp0)
+	.dword CONFIG_ETRAX_SDRAM_GRP0_CONFIG
+	.dword REG_ADDR(bif_core, regi_bif_core, rw_sdram_cfg_grp1)
+	.dword CONFIG_ETRAX_SDRAM_GRP1_CONFIG
+	.dword REG_ADDR(bif_core, regi_bif_core, rw_sdram_timing)
+	.dword CONFIG_ETRAX_SDRAM_TIMING
+	.dword REG_ADDR(bif_core, regi_bif_core, rw_sdram_cmd)
+	.dword CONFIG_ETRAX_SDRAM_COMMAND
+
+	.dword REG_ADDR(gio, regi_gio, rw_pa_dout)
+	.dword CONFIG_ETRAX_DEF_GIO_PA_OUT
+	.dword REG_ADDR(gio, regi_gio, rw_pa_oe)
+	.dword CONFIG_ETRAX_DEF_GIO_PA_OE
+	.dword REG_ADDR(gio, regi_gio, rw_pb_dout)
+	.dword CONFIG_ETRAX_DEF_GIO_PB_OUT
+	.dword REG_ADDR(gio, regi_gio, rw_pb_oe)
+	.dword CONFIG_ETRAX_DEF_GIO_PB_OE
+	.dword REG_ADDR(gio, regi_gio, rw_pc_dout)
+	.dword CONFIG_ETRAX_DEF_GIO_PC_OUT
+	.dword REG_ADDR(gio, regi_gio, rw_pc_oe)
+	.dword CONFIG_ETRAX_DEF_GIO_PC_OE
+	.dword REG_ADDR(gio, regi_gio, rw_pd_dout)
+	.dword CONFIG_ETRAX_DEF_GIO_PD_OUT
+	.dword REG_ADDR(gio, regi_gio, rw_pd_oe)
+	.dword CONFIG_ETRAX_DEF_GIO_PD_OE
+	.dword REG_ADDR(gio, regi_gio, rw_pe_dout)
+	.dword CONFIG_ETRAX_DEF_GIO_PE_OUT
+	.dword REG_ADDR(gio, regi_gio, rw_pe_oe)
+	.dword CONFIG_ETRAX_DEF_GIO_PE_OE
+
+	.dword 0 ; No more register values
diff --git a/arch/cris/arch-v32/mach-fs/io.c b/arch/cris/arch-v32/mach-fs/io.c
new file mode 100644
index 0000000..a03a3ad
--- /dev/null
+++ b/arch/cris/arch-v32/mach-fs/io.c
@@ -0,0 +1,191 @@
+/*
+ * Helper functions for I/O pins.
+ *
+ * Copyright (c) 2004-2007 Axis Communications AB.
+ */
+
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/string.h>
+#include <linux/ctype.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <asm/io.h>
+#include <asm/arch/pinmux.h>
+#include <asm/arch/hwregs/gio_defs.h>
+
+#ifndef DEBUG
+#define DEBUG(x)
+#endif
+
+struct crisv32_ioport crisv32_ioports[] = {
+	{
+		(unsigned long *)REG_ADDR(gio, regi_gio, rw_pa_oe),
+		(unsigned long *)REG_ADDR(gio, regi_gio, rw_pa_dout),
+		(unsigned long *)REG_ADDR(gio, regi_gio, r_pa_din),
+		8
+	},
+	{
+		(unsigned long *)REG_ADDR(gio, regi_gio, rw_pb_oe),
+		(unsigned long *)REG_ADDR(gio, regi_gio, rw_pb_dout),
+		(unsigned long *)REG_ADDR(gio, regi_gio, r_pb_din),
+		18
+	},
+	{
+		(unsigned long *)REG_ADDR(gio, regi_gio, rw_pc_oe),
+		(unsigned long *)REG_ADDR(gio, regi_gio, rw_pc_dout),
+		(unsigned long *)REG_ADDR(gio, regi_gio, r_pc_din),
+		18
+	},
+	{
+		(unsigned long *)REG_ADDR(gio, regi_gio, rw_pd_oe),
+		(unsigned long *)REG_ADDR(gio, regi_gio, rw_pd_dout),
+		(unsigned long *)REG_ADDR(gio, regi_gio, r_pd_din),
+		18
+	},
+	{
+		(unsigned long *)REG_ADDR(gio, regi_gio, rw_pe_oe),
+		(unsigned long *)REG_ADDR(gio, regi_gio, rw_pe_dout),
+		(unsigned long *)REG_ADDR(gio, regi_gio, r_pe_din),
+		18
+	}
+};
+
+#define NBR_OF_PORTS sizeof(crisv32_ioports)/sizeof(struct crisv32_ioport)
+
+struct crisv32_iopin crisv32_led_net0_green;
+struct crisv32_iopin crisv32_led_net0_red;
+struct crisv32_iopin crisv32_led_net1_green;
+struct crisv32_iopin crisv32_led_net1_red;
+struct crisv32_iopin crisv32_led2_green;
+struct crisv32_iopin crisv32_led2_red;
+struct crisv32_iopin crisv32_led3_green;
+struct crisv32_iopin crisv32_led3_red;
+
+/* Dummy port used when green LED and red LED is on the same bit */
+static unsigned long io_dummy;
+static struct crisv32_ioport dummy_port = {
+	&io_dummy,
+	&io_dummy,
+	&io_dummy,
+	18
+};
+static struct crisv32_iopin dummy_led = {
+	&dummy_port,
+	0
+};
+
+static int __init crisv32_io_init(void)
+{
+	int ret = 0;
+
+	u32 i;
+
+	/* Locks *should* be dynamically initialized. */
+	for (i = 0; i < ARRAY_SIZE(crisv32_ioports); i++)
+		spin_lock_init(&crisv32_ioports[i].lock);
+	spin_lock_init(&dummy_port.lock);
+
+	/* Initialize LEDs */
+#if (defined(CONFIG_ETRAX_NBR_LED_GRP_ONE) || defined(CONFIG_ETRAX_NBR_LED_GRP_TWO))
+	ret +=
+	    crisv32_io_get_name(&crisv32_led_net0_green,
+				CONFIG_ETRAX_LED_G_NET0);
+	crisv32_io_set_dir(&crisv32_led_net0_green, crisv32_io_dir_out);
+	if (strcmp(CONFIG_ETRAX_LED_G_NET0, CONFIG_ETRAX_LED_R_NET0)) {
+		ret +=
+		    crisv32_io_get_name(&crisv32_led_net0_red,
+					CONFIG_ETRAX_LED_R_NET0);
+		crisv32_io_set_dir(&crisv32_led_net0_red, crisv32_io_dir_out);
+	} else
+		crisv32_led_net0_red = dummy_led;
+#endif
+
+#ifdef CONFIG_ETRAX_NBR_LED_GRP_TWO
+	ret +=
+	    crisv32_io_get_name(&crisv32_led_net1_green,
+				CONFIG_ETRAX_LED_G_NET1);
+	crisv32_io_set_dir(&crisv32_led_net1_green, crisv32_io_dir_out);
+	if (strcmp(CONFIG_ETRAX_LED_G_NET1, CONFIG_ETRAX_LED_R_NET1)) {
+		crisv32_io_get_name(&crisv32_led_net1_red,
+				    CONFIG_ETRAX_LED_R_NET1);
+		crisv32_io_set_dir(&crisv32_led_net1_red, crisv32_io_dir_out);
+	} else
+		crisv32_led_net1_red = dummy_led;
+#endif
+
+	ret += crisv32_io_get_name(&crisv32_led2_green, CONFIG_ETRAX_V32_LED2G);
+	ret += crisv32_io_get_name(&crisv32_led2_red, CONFIG_ETRAX_V32_LED2R);
+	ret += crisv32_io_get_name(&crisv32_led3_green, CONFIG_ETRAX_V32_LED3G);
+	ret += crisv32_io_get_name(&crisv32_led3_red, CONFIG_ETRAX_V32_LED3R);
+
+	crisv32_io_set_dir(&crisv32_led2_green, crisv32_io_dir_out);
+	crisv32_io_set_dir(&crisv32_led2_red, crisv32_io_dir_out);
+	crisv32_io_set_dir(&crisv32_led3_green, crisv32_io_dir_out);
+	crisv32_io_set_dir(&crisv32_led3_red, crisv32_io_dir_out);
+
+	return ret;
+}
+
+__initcall(crisv32_io_init);
+
+int crisv32_io_get(struct crisv32_iopin *iopin,
+		   unsigned int port, unsigned int pin)
+{
+	if (port > NBR_OF_PORTS)
+		return -EINVAL;
+	if (port > crisv32_ioports[port].pin_count)
+		return -EINVAL;
+
+	iopin->bit = 1 << pin;
+	iopin->port = &crisv32_ioports[port];
+
+	/* Only allocate pinmux gpiopins if port != PORT_A (port 0) */
+	/* NOTE! crisv32_pinmux_alloc thinks PORT_B is port 0 */
+	if (port != 0 && crisv32_pinmux_alloc(port - 1, pin, pin, pinmux_gpio))
+		return -EIO;
+	DEBUG(printk(KERN_DEBUG "crisv32_io_get: Allocated pin %d on port %d\n",
+		pin, port));
+
+	return 0;
+}
+
+int crisv32_io_get_name(struct crisv32_iopin *iopin, const char *name)
+{
+	int port;
+	int pin;
+
+	if (toupper(*name) == 'P')
+		name++;
+
+	if (toupper(*name) < 'A' || toupper(*name) > 'E')
+		return -EINVAL;
+
+	port = toupper(*name) - 'A';
+	name++;
+	pin = simple_strtoul(name, NULL, 10);
+
+	if (pin < 0 || pin > crisv32_ioports[port].pin_count)
+		return -EINVAL;
+
+	iopin->bit = 1 << pin;
+	iopin->port = &crisv32_ioports[port];
+
+	/* Only allocate pinmux gpiopins if port != PORT_A (port 0) */
+	/* NOTE! crisv32_pinmux_alloc thinks PORT_B is port 0 */
+	if (port != 0 && crisv32_pinmux_alloc(port - 1, pin, pin, pinmux_gpio))
+		return -EIO;
+
+	DEBUG(printk(KERN_DEBUG
+		"crisv32_io_get_name: Allocated pin %d on port %d\n",
+		pin, port));
+
+	return 0;
+}
+
+#ifdef CONFIG_PCI
+/* PCI I/O access stuff */
+struct cris_io_operations *cris_iops = NULL;
+EXPORT_SYMBOL(cris_iops);
+#endif
diff --git a/arch/cris/arch-v32/mach-fs/pinmux.c b/arch/cris/arch-v32/mach-fs/pinmux.c
new file mode 100644
index 0000000..d722ad9
--- /dev/null
+++ b/arch/cris/arch-v32/mach-fs/pinmux.c
@@ -0,0 +1,309 @@
+/*
+ * Allocator for I/O pins. All pins are allocated to GPIO at bootup.
+ * Unassigned pins and GPIO pins can be allocated to a fixed interface
+ * or the I/O processor instead.
+ *
+ * Copyright (c) 2004-2007 Axis Communications AB.
+ */
+
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/spinlock.h>
+#include <hwregs/reg_map.h>
+#include <hwregs/reg_rdwr.h>
+#include <pinmux.h>
+#include <hwregs/pinmux_defs.h>
+
+#undef DEBUG
+
+#define PORT_PINS 18
+#define PORTS 4
+
+static char pins[PORTS][PORT_PINS];
+static DEFINE_SPINLOCK(pinmux_lock);
+
+static void crisv32_pinmux_set(int port);
+
+int crisv32_pinmux_init(void)
+{
+	static int initialized;
+
+	if (!initialized) {
+		reg_pinmux_rw_pa pa = REG_RD(pinmux, regi_pinmux, rw_pa);
+		initialized = 1;
+		REG_WR_INT(pinmux, regi_pinmux, rw_hwprot, 0);
+		pa.pa0 = pa.pa1 = pa.pa2 = pa.pa3 =
+		    pa.pa4 = pa.pa5 = pa.pa6 = pa.pa7 = regk_pinmux_yes;
+		REG_WR(pinmux, regi_pinmux, rw_pa, pa);
+		crisv32_pinmux_alloc(PORT_B, 0, PORT_PINS - 1, pinmux_gpio);
+		crisv32_pinmux_alloc(PORT_C, 0, PORT_PINS - 1, pinmux_gpio);
+		crisv32_pinmux_alloc(PORT_D, 0, PORT_PINS - 1, pinmux_gpio);
+		crisv32_pinmux_alloc(PORT_E, 0, PORT_PINS - 1, pinmux_gpio);
+	}
+
+	return 0;
+}
+
+int
+crisv32_pinmux_alloc(int port, int first_pin, int last_pin, enum pin_mode mode)
+{
+	int i;
+	unsigned long flags;
+
+	crisv32_pinmux_init();
+
+	if (port > PORTS)
+		return -EINVAL;
+
+	spin_lock_irqsave(&pinmux_lock, flags);
+
+	for (i = first_pin; i <= last_pin; i++) {
+		if ((pins[port][i] != pinmux_none)
+		    && (pins[port][i] != pinmux_gpio)
+		    && (pins[port][i] != mode)) {
+			spin_unlock_irqrestore(&pinmux_lock, flags);
+#ifdef DEBUG
+			panic("Pinmux alloc failed!\n");
+#endif
+			return -EPERM;
+		}
+	}
+
+	for (i = first_pin; i <= last_pin; i++)
+		pins[port][i] = mode;
+
+	crisv32_pinmux_set(port);
+
+	spin_unlock_irqrestore(&pinmux_lock, flags);
+
+	return 0;
+}
+
+int crisv32_pinmux_alloc_fixed(enum fixed_function function)
+{
+	int ret = -EINVAL;
+	char saved[sizeof pins];
+	unsigned long flags;
+
+	spin_lock_irqsave(&pinmux_lock, flags);
+
+	/* Save internal data for recovery */
+	memcpy(saved, pins, sizeof pins);
+
+	crisv32_pinmux_init();	/* Must be done before we read rw_hwprot */
+
+	reg_pinmux_rw_hwprot hwprot = REG_RD(pinmux, regi_pinmux, rw_hwprot);
+
+	switch (function) {
+	case pinmux_ser1:
+		ret = crisv32_pinmux_alloc(PORT_C, 4, 7, pinmux_fixed);
+		hwprot.ser1 = regk_pinmux_yes;
+		break;
+	case pinmux_ser2:
+		ret = crisv32_pinmux_alloc(PORT_C, 8, 11, pinmux_fixed);
+		hwprot.ser2 = regk_pinmux_yes;
+		break;
+	case pinmux_ser3:
+		ret = crisv32_pinmux_alloc(PORT_C, 12, 15, pinmux_fixed);
+		hwprot.ser3 = regk_pinmux_yes;
+		break;
+	case pinmux_sser0:
+		ret = crisv32_pinmux_alloc(PORT_C, 0, 3, pinmux_fixed);
+		ret |= crisv32_pinmux_alloc(PORT_C, 16, 16, pinmux_fixed);
+		hwprot.sser0 = regk_pinmux_yes;
+		break;
+	case pinmux_sser1:
+		ret = crisv32_pinmux_alloc(PORT_D, 0, 4, pinmux_fixed);
+		hwprot.sser1 = regk_pinmux_yes;
+		break;
+	case pinmux_ata0:
+		ret = crisv32_pinmux_alloc(PORT_D, 5, 7, pinmux_fixed);
+		ret |= crisv32_pinmux_alloc(PORT_D, 15, 17, pinmux_fixed);
+		hwprot.ata0 = regk_pinmux_yes;
+		break;
+	case pinmux_ata1:
+		ret = crisv32_pinmux_alloc(PORT_D, 0, 4, pinmux_fixed);
+		ret |= crisv32_pinmux_alloc(PORT_E, 17, 17, pinmux_fixed);
+		hwprot.ata1 = regk_pinmux_yes;
+		break;
+	case pinmux_ata2:
+		ret = crisv32_pinmux_alloc(PORT_C, 11, 15, pinmux_fixed);
+		ret |= crisv32_pinmux_alloc(PORT_E, 3, 3, pinmux_fixed);
+		hwprot.ata2 = regk_pinmux_yes;
+		break;
+	case pinmux_ata3:
+		ret = crisv32_pinmux_alloc(PORT_C, 8, 10, pinmux_fixed);
+		ret |= crisv32_pinmux_alloc(PORT_C, 0, 2, pinmux_fixed);
+		hwprot.ata2 = regk_pinmux_yes;
+		break;
+	case pinmux_ata:
+		ret = crisv32_pinmux_alloc(PORT_B, 0, 15, pinmux_fixed);
+		ret |= crisv32_pinmux_alloc(PORT_D, 8, 15, pinmux_fixed);
+		hwprot.ata = regk_pinmux_yes;
+		break;
+	case pinmux_eth1:
+		ret = crisv32_pinmux_alloc(PORT_E, 0, 17, pinmux_fixed);
+		hwprot.eth1 = regk_pinmux_yes;
+		hwprot.eth1_mgm = regk_pinmux_yes;
+		break;
+	case pinmux_timer:
+		ret = crisv32_pinmux_alloc(PORT_C, 16, 16, pinmux_fixed);
+		hwprot.timer = regk_pinmux_yes;
+		spin_unlock_irqrestore(&pinmux_lock, flags);
+		return ret;
+	}
+
+	if (!ret)
+		REG_WR(pinmux, regi_pinmux, rw_hwprot, hwprot);
+	else
+		memcpy(pins, saved, sizeof pins);
+
+	spin_unlock_irqrestore(&pinmux_lock, flags);
+
+	return ret;
+}
+
+void crisv32_pinmux_set(int port)
+{
+	int i;
+	int gpio_val = 0;
+	int iop_val = 0;
+
+	for (i = 0; i < PORT_PINS; i++) {
+		if (pins[port][i] == pinmux_gpio)
+			gpio_val |= (1 << i);
+		else if (pins[port][i] == pinmux_iop)
+			iop_val |= (1 << i);
+	}
+
+	REG_WRITE(int, regi_pinmux + REG_RD_ADDR_pinmux_rw_pb_gio + 8 * port,
+		  gpio_val);
+	REG_WRITE(int, regi_pinmux + REG_RD_ADDR_pinmux_rw_pb_iop + 8 * port,
+		  iop_val);
+
+#ifdef DEBUG
+	crisv32_pinmux_dump();
+#endif
+}
+
+int crisv32_pinmux_dealloc(int port, int first_pin, int last_pin)
+{
+	int i;
+	unsigned long flags;
+
+	crisv32_pinmux_init();
+
+	if (port > PORTS)
+		return -EINVAL;
+
+	spin_lock_irqsave(&pinmux_lock, flags);
+
+	for (i = first_pin; i <= last_pin; i++)
+		pins[port][i] = pinmux_none;
+
+	crisv32_pinmux_set(port);
+	spin_unlock_irqrestore(&pinmux_lock, flags);
+
+	return 0;
+}
+
+int crisv32_pinmux_dealloc_fixed(enum fixed_function function)
+{
+	int ret = -EINVAL;
+	char saved[sizeof pins];
+	unsigned long flags;
+
+	spin_lock_irqsave(&pinmux_lock, flags);
+
+	/* Save internal data for recovery */
+	memcpy(saved, pins, sizeof pins);
+
+	crisv32_pinmux_init();	/* Must be done before we read rw_hwprot */
+
+	reg_pinmux_rw_hwprot hwprot = REG_RD(pinmux, regi_pinmux, rw_hwprot);
+
+	switch (function) {
+	case pinmux_ser1:
+		ret = crisv32_pinmux_dealloc(PORT_C, 4, 7);
+		hwprot.ser1 = regk_pinmux_no;
+		break;
+	case pinmux_ser2:
+		ret = crisv32_pinmux_dealloc(PORT_C, 8, 11);
+		hwprot.ser2 = regk_pinmux_no;
+		break;
+	case pinmux_ser3:
+		ret = crisv32_pinmux_dealloc(PORT_C, 12, 15);
+		hwprot.ser3 = regk_pinmux_no;
+		break;
+	case pinmux_sser0:
+		ret = crisv32_pinmux_dealloc(PORT_C, 0, 3);
+		ret |= crisv32_pinmux_dealloc(PORT_C, 16, 16);
+		hwprot.sser0 = regk_pinmux_no;
+		break;
+	case pinmux_sser1:
+		ret = crisv32_pinmux_dealloc(PORT_D, 0, 4);
+		hwprot.sser1 = regk_pinmux_no;
+		break;
+	case pinmux_ata0:
+		ret = crisv32_pinmux_dealloc(PORT_D, 5, 7);
+		ret |= crisv32_pinmux_dealloc(PORT_D, 15, 17);
+		hwprot.ata0 = regk_pinmux_no;
+		break;
+	case pinmux_ata1:
+		ret = crisv32_pinmux_dealloc(PORT_D, 0, 4);
+		ret |= crisv32_pinmux_dealloc(PORT_E, 17, 17);
+		hwprot.ata1 = regk_pinmux_no;
+		break;
+	case pinmux_ata2:
+		ret = crisv32_pinmux_dealloc(PORT_C, 11, 15);
+		ret |= crisv32_pinmux_dealloc(PORT_E, 3, 3);
+		hwprot.ata2 = regk_pinmux_no;
+		break;
+	case pinmux_ata3:
+		ret = crisv32_pinmux_dealloc(PORT_C, 8, 10);
+		ret |= crisv32_pinmux_dealloc(PORT_C, 0, 2);
+		hwprot.ata2 = regk_pinmux_no;
+		break;
+	case pinmux_ata:
+		ret = crisv32_pinmux_dealloc(PORT_B, 0, 15);
+		ret |= crisv32_pinmux_dealloc(PORT_D, 8, 15);
+		hwprot.ata = regk_pinmux_no;
+		break;
+	case pinmux_eth1:
+		ret = crisv32_pinmux_dealloc(PORT_E, 0, 17);
+		hwprot.eth1 = regk_pinmux_no;
+		hwprot.eth1_mgm = regk_pinmux_no;
+		break;
+	case pinmux_timer:
+		ret = crisv32_pinmux_dealloc(PORT_C, 16, 16);
+		hwprot.timer = regk_pinmux_no;
+		spin_unlock_irqrestore(&pinmux_lock, flags);
+		return ret;
+	}
+
+	if (!ret)
+		REG_WR(pinmux, regi_pinmux, rw_hwprot, hwprot);
+	else
+		memcpy(pins, saved, sizeof pins);
+
+	spin_unlock_irqrestore(&pinmux_lock, flags);
+
+	return ret;
+}
+
+void crisv32_pinmux_dump(void)
+{
+	int i, j;
+
+	crisv32_pinmux_init();
+
+	for (i = 0; i < PORTS; i++) {
+		printk(KERN_DEBUG "Port %c\n", 'B' + i);
+		for (j = 0; j < PORT_PINS; j++)
+			printk(KERN_DEBUG "  Pin %d = %d\n", j, pins[i][j]);
+	}
+}
+
+__initcall(crisv32_pinmux_init);
diff --git a/arch/cris/arch-v32/mach-fs/vcs_hook.c b/arch/cris/arch-v32/mach-fs/vcs_hook.c
new file mode 100644
index 0000000..593b10f
--- /dev/null
+++ b/arch/cris/arch-v32/mach-fs/vcs_hook.c
@@ -0,0 +1,100 @@
+/*
+ * Call simulator hook. This is the part running in the
+ * simulated program.
+ */
+
+#include "vcs_hook.h"
+#include <stdarg.h>
+#include <asm/arch-v32/hwregs/reg_map.h>
+#include <asm/arch-v32/hwregs/intr_vect_defs.h>
+
+#define HOOK_TRIG_ADDR     0xb7000000	/* hook cvlog model reg address */
+#define HOOK_MEM_BASE_ADDR 0xa0000000	/* csp4 (shared mem) base addr */
+
+#define HOOK_DATA(offset) ((unsigned *)HOOK_MEM_BASE_ADDR)[offset]
+#define VHOOK_DATA(offset) ((volatile unsigned *)HOOK_MEM_BASE_ADDR)[offset]
+#define HOOK_TRIG(funcid) \
+	do { \
+		*((unsigned *) HOOK_TRIG_ADDR) = funcid; \
+	} while (0)
+#define HOOK_DATA_BYTE(offset) ((unsigned char *)HOOK_MEM_BASE_ADDR)[offset]
+
+int hook_call(unsigned id, unsigned pcnt, ...)
+{
+	va_list ap;
+	unsigned i;
+	unsigned ret;
+#ifdef USING_SOS
+	PREEMPT_OFF_SAVE();
+#endif
+
+	/* pass parameters */
+	HOOK_DATA(0) = id;
+
+	/* Have to make hook_print_str a special case since we call with a
+	 * parameter of byte type. Should perhaps be a separate
+	 * hook_call. */
+
+	if (id == hook_print_str) {
+		int i;
+		char *str;
+
+		HOOK_DATA(1) = pcnt;
+
+		va_start(ap, pcnt);
+		str = (char *)va_arg(ap, unsigned);
+
+		for (i = 0; i != pcnt; i++)
+			HOOK_DATA_BYTE(8 + i) = str[i];
+
+		HOOK_DATA_BYTE(8 + i) = 0;	/* null byte */
+	} else {
+		va_start(ap, pcnt);
+		for (i = 1; i <= pcnt; i++)
+			HOOK_DATA(i) = va_arg(ap, unsigned);
+		va_end(ap);
+	}
+
+	/* read from mem to make sure data has propagated to memory before
+	 * trigging */
+	ret = *((volatile unsigned *)HOOK_MEM_BASE_ADDR);
+
+	/* trigger hook */
+	HOOK_TRIG(id);
+
+	/* wait for call to finish */
+	while (VHOOK_DATA(0) > 0) ;
+
+	/* extract return value */
+
+	ret = VHOOK_DATA(1);
+
+#ifdef USING_SOS
+	PREEMPT_RESTORE();
+#endif
+	return ret;
+}
+
+unsigned hook_buf(unsigned i)
+{
+	return (HOOK_DATA(i));
+}
+
+void print_str(const char *str)
+{
+	int i;
+	/* find null at end of string */
+	for (i = 1; str[i]; i++) ;
+	hook_call(hook_print_str, i, str);
+}
+
+void CPU_KICK_DOG(void)
+{
+	(void)hook_call(hook_kick_dog, 0);
+}
+
+void CPU_WATCHDOG_TIMEOUT(unsigned t)
+{
+	(void)hook_call(hook_dog_timeout, 1, t);
+}
+
diff --git a/arch/cris/arch-v32/mach-fs/vcs_hook.h b/arch/cris/arch-v32/mach-fs/vcs_hook.h
new file mode 100644
index 0000000..c000b9f
--- /dev/null
+++ b/arch/cris/arch-v32/mach-fs/vcs_hook.h
@@ -0,0 +1,42 @@
+/*
+ * Call simulator hook functions
+ */
+
+#ifndef HOOK_H
+#define HOOK_H
+
+int hook_call(unsigned id, unsigned pcnt, ...);
+
+enum hook_ids {
+  hook_debug_on = 1,
+  hook_debug_off,
+  hook_stop_sim_ok,
+  hook_stop_sim_fail,
+  hook_alloc_shared,
+  hook_ptr_shared,
+  hook_free_shared,
+  hook_file2shared,
+  hook_cmp_shared,
+  hook_print_params,
+  hook_sim_time,
+  hook_stop_sim,
+  hook_kick_dog,
+  hook_dog_timeout,
+  hook_rand,
+  hook_srand,
+  hook_rand_range,
+  hook_print_str,
+  hook_print_hex,
+  hook_cmp_offset_shared,
+  hook_fill_random_shared,
+  hook_alloc_random_data,
+  hook_calloc_random_data,
+  hook_print_int,
+  hook_print_uint,
+  hook_fputc,
+  hook_init_fd,
+  hook_sbrk
+
+};
+
+#endif
-- 
1.5.3.6.970.gd25430

