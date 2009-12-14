Return-Path: <linux-kernel-owner+w=401wt.eu-S932476AbZLNTMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476AbZLNTMF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 14:12:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932420AbZLNTMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 14:12:01 -0500
Received: from exprod6og105.obsmtp.com ([64.18.1.189]:50208 "EHLO
	exprod6og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932419AbZLNTMA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 14:12:00 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] atmel-mci.c: use resource size()
Date: Mon, 14 Dec 2009 14:11:56 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200E9EA@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] atmel-mci.c: use resource size()
Thread-Index: Acp88U3dXV1qIRtZS3O2QgyLxV/tkQ==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>
Cc: <haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 14 Dec 2009 19:11:57.0047 (UTC) FILETIME=[4DF6E870:01CA7CF1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

---

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index fc25586..150242f 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -1628,7 +1628,7 @@ static int __init atmci_probe(struct platform_device *pdev)
 	}
 
 	ret = -ENOMEM;
-	host->regs = ioremap(regs->start, regs->end - regs->start + 1);
+	host->regs = ioremap(regs->start, resource_size(regs));
 	if (!host->regs)
 		goto err_ioremap;
  
