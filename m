Return-Path: <linux-kernel-owner+w=401wt.eu-S933007AbZLNVOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007AbZLNVOO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 16:14:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932656AbZLNVOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 16:14:14 -0500
Received: from exprod6og116.obsmtp.com ([64.18.1.37]:45430 "EHLO
	exprod6og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644AbZLNVON convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 16:14:13 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] davinci_nand.c: use resource_size()
Date: Mon, 14 Dec 2009 16:13:13 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200EA46@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] davinci_nand.c: use resource_size()
Thread-Index: Acp9Aj7lSLM6zpGoSka1wxYuzEn5RA==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>,
       <linux-mtd@lists.infradead.org>
Cc: "David Woodhouse" <dwmw2@infradead.org>
X-OriginalArrivalTime: 14 Dec 2009 21:13:11.0983 (UTC) FILETIME=[3E2A0BF0:01CA7D02]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ioremap'ed sizes are off by 1, use resource_size() for correct value.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Woodhouse <dwmw2@infradead.org>

---

diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
index f13f5b9..b6905f8 100644
--- a/drivers/mtd/nand/davinci_nand.c
+++ b/drivers/mtd/nand/davinci_nand.c
@@ -566,8 +566,8 @@ static int __init nand_davinci_probe(struct platform_device *pdev)
 		goto err_nomem;
 	}
 
-	vaddr = ioremap(res1->start, res1->end - res1->start);
-	base = ioremap(res2->start, res2->end - res2->start);
+	vaddr = ioremap(res1->start, resource_size(res1));
+	base = ioremap(res2->start, resource_size(res2));
 	if (!vaddr || !base) {
 		dev_err(&pdev->dev, "ioremap failed\n");
 		ret = -EINVAL; 
