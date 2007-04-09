Return-Path: <linux-kernel-owner+w=401wt.eu-S965881AbXDIVY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965881AbXDIVY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030254AbXDIVX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:23:59 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:26704 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965912AbXDIVXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:23:17 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>
Subject: [PATCH 5/18] ARM: OMAP: Sync headers with linux-omap
Date: Mon,  9 Apr 2007 17:22:10 -0400
Message-Id: <11761537613625-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11761537563620-git-send-email-tony@atomide.com>
References: <11761537431635-git-send-email-tony@atomide.com> <117615374683-git-send-email-tony@atomide.com> <11761537491968-git-send-email-tony@atomide.com> <11761537522665-git-send-email-tony@atomide.com> <11761537563620-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch syncs omap specific headers with linux-omap.
Most of the changes needed because of bitrot caused by
driver changes in linux-omap tree. Integrating this
is needed for adding support for various omap drivers.

Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 include/asm-arm/arch-omap/aic23.h         |    4 +-
 include/asm-arm/arch-omap/board-apollon.h |    9 -
 include/asm-arm/arch-omap/board-h4.h      |    3 -
 include/asm-arm/arch-omap/board.h         |   41 +++--
 include/asm-arm/arch-omap/dsp.h           |  250 -----------------------------
 include/asm-arm/arch-omap/dsp_common.h    |   32 ++--
 include/asm-arm/arch-omap/gpio-switch.h   |   54 ++++++
 include/asm-arm/arch-omap/gpmc.h          |    2 +
 include/asm-arm/arch-omap/hardware.h      |    9 +
 include/asm-arm/arch-omap/io.h            |   11 ++
 include/asm-arm/arch-omap/irqs.h          |   19 ++-
 include/asm-arm/arch-omap/lcd_lph8923.h   |   14 --
 include/asm-arm/arch-omap/lcd_mipid.h     |   24 +++
 include/asm-arm/arch-omap/led.h           |   24 +++
 include/asm-arm/arch-omap/mcspi.h         |    1 -
 include/asm-arm/arch-omap/memory.h        |   13 ++
 include/asm-arm/arch-omap/menelaus.h      |   17 ++-
 include/asm-arm/arch-omap/omap16xx.h      |   12 +-
 include/asm-arm/arch-omap/omap24xx.h      |    9 +
 include/asm-arm/arch-omap/omapfb.h        |  131 +++++++++------
 include/asm-arm/arch-omap/sram.h          |    4 +-
 include/asm-arm/arch-omap/usb.h           |   40 ++++-
 22 files changed, 334 insertions(+), 389 deletions(-)

Index: linux-2.6/include/asm-arm/arch-omap/aic23.h
===================================================================
--- linux-2.6.orig/include/asm-arm/arch-omap/aic23.h	2007-04-06 09:00:28.000000000 -0400
+++ linux-2.6/include/asm-arm/arch-omap/aic23.h	2007-04-09 14:22:43.000000000 -0400
@@ -110,7 +110,7 @@
 #define TLV320AIC23ID1                  (0x1a)	// cs low
 #define TLV320AIC23ID2                  (0x1b)	// cs high
 
-void tlv320aic23_power_up(void);
-void tlv320aic23_power_down(void);
+void aic23_power_up(void);
+void aic23_power_down(void);
 
 #endif /* __ASM_ARCH_AIC23_H */
Index: linux-2.6/include/asm-arm/arch-omap/board-apollon.h
===================================================================
--- linux-2.6.orig/include/asm-arm/arch-omap/board-apollon.h	2007-04-06 09:00:28.000000000 -0400
+++ linux-2.6/include/asm-arm/arch-omap/board-apollon.h	2007-04-09 14:22:43.000000000 -0400
@@ -30,16 +30,7 @@
 #define __ASM_ARCH_OMAP_APOLLON_H
 
 /* Placeholder for APOLLON specific defines */
-/* GPMC CS0 */
-#define APOLLON_CS0_BASE		0x00000000
-/* GPMC CS1 */
-#define APOLLON_CS1_BASE		0x08000000
-#define APOLLON_ETHR_START		(APOLLON_CS1_BASE + 0x300)
 #define APOLLON_ETHR_GPIO_IRQ		74
-/* GPMC CS2 - reserved for OneNAND */
-#define APOLLON_CS2_BASE		0x10000000
-/* GPMC CS3 - reserved for NOR or NAND */
-#define APOLLON_CS3_BASE		0x18000000
 
 #endif /*  __ASM_ARCH_OMAP_APOLLON_H */
 
Index: linux-2.6/include/asm-arm/arch-omap/board-h4.h
===================================================================
--- linux-2.6.orig/include/asm-arm/arch-omap/board-h4.h	2007-04-06 09:00:28.000000000 -0400
+++ linux-2.6/include/asm-arm/arch-omap/board-h4.h	2007-04-09 14:22:43.000000000 -0400
@@ -30,9 +30,6 @@
 #define __ASM_ARCH_OMAP_H4_H
 
 /* Placeholder for H4 specific defines */
-/* GPMC CS1 */
-#define OMAP24XX_ETHR_START             0x08000300
 #define OMAP24XX_ETHR_GPIO_IRQ		92
-#define H4_CS0_BASE			0x04000000
 #endif /*  __ASM_ARCH_OMAP_H4_H */
 
Index: linux-2.6/include/asm-arm/arch-omap/board.h
===================================================================
--- linux-2.6.orig/include/asm-arm/arch-omap/board.h	2007-04-06 09:00:28.000000000 -0400
+++ linux-2.6/include/asm-arm/arch-omap/board.h	2007-04-09 14:22:43.000000000 -0400
@@ -12,6 +12,8 @@
 
 #include <linux/types.h>
 
+#include <asm/arch/gpio-switch.h>
+
 /* Different peripheral ids */
 #define OMAP_TAG_CLOCK		0x4f01
 #define OMAP_TAG_MMC		0x4f02
