Return-Path: <linux-kernel-owner+w=401wt.eu-S1756572AbZADXDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572AbZADXDZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 18:03:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753876AbZADXBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 18:01:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49619 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567AbZADXBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 18:01:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 6/8] PCI PCIe portdrv: Remove unnecessary function
Date: Sun, 4 Jan 2009 23:57:02 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: Linux PCI <linux-pci@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <200901042346.42723.rjw@sisk.pl>
In-Reply-To: <200901042346.42723.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901042357.02323.rjw@sisk.pl>
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
 

