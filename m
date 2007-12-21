Return-Path: <linux-kernel-owner+w=401wt.eu-S1764652AbXLUDCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764652AbXLUDCX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 22:02:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756219AbXLUDBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 22:01:55 -0500
Received: from mx1.suse.de ([195.135.220.2]:53798 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753161AbXLUDBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 22:01:54 -0500
Subject: patch pci-remove-pci_enable_device_bars.patch added to gregkh-2.6 tree
To: benh@kernel.crashing.org, alan@redhat.com, bzolnier@gmail.com,
       greg@kroah.com, gregkh@suse.de, ink@jurassic.park.msu.ru,
       james.smart@emulex.com, linux-driver@qlogic.com,
       linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Thu, 20 Dec 2007 18:59:16 -0800
In-Reply-To: <20071220042812.706D0DDEE7@ozlabs.org>
Message-ID: <11982059561825@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: PCI: Remove pci_enable_device_bars()

to my gregkh-2.6 tree.  Its filename is

     pci-remove-pci_enable_device_bars.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From owner-linux-pci@atrey.karlin.mff.cuni.cz Wed Dec 19 20:30:57 2007
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 20 Dec 2007 15:28:10 +1100
Subject: PCI: Remove pci_enable_device_bars()
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, <linux-kernel@vger.kernel.org>, <ink@jurassic.park.msu.ru>, Alan Cox <alan@redhat.com>, <james.smart@emulex.com>, <linux-driver@qlogic.com>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Message-ID: <20071220042812.706D0DDEE7@ozlabs.org>


Now that all in-tree users are gone, this removes pci_enable_device_bars()
completely.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/pci.c   |   24 ------------------------
 include/linux/pci.h |    1 -
 2 files changed, 25 deletions(-)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -741,29 +741,6 @@ int pci_reenable_device(struct pci_dev *
 	return 0;
 }
 
-/**
- * pci_enable_device_bars - Initialize some of a device for use
- * @dev: PCI device to be initialized
- * @bars: bitmask of BAR's that must be configured
- *
- *  Initialize device before it's used by a driver. Ask low-level code
- *  to enable selected I/O and memory resources. Wake up the device if it
- *  was suspended. Beware, this function can fail.
- */
-int
-pci_enable_device_bars(struct pci_dev *dev, int bars)
-{
-	int err;
-
-	if (atomic_add_return(1, &dev->enable_cnt) > 1)
-		return 0;		/* already enabled */
-
-	err = do_pci_enable_device(dev, bars);
-	if (err < 0)
-		atomic_dec(&dev->enable_cnt);
-	return err;
-}
-
 static int __pci_enable_device_flags(struct pci_dev *dev,
 				     resource_size_t flags)
 {
@@ -1695,7 +1672,6 @@ early_param("pci", pci_setup);
 device_initcall(pci_init);
 
 EXPORT_SYMBOL(pci_reenable_device);
-EXPORT_SYMBOL(pci_enable_device_bars);
 EXPORT_SYMBOL(pci_enable_device_io);
 EXPORT_SYMBOL(pci_enable_device_mem);
 EXPORT_SYMBOL(pci_enable_device);
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -543,7 +543,6 @@ static inline int pci_write_config_dword
 }
 
 int __must_check pci_enable_device(struct pci_dev *dev);
-int __must_check pci_enable_device_bars(struct pci_dev *dev, int mask);
 int __must_check pci_enable_device_io(struct pci_dev *dev);
 int __must_check pci_enable_device_mem(struct pci_dev *dev);
 int __must_check pci_reenable_device(struct pci_dev *);


Patches currently in gregkh-2.6 which might be from benh@kernel.crashing.org are

bad/battery-class-driver.patch
driver/adb-convert-from-class_device-to-device.patch
driver/kobject-convert-hvc_console-to-use-kref-not-kobject.patch
driver/kobject-convert-hvcs-to-use-kref-not-kobject.patch
driver/kobject-convert-icom-to-use-kref-not-kobject.patch
pci/pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch
pci/pci-fix-warning-in-setup-res.c-on-32-bit-platforms-with-64-bit-resources.patch
pci/pci-add-pci_enable_device_-io-mem-intefaces.patch
pci/pci-remove-pci_enable_device_bars.patch
pci/pci-remove-users-of-pci_enable_device_bars.patch
usb/usb-remove-ohci-useless-masking-unmasking-of-wdh-interrupt.patch
