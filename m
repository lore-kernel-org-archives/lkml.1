Return-Path: <linux-kernel-owner+w=401wt.eu-S932223AbZLNWdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223AbZLNWdr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:33:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbZLNWdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:33:46 -0500
Received: from exprod6ob117.obsmtp.com ([64.18.1.38]:58170 "EHLO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750844AbZLNWdp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:33:45 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] spi_bfin5xx.c: use resource_size()
Date: Mon, 14 Dec 2009 17:33:43 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200EA82@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] spi_bfin5xx.c: use resource_size()
Thread-Index: Acp9DX4086XAzgVWTpWuoRi7Fe9JkQ==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>,
       <spi-devel-general@lists.sourceforge.net>
Cc: "David Brownell" <dbrownell@users.sourceforge.net>, <cooloney@kernel.org>
X-OriginalArrivalTime: 14 Dec 2009 22:33:42.0090 (UTC) FILETIME=[7D21E2A0:01CA7D0D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Bryan Wu <cooloney@kernel.org>

---

diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 73e24ef..1d41058 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -1294,7 +1294,7 @@ static int __init bfin_spi_probe(struct platform_device *pdev)
 		goto out_error_get_res;
 	}
 
-	drv_data->regs_base = ioremap(res->start, (res->end - res->start + 1));
+	drv_data->regs_base = ioremap(res->start, resource_size(res));
 	if (drv_data->regs_base == NULL) {
 		dev_err(dev, "Cannot map IO\n");
 		status = -ENXIO; 
