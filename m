Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab0BWWzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 17:55:22 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46657 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249Ab0BWWzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 17:55:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=wmSavME595T9KfMypYtijb5+c6GLPDk23vPOBJjHFiMEQwWFqNi1LKDXohn7EeKoPk
         uiv4GHgEo3R8hQBHepL5bQuVAvzqnwOKx11+hszlK88x6EnOrcXLTSLvqbXZ7bsW9mQH
         uuXtOnoYrWRSW99cJ3t45macf72boykPRPE8w=
MIME-Version: 1.0
Date: Tue, 23 Feb 2010 16:55:17 -0600
Message-ID: <808c8e9d1002231455q379b26acq4b4a50188c5d73be@mail.gmail.com>
Subject: [PATCH] cs5535_gpio: gpio_chip.get should return the input value
From: Ben Gardner <gardner.ben@gmail.com>
To: Andres Salomon <dilinger@collabora.co.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gpio_chip.get() function for the CS5535 GPIO driver currently returns the
output value instead of the input value.
This patch changes it to return the input value.

Signed-off-by: Ben Gardner <gardner.ben@gmail.com>
---
--- linux-2.6.33-rc8.orig/drivers/gpio/cs5535-gpio.c
+++ linux-2.6.33-rc8/drivers/gpio/cs5535-gpio.c
@@ -154,7 +154,7 @@

 static int chip_gpio_get(struct gpio_chip *chip, unsigned offset)
 {
-	return cs5535_gpio_isset(offset, GPIO_OUTPUT_VAL);
+	return cs5535_gpio_isset(offset, GPIO_READ_BACK);
 }

 static void chip_gpio_set(struct gpio_chip *chip, unsigned offset, int val)
