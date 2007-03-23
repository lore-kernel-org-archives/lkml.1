Return-Path: <linux-kernel-owner+w=401wt.eu-S2992513AbXCWQPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992513AbXCWQPL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 12:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992511AbXCWQPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 12:15:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992514AbXCWQPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 12:15:09 -0400
Date: Fri, 23 Mar 2007 12:15:05 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tom.l.nguyen@intel.com, kristen.c.accardi@intel.com, ddutile@redhat.com
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20070323161505.10285.9944.sendpatchset@prarit.boston.redhat.com>
Subject: [PATCH]: Fix warning message in PCIE port driver
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

PCIE error output should conform to vendor_id:device_id.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
index 0be5a0b..df38364 100644
--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -93,7 +93,7 @@ static int __devinit pcie_portdrv_probe (struct pci_dev *dev,
         if (!dev->irq && dev->pin) {
 		printk(KERN_WARNING 
 		"%s->Dev[%04x:%04x] has invalid IRQ. Check vendor BIOS\n", 
-		__FUNCTION__, dev->device, dev->vendor);
+		__FUNCTION__, dev->vendor, dev->device);
 	}
 	if (pcie_port_device_register(dev)) {
 		pci_disable_device(dev);
