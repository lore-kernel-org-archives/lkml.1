Return-Path: <linux-kernel-owner+w=401wt.eu-S932318AbZLDR2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318AbZLDR2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 12:28:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932306AbZLDR2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 12:28:33 -0500
Received: from exprod6og101.obsmtp.com ([64.18.1.181]:52166 "EHLO
	exprod6og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307AbZLDR23 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 12:28:29 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: davinci_wdt.c: use resource_size()
Date: Fri, 4 Dec 2009 12:28:35 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901FB06CD@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: davinci_wdt.c: use resource_size()
Thread-Index: Acp1BzVSj5oLv/jtQfiKzQo7JY74fw==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
Cc: <wim@iguana.be>, <khilman@deeprootsystems.com>
X-OriginalArrivalTime: 04 Dec 2009 17:28:34.0630 (UTC) FILETIME=[34E7AE60:01CA7507]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Kevin Hilman <khilman@deeprootsystems.com>

---

diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
index 9d7520f..887136d 100644
--- a/drivers/watchdog/davinci_wdt.c
+++ b/drivers/watchdog/davinci_wdt.c
@@ -221,7 +221,7 @@ static int __devinit davinci_wdt_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	size = res->end - res->start + 1;
+	size = resource_size(res);
 	wdt_mem = request_mem_region(res->start, size, pdev->name);
 
 	if (wdt_mem == NULL) { 
