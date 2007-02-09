Return-Path: <linux-kernel-owner+w=401wt.eu-S1946650AbXBIQkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946650AbXBIQkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:40:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946664AbXBIQk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:40:29 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51742 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946649AbXBIQkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:40:06 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] pc300too annotation fixes
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org
Message-Id: <E1HFYn7-0006s2-P2@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 09 Feb 2007 16:40:05 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/net/wan/pc300too.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wan/pc300too.c b/drivers/net/wan/pc300too.c
index 79b2d54..bc156b5 100644
--- a/drivers/net/wan/pc300too.c
+++ b/drivers/net/wan/pc300too.c
@@ -101,8 +101,8 @@ typedef struct port_s {
 typedef struct card_s {
 	int type;		/* RSV, X21, etc. */
 	int n_ports;		/* 1 or 2 ports */
-	u8* __iomem rambase;	/* buffer memory base (virtual) */
-	u8* __iomem scabase;	/* SCA memory base (virtual) */
+	u8 __iomem *rambase;	/* buffer memory base (virtual) */
+	u8 __iomem *scabase;	/* SCA memory base (virtual) */
 	plx9050 __iomem *plxbase; /* PLX registers memory base (virtual) */
 	u32 init_ctrl_value;	/* Saved value - 9050 bug workaround */
 	u16 rx_ring_buffers;	/* number of buffers in a ring */
@@ -134,7 +134,7 @@ typedef struct card_s {
 static void pc300_set_iface(port_t *port)
 {
 	card_t *card = port->card;
-	u32* init_ctrl = &card->plxbase->init_ctrl;
+	u32 __iomem * init_ctrl = &card->plxbase->init_ctrl;
 	u16 msci = get_msci(port);
 	u8 rxs = port->rxs & CLK_BRG_MASK;
 	u8 txs = port->txs & CLK_BRG_MASK;
@@ -393,7 +393,7 @@ static int __devinit pc300_pci_init_one(struct pci_dev *pdev,
 
 	/* PLX PCI 9050 workaround for local configuration register read bug */
 	pci_write_config_dword(pdev, PCI_BASE_ADDRESS_0, scaphys);
-	card->init_ctrl_value = readl(&((plx9050*)card->scabase)->init_ctrl);
+	card->init_ctrl_value = readl(&((plx9050 __iomem *)card->scabase)->init_ctrl);
 	pci_write_config_dword(pdev, PCI_BASE_ADDRESS_0, plxphys);
 
 	/* Reset PLX */
@@ -519,10 +519,10 @@ static struct pci_device_id pc300_pci_tbl[] __devinitdata = {
 
 
 static struct pci_driver pc300_pci_driver = {
-	name:           "PC300",
-	id_table:       pc300_pci_tbl,
-	probe:          pc300_pci_init_one,
-	remove:         pc300_pci_remove_one,
+	.name =          "PC300",
+	.id_table =      pc300_pci_tbl,
+	.probe =         pc300_pci_init_one,
+	.remove =        pc300_pci_remove_one,
 };
 
 
-- 
1.5.0-rc2.GIT


