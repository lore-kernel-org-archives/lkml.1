Return-Path: <linux-kernel-owner+w=401wt.eu-S1756595AbZHQAXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbZHQAXb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 20:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756503AbZHQAX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 20:23:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46004 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210AbZHQAW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 20:22:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "linux-pm" <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH 5/7] PM: Asynchronous suspend and resume of PCI devices
Date: Mon, 17 Aug 2009 02:20:18 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: "linux-acpi" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@linux.intel.com>, Greg KH <gregkh@suse.de>
References: <200908122218.13975.rjw@sisk.pl> <200908170215.21173.rjw@sisk.pl>
In-Reply-To: <200908170215.21173.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908170220.18874.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set async_suspend for all PCI devices and PCIe port services.

---
 drivers/input/serio/i8042.c     |    2 ++
 drivers/pci/pci.c               |    2 ++
 drivers/pci/pcie/portdrv_core.c |    1 +
 3 files changed, 5 insertions(+)

Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -1409,6 +1409,8 @@ void pci_pm_init(struct pci_dev *dev)
 	} else {
 		dev->pme_support = 0;
 	}
+
+	device_enable_async_suspend(&dev->dev, true);
 }
 
 /**
Index: linux-2.6/drivers/pci/pcie/portdrv_core.c
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/portdrv_core.c
+++ linux-2.6/drivers/pci/pcie/portdrv_core.c
@@ -280,6 +280,7 @@ static void pcie_device_init(struct pci_
 	dev_set_name(device, "%s:pcie%02x",
 		 pci_name(parent), get_descriptor_id(port_type, service_type));
 	device->parent = &parent->dev;
+	device_enable_async_suspend(device, true);
 }
 
 /**
