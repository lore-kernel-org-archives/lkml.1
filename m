Return-Path: <linux-kernel-owner+w=401wt.eu-S933045AbZLNVTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933045AbZLNVTt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 16:19:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933025AbZLNVTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 16:19:46 -0500
Received: from exprod6ob117.obsmtp.com ([64.18.1.38]:60073 "EHLO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933005AbZLNVTp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 16:19:45 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] fsl_elbc_nand.c: user resource_size()
Date: Mon, 14 Dec 2009 16:19:44 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200EA4C@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] fsl_elbc_nand.c: user resource_size()
Thread-Index: Acp9Ayhe2VEuaDfOR9yPQRrngTWNYQ==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>,
       <linux-mtd@lists.infradead.org>
Cc: "David Woodhouse" <dwmw2@infradead.org>
X-OriginalArrivalTime: 14 Dec 2009 21:19:43.0462 (UTC) FILETIME=[27810060:01CA7D03]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Woodhouse <dwmw2@infradead.org>

---

diff --git a/drivers/mtd/nand/fsl_elbc_nand.c b/drivers/mtd/nand/fsl_elbc_nand.c
index ddd37d2..f5ed403 100644
--- a/drivers/mtd/nand/fsl_elbc_nand.c
+++ b/drivers/mtd/nand/fsl_elbc_nand.c
@@ -883,7 +883,7 @@ static int __devinit fsl_elbc_chip_probe(struct fsl_elbc_ctrl *ctrl,
 	priv->ctrl = ctrl;
 	priv->dev = ctrl->dev;
 
-	priv->vbase = ioremap(res.start, res.end - res.start + 1);
+	priv->vbase = ioremap(res.start, resource_size(&res));
 	if (!priv->vbase) {
 		dev_err(ctrl->dev, "failed to map chip region\n");
 		ret = -ENOMEM; 
