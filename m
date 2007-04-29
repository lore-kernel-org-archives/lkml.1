Return-Path: <linux-kernel-owner+w=401wt.eu-S1161224AbXD2U5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161224AbXD2U5I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 16:57:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161113AbXD2U5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 16:57:07 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:49437 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161224AbXD2U5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 16:57:02 -0400
Message-id: <2404076572497619881@wsc.cz>
In-reply-to: <1726067771982725064@wsc.cz>
Subject: [PATCH 6/21] Char: cyclades, irq is int
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Sun, 29 Apr 2007 22:57:00 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cyclades, irq is int

don't fetch it to uchar

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 34705e1c32f10d42a1d4b7e2b3da93321bd20625
tree d32188cad2366036c71f140b123d50c8f748b3fa
parent 85e1e6d0a4acbcedf00e9f2fc6b71d66179dc382
author Jiri Slaby <jirislaby@gmail.com> Wed, 25 Apr 2007 14:15:57 +0200
committer Jiri Slaby <jirislaby@gmail.com> Fri, 27 Apr 2007 13:15:01 +0200

 drivers/char/cyclades.c |   30 ++++++++++++------------------
 1 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index a79a4b2..c12dbb1 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -4916,7 +4916,7 @@ static int __devinit cy_init_Ze(unsigned long cy_pci_phys0,
 	/* set cy_card */
 	cy_card[j].base_addr = cy_pci_addr2;
 	cy_card[j].ctl_addr = cy_pci_addr0;
-	cy_card[j].irq = (int)cy_pci_irq;
+	cy_card[j].irq = cy_pci_irq;
 	cy_card[j].bus_index = 1;
 	cy_card[j].first_line = cy_next_channel;
 	cy_card[j].num_chips = -1;
@@ -4929,8 +4929,7 @@ static int __devinit cy_init_Ze(unsigned long cy_pci_phys0,
 	if ((cy_pci_irq != 0) && (cy_pci_irq != 255))
 		printk("Cyclades-Ze/PCI #%d: 0x%lx-0x%lx, IRQ%d, ",
 			j + 1, (ulong) cy_pci_phys2,
-			(ulong) (cy_pci_phys2 + CyPCI_Ze_win - 1),
-			(int)cy_pci_irq);
+			(ulong) (cy_pci_phys2 + CyPCI_Ze_win - 1), cy_pci_irq);
 	else
 #endif				/* CONFIG_CYZ_INTR */
 		printk("Cyclades-Ze/PCI #%d: 0x%lx-0x%lx, ",
@@ -4950,7 +4949,7 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
 		const struct pci_device_id *ent)
 {
 	unsigned char cyy_rev_id;
-	unsigned char cy_pci_irq;
+	int cy_pci_irq;
 	__u32 cy_pci_phys0, cy_pci_phys2, mailbox;
 	void __iomem *cy_pci_addr0, *cy_pci_addr2;
 	unsigned int device_id;
@@ -4976,8 +4975,7 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
 #ifdef CY_PCI_DEBUG
 		printk("Cyclom-Y/PCI (bus=0x0%x, pci_id=0x%x, ",
 			pdev->bus->number, pdev->devfn);
-		printk("rev_id=%d) IRQ%d\n",
-			cyy_rev_id, (int)cy_pci_irq);
+		printk("rev_id=%d) IRQ%d\n", cyy_rev_id, cy_pci_irq);
 		printk("Cyclom-Y/PCI:found  winaddr=0x%lx "
 			"ctladdr=0x%lx\n",
 			(ulong)cy_pci_phys2, (ulong)cy_pci_phys0);
@@ -5003,7 +5001,7 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
 			printk("Cyclom-Y/PCI (bus=0x0%x, pci_id=0x%x, ",
 				pdev->bus->number, pdev->devfn);
 			printk("rev_id=%d) IRQ%d\n",
-				cyy_rev_id, (int)cy_pci_irq);
+				cyy_rev_id, cy_pci_irq);
 			printk("Cyclom-Y/PCI:found  winaddr=0x%lx "
 				"ctladdr=0x%lx\n",
 				(ulong)cy_pci_phys2,
@@ -5065,7 +5063,7 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
 		/* set cy_card */
 		cy_card[j].base_addr = cy_pci_addr2;
 		cy_card[j].ctl_addr = cy_pci_addr0;
-		cy_card[j].irq = (int)cy_pci_irq;
+		cy_card[j].irq = cy_pci_irq;
 		cy_card[j].bus_index = 1;
 		cy_card[j].first_line = cy_next_channel;
 		cy_card[j].num_chips = cy_pci_nchan / 4;
@@ -5101,8 +5099,7 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
 		/* print message */
 		printk("Cyclom-Y/PCI #%d: 0x%lx-0x%lx, IRQ%d, ",
 			j + 1, (ulong)cy_pci_phys2,
-			(ulong) (cy_pci_phys2 + CyPCI_Ywin - 1),
-			(int)cy_pci_irq);
+			(ulong) (cy_pci_phys2 + CyPCI_Ywin - 1), cy_pci_irq);
 		printk("%d channels starting from port %d.\n",
 			cy_pci_nchan, cy_next_channel);
 		for (j = cy_next_channel;
@@ -5114,8 +5111,7 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
 		/* print message */
 		printk("Cyclades-Z/PCI (bus=0x0%x, pci_id=0x%x, ",
 			pdev->bus->number, pdev->devfn);
-		printk("rev_id=%d) IRQ%d\n",
-			cyy_rev_id, (int)cy_pci_irq);
+		printk("rev_id=%d) IRQ%d\n", cyy_rev_id, cy_pci_irq);
 		printk("Cyclades-Z/PCI: found winaddr=0x%lx "
 			"ctladdr=0x%lx\n",
 			(ulong)cy_pci_phys2, (ulong)cy_pci_phys0);
@@ -5126,8 +5122,7 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
 #ifdef CY_PCI_DEBUG
 		printk("Cyclades-Z/PCI (bus=0x0%x, pci_id=0x%x, ",
 			pdev->bus->number, pdev->devfn);
-		printk("rev_id=%d) IRQ%d\n",
-			cyy_rev_id, (int)cy_pci_irq);
+		printk("rev_id=%d) IRQ%d\n", cyy_rev_id, cy_pci_irq);
 		printk("Cyclades-Z/PCI: found winaddr=0x%lx "
 			"ctladdr=0x%lx\n",
 			(ulong) cy_pci_phys2, (ulong) cy_pci_phys0);
@@ -5144,8 +5139,7 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
 		   re-write it to the PCI config. registers.
 		   This will remain here until we find a permanent
 		   fix. */
-		pci_write_config_byte(pdev, PCI_INTERRUPT_LINE,
-					cy_pci_irq);
+		pci_write_config_byte(pdev, PCI_INTERRUPT_LINE, cy_pci_irq);
 
 		mailbox = (__u32)readl(&((struct RUNTIME_9060 __iomem *)
 				cy_pci_addr0)->mail_box_0);
@@ -5249,7 +5243,7 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
 		/* set cy_card */
 		cy_card[j].base_addr = cy_pci_addr2;
 		cy_card[j].ctl_addr = cy_pci_addr0;
-		cy_card[j].irq = (int)cy_pci_irq;
+		cy_card[j].irq = cy_pci_irq;
 		cy_card[j].bus_index = 1;
 		cy_card[j].first_line = cy_next_channel;
 		cy_card[j].num_chips = -1;
@@ -5263,7 +5257,7 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
 			printk("Cyclades-8Zo/PCI #%d: 0x%lx-0x%lx, "
 				"IRQ%d, ", j + 1, (ulong)cy_pci_phys2,
 				(ulong) (cy_pci_phys2 + CyPCI_Zwin - 1),
-				(int)cy_pci_irq);
+				cy_pci_irq);
 		else
 #endif				/* CONFIG_CYZ_INTR */
 			printk("Cyclades-8Zo/PCI #%d: 0x%lx-0x%lx, ",
