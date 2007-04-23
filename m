Return-Path: <linux-kernel-owner+w=401wt.eu-S1751615AbXDWNrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615AbXDWNrE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 09:47:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbXDWNrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 09:47:03 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57245 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751615AbXDWNrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 09:47:02 -0400
Date: Mon, 23 Apr 2007 14:50:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: davej@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] Nvidia AGP: Use refcount aware PCI interfaces
Message-ID: <20070423145027.47f1ba38@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc6-mm1/drivers/char/agp/nvidia-agp.c linux-2.6.21-rc6-mm1/drivers/char/agp/nvidia-agp.c
--- linux.vanilla-2.6.21-rc6-mm1/drivers/char/agp/nvidia-agp.c	2007-04-12 14:15:03.000000000 +0100
+++ linux-2.6.21-rc6-mm1/drivers/char/agp/nvidia-agp.c	2007-04-23 11:53:12.560578080 +0100
@@ -320,11 +320,11 @@
 	u8 cap_ptr;
 
 	nvidia_private.dev_1 =
-		pci_find_slot((unsigned int)pdev->bus->number, PCI_DEVFN(0, 1));
+		pci_get_bus_and_slot((unsigned int)pdev->bus->number, PCI_DEVFN(0, 1));
 	nvidia_private.dev_2 =
-		pci_find_slot((unsigned int)pdev->bus->number, PCI_DEVFN(0, 2));
+		pci_get_bus_and_slot((unsigned int)pdev->bus->number, PCI_DEVFN(0, 2));
 	nvidia_private.dev_3 =
-		pci_find_slot((unsigned int)pdev->bus->number, PCI_DEVFN(30, 0));
+		pci_get_bus_and_slot((unsigned int)pdev->bus->number, PCI_DEVFN(30, 0));
 
 	if (!nvidia_private.dev_1 || !nvidia_private.dev_2 || !nvidia_private.dev_3) {
 		printk(KERN_INFO PFX "Detected an NVIDIA nForce/nForce2 "
@@ -443,6 +443,9 @@
 static void __exit agp_nvidia_cleanup(void)
 {
 	pci_unregister_driver(&agp_nvidia_pci_driver);
+	pci_dev_put(nvidia_private.dev_1);
+	pci_dev_put(nvidia_private.dev_2);
+	pci_dev_put(nvidia_private.dev_3);
 }
 
 module_init(agp_nvidia_init);
