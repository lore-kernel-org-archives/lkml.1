Return-Path: <linux-kernel-owner+w=401wt.eu-S1765321AbXGaVW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765321AbXGaVW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 17:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756286AbXGaVWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 17:22:20 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3233 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755859AbXGaVWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 17:22:19 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 53] Documentation/DocBook/mtdnand.tmpl: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 23:22:18 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       dwmw2@infradead.org, linux-mtd@lists.infradead.org
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707312322.18508.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 Documentation/DocBook/mtdnand.tmpl |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- linux-2.6.23-rc1-mm1-a/Documentation/DocBook/mtdnand.tmpl	2007-07-26 13:07:45.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/Documentation/DocBook/mtdnand.tmpl	2007-07-31 12:16:02.000000000 +0200
@@ -275,16 +275,13 @@ int __init board_init (void)
 	int err = 0;

 	/* Allocate memory for MTD device structure and private data */
-	board_mtd = kmalloc (sizeof(struct mtd_info) + sizeof (struct nand_chip), GFP_KERNEL);
+	board_mtd = kzalloc(sizeof(struct mtd_info) + sizeof(struct nand_chip), GFP_KERNEL);
 	if (!board_mtd) {
 		printk ("Unable to allocate NAND MTD device structure.\n");
 		err = -ENOMEM;
 		goto out;
 	}

-	/* Initialize structures */
-	memset ((char *) board_mtd, 0, sizeof(struct mtd_info) + sizeof(struct nand_chip));
-
 	/* map physical adress */
 	baseaddr = (unsigned long)ioremap(CHIP_PHYSICAL_ADDRESS, 1024);
 	if(!baseaddr){
