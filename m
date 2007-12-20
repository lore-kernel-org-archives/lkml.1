Return-Path: <linux-kernel-owner+w=401wt.eu-S1758553AbXLTEb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553AbXLTEb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 23:31:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754945AbXLTEap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 23:30:45 -0500
Received: from ozlabs.org ([203.10.76.45]:57521 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754893AbXLTEao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 23:30:44 -0500
To: Greg Kroah-Hartman <greg@kroah.com>
CC: linux-pci@atrey.karlin.mff.cuni.cz, <linux-kernel@vger.kernel.org>,
       <ink@jurassic.park.msu.ru>, Alan Cox <alan@redhat.com>,
       <james.smart@emulex.com>, <linux-driver@qlogic.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 20 Dec 2007 15:28:10 +1100
Subject: [PATCH 3/3] pci: Remove pci_enable_device_bars()
Message-Id: <20071220042812.706D0DDEE7@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all in-tree users are gone, this removes pci_enable_device_bars()
completely.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

 drivers/pci/pci.c   |   24 ------------------------
 include/linux/pci.h |    1 -
 2 files changed, 25 deletions(-)

--- linux-work.orig/drivers/pci/pci.c	2007-12-18 11:01:20.000000000 +1100
+++ linux-work/drivers/pci/pci.c	2007-12-18 11:01:28.000000000 +1100
@@ -713,29 +713,6 @@ int pci_reenable_device(struct pci_dev *
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
@@ -1665,7 +1642,6 @@ device_initcall(pci_init);
 
 EXPORT_SYMBOL_GPL(pci_restore_bars);
 EXPORT_SYMBOL(pci_reenable_device);
-EXPORT_SYMBOL(pci_enable_device_bars);
 EXPORT_SYMBOL(pci_enable_device_io);
 EXPORT_SYMBOL(pci_enable_device_mem);
 EXPORT_SYMBOL(pci_enable_device);
Index: linux-work/include/linux/pci.h
===================================================================
--- linux-work.orig/include/linux/pci.h	2007-12-18 11:00:33.000000000 +1100
+++ linux-work/include/linux/pci.h	2007-12-18 11:01:28.000000000 +1100
@@ -547,7 +547,6 @@ static inline int pci_write_config_dword
 }
 
 int __must_check pci_enable_device(struct pci_dev *dev);
-int __must_check pci_enable_device_bars(struct pci_dev *dev, int mask);
 int __must_check pci_enable_device_io(struct pci_dev *dev);
 int __must_check pci_enable_device_mem(struct pci_dev *dev);
 int __must_check pci_reenable_device(struct pci_dev *);
