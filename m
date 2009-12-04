Return-Path: <linux-kernel-owner+w=401wt.eu-S1756009AbZLDCrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbZLDCrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 21:47:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755839AbZLDCrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 21:47:33 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:41078 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992AbZLDCr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 21:47:26 -0500
From: Amit Kucheria <amit.kucheria@canonical.com>
To: List Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Dinh Nguyen <Dinh.Nguyen@freescale.com>,
       linux-arm-kernel@lists.infradead.org, s.hauer@pengutronix.de,
       valentin.longchamp@epfl.ch, daniel@caiaq.de, grant.likely@secretlab.ca,
       r.herring@freescale.com
Subject: [RFC][PATCH 08/10] arm: mxc: Add IO multiplexing support for FEC
Date: Fri,  4 Dec 2009 04:47:08 +0200
Message-Id: <dbab65547b41b82719df19067b50db9c82eeb6d6.1259893118.git.amit.kucheria@canonical.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <a34d2aac8d5282bfbdf09dddc2da57c4ad7da355.1259893118.git.amit.kucheria@canonical.com>
References: <cover.1259893118.git.amit.kucheria@canonical.com>
 <e99e70e2a619693064130a747b6ee3a93273337b.1259893118.git.amit.kucheria@canonical.com>
 <6608c4dca645d87efce78ae0b7dbad265004f482.1259893118.git.amit.kucheria@canonical.com>
 <58eb7d14c6cf56cbc874657dff5789c47116b49e.1259893118.git.amit.kucheria@canonical.com>
 <a079a0627e77f2df590840e4798fc067f4436160.1259893118.git.amit.kucheria@canonical.com>
 <0559d42bc9f32e30264fea6ca6fa679121f6a241.1259893118.git.amit.kucheria@canonical.com>
 <7a49f4c0ea2f5030068729978c2cb173a6e15857.1259893118.git.amit.kucheria@canonical.com>
 <a34d2aac8d5282bfbdf09dddc2da57c4ad7da355.1259893118.git.amit.kucheria@canonical.com>
In-Reply-To: <cover.1259893118.git.amit.kucheria@canonical.com>
References: <cover.1259893118.git.amit.kucheria@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <Dinh.Nguyen@freescale.com>

Setup correct multiplexing in order to use the FEC ethernet device on the
Babbage board.

Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
---
 arch/arm/mach-mx5/board-mx51_babbage.c    |   43 +++++++++++++++++++++++++++++
 arch/arm/plat-mxc/include/mach/iomux-v3.h |    8 +++++
 2 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-mx5/board-mx51_babbage.c b/arch/arm/mach-mx5/board-mx51_babbage.c
index a1bc9c4..cefcb90 100644
--- a/arch/arm/mach-mx5/board-mx51_babbage.c
+++ b/arch/arm/mach-mx5/board-mx51_babbage.c
@@ -33,6 +33,8 @@ extern void __init mx51_babbage_io_init(void);
 #define MX51_UART2_PAD_CTRL	(PAD_CTL_PKE | PAD_CTL_PUE | PAD_CTL_DSE_HIGH | PAD_CTL_SRE_FAST)
 #define MX51_UART3_PAD_CTRL	(PAD_CTL_PKE | PAD_CTL_DSE_HIGH | PAD_CTL_SRE_FAST)
 
+#define MX51_FEC_PAD_CTRL	(PAD_CTL_DRV_VOT_HIGH | PAD_CTL_DRV_HIGH)
+
 /* UART1 */
 #define MX51_BABBAGE_PAD_UART1_RXD__UART1_RXD	IOMUX_PAD(0x618, 0x228,	IOMUX_CONFIG_ALT0, 0x9e4,   0, MX51_UART1_PAD_CTRL | PAD_CTL_SRE_FAST)
 #define MX51_BABBAGE_PAD_UART1_TXD__UART1_TXD	IOMUX_PAD(0x61C, 0x22C, IOMUX_CONFIG_ALT0, 0x0,   0, MX51_UART1_PAD_CTRL | PAD_CTL_SRE_FAST)
