Return-Path: <linux-kernel-owner+w=401wt.eu-S1761580AbZLLALI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761580AbZLLALI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 19:11:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761066AbZLLALG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 19:11:06 -0500
Received: from exprod6og115.obsmtp.com ([64.18.1.35]:35830 "EHLO
	exprod6og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760947AbZLLALG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 19:11:06 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] tc6393xb.c: use resource_size()
Date: Fri, 11 Dec 2009 19:11:13 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901FB110D@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] tc6393xb.c: use resource_size()
Thread-Index: Acp6v52rENeUS+wlR5qurb64hGjQiw==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>
Cc: <ian@mnementh.co.uk>, <sameo@linux.intel.com>
X-OriginalArrivalTime: 12 Dec 2009 00:11:11.0902 (UTC) FILETIME=[9CA71BE0:01CA7ABF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size() for ioremap.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: Samuel Ortiz <sameo@linux.intel.com>

---

diff --git a/drivers/mfd/tc6393xb.c b/drivers/mfd/tc6393xb.c
index 1429a73..50b1610 100644
--- a/drivers/mfd/tc6393xb.c
+++ b/drivers/mfd/tc6393xb.c
@@ -610,7 +610,7 @@ static int __devinit tc6393xb_probe(struct platform_device *dev)
 	if (ret)
 		goto err_request_scr;
 
-	tc6393xb->scr = ioremap(rscr->start, rscr->end - rscr->start + 1);
+	tc6393xb->scr = ioremap(rscr->start, resource_size(rscr));
 	if (!tc6393xb->scr) {
 		ret = -ENOMEM;
 		goto err_ioremap; 
