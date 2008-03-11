Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbYCKRlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbYCKRlz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 13:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754314AbYCKRlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 13:41:32 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:24420 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754214AbYCKRlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 13:41:31 -0400
Date: Tue, 11 Mar 2008 20:41:29 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] gpiolib: add __must_check attribute to the gpiochip_add function
Message-ID: <20080311174129.GC12397@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/gpio/gpiolib.c     |    2 +-
 include/asm-generic/gpio.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 2149e0c..851eb4d 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -161,7 +161,7 @@ static int gpiochip_find_base(int ngpio)
  * because the chip->base is invalid or already associated with a
  * different chip.  Otherwise it returns zero as a success code.
  */
-int gpiochip_add(struct gpio_chip *chip)
+int __must_check gpiochip_add(struct gpio_chip *chip)
 {
 	unsigned long	flags;
 	int		status = 0;
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 20f5d67..51ed230 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -77,7 +77,7 @@ extern const char *gpiochip_is_requested(struct gpio_chip *chip,
 extern int __must_check gpiochip_reserve(int start, int ngpio);
 
 /* add/remove chips */
-extern int gpiochip_add(struct gpio_chip *chip);
+extern int __must_check gpiochip_add(struct gpio_chip *chip);
 extern int __must_check gpiochip_remove(struct gpio_chip *chip);
 
 
-- 
1.5.2.2
