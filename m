Return-Path: <linux-kernel-owner+w=401wt.eu-S965341AbXHMDaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965341AbXHMDaO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 23:30:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935620AbXHMD37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 23:29:59 -0400
Received: from smtp3.hushmail.com ([65.39.178.135]:58012 "EHLO
	smtp3.hushmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935548AbXHMD36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 23:29:58 -0400
Date: Sun, 12 Aug 2007 23:29:56 -0400
To: <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Cc: <a.zummo@towertech.it>
Subject: [PATCH ] /drivers/ata ioremap returncode check (pata_ixp4xx_cf.c)
Reply-to: postfail@hushmail.com
From: "Scott Thompson" <postfail@hushmail.com>
Content-type: text/plain; charset="UTF-8"
Message-Id: <20070813032957.44BD9DA820@mailserver8.hushmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

patch against 2.6.23-rc2.  this corrects two missing ioremap return 
checks.

Signed-off-by: Scott Thompson <postfail <at> hushmail.com>
----------------------------------------------------------

diff --git a/drivers/ata/pata_ixp4xx_cf.c 
b/drivers/ata/pata_ixp4xx_cf.c
index 4ca7fd6..eaebc4d 100644
--- a/drivers/ata/pata_ixp4xx_cf.c
+++ b/drivers/ata/pata_ixp4xx_cf.c
@@ -189,6 +189,14 @@ static __devinit int ixp4xx_pata_probe(struct 
platform_device *pdev)
 	data->cs0 = devm_ioremap(&pdev->dev, cs0->start, 0x1000);
 	data->cs1 = devm_ioremap(&pdev->dev, cs1->start, 0x1000);
 
+	if (!data->cs0 || !data->cs1) {
+		if (data->cs0)
+			iounmap(data->cs0);
+		if (data->cs1)
+			iounmap(data->cs1);
+		return -ENOMEM;
+	}
+
 	irq = platform_get_irq(pdev, 0);
 	if (irq)
 		set_irq_type(irq, IRQT_RISING);

