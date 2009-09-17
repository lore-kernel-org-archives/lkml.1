Return-Path: <linux-kernel-owner+w=401wt.eu-S1754577AbZIQXsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbZIQXsH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 19:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754381AbZIQXsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 19:48:05 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:59095 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786AbZIQXrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 19:47:52 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: spi-devel-general@lists.sourceforge.net,
       David Brownell <dbrownell@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Wolfgang Muees <wolfgang.mues@auerswald.de>
Subject: [PATCH 3/5] Blackfin SPI: force sane state at boot
Date: Thu, 17 Sep 2009 19:47:51 -0400
Message-Id: <1253231273-16423-3-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc1
In-Reply-To: <1253231273-16423-1-git-send-email-vapier@gentoo.org>
References: <1253231273-16423-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfgang Muees <wolfgang.mues@auerswald.de>

We should make sure the SPI controller is in a sane state in case the
boot loader left it in a crappy state.  Such as DMA pending which causes
interrupts to fire on us.

Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/spi/spi_bfin5xx.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 5591bce..3249c5d 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -1334,6 +1334,12 @@ static int __init bfin_spi_probe(struct platform_device *pdev)
 		goto out_error_queue_alloc;
 	}
 
+	/* Reset SPI registers. If these registers were used by the boot loader,
+	 * the sky may fall on your head if you enable the dma controller.
+	 */
+	write_CTRL(drv_data, 0x0400);
+	write_FLAG(drv_data, 0xFF00);
+
 	/* Register with the SPI framework */
 	platform_set_drvdata(pdev, drv_data);
 	status = spi_register_master(master);
-- 
1.6.5.rc1

