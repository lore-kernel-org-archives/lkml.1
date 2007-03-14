Return-Path: <linux-kernel-owner+w=401wt.eu-S1030726AbXCNJSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030726AbXCNJSx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030787AbXCNJSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:18:38 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60477 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030744AbXCNJSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:18:22 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 3/17] dmfe trivial endianness annotations
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org
Message-Id: <E1HRPci-0003Or-09@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 14 Mar 2007 09:18:20 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/net/tulip/dmfe.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/tulip/dmfe.c b/drivers/net/tulip/dmfe.c
index 24a29c9..9aeac76 100644
--- a/drivers/net/tulip/dmfe.c
+++ b/drivers/net/tulip/dmfe.c
@@ -190,13 +190,13 @@
 
 /* Structure/enum declaration ------------------------------- */
 struct tx_desc {
-        u32 tdes0, tdes1, tdes2, tdes3; /* Data for the card */
+        __le32 tdes0, tdes1, tdes2, tdes3; /* Data for the card */
         char *tx_buf_ptr;               /* Data for us */
         struct tx_desc *next_tx_desc;
 } __attribute__(( aligned(32) ));
 
 struct rx_desc {
-	u32 rdes0, rdes1, rdes2, rdes3; /* Data for the card */
+	__le32 rdes0, rdes1, rdes2, rdes3; /* Data for the card */
 	struct sk_buff *rx_skb_ptr;	/* Data for us */
 	struct rx_desc *next_rx_desc;
 } __attribute__(( aligned(32) ));
@@ -458,7 +458,7 @@ static int __devinit dmfe_init_one (struct pci_dev *pdev,
 
 	/* read 64 word srom data */
 	for (i = 0; i < 64; i++)
-		((u16 *) db->srom)[i] =
+		((__le16 *) db->srom)[i] =
 			cpu_to_le16(read_srom_word(db->ioaddr, i));
 
 	/* Set Node address */
-- 
1.5.0-rc2.GIT


