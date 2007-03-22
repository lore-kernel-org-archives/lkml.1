Return-Path: <linux-kernel-owner+w=401wt.eu-S934131AbXCVX1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934131AbXCVX1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 19:27:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933413AbXCVX1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 19:27:10 -0400
Received: from vena.lwn.net ([206.168.112.25]:43352 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934131AbXCVX1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 19:27:09 -0400
X-Greylist: delayed 2009 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Mar 2007 19:27:09 EDT
To: akpm@linux-foundation.org
Subject: [PATCH] Fix up PCI power management doc
cc: linux-kernel@vger.kernel.org
From: Jonathan Corbet <corbet@lwn.net>
Date: Thu, 22 Mar 2007 16:53:40 -0600
Message-ID: <24815.1174604020@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that the PCI power management document file had fallen a
little behind the times, so I fixed it up.

jon

Update the documentation of PCI power management functions.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>

diff --git a/Documentation/power/pci.txt b/Documentation/power/pci.txt
index c750f9f..b6a3cbf 100644
--- a/Documentation/power/pci.txt
+++ b/Documentation/power/pci.txt
@@ -102,31 +102,28 @@ pci_save_state
 --------------
 
 Usage:
-	pci_save_state(dev, buffer);
+	pci_save_state(struct pci_dev *dev);
 
 Description:
-	Save first 64 bytes of PCI config space. Buffer must be allocated by
-	caller.
+	Save first 64 bytes of PCI config space, along with any additional
+	PCI-Express or PCI-X information.
 
 
 pci_restore_state
 -----------------
 
 Usage:
-	pci_restore_state(dev, buffer);
+	pci_restore_state(struct pci_dev *dev);
 
 Description:
-	Restore previously saved config space. (First 64 bytes only);
-
-	If buffer is NULL, then restore what information we know about the
-	device from bootup: BARs and interrupt line.
+	Restore previously saved config space.
 
 
 pci_set_power_state
 -------------------
 
 Usage:
-	pci_set_power_state(dev, state);
+	pci_set_power_state(struct pci_dev *dev, pci_power_t state);
 
 Description:
 	Transition device to low power state using PCI PM Capabilities
@@ -142,7 +139,7 @@ pci_enable_wake
 ---------------
 
 Usage:
-	pci_enable_wake(dev, state, enable);
+	pci_enable_wake(struct pci_dev *dev, pci_power_t state, int enable);
 
 Description:
 	Enable device to generate PME# during low power state using PCI PM 

