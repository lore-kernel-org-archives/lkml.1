Return-Path: <linux-kernel-owner+w=401wt.eu-S932315AbZLDRdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315AbZLDRdh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 12:33:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932235AbZLDRdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 12:33:36 -0500
Received: from exprod6og101.obsmtp.com ([64.18.1.181]:54393 "EHLO
	exprod6og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167AbZLDRdf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 12:33:35 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: mpcore_wdt.c: use resource_size()
Date: Fri, 4 Dec 2009 12:33:40 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901FB06D0@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: mpcore_wdt.c: use resource_size()
Thread-Index: Acp1B+tFV8Yt42GvRLa8KZFj8rUFEA==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
Cc: <wim@iguana.be>
X-OriginalArrivalTime: 04 Dec 2009 17:33:41.0013 (UTC) FILETIME=[EB860450:01CA7507]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Wim Van Sebroeck <wim@iguana.be>

---

diff --git a/drivers/watchdog/mpcore_wdt.c b/drivers/watchdog/mpcore_wdt.c
index 83fa34b..a2dc07c 100644
--- a/drivers/watchdog/mpcore_wdt.c
+++ b/drivers/watchdog/mpcore_wdt.c
@@ -350,7 +350,7 @@ static int __devinit mpcore_wdt_probe(struct platform_device *dev)
 		ret = -ENXIO;
 		goto err_free;
 	}
-	wdt->base = ioremap(res->start, res->end - res->start + 1);
+	wdt->base = ioremap(res->start, resource_size(res));
 	if (!wdt->base) {
 		ret = -ENOMEM;
 		goto err_free; 
