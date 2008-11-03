Return-Path: <linux-kernel-owner+w=401wt.eu-S1756695AbYKCULx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbYKCULx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 15:11:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628AbYKCUKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 15:10:20 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:36616 "EHLO
	teyla.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754199AbYKCUKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 15:10:13 -0500
Message-Id: <20081103201010.314538796@fluff.org.uk>
References: <20081103200944.099353331@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Mon, 03 Nov 2008 20:09:47 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: drzeus-mmc@drzeus.cx, sdhci-devel@list.drzeus.cx,
       Ben Dooks <ben-linux@fluff.org>
Subject: [patch 3/7] SDHCI: Add set_ios hook
Content-Disposition: inline; filename=simtec/s3c64xx/sdhci-add-ios-hook.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a set_ios hook which is called when the SDHCI driver
is called to change parameters such as clock or card
width.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

--- linux.git.orig/drivers/mmc/host/sdhci.c	2008-10-28 08:35:50.000000000 +0000
+++ linux.git/drivers/mmc/host/sdhci.c	2008-10-28 08:35:51.000000000 +0000
@@ -1038,6 +1038,9 @@ static void sdhci_set_ios(struct mmc_hos
 		sdhci_init(host);
 	}
 
+	if (host->ops->set_ios)
+		host->ops->set_ios(host, ios);
+
 	sdhci_set_clock(host, ios->clock);
 
 	if (ios->power_mode == MMC_POWER_OFF)
--- linux.git.orig/drivers/mmc/host/sdhci.h	2008-10-28 08:31:30.000000000 +0000
+++ linux.git/drivers/mmc/host/sdhci.h	2008-10-28 08:35:51.000000000 +0000
@@ -269,6 +269,9 @@ struct sdhci_ops {
 	int		(*enable_dma)(struct sdhci_host *host);
 	unsigned int	(*get_max_clock)(struct sdhci_host *host);
 	unsigned int	(*get_timeout_clock)(struct sdhci_host *host);
+
+	void		(*set_ios)(struct sdhci_host *host,
+				   struct mmc_ios *ios);
 };
 
 

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
