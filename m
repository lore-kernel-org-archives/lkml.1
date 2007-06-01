Return-Path: <linux-kernel-owner+w=401wt.eu-S1761286AbXFABQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761286AbXFABQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 21:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758716AbXFABP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 21:15:59 -0400
Received: from mail.kroah.org ([69.55.234.183]:46577 "EHLO perch.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757812AbXFABP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 21:15:58 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-pci@atrey.karlin.mff.cuni.cz
Cc: linux-kernel@vger.kernel.org, Andy Gospodarek <andy@greyhouse.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/5] PCI: disable MSI by default on systems with Serverworks HT1000 chips
Date: Thu, 31 May 2007 18:16:54 -0700
Message-Id: <11806606172891-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2
In-Reply-To: <11806606172653-git-send-email-gregkh@suse.de>
References: <20070601011612.GA28262@kroah.com>
 <11806606172653-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Gospodarek <andy@greyhouse.net>

I've been seeing lots of messages like these:

eth0: No interrupt was generated using MSI, switching to INTx mode.  Please
report this failure to the PCI maintainer and include system chipset
information.

On several systems that use the following Severworks HT1000 (also sometimes
labeled as a Broadcom chipset as well) bridge chips.  It doesn't appear MSI
works well (if at all) on these systems.

Signed-off-by: Andy Gospodarek <andy@greyhouse.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/pci/quirks.c    |    1 +
 include/linux/pci_ids.h |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 1cff65f..4937982 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1637,6 +1637,7 @@ static void __init quirk_disable_all_msi(struct pci_dev *dev)
 	printk(KERN_WARNING "PCI: MSI quirk detected. MSI deactivated.\n");
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_GCNB_LE, quirk_disable_all_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_HT1000_PCIX, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS400_200, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS480, quirk_disable_all_msi);
 
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 4712e26..c4a14c6 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1437,6 +1437,7 @@
 #define PCI_DEVICE_ID_SERVERWORKS_LE	  0x0009
 #define PCI_DEVICE_ID_SERVERWORKS_GCNB_LE 0x0017
 #define PCI_DEVICE_ID_SERVERWORKS_EPB	  0x0103
+#define PCI_DEVICE_ID_SERVERWORKS_HT1000_PCIX	0x0104
 #define PCI_DEVICE_ID_SERVERWORKS_HT2000_PCIE	0x0132
 #define PCI_DEVICE_ID_SERVERWORKS_OSB4	  0x0200
 #define PCI_DEVICE_ID_SERVERWORKS_CSB5	  0x0201
-- 
1.5.2

