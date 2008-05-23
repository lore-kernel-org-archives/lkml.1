Return-Path: <linux-kernel-owner+w=401wt.eu-S1759260AbYEWS2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260AbYEWS2q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 14:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753356AbYEWS2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 14:28:36 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:2958 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752614AbYEWS2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 14:28:35 -0400
Date: Fri, 23 May 2008 22:28:34 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>
Cc: Gary Jennejohn <garyj@denx.de>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/2] mmc_spi: export probe and remove functions
Message-ID: <20080523182834.GA469@polina.dev.rtsoft.ru>
References: <20080523182754.GA26891@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080523182754.GA26891@polina.dev.rtsoft.ru>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...so we'll able to write bindings for the OpenFirmware without
messing with #ifdefs in the driver itself.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/mmc/host/mmc_spi.c |    6 ++++--
 drivers/mmc/host/mmc_spi.h |    7 +++++++
 2 files changed, 11 insertions(+), 2 deletions(-)
 create mode 100644 drivers/mmc/host/mmc_spi.h

diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index 85d9853..f2c4fc2 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -1184,7 +1184,7 @@ static int maybe_count_child(struct device *dev, void *c)
 	return 0;
 }
 
-static int mmc_spi_probe(struct spi_device *spi)
+int mmc_spi_probe(struct spi_device *spi)
 {
 	void			*ones;
 	struct mmc_host		*mmc;
@@ -1366,9 +1366,10 @@ nomem:
 	kfree(ones);
 	return status;
 }
+EXPORT_SYMBOL(mmc_spi_probe);
 
 
-static int __devexit mmc_spi_remove(struct spi_device *spi)
+int __devexit mmc_spi_remove(struct spi_device *spi)
 {
 	struct mmc_host		*mmc = dev_get_drvdata(&spi->dev);
 	struct mmc_spi_host	*host;
@@ -1398,6 +1399,7 @@ static int __devexit mmc_spi_remove(struct spi_device *spi)
 	}
 	return 0;
 }
+EXPORT_SYMBOL(mmc_spi_remove);
 
 
 static struct spi_driver mmc_spi_driver = {
diff --git a/drivers/mmc/host/mmc_spi.h b/drivers/mmc/host/mmc_spi.h
new file mode 100644
index 0000000..d4fcd91
--- /dev/null
+++ b/drivers/mmc/host/mmc_spi.h
@@ -0,0 +1,7 @@
+#ifndef __DRIVERS_MMC_HOST_MMC_SPI_H
+#define __DRIVERS_MMC_HOST_MMC_SPI_H
+
+extern int mmc_spi_probe(struct spi_device *spi);
+extern int __devexit mmc_spi_remove(struct spi_device *spi);
+
+#endif
-- 
1.5.5.1

