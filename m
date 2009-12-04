Return-Path: <linux-kernel-owner+w=401wt.eu-S932369AbZLDRlC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369AbZLDRlC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 12:41:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932340AbZLDRlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 12:41:00 -0500
Received: from exprod6og104.obsmtp.com ([64.18.1.187]:41336 "EHLO
	exprod6og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932338AbZLDRlA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 12:41:00 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: omap_wdt.c: use resource_size()
Date: Fri, 4 Dec 2009 12:41:06 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901FB06D9@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: omap_wdt.c: use resource_size()
Thread-Index: Acp1CPU4oKadcBjLR2qjmoE9MlLaYg==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
Cc: <wim@iguana.be>, <khilman@ti.deeprootsystems.com>, <ubh@ti.com>
X-OriginalArrivalTime: 04 Dec 2009 17:41:06.0400 (UTC) FILETIME=[F4FEAE00:01CA7508]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Kevin Hilman <khilman@ti.deeprootsystems.com>
Cc: Ulrik Bech Hald <ubh@ti.com>

---

diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index 3ed571a..6ea3235 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -277,8 +277,7 @@ static int __devinit omap_wdt_probe(struct platform_device *pdev)
 		goto err_busy;
 	}
 
-	mem = request_mem_region(res->start, res->end - res->start + 1,
-				 pdev->name);
+	mem = request_mem_region(res->start, resource_size(res), pdev->name);
 	if (!mem) {
 		ret = -EBUSY;
 		goto err_busy;
@@ -306,7 +305,7 @@ static int __devinit omap_wdt_probe(struct platform_device *pdev)
 		goto err_clk;
 	}
 
-	wdev->base = ioremap(res->start, res->end - res->start + 1);
+	wdev->base = ioremap(res->start, resource_size(res));
 	if (!wdev->base) {
 		ret = -ENOMEM;
 		goto err_ioremap;
@@ -358,7 +357,7 @@ err_clk:
 	kfree(wdev);
 
 err_kzalloc:
-	release_mem_region(res->start, res->end - res->start + 1);
+	release_mem_region(res->start, resource_size(res));
 
 err_busy:
 err_get_resource:
@@ -383,7 +382,7 @@ static int __devexit omap_wdt_remove(struct platform_device *pdev)
 		return -ENOENT;
 
 	misc_deregister(&(wdev->omap_wdt_miscdev));
-	release_mem_region(res->start, res->end - res->start + 1);
+	release_mem_region(res->start, resource_size(res));
 	platform_set_drvdata(pdev, NULL);
 
 	clk_put(wdev->ick); 
