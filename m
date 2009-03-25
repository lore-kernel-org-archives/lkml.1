Return-Path: <linux-kernel-owner+w=401wt.eu-S1755614AbZCYA3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614AbZCYA3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbZCYA3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:29:34 -0400
Received: from kroah.org ([198.145.64.141]:54030 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753084AbZCYA3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:29:33 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, dougthompson@xmission.com,
       bluesmoke-devel@lists.sourceforge.net
Subject: [PATCH 01/61] edac: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue, 24 Mar 2009 17:26:05 -0700
Message-Id: <1237940825-22904-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Cc: dougthompson@xmission.com
Cc: bluesmoke-devel@lists.sourceforge.net
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/edac/cell_edac.c    |    2 +-
 drivers/edac/mpc85xx_edac.c |    2 +-
 drivers/edac/mv64x60_edac.c |    8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/edac/cell_edac.c b/drivers/edac/cell_edac.c
index 24f3ca8..cb0f639 100644
--- a/drivers/edac/cell_edac.c
+++ b/drivers/edac/cell_edac.c
@@ -198,7 +198,7 @@ static int __devinit cell_edac_probe(struct platform_device *pdev)
 	mci->edac_cap = EDAC_FLAG_EC | EDAC_FLAG_SECDED;
 	mci->mod_name = "cell_edac";
 	mci->ctl_name = "MIC";
-	mci->dev_name = pdev->dev.bus_id;
+	mci->dev_name = dev_name(&pdev->dev);
 	mci->edac_check = cell_edac_check;
 	cell_edac_init_csrows(mci);
 
diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index 853ef37..4637a4a 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -218,7 +218,7 @@ static int __devinit mpc85xx_pci_err_probe(struct of_device *op,
 	pci->dev = &op->dev;
 	pci->mod_name = EDAC_MOD_STR;
 	pci->ctl_name = pdata->name;
-	pci->dev_name = op->dev.bus_id;
+	pci->dev_name = dev_name(&op->dev);
 
 	if (edac_op_state == EDAC_OPSTATE_POLL)
 		pci->edac_check = mpc85xx_pci_check;
diff --git a/drivers/edac/mv64x60_edac.c b/drivers/edac/mv64x60_edac.c
index 083ce8d..5131aaa 100644
--- a/drivers/edac/mv64x60_edac.c
+++ b/drivers/edac/mv64x60_edac.c
@@ -121,7 +121,7 @@ static int __devinit mv64x60_pci_err_probe(struct platform_device *pdev)
 	pdata->irq = NO_IRQ;
 	platform_set_drvdata(pdev, pci);
 	pci->dev = &pdev->dev;
-	pci->dev_name = pdev->dev.bus_id;
+	pci->dev_name = dev_name(&pdev->dev);
 	pci->mod_name = EDAC_MOD_STR;
 	pci->ctl_name = pdata->name;
 
@@ -294,7 +294,7 @@ static int __devinit mv64x60_sram_err_probe(struct platform_device *pdev)
 	pdata->irq = NO_IRQ;
 	edac_dev->dev = &pdev->dev;
 	platform_set_drvdata(pdev, edac_dev);
-	edac_dev->dev_name = pdev->dev.bus_id;
+	edac_dev->dev_name = dev_name(&pdev->dev);
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!r) {
@@ -462,7 +462,7 @@ static int __devinit mv64x60_cpu_err_probe(struct platform_device *pdev)
 	pdata->irq = NO_IRQ;
 	edac_dev->dev = &pdev->dev;
 	platform_set_drvdata(pdev, edac_dev);
-	edac_dev->dev_name = pdev->dev.bus_id;
+	edac_dev->dev_name = dev_name(&pdev->dev);
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!r) {
@@ -713,7 +713,7 @@ static int __devinit mv64x60_mc_err_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, mci);
 	pdata->name = "mv64x60_mc_err";
 	pdata->irq = NO_IRQ;
-	mci->dev_name = pdev->dev.bus_id;
+	mci->dev_name = dev_name(&pdev->dev);
 	pdata->edac_idx = edac_mc_idx++;
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-- 
1.6.2

