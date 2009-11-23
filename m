Return-Path: <linux-kernel-owner+w=401wt.eu-S1753392AbZKWSP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbZKWSP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 13:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbZKWSP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 13:15:28 -0500
Received: from exprod6ob109.obsmtp.com ([64.18.1.22]:48189 "EHLO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750820AbZKWSP1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 13:15:27 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: drivers/ide/au1xxx-ide.c: use resource_size()
Date: Mon, 23 Nov 2009 13:15:32 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901EE5BFD@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: drivers/ide/au1xxx-ide.c: use resource_size()
Thread-Index: AcpsaPHWA/wxJDXARlSRLSGFtV3r+w==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>
X-OriginalArrivalTime: 23 Nov 2009 18:15:32.0280 (UTC) FILETIME=[F1CFB380:01CA6C68]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size() for {request/release}_mem_region and ioremap.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/drivers/ide/au1xxx-ide.c b/drivers/ide/au1xxx-ide.c
index 58121bd..87cef0c 100644
--- a/drivers/ide/au1xxx-ide.c
+++ b/drivers/ide/au1xxx-ide.c
@@ -532,14 +532,13 @@ static int au_ide_probe(struct platform_device *dev)
 		goto out;
 	}
 
-	if (!request_mem_region(res->start, res->end - res->start + 1,
-				dev->name)) {
+	if (!request_mem_region(res->start, resource_size(res), dev->name)) {
 		pr_debug("%s: request_mem_region failed\n", DRV_NAME);
 		ret =  -EBUSY;
 		goto out;
 	}
 
-	ahwif->regbase = (u32)ioremap(res->start, res->end - res->start + 1);
+	ahwif->regbase = (u32)ioremap(res->start, resource_size(res));
 	if (ahwif->regbase == 0) {
 		ret = -ENOMEM;
 		goto out;
@@ -575,7 +574,7 @@ static int au_ide_remove(struct platform_device *dev)
 	iounmap((void *)ahwif->regbase);
 
 	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, res->end - res->start + 1);
+	release_mem_region(res->start, resource_size(res));
 
 	return 0;
 } 
