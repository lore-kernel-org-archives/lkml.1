Return-Path: <linux-kernel-owner+w=401wt.eu-S1762813AbZLLAPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762813AbZLLAPt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 19:15:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761520AbZLLAPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 19:15:44 -0500
Received: from exprod6ob117.obsmtp.com ([64.18.1.38]:32937 "EHLO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761515AbZLLAPn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 19:15:43 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] atmel_pwm.c: use resource_size()
Date: Fri, 11 Dec 2009 19:15:51 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901FB110E@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] atmel_pwm.c: use resource_size()
Thread-Index: Acp6wEOQ/45UKScKSE2y23ktDa8utw==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 12 Dec 2009 00:15:49.0939 (UTC) FILETIME=[42603030:01CA7AC0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size() for ioremap.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/drivers/misc/atmel_pwm.c b/drivers/misc/atmel_pwm.c
index 6aa5294..6e1fef5 100644
--- a/drivers/misc/atmel_pwm.c
+++ b/drivers/misc/atmel_pwm.c
@@ -328,7 +328,7 @@ static int __init pwm_probe(struct platform_device *pdev)
 	p->pdev = pdev;
 	p->mask = *mp;
 	p->irq = irq;
-	p->base = ioremap(r->start, r->end - r->start + 1);
+	p->base = ioremap(r->start, resource_size(r));
 	if (!p->base)
 		goto fail;
 	p->clk = clk_get(&pdev->dev, "pwm_clk"); 
