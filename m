Return-Path: <linux-kernel-owner+w=401wt.eu-S1754250AbZCHCgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250AbZCHCgD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 21:36:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbZCHCfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 21:35:52 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:32450 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbZCHCfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 21:35:51 -0500
Date: Sat, 7 Mar 2009 19:35:47 -0700
From: Alex Chiang <achiang@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, rjw@sisk.pl, matthew@wil.cx
Cc: stable@kernel.org, linux-pci <linux-pci@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] PCIe: portdrv: call pci_disable_device during remove
Message-ID: <20090308023547.GB3575@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>, rjw@sisk.pl,
	matthew@wil.cx, stable@kernel.org,
	linux-pci <linux-pci@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCIe port driver calls pci_enable_device() during probe but
never calls pci_disable_device() during remove.

Cc: stable@kernel.org
Signed-off-by: Alex Chiang <achiang@hp.com>
---
This is a bug in the original PCIe port driver code, and should
be backported to the .27 and .28 stable series.

The implementation of the PCIe port driver is different in
linux-next, and I have a different patch for that.
---
diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
index 248b4db..5ea566e 100644
--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -103,6 +103,7 @@ static int __devinit pcie_portdrv_probe (struct pci_dev *dev,
 static void pcie_portdrv_remove (struct pci_dev *dev)
 {
 	pcie_port_device_remove(dev);
+	pci_disable_device(dev);
 	kfree(pci_get_drvdata(dev));
 }
 
