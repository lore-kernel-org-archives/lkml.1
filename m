Return-Path: <linux-kernel-owner+w=401wt.eu-S1756087AbXHSNbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbXHSNbV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 09:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755307AbXHSNa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 09:30:58 -0400
Received: from mba.ocn.ne.jp ([122.1.175.29]:57406 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754319AbXHSNay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 09:30:54 -0400
Date: Sun, 19 Aug 2007 22:32:10 +0900 (JST)
Message-Id: <20070819.223210.21590535.anemo@mba.ocn.ne.jp>
To: a.zummo@towertech.it
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
       dbrownell@users.sourceforge.net, ralf@linux-mips.org
Subject: [PATCH] rtc: Make rtc-rs5c348 driver hotplug-aware (take 2)
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The rtc-rs5c348 SPI driver name doesn't match its module name, which
prevents it from properly hotplugging.  There is only one in-tree user
of its driver, which is fixed by this patch too.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
 arch/mips/tx4938/toshiba_rbtx4938/setup.c |    2 +-
 drivers/rtc/rtc-rs5c348.c                 |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/tx4938/toshiba_rbtx4938/setup.c b/arch/mips/tx4938/toshiba_rbtx4938/setup.c
index 57f3c70..84ebff7 100644
--- a/arch/mips/tx4938/toshiba_rbtx4938/setup.c
+++ b/arch/mips/tx4938/toshiba_rbtx4938/setup.c
@@ -1115,7 +1115,7 @@ static void __init txx9_spi_init(unsigned long base, int irq)
 static int __init rbtx4938_spi_init(void)
 {
 	struct spi_board_info srtc_info = {
-		.modalias = "rs5c348",
+		.modalias = "rtc-rs5c348",
 		.max_speed_hz = 1000000, /* 1.0Mbps @ Vdd 2.0V */
 		.bus_num = 0,
 		.chip_select = 16 + SRTC_CS,
diff --git a/drivers/rtc/rtc-rs5c348.c b/drivers/rtc/rtc-rs5c348.c
index f50f3fc..8394626 100644
--- a/drivers/rtc/rtc-rs5c348.c
+++ b/drivers/rtc/rtc-rs5c348.c
@@ -226,7 +226,7 @@ static int __devexit rs5c348_remove(struct spi_device *spi)
 
 static struct spi_driver rs5c348_driver = {
 	.driver = {
-		.name	= "rs5c348",
+		.name	= "rtc-rs5c348",
 		.bus	= &spi_bus_type,
 		.owner	= THIS_MODULE,
 	},
