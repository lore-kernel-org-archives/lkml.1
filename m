Return-Path: <linux-kernel-owner+w=401wt.eu-S1754934AbZB1RdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbZB1RdT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 12:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbZB1RdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 12:33:09 -0500
Received: from mail.openmoko.org ([88.198.124.205]:56157 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbZB1RdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 12:33:08 -0500
Subject: [PATCH] spi_s3c24xx_gpio: Introduce csid parameter to chip_select
	callback
To: linux-kernel@vger.kernel.org
From: Balaji Rao <balajirrao@openmoko.org>
Cc: Ben Dooks <ben@simtec.co.uk>, Andy Green <andy@openmoko.com>
Date: Sat, 28 Feb 2009 23:02:38 +0530
Message-ID: <20090228173238.23019.10564.stgit@fedora.yogi>
User-Agent: StGit/0.14.3.343.g0584
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a multiple slave configuration, it is required to know which
chip_select to assert.

Signed-off-by: Balaji Rao <balajirrao@openmoko.org>
Signed-off-by: Andy Green <andy@openmoko.com>
Cc: Ben Dooks <ben@simtec.co.uk>
---
 arch/arm/mach-s3c2410/include/mach/spi-gpio.h |    2 +-
 drivers/spi/spi_s3c24xx_gpio.c                |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-s3c2410/include/mach/spi-gpio.h b/arch/arm/mach-s3c2410/include/mach/spi-gpio.h
index 980a099..8189768 100644
--- a/arch/arm/mach-s3c2410/include/mach/spi-gpio.h
+++ b/arch/arm/mach-s3c2410/include/mach/spi-gpio.h
@@ -21,7 +21,7 @@ struct s3c2410_spigpio_info {
 	int			 num_chipselect;
 	int			 bus_num;
 
-	void (*chip_select)(struct s3c2410_spigpio_info *spi, int cs);
+	void (*chip_select)(struct s3c2410_spigpio_info *spi, int csid, int cs);
 };
 
 
diff --git a/drivers/spi/spi_s3c24xx_gpio.c b/drivers/spi/spi_s3c24xx_gpio.c
index f2447a5..006e7e7 100644
--- a/drivers/spi/spi_s3c24xx_gpio.c
+++ b/drivers/spi/spi_s3c24xx_gpio.c
@@ -91,7 +91,7 @@ static void s3c2410_spigpio_chipselect(struct spi_device *dev, int value)
 	struct s3c2410_spigpio *sg = spidev_to_sg(dev);
 
 	if (sg->info && sg->info->chip_select)
-		(sg->info->chip_select)(sg->info, value);
+		(sg->info->chip_select)(sg->info, dev->chip_select, value);
 }
 
 static int s3c2410_spigpio_probe(struct platform_device *dev)

