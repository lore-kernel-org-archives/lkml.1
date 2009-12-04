Return-Path: <linux-kernel-owner+w=401wt.eu-S932397AbZLDRs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397AbZLDRs0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 12:48:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756978AbZLDRsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 12:48:25 -0500
Received: from exprod6og101.obsmtp.com ([64.18.1.181]:32780 "EHLO
	exprod6og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756756AbZLDRsY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 12:48:24 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: rm9k_wdt.c: use resource_size()
Date: Fri, 4 Dec 2009 12:48:30 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901FB06E2@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: rm9k_wdt.c: use resource_size()
Thread-Index: Acp1Cf3lnLplMLYWSaSVfuSnIN7MAQ==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
Cc: <wim@iguana.be>, <hmh@hmh.eng.br>, <tom.leiming@gmail.com>
X-OriginalArrivalTime: 04 Dec 2009 17:48:29.0974 (UTC) FILETIME=[FD62B360:01CA7509]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ming Lei <tom.leiming@gmail.com>

---

diff --git a/drivers/watchdog/rm9k_wdt.c b/drivers/watchdog/rm9k_wdt.c
index bb66958..198f748 100644
--- a/drivers/watchdog/rm9k_wdt.c
+++ b/drivers/watchdog/rm9k_wdt.c
@@ -360,7 +360,7 @@ static int __devinit wdt_gpi_probe(struct platform_device *pdv)
 	if (unlikely(!rr || !ri || !rc))
 		return -ENXIO;
 
-	wd_regs = ioremap_nocache(rr->start, rr->end + 1 - rr->start);
+	wd_regs = ioremap_nocache(rr->start, resource_size(rr));
 	if (unlikely(!wd_regs))
 		return -ENOMEM;
 	wd_irq = ri->start; 
