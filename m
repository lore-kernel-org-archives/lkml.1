Return-Path: <linux-kernel-owner+w=401wt.eu-S1762128AbZLKBQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762128AbZLKBQv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 20:16:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757023AbZLKBQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 20:16:50 -0500
Received: from exprod6og105.obsmtp.com ([64.18.1.189]:34084 "EHLO
	exprod6og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbZLKBQu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 20:16:50 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] timeriomem-rng.c: use resource_size()
Date: Thu, 10 Dec 2009 20:16:54 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901FB0FBA@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] timeriomem-rng.c: use resource_size()
Thread-Index: Acp5/6A6pRaTlbERRT21/EYlrNXwnw==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>
Cc: "Alexander Clouter" <alex@digriz.org.uk>
X-OriginalArrivalTime: 11 Dec 2009 01:16:55.0943 (UTC) FILETIME=[A1124170:01CA79FF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size() for ioremap.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Alexander Clouter <alex@digriz.org.uk>

---

diff --git a/drivers/char/hw_random/timeriomem-rng.c b/drivers/char/hw_random/timeriomem-rng.c
index a94e930..a8428e6 100644
--- a/drivers/char/hw_random/timeriomem-rng.c
+++ b/drivers/char/hw_random/timeriomem-rng.c
@@ -100,8 +100,7 @@ static int __devinit timeriomem_rng_probe(struct platform_device *pdev)
 
 	timeriomem_rng_data = pdev->dev.platform_data;
 
-	timeriomem_rng_data->address = ioremap(res->start,
-						res->end - res->start + 1);
+	timeriomem_rng_data->address = ioremap(res->start, resource_size(res));
 	if (!timeriomem_rng_data->address)
 		return -EIO;
  