@@ -52,6 +54,28 @@ extern void __init mx51_babbage_io_init(void);
 
 #define MX51_BABBAGE_PAD_GPIO_1_8__GPIO1_8	IOMUX_PAD(0x814, 0x3E8, 0, 0x0, 1, (PAD_CTL_SRE_SLOW | PAD_CTL_DSE_MED | PAD_CTL_PUS_100K_UP |  PAD_CTL_HYS))
 
+/* FEC */
+#define MX51_BABBAGE_PAD_EIM_EB2__MDIO		IOMUX_PAD(0x468, 0x0d4, IOMUX_CONFIG_ALT3, 0x954,   0, MX51_FEC_PAD_CTRL)
+#define MX51_BABBAGE_PAD_NANDF_CS3__MDC		IOMUX_PAD(0x524, 0x13C, IOMUX_CONFIG_ALT2, 0x0, 0, MX51_FEC_PAD_CTRL)
+#define MX51_BABBAGE_PAD_EIM_CS3__RDATA3	IOMUX_PAD(0x480, 0x0ec, IOMUX_CONFIG_ALT3, 0x964,   0, MX51_FEC_PAD_CTRL)
+#define MX51_BABBAGE_PAD_EIM_CS2__RDATA2	IOMUX_PAD(0x47c, 0x0e8, IOMUX_CONFIG_ALT3, 0x960,   0, MX51_FEC_PAD_CTRL)
+#define MX51_BABBAGE_PAD_EIM_EB3__RDATA1	IOMUX_PAD(0x46c, 0x0d8, IOMUX_CONFIG_ALT3, 0x95c,   0, MX51_FEC_PAD_CTRL)
+#define MX51_BABBAGE_PAD_NANDF_RB6__RDATA0	IOMUX_PAD(0x5DC, 0x134, IOMUX_CONFIG_ALT1, 0x958, 0, MX51_FEC_PAD_CTRL)
+#define MX51_BABBAGE_PAD_NANDF_D11__RX_DV	IOMUX_PAD(0x54C, 0x164, IOMUX_CONFIG_ALT2, 0x96c, 0, MX51_FEC_PAD_CTRL)
+#define MX51_BABBAGE_PAD_NANDF_RB3__RX_CLK	IOMUX_PAD(0x504, 0x128, IOMUX_CONFIG_ALT1, 0x968, 0, MX51_FEC_PAD_CTRL)
+#define MX51_BABBAGE_PAD_EIM_CS4__RX_ER		IOMUX_PAD(0x484, 0x0f0, IOMUX_CONFIG_ALT3, 0x970,   0, MX51_FEC_PAD_CTRL)
+#define MX51_BABBAGE_PAD_NANDF_RDY_INT__TX_CLK	IOMUX_PAD(0x538, 0x150, IOMUX_CONFIG_ALT1, 0x974, 0, MX51_FEC_PAD_CTRL)
+#define MX51_BABBAGE_PAD_NANDF_CS7__TX_EN	IOMUX_PAD(0x534, 0x14C, IOMUX_CONFIG_ALT1, 0x0, 0, MX51_FEC_PAD_CTRL)
+#define MX51_BABBAGE_PAD_NANDF_D8__TDATA0	IOMUX_PAD(0x558, 0x170, IOMUX_CONFIG_ALT2, 0x0, 0, MX51_FEC_PAD_CTRL)
+#define MX51_BABBAGE_PAD_NANDF_CS4__TDATA1	IOMUX_PAD(0x528, 0x140, IOMUX_CONFIG_ALT2, 0x0, 0, MX51_FEC_PAD_CTRL)
+#define MX51_BABBAGE_PAD_NANDF_CS5__TDATA2	IOMUX_PAD(0x52C, 0x144, IOMUX_CONFIG_ALT2, 0x0, 0, MX51_FEC_PAD_CTRL)
+#define MX51_BABBAGE_PAD_NANDF_CS6__TDATA3	IOMUX_PAD(0x530, 0x148, IOMUX_CONFIG_ALT2, 0x0, 0, MX51_FEC_PAD_CTRL)
+#define MX51_BABBAGE_PAD_NANDF_RB2__COL		IOMUX_PAD(0x500, 0x124, IOMUX_CONFIG_ALT1, 0x94c, 0, MX51_FEC_PAD_CTRL)
+#define MX51_BABBAGE_PAD_EIM_CS5__CRS		IOMUX_PAD(0x52C, 0x144, IOMUX_CONFIG_ALT3, 0x950, 0, MX51_FEC_PAD_CTRL)
+
+
+
+
 static struct platform_device *devices[] __initdata = {
 	&mxc_fec_device,
 };
