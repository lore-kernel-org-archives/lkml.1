Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966178Ab0BZVZX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 16:25:23 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:4860 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966163Ab0BZVZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 16:25:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=yDZC2dUdtcgxI93PdWwV3aCRtKQ1Ly+2HSf8gac8vblvkN7JZ8jucvoO0gp3Ati4Zx
         zuiIGA1/zGEJEPHPmMROG998uosw5diqoF8JWFUTiv/vvfM4x+AO2+CtTjdQez9LygQW
         YNqAPXwtwmaumItHEM762W8vdbEJ4RdlVsahA=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-mmc@vger.kernel.org
Cc: Vasily Khoruzhick <anarsoul@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] Subject: MMC: Enable DMA on Ricoh sdhci reader by default
Date: Fri, 26 Feb 2010 23:25:11 +0200
Message-Id: <1267219511-20657-1-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20100224120038.3f0ec412.akpm@linux-foundation.org>
References: <20100224120038.3f0ec412.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasily Khoruzhick <anarsoul@gmail.com>

This card reader doesn't advertise, however DMA works well.
Probably windows SDHCI driver assumes that all readers support DMA
and thus we see that bug.

Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
Tested-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mmc/host/sdhci-pci.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 5c3a176..12f5b09 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -80,9 +80,6 @@ struct sdhci_pci_chip {
 
 static int ricoh_probe(struct sdhci_pci_chip *chip)
 {
-	if (chip->pdev->subsystem_vendor == PCI_VENDOR_ID_IBM)
-		chip->quirks |= SDHCI_QUIRK_CLOCK_BEFORE_RESET;
-
 	if (chip->pdev->subsystem_vendor == PCI_VENDOR_ID_SAMSUNG ||
 	    chip->pdev->subsystem_vendor == PCI_VENDOR_ID_SONY)
 		chip->quirks |= SDHCI_QUIRK_NO_CARD_NO_RESET;
@@ -92,7 +89,9 @@ static int ricoh_probe(struct sdhci_pci_chip *chip)
 
 static const struct sdhci_pci_fixes sdhci_ricoh = {
 	.probe		= ricoh_probe,
-	.quirks		= SDHCI_QUIRK_32BIT_DMA_ADDR,
+	.quirks		= SDHCI_QUIRK_32BIT_DMA_ADDR |
+			  SDHCI_QUIRK_FORCE_DMA |
+			  SDHCI_QUIRK_CLOCK_BEFORE_RESET,
 };
 
 static const struct sdhci_pci_fixes sdhci_ene_712 = {
-- 
1.6.3.3

