Return-Path: <linux-kernel-owner+w=401wt.eu-S1758302AbYLPLmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758302AbYLPLmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 06:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758108AbYLPLls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 06:41:48 -0500
Received: from exchtp08.via.com.tw ([61.66.243.7]:5290 "EHLO
	exchtp08.via.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758097AbYLPLlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 06:41:45 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: [Patch 3/3] via-sdmmc: via-sdmmc.h
Date: Tue, 16 Dec 2008 19:41:43 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB808520F3C@exchtp03.taipei.via.com.tw>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Patch 3/3] via-sdmmc: via-sdmmc.h
Thread-Index: Aclfc0R5RbUasrVKTV+3/IJ/Zjg6tQ==
From: <JosephChan@via.com.tw>
To: <linux-kernel@vger.kernel.org>
Cc: <JosephChan@via.com.tw>
X-OriginalArrivalTime: 16 Dec 2008 11:41:44.0032 (UTC) FILETIME=[4500AE00:01C95F73]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id mBGBgZi3028830

Header file of VIA MSP SD/MMC card reader driver.

BRs,
Joseph Chan 


Signed-off-by: Joseph Chan <josephchan@via.com.tw>

--- a/drivers/mmc/host/via-sdmmc.h	1970-01-01 08:00:00.000000000 +0800
+++ b/drivers/mmc/host/via-sdmmc.h	2008-12-15 19:44:39.000000000 +0800
@@ -0,0 +1,274 @@
+/*
+ *  drivers/mmc/host/via-sdmmc.h - VIA SD/MMC Card Reader driver
+ *  Copyright (c) 2008, VIA Technologies Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or (at
+ * your option) any later version.
+ */
+#define DEV_NULL	0
+#define DEV_SDC		1
+#define DEV_CEATA	2
+#define DEV_MSC		4
+#define DEV_XDC		8
+
+#define NFC_OFFSET        0x0
+#define MSC_OFFSET        0x100
+#define SDC_OFFSET        0x200
+#define CEA_OFFSET        0x300
+#define DDMA_OFFSET       0x400
+#define CICH_OFFSET       0x500
+#define PCICTRL_OFFSET    0x600
+
+enum DMA_DIRECTION {
+	CARD_TO_MEM,
+	MEM_TO_CARD
+};
+
+enum PCI_HOST_CLK_CONTROL {
+	PCI_CLK_375K = 0x03,
+	PCI_CLK_8M = 0x04,
+	PCI_CLK_12M = 0x00,
+	PCI_CLK_16M = 0x05,
+	PCI_CLK_24M = 0x01,
+	PCI_CLK_33M = 0x06,
+	PCI_CLK_48M = 0x02
+};
+
+/*
+ * PCI registers
+ */
+
+#define PCI_WORK_MODE      0x40
+#define PCI_DEBUG_MODE     0x41
+
+/*
+ * SDC MMIO Registers
+ */
+
+#define SDCONTROL_REG	0x0
+#define SDCMDARG_REG 	0x4
+
+#define SDBUSMODE_REG	0x8
+#define SD_MODE_SPI		0x01
+#define SD_MODE_4BIT		0x02
+#define SD_MODE_RW			0x04
+#define SD_MODE_SPICRC		0x08
+#define SD_MODE_CST		0x10
+#define SD_MODE_SPICS		0x20
+#define SD_MODE_SDPWR		0x40
+#define SD_MODE_SFTRST		0x80
+
+#define SDBLKLEN_REG	0xc
+#define SD_BLKLEN_CRCSTP	0x0800
+#define SD_BLKLEN_DETPOL	0x1000
+#define SD_BLKLEN_GPIDET	0x2000
+#define SD_BLKLEN_DT3DET	0x4000
+#define SD_BLKLEN_INTEN	0x8000
+
+#define SDRESP0_REG		0x10
+#define SDRESP1_REG		0x14
+#define SDRESP2_REG		0x18
+#define SDRESP3_REG		0x1c
+#define SDCURBLKCNT_REG	0x20
+
+#define SDINTMASK_REG	0x24
+#define SD_INTMASK_BDIE	0x10
+#define SD_INTMASK_DDIE	0x20
+#define SD_INTMASK_CDIE	0x40
+#define SD_INTMASK_SIIE	0x80
+#define SD_INTMASK_IOIE	0x100
+#define SD_INTMASK_CRIE	0x200
+#define SD_INTMASK_RAIE	0x400
+#define SD_INTMASK_PDIE	0x800
+#define SD_INTMASK_DTIE	0x1000
+#define SD_INTMASK_SCIE	0x2000
+#define SD_INTMASK_RCIE	0x4000
+#define SD_INTMASK_WCIE	0x8000
+#define SD_ACTIVE_INTMASK \
+	(SD_INTMASK_BDIE | SD_INTMASK_SIIE | SD_INTMASK_CRIE \
+	| SD_INTMASK_RAIE | SD_INTMASK_DTIE | SD_INTMASK_SCIE \
+	| SD_INTMASK_RCIE | SD_INTMASK_WCIE)
+
+#define SDSTATUS_REG	0x28
+#define SD_STS_CECC			0x01
+#define SD_STS_WP			0x02
+#define SD_STS_SLOTD		0x04
+#define SD_STS_SLOTG		0x08
+#define SD_STS_BD			0x10
+#define SD_STS_DD			0x20
+#define SD_STS_CD			0x40
+#define SD_STS_SI			0x80
+#define SD_STS_IO			0x100
+#define SD_STS_CR			0x200
+#define SD_STS_RA			0x400
+#define SD_STS_PD			0x800
+#define SD_STS_DT			0x1000
+#define SD_STS_SC			0x2000
+#define SD_STS_RC			0x4000
+#define SD_STS_WC			0x8000
+#define SD_STS_IGN_MASK\
+	(SD_STS_DD | SD_STS_PD | SD_STS_IO)
+#define SD_STS_INT_MASK \
+	(SD_STS_BD | SD_STS_DD | SD_STS_CD | SD_STS_SI \
+	| SD_STS_IO | SD_STS_CR | SD_STS_RA | SD_STS_PD \
+	| SD_STS_DT | SD_STS_SC | SD_STS_RC | SD_STS_WC)
+#define SD_STS_W1C_MASK \
+	(SD_STS_CECC | SD_STS_BD | SD_STS_DD | SD_STS_CD \
+	| SD_STS_SI | SD_STS_CR  | SD_STS_RA | SD_STS_PD \
+	| SD_STS_DT | SD_STS_SC | SD_STS_RC | SD_STS_WC)
+#define  SD_STS_CMD_MASK \
+	(SD_STS_CR | SD_STS_RA | SD_STS_SC)
+#define  SD_STS_DATA_MASK\
+	(SD_STS_BD | SD_STS_DT | SD_STS_RC | SD_STS_WC)
+
+#define SDSTATUS_REG2	0x2a
+#define SD_STS_DB			0x20
+#define SD_STS_CFE			0x80
+
+#define SDRSPTMO_REG	0x2C
+
+#define SDCLKSEL_REG	0x30
+#define SD_CLKSEL_375k		0x00
+#define SD_CLKSEL_10M		0x01
+#define SD_CLKSEL_12M		0x02
+#define SD_CLKSEL_15M		0x03
+#define SD_CLKSEL_20M		0x04
+#define SD_CLKSEL_24M		0x05
+#define SD_CLKSEL_30M		0x06
+#define SD_CLKSEL_40M		0x07
+
+#define SDEXTCTRL_REG	0x34
+#define SD_EXTCTRL_AUTO	0x01
+#define SD_EXTCTRL_8BIT		0x04
+/* 0x38-0xFF reserved */
+
+/*
+ * Data DMA Control Registers
+ */
+
+#define DDMABASEADD_REG		0x0
+#define DDMACOUNTER_REG		0x4
+
+#define DDMACONTROL_REG		0x8
+#define DDMA_CONTROL_RDDIR		0x100
+#define DDMA_CONTROL_DATA16		0x200
+#define DDMA_CONTROL_EFMODE		0x400
+#define DDMA_CONTROL_RDENIRQ		0x10000
+#define DDMA_CONTROL_SOFTRESET	0x1000000
+
+#define DDMASTATUS_REG	0xc
+#define DDMA_STATUS_IRQSTATUS	0x10000
+
+#define DDMASTART_REG		0x10
+/*0x14-0xFF reserved*/
+
+/*
+ * PCI Control Registers
+ */
+
+/*0x0 - 0x1 reserved*/
+#define PCICLKGATT_REG	0x2
+#define PCI_CLKGATT_SOFTRST	0x01
+#define PCI_CLKGATT_CKGEN		0x02
+#define PCI_CLKGATT_POWSEL		0x10
+#define PCI_CLKGATT_POWOFF	0x20
+
+#define PCINFCCLK_REG	0x3
+#define PCIMSCCLK_REG	0x4
+#define PCISDCCLK_REG	0x5
+#define PCICEACLK_REG	0x6
+
+#define PCIDMACLK_REG	0x7
+#define PCI_DMA_CLK_NFC	0x0
+#define PCI_DMA_CLK_MSC	0x1
+#define PCI_DMA_CLK_SDC	0x2
+#define PCI_DMA_CLK_CEA	0x3
+
+#define PCIINTCTRL_REG		0x8
+#define PCI_INTCTRL_NFCIRQEN	0x01
+#define PCI_INTCTRL_MSCIRQEN	0x02
+#define PCI_INTCTRL_SDCIRQEN	0x04
+#define PCI_INTCTRL_CEAIRQEN	0x08
+#define PCI_INTCTRL_DMAIRQEN	0x10
+#define PCI_INTCTRL_CICHIRQEN	0x20
+
+#define PCIINTSTATUS_REG	0x9
+#define PCI_INT_STATUS_NFC		0x01
+#define PCI_INT_STATUS_MSC		0x02
+#define PCI_INT_STATUS_SDC		0x04
+#define PCI_INT_STATUS_CEA		0x08
+#define PCI_INT_STATUS_DMA		0x10
+#define PCI_INT_STATUS_CICH	0x20
+
+#define PCITMOCTRL_REG		0xa
+#define PCI_TMO_CTRL_NO		0x0
+#define PCI_TMO_CTRL_32US		0x1
+#define PCI_TMO_CTRL_256US		0x2
+#define PCI_TMO_CTRL_1024US	0x3
+#define PCI_TMO_CTRL_256MS	0x4
+#define PCI_TMO_CTRL_512MS	0x5
+#define PCI_TMO_CTRL_1024MS	0x6
+
+/*0xB-0xFF reserved*/
+
+struct sdhcreg {
+	u32 sdcontrol_reg;
+	u32 sdcmdarg_reg;
+	u32 sdbusmode_reg;
+	u32 sdblklen_reg;
+	u32 sdresp_reg[4];
+	u32 sdcurblkcnt_reg;
+	u32 sdintmask_reg;
+	u32 sdstatus_reg;
+	u32 sdrsptmo_reg;
+	u32 sdclksel_reg;
+	u32 sdextctrl_reg;
+};
+
+struct pcictrlreg {
+	u8 reserve[2];
+	u8 pciclkgat_reg;
+	u8 pcinfcclk_reg;
+	u8 pcimscclk_reg;
+	u8 pcisdclk_reg;
+	u8 pcicaclk_reg;
+	u8 pcidmaclk_reg;
+	u8 pciintctrl_reg;
+	u8 pciintstatus_reg;
+	u8 pcitmoctrl_reg;
+	u8 Resv;
+};
+
+struct via_crdr_chip {
+	struct via_crdr_mmc_host *sdc;
+	void __iomem *mmiobase;
+	void __iomem *sdhc_mmiobase;
+	void __iomem *ddma_mmiobase;
+	void __iomem *pcictrl_mmiobase;
+	u32 cur_device;
+
+#ifdef CONFIG_PM
+	u8 pci_cfg_bak[0x42];
+	struct pcictrlreg pm_pcictrl_reg;
+	struct sdhcreg pm_sdhc_reg;
+#endif
+};
+
+struct via_crdr_mmc_host {
+	struct via_crdr_chip *chip;
+	struct mmc_host *mmc;
+	spinlock_t lock;
+	struct mmc_request *mrq;
+	struct mmc_command *cmd;
+	struct mmc_data *data;
+	int data_early:1;
+	u8 bus_width;
+	u8 *ddmabuf;
+
+	struct tasklet_struct carddet_tasklet;
+	struct tasklet_struct finish_tasklet;
+
+	struct timer_list timer;
+};
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
