Return-Path: <linux-kernel-owner+w=401wt.eu-S1760392AbXLTXmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760392AbXLTXmB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 18:42:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756312AbXLTXlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 18:41:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60290 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755965AbXLTXlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 18:41:44 -0500
Subject: patch pci-fix-warning-in-setup-res.c-on-32-bit-platforms-with-64-bit-resources.patch added to gregkh-2.6 tree
To: benh@kernel.crashing.org, greg@kroah.com, gregkh@suse.de,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
From: <gregkh@suse.de>
Date: Thu, 20 Dec 2007 15:37:17 -0800
In-Reply-To: <20071210063217.292B5DDE27@ozlabs.org>
Message-ID: <11981938373542@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: PCI: Fix warning in setup-res.c on 32-bit platforms with 64-bit resources

to my gregkh-2.6 tree.  Its filename is

     pci-fix-warning-in-setup-res.c-on-32-bit-platforms-with-64-bit-resources.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From benh@ozlabs.org Sun Dec  9 22:32:23 2007
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Mon, 10 Dec 2007 17:32:16 +1100
Subject: PCI: Fix warning in setup-res.c on 32-bit platforms with 64-bit resources
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, <linuxppc-dev@ozlabs.org>, <linux-kernel@vger.kernel.org>
Message-ID: <20071210063217.292B5DDE27@ozlabs.org>


This adds appropriate casts to avoid a warning and print the correct
values in pr_debug.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/setup-res.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -51,10 +51,12 @@ pci_update_resource(struct pci_dev *dev,
 
 	pcibios_resource_to_bus(dev, &region, res);
 
-	pr_debug("  got res [%llx:%llx] bus [%lx:%lx] flags %lx for "
+	pr_debug("  got res [%llx:%llx] bus [%llx:%llx] flags %lx for "
 		 "BAR %d of %s\n", (unsigned long long)res->start,
 		 (unsigned long long)res->end,
-		 region.start, region.end, res->flags, resno, pci_name(dev));
+		 (unsigned long long)region.start,
+		 (unsigned long long)region.end,
+		 (unsigned long)res->flags, resno, pci_name(dev));
 
 	new = region.start | (res->flags & PCI_REGION_FLAG_MASK);
 	if (res->flags & IORESOURCE_IO)


Patches currently in gregkh-2.6 which might be from benh@kernel.crashing.org are

bad/battery-class-driver.patch
driver/adb-convert-from-class_device-to-device.patch
driver/kobject-convert-hvc_console-to-use-kref-not-kobject.patch
driver/kobject-convert-hvcs-to-use-kref-not-kobject.patch
driver/kobject-convert-icom-to-use-kref-not-kobject.patch
pci/pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch
pci/pci-fix-warning-in-setup-res.c-on-32-bit-platforms-with-64-bit-resources.patch
usb/usb-remove-ohci-useless-masking-unmasking-of-wdh-interrupt.patch
