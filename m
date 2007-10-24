Return-Path: <linux-kernel-owner+w=401wt.eu-S1756562AbXJXCvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbXJXCvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 22:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbXJXCvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 22:51:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48124
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752712AbXJXCvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 22:51:36 -0400
Date: Tue, 23 Oct 2007 19:52:04 -0700 (PDT)
Message-Id: <20071023.195204.112851541.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, barkalow@iabervon.org, linas@austin.ibm.com,
       chunhao.huang@hotmail.com, gregkh@suse.de, htejun@gmail.com,
       brice.goglin@gmail.com, david.gaarenstroom@gmail.com,
       linux-pci@atrey.karlin.mff.cuni.cz, shane.huang@amd.com,
       linux-ide@vger.kernel.org, brice@myri.com, mchan@broadcom.com
Subject: [PATCH 1/4]: Revert "PCI: disable MSI by default on systems with
 Serverworks HT1000 chips"
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This reverts commit e3008dedff4bdc96a5f67224cd3d8d12237082a0.

The real bug was an INTX issue in the tg3 ethernet chip, and
cured by commit c129d962a66c76964954a98b38586ada82cf9381

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/pci/quirks.c    |    1 -
 include/linux/pci_ids.h |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 59d4da2..1f1ee67 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1621,7 +1621,6 @@ static void __init quirk_disable_all_msi(struct pci_dev *dev)
 	printk(KERN_WARNING "PCI: MSI quirk detected. MSI deactivated.\n");
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_GCNB_LE, quirk_disable_all_msi);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_HT1000_PCIX, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS400_200, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS480, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RD580, quirk_disable_all_msi);
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 4e10a07..0571d6a 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1433,7 +1433,6 @@
 #define PCI_DEVICE_ID_SERVERWORKS_LE	  0x0009
 #define PCI_DEVICE_ID_SERVERWORKS_GCNB_LE 0x0017
 #define PCI_DEVICE_ID_SERVERWORKS_EPB	  0x0103
-#define PCI_DEVICE_ID_SERVERWORKS_HT1000_PCIX	0x0104
 #define PCI_DEVICE_ID_SERVERWORKS_HT2000_PCIE	0x0132
 #define PCI_DEVICE_ID_SERVERWORKS_OSB4	  0x0200
 #define PCI_DEVICE_ID_SERVERWORKS_CSB5	  0x0201
-- 
1.5.3.4

