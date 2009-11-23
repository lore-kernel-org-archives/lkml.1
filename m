Return-Path: <linux-kernel-owner+w=401wt.eu-S1754899AbZKWS1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbZKWS1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 13:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754836AbZKWS1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 13:27:19 -0500
Received: from exprod6og103.obsmtp.com ([64.18.1.185]:56124 "EHLO
	exprod6og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151AbZKWS1S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 13:27:18 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: drivers/ide/tx4938ide.c: use resource_size()
Date: Mon, 23 Nov 2009 13:27:23 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901EE5C05@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: drivers/ide/tx4938ide.c: use resource_size()
Thread-Index: Acpsapl7TEk+0EC9SYmj9MoKVKQDjA==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>
X-OriginalArrivalTime: 23 Nov 2009 18:27:23.0235 (UTC) FILETIME=[9992D330:01CA6C6A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size() for devm_request_mem_region.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/drivers/ide/tx4938ide.c b/drivers/ide/tx4938ide.c
index ea89fdd..fd59c0d 100644
--- a/drivers/ide/tx4938ide.c
+++ b/drivers/ide/tx4938ide.c
@@ -146,7 +146,7 @@ static int __init tx4938ide_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	if (!devm_request_mem_region(&pdev->dev, res->start,
-				     res->end - res->start + 1, "tx4938ide"))
+				     resource_size(res), "tx4938ide"))
 		return -EBUSY;
 	mapbase = (unsigned long)devm_ioremap(&pdev->dev, res->start,
 					      8 << pdata->ioport_shift); 
