Return-Path: <linux-kernel-owner+w=401wt.eu-S1761959AbXFABQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761959AbXFABQ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 21:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759871AbXFABQC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 21:16:02 -0400
Received: from mail.kroah.org ([69.55.234.183]:46581 "EHLO perch.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758332AbXFABP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 21:15:59 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-pci@atrey.karlin.mff.cuni.cz
Cc: linux-kernel@vger.kernel.org, Jay Cliburn <jacliburn@bellsouth.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 5/5] PCI: quirk disable MSI on via vt3351
Date: Thu, 31 May 2007 18:16:57 -0700
Message-Id: <11806606173020-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2
In-Reply-To: <11806606173283-git-send-email-gregkh@suse.de>
References: <20070601011612.GA28262@kroah.com>
 <11806606172653-git-send-email-gregkh@suse.de>
 <11806606172891-git-send-email-gregkh@suse.de>
 <11806606172411-git-send-email-gregkh@suse.de>
 <11806606173283-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jay Cliburn <jacliburn@bellsouth.net>

The Via VT3351 APIC does not play well with MSI and unleashes a flood
of APIC errors when MSI is used to deliver interrupts.  The problem
was recently exposed when the atl1 network device driver, which enables
MSI by default, stimulated APIC errors on an Asus M2V mainboard, which
employs the Via VT3351.
See http://bugzilla.kernel.org/show_bug.cgi?id=8472 for additional
details on this bug.

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/pci/quirks.c    |    1 +
 include/linux/pci_ids.h |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 4937982..01d8f8a 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1640,6 +1640,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_GCN
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_HT1000_PCIX, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS400_200, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS480, quirk_disable_all_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VT3351, quirk_disable_all_msi);
 
 /* Disable MSI on chipsets that are known to not support it */
 static void __devinit quirk_disable_msi(struct pci_dev *dev)
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index c4a14c6..02cf0cd 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1292,6 +1292,7 @@
 #define PCI_DEVICE_ID_VIA_P4M890	0x0327
 #define PCI_DEVICE_ID_VIA_VT3324	0x0324
 #define PCI_DEVICE_ID_VIA_VT3336	0x0336
+#define PCI_DEVICE_ID_VIA_VT3351	0x0351
 #define PCI_DEVICE_ID_VIA_8371_0	0x0391
 #define PCI_DEVICE_ID_VIA_8501_0	0x0501
 #define PCI_DEVICE_ID_VIA_82C561	0x0561
-- 
1.5.2

