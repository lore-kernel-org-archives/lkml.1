Return-Path: <linux-kernel-owner+w=401wt.eu-S1753606AbXCZKO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606AbXCZKO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 06:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbXCZKO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 06:14:28 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:19349 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606AbXCZKO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 06:14:27 -0400
X-IronPort-AV: i="4.14,329,1170651600"; 
   d="scan'208"; a="32577561:sNHT20831104"
Subject: [PATCH -mm] Blackfin: spi driver fix reboot kernel mounting spi
	flash print error bug
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: dbrownell@users.sourceforge.net, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Mon, 26 Mar 2007 18:14:59 +0800
Message-Id: <1174904099.32691.79.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

This patch fix a printing error bug when reboot kernel mounting on SPI
flash.

Signed-off-by: Bryan Wu <bryan.wu@analog.com> 
---

 drivers/spi/spi_bfin5xx.c |    9 ---------
 1 file changed, 9 deletions(-)

Index: linux-2.6/drivers/spi/spi_bfin5xx.c
===================================================================
--- linux-2.6.orig/drivers/spi/spi_bfin5xx.c
+++ linux-2.6/drivers/spi/spi_bfin5xx.c
@@ -1167,14 +1167,6 @@
 	return 0;
 }
 
-static void bfin5xx_spi_shutdown(struct platform_device *pdev)
-{
-	int status = 0;
-
-	if ((status = bfin5xx_spi_remove(pdev)) != 0)
-		dev_err(&pdev->dev, "shutdown failed with %d\n", status);
-}
-
 /* PM, do nothing now */
 #ifdef CONFIG_PM
 static int suspend_devices(struct device *dev, void *pm_message)
@@ -1242,7 +1234,6 @@
 	},
 	.probe = bfin5xx_spi_probe,
 	.remove = __devexit_p(bfin5xx_spi_remove),
-	.shutdown = bfin5xx_spi_shutdown,
 	.suspend = bfin5xx_spi_suspend,
 	.resume = bfin5xx_spi_resume,
 };
_

Thanks,
-Bryan Wu
