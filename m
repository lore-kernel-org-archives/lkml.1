Return-Path: <linux-kernel-owner+w=401wt.eu-S1756871AbYCUE3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbYCUE3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 00:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbYCUE2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 00:28:44 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36069 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbYCUE2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 00:28:42 -0400
Message-ID: <47E338E5.3020504@jp.fujitsu.com>
Date: Fri, 21 Mar 2008 13:26:13 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>, Greg KH <gregkh@suse.de>
CC: Gary Hade <garyhade@us.ibm.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Matthew Wilcox <matthew@wil.cx>, warthog19@eaglescrag.net,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
Subject: [PATCH 14/16] PCI slot: Change return value of pci_destroy_slot()
 (Not for mainline!)
References: <20080318210539.GA30421@ldl.fc.hp.com> <47E33472.1000602@jp.fujitsu.com>
In-Reply-To: <47E33472.1000602@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since nobody checks the return value from pci_destroy_slot(), it
should be void.

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

---
 drivers/pci/slot.c  |    4 +---
 include/linux/pci.h |    2 +-
 2 files changed, 2 insertions(+), 4 deletions(-)

Index: linux-2.6.25-rc6/drivers/pci/slot.c
===================================================================
--- linux-2.6.25-rc6.orig/drivers/pci/slot.c
+++ linux-2.6.25-rc6/drivers/pci/slot.c
@@ -118,7 +118,7 @@ struct pci_slot *pci_create_slot(struct 
 }
 EXPORT_SYMBOL_GPL(pci_create_slot);
 
-int pci_destroy_slot(struct pci_slot *slot)
+void pci_destroy_slot(struct pci_slot *slot)
 {
 	pr_debug("%s: decreased refcount to %d on %x:%d\n", __func__,
 		 atomic_read(&slot->kobj.kref.refcount) - 1, slot->bus->number,
@@ -127,8 +127,6 @@ int pci_destroy_slot(struct pci_slot *sl
 	down_write(&pci_bus_sem);
 	kobject_put(&slot->kobj);
 	up_write(&pci_bus_sem);
-
-	return 0;
 }
 EXPORT_SYMBOL_GPL(pci_destroy_slot);
 
Index: linux-2.6.25-rc6/include/linux/pci.h
===================================================================
--- linux-2.6.25-rc6.orig/include/linux/pci.h
+++ linux-2.6.25-rc6/include/linux/pci.h
@@ -493,7 +493,7 @@ struct pci_bus *pci_add_new_bus(struct p
 				int busnr);
 struct pci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,
 				 const char *name);
-int pci_destroy_slot(struct pci_slot *slot);
+void pci_destroy_slot(struct pci_slot *slot);
 int pci_scan_slot(struct pci_bus *bus, int devfn);
 struct pci_dev *pci_scan_single_device(struct pci_bus *bus, int devfn);
 void pci_device_add(struct pci_dev *dev, struct pci_bus *bus);


