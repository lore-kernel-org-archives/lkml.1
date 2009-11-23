Return-Path: <linux-kernel-owner+w=401wt.eu-S1752772AbZKWSCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbZKWSCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 13:02:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbZKWSCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 13:02:34 -0500
Received: from exprod6og101.obsmtp.com ([64.18.1.181]:45876 "EHLO
	exprod6og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbZKWSCe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 13:02:34 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: drivers/dma/mv_xor.c: use resource_size()
Date: Mon, 23 Nov 2009 13:02:40 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901EE5BF5@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: drivers/dma/mv_xor.c: use resource_size()
Thread-Index: AcpsZyWcnPwxPJjOTguzevF7zf1RpA==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 23 Nov 2009 18:02:40.0035 (UTC) FILETIME=[25847730:01CA6C67]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size() for devm_ioremap.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 466ab10..ec280ff 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -1311,7 +1311,7 @@ static int mv_xor_shared_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	msp->xor_base = devm_ioremap(&pdev->dev, res->start,
-				     res->end - res->start + 1);
+				     resource_size(res));
 	if (!msp->xor_base)
 		return -EBUSY;
 
@@ -1320,7 +1320,7 @@ static int mv_xor_shared_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	msp->xor_high_base = devm_ioremap(&pdev->dev, res->start,
-					  res->end - res->start + 1);
+					  resource_size(res));
 	if (!msp->xor_high_base)
 		return -EBUSY;
  
