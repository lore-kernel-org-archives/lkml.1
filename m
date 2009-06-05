Return-Path: <linux-kernel-owner+w=401wt.eu-S1756367AbZFEIKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367AbZFEIKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754996AbZFEIFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:05:42 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37487 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755140AbZFEIF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:05:26 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 12/62] Blackfin: fix up PATA resource handling in bf537-stamp
Date: Fri,  5 Jun 2009 04:04:21 -0400
Message-Id: <1244189111-19639-13-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Make sure the addresses declared match reality, and make the PATA IRQ code
optional.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 arch/blackfin/mach-bf537/boards/stamp.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index 0572926..9bd0a80 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -1358,16 +1358,18 @@ static struct resource bfin_pata_resources[] = {
 static struct pata_platform_info bfin_pata_platform_data = {
 	.ioport_shift = 0,
 };
-
+/* CompactFlash Storage Card Memory Mapped Adressing
+ * /REG = A11 = 1
+ */
 static struct resource bfin_pata_resources[] = {
 	{
-		.start = 0x20211820,
-		.end = 0x2021183F,
+		.start = 0x20211800,
+		.end = 0x20211807,
 		.flags = IORESOURCE_MEM,
 	},
 	{
-		.start = 0x2021181C,
-		.end = 0x2021181F,
+		.start = 0x2021180E,	/* Device Ctl */
+		.end = 0x2021180E,
 		.flags = IORESOURCE_MEM,
 	},
 };
@@ -1527,7 +1529,8 @@ static int __init stamp_init(void)
 	platform_add_devices(stamp_devices, ARRAY_SIZE(stamp_devices));
 	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
 
-#if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
+#if (defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)) \
+	 && defined(PATA_INT)
 	irq_desc[PATA_INT].status |= IRQ_NOAUTOEN;
 #endif
 
-- 
1.6.3.1

