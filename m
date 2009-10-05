Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbZJEVP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbZJEVP1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 17:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753973AbZJEVP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 17:15:26 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:55024 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951AbZJEVP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 17:15:26 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
       David Woodhouse <dwmw2@infradead.org>, Graf Yang <graf.yang@analog.com>
Subject: [PATCH 1/3] mtd: m25p80: disable SST software protection bits by default
Date: Mon,  5 Oct 2009 17:14:47 -0400
Message-Id: <1254777289-32109-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc2
In-Reply-To: <1254777289-32109-1-git-send-email-vapier@gentoo.org>
References: <1254777289-32109-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

The SST SPI flashes is like Atmel SPI flashes in that the software
protection bits are set by default at power up, so clear them at init
time.

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/mtd/devices/m25p80.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index 379c316..933267a 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -775,11 +775,12 @@ static int __devinit m25p_probe(struct spi_device *spi)
 	dev_set_drvdata(&spi->dev, flash);
 
 	/*
-	 * Atmel serial flash tend to power up
-	 * with the software protection bits set
+	 * Atmel and SST serial flash tend to power
+	 * up with the software protection bits set
 	 */
 
-	if (info->jedec_id >> 16 == 0x1f) {
+	if (info->jedec_id >> 16 == 0x1f ||
+	    info->jedec_id >> 16 == 0xbf) {
 		write_enable(flash);
 		write_sr(flash, 0);
 	}
-- 
1.6.5.rc2

