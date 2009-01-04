Return-Path: <linux-kernel-owner+w=401wt.eu-S1758290AbZADXBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290AbZADXBp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 18:01:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbZADXBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 18:01:31 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49613 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbZADXBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 18:01:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 3/8] PCI PCIe portdrv: Remove unused device extension
Date: Sun, 4 Jan 2009 23:51:06 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: Linux PCI <linux-pci@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <200901042346.42723.rjw@sisk.pl>
In-Reply-To: <200901042346.42723.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901042351.07144.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

There is struct pcie_port_device_ext defined in portdrv.h, but its
member is only initialized and never used.  Remove it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pcie/portdrv.h      |    4 ----
 drivers/pci/pcie/portdrv_core.c |    8 --------
 2 files changed, 12 deletions(-)

Index: linux-2.6/drivers/pci/pcie/portdrv.h
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/portdrv.h
+++ linux-2.6/drivers/pci/pcie/portdrv.h
@@ -28,10 +28,6 @@
 
 #define get_descriptor_id(type, service) (((type - 4) << 4) | service)
 
-struct pcie_port_device_ext {
-	int interrupt_mode;	/* [0:INTx | 1:MSI | 2:MSI-X] */
-};
-
 extern struct bus_type pcie_port_bus_type;
 extern int pcie_port_device_probe(struct pci_dev *dev);
 extern int pcie_port_device_register(struct pci_dev *dev);
Index: linux-2.6/drivers/pci/pcie/portdrv_core.c
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/portdrv_core.c
+++ linux-2.6/drivers/pci/pcie/portdrv_core.c
@@ -204,17 +204,10 @@ int pcie_port_device_probe(struct pci_de
  */
 int pcie_port_device_register(struct pci_dev *dev)
 {
-	struct pcie_port_device_ext *p_ext;
 	int status, type, capabilities, irq_mode, i;
 	int vectors[PCIE_PORT_DEVICE_MAXSERVICES];
 	u16 reg16;
 
-	/* Allocate port device extension */
-	if (!(p_ext = kmalloc(sizeof(struct pcie_port_device_ext), GFP_KERNEL)))
-		return -ENOMEM;
-
-	pci_set_drvdata(dev, p_ext);
-
 	/* Get port type */
 	pci_read_config_word(dev,
 		pci_find_capability(dev, PCI_CAP_ID_EXP) +
@@ -224,7 +217,6 @@ int pcie_port_device_register(struct pci
 	/* Now get port services */
 	capabilities = get_port_device_capability(dev);
 	irq_mode = assign_interrupt_mode(dev, vectors, capabilities);
-	p_ext->interrupt_mode = irq_mode;
 
 	/* Allocate child services if any */
 	for (i = 0; i < PCIE_PORT_DEVICE_MAXSERVICES; i++) {

