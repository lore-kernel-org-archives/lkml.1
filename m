Return-Path: <linux-kernel-owner+w=401wt.eu-S932864AbZLNVET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932864AbZLNVET (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 16:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932876AbZLNVEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 16:04:14 -0500
Received: from exprod6og107.obsmtp.com ([64.18.1.208]:37324 "EHLO
	exprod6og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932974AbZLNVEI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 16:04:08 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] au1550nd.c: use kzalloc()
Date: Mon, 14 Dec 2009 16:04:07 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200EA44@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] au1550nd.c: use kzalloc()
Thread-Index: Acp9APm0qnC54CtWQiGN6hAIxQxxVg==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>,
       <linux-mtd@lists.infradead.org>
Cc: "David Woodhouse" <dwmw2@infradead.org>
X-OriginalArrivalTime: 14 Dec 2009 21:04:06.0195 (UTC) FILETIME=[F8D96830:01CA7D00]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kzalloc() instead of kmalloc()/memset().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Woodhouse <dwmw2@infradead.org>

---

diff --git a/drivers/mtd/nand/au1550nd.c b/drivers/mtd/nand/au1550nd.c
index 92c334f..de190b8 100644
--- a/drivers/mtd/nand/au1550nd.c
+++ b/drivers/mtd/nand/au1550nd.c
@@ -450,7 +450,7 @@ static int __init au1xxx_nand_init(void)
 	u32 nand_phys;
 
 	/* Allocate memory for MTD device structure and private data */
-	au1550_mtd = kmalloc(sizeof(struct mtd_info) + sizeof(struct nand_chip), GFP_KERNEL);
+	au1550_mtd = kzalloc(sizeof(struct mtd_info) + sizeof(struct nand_chip), GFP_KERNEL);
 	if (!au1550_mtd) {
 		printk("Unable to allocate NAND MTD dev structure.\n");
 		return -ENOMEM;
@@ -459,10 +459,6 @@ static int __init au1xxx_nand_init(void)
 	/* Get pointer to private data */
 	this = (struct nand_chip *)(&au1550_mtd[1]);
 
-	/* Initialize structures */
-	memset(au1550_mtd, 0, sizeof(struct mtd_info));
-	memset(this, 0, sizeof(struct nand_chip));
-
 	/* Link the private data with the MTD structure */
 	au1550_mtd->priv = this;
 	au1550_mtd->owner = THIS_MODULE; 
