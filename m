Return-Path: <linux-kernel-owner+w=401wt.eu-S1161159AbXD2U4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161159AbXD2U4S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 16:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161224AbXD2U4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 16:56:18 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:49434 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161159AbXD2U4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 16:56:16 -0400
Message-id: <124771016594152984@wsc.cz>
In-reply-to: <1726067771982725064@wsc.cz>
Subject: [PATCH 5/21] Char: cyclades, remove useless fileds from cyclades_card
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Sun, 29 Apr 2007 22:56:14 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cyclades, remove useless fileds from cyclades_card

pde, ctl_phys and base_phys are useless -- they are never used.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 85e1e6d0a4acbcedf00e9f2fc6b71d66179dc382
tree 2dac7ea5d42dab587e046c9b91354ea5a467a2ed
parent 166b3f753df7acfa71c32b1069e78317f532b0f7
author Jiri Slaby <jirislaby@gmail.com> Wed, 25 Apr 2007 14:13:30 +0200
committer Jiri Slaby <jirislaby@gmail.com> Fri, 27 Apr 2007 13:15:00 +0200

 drivers/char/cyclades.c  |    9 ---------
 include/linux/cyclades.h |    3 ---
 2 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 1b4ff13..a79a4b2 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -4914,15 +4914,12 @@ static int __devinit cy_init_Ze(unsigned long cy_pci_phys0,
 #endif				/* CONFIG_CYZ_INTR */
 
 	/* set cy_card */
-	cy_card[j].base_phys = cy_pci_phys2;
-	cy_card[j].ctl_phys = cy_pci_phys0;
 	cy_card[j].base_addr = cy_pci_addr2;
 	cy_card[j].ctl_addr = cy_pci_addr0;
 	cy_card[j].irq = (int)cy_pci_irq;
 	cy_card[j].bus_index = 1;
 	cy_card[j].first_line = cy_next_channel;
 	cy_card[j].num_chips = -1;
-	cy_card[j].pdev = pdev;
 	cy_init_card(&cy_card[j], j);
 	pci_set_drvdata(pdev, &cy_card[j]);
 
@@ -5066,15 +5063,12 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
 		}
 
 		/* set cy_card */
-		cy_card[j].base_phys = (ulong) cy_pci_phys2;
-		cy_card[j].ctl_phys = (ulong) cy_pci_phys0;
 		cy_card[j].base_addr = cy_pci_addr2;
 		cy_card[j].ctl_addr = cy_pci_addr0;
 		cy_card[j].irq = (int)cy_pci_irq;
 		cy_card[j].bus_index = 1;
 		cy_card[j].first_line = cy_next_channel;
 		cy_card[j].num_chips = cy_pci_nchan / 4;
-		cy_card[j].pdev = pdev;
 		cy_init_card(&cy_card[j], j);
 		pci_set_drvdata(pdev, &cy_card[j]);
 
@@ -5253,15 +5247,12 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
 #endif				/* CONFIG_CYZ_INTR */
 
 		/* set cy_card */
-		cy_card[j].base_phys = cy_pci_phys2;
-		cy_card[j].ctl_phys = cy_pci_phys0;
 		cy_card[j].base_addr = cy_pci_addr2;
 		cy_card[j].ctl_addr = cy_pci_addr0;
 		cy_card[j].irq = (int)cy_pci_irq;
 		cy_card[j].bus_index = 1;
 		cy_card[j].first_line = cy_next_channel;
 		cy_card[j].num_chips = -1;
-		cy_card[j].pdev = pdev;
 		cy_init_card(&cy_card[j], j);
 		pci_set_drvdata(pdev, &cy_card[j]);
 
diff --git a/include/linux/cyclades.h b/include/linux/cyclades.h
index e76f486..e06cd47 100644
--- a/include/linux/cyclades.h
+++ b/include/linux/cyclades.h
@@ -509,8 +509,6 @@ struct ZFW_CTRL {
 
 /* Per card data structure */
 struct cyclades_card {
-    unsigned long base_phys;
-    unsigned long ctl_phys;
     void __iomem *base_addr;
     void __iomem *ctl_addr;
     int irq;
@@ -519,7 +517,6 @@ struct cyclades_card {
     int nports;		/* Number of ports in the card */
     int bus_index;	/* address shift - 0 for ISA, 1 for PCI */
     int	intr_enabled;	/* FW Interrupt flag - 0 disabled, 1 enabled */
-    struct pci_dev *pdev;
     spinlock_t card_lock;
 };
 
