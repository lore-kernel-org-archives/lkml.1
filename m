Return-Path: <linux-kernel-owner+w=401wt.eu-S933913AbXEGNqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933913AbXEGNqB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 09:46:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933897AbXEGNp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 09:45:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933895AbXEGNp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 09:45:57 -0400
Date: Mon, 7 May 2007 09:45:52 -0400
From: Andy Gospodarek <andy@greyhouse.net>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: [PATCH] PCI: disable MSI by default on systems with Serverworks HT1000 chips
Message-ID: <20070507134552.GA2975@gospo.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.10i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I've been seeing lots of messages like these:

eth0: No interrupt was generated using MSI, switching to INTx mode.
Please report this failure to the PCI maintainer and include system
chipset information.

On several systems that use the following Severworks HT1000 (also
sometimes labeled as a Broadcom chipset as well) bridge chips.  It
doesn't appear MSI works well (if at all) on these systems.

Signed-off-by: Andy Gospodarek <andy@greyhouse.net>
---

 drivers/pci/quirks.c    |    1 +
 include/linux/pci_ids.h |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 3411483..e5ff7e0 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1636,6 +1636,7 @@ static void __init quirk_svw_msi(struct pci_dev *dev)
 	printk(KERN_WARNING "PCI: MSI quirk detected. MSI deactivated.\n");
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_GCNB_LE, quirk_svw_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_HT1000_PCIX, quirk_svw_msi );
 
 /* Disable MSI on chipsets that are known to not support it */
 static void __devinit quirk_disable_msi(struct pci_dev *dev)
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 1b0ddbb..8ee55a9 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1431,6 +1431,7 @@
 #define PCI_DEVICE_ID_SERVERWORKS_LE	  0x0009
 #define PCI_DEVICE_ID_SERVERWORKS_GCNB_LE 0x0017
 #define PCI_DEVICE_ID_SERVERWORKS_EPB	  0x0103
+#define PCI_DEVICE_ID_SERVERWORKS_HT1000_PCIX	0x0104
 #define PCI_DEVICE_ID_SERVERWORKS_HT2000_PCIE	0x0132
 #define PCI_DEVICE_ID_SERVERWORKS_OSB4	  0x0200
 #define PCI_DEVICE_ID_SERVERWORKS_CSB5	  0x0201
