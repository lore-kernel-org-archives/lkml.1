Return-Path: <linux-kernel-owner+w=401wt.eu-S932404AbZLDRv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404AbZLDRv0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 12:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932295AbZLDRvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 12:51:25 -0500
Received: from exprod6og116.obsmtp.com ([64.18.1.37]:33605 "EHLO
	exprod6og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247AbZLDRvZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 12:51:25 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: s3c2410_wdt.c: use resource_size()
Date: Fri, 4 Dec 2009 12:51:31 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901FB06E6@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: s3c2410_wdt.c: use resource_size()
Thread-Index: Acp1Cml5nEskTwXKQUKjjxqD0XjR2w==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
Cc: <wim@iguana.be>, <support@simtec.co.uk>
X-OriginalArrivalTime: 04 Dec 2009 17:51:30.0965 (UTC) FILETIME=[6943BC50:01CA750A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Vincent Sanders <support@simtec.co.uk>

---

diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index b57ac6b..1639e0e 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -348,7 +348,7 @@ static int __devinit s3c2410wdt_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	size = (res->end - res->start) + 1;
+	size = resource_size(res);
 	wdt_mem = request_mem_region(res->start, size, pdev->name);
 	if (wdt_mem == NULL) {
 		dev_err(dev, "failed to get memory region\n"); 
