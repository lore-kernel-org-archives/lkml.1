Return-Path: <linux-kernel-owner+w=401wt.eu-S1751300AbXEZWBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300AbXEZWBS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 18:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750740AbXEZWBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 18:01:08 -0400
Received: from imf21aec.mail.bellsouth.net ([205.152.59.69]:57846 "EHLO
	imf21aec.mail.bellsouth.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750718AbXEZWBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 18:01:07 -0400
Date: Sat, 26 May 2007 17:01:04 -0500
From: Jay Cliburn <jacliburn@bellsouth.net>
To: gregkh@suse.de, chrisw@sous-sol.org
Cc: jacliburn@bellsouth.net, csnook@redhat.com, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [stable][PATCH] pci: quirk disable MSI on via vt3351
Message-ID: <20070526220104.GA11530@osprey.hogchain.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The Via VT3351 APIC does not play well with MSI and unleashes a flood
of APIC errors when MSI is used to deliver interrupts.  The problem
was recently exposed when the atl1 network device driver, which enables
MSI by default, stimulated APIC errors on an Asus M2V mainboard, which
employs the Via VT3351.
See http://bugzilla.kernel.org/show_bug.cgi?id=8472 for additional
details on this bug.

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
---
 drivers/pci/quirks.c    |    1 +
 include/linux/pci_ids.h |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 5af9125..e2d81af 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1751,6 +1751,7 @@ static void __init quirk_disable_all_msi(struct pci_dev *dev)
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_GCNB_LE, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS400_200, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS480, quirk_disable_all_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VT3351, quirk_disable_all_msi);
 
 /* Disable MSI on chipsets that are known to not support it */
 static void __devinit quirk_disable_msi(struct pci_dev *dev)
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 600308f..2a0a70d 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1287,6 +1287,7 @@
 #define PCI_DEVICE_ID_VIA_P4M800CE	0x0314
 #define PCI_DEVICE_ID_VIA_P4M890	0x0327
 #define PCI_DEVICE_ID_VIA_VT3336	0x0336
+#define PCI_DEVICE_ID_VIA_VT3351	0x0351
 #define PCI_DEVICE_ID_VIA_8371_0	0x0391
 #define PCI_DEVICE_ID_VIA_8501_0	0x0501
 #define PCI_DEVICE_ID_VIA_82C561	0x0561

