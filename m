Return-Path: <linux-kernel-owner+w=401wt.eu-S932380AbZLDRow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380AbZLDRow (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 12:44:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932360AbZLDRov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 12:44:51 -0500
Received: from exprod6og102.obsmtp.com ([64.18.1.183]:40938 "EHLO
	exprod6og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932346AbZLDRou convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 12:44:50 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: pnx4008_wdt.c: use resource_size()
Date: Fri, 4 Dec 2009 12:44:56 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901FB06DD@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: pnx4008_wdt.c: use resource_size()
Thread-Index: Acp1CX5DFj4qWSn5QTWjrA7v4n6pmQ==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
Cc: <wim@iguana.be>
X-OriginalArrivalTime: 04 Dec 2009 17:44:56.0531 (UTC) FILETIME=[7E29E230:01CA7509]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Wim Van Sebroeck <wim@iguana.be>

---

diff --git a/drivers/watchdog/pnx4008_wdt.c b/drivers/watchdog/pnx4008_wdt.c
index 4d227b1..430a584 100644
--- a/drivers/watchdog/pnx4008_wdt.c
+++ b/drivers/watchdog/pnx4008_wdt.c
@@ -264,7 +264,7 @@ static int __devinit pnx4008_wdt_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	size = res->end - res->start + 1;
+	size = resource_size(res);
 	wdt_mem = request_mem_region(res->start, size, pdev->name);
 
 	if (wdt_mem == NULL) { 
