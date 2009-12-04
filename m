Return-Path: <linux-kernel-owner+w=401wt.eu-S932446AbZLDRy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446AbZLDRy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 12:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932428AbZLDRyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 12:54:54 -0500
Received: from exprod6og108.obsmtp.com ([64.18.1.21]:47748 "EHLO
	exprod6og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932415AbZLDRyt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 12:54:49 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: txx9wdt.c: use resource_size()
Date: Fri, 4 Dec 2009 12:54:55 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901FB06E9@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: txx9wdt.c: use resource_size()
Thread-Index: Acp1CuNqp7xSCRchQ0S6VFPjJNLKBQ==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
Cc: <wim@iguana.be>
X-OriginalArrivalTime: 04 Dec 2009 17:54:55.0658 (UTC) FILETIME=[E34568A0:01CA750A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Wim Van Sebroeck <wim@iguana.be>

---

diff --git a/drivers/watchdog/txx9wdt.c b/drivers/watchdog/txx9wdt.c
index 6adab77..fab1ed9 100644
--- a/drivers/watchdog/txx9wdt.c
+++ b/drivers/watchdog/txx9wdt.c
@@ -215,11 +215,11 @@ static int __init txx9wdt_probe(struct platform_device *dev)
 	if (!res)
 		goto exit_busy;
 	if (!devm_request_mem_region(&dev->dev,
-				     res->start, res->end - res->start + 1,
+				     res->start, resource_size(res),
 				     "txx9wdt"))
 		goto exit_busy;
 	txx9wdt_reg = devm_ioremap(&dev->dev,
-				   res->start, res->end - res->start + 1);
+				   res->start, resource_size(res));
 	if (!txx9wdt_reg)
 		goto exit_busy;
  
