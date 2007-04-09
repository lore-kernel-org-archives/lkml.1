Return-Path: <linux-kernel-owner+w=401wt.eu-S966019AbXDIVdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966019AbXDIVdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966046AbXDIVcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:32:45 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:33717 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966017AbXDIVcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:32:17 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Kai Svahn <kai.svahn@nokia.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 14/18] ARM: OMAP: Merge driver headers from N800 tree
Date: Mon,  9 Apr 2007 17:30:57 -0400
Message-Id: <1176154311389-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1176154308509-git-send-email-tony@atomide.com>
References: <1176154261668-git-send-email-tony@atomide.com> <11761542642563-git-send-email-tony@atomide.com> <11761542683139-git-send-email-tony@atomide.com> <11761542712251-git-send-email-tony@atomide.com> <11761542731458-git-send-email-tony@atomide.com> <1176154277435-git-send-email-tony@atomide.com> <11761542841909-git-send-email-tony@atomide.com> <1176154286590-git-send-email-tony@atomide.com> <11761542912185-git-send-email-tony@atomide.com> <1176154294883-git-send-email-tony@atomide.com> <11761542981742-git-send-email-tony@atomide.com> <1176154302614-git-send-email-tony@atomide.com> <11761543041751-git-send-email-tony@atomide.com> <1176154308509-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kai Svahn <kai.svahn@nokia.com>

This patch merges omap specific driver headers from
N800 tree.

Signed-off-by: Kai Svahn <kai.svahn@nokia.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 include/asm-arm/arch-omap/blizzard.h |   12 ++++
 include/asm-arm/arch-omap/eac.h      |  101 ++++++++++++++++++++++++++++++++++
 include/asm-arm/arch-omap/menelaus.h |   23 +++++++-
 include/asm-arm/arch-omap/mmc.h      |   67 ++++++++++++++++++++++
 include/asm-arm/arch-omap/onenand.h  |   19 ++++++
 5 files changed, 221 insertions(+), 1 deletions(-)

--- /dev/null
+++ b/include/asm-arm/arch-omap/blizzard.h
@@ -0,0 +1,12 @@
+#ifndef _BLIZZARD_H
+#define _BLIZZARD_H
+
+struct blizzard_platform_data {
+	void		(*power_up)(struct device *dev);
+	void		(*power_down)(struct device *dev);
+	unsigned long	(*get_clock_rate)(struct device *dev);
+
+	unsigned	te_connected : 1;
+};
+
+#endif
--- /dev/null
+++ b/include/asm-arm/arch-omap/eac.h
@@ -0,0 +1,101 @@
+/*
+ * linux/include/asm-arm/arch-omap2/eac.h
+ *
+ * Defines for Enhanced Audio Controller
+ *
+ * Contact: Jarkko Nikula <jarkko.nikula@nokia.com>
+ *
+ * Copyright (C) 2006 Nokia Corporation
+ * Copyright (C) 2004 Texas Instruments, Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __ASM_ARM_ARCH_OMAP2_EAC_H
+#define __ASM_ARM_ARCH_OMAP2_EAC_H
+
+#include <asm/arch/io.h>
+#include <asm/arch/hardware.h>
+#include <asm/irq.h>
+
+#include <sound/driver.h>
+#include <sound/core.h>
+
+/* master codec clock source */
+#define EAC_MCLK_EXT_MASK	0x100
+enum eac_mclk_src {
+	EAC_MCLK_INT_11290000, /* internal 96 MHz / 8.5 = 11.29 Mhz */
+	EAC_MCLK_EXT_11289600 = EAC_MCLK_EXT_MASK,
+	EAC_MCLK_EXT_12288000,
+	EAC_MCLK_EXT_2x11289600,
+	EAC_MCLK_EXT_2x12288000,
+};
+
+/* codec port interface mode */
+enum eac_codec_mode {
+	EAC_CODEC_PCM,
+	EAC_CODEC_AC97,
+	EAC_CODEC_I2S,
+};
+
+/* configuration structure for I2S mode */
+struct eac_i2s_conf {
+	/* it seems according to TRM that the polarity-changed I2S mode is not
+	 * only that frame sync polarity (EAC.AC_FS) is changed but also direction
+	 * of it and interface serial clock (EAC.AC_SCLK) */
+	unsigned	polarity_changed_mode:1;
+	/* if enabled, then serial data starts one clock cycle after the
+	 * of EAC.AC_FS for first audio slot */
+	unsigned	sync_delay_enable:1;
+};
+
+/* configuration structure for EAC codec port */
+struct eac_codec {
+	enum eac_mclk_src	mclk_src;
+
+	enum eac_codec_mode	codec_mode;
+	union {
+		struct eac_i2s_conf	i2s;
+	} codec_conf;
+
+	int		default_rate; /* audio sampling rate */
+
+	int		(* set_power)(void *private_data, int dac, int adc);
+	int		(* register_controls)(void *private_data,
+					      struct snd_card *card);
+	const char 	*short_name;
+
+	void		*private_data;
+};
+
+/* structure for passing platform dependent data to the EAC driver */
+struct eac_platform_data {
+        int	(* init)(struct device *eac_dev);
+	void	(* cleanup)(struct device *eac_dev);
+	/* these callbacks are used to configure & control external MCLK
+	 * source. NULL if not used */
+	int	(* enable_ext_clocks)(struct device *eac_dev);
+	void	(* disable_ext_clocks)(struct device *eac_dev);
+};
+
+extern void omap_init_eac(struct eac_platform_data *pdata);
+
+extern int eac_register_codec(struct device *eac_dev, struct eac_codec *codec);
+extern void eac_unregister_codec(struct device *eac_dev);
+
+extern int eac_set_mode(struct device *eac_dev, int play, int rec);
+
+#endif /* __ASM_ARM_ARCH_OMAP2_EAC_H */
--- a/include/asm-arm/arch-omap/menelaus.h
+++ b/include/asm-arm/arch-omap/menelaus.h
@@ -7,6 +7,15 @@
 #ifndef __ASM_ARCH_MENELAUS_H
 #define __ASM_ARCH_MENELAUS_H
 
