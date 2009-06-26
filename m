Return-Path: <linux-kernel-owner+w=401wt.eu-S1757603AbZFZXaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603AbZFZXaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 19:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757590AbZFZXaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 19:30:21 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:4410 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757566AbZFZXaT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 19:30:19 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
From: "Leo (Hao) Chen" <leochen@broadcom.com>
To: "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
cc: "Leo (Hao) Chen" <leochen@broadcom.com>
Date: Fri, 26 Jun 2009 16:30:13 -0700
Subject: [PATCH v1 4/6][ARM]  new ARM SoC support: BCMRing
Thread-Topic: [PATCH v1 4/6][ARM]  new ARM SoC support: BCMRing
Thread-Index: Acn2tg1U2TBBnfrFTVet1CuVrKLaaw==
Message-ID: <8628FE4E7912BF47A96AE7DD7BAC0AADCB25AE17C6@SJEXCHCCR02.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 665B858C0EG7109602-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the fourth one. We add Kconfig option and Makefile entries of the nand driver.

>From 64d367c7a2b97cd71b4c4ed215dd8247271fda8b Mon Sep 17 00:00:00 2001
From: Leo Chen <leochen@broadcom.com>
Date: Fri, 26 Jun 2009 15:47:04 -0700
Subject: [PATCH 4/6] add bcmring umi nand driver in mtd/nand Kconfig and Makefile

---
 drivers/mtd/nand/Kconfig  |   16 ++++++++++++++++
 drivers/mtd/nand/Makefile |    2 ++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index ce96c09..35a3f91 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -186,6 +186,22 @@ config MTD_NAND_S3C2410_CLKSTOP
 	  when the is NAND chip selected or released, but will save
 	  approximately 5mA of power when there is nothing happening.
 
+config MTD_NAND_BCM_UMI
+	tristate "NAND Flash support for BCM Reference Boards"
+	depends on ARCH_BCMRING && MTD_NAND
+	help
+	  This enables the NAND flash controller on the BCM UMI block.
+
+	  No board specfic support is done by this driver, each board
+	  must advertise a platform_device for the driver to attach.
+
+config MTD_NAND_BCM_UMI_HWECC
+	bool "BCM UMI NAND Hardware ECC"
+	depends on MTD_NAND_BCM_UMI
+	help
+	  Enable the use of the BCM UMI block's internal ECC generator when
+	  using NAND.
+
 config MTD_NAND_DISKONCHIP
 	tristate "DiskOnChip 2000, Millennium and Millennium Plus (NAND reimplementation) (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
diff --git a/drivers/mtd/nand/Makefile b/drivers/mtd/nand/Makefile
index f3a786b..2a3b777 100644
--- a/drivers/mtd/nand/Makefile
+++ b/drivers/mtd/nand/Makefile
@@ -40,5 +40,7 @@ obj-$(CONFIG_MTD_NAND_SH_FLCTL)		+= sh_flctl.o
 obj-$(CONFIG_MTD_NAND_MXC)		+= mxc_nand.o
 obj-$(CONFIG_MTD_NAND_SOCRATES)		+= socrates_nand.o
 obj-$(CONFIG_MTD_NAND_TXX9NDFMC)	+= txx9ndfmc.o
+obj-$(CONFIG_MTD_NAND_BCM_UMI)		+= nand_bcm_umi.o
+obj-$(CONFIG_MTD_NAND_BCM_UMI_HWECC) += nand_correct_data512.o nand_calculate_ecc512.o
 
 nand-objs := nand_base.o nand_bbt.o
-- 
1.6.0.6


 
Leo Hao Chen
Software Engineer
Broadcom Canada Inc.


