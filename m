Return-Path: <linux-kernel-owner+w=401wt.eu-S1753441AbZLNVgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbZLNVgi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 16:36:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751011AbZLNVgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 16:36:37 -0500
Received: from exprod6og103.obsmtp.com ([64.18.1.185]:56756 "EHLO
	exprod6og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbZLNVgh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 16:36:37 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] nomadik_nand.c: use resource_size()
Date: Mon, 14 Dec 2009 16:36:37 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200EA5D@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] nomadik_nand.c: use resource_size()
Thread-Index: Acp9BYOfBT4/8h0kRRCS7rrgSv9zQw==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>,
       <linux-mtd@lists.infradead.org>
Cc: "David Woodhouse" <dwmw2@infradead.org>
X-OriginalArrivalTime: 14 Dec 2009 21:36:35.0330 (UTC) FILETIME=[829FCE20:01CA7D05]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Woodhouse <dwmw2@infradead.org>

---

diff --git a/drivers/mtd/nand/nomadik_nand.c b/drivers/mtd/nand/nomadik_nand.c
index 7c302d5..ed966c0 100644
--- a/drivers/mtd/nand/nomadik_nand.c
+++ b/drivers/mtd/nand/nomadik_nand.c
@@ -104,21 +104,21 @@ static int nomadik_nand_probe(struct platform_device *pdev)
 		ret = -EIO;
 		goto err_unmap;
 	}
-	host->addr_va = ioremap(res->start, res->end - res->start + 1);
+	host->addr_va = ioremap(res->start, resource_size(res));
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "nand_data");
 	if (!res) {
 		ret = -EIO;
 		goto err_unmap;
 	}
-	host->data_va = ioremap(res->start, res->end - res->start + 1);
+	host->data_va = ioremap(res->start, resource_size(res));
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "nand_cmd");
 	if (!res) {
 		ret = -EIO;
 		goto err_unmap;
 	}
-	host->cmd_va = ioremap(res->start, res->end - res->start + 1);
+	host->cmd_va = ioremap(res->start, resource_size(res));
 
 	if (!host->addr_va || !host->data_va || !host->cmd_va) {
 		ret = -ENOMEM; 
