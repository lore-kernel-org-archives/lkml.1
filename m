Return-Path: <linux-kernel-owner+w=401wt.eu-S1752329AbYJUEwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329AbYJUEwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 00:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbYJUEwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 00:52:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:39930 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbYJUEwC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 00:52:02 -0400
Date: Mon, 20 Oct 2008 21:52:15 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH] pci: use pci_ioremap_bar() in drivers/misc
Message-ID: <20081020215215.2296f72f@infradead.org>
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

>From 24499136286bd94ed96f938bd59442a6e0723903 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sun, 28 Sep 2008 16:15:14 -0700
Subject: [PATCH] pci: use pci_ioremap_bar() in drivers/misc

Use the newly introduced pci_ioremap_bar() function in drivers/misc.
pci_ioremap_bar() just takes a pci device and a bar number, with the goal
of making it really hard to get wrong, while also having a central place
to stick sanity checks.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/misc/ibmasm/module.c |    3 +--
 drivers/misc/tifm_7xx1.c     |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/ibmasm/module.c b/drivers/misc/ibmasm/module.c
index b5f6add..dc14b0b 100644
--- a/drivers/misc/ibmasm/module.c
+++ b/drivers/misc/ibmasm/module.c
@@ -104,8 +104,7 @@ static int __devinit ibmasm_init_one(struct pci_dev *pdev, const struct pci_devi
 	}
 
 	sp->irq = pdev->irq;
-	sp->base_address = ioremap(pci_resource_start(pdev, 0),
-					pci_resource_len(pdev, 0));
+	sp->base_address = pci_ioremap_bar(pdev, 0);
 	if (!sp->base_address) {
 		dev_err(sp->dev, "Failed to ioremap pci memory\n");
 		result =  -ENODEV;
diff --git a/drivers/misc/tifm_7xx1.c b/drivers/misc/tifm_7xx1.c
index 67503ea..af61733 100644
--- a/drivers/misc/tifm_7xx1.c
+++ b/drivers/misc/tifm_7xx1.c
@@ -354,8 +354,7 @@ static int tifm_7xx1_probe(struct pci_dev *dev,
 	fm->has_ms_pif = tifm_7xx1_has_ms_pif;
 	pci_set_drvdata(dev, fm);
 
-	fm->addr = ioremap(pci_resource_start(dev, 0),
-			   pci_resource_len(dev, 0));
+	fm->addr = pci_ioremap_bar(dev, 0);
 	if (!fm->addr)
 		goto err_out_free;
 
-- 
1.5.5.1



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
