Return-Path: <linux-kernel-owner+w=401wt.eu-S1758451AbZLNV72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758451AbZLNV72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 16:59:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758387AbZLNV72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 16:59:28 -0500
Received: from exprod6og110.obsmtp.com ([64.18.1.25]:45679 "EHLO
	exprod6og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758373AbZLNV71 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 16:59:27 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] drivers/mtd/nand/sh_flctl.c: use resource_size()
Date: Mon, 14 Dec 2009 16:59:27 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200EA68@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/mtd/nand/sh_flctl.c: use resource_size()
Thread-Index: Acp9CLRhiORin6X3TZi/siDYVNOeNQ==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>,
       <linux-mtd@lists.infradead.org>
Cc: "David Woodhouse" <dwmw2@infradead.org>, <shimoda.yoshihiro@renesas.com>
X-OriginalArrivalTime: 14 Dec 2009 21:59:25.0325 (UTC) FILETIME=[B33473D0:01CA7D08]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Yoshihiro Shimoda <shimoda.yoshihiro@renesas.com>

---

diff --git a/drivers/mtd/nand/sh_flctl.c b/drivers/mtd/nand/sh_flctl.c
index 02bef21..4260ab7 100644
--- a/drivers/mtd/nand/sh_flctl.c
+++ b/drivers/mtd/nand/sh_flctl.c
@@ -797,7 +797,7 @@ static int __init flctl_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	flctl->reg = ioremap(res->start, res->end - res->start + 1);
+	flctl->reg = ioremap(res->start, resource_size(res));
 	if (flctl->reg == NULL) {
 		printk(KERN_ERR "%s: ioremap error.\n", __func__);
 		ret = -ENOMEM; 
