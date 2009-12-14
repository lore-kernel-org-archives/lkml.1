Return-Path: <linux-kernel-owner+w=401wt.eu-S1755254AbZLNWhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbZLNWhS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:37:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbZLNWhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:37:16 -0500
Received: from exprod6og106.obsmtp.com ([64.18.1.191]:47596 "EHLO
	exprod6og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbZLNWhP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:37:15 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] spi_mpc8xxx.c: use resource_size()
Date: Mon, 14 Dec 2009 17:37:15 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200EA8D@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] spi_mpc8xxx.c: use resource_size()
Thread-Index: Acp9DfyVUWyJYxtGR1yRtHNculIjAQ==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>,
       <spi-devel-general@lists.sourceforge.net>
Cc: "David Brownell" <dbrownell@users.sourceforge.net>,
       <galak@kernel.crashing.org>
X-OriginalArrivalTime: 14 Dec 2009 22:37:13.0802 (UTC) FILETIME=[FB5292A0:01CA7D0D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Kumar Gala <galak@kernel.crashing.org>

---

diff --git a/drivers/spi/spi_mpc8xxx.c b/drivers/spi/spi_mpc8xxx.c
index 930135d..d72db76 100644
--- a/drivers/spi/spi_mpc8xxx.c
+++ b/drivers/spi/spi_mpc8xxx.c
@@ -1013,7 +1013,7 @@ mpc8xxx_spi_probe(struct device *dev, struct resource *mem, unsigned int irq)
 
 	init_completion(&mpc8xxx_spi->done);
 
-	mpc8xxx_spi->base = ioremap(mem->start, mem->end - mem->start + 1);
+	mpc8xxx_spi->base = ioremap(mem->start, resource_size(mem));
 	if (mpc8xxx_spi->base == NULL) {
 		ret = -ENOMEM;
 		goto err_ioremap; 
