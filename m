Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbZCISI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbZCISI2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 14:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbZCISIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 14:08:19 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:48097 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbZCISIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 14:08:18 -0400
Date: Mon, 9 Mar 2009 12:08:15 -0600
From: Alex Chiang <achiang@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, rjw@sisk.pl
Cc: linux-pci <linux-pci@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] PCIe portdrv: eliminate double kfree in remove path
Message-ID: <20090309180815.GH32589@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>, rjw@sisk.pl,
	linux-pci <linux-pci@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 55633af3 (PCIe portdrv: Use driver data to simplify code)
added a kfree of the driver private data in pcie_port_device_remove
but forgot to remove the old kfree from pcie_portdrv_remove.

Signed-off-by: Alex Chiang <achiang@hp.com>
---
diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
index a6fee6c..f2368b1 100644
--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -93,7 +93,6 @@ static int __devinit pcie_portdrv_probe (struct pci_dev *dev,
 static void pcie_portdrv_remove (struct pci_dev *dev)
 {
 	pcie_port_device_remove(dev);
-	kfree(pci_get_drvdata(dev));
 }
 
 static int error_detected_iter(struct device *device, void *data)
