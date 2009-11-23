Return-Path: <linux-kernel-owner+w=401wt.eu-S1753812AbZKWRsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbZKWRsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 12:48:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbZKWRsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 12:48:33 -0500
Received: from exprod6ob111.obsmtp.com ([64.18.1.26]:47124 "EHLO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750891AbZKWRsc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 12:48:32 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: drivers/crypto/mv_cesa.c: use resource_size()
Date: Mon, 23 Nov 2009 12:48:36 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901EE5BE5@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: drivers/crypto/mv_cesa.c: use resource_size()
Thread-Index: AcpsZS6gUVWKlN4hRXmeochvvWn6Mg==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>
Cc: <sebastian@breakpoint.cc>
X-OriginalArrivalTime: 23 Nov 2009 17:48:37.0556 (UTC) FILETIME=[2F5C5F40:01CA6C65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size() for ioremap.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

---

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index b21ef63..b8770e9 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -495,7 +495,7 @@ static int mv_probe(struct platform_device *pdev)
 
 	spin_lock_init(&cp->lock);
 	crypto_init_queue(&cp->queue, 50);
-	cp->reg = ioremap(res->start, res->end - res->start + 1);
+	cp->reg = ioremap(res->start, resource_size(res));
 	if (!cp->reg) {
 		ret = -ENOMEM;
 		goto err;
@@ -506,7 +506,7 @@ static int mv_probe(struct platform_device *pdev)
 		ret = -ENXIO;
 		goto err_unmap_reg;
 	}
-	cp->sram_size = res->end - res->start + 1;
+	cp->sram_size = resource_size(res);
 	cp->max_req_size = cp->sram_size - SRAM_CFG_SPACE;
 	cp->sram = ioremap(res->start, cp->sram_size);
 	if (!cp->sram) { 
