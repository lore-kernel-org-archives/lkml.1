Return-Path: <linux-kernel-owner+w=401wt.eu-S1752601AbYJUE4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbYJUE4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 00:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750874AbYJUE4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 00:56:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:41929 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbYJUE4N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 00:56:13 -0400
Date: Mon, 20 Oct 2008 21:56:24 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: drzeus-mmc@drzeus.cx
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] pci: use pci_ioremap_bar() in drivers/mmc
Message-ID: <20081020215624.18c5b604@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6fc220a25ecbb0576179c6b4472e7262389b25e8 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sun, 28 Sep 2008 16:15:56 -0700
Subject: [PATCH] pci: use pci_ioremap_bar() in drivers/mmc

Use the new pci_ioremap_bar() function in drivers/mmc.
pci_ioremap_bar() just takes a pci device and a bar number, with the goal
of making it really hard to get wrong, while also having a central place
to stick sanity checks.

CC: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/mmc/host/sdhci-pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 9bd7026..f07255c 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -545,7 +545,7 @@ static struct sdhci_pci_slot * __devinit sdhci_pci_probe_slot(
 	}
 
 	addr = pci_resource_start(pdev, bar);
-	host->ioaddr = ioremap_nocache(addr, pci_resource_len(pdev, bar));
+	host->ioaddr = pci_ioremap_bar(pdev, bar);
 	if (!host->ioaddr) {
 		dev_err(&pdev->dev, "failed to remap registers\n");
 		goto release;
-- 
1.5.5.1



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
