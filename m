Return-Path: <linux-kernel-owner+w=401wt.eu-S1758120AbYHHQS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120AbYHHQS2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 12:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbYHHQSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 12:18:15 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:48089 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758002AbYHHQSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 12:18:14 -0400
Date: Fri, 8 Aug 2008 20:18:13 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Greg Kroah-Hartman <greg@kroah.com>, linux-usb@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Li Yang <leoli@freescale.com>, Timur Tabi <timur@freescale.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] gpiolib: make gpio_to_chip() public
Message-ID: <20080808161813.GA31258@polina.dev.rtsoft.ru>
References: <20080808161717.GA19095@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20080808161717.GA19095@polina.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We'll need this function to write platform-specific hooks to deal
with pin's dedicated functions. Quite obviously this will work only
for the platforms with 1-to-1 GPIO to PIN mapping.

This is stopgap solution till we think out and implement a proper
api (pinlib?).

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/gpio/gpiolib.c     |    3 ++-
 include/asm-generic/gpio.h |    1 +
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 8d29405..9536fa8 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -81,10 +81,11 @@ static void gpio_ensure_requested(struct gpio_desc *desc)
 }
 
 /* caller holds gpio_lock *OR* gpio is marked as requested */
-static inline struct gpio_chip *gpio_to_chip(unsigned gpio)
+struct gpio_chip *gpio_to_chip(unsigned gpio)
 {
 	return gpio_desc[gpio].chip;
 }
+EXPORT_SYMBOL_GPL(gpio_to_chip);
 
 /* dynamic allocation of GPIOs, e.g. on a hotplugged device */
 static int gpiochip_find_base(int ngpio)
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 0f99ad3..d70ee45 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -81,6 +81,7 @@ struct gpio_chip {
 	unsigned		exported:1;
 };
 
+extern struct gpio_chip *gpio_to_chip(unsigned gpio);
 extern const char *gpiochip_is_requested(struct gpio_chip *chip,
 			unsigned offset);
 extern int __must_check gpiochip_reserve(int start, int ngpio);
-- 
1.5.5.4

