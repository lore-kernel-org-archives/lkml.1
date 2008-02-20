Return-Path: <linux-kernel-owner+w=401wt.eu-S1763717AbYBTAPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763717AbYBTAPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 19:15:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756750AbYBTAOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 19:14:25 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:41108 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756103AbYBTAOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 19:14:24 -0500
Date: Wed, 20 Feb 2008 02:13:47 +0200
From: Adrian Bunk <bunk@kernel.org>
To: flatif@neteffect.com, gstreiff@neteffect.com
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] infiniband/hw/nes/nes.c: fix a check-after-use
Message-ID: <20080220001347.GU31955@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a check-after-use spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
e9468c7fb623f63582f5522493f6a43ab904e061 diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
index 7f8853b..b2112f5 100644
--- a/drivers/infiniband/hw/nes/nes.c
+++ b/drivers/infiniband/hw/nes/nes.c
@@ -567,12 +567,12 @@ static int __devinit nes_probe(struct pci_dev *pcidev, const struct pci_device_i
 
 	/* Init the adapter */
 	nesdev->nesadapter = nes_init_adapter(nesdev, hw_rev);
-	nesdev->nesadapter->et_rx_coalesce_usecs_irq = interrupt_mod_interval;
 	if (!nesdev->nesadapter) {
 		printk(KERN_ERR PFX "Unable to initialize adapter.\n");
 		ret = -ENOMEM;
 		goto bail5;
 	}
+	nesdev->nesadapter->et_rx_coalesce_usecs_irq = interrupt_mod_interval;
 
 	/* nesdev->base_doorbell_index =
 			nesdev->nesadapter->pd_config_base[PCI_FUNC(nesdev->pcidev->devfn)]; */

