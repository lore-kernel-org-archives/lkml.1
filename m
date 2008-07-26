Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbYGZMUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbYGZMUF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 08:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbYGZMTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 08:19:55 -0400
Received: from bu3sch.de ([62.75.166.246]:47876 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbYGZMTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 08:19:54 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] spi-gpio: Fix returned error code
Date: Sat, 26 Jul 2008 14:18:32 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: David Brownell <david-b@pacbell.net>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "Torgil Svensson" <torgil.svensson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807261418.33091.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the returned error code in case spi_new_device failed.

Reported-by: Torgil Svensson <torgil.svensson@gmail.com>
Signed-off-by: Michael Buesch <mb@bu3sch.de>


Index: linux-next/drivers/spi/spi_gpio.c
===================================================================
--- linux-next.orig/drivers/spi/spi_gpio.c	2008-07-26 14:16:32.000000000 +0200
+++ linux-next/drivers/spi/spi_gpio.c	2008-07-26 14:16:54.000000000 +0200
@@ -167,6 +167,7 @@ static int spi_gpio_probe(struct platfor
 	if (err)
 		goto err_bi_setup;
 	sp->bi.controller_data = sp;
+	err = -ENOMEM;
 	spidev = spi_new_device(master, &sp->bi);
 	if (!spidev)
 		goto err_new_dev;

-- 
Greetings Michael.
