Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbZBOPr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbZBOPr7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 10:47:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbZBOPru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 10:47:50 -0500
Received: from bu3sch.de ([62.75.166.246]:58405 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187AbZBOPrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 10:47:49 -0500
From: Michael Buesch <mb@bu3sch.de>
To: David Brownell <dbrownell@users.sourceforge.net>
Subject: [PATCH] spi-gpio: Sanitize MISO bitvalue
Date: Sun, 15 Feb 2009 16:30:41 +0100
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       openwrt-devel@lists.openwrt.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902151630.41426.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gpio_get_value() returns 0 or nonzero, but getmiso() expects 0 or 1.
Sanitize the value to a 0/1 boolean.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Well, we could also change the bitbang helpers in linux/spi/spi_bitbang.h
or change the way the gpio_get_value API is defined, but I personally think
this patch is pretty good as is.
In any case, it fixes a real bug on platforms like the bcm47xx which
return 0 or nonzero for gpio_get_value.

Index: linux-2.6/drivers/spi/spi_gpio.c
===================================================================
--- linux-2.6.orig/drivers/spi/spi_gpio.c	2009-02-14 21:37:14.000000000 +0100
+++ linux-2.6/drivers/spi/spi_gpio.c	2009-02-15 16:27:16.000000000 +0100
@@ -114,7 +114,7 @@ static inline void setmosi(const struct 
 
 static inline int getmiso(const struct spi_device *spi)
 {
-	return gpio_get_value(SPI_MISO_GPIO);
+	return !!gpio_get_value(SPI_MISO_GPIO);
 }
 
 #undef pdata

-- 
Greetings, Michael.
