Return-Path: <linux-kernel-owner+w=401wt.eu-S1753480AbZKWR5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbZKWR5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 12:57:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbZKWR5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 12:57:52 -0500
Received: from exprod6ob117.obsmtp.com ([64.18.1.38]:56122 "EHLO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751505AbZKWR5v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 12:57:51 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: drivers/dma/ipu/ipu_idmac.c: use resource_size()
Date: Mon, 23 Nov 2009 12:57:56 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901EE5BEF@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: drivers/dma/ipu/ipu_idmac.c: use resource_size()
Thread-Index: AcpsZnyjVuVBLs/HRhGvoeCjI1ieBQ==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
Cc: <g.liakhovetski@gmx.de>
X-OriginalArrivalTime: 23 Nov 2009 17:57:56.0911 (UTC) FILETIME=[7CC32BF0:01CA6C66]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size() for ioremap.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

---

diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
index 9a5bc1a..bfa2126 100644
--- a/drivers/dma/ipu/ipu_idmac.c
+++ b/drivers/dma/ipu/ipu_idmac.c
@@ -1771,16 +1771,14 @@ static int __init ipu_probe(struct platform_device *pdev)
 		ipu_data.irq_fn, ipu_data.irq_err, ipu_data.irq_base);
 
 	/* Remap IPU common registers */
-	ipu_data.reg_ipu = ioremap(mem_ipu->start,
-				   mem_ipu->end - mem_ipu->start + 1);
+	ipu_data.reg_ipu = ioremap(mem_ipu->start, resource_size(mem_ipu));
 	if (!ipu_data.reg_ipu) {
 		ret = -ENOMEM;
 		goto err_ioremap_ipu;
 	}
 
 	/* Remap Image Converter and Image DMA Controller registers */
-	ipu_data.reg_ic = ioremap(mem_ic->start,
-				  mem_ic->end - mem_ic->start + 1);
+	ipu_data.reg_ic = ioremap(mem_ic->start, resource_size(mem_ic));
 	if (!ipu_data.reg_ic) {
 		ret = -ENOMEM;
 		goto err_ioremap_ic; 
