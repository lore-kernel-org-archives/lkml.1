Return-Path: <linux-kernel-owner+w=401wt.eu-S1760050AbZAMNuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760050AbZAMNuh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 08:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756704AbZAMNt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 08:49:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50460 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756447AbZAMNt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 08:49:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 4/7] PCI PCIe portdrv: Remove unnecessary function
Date: Tue, 13 Jan 2009 14:43:07 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc1-rjw; KDE/4.1.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>
References: <200901131434.28340.rjw@sisk.pl>
In-Reply-To: <200901131434.28340.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901131443.07888.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The function pcie_portdrv_save_config() in portdrv_pci.c is not
necessary.  Remove it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pcie/portdrv_pci.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

Index: linux-2.6/drivers/pci/pcie/portdrv_pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/portdrv_pci.c
+++ linux-2.6/drivers/pci/pcie/portdrv_pci.c
@@ -32,11 +32,6 @@ MODULE_LICENSE("GPL");
 /* global data */
 static const char device_name[] = "pcieport-driver";
 
-static int pcie_portdrv_save_config(struct pci_dev *dev)
-{
-	return pci_save_state(dev);
-}
-
 static int pcie_portdrv_restore_config(struct pci_dev *dev)
 {
 	int retval;
@@ -102,7 +97,7 @@ static int __devinit pcie_portdrv_probe 
 	if (status)
 		return status;
 
-	pcie_portdrv_save_config(dev);
+	pci_save_state(dev);
 
 	pci_enable_pcie_error_reporting(dev);
 

