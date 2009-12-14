Return-Path: <linux-kernel-owner+w=401wt.eu-S1757963AbZLNU6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963AbZLNU6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 15:58:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757738AbZLNU6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 15:58:09 -0500
Received: from exprod6ob109.obsmtp.com ([64.18.1.22]:35484 "EHLO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755170AbZLNU6I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 15:58:08 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] atmel_nand.c: use resource_size()
Date: Mon, 14 Dec 2009 15:58:06 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200EA41@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] atmel_nand.c: use resource_size()
Thread-Index: Acp9ACKsx6nqH8tSQWGT/WNu74pbCQ==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>,
       <linux-mtd@lists.infradead.org>
X-OriginalArrivalTime: 14 Dec 2009 20:58:05.0560 (UTC) FILETIME=[21E4DF80:01CA7D00]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
index f8e9975..162b4f2 100644
--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@ -399,7 +399,7 @@ static int __init atmel_nand_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	host->io_base = ioremap(mem->start, mem->end - mem->start + 1);
+	host->io_base = ioremap(mem->start, resource_size(mem));
 	if (host->io_base == NULL) {
 		printk(KERN_ERR "atmel_nand: ioremap failed\n");
 		res = -EIO;
@@ -433,7 +433,7 @@ static int __init atmel_nand_probe(struct platform_device *pdev)
 	if (no_ecc)
 		nand_chip->ecc.mode = NAND_ECC_NONE;
 	if (hard_ecc && regs) {
-		host->ecc = ioremap(regs->start, regs->end - regs->start + 1);
+		host->ecc = ioremap(regs->start, resource_size(regs));
 		if (host->ecc == NULL) {
 			printk(KERN_ERR "atmel_nand: ioremap failed\n");
 			res = -EIO; 
