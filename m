Return-Path: <linux-kernel-owner+w=401wt.eu-S1758299AbZLNVav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758299AbZLNVav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 16:30:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932679AbZLNVat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 16:30:49 -0500
Received: from exprod6og105.obsmtp.com ([64.18.1.189]:51051 "EHLO
	exprod6og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654AbZLNVas convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 16:30:48 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] drivers/mtd/nand/gpio.c: use resource_size()
Date: Mon, 14 Dec 2009 16:30:46 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200EA54@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/mtd/nand/gpio.c: use resource_size()
Thread-Index: Acp9BLJyJzzUqZ1pSdefQ6VtmNL8Mw==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>,
       <linux-mtd@lists.infradead.org>
Cc: "David Woodhouse" <dwmw2@infradead.org>
X-OriginalArrivalTime: 14 Dec 2009 21:30:46.0877 (UTC) FILETIME=[B2EE18D0:01CA7D04]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Woodhouse <dwmw2@infradead.org>

---

diff --git a/drivers/mtd/nand/gpio.c b/drivers/mtd/nand/gpio.c
index 8f902e7..41f7d22 100644
--- a/drivers/mtd/nand/gpio.c
+++ b/drivers/mtd/nand/gpio.c
@@ -181,11 +181,11 @@ static int __devexit gpio_nand_remove(struct platform_device *dev)
 	res = platform_get_resource(dev, IORESOURCE_MEM, 1);
 	iounmap(gpiomtd->io_sync);
 	if (res)
-		release_mem_region(res->start, res->end - res->start + 1);
+		release_mem_region(res->start, resource_size(res));
 
 	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	iounmap(gpiomtd->nand_chip.IO_ADDR_R);
-	release_mem_region(res->start, res->end - res->start + 1);
+	release_mem_region(res->start, resource_size(res));
 
 	if (gpio_is_valid(gpiomtd->plat.gpio_nwp))
 		gpio_set_value(gpiomtd->plat.gpio_nwp, 0);
@@ -208,14 +208,14 @@ static void __iomem *request_and_remap(struct resource *res, size_t size,
 {
 	void __iomem *ptr;
 
-	if (!request_mem_region(res->start, res->end - res->start + 1, name)) {
+	if (!request_mem_region(res->start, resource_size(res), name)) {
 		*err = -EBUSY;
 		return NULL;
 	}
 
 	ptr = ioremap(res->start, size);
 	if (!ptr) {
-		release_mem_region(res->start, res->end - res->start + 1);
+		release_mem_region(res->start, resource_size(res));
 		*err = -ENOMEM;
 	}
 	return ptr;
@@ -338,10 +338,10 @@ err_nwp:
 err_nce:
 	iounmap(gpiomtd->io_sync);
 	if (res1)
-		release_mem_region(res1->start, res1->end - res1->start + 1);
+		release_mem_region(res1->start, resource_size(res1));
 err_sync:
 	iounmap(gpiomtd->nand_chip.IO_ADDR_R);
-	release_mem_region(res0->start, res0->end - res0->start + 1);
+	release_mem_region(res0->start, resouce_size(res0));
 err_map:
 	kfree(gpiomtd);
 	return ret; 