@@ -99,26 +101,31 @@ struct omap_usb_config {
 struct omap_lcd_config {
 	char panel_name[16];
 	char ctrl_name[16];
+	s16  nreset_gpio;
+	u8   data_lines;
+};
+
+struct device;
+struct fb_info;
+struct omap_backlight_config {
+	int default_intensity;
+	int (*set_power)(struct device *dev, int state);
+	int (*check_fb)(struct fb_info *fb);
 };
 
 struct omap_fbmem_config {
-	u32 fb_sram_start;
-	u32 fb_sram_size;
-	u32 fb_sdram_start;
-	u32 fb_sdram_size;
-};
-
-/* Cover:
- *      high -> closed
- *      low  -> open
- * Connection:
- *      high -> connected
- *      low  -> disconnected
- */
-#define OMAP_GPIO_SWITCH_TYPE_COVER		0x0000
-#define OMAP_GPIO_SWITCH_TYPE_CONNECTION	0x0001
-#define OMAP_GPIO_SWITCH_FLAG_INVERTED		0x0001
-#define OMAP_GPIO_SWITCH_FLAG_OUTPUT		0x0002
+	u32 start;
+	u32 size;
+};
+
+struct omap_pwm_led_platform_data {
+	const char *name;
+	int intensity_timer;
+	int blink_timer;
+	void (*set_power)(struct omap_pwm_led_platform_data *self, int on_off);
+};
+
+/* See include/asm-arm/arch-omap/gpio-switch.h for definitions */
 struct omap_gpio_switch_config {
 	char name[12];
 	u16 gpio;
Index: linux-2.6/include/asm-arm/arch-omap/dsp.h
===================================================================
--- linux-2.6.orig/include/asm-arm/arch-omap/dsp.h	2007-04-06 09:00:28.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,250 +0,0 @@
-/*
- * linux/include/asm-arm/arch-omap/dsp.h
- *
- * Header for OMAP DSP driver
- *
- * Copyright (C) 2002-2005 Nokia Corporation
- *
- * Written by Toshihiro Kobayashi <toshihiro.kobayashi@nokia.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
- *
- * 2005/06/01:  DSP Gateway version 3.3
- */
-
-#ifndef ASM_ARCH_DSP_H
-#define ASM_ARCH_DSP_H
-
-
-/*
- * for /dev/dspctl/ctl
- */
-#define OMAP_DSP_IOCTL_RESET			1
-#define OMAP_DSP_IOCTL_RUN			2
-#define OMAP_DSP_IOCTL_SETRSTVECT		3
-#define OMAP_DSP_IOCTL_CPU_IDLE			4
-#define OMAP_DSP_IOCTL_MPUI_WORDSWAP_ON		5
-#define OMAP_DSP_IOCTL_MPUI_WORDSWAP_OFF	6
-#define OMAP_DSP_IOCTL_MPUI_BYTESWAP_ON		7
-#define OMAP_DSP_IOCTL_MPUI_BYTESWAP_OFF	8
-#define OMAP_DSP_IOCTL_GBL_IDLE			9
-#define OMAP_DSP_IOCTL_DSPCFG			10
-#define OMAP_DSP_IOCTL_DSPUNCFG			11
-#define OMAP_DSP_IOCTL_TASKCNT			12
-#define OMAP_DSP_IOCTL_POLL			13
-#define OMAP_DSP_IOCTL_REGMEMR			40
-#define OMAP_DSP_IOCTL_REGMEMW			41
-#define OMAP_DSP_IOCTL_REGIOR			42
-#define OMAP_DSP_IOCTL_REGIOW			43
-#define OMAP_DSP_IOCTL_GETVAR			44
-#define OMAP_DSP_IOCTL_SETVAR			45
-#define OMAP_DSP_IOCTL_RUNLEVEL			50
-#define OMAP_DSP_IOCTL_SUSPEND			51
-#define OMAP_DSP_IOCTL_RESUME			52
-#define OMAP_DSP_IOCTL_FBEN			53
-#define OMAP_DSP_IOCTL_FBDIS			54
-#define OMAP_DSP_IOCTL_MBSEND			99
-
-/*
- * for taskdev
- * (ioctls below should be >= 0x10000)
- */
-#define OMAP_DSP_TASK_IOCTL_BFLSH	0x10000
-#define OMAP_DSP_TASK_IOCTL_SETBSZ	0x10001
-#define OMAP_DSP_TASK_IOCTL_LOCK	0x10002
-#define OMAP_DSP_TASK_IOCTL_UNLOCK	0x10003
-#define OMAP_DSP_TASK_IOCTL_GETNAME	0x10004
-
-/*
- * for /dev/dspctl/mem
- */
-#define OMAP_DSP_MEM_IOCTL_EXMAP	1
-#define OMAP_DSP_MEM_IOCTL_EXUNMAP	2
-#define OMAP_DSP_MEM_IOCTL_EXMAP_FLUSH	3
-#define OMAP_DSP_MEM_IOCTL_FBEXPORT	5
-#define OMAP_DSP_MEM_IOCTL_MMUITACK	7
-#define OMAP_DSP_MEM_IOCTL_MMUINIT	9
-#define OMAP_DSP_MEM_IOCTL_KMEM_RESERVE	11
-#define OMAP_DSP_MEM_IOCTL_KMEM_RELEASE	12
-
-struct omap_dsp_mapinfo {
-	unsigned long dspadr;
-	unsigned long size;
-};
-
-/*
- * for /dev/dspctl/twch
- */
-#define OMAP_DSP_TWCH_IOCTL_MKDEV	1
-#define OMAP_DSP_TWCH_IOCTL_RMDEV	2
-#define OMAP_DSP_TWCH_IOCTL_TADD	11
-#define OMAP_DSP_TWCH_IOCTL_TDEL	12
-#define OMAP_DSP_TWCH_IOCTL_TKILL	13
-
-#define OMAP_DSP_DEVSTATE_NOTASK	0x00000001
-#define OMAP_DSP_DEVSTATE_ATTACHED	0x00000002
-#define OMAP_DSP_DEVSTATE_GARBAGE	0x00000004
-#define OMAP_DSP_DEVSTATE_INVALID	0x00000008
-#define OMAP_DSP_DEVSTATE_ADDREQ	0x00000100
-#define OMAP_DSP_DEVSTATE_DELREQ	0x00000200
-#define OMAP_DSP_DEVSTATE_ADDFAIL	0x00001000
-#define OMAP_DSP_DEVSTATE_ADDING	0x00010000
-#define OMAP_DSP_DEVSTATE_DELING	0x00020000
-#define OMAP_DSP_DEVSTATE_KILLING	0x00040000
-#define OMAP_DSP_DEVSTATE_STATE_MASK	0x7fffffff
-#define OMAP_DSP_DEVSTATE_STALE		0x80000000
-
-struct omap_dsp_taddinfo {
-	unsigned char minor;
-	unsigned long taskadr;
-};
-#define OMAP_DSP_TADD_ABORTADR	0xffffffff
-
-
-/*
- * error cause definition (for error detection device)
- */
-#define OMAP_DSP_ERRDT_WDT	0x00000001
-#define OMAP_DSP_ERRDT_MMU	0x00000002
-
-
-/*
- * mailbox protocol definitions
- */
-
-struct omap_dsp_mailbox_cmd {
-	unsigned short cmd;
-	unsigned short data;
-};
-
-struct omap_dsp_reginfo {
-	unsigned short adr;
-	unsigned short val;
-};
-
-struct omap_dsp_varinfo {
-	unsigned char varid;
-	unsigned short val[0];
-};
-
-#define OMAP_DSP_MBPROT_REVISION	0x0019
-
-#define OMAP_DSP_MBCMD_WDSND	0x10
-#define OMAP_DSP_MBCMD_WDREQ	0x11
-#define OMAP_DSP_MBCMD_BKSND	0x20
-#define OMAP_DSP_MBCMD_BKREQ	0x21
-#define OMAP_DSP_MBCMD_BKYLD	0x23
-#define OMAP_DSP_MBCMD_BKSNDP	0x24
-#define OMAP_DSP_MBCMD_BKREQP	0x25
-#define OMAP_DSP_MBCMD_TCTL	0x30
-#define OMAP_DSP_MBCMD_TCTLDATA	0x31
-#define OMAP_DSP_MBCMD_POLL	0x32
-#define OMAP_DSP_MBCMD_WDT	0x50	/* v3.3: obsolete */
-#define OMAP_DSP_MBCMD_RUNLEVEL	0x51
-#define OMAP_DSP_MBCMD_PM	0x52
-#define OMAP_DSP_MBCMD_SUSPEND	0x53
-#define OMAP_DSP_MBCMD_KFUNC	0x54
-#define OMAP_DSP_MBCMD_TCFG	0x60
-#define OMAP_DSP_MBCMD_TADD	0x62
-#define OMAP_DSP_MBCMD_TDEL	0x63
-#define OMAP_DSP_MBCMD_TSTOP	0x65
-#define OMAP_DSP_MBCMD_DSPCFG	0x70
-#define OMAP_DSP_MBCMD_REGRW	0x72
-#define OMAP_DSP_MBCMD_GETVAR	0x74
-#define OMAP_DSP_MBCMD_SETVAR	0x75
-#define OMAP_DSP_MBCMD_ERR	0x78
-#define OMAP_DSP_MBCMD_DBG	0x79
-
-#define OMAP_DSP_MBCMD_TCTL_TINIT	0x0000
-#define OMAP_DSP_MBCMD_TCTL_TEN		0x0001
-#define OMAP_DSP_MBCMD_TCTL_TDIS	0x0002
-#define OMAP_DSP_MBCMD_TCTL_TCLR	0x0003
-#define OMAP_DSP_MBCMD_TCTL_TCLR_FORCE	0x0004
-
-#define OMAP_DSP_MBCMD_RUNLEVEL_USER		0x01
-#define OMAP_DSP_MBCMD_RUNLEVEL_SUPER		0x0e
-#define OMAP_DSP_MBCMD_RUNLEVEL_RECOVERY	0x10
-
-#define OMAP_DSP_MBCMD_PM_DISABLE	0x00
-#define OMAP_DSP_MBCMD_PM_ENABLE	0x01
-
-#define OMAP_DSP_MBCMD_KFUNC_FBCTL	0x00
-#define OMAP_DSP_MBCMD_KFUNC_AUDIO_PWR	0x01
-
-#define OMAP_DSP_MBCMD_FBCTL_UPD	0x0000
-#define OMAP_DSP_MBCMD_FBCTL_ENABLE	0x0002
-#define OMAP_DSP_MBCMD_FBCTL_DISABLE	0x0003
-
-#define OMAP_DSP_MBCMD_AUDIO_PWR_UP	0x0000
-#define OMAP_DSP_MBCMD_AUDIO_PWR_DOWN1	0x0001
-#define OMAP_DSP_MBCMD_AUDIO_PWR_DOWN2	0x0002
-
-#define OMAP_DSP_MBCMD_TDEL_SAFE	0x0000
-#define OMAP_DSP_MBCMD_TDEL_KILL	0x0001
-
-#define OMAP_DSP_MBCMD_DSPCFG_REQ	0x00
-#define OMAP_DSP_MBCMD_DSPCFG_SYSADRH	0x28
-#define OMAP_DSP_MBCMD_DSPCFG_SYSADRL	0x29
-#define OMAP_DSP_MBCMD_DSPCFG_PROTREV	0x70
-#define OMAP_DSP_MBCMD_DSPCFG_ABORT	0x78
-#define OMAP_DSP_MBCMD_DSPCFG_LAST	0x80
-
-#define OMAP_DSP_MBCMD_REGRW_MEMR	0x00
-#define OMAP_DSP_MBCMD_REGRW_MEMW	0x01
-#define OMAP_DSP_MBCMD_REGRW_IOR	0x02
-#define OMAP_DSP_MBCMD_REGRW_IOW	0x03
-#define OMAP_DSP_MBCMD_REGRW_DATA	0x04
-
-#define OMAP_DSP_MBCMD_VARID_ICRMASK	0x00
-#define OMAP_DSP_MBCMD_VARID_LOADINFO	0x01
-
-#define OMAP_DSP_TTYP_ARCV	0x0001
-#define OMAP_DSP_TTYP_ASND	0x0002
-#define OMAP_DSP_TTYP_BKMD	0x0004
-#define OMAP_DSP_TTYP_BKDM	0x0008
-#define OMAP_DSP_TTYP_PVMD	0x0010
-#define OMAP_DSP_TTYP_PVDM	0x0020
-
-#define OMAP_DSP_EID_BADTID	0x10
-#define OMAP_DSP_EID_BADTCN	0x11
-#define OMAP_DSP_EID_BADBID	0x20
-#define OMAP_DSP_EID_BADCNT	0x21
-#define OMAP_DSP_EID_NOTLOCKED	0x22
-#define OMAP_DSP_EID_STVBUF	0x23
-#define OMAP_DSP_EID_BADADR	0x24
-#define OMAP_DSP_EID_BADTCTL	0x30
-#define OMAP_DSP_EID_BADPARAM	0x50
-#define OMAP_DSP_EID_FATAL	0x58
-#define OMAP_DSP_EID_NOMEM	0xc0
-#define OMAP_DSP_EID_NORES	0xc1
-#define OMAP_DSP_EID_IPBFULL	0xc2
-#define OMAP_DSP_EID_WDT	0xd0
-#define OMAP_DSP_EID_TASKNOTRDY	0xe0
-#define OMAP_DSP_EID_TASKBSY	0xe1
-#define OMAP_DSP_EID_TASKERR	0xef
-#define OMAP_DSP_EID_BADCFGTYP	0xf0
-#define OMAP_DSP_EID_DEBUG	0xf8
-#define OMAP_DSP_EID_BADSEQ	0xfe
-#define OMAP_DSP_EID_BADCMD	0xff
-
-#define OMAP_DSP_TNM_LEN	16
-
-#define OMAP_DSP_TID_FREE	0xff
-#define OMAP_DSP_TID_ANON	0xfe
-
-#define OMAP_DSP_BID_NULL	0xffff
-#define OMAP_DSP_BID_PVT	0xfffe
-
-#endif /* ASM_ARCH_DSP_H */
Index: linux-2.6/include/asm-arm/arch-omap/dsp_common.h
===================================================================
--- linux-2.6.orig/include/asm-arm/arch-omap/dsp_common.h	2007-04-06 09:00:28.000000000 -0400
+++ linux-2.6/include/asm-arm/arch-omap/dsp_common.h	2007-04-09 14:22:43.000000000 -0400
@@ -1,38 +1,34 @@
 /*
- * linux/include/asm-arm/arch-omap/dsp_common.h
+ * This file is part of OMAP DSP driver (DSP Gateway version 3.3.1)
  *
- * Header for OMAP DSP subsystem control
+ * Copyright (C) 2004-2006 Nokia Corporation. All rights reserved.
  *
- * Copyright (C) 2004,2005 Nokia Corporation
+ * Contact: Toshihiro Kobayashi <toshihiro.kobayashi@nokia.com>
  *
- * Written by Toshihiro Kobayashi <toshihiro.kobayashi@nokia.com>
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
- * GNU General Public License for more details.
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
  *
- * 2005/06/03:  DSP Gateway version 3.3
  */
 
 #ifndef ASM_ARCH_DSP_COMMON_H
 #define ASM_ARCH_DSP_COMMON_H
 
+#ifdef CONFIG_ARCH_OMAP1
 extern void omap_dsp_request_mpui(void);
 extern void omap_dsp_release_mpui(void);
 extern int omap_dsp_request_mem(void);
 extern int omap_dsp_release_mem(void);
-
-extern void (*omap_dsp_audio_pwr_up_request)(int stage);
-extern void (*omap_dsp_audio_pwr_down_request)(int stage);
+#endif
 
 #endif /* ASM_ARCH_DSP_COMMON_H */
Index: linux-2.6/include/asm-arm/arch-omap/gpio-switch.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/include/asm-arm/arch-omap/gpio-switch.h	2007-04-09 14:22:43.000000000 -0400
@@ -0,0 +1,54 @@
+/*
+ * GPIO switch definitions
+ *
+ * Copyright (C) 2006 Nokia Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_ARCH_OMAP_GPIO_SWITCH_H
+#define __ASM_ARCH_OMAP_GPIO_SWITCH_H
+
+#include <linux/types.h>
+
+/* Cover:
+ *	high -> closed
+ *	low  -> open
+ * Connection:
+ *	high -> connected
+ *	low  -> disconnected
+ * Activity:
+ *	high -> active
+ *	low  -> inactive
+ *
+ */
+#define OMAP_GPIO_SWITCH_TYPE_COVER		0x0000
+#define OMAP_GPIO_SWITCH_TYPE_CONNECTION	0x0001
+#define OMAP_GPIO_SWITCH_TYPE_ACTIVITY		0x0002
+#define OMAP_GPIO_SWITCH_FLAG_INVERTED		0x0001
+#define OMAP_GPIO_SWITCH_FLAG_OUTPUT		0x0002
+
+struct omap_gpio_switch {
+	const char *name;
+	s16 gpio;
+	unsigned flags:4;
+	unsigned type:4;
+
+	/* Time in ms to debounce when transitioning from
+	 * inactive state to active state. */
+	u16 debounce_rising;
+	/* Same for transition from active to inactive state. */
+	u16 debounce_falling;
+
+	/* notify board-specific code about state changes */
+	void (* notify)(void *data, int state);
+	void *notify_data;
+};
+
+/* Call at init time only */
+extern void omap_register_gpio_switches(const struct omap_gpio_switch *tbl,
+					int count);
+
+#endif
Index: linux-2.6/include/asm-arm/arch-omap/gpmc.h
===================================================================
--- linux-2.6.orig/include/asm-arm/arch-omap/gpmc.h	2007-04-06 09:00:28.000000000 -0400
+++ linux-2.6/include/asm-arm/arch-omap/gpmc.h	2007-04-09 14:22:43.000000000 -0400
@@ -87,5 +87,7 @@ extern int gpmc_cs_calc_divider(int cs, 
 extern int gpmc_cs_set_timings(int cs, const struct gpmc_timings *t);
 extern int gpmc_cs_request(int cs, unsigned long size, unsigned long *base);
 extern void gpmc_cs_free(int cs);
+extern void gpmc_cs_set_reserved(int cs, int reserved);
+extern int gpmc_cs_reserved(int cs);
 
 #endif
Index: linux-2.6/include/asm-arm/arch-omap/hardware.h
===================================================================
--- linux-2.6.orig/include/asm-arm/arch-omap/hardware.h	2007-04-06 09:00:28.000000000 -0400
+++ linux-2.6/include/asm-arm/arch-omap/hardware.h	2007-04-09 14:22:43.000000000 -0400
@@ -267,6 +267,15 @@
 #define OMAP_LPG2_PMR			(OMAP_LPG2_BASE + 0x04)
 
 /*
+ * ----------------------------------------------------------------------------
+ * Pulse-Width Light
+ * ----------------------------------------------------------------------------
+ */
+#define OMAP_PWL_BASE			0xfffb5800
+#define OMAP_PWL_ENABLE			(OMAP_PWL_BASE + 0x00)
+#define OMAP_PWL_CLK_ENABLE		(OMAP_PWL_BASE + 0x04)
+
+/*
  * ---------------------------------------------------------------------------
  * Processor specific defines
  * ---------------------------------------------------------------------------
Index: linux-2.6/include/asm-arm/arch-omap/io.h
===================================================================
--- linux-2.6.orig/include/asm-arm/arch-omap/io.h	2007-04-06 09:00:28.000000000 -0400
+++ linux-2.6/include/asm-arm/arch-omap/io.h	2007-04-09 14:22:43.000000000 -0400
@@ -77,6 +77,17 @@
 #define io_p2v(pa)	((pa) + IO_OFFSET)	/* Works for L3 and L4 */
 #define io_v2p(va)	((va) - IO_OFFSET)	/* Works for L3 and L4 */
 
+/* DSP */
+#define DSP_MEM_24XX_PHYS	OMAP24XX_DSP_MEM_BASE	/* 0x58000000 */
+#define DSP_MEM_24XX_VIRT	0xe0000000
+#define DSP_MEM_24XX_SIZE	0x28000
+#define DSP_IPI_24XX_PHYS	OMAP24XX_DSP_IPI_BASE	/* 0x59000000 */
+#define DSP_IPI_24XX_VIRT	0xe1000000
+#define DSP_IPI_24XX_SIZE	SZ_4K
+#define DSP_MMU_24XX_PHYS	OMAP24XX_DSP_MMU_BASE	/* 0x5a000000 */
+#define DSP_MMU_24XX_VIRT	0xe2000000
+#define DSP_MMU_24XX_SIZE	SZ_4K
+
 #endif
 
 #ifndef __ASSEMBLER__
Index: linux-2.6/include/asm-arm/arch-omap/irqs.h
===================================================================
--- linux-2.6.orig/include/asm-arm/arch-omap/irqs.h	2007-04-06 09:00:28.000000000 -0400
+++ linux-2.6/include/asm-arm/arch-omap/irqs.h	2007-04-09 14:22:43.000000000 -0400
@@ -37,8 +37,6 @@
 #define INT_DSP_MMU_ABORT	7
 #define INT_HOST		8
 #define INT_ABORT		9
-#define INT_DSP_MAILBOX1	10
-#define INT_DSP_MAILBOX2	11
 #define INT_BRIDGE_PRIV		13
 #define INT_GPIO_BANK1		14
 #define INT_UART3		15
@@ -63,6 +61,8 @@
 #define INT_1510_RES2		2
 #define INT_1510_SPI_TX		4
 #define INT_1510_SPI_RX		5
+#define INT_1510_DSP_MAILBOX1	10
+#define INT_1510_DSP_MAILBOX2	11
 #define INT_1510_RES12		12
 #define INT_1510_LB_MMU		17
 #define INT_1510_RES18		18
@@ -75,6 +75,8 @@
 #define INT_1610_IH2_FIQ	2
 #define INT_1610_McBSP2_TX	4
 #define INT_1610_McBSP2_RX	5
+#define INT_1610_DSP_MAILBOX1	10
+#define INT_1610_DSP_MAILBOX2	11
 #define INT_1610_LCD_LINE	12
 #define INT_1610_GPTIMER1	17
 #define INT_1610_GPTIMER2	18
@@ -131,11 +133,11 @@
 #define INT_RTC_TIMER		(25 + IH2_BASE)
 #define INT_RTC_ALARM		(26 + IH2_BASE)
 #define INT_MEM_STICK		(27 + IH2_BASE)
-#define INT_DSP_MMU		(28 + IH2_BASE)
 
 /*
  * OMAP-1510 specific IRQ numbers for interrupt handler 2
  */
+#define INT_1510_DSP_MMU	(28 + IH2_BASE)
 #define INT_1510_COM_SPI_RO	(31 + IH2_BASE)
 
 /*
@@ -146,6 +148,7 @@
 #define INT_1610_USB_OTG	(8 + IH2_BASE)
 #define INT_1610_SoSSI		(9 + IH2_BASE)
 #define INT_1610_SoSSI_MATCH	(19 + IH2_BASE)
+#define INT_1610_DSP_MMU	(28 + IH2_BASE)
 #define INT_1610_McBSP2RX_OF	(31 + IH2_BASE)
 #define INT_1610_STI		(32 + IH2_BASE)
 #define INT_1610_STI_WAKEUP	(33 + IH2_BASE)
@@ -239,10 +242,15 @@
 #define INT_24XX_SDMA_IRQ3	15
 #define INT_24XX_CAM_IRQ	24
 #define INT_24XX_DSS_IRQ	25
+#define INT_24XX_MAIL_U0_MPU	26
+#define INT_24XX_DSP_UMA	27
+#define INT_24XX_DSP_MMU	28
 #define INT_24XX_GPIO_BANK1	29
 #define INT_24XX_GPIO_BANK2	30
 #define INT_24XX_GPIO_BANK3	31
 #define INT_24XX_GPIO_BANK4	32
+#define INT_24XX_GPIO_BANK5	33
+#define INT_24XX_MAIL_U3_MPU	34
 #define INT_24XX_GPTIMER1	37
 #define INT_24XX_GPTIMER2	38
 #define INT_24XX_GPTIMER3	39
@@ -262,6 +270,12 @@
 #define INT_24XX_UART1_IRQ	72
 #define INT_24XX_UART2_IRQ	73
 #define INT_24XX_UART3_IRQ	74
+#define INT_24XX_USB_IRQ_GEN	75
+#define INT_24XX_USB_IRQ_NISO	76
+#define INT_24XX_USB_IRQ_ISO	77
+#define INT_24XX_USB_IRQ_HGEN	78
+#define INT_24XX_USB_IRQ_HSOF	79
+#define INT_24XX_USB_IRQ_OTG	80
 #define INT_24XX_MMC_IRQ	83
 
 /* Max. 128 level 2 IRQs (OMAP1610), 192 GPIOs (OMAP730) and
Index: linux-2.6/include/asm-arm/arch-omap/lcd_lph8923.h
===================================================================
--- linux-2.6.orig/include/asm-arm/arch-omap/lcd_lph8923.h	2007-04-06 09:00:28.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,14 +0,0 @@
-#ifndef __LCD_LPH8923_H
-#define __LCD_LPH8923_H
-
-enum lcd_lph8923_test_num {
-	LCD_LPH8923_TEST_RGB_LINES,
-};
-
-enum lcd_lph8923_test_result {
-	LCD_LPH8923_TEST_SUCCESS,
-	LCD_LPH8923_TEST_INVALID,
-	LCD_LPH8923_TEST_FAILED,
-};
-
-#endif
Index: linux-2.6/include/asm-arm/arch-omap/lcd_mipid.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/include/asm-arm/arch-omap/lcd_mipid.h	2007-04-09 14:22:43.000000000 -0400
@@ -0,0 +1,24 @@
+#ifndef __LCD_MIPID_H
+#define __LCD_MIPID_H
+
+enum mipid_test_num {
+	MIPID_TEST_RGB_LINES,
+};
+
+enum mipid_test_result {
+	MIPID_TEST_SUCCESS,
+	MIPID_TEST_INVALID,
+	MIPID_TEST_FAILED,
+};
+
+#ifdef __KERNEL__
+
+struct mipid_platform_data {
+	int	nreset_gpio;
+	int	data_lines;
+	void	(*shutdown)(struct mipid_platform_data *pdata);
+};
+
+#endif
+
+#endif
Index: linux-2.6/include/asm-arm/arch-omap/led.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/include/asm-arm/arch-omap/led.h	2007-04-09 14:22:43.000000000 -0400
@@ -0,0 +1,24 @@
+/*
+ *  linux/include/asm-arm/arch-omap/led.h
+ *
+ *  Copyright (C) 2006 Samsung Electronics
+ *  Kyungmin Park <kyungmin.park@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef ASMARM_ARCH_LED_H
+#define ASMARM_ARCH_LED_H
+
+struct omap_led_config {
+	struct led_classdev	cdev;
+	s16			gpio;
+};
+
+struct omap_led_platform_data {
+	s16			nr_leds;
+	struct omap_led_config	*leds;
+};
+
+#endif
Index: linux-2.6/include/asm-arm/arch-omap/mcspi.h
===================================================================
--- linux-2.6.orig/include/asm-arm/arch-omap/mcspi.h	2007-04-06 09:00:28.000000000 -0400
+++ linux-2.6/include/asm-arm/arch-omap/mcspi.h	2007-04-09 14:22:43.000000000 -0400
@@ -2,7 +2,6 @@
 #define _OMAP2_MCSPI_H
 
 struct omap2_mcspi_platform_config {
-	unsigned long	base;
 	unsigned short	num_cs;
 };
 
Index: linux-2.6/include/asm-arm/arch-omap/memory.h
===================================================================
--- linux-2.6.orig/include/asm-arm/arch-omap/memory.h	2007-04-06 09:00:28.000000000 -0400
+++ linux-2.6/include/asm-arm/arch-omap/memory.h	2007-04-09 14:22:43.000000000 -0400
@@ -86,5 +86,18 @@
 
 #endif	/* CONFIG_ARCH_OMAP15XX */
 
+/* Override the ARM default */
+#ifdef CONFIG_FB_OMAP_CONSISTENT_DMA_SIZE
+
+#if (CONFIG_FB_OMAP_CONSISTENT_DMA_SIZE == 0)
+#undef CONFIG_FB_OMAP_CONSISTENT_DMA_SIZE
+#define CONFIG_FB_OMAP_CONSISTENT_DMA_SIZE 2
+#endif
+
+#define CONSISTENT_DMA_SIZE \
+	(((CONFIG_FB_OMAP_CONSISTENT_DMA_SIZE + 1) & ~1) * 1024 * 1024)
+
+#endif
+
 #endif
 
Index: linux-2.6/include/asm-arm/arch-omap/menelaus.h
===================================================================
--- linux-2.6.orig/include/asm-arm/arch-omap/menelaus.h	2007-04-06 09:00:28.000000000 -0400
+++ linux-2.6/include/asm-arm/arch-omap/menelaus.h	2007-04-09 14:22:43.000000000 -0400
@@ -7,10 +7,19 @@
 #ifndef __ASM_ARCH_MENELAUS_H
 #define __ASM_ARCH_MENELAUS_H
 
-extern void menelaus_mmc_register(void (*callback)(unsigned long data, u8 card_mask),
-				  unsigned long data);
-extern void menelaus_mmc_remove(void);
-extern void menelaus_mmc_opendrain(int enable);
+extern int menelaus_register_mmc_callback(void (*callback)(void *data, u8 card_mask),
+					  void *data);
+extern void menelaus_unregister_mmc_callback(void);
+extern int menelaus_set_mmc_opendrain(int slot, int enable);
+extern int menelaus_set_mmc_slot(int slot, int enable, int power, int cd_on);
+
+extern int menelaus_set_vmem(unsigned int mV);
+extern int menelaus_set_vio(unsigned int mV);
+extern int menelaus_set_vmmc(unsigned int mV);
+extern int menelaus_set_vaux(unsigned int mV);
+extern int menelaus_set_vdcdc(int dcdc, unsigned int mV);
+extern int menelaus_set_slot_sel(int enable);
+extern int menelaus_get_slot_pin_states(void);
 
 #if defined(CONFIG_ARCH_OMAP24XX) && defined(CONFIG_MENELAUS)
 #define omap_has_menelaus()	1
Index: linux-2.6/include/asm-arm/arch-omap/omap16xx.h
===================================================================
--- linux-2.6.orig/include/asm-arm/arch-omap/omap16xx.h	2007-04-06 09:00:28.000000000 -0400
+++ linux-2.6/include/asm-arm/arch-omap/omap16xx.h	2007-04-09 14:22:43.000000000 -0400
@@ -159,15 +159,6 @@
 #define UART3_MVR               (OMAP_UART3_BASE + 0x50)
 
 /*
- * ----------------------------------------------------------------------------
- * Pulse-Width Light
- * ----------------------------------------------------------------------------
- */
-#define OMAP16XX_PWL_BASE	(0xfffb5800)
-#define OMAP16XX_PWL_ENABLE	(OMAP16XX_PWL_BASE + 0x00)
-#define OMAP16XX_PWL_CLK_ENABLE	(OMAP16XX_PWL_BASE + 0x04)
-
-/*
  * ---------------------------------------------------------------------------
  * Watchdog timer
  * ---------------------------------------------------------------------------
@@ -199,5 +190,8 @@
 #define WSPR_DISABLE_0         (0x0000aaaa)
 #define WSPR_DISABLE_1         (0x00005555)
 
+/* Mailbox */
+#define OMAP16XX_MAILBOX_BASE	(0xfffcf000)
+
 #endif /*  __ASM_ARCH_OMAP16XX_H */
 
Index: linux-2.6/include/asm-arm/arch-omap/omap24xx.h
===================================================================
--- linux-2.6.orig/include/asm-arm/arch-omap/omap24xx.h	2007-04-06 09:00:28.000000000 -0400
+++ linux-2.6/include/asm-arm/arch-omap/omap24xx.h	2007-04-09 14:22:43.000000000 -0400
@@ -20,5 +20,14 @@
 #define OMAP24XX_PRCM_BASE	(L4_24XX_BASE + 0x8000)
 #define OMAP24XX_SDRC_BASE	(L3_24XX_BASE + 0x9000)
 
+/* DSP SS */
+#define OMAP24XX_DSP_BASE	0x58000000
+#define OMAP24XX_DSP_MEM_BASE	(OMAP24XX_DSP_BASE + 0x0)
+#define OMAP24XX_DSP_IPI_BASE	(OMAP24XX_DSP_BASE + 0x1000000)
+#define OMAP24XX_DSP_MMU_BASE	(OMAP24XX_DSP_BASE + 0x2000000)
+
+/* Mailbox */
+#define OMAP24XX_MAILBOX_BASE	(L4_24XX_BASE + 0x94000)
+
 #endif /* __ASM_ARCH_OMAP24XX_H */
 
Index: linux-2.6/include/asm-arm/arch-omap/omapfb.h
===================================================================
--- linux-2.6.orig/include/asm-arm/arch-omap/omapfb.h	2007-04-09 14:18:58.000000000 -0400
+++ linux-2.6/include/asm-arm/arch-omap/omapfb.h	2007-04-09 14:22:43.000000000 -0400
@@ -24,6 +24,9 @@
 #ifndef __OMAPFB_H
 #define __OMAPFB_H
 
+#include <asm/ioctl.h>
+#include <asm/types.h>
+
 /* IOCTL commands. */
 
 #define OMAP_IOW(num, dtype)	_IOW('O', num, dtype)
@@ -36,14 +39,14 @@
 #define OMAPFB_VSYNC		OMAP_IO(38)
 #define OMAPFB_SET_UPDATE_MODE	OMAP_IOW(40, int)
 #define OMAPFB_UPDATE_WINDOW_OLD OMAP_IOW(41, struct omapfb_update_window_old)
-#define OMAPFB_GET_CAPS		OMAP_IOR(42, unsigned long)
 #define OMAPFB_GET_UPDATE_MODE	OMAP_IOW(43, int)
 #define OMAPFB_LCD_TEST		OMAP_IOW(45, int)
 #define OMAPFB_CTRL_TEST	OMAP_IOW(46, int)
 #define OMAPFB_UPDATE_WINDOW	OMAP_IOW(47, struct omapfb_update_window)
-#define OMAPFB_SETUP_PLANE	OMAP_IOW(48, struct omapfb_setup_plane)
-#define OMAPFB_ENABLE_PLANE	OMAP_IOW(49, struct omapfb_enable_plane)
 #define OMAPFB_SET_COLOR_KEY	OMAP_IOW(50, struct omapfb_color_key)
+#define OMAPFB_GET_COLOR_KEY	OMAP_IOW(51, struct omapfb_color_key)
+#define OMAPFB_SETUP_PLANE	OMAP_IOW(52, struct omapfb_plane_info)
+#define OMAPFB_QUERY_PLANE	OMAP_IOW(53, struct omapfb_plane_info)
 
 #define OMAPFB_CAPS_GENERIC_MASK	0x00000fff
 #define OMAPFB_CAPS_LCDC_MASK		0x00fff000
@@ -56,6 +59,9 @@
 #define OMAPFB_FORMAT_MASK         0x00ff
 #define OMAPFB_FORMAT_FLAG_DOUBLE  0x0100
 
+#define OMAPFB_EVENT_READY	1
+#define OMAPFB_EVENT_DISABLED	2
+
 enum omapfb_color_format {
 	OMAPFB_COLOR_RGB565 = 0,
 	OMAPFB_COLOR_YUV422,
@@ -64,6 +70,8 @@ enum omapfb_color_format {
 	OMAPFB_COLOR_CLUT_4BPP,
 	OMAPFB_COLOR_CLUT_2BPP,
 	OMAPFB_COLOR_CLUT_1BPP,
+	OMAPFB_COLOR_RGB444,
+	OMAPFB_COLOR_YUY422,
 };
 
 struct omapfb_update_window {
@@ -88,18 +96,16 @@ enum omapfb_channel_out {
 	OMAPFB_CHANNEL_OUT_DIGIT,
 };
 
-struct omapfb_setup_plane {
-	__u8  plane;
+struct omapfb_plane_info {
+	__u32 pos_x;
+	__u32 pos_y;
+	__u8  enabled;
 	__u8  channel_out;
-	__u32 offset;
-	__u32 pos_x, pos_y;
-	__u32 width, height;
-	__u32 color_mode;
-};
-
-struct omapfb_enable_plane {
-	__u8  plane;
-	__u8  enable;
+	__u8  mirror;
+	__u8  reserved1;
+	__u32 out_width;
+	__u32 out_height;
+	__u32 reserved2[12];
 };
 
 enum omapfb_color_key_type {
@@ -141,6 +147,9 @@ enum omapfb_update_mode {
 
 #define OMAP_LCDC_PANEL_TFT		0x0100
 
+#define OMAPFB_PLANE_XRES_MIN		8
+#define OMAPFB_PLANE_YRES_MIN		8
+
 #ifdef CONFIG_ARCH_OMAP1
 #define OMAPFB_PLANE_NUM		1
 #else
@@ -169,15 +178,17 @@ struct lcd_panel {
 	int		pcd;		/* pixel clock divider.
 					   Obsolete use pixel_clock instead */
 
-	int		(*init)		(struct omapfb_device *fbdev);
-	void		(*cleanup)	(void);
-	int		(*enable)	(void);
-	void		(*disable)	(void);
-	unsigned long	(*get_caps)	(void);
-	int		(*set_bklight_level)(unsigned int level);
-	unsigned int	(*get_bklight_level)(void);
-	unsigned int	(*get_bklight_max)  (void);
-	int		(*run_test)	(int test_num);
+	int		(*init)		(struct lcd_panel *panel,
+					 struct omapfb_device *fbdev);
+	void		(*cleanup)	(struct lcd_panel *panel);
+	int		(*enable)	(struct lcd_panel *panel);
+	void		(*disable)	(struct lcd_panel *panel);
+	unsigned long	(*get_caps)	(struct lcd_panel *panel);
+	int		(*set_bklight_level)(struct lcd_panel *panel,
+					     unsigned int level);
+	unsigned int	(*get_bklight_level)(struct lcd_panel *panel);
+	unsigned int	(*get_bklight_max)  (struct lcd_panel *panel);
+	int		(*run_test)	(struct lcd_panel *panel, int test_num);
 };
 
 struct omapfb_device;
@@ -202,7 +213,7 @@ struct extif_timings {
 };
 
 struct lcd_ctrl_extif {
-	int  (*init)		(void);
+	int  (*init)		(struct omapfb_device *fbdev);
 	void (*cleanup)		(void);
 	void (*get_clk_info)	(u32 *clk_period, u32 *max_clk_div);
 	int  (*convert_timings)	(struct extif_timings *timings);
@@ -213,30 +224,41 @@ struct lcd_ctrl_extif {
 	void (*write_data)	(const void *buf, unsigned int len);
 	void (*transfer_area)	(int width, int height,
 				 void (callback)(void * data), void *data);
+
 	unsigned long		max_transmit_size;
 };
 
 struct omapfb_notifier_block {
 	struct notifier_block	nb;
 	void			*data;
+	int			plane_idx;
 };
 
-typedef int (*omapfb_notifier_callback_t)(struct omapfb_notifier_block *,
-					   unsigned long event,
-					   struct omapfb_device *fbdev);
+typedef int (*omapfb_notifier_callback_t)(struct notifier_block *,
+					  unsigned long event,
+					  void *fbi);
+
+struct omapfb_mem_region {
+	dma_addr_t	paddr;
+	void		*vaddr;
+	unsigned long	size;
+	int		alloc:1;
+};
+
+struct omapfb_mem_desc {
+	int				region_cnt;
+	struct omapfb_mem_region	region[OMAPFB_PLANE_NUM];
+};
 
 struct lcd_ctrl {
 	const char	*name;
 	void		*data;
 
 	int		(*init)		  (struct omapfb_device *fbdev,
-					   int ext_mode, int req_vram_size);
+					   int ext_mode,
+					   struct omapfb_mem_desc *req_md);
 	void		(*cleanup)	  (void);
 	void		(*bind_client)	  (struct omapfb_notifier_block *nb);
-	void		(*get_vram_layout)(unsigned long *size,
-					   void **virt_base,
-					   dma_addr_t *phys_base);
-	int		(*mmap)		  (struct vm_area_struct *vma);
 	unsigned long	(*get_caps)	  (void);
 	int		(*set_update_mode)(enum omapfb_update_mode mode);
 	enum omapfb_update_mode (*get_update_mode)(void);
@@ -245,8 +267,12 @@ struct lcd_ctrl {
 					   int screen_width,
 					   int pos_x, int pos_y, int width,
 					   int height, int color_mode);
+	int		(*set_scale)	  (int plane,
+					   int orig_width, int orig_height,
+					   int out_width, int out_height);
 	int		(*enable_plane)	  (int plane, int enable);
-	int		(*update_window)  (struct omapfb_update_window *win,
+	int		(*update_window)  (struct fb_info *fbi,
+					   struct omapfb_update_window *win,
 					   void (*callback)(void *),
 					   void *callback_data);
 	void		(*sync)		  (void);
@@ -257,6 +283,7 @@ struct lcd_ctrl {
 					   u16 blue, u16 transp,
 					   int update_hw_mem);
 	int		(*set_color_key)  (struct omapfb_color_key *ck);
+	int		(*get_color_key)  (struct omapfb_color_key *ck);
 
 };
 
@@ -266,19 +293,20 @@ enum omapfb_state {
 	OMAPFB_ACTIVE	= 100
 };
 
+struct omapfb_plane_struct {
+	int				idx;
+	struct omapfb_plane_info	info;
+	enum omapfb_color_format	color_mode;
+	struct omapfb_device		*fbdev;
+};
+
 struct omapfb_device {
 	int			state;
 	int                     ext_lcdc;               /* Using external
                                                            LCD controller */
 	struct mutex		rqueue_mutex;
 
-	void			*vram_virt_base;
-	dma_addr_t		vram_phys_base;
-	unsigned long		vram_size;
-
-	int			color_mode;
 	int			palette_size;
-	int			mirror;
 	u32			pseudo_palette[17];
 
 	struct lcd_panel	*panel;			/* LCD panel */
@@ -286,20 +314,18 @@ struct omapfb_device {
 	struct lcd_ctrl		*int_ctrl;		/* internal LCD ctrl */
 	struct lcd_ctrl_extif	*ext_if;		/* LCD ctrl external
 							   interface */
-	struct fb_info		*fb_info;
-
 	struct device		*dev;
+
+	struct omapfb_mem_desc		mem_desc;
+	struct fb_info			*fb_info[OMAPFB_PLANE_NUM];
 };
 
 struct omapfb_platform_data {
-	struct omap_lcd_config	lcd;
-	struct omapfb_mem_desc	mem_desc;
-	void			*ctrl_platform_data;
+	struct omap_lcd_config		lcd;
+	struct omapfb_mem_desc		mem_desc;
+	void				*ctrl_platform_data;
 };
 
-#define OMAPFB_EVENT_READY	1
-#define OMAPFB_EVENT_DISABLED	2
-
 #ifdef CONFIG_ARCH_OMAP1
 extern struct lcd_ctrl omap1_lcd_ctrl;
 #else
@@ -311,12 +337,13 @@ extern void omapfb_write_first_pixel(str
 extern void omapfb_notify_clients(struct omapfb_device *fbdev,
 				  unsigned long event);
 extern int  omapfb_register_client(struct omapfb_notifier_block *nb,
-				    omapfb_notifier_callback_t callback,
-				    void *callback_data);
+				   omapfb_notifier_callback_t callback,
+				   void *callback_data);
 extern int  omapfb_unregister_client(struct omapfb_notifier_block *nb);
-extern int  omapfb_update_window_async(struct omapfb_update_window *win,
-					void (*callback)(void *),
-					void *callback_data);
+extern int  omapfb_update_window_async(struct fb_info *fbi,
+				       struct omapfb_update_window *win,
+				       void (*callback)(void *),
+				       void *callback_data);
 
 /* in arch/arm/plat-omap/fb.c */
 extern void omapfb_reserve_mem(void);
Index: linux-2.6/include/asm-arm/arch-omap/sram.h
===================================================================
--- linux-2.6.orig/include/asm-arm/arch-omap/sram.h	2007-04-06 09:00:28.000000000 -0400
+++ linux-2.6/include/asm-arm/arch-omap/sram.h	2007-04-09 14:22:43.000000000 -0400
@@ -20,8 +20,8 @@ extern void omap2_sram_reprogram_sdrc(u3
 				      u32 mem_type);
 extern u32 omap2_set_prcm(u32 dpll_ctrl_val, u32 sdrc_rfr_val, int bypass);
 
-extern unsigned long omap_fb_sram_start;
-extern unsigned long omap_fb_sram_size;
+extern int omap_fb_sram_plane;
+extern int omap_fb_sram_valid;
 
 /* Do not use these */
 extern void sram_reprogram_clock(u32 ckctl, u32 dpllctl);
Index: linux-2.6/include/asm-arm/arch-omap/usb.h
===================================================================
--- linux-2.6.orig/include/asm-arm/arch-omap/usb.h	2007-04-06 09:00:28.000000000 -0400
+++ linux-2.6/include/asm-arm/arch-omap/usb.h	2007-04-09 14:22:43.000000000 -0400
@@ -7,9 +7,27 @@
 
 /*-------------------------------------------------------------------------*/
 
-#define OTG_BASE			0xfffb0400
-#define UDC_BASE			0xfffb4000
-#define OMAP_OHCI_BASE			0xfffba000
+#define OMAP1_OTG_BASE			0xfffb0400
+#define OMAP1_UDC_BASE			0xfffb4000
+#define OMAP1_OHCI_BASE			0xfffba000
+
+#define OMAP2_OHCI_BASE			0x4805e000
+#define OMAP2_UDC_BASE			0x4805e200
+#define OMAP2_OTG_BASE			0x4805e300
+
+#ifdef CONFIG_ARCH_OMAP1
+
+#define OTG_BASE			OMAP1_OTG_BASE
+#define UDC_BASE			OMAP1_UDC_BASE
+#define OMAP_OHCI_BASE			OMAP1_OHCI_BASE
+
+#else
+
+#define OTG_BASE			OMAP2_OTG_BASE
+#define UDC_BASE			OMAP2_UDC_BASE
+#define OMAP_OHCI_BASE			OMAP2_OHCI_BASE
+
+#endif
 
 /*-------------------------------------------------------------------------*/
 
@@ -28,6 +46,7 @@
 #	define	 HST_IDLE_EN		(1 << 14)
 #	define	 DEV_IDLE_EN		(1 << 13)
 #	define	 OTG_RESET_DONE		(1 << 2)
+#	define	 OTG_SOFT_RESET		(1 << 1)
 #define OTG_SYSCON_2_REG		OTG_REG32(0x08)
 #	define	 OTG_EN			(1 << 31)
 #	define	 USBX_SYNCHRO		(1 << 30)
@@ -103,6 +122,7 @@
 
 /*-------------------------------------------------------------------------*/
 
+/* OMAP1 */
 #define	USB_TRANSCEIVER_CTRL_REG	__REG32(0xfffe1000 + 0x0064)
 #	define	CONF_USB2_UNI_R		(1 << 8)
 #	define	CONF_USB1_UNI_R		(1 << 7)
@@ -111,7 +131,17 @@
 #	define	CONF_USB_PWRDN_DM_R	(1 << 2)
 #	define	CONF_USB_PWRDN_DP_R	(1 << 1)
 
-
-
+/* OMAP2 */
+#define	CONTROL_DEVCONF_REG		__REG32(L4_24XX_BASE + 0x0274)
+#	define	USB_UNIDIR			0x0
+#	define	USB_UNIDIR_TLL			0x1
+#	define	USB_BIDIR			0x2
+#	define	USB_BIDIR_TLL			0x3
+#	define	USBT0WRMODEI(x)		((x) << 22)
+#	define	USBT1WRMODEI(x)		((x) << 20)
+#	define	USBT2WRMODEI(x)		((x) << 18)
+#	define	USBT2TLL5PI		(1 << 17)
+#	define	USB0PUENACTLOI		(1 << 16)
+#	define	USBSTANDBYCTRL		(1 << 15)
 
 #endif	/* __ASM_ARCH_OMAP_USB_H */