@@ -72,6 +96,25 @@ static struct pad_desc mx51babbage_pads[] = {
 	MX51_BABBAGE_PAD_EIM_D26__UART3_TXD,
 	MX51_BABBAGE_PAD_EIM_D27__UART3_RTS,
 	MX51_BABBAGE_PAD_EIM_D24__UART3_CTS,
+
+	/* FEC */
+	MX51_BABBAGE_PAD_EIM_EB2__MDIO,
+	MX51_BABBAGE_PAD_NANDF_CS3__MDC,
+	MX51_BABBAGE_PAD_EIM_CS3__RDATA3,
+	MX51_BABBAGE_PAD_EIM_CS2__RDATA2,
+	MX51_BABBAGE_PAD_EIM_EB3__RDATA1,
+	MX51_BABBAGE_PAD_NANDF_RB6__RDATA0,
+	MX51_BABBAGE_PAD_NANDF_D11__RX_DV,
+	MX51_BABBAGE_PAD_NANDF_RB3__RX_CLK,
+	MX51_BABBAGE_PAD_EIM_CS4__RX_ER,
+	MX51_BABBAGE_PAD_NANDF_RDY_INT__TX_CLK,
+	MX51_BABBAGE_PAD_NANDF_CS7__TX_EN,
+	MX51_BABBAGE_PAD_NANDF_D8__TDATA0,
+	MX51_BABBAGE_PAD_NANDF_CS4__TDATA1,
+	MX51_BABBAGE_PAD_NANDF_CS5__TDATA2,
+	MX51_BABBAGE_PAD_NANDF_CS6__TDATA3,
+	MX51_BABBAGE_PAD_NANDF_RB2__COL,
+	MX51_BABBAGE_PAD_EIM_CS5__CRS	,
 };
 
 /* Serial ports */
diff --git a/arch/arm/plat-mxc/include/mach/iomux-v3.h b/arch/arm/plat-mxc/include/mach/iomux-v3.h
index 8c351d6..78c71f0 100644
--- a/arch/arm/plat-mxc/include/mach/iomux-v3.h
+++ b/arch/arm/plat-mxc/include/mach/iomux-v3.h
@@ -89,6 +89,14 @@ struct pad_desc {
 #define PAD_CTL_SRE_FAST		(1 << 0)
 #define PAD_CTL_SRE_SLOW		(0 << 0)
 
+#define PAD_CTL_DRV_LOW			(0 << 1)
+#define PAD_CTL_DRV_MEDIUM		(1 << 1)
+#define PAD_CTL_DRV_HIGH		(2 << 1)
+#define PAD_CTL_DRV_MAX			(3 << 1)
+
+#define PAD_CTL_DRV_VOT_LOW		(0 << 13)
+#define PAD_CTL_DRV_VOT_HIGH		(1 << 13)
+
 /*
  * setups a single pad:
  * 	- reserves the pad so that it is not claimed by another driver
-- 
1.6.3.3

