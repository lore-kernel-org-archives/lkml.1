Return-Path: <linux-kernel-owner+w=401wt.eu-S1760805AbXEUOcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760805AbXEUOcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 10:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755684AbXEUOcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 10:32:08 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44038 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755548AbXEUOcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 10:32:06 -0400
Date: Mon, 21 May 2007 15:36:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org, matt.domsch@dell.com
Subject: [PATCH] edd: Switch to pci_get based API
Message-ID: <20070521153605.4211b9e2@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc1-mm1/drivers/firmware/edd.c linux-2.6.22-rc1-mm1/drivers/firmware/edd.c
--- linux.vanilla-2.6.22-rc1-mm1/drivers/firmware/edd.c	2007-05-18 16:22:53.000000000 +0100
+++ linux-2.6.22-rc1-mm1/drivers/firmware/edd.c	2007-05-18 16:35:08.000000000 +0100
@@ -669,7 +669,7 @@
 	struct edd_info *info = edd_dev_get_info(edev);
 
 	if (edd_dev_is_type(edev, "PCI")) {
-		return pci_find_slot(info->params.interface_path.pci.bus,
+		return pci_get_bus_and_slot(info->params.interface_path.pci.bus,
 				     PCI_DEVFN(info->params.interface_path.pci.slot,
 					       info->params.interface_path.pci.
 					       function));
@@ -682,9 +682,12 @@
 {
 
 	struct pci_dev *pci_dev = edd_get_pci_dev(edev);
+	int ret;
 	if (!pci_dev)
 		return 1;
-	return sysfs_create_link(&edev->kobj,&pci_dev->dev.kobj,"pci_dev");
+	ret = sysfs_create_link(&edev->kobj,&pci_dev->dev.kobj,"pci_dev");
+	pci_dev_put(pci_dev);
+	return ret;
 }
 
 static inline void

