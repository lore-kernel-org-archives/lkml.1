Return-Path: <linux-kernel-owner+w=401wt.eu-S1758193AbZADWIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193AbZADWIi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 17:08:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbZADWI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 17:08:29 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49480 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883AbZADWI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 17:08:28 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] x86 PCI: Do not use interrupt links for devices using MSI-X
Date: Sun, 4 Jan 2009 23:08:42 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-tst; KDE/4.1.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901042308.42625.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

pcibios_enable_device() and pcibios_disable_device() don't handle
IRQs for devices that have MSI enabled and it should tread the
devices with MSI-X enabled in the same way.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/x86/pci/common.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/pci/common.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/common.c
+++ linux-2.6/arch/x86/pci/common.c
@@ -551,14 +551,14 @@ int pcibios_enable_device(struct pci_dev
 	if ((err = pci_enable_resources(dev, mask)) < 0)
 		return err;
 
-	if (!dev->msi_enabled)
+	if (!dev->msi_enabled && !dev->msix_enabled)
 		return pcibios_enable_irq(dev);
 	return 0;
 }
 
 void pcibios_disable_device (struct pci_dev *dev)
 {
-	if (!dev->msi_enabled && pcibios_disable_irq)
+	if (!dev->msi_enabled && !dev->msix_enabled && pcibios_disable_irq)
 		pcibios_disable_irq(dev);
 }
 

