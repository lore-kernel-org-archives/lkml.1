Return-Path: <linux-kernel-owner+w=401wt.eu-S1762900AbZLLAT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762900AbZLLAT2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 19:19:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762841AbZLLATW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 19:19:22 -0500
Received: from exprod6og103.obsmtp.com ([64.18.1.185]:34303 "EHLO
	exprod6og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762728AbZLLATV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 19:19:21 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] atmel-ssc.c: use resource_suze()
Date: Fri, 11 Dec 2009 19:19:29 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901FB1110@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] atmel-ssc.c: use resource_suze()
Thread-Index: Acp6wMU0n+F0DG6gS4CPIGAJG3k6lQ==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>
Cc: <hans-christian.egtvedt@atmel.com>
X-OriginalArrivalTime: 12 Dec 2009 00:19:27.0467 (UTC) FILETIME=[C40853B0:01CA7AC0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size() for ioremap.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>

---

diff --git a/drivers/misc/atmel-ssc.c b/drivers/misc/atmel-ssc.c
index 558bf3f..f4acd10 100644
--- a/drivers/misc/atmel-ssc.c
+++ b/drivers/misc/atmel-ssc.c
@@ -94,7 +94,7 @@ static int __init ssc_probe(struct platform_device *pdev)
 	}
 
 	ssc->pdev = pdev;
-	ssc->regs = ioremap(regs->start, regs->end - regs->start + 1);
+	ssc->regs = ioremap(regs->start, resource_size(regs));
 	if (!ssc->regs) {
 		dev_dbg(&pdev->dev, "ioremap failed\n");
 		retval = -EINVAL; 
