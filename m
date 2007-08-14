Return-Path: <linux-kernel-owner+w=401wt.eu-S1761360AbXHNVpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761360AbXHNVpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758510AbXHNV0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:26:22 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:45844 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758073AbXHNV0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:26:19 -0400
Date: Tue, 14 Aug 2007 23:26:09 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, gregkh@suse.de
Cc: linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/pci/: possible cleanups
Message-ID: <20070814212609.GX18945@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following possible cleanups:
- make the following needlessly global function static:
  - pci.c: pci_restore_bars()
- #if 0 the following unused global functions:
  - rom.c: pci_map_rom_copy()
  - rom.c: pci_remove_rom()
- remove the following unused EXPORT_SYMBOL's:
 - pci-acpi.c: pci_osc_support_set
 - proc.c: pci_proc_detach_bus
- remove the following unused EXPORT_SYMBOL_GPL's:
  - bus.c: pci_walk_bus
  - probe.c: pci_create_bus
  - setup-res.c: pci_claim_resource

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 13 Jul 2007

 drivers/pci/bus.c       |    1 -
 drivers/pci/pci-acpi.c  |    1 -
 drivers/pci/pci.c       |    3 +--
 drivers/pci/probe.c     |    1 -
 drivers/pci/proc.c      |    4 ----
 drivers/pci/rom.c       |    6 ++++--
 drivers/pci/setup-res.c |    1 -
 include/linux/pci.h     |    3 ---
 8 files changed, 5 insertions(+), 15 deletions(-)

--- linux-2.6.22-rc6-mm1/include/linux/pci.h.old	2007-07-11 22:41:06.000000000 +0200
+++ linux-2.6.22-rc6-mm1/include/linux/pci.h	2007-07-11 22:49:32.000000000 +0200
@@ -562,14 +562,11 @@
 void pci_update_resource(struct pci_dev *dev, struct resource *res, int resno);
 int __must_check pci_assign_resource(struct pci_dev *dev, int i);
 int __must_check pci_assign_resource_fixed(struct pci_dev *dev, int i);
-void pci_restore_bars(struct pci_dev *dev);
 int pci_select_bars(struct pci_dev *dev, unsigned long flags);
 
 /* ROM control related routines */
 void __iomem __must_check *pci_map_rom(struct pci_dev *pdev, size_t *size);
-void __iomem __must_check *pci_map_rom_copy(struct pci_dev *pdev, size_t *size);
 void pci_unmap_rom(struct pci_dev *pdev, void __iomem *rom);
-void pci_remove_rom(struct pci_dev *pdev);
 
 /* Power management related routines */
 int pci_save_state(struct pci_dev *dev);
--- linux-2.6.22-rc6-mm1/drivers/pci/bus.c.old	2007-07-11 22:37:40.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/pci/bus.c	2007-07-11 22:37:47.000000000 +0200
@@ -204,7 +204,6 @@
 	}
 	up_read(&pci_bus_sem);
 }
-EXPORT_SYMBOL_GPL(pci_walk_bus);
 
 EXPORT_SYMBOL(pci_bus_alloc_resource);
 EXPORT_SYMBOL_GPL(pci_bus_add_device);
--- linux-2.6.22-rc6-mm1/drivers/pci/pci-acpi.c.old	2007-07-11 22:38:44.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/pci/pci-acpi.c	2007-07-11 22:38:51.000000000 +0200
@@ -188,7 +188,6 @@
 	}
 	return AE_OK;
 }
-EXPORT_SYMBOL(pci_osc_support_set);
 
 /**
  * pci_osc_control_set - commit requested control to Firmware
--- linux-2.6.22-rc6-mm1/drivers/pci/pci.c.old	2007-07-11 22:41:30.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/pci/pci.c	2007-07-11 22:41:39.000000000 +0200
@@ -348,7 +348,7 @@
  * Restore the BAR values for a given device, so as to make it
  * accessible by its driver.
  */
-void
+static void
 pci_restore_bars(struct pci_dev *dev)
 {
 	int i, numres;
@@ -1612,7 +1612,6 @@
 
 device_initcall(pci_init);
 
-EXPORT_SYMBOL_GPL(pci_restore_bars);
 EXPORT_SYMBOL(pci_enable_device_bars);
 EXPORT_SYMBOL(pci_enable_device);
 EXPORT_SYMBOL(pcim_enable_device);
--- linux-2.6.22-rc6-mm1/drivers/pci/probe.c.old	2007-07-11 22:42:15.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/pci/probe.c	2007-07-11 22:42:22.000000000 +0200
@@ -1205,7 +1205,6 @@
 	kfree(b);
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(pci_create_bus);
 
 struct pci_bus *pci_scan_bus_parented(struct device *parent,
 		int bus, struct pci_ops *ops, void *sysdata)
--- linux-2.6.22-rc6-mm1/drivers/pci/proc.c.old	2007-07-11 22:46:05.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/pci/proc.c	2007-07-11 22:46:15.000000000 +0200
@@ -479,7 +479,3 @@
 
 __initcall(pci_proc_init);
 
-#ifdef CONFIG_HOTPLUG
-EXPORT_SYMBOL(pci_proc_detach_bus);
-#endif
-
--- linux-2.6.22-rc6-mm1/drivers/pci/rom.c.old	2007-07-11 22:48:58.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/pci/rom.c	2007-07-11 22:49:52.000000000 +0200
@@ -147,6 +147,7 @@
 	return rom;
 }
 
+#if 0
 /**
  * pci_map_rom_copy - map a PCI ROM to kernel space, create a copy
  * @pdev: pointer to pci device struct
@@ -181,6 +182,7 @@
 
 	return (void __iomem *)(unsigned long)res->start;
 }
+#endif  /*  0  */
 
 /**
  * pci_unmap_rom - unmap the ROM from kernel space
@@ -203,6 +205,7 @@
 		pci_disable_rom(pdev);
 }
 
+#if 0
 /**
  * pci_remove_rom - disable the ROM and remove its sysfs attribute
  * @pdev: pointer to pci device struct
@@ -221,6 +224,7 @@
 			    IORESOURCE_ROM_COPY)))
 		pci_disable_rom(pdev);
 }
+#endif  /*  0  */
 
 /**
  * pci_cleanup_rom - internal routine for freeing the ROM copy created
@@ -241,6 +245,4 @@
 }
 
 EXPORT_SYMBOL(pci_map_rom);
-EXPORT_SYMBOL(pci_map_rom_copy);
 EXPORT_SYMBOL(pci_unmap_rom);
-EXPORT_SYMBOL(pci_remove_rom);
--- linux-2.6.22-rc6-mm1/drivers/pci/setup-res.c.old	2007-07-11 22:50:55.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/pci/setup-res.c	2007-07-11 22:51:01.000000000 +0200
@@ -125,7 +125,6 @@
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(pci_claim_resource);
 
 int pci_assign_resource(struct pci_dev *dev, int resno)
 {


