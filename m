Return-Path: <linux-kernel-owner+w=401wt.eu-S1757809AbZFTSqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757809AbZFTSqL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 14:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757219AbZFTSpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 14:45:32 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48011 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757602AbZFTSp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 14:45:26 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 03/25] Blackfin: bf533-ezkit: add resources for FISP devices
Date: Sat, 20 Jun 2009 14:44:26 -0400
Message-Id: <1245523488-26536-4-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
References: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BF533-EZKIT has two Flash In-System Programming devices hooked up to
the async memory bus, so add resources for the primary flashes and the
SRAMs on the devices.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf533/boards/ezkit.c |  106 +++++++++++++++++++++++++++++++
 1 files changed, 106 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/mach-bf533/boards/ezkit.c b/arch/blackfin/mach-bf533/boards/ezkit.c
index 89a5ec4..4e3e511 100644
--- a/arch/blackfin/mach-bf533/boards/ezkit.c
+++ b/arch/blackfin/mach-bf533/boards/ezkit.c
@@ -32,6 +32,7 @@
 #include <linux/platform_device.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
+#include <linux/mtd/plat-ram.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
 #if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
@@ -86,6 +87,101 @@ static struct platform_device smc91x_device = {
 };
 #endif
 
+#if defined(CONFIG_MTD_PSD4256G) || defined(CONFIG_MTD_PSD4256G_MODULE)
+static const char *map_probes[] = {
+	"stm_flash",
+	NULL,
+};
+
+static struct platdata_mtd_ram stm_pri_data_a = {
+	.mapname    = "Flash A Primary",
+	.map_probes = map_probes,
+	.bankwidth  = 2,
+};
+
+static struct resource stm_pri_resource_a = {
+	.start = 0x20000000,
+	.end   = 0x200fffff,
+	.flags = IORESOURCE_MEM,
+};
+
+static struct platform_device stm_pri_device_a = {
+	.name          = "mtd-ram",
+	.id            = 0,
+	.dev = {
+		.platform_data = &stm_pri_data_a,
+	},
+	.num_resources = 1,
+	.resource      = &stm_pri_resource_a,
+};
+
+static struct platdata_mtd_ram stm_pri_data_b = {
+	.mapname    = "Flash B Primary",
+	.map_probes = map_probes,
+	.bankwidth  = 2,
+};
+
+static struct resource stm_pri_resource_b = {
+	.start = 0x20100000,
+	.end   = 0x201fffff,
+	.flags = IORESOURCE_MEM,
+};
+
+static struct platform_device stm_pri_device_b = {
+	.name          = "mtd-ram",
+	.id            = 4,
+	.dev = {
+		.platform_data = &stm_pri_data_b,
+	},
+	.num_resources = 1,
+	.resource      = &stm_pri_resource_b,
+};
+#endif
+
+#if defined(CONFIG_MTD_PLATRAM) || defined(CONFIG_MTD_PLATRAM_MODULE)
+static struct platdata_mtd_ram sram_data_a = {
+	.mapname   = "Flash A SRAM",
+	.bankwidth = 2,
+};
+
+static struct resource sram_resource_a = {
+	.start = 0x20240000,
+	.end   = 0x2024ffff,
+	.flags = IORESOURCE_MEM,
+};
+
+static struct platform_device sram_device_a = {
+	.name          = "mtd-ram",
+	.id            = 8,
+	.dev = {
+		.platform_data = &sram_data_a,
+	},
+	.num_resources = 1,
+	.resource      = &sram_resource_a,
+};
+
+static struct platdata_mtd_ram sram_data_b = {
+	.mapname   = "Flash B SRAM",
+	.bankwidth = 2,
+};
+
+static struct resource sram_resource_b = {
+	.start = 0x202c0000,
+	.end   = 0x202cffff,
+	.flags = IORESOURCE_MEM,
+};
+
+static struct platform_device sram_device_b = {
+	.name          = "mtd-ram",
+	.id            = 9,
+	.dev = {
+		.platform_data = &sram_data_b,
+	},
+	.num_resources = 1,
+	.resource      = &sram_resource_b,
+};
+#endif
+
 #if defined(CONFIG_MTD_M25P80) || defined(CONFIG_MTD_M25P80_MODULE)
 static struct mtd_partition bfin_spi_flash_partitions[] = {
 	{
@@ -357,6 +453,16 @@ static struct platform_device *ezkit_devices[] __initdata = {
 
 	&bfin_dpmc,
 
+#if defined(CONFIG_MTD_PSD4256G) || defined(CONFIG_MTD_PSD4256G_MODULE)
+	&stm_pri_device_a,
+	&stm_pri_device_b,
+#endif
+
+#if defined(CONFIG_MTD_PLATRAM) || defined(CONFIG_MTD_PLATRAM_MODULE)
+	&sram_device_a,
+	&sram_device_b,
+#endif
+
 #if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91X_MODULE)
 	&smc91x_device,
 #endif
-- 
1.6.3.1

