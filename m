Return-Path: <linux-kernel-owner+w=401wt.eu-S1757708AbYHYWCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757708AbYHYWCz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 18:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757264AbYHYWCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 18:02:08 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:9313 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbYHYWCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 18:02:07 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: [PATCH 5/5] PCI: follow lspci device/vendor style
To: linux-kernel@vger.kernel.org
Date: Mon, 25 Aug 2008 16:02:03 -0600
Message-ID: <20080825220203.19210.80497.stgit@tigger.helgaas>
In-Reply-To: <20080825220137.19210.41857.stgit@tigger.helgaas>
References: <20080825220137.19210.41857.stgit@tigger.helgaas>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use "[%04x:%04x]" for PCI vendor/device IDs to follow the format
used by lspci(8).

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 drivers/pci/pcie/portdrv_pci.c |    2 +-
 drivers/pci/probe.c            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
index 367c9c2..584422d 100644
--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -91,7 +91,7 @@ static int __devinit pcie_portdrv_probe (struct pci_dev *dev,
 	
 	pci_set_master(dev);
         if (!dev->irq && dev->pin) {
-		dev_warn(&dev->dev, "device [%04x/%04x] has invalid IRQ; "
+		dev_warn(&dev->dev, "device [%04x:%04x] has invalid IRQ; "
 			 "check vendor BIOS\n", dev->vendor, dev->device);
 	}
 	if (pcie_port_device_register(dev)) {
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index cce2f4c..d58078c 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -752,7 +752,7 @@ static int pci_setup_device(struct pci_dev * dev)
 	dev->class = class;
 	class >>= 8;
 
-	dev_dbg(&dev->dev, "found [%04x/%04x] class %06x header type %02x\n",
+	dev_dbg(&dev->dev, "found [%04x:%04x] class %06x header type %02x\n",
 		 dev->vendor, dev->device, class, dev->hdr_type);
 
 	/* "Unknown power state" */

