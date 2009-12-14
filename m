Return-Path: <linux-kernel-owner+w=401wt.eu-S933033AbZLNVW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033AbZLNVW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 16:22:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758215AbZLNVWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 16:22:54 -0500
Received: from exprod6og105.obsmtp.com ([64.18.1.189]:47875 "EHLO
	exprod6og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758269AbZLNVWw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 16:22:52 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] fls_upm.c: use resource_size()
Date: Mon, 14 Dec 2009 16:22:49 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200EA4E@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] fls_upm.c: use resource_size()
Thread-Index: Acp9A5aOL9pnDcpKSZyOjyaShBtbPQ==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>,
       <linux-mtd@lists.infradead.org>
Cc: "David Woodhouse" <dwmw2@infradead.org>
X-OriginalArrivalTime: 14 Dec 2009 21:22:48.0607 (UTC) FILETIME=[95DBE2F0:01CA7D03]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Woodhouse <dwmw2@infradead.org>

---

diff --git a/drivers/mtd/nand/fsl_upm.c b/drivers/mtd/nand/fsl_upm.c
index d120cd8..0b9eaec 100644
--- a/drivers/mtd/nand/fsl_upm.c
+++ b/drivers/mtd/nand/fsl_upm.c
@@ -302,7 +302,7 @@ static int __devinit fun_probe(struct of_device *ofdev,
 				  FSL_UPM_WAIT_WRITE_BYTE;
 
 	fun->io_base = devm_ioremap_nocache(&ofdev->dev, io_res.start,
-					    io_res.end - io_res.start + 1);
+					    resource_size(&io_res));
 	if (!fun->io_base) {
 		ret = -ENOMEM;
 		goto err2; 
