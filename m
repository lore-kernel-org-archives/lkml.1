Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030612Ab0B0Sgv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 13:36:51 -0500
Received: from mail-iw0-f182.google.com ([209.85.223.182]:60350 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030419Ab0B0Sgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 13:36:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=H9qfxzrtOr+6/Og+UQSt0ijNqJ9UMDbeiwB1znhE5bKiGtVeAJFgBU9XGfg2HuvLHa
         r6skJyF5CTrm+VSIhc5+6cwNLFl9rOzrjBUXRdgU9cnIq6se8zjRB0RjMyzzF28IbgSK
         zGxpDRaklDDFrzCRc1ATOcaLFiPGzsiWpMLC8=
From: Ben Gardner <gardner.ben@gmail.com>
To: linux-kernel@vger.kernel.org, Andres Salomon <dilinger@collabora.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       David Brownell <david-b@pacbell.net>
Cc: Ben Gardner <gardner.ben@gmail.com>,
       Andres Salomon <dilinger@collabora.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Jani Nikula <ext-jani.1.nikula@nokia.com>
Subject: [PATCH] cs5535-gpio: change input/output enable to match gpiolib expectations
Date: Sat, 27 Feb 2010 12:36:35 -0600
Message-Id: <1267295795-2831-1-git-send-email-gardner.ben@gmail.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <14e456b7d269efd860bb36c312de2bc4ad504dca.1267225701.git.gardner.ben@gmail.com>
References: <14e456b7d269efd860bb36c312de2bc4ad504dca.1267225701.git.gardner.ben@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The intent of the gpiolib set_direction_xxx functions is as follows:
output: enable both input and output
input: disable output, enable input

Change the cs5535 driver to do that.

Signed-off-by: Ben Gardner <gardner.ben@gmail.com>
CC: Andres Salomon <dilinger@collabora.co.uk>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: David Brownell <dbrownell@users.sourceforge.net>
CC: Jani Nikula <ext-jani.1.nikula@nokia.com>
---
 drivers/gpio/cs5535-gpio.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/cs5535-gpio.c b/drivers/gpio/cs5535-gpio.c
index 0fdbe94..59ab30e 100644
--- a/drivers/gpio/cs5535-gpio.c
+++ b/drivers/gpio/cs5535-gpio.c
@@ -171,6 +171,7 @@ static int chip_direction_input(struct gpio_chip *c, unsigned offset)
 	unsigned long flags;
 
 	spin_lock_irqsave(&chip->lock, flags);
+	__cs5535_gpio_set(chip, offset, GPIO_OUTPUT_DISABLE);
 	__cs5535_gpio_set(chip, offset, GPIO_INPUT_ENABLE);
 	spin_unlock_irqrestore(&chip->lock, flags);
 
@@ -185,6 +186,7 @@ static int chip_direction_output(struct gpio_chip *c, unsigned offset, int val)
 	spin_lock_irqsave(&chip->lock, flags);
 
 	__cs5535_gpio_set(chip, offset, GPIO_OUTPUT_ENABLE);
+	__cs5535_gpio_set(chip, offset, GPIO_INPUT_ENABLE);
 	if (val)
 		__cs5535_gpio_set(chip, offset, GPIO_OUTPUT_VAL);
 	else
-- 
1.7.0

