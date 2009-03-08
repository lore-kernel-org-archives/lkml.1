Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbZCHErA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbZCHErA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 23:47:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755423AbZCHEqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 23:46:52 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:29919 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391AbZCHEqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 23:46:51 -0500
Date: Sat, 7 Mar 2009 21:46:49 -0700
From: Alex Chiang <achiang@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci <linux-pci@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] PCIe: portdrv: call pci_disable_device during remove
Message-ID: <20090308044649.GC3575@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	linux-pci <linux-pci@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCIe port driver calls pci_enable_device when registering
ports, but never calls pci_disable_device during removal.

Signed-off-by: Alex Chiang <achiang@hp.com>
---
This patch is against jbarnes's linux-next branch.
---
diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
index 5a5bfe7..e399825 100644
--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -473,6 +473,7 @@ void pcie_port_device_remove(struct pci_dev *dev)
 	struct pcie_port_data *port_data = pci_get_drvdata(dev);
 
 	device_for_each_child(&dev->dev, NULL, remove_iter);
+	pci_disable_device(dev);
 
 	switch (port_data->port_irq_mode) {
 	case PCIE_PORT_MSIX_MODE:
