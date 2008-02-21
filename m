Return-Path: <linux-kernel-owner+w=401wt.eu-S932627AbYBUNTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627AbYBUNTp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 08:19:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752979AbYBUNTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 08:19:37 -0500
Received: from 75.neteffect.com ([204.57.75.75]:63880 "EHLO
	velma.neteffect.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752805AbYBUNTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 08:19:37 -0500
Date: Thu, 21 Feb 2008 08:13:47 -0600
From: gstreiff@neteffect.com
Message-Id: <200802211413.m1LEDlts005057@velma.neteffect.com>
To: rdreier@cisco.com
Subject: [PATCH 2.6 4/8] infiniband/hw/nes/nes.c: fix a check-after-use
Cc: bunk@kernel.org, general@lists.openfabrics.org,
       linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>

This patch fixes a check-after-use spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Glenn Streiff <gstreiff@neteffect.com>

---
 drivers/infiniband/hw/nes/nes.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
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
