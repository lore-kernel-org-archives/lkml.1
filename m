Return-Path: <linux-kernel-owner+w=401wt.eu-S1161305AbXD2U7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161305AbXD2U7u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 16:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161303AbXD2U7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 16:59:50 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:48223 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161305AbXD2U7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 16:59:49 -0400
Message-id: <7762312221026113000@wsc.cz>
In-reply-to: <1726067771982725064@wsc.cz>
Subject: [PATCH 10/21] Char: cyclades, get rid of phys addresses
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Sun, 29 Apr 2007 22:59:47 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cyclades, get rid of phys addresses

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 17c85217155fbe44ff70ddf1912af5bc87fbb559
tree 3d7dc0a43bc4a1e9f2e93016724df71ec836b30a
parent 5bd7a7ad3eaafc9d8d03bd1488650b210c03f613
author Jiri Slaby <jirislaby@gmail.com> Wed, 25 Apr 2007 22:17:24 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sat, 28 Apr 2007 23:48:12 +0200

 drivers/char/cyclades.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 9088c93..01c835a 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -4797,9 +4797,7 @@ static void __devinit plx_init(void __iomem * addr, __u32 initctl)
 	cy_writel(addr + initctl, readl(addr + initctl) & ~0x20000000);
 }
 
-static int __devinit cy_init_Ze(unsigned long cy_pci_phys0,
-		unsigned long cy_pci_phys2,
-		struct RUNTIME_9060 __iomem *cy_pci_addr0,
+static int __devinit cy_init_Ze(struct RUNTIME_9060 __iomem *cy_pci_addr0,
 		int cy_pci_irq, struct pci_dev *pdev)
 {
 	void __iomem *cy_pci_addr2;
@@ -4869,7 +4867,7 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
 {
 	unsigned char cyy_rev_id;
 	int cy_pci_irq;
-	__u32 cy_pci_phys0, cy_pci_phys2, mailbox;
+	__u32 mailbox;
 	void __iomem *cy_pci_addr0, *cy_pci_addr2;
 	unsigned int device_id;
 	unsigned short j, cy_pci_nchan, plx_ver;
@@ -4883,8 +4881,6 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
 
 	/* read PCI configuration area */
 	cy_pci_irq = pdev->irq;
-	cy_pci_phys0 = pci_resource_start(pdev, 0);
-	cy_pci_phys2 = pci_resource_start(pdev, 2);
 	pci_read_config_byte(pdev, PCI_REVISION_ID, &cyy_rev_id);
 
 	device_id = pdev->device & ~PCI_DEVICE_ID_MASK;
@@ -5038,8 +5034,7 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
 		}
 
 		if (mailbox == ZE_V1) {
-			retval = cy_init_Ze(cy_pci_phys0, cy_pci_phys2,
-					cy_pci_addr0, cy_pci_irq, pdev);
+			retval = cy_init_Ze(cy_pci_addr0, cy_pci_irq, pdev);
 			return retval;
 		} else {
 			cy_pci_addr2 = pci_iomap(pdev, 2, CyPCI_Zwin);
