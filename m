Return-Path: <linux-kernel-owner+w=401wt.eu-S933001AbZLNVIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001AbZLNVIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 16:08:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932620AbZLNVIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 16:08:39 -0500
Received: from exprod6og112.obsmtp.com ([64.18.1.29]:51818 "EHLO
	exprod6og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932609AbZLNVIi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 16:08:38 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] au1550nd.c: remove unnecessary casts
Date: Mon, 14 Dec 2009 16:08:37 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200EA45@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] au1550nd.c: remove unnecessary casts
Thread-Index: Acp9AZp1Vjb/zmy4SmSrdy5+yGTH7Q==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>,
       <linux-mtd@lists.infradead.org>
Cc: "David Woodhouse" <dwmw2@infradead.org>
X-OriginalArrivalTime: 14 Dec 2009 21:08:36.0150 (UTC) FILETIME=[99C14560:01CA7D01]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary casts for p_nand, it is already a void __iomem *.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Woodhouse <dwmw2@infradead.org>

---

diff --git a/drivers/mtd/nand/au1550nd.c b/drivers/mtd/nand/au1550nd.c
index 92c334f..35f35f0 100644
--- a/drivers/mtd/nand/au1550nd.c
+++ b/drivers/mtd/nand/au1550nd.c
@@ -542,7 +542,7 @@ static int __init au1xxx_nand_init(void)
 	}
 	nand_phys = (mem_staddr << 4) & 0xFFFC0000;
 
-	p_nand = (void __iomem *)ioremap(nand_phys, 0x1000);
+	p_nand = ioremap(nand_phys, 0x1000);
 
 	/* make controller and MTD agree */
 	if (NAND_CS == 0)
@@ -587,7 +587,7 @@ static int __init au1xxx_nand_init(void)
 	return 0;
 
  outio:
-	iounmap((void *)p_nand);
+	iounmap(p_nand);
 
  outmem:
 	kfree(au1550_mtd);
@@ -608,7 +608,7 @@ static void __exit au1550_cleanup(void)
 	kfree(au1550_mtd);
 
 	/* Unmap */
-	iounmap((void *)p_nand);
+	iounmap(p_nand);
 }
 
 module_exit(au1550_cleanup); 
