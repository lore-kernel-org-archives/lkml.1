Return-Path: <linux-kernel-owner+w=401wt.eu-S1758674AbZLNWtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674AbZLNWtB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:49:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758592AbZLNWtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:49:00 -0500
Received: from exprod6og106.obsmtp.com ([64.18.1.191]:51314 "EHLO
	exprod6og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758459AbZLNWs7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:48:59 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] xilinx_spi.c: use resource_size()
Date: Mon, 14 Dec 2009 17:48:59 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200EA93@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] xilinx_spi.c: use resource_size()
Thread-Index: Acp9D5/ewc7ygpsUTvidw/lprgEYJA==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>,
       <spi-devel-general@lists.sourceforge.net>
Cc: "David Brownell" <dbrownell@users.sourceforge.net>
X-OriginalArrivalTime: 14 Dec 2009 22:48:58.0035 (UTC) FILETIME=[9F140030:01CA7D0F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>

---

diff --git a/drivers/spi/xilinx_spi.c b/drivers/spi/xilinx_spi.c
index 5a143b9..32525e6 100644
--- a/drivers/spi/xilinx_spi.c
+++ b/drivers/spi/xilinx_spi.c
@@ -332,14 +332,14 @@ static int __init xilinx_spi_of_probe(struct of_device *ofdev,
 
 	xspi->irq = r_irq->start;
 
-	if (!request_mem_region(r_mem->start,
-			r_mem->end - r_mem->start + 1, XILINX_SPI_NAME)) {
+	if (!request_mem_region(r_mem->start, resource_size(r_mem),
+			XILINX_SPI_NAME)) {
 		rc = -ENXIO;
 		dev_warn(&ofdev->dev, "memory request failure\n");
 		goto put_master;
 	}
 
-	xspi->regs = ioremap(r_mem->start, r_mem->end - r_mem->start + 1);
+	xspi->regs = ioremap(r_mem->start, resource_size(r_mem));
 	if (xspi->regs == NULL) {
 		rc = -ENOMEM;
 		dev_warn(&ofdev->dev, "ioremap failure\n"); 
