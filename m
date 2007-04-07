Return-Path: <linux-kernel-owner+w=401wt.eu-S966281AbXDGTKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966281AbXDGTKG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 15:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966295AbXDGTKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 15:10:06 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:50108 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966281AbXDGTKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 15:10:03 -0400
Date: Sat, 7 Apr 2007 21:10:49 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Victor <andrew@sanpeople.com>, Russell King <rmk@arm.linux.org.uk>,
       Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] arm: fix section mismatch warning in board-sam9260
Message-ID: <20070407191049.GA30885@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton found a section mismatch warning in x86_64 triggered
by a wrongly placed __initdata marker.
git grep "struct __initdata" revealed that board-sam9260.c
had the same problem.

This patch fixes this by placing the __initdata marker correct.
It was checked with objdump that the variable was moved to
.init.data by this change.

Fixed an unrelated section mismatch warning while touching the file.

Both changes are only compile tested but obvious correct.
[Used at91sam9260ek_defconfig to get compile coverage]

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
diff --git a/arch/arm/mach-at91/board-sam9260ek.c b/arch/arm/mach-at91/board-sam9260ek.c
index 57fb449..7a31db0 100644
--- a/arch/arm/mach-at91/board-sam9260ek.c
+++ b/arch/arm/mach-at91/board-sam9260ek.c
@@ -118,7 +118,7 @@ static struct spi_board_info ek_spi_devices[] = {
 /*
  * MACB Ethernet device
  */
-static struct __initdata at91_eth_data ek_macb_data = {
+static struct at91_eth_data __initdata ek_macb_data = {
 	.phy_irq_pin	= AT91_PIN_PA7,
 	.is_rmii	= 1,
 };
@@ -140,7 +140,7 @@ static struct mtd_partition __initdata ek_nand_partition[] = {
 	},
 };
 
-static struct mtd_partition *nand_partitions(int size, int *num_partitions)
+static struct mtd_partition * __init nand_partitions(int size, int *num_partitions)
 {
 	*num_partitions = ARRAY_SIZE(ek_nand_partition);
 	return ek_nand_partition;
