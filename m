Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbZETPvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbZETPvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 11:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbZETPvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 11:51:09 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:21371 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbZETPvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 11:51:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=M0AkKodr3VU2GBL6sF3irVcR82ieyy6r3Xn16JJlJZaq4zjbBpOIij+E5jnYuoQBG9
         aWpzeBBC4TpCBUUY8dtUlWy70JDmPtyJM+Yus0lc/qwJ7MEQQfkRAghQK1wEGMoLt6rK
         jznwyy2u8MZKMnF8N9FdXL2n5xHnw2xocdsxw=
Message-ID: <4A1426EB.5080506@gmail.com>
Date: Wed, 20 May 2009 17:51:07 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: ben-linux@fluff.org
CC: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] S3C: beyond ARRAY_SIZE of s3c_gpios
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not go beyond ARRAY_SIZE of s3c_gpios

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/arch/arm/plat-s3c/gpio.c b/arch/arm/plat-s3c/gpio.c
index d71dd6d..29926c1 100644
--- a/arch/arm/plat-s3c/gpio.c
+++ b/arch/arm/plat-s3c/gpio.c
@@ -28,7 +28,7 @@ static __init void s3c_gpiolib_track(struct s3c_gpio_chip *chip)
 
 	gpn = chip->chip.base;
 	for (i = 0; i < chip->chip.ngpio; i++, gpn++) {
-		BUG_ON(gpn > ARRAY_SIZE(s3c_gpios));
+		BUG_ON(gpn >= ARRAY_SIZE(s3c_gpios));
 		s3c_gpios[gpn] = chip;
 	}
 }

