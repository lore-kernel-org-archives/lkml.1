Return-Path: <linux-kernel-owner+w=401wt.eu-S1762281AbZLLAHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762281AbZLLAHa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 19:07:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758394AbZLLAH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 19:07:26 -0500
Received: from exprod6og105.obsmtp.com ([64.18.1.189]:59620 "EHLO
	exprod6og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761538AbZLLAHZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 19:07:25 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] t7l66xb.c: use resource_size()
Date: Fri, 11 Dec 2009 19:07:32 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901FB110A@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] t7l66xb.c: use resource_size()
Thread-Index: Acp6vxnGPYwzqUNxTkuln5AnY95uDA==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>
Cc: <ian@mnementh.co.uk>, <sameo@linux.intel.com>
X-OriginalArrivalTime: 12 Dec 2009 00:07:30.0742 (UTC) FILETIME=[18D4C560:01CA7ABF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size() for ioremap.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: Samuel Ortiz <sameo@linux.intel.com>

---

diff --git a/drivers/mfd/t7l66xb.c b/drivers/mfd/t7l66xb.c
index 0a255c1..20bbd1d 100644
--- a/drivers/mfd/t7l66xb.c
+++ b/drivers/mfd/t7l66xb.c
@@ -341,7 +341,7 @@ static int t7l66xb_probe(struct platform_device *dev)
 	if (ret)
 		goto err_request_scr;
 
-	t7l66xb->scr = ioremap(rscr->start, rscr->end - rscr->start + 1);
+	t7l66xb->scr = ioremap(rscr->start, resource_size(rscr));
 	if (!t7l66xb->scr) {
 		ret = -ENOMEM;
 		goto err_ioremap; 
