Return-Path: <linux-kernel-owner+w=401wt.eu-S1757097AbZLDRUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097AbZLDRUW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 12:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756756AbZLDRUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 12:20:21 -0500
Received: from exprod6ob109.obsmtp.com ([64.18.1.22]:55227 "EHLO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755151AbZLDRUU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 12:20:20 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: adx_wdt.c: use resource_size()
Date: Fri, 4 Dec 2009 12:20:20 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901FB06C8@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: adx_wdt.c: use resource_size()
Thread-Index: Acp1Bg6mf3DSh1+dTySuFR0KO0B3Fg==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
Cc: <thierry.reding@avionic-design.de>
X-OriginalArrivalTime: 04 Dec 2009 17:20:20.0605 (UTC) FILETIME=[0E7172D0:01CA7506]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>

---

diff --git a/drivers/watchdog/adx_wdt.c b/drivers/watchdog/adx_wdt.c
index 77afb0a..ee95758 100644
--- a/drivers/watchdog/adx_wdt.c
+++ b/drivers/watchdog/adx_wdt.c
@@ -242,14 +242,14 @@ static int __devinit adx_wdt_probe(struct platform_device *pdev)
 	}
 
 	res = devm_request_mem_region(&pdev->dev, res->start,
-			res->end - res->start + 1, res->name);
+			resource_size(res), res->name);
 	if (!res) {
 		dev_err(&pdev->dev, "cannot request I/O memory region\n");
 		return -ENXIO;
 	}
 
 	wdt->base = devm_ioremap_nocache(&pdev->dev, res->start,
-			res->end - res->start + 1);
+			resource_size(res));
 	if (!wdt->base) {
 		dev_err(&pdev->dev, "cannot remap I/O memory region\n");
 		return -ENXIO; 
