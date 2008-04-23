Return-Path: <linux-kernel-owner+w=401wt.eu-S1754671AbYDWUz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbYDWUz3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 16:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbYDWUzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 16:55:21 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:33479 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbYDWUzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 16:55:20 -0400
Message-ID: <480FA234.1000601@tiscali.nl>
Date: Wed, 23 Apr 2008 22:55:16 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: galak@kernel.crashing.org, linuxppc-dev@ozlabs.org
CC: lkml <linux-kernel@vger.kernel.org>, dbrownell@users.sourceforge.net,
       spi-devel-general@lists.sourceforge.net
Subject: [PATCH 1/2] spi_mpc83xx: test below 0 on unsigned irq in mpc83xx_spi_probe()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mpc83xx_spi->irq is unsigned, so the test fails

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/spi/spi_mpc83xx.c b/drivers/spi/spi_mpc83xx.c
index be15a62..033fd51 100644
--- a/drivers/spi/spi_mpc83xx.c
+++ b/drivers/spi/spi_mpc83xx.c
@@ -454,12 +454,12 @@ static int __init mpc83xx_spi_probe(struct platform_device *dev)
 		goto put_master;
 	}
 
-	mpc83xx_spi->irq = platform_get_irq(dev, 0);
-
-	if (mpc83xx_spi->irq < 0) {
-		ret = -ENXIO;
+	ret = platform_get_irq(dev, 0);
+	if (ret < 0)
 		goto unmap_io;
-	}
+
+	mpc83xx_spi->irq = ret;
+	ret = 0;
 
 	/* Register for SPI Interrupt */
 	ret = request_irq(mpc83xx_spi->irq, mpc83xx_spi_irq,

