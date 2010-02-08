Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab0BHJJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 04:09:57 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40597 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab0BHJJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 04:09:55 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Jani Nikula <ext-jani.1.nikula@nokia.com>,
       =?UTF-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>,
       Nate Case <ncase@xes-inc.com>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Daniel Silverstone <dsilvers@simtec.co.uk>,
       Arnd Bergmann <arnd@arndb.de>, Mike Frysinger <vapier@gentoo.org>,
       Kevin Wells <kevin.wells@nxp.com>
Subject: [PATCH 1/3] gpiolib: make names array and its values const
Date: Mon,  8 Feb 2010 10:09:38 +0100
Message-Id: <1265620180-14150-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100203155558.GH11354@pengutronix.de>
References: <20100203155558.GH11354@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gpiolib doesn't need to modify the names and I assume most initializers
use sting constants that shouldn't be modified anyhow.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Kevin Wells <kevin.wells@nxp.com>
---
 drivers/gpio/gpiolib.c      |    2 +-
 drivers/gpio/pca953x.c      |    2 +-
 include/asm-generic/gpio.h  |    2 +-
 include/linux/i2c/pca953x.h |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index a25ad28..8543685 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -716,7 +716,7 @@ int gpio_export(unsigned gpio, bool direction_may_change)
 	unsigned long		flags;
 	struct gpio_desc	*desc;
 	int			status = -EINVAL;
-	char			*ioname = NULL;
+	const char		*ioname = NULL;
 
 	/* can't export until sysfs is available ... */
 	if (!gpio_class.p) {
diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
index 6a2fb3f..4faeca4 100644
--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/pca953x.c
@@ -56,7 +56,7 @@ struct pca953x_chip {
 	struct i2c_client *client;
 	struct pca953x_platform_data *dyn_pdata;
 	struct gpio_chip gpio_chip;
-	char **names;
+	const char *const *names;
 };
 
 static int pca953x_write_reg(struct pca953x_chip *chip, int reg, uint16_t val)
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 485eeb6..37af893 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -98,7 +98,7 @@ struct gpio_chip {
 						struct gpio_chip *chip);
 	int			base;
 	u16			ngpio;
-	char			**names;
+	const char		*const *names;
 	unsigned		can_sleep:1;
 	unsigned		exported:1;
 };
diff --git a/include/linux/i2c/pca953x.h b/include/linux/i2c/pca953x.h
index 81736d6..4630fab 100644
--- a/include/linux/i2c/pca953x.h
+++ b/include/linux/i2c/pca953x.h
@@ -15,5 +15,5 @@ struct pca953x_platform_data {
 	int		(*teardown)(struct i2c_client *client,
 				unsigned gpio, unsigned ngpio,
 				void *context);
-	char		**names;
+	const char	*const *names;
 };
-- 
1.6.6

