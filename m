Return-Path: <linux-kernel-owner+w=401wt.eu-S1755756AbYKCUK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756AbYKCUK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 15:10:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbYKCUKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 15:10:14 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:36626 "EHLO
	teyla.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754169AbYKCUKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 15:10:13 -0500
Message-Id: <20081103201010.165171320@fluff.org.uk>
References: <20081103200944.099353331@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Mon, 03 Nov 2008 20:09:46 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: drzeus-mmc@drzeus.cx, sdhci-devel@list.drzeus.cx,
       Ben Dooks <ben-linux@fluff.org>
Subject: [patch 2/7] SDHCI: Print ADMA status and pointer on debug
Content-Disposition: inline; filename=simtec/s3c64xx/sdhci-print-adma-status-if-enabled.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If using ADMA, then we should print the ADMA error
and current pointer in sdhci_dumpregs() when any
debug is requested.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

--- linux.git.orig/drivers/mmc/host/sdhci.c	2008-10-27 08:17:43.000000000 +0000
+++ linux.git/drivers/mmc/host/sdhci.c	2008-10-27 11:01:20.000000000 +0000
@@ -73,6 +73,11 @@ static void sdhci_dumpregs(struct sdhci_
 		readl(host->ioaddr + SDHCI_CAPABILITIES),
 		readl(host->ioaddr + SDHCI_MAX_CURRENT));
 
+	if (host->flags & SDHCI_USE_ADMA)
+		printk(KERN_DEBUG DRIVER_NAME ": ADMA Err: 0x%08x | ADMA Ptr: 0x%08x\n",
+		       readl(host->ioaddr + SDHCI_ADMA_ERROR),
+		       readl(host->ioaddr + SDHCI_ADMA_ADDRESS));
+
 	printk(KERN_DEBUG DRIVER_NAME ": ===========================================\n");
 }
 

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
