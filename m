Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325AbZHZU1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbZHZU1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 16:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbZHZU1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 16:27:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35932 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178AbZHZU13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 16:27:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "linux-pm" <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 4/6] PM: Allow PCI devices to suspend/resume asynchronously
Date: Wed, 26 Aug 2009 22:22:31 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Zhang Rui <rui.zhang@intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <200908262217.19609.rjw@sisk.pl>
In-Reply-To: <200908262217.19609.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908262222.31789.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Set async_suspend for all PCI devices and PCIe port services, so that
they can be suspended and resumed asynchronously with other devices
they don't depend on in a known way (i.e. devices which are not their
parents or children and to which they are not connected via struct
pm_link objects).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci.c               |    1 +
 drivers/pci/pcie/portdrv_core.c |    1 +
 2 files changed, 2 insertions(+)

Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -1360,6 +1360,7 @@ void pci_pm_init(struct pci_dev *dev)
 	int pm;
 	u16 pmc;
 
+	device_enable_async_suspend(&dev->dev, true);
 	dev->pm_cap = 0;
 
 	/* find PCI PM capability in list */
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

