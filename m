Return-Path: <linux-kernel-owner+w=401wt.eu-S1756638AbXFLPmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbXFLPmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 11:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754716AbXFLPmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 11:42:45 -0400
Received: from mba.ocn.ne.jp ([122.1.175.29]:51628 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754251AbXFLPmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 11:42:44 -0400
Date: Wed, 13 Jun 2007 00:43:16 +0900 (JST)
Message-Id: <20070613.004316.128619812.anemo@mba.ocn.ne.jp>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: linux-kernel@vger.kernel.org, i2c@lm-sensors.org, khali@linux-fr.org
Subject: [PATCH] i2c-gpio: Add support for new-style clients
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use i2c_bit_add_numbered_bus() if device id specified, so that the
i2c-gpio adapter works well with new-style pre-declared devices.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
diff --git a/drivers/i2c/busses/i2c-gpio.c b/drivers/i2c/busses/i2c-gpio.c
index a7dd546..8a62c26 100644
--- a/drivers/i2c/busses/i2c-gpio.c
+++ b/drivers/i2c/busses/i2c-gpio.c
@@ -142,7 +142,10 @@ static int __init i2c_gpio_probe(struct platform_device *pdev)
 	adap->algo_data = bit_data;
 	adap->dev.parent = &pdev->dev;
 
-	ret = i2c_bit_add_bus(adap);
+	if (pdev->id == -1)
+		ret = i2c_bit_add_bus(adap);
+	else
+		ret = i2c_bit_add_numbered_bus(adap);
 	if (ret)
 		goto err_add_bus;
 