+struct device;
+
+struct menelaus_platform_data {
+	int (* late_init)(struct device *dev);
+};
+
+/* Call only at init time. */
+extern void menelaus_set_platform_data(struct menelaus_platform_data *pdata);
+
 extern int menelaus_register_mmc_callback(void (*callback)(void *data, u8 card_mask),
 					  void *data);
 extern void menelaus_unregister_mmc_callback(void);
@@ -20,6 +29,19 @@ extern int menelaus_set_vaux(unsigned int mV);
 extern int menelaus_set_vdcdc(int dcdc, unsigned int mV);
 extern int menelaus_set_slot_sel(int enable);
 extern int menelaus_get_slot_pin_states(void);
+extern int menelaus_set_vcore_sw(unsigned int mV);
+extern int menelaus_set_vcore_hw(unsigned int roof_mV, unsigned int floor_mV);
+
+#define EN_VPLL_SLEEP	(1 << 7)
+#define EN_VMMC_SLEEP	(1 << 6)
+#define EN_VAUX_SLEEP	(1 << 5)
+#define EN_VIO_SLEEP	(1 << 4)
+#define EN_VMEM_SLEEP	(1 << 3)
+#define EN_DC3_SLEEP	(1 << 2)
+#define EN_DC2_SLEEP	(1 << 1)
+#define EN_VC_SLEEP	(1 << 0)
+
+extern int menelaus_set_regulator_sleep(int enable, u32 val);
 
 #if defined(CONFIG_ARCH_OMAP24XX) && defined(CONFIG_MENELAUS)
 #define omap_has_menelaus()	1
@@ -28,4 +50,3 @@ extern int menelaus_get_slot_pin_states(void);
 #endif
 
 #endif
-
--- /dev/null
+++ b/include/asm-arm/arch-omap/mmc.h
@@ -0,0 +1,67 @@
+/*
+ * MMC definitions for OMAP2
+ *
+ * Copyright (C) 2006 Nokia Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __OMAP2_MMC_H
+#define __OMAP2_MMC_H
+
+#include <linux/types.h>
+#include <linux/device.h>
+#include <linux/mmc/protocol.h>
+#include <linux/mmc/host.h>
+
+#define OMAP_MMC_MAX_SLOTS	2
+
+struct omap_mmc_platform_data {
+	unsigned enabled:1;
+	/* number of slots on board */
+	unsigned nr_slots:2;
+	/* nomux means "standard" muxing is wrong on this board, and that
+	 * board-specific code handled it before common init logic.
+	 */
+	unsigned nomux:1;
+	/* 4 wire signaling is optional, and is only used for SD/SDIO and
+	 * MMCv4 */
+	unsigned wire4:1;
+	/* set if your board has components or wiring that limits the
+	 * maximum frequency on the MMC bus */
+	unsigned int max_freq;
+
+	/* switch the bus to a new slot */
+	int (* switch_slot)(struct device *dev, int slot);
+	/* initialize board-specific MMC functionality, can be NULL if
+	 * not supported */
+	int (* init)(struct device *dev);
+	void (* cleanup)(struct device *dev);
+
+	struct omap_mmc_slot_data {
+		int (* set_bus_mode)(struct device *dev, int slot, int bus_mode);
+		int (* set_power)(struct device *dev, int slot, int power_on, int vdd);
+		int (* get_ro)(struct device *dev, int slot);
+
+		/* return MMC cover switch state, can be NULL if not supported.
+		 *
+		 * possible return values:
+		 *   0 - open
+		 *   1 - closed
+		 */
+		int (* get_cover_state)(struct device *dev, int slot);
+
+		const char *name;
+		u32 ocr_mask;
+	} slots[OMAP_MMC_MAX_SLOTS];
+};
+
+extern void omap_set_mmc_info(int host, const struct omap_mmc_platform_data *info);
+
+/* called from board-specific card detection service routine */
+extern void omap_mmc_notify_card_detect(struct device *dev, int slot, int detected);
+extern void omap_mmc_notify_cover_event(struct device *dev, int slot, int is_closed);
+
+#endif
--- /dev/null
+++ b/include/asm-arm/arch-omap/onenand.h
@@ -0,0 +1,19 @@
+/*
+ * include/asm-arm/arch-omap/onenand.h
+ *
+ * Copyright (C) 2006 Nokia Corporation
+ * Author: Juha Yrjola
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/mtd/partitions.h>
+
+struct omap_onenand_platform_data {
+	int			cs;
+	int			gpio_irq;
+	struct mtd_partition	*parts;
+	int			nr_parts;
+};
-- 
1.4.4.2

