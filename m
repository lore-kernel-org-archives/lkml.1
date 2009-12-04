Return-Path: <linux-kernel-owner+w=401wt.eu-S932324AbZLDRgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324AbZLDRgO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 12:36:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932240AbZLDRgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 12:36:12 -0500
Received: from exprod6og104.obsmtp.com ([64.18.1.187]:39245 "EHLO
	exprod6og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235AbZLDRgM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 12:36:12 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: mv64x60_wdt.c: use resource_size()
Date: Fri, 4 Dec 2009 12:36:17 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901FB06D2@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: mv64x60_wdt.c: use resource_size()
Thread-Index: Acp1CEj0BBxspQeFSUeFe3pPLle8Ww==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
Cc: <wim@iguana.be>
X-OriginalArrivalTime: 04 Dec 2009 17:36:17.0453 (UTC) FILETIME=[48C4DDD0:01CA7508]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Wim Van Sebroeck <wim@iguana.be>

---

diff --git a/drivers/watchdog/mv64x60_wdt.c b/drivers/watchdog/mv64x60_wdt.c
index acf589d..a51dbe4 100644
--- a/drivers/watchdog/mv64x60_wdt.c
+++ b/drivers/watchdog/mv64x60_wdt.c
@@ -275,7 +275,7 @@ static int __devinit mv64x60_wdt_probe(struct platform_device *dev)
 	if (!r)
 		return -ENODEV;
 
-	mv64x60_wdt_regs = ioremap(r->start, r->end - r->start + 1);
+	mv64x60_wdt_regs = ioremap(r->start, resource_size(r));
 	if (mv64x60_wdt_regs == NULL)
 		return -ENOMEM;
  
