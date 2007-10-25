Return-Path: <linux-kernel-owner+w=401wt.eu-S1760910AbXJYISd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760910AbXJYISd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 04:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760173AbXJYIRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 04:17:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57878
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760409AbXJYIRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 04:17:15 -0400
Date: Thu, 25 Oct 2007 01:17:16 -0700 (PDT)
Message-Id: <20071025.011716.123998434.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, barkalow@iabervon.org, linas@austin.ibm.com,
       chunhao.huang@hotmail.com, gregkh@suse.de, htejun@gmail.com,
       brice.goglin@gmail.com, david.gaarenstroom@gmail.com,
       linux-pci@atrey.karlin.mff.cuni.cz, shane.huang@amd.com,
       linux-ide@vger.kernel.org, brice@myri.com, mchan@broadcom.com
Subject: [PATCH 5/5]: [PCI]: Remove 3 incorrect MSI quirks.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Now that we have dealt with the real issue, in that some ATI SATA and
USB controllers needed the INTX_DISABLE quirk, we can remove these AMD
chipset global MSI disabling quirks.

This reverts three changesets:

4be8f906435a6af241821ab5b94b2b12cb7d57d8 (PCI: disable MSI on RS690)
aea6a433f50cd89b9cbd10850fd0b32f961f9883 (PCI: disable MSI on RD580)
f122392f679ebed39db08074f935d770504623eb (PCI: disable MSI on RX790)

This is based upon testing and feedback from
Shane Huang <Shane.Huang@amd.com>.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/pci/quirks.c    |    3 ---
 include/linux/pci_ids.h |    3 ---
 2 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index d8f2d89..26cc4dc 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1623,9 +1623,6 @@ static void __init quirk_disable_all_msi(struct pci_dev *dev)
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_GCNB_LE, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS400_200, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS480, quirk_disable_all_msi);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RD580, quirk_disable_all_msi);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RX790, quirk_disable_all_msi);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS690, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VT3351, quirk_disable_all_msi);
 
 /* Disable MSI on chipsets that are known to not support it */
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index c64bb89..e66af5d 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -360,9 +360,6 @@
 #define PCI_DEVICE_ID_ATI_RS400_166     0x5a32
 #define PCI_DEVICE_ID_ATI_RS400_200     0x5a33
 #define PCI_DEVICE_ID_ATI_RS480         0x5950
-#define PCI_DEVICE_ID_ATI_RD580		0x5952
-#define PCI_DEVICE_ID_ATI_RX790		0x5957
-#define PCI_DEVICE_ID_ATI_RS690		0x7910
 /* ATI IXP Chipset */
 #define PCI_DEVICE_ID_ATI_IXP200_IDE	0x4349
 #define PCI_DEVICE_ID_ATI_IXP200_SMBUS	0x4353
-- 
1.5.2.5

