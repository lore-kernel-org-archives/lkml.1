Return-Path: <linux-kernel-owner+w=401wt.eu-S1755151AbZLNAZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbZLNAZL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:25:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756199AbZLNAYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:24:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33896 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754774AbZLMX53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:29 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, akpm@linux-foundation.org,
       rpurdie@rpsys.net, eric.y.miao@gmail.com, mike@compulab.co.il,
       torvalds@linux-foundation.org, mjg@redhat.com, mingo@elte.hu
Subject: [PATCH 05/22] Constify struct backlight_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:58:57 +0100
Message-Id: <3b8f4305c6acb257fbf227f19cb227450d6c7182.1260662995.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260662994.git.re.emese@gmail.com>
References: <cover.1260662994.git.re.emese@gmail.com>
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 drivers/video/backlight/adp5520_bl.c    |    2 +-
 drivers/video/backlight/adx_bl.c        |    2 +-
 drivers/video/backlight/atmel-pwm-bl.c  |    2 +-
 drivers/video/backlight/backlight.c     |    2 +-
 drivers/video/backlight/corgi_lcd.c     |    2 +-
 drivers/video/backlight/cr_bllcd.c      |    2 +-
 drivers/video/backlight/da903x_bl.c     |    2 +-
 drivers/video/backlight/generic_bl.c    |    2 +-
 drivers/video/backlight/hp680_bl.c      |    2 +-
 drivers/video/backlight/jornada720_bl.c |    2 +-
 drivers/video/backlight/kb3886_bl.c     |    2 +-
 drivers/video/backlight/locomolcd.c     |    2 +-
 drivers/video/backlight/mbp_nvidia_bl.c |    2 +-
 drivers/video/backlight/omap1_bl.c      |    2 +-
 drivers/video/backlight/progear_bl.c    |    2 +-
 drivers/video/backlight/pwm_bl.c        |    2 +-
 drivers/video/backlight/tosa_bl.c       |    2 +-
 drivers/video/backlight/wm831x_bl.c     |    2 +-
 include/linux/backlight.h               |   12 ++++++------
 19 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/video/backlight/adp5520_bl.c b/drivers/video/backlight/adp5520_bl.c
index ad05da5..3cb2cb9 100644
--- a/drivers/video/backlight/adp5520_bl.c
+++ b/drivers/video/backlight/adp5520_bl.c
@@ -84,7 +84,7 @@ static int adp5520_bl_get_brightness(struct backlight_device *bl)
 	return error ? data->current_brightness : reg_val;
 }
 
-static struct backlight_ops adp5520_bl_ops = {
+static const struct backlight_ops adp5520_bl_ops = {
 	.update_status	= adp5520_bl_update_status,
 	.get_brightness	= adp5520_bl_get_brightness,
 };
diff --git a/drivers/video/backlight/adx_bl.c b/drivers/video/backlight/adx_bl.c
index 2c3bdfc..d769b0b 100644
--- a/drivers/video/backlight/adx_bl.c
+++ b/drivers/video/backlight/adx_bl.c
@@ -61,7 +61,7 @@ static int adx_backlight_check_fb(struct fb_info *fb)
 	return 1;
 }
 
-static struct backlight_ops adx_backlight_ops = {
+static const struct backlight_ops adx_backlight_ops = {
 	.options = 0,
 	.update_status = adx_backlight_update_status,
 	.get_brightness = adx_backlight_get_brightness,
diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
index 2cf7ba5..f625ffc 100644
--- a/drivers/video/backlight/atmel-pwm-bl.c
+++ b/drivers/video/backlight/atmel-pwm-bl.c
@@ -113,7 +113,7 @@ static int atmel_pwm_bl_init_pwm(struct atmel_pwm_bl *pwmbl)
 	return pwm_channel_enable(&pwmbl->pwmc);
 }
 
-static struct backlight_ops atmel_pwm_bl_ops = {
+static const struct backlight_ops atmel_pwm_bl_ops = {
 	.get_brightness = atmel_pwm_bl_get_intensity,
 	.update_status  = atmel_pwm_bl_set_intensity,
 };
diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index 6615ac7..18829cf 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -269,7 +269,7 @@ EXPORT_SYMBOL(backlight_force_update);
  * ERR_PTR() or a pointer to the newly allocated device.
  */
 struct backlight_device *backlight_device_register(const char *name,
-		struct device *parent, void *devdata, struct backlight_ops *ops)
+		struct device *parent, void *devdata, const struct backlight_ops *ops)
 {
 	struct backlight_device *new_bd;
 	int rc;
diff --git a/drivers/video/backlight/corgi_lcd.c b/drivers/video/backlight/corgi_lcd.c
index 9677494..b4bcf80 100644
--- a/drivers/video/backlight/corgi_lcd.c
+++ b/drivers/video/backlight/corgi_lcd.c
@@ -451,7 +451,7 @@ void corgi_lcd_limit_intensity(int limit)
 }
 EXPORT_SYMBOL(corgi_lcd_limit_intensity);
 
-static struct backlight_ops corgi_bl_ops = {
+static const struct backlight_ops corgi_bl_ops = {
 	.get_brightness	= corgi_bl_get_intensity,
 	.update_status  = corgi_bl_update_status,
 };
diff --git a/drivers/video/backlight/cr_bllcd.c b/drivers/video/backlight/cr_bllcd.c
index b9fe62b..2914bf1 100644
--- a/drivers/video/backlight/cr_bllcd.c
+++ b/drivers/video/backlight/cr_bllcd.c
@@ -108,7 +108,7 @@ static int cr_backlight_get_intensity(struct backlight_device *bd)
 	return intensity;
 }
 
-static struct backlight_ops cr_backlight_ops = {
+static const struct backlight_ops cr_backlight_ops = {
 	.get_brightness = cr_backlight_get_intensity,
 	.update_status = cr_backlight_set_intensity,
 };
diff --git a/drivers/video/backlight/da903x_bl.c b/drivers/video/backlight/da903x_bl.c
index 7fcb0eb..206cf99 100644
--- a/drivers/video/backlight/da903x_bl.c
+++ b/drivers/video/backlight/da903x_bl.c
@@ -95,7 +95,7 @@ static int da903x_backlight_get_brightness(struct backlight_device *bl)
 	return data->current_brightness;
 }
 
-static struct backlight_ops da903x_backlight_ops = {
+static const struct backlight_ops da903x_backlight_ops = {
 	.update_status	= da903x_backlight_update_status,
 	.get_brightness	= da903x_backlight_get_brightness,
 };
diff --git a/drivers/video/backlight/generic_bl.c b/drivers/video/backlight/generic_bl.c
index 6d27f62..e6d348e 100644
--- a/drivers/video/backlight/generic_bl.c
+++ b/drivers/video/backlight/generic_bl.c
@@ -70,7 +70,7 @@ void corgibl_limit_intensity(int limit)
 }
 EXPORT_SYMBOL(corgibl_limit_intensity);
 
-static struct backlight_ops genericbl_ops = {
+static const struct backlight_ops genericbl_ops = {
 	.options = BL_CORE_SUSPENDRESUME,
 	.get_brightness = genericbl_get_intensity,
 	.update_status  = genericbl_send_intensity,
diff --git a/drivers/video/backlight/hp680_bl.c b/drivers/video/backlight/hp680_bl.c
index 7fb4eef..f7cc528 100644
--- a/drivers/video/backlight/hp680_bl.c
+++ b/drivers/video/backlight/hp680_bl.c
@@ -98,7 +98,7 @@ static int hp680bl_get_intensity(struct backlight_device *bd)
 	return current_intensity;
 }
 
-static struct backlight_ops hp680bl_ops = {
+static const struct backlight_ops hp680bl_ops = {
 	.get_brightness = hp680bl_get_intensity,
 	.update_status  = hp680bl_set_intensity,
 };
diff --git a/drivers/video/backlight/jornada720_bl.c b/drivers/video/backlight/jornada720_bl.c
index 7aed256..db9071f 100644
--- a/drivers/video/backlight/jornada720_bl.c
+++ b/drivers/video/backlight/jornada720_bl.c
@@ -93,7 +93,7 @@ out:
 	return ret;
 }
 
-static struct backlight_ops jornada_bl_ops = {
+static const struct backlight_ops jornada_bl_ops = {
 	.get_brightness = jornada_bl_get_brightness,
 	.update_status = jornada_bl_update_status,
 	.options = BL_CORE_SUSPENDRESUME,
diff --git a/drivers/video/backlight/kb3886_bl.c b/drivers/video/backlight/kb3886_bl.c
index a38fda1..939e7b8 100644
--- a/drivers/video/backlight/kb3886_bl.c
+++ b/drivers/video/backlight/kb3886_bl.c
@@ -134,7 +134,7 @@ static int kb3886bl_get_intensity(struct backlight_device *bd)
 	return kb3886bl_intensity;
 }
 
-static struct backlight_ops kb3886bl_ops = {
+static const struct backlight_ops kb3886bl_ops = {
 	.get_brightness = kb3886bl_get_intensity,
 	.update_status  = kb3886bl_send_intensity,
 };
diff --git a/drivers/video/backlight/locomolcd.c b/drivers/video/backlight/locomolcd.c
index 6b488b8..00a9591 100644
--- a/drivers/video/backlight/locomolcd.c
+++ b/drivers/video/backlight/locomolcd.c
@@ -141,7 +141,7 @@ static int locomolcd_get_intensity(struct backlight_device *bd)
 	return current_intensity;
 }
 
-static struct backlight_ops locomobl_data = {
+static const struct backlight_ops locomobl_data = {
 	.get_brightness = locomolcd_get_intensity,
 	.update_status  = locomolcd_set_intensity,
 };
diff --git a/drivers/video/backlight/mbp_nvidia_bl.c b/drivers/video/backlight/mbp_nvidia_bl.c
index 9edb8d7..5812468 100644
--- a/drivers/video/backlight/mbp_nvidia_bl.c
+++ b/drivers/video/backlight/mbp_nvidia_bl.c
@@ -33,7 +33,7 @@ struct dmi_match_data {
 	unsigned long iostart;
 	unsigned long iolen;
 	/* Backlight operations structure. */
-	struct backlight_ops backlight_ops;
+	const struct backlight_ops backlight_ops;
 };
 
 /* Module parameters. */
diff --git a/drivers/video/backlight/omap1_bl.c b/drivers/video/backlight/omap1_bl.c
index 8693e5f..409ca96 100644
--- a/drivers/video/backlight/omap1_bl.c
+++ b/drivers/video/backlight/omap1_bl.c
@@ -125,7 +125,7 @@ static int omapbl_get_intensity(struct backlight_device *dev)
 	return bl->current_intensity;
 }
 
-static struct backlight_ops omapbl_ops = {
+static const struct backlight_ops omapbl_ops = {
 	.get_brightness = omapbl_get_intensity,
 	.update_status  = omapbl_update_status,
 };
diff --git a/drivers/video/backlight/progear_bl.c b/drivers/video/backlight/progear_bl.c
index 9edaf24..075786e 100644
--- a/drivers/video/backlight/progear_bl.c
+++ b/drivers/video/backlight/progear_bl.c
@@ -54,7 +54,7 @@ static int progearbl_get_intensity(struct backlight_device *bd)
 	return intensity - HW_LEVEL_MIN;
 }
 
-static struct backlight_ops progearbl_ops = {
+static const struct backlight_ops progearbl_ops = {
 	.get_brightness = progearbl_get_intensity,
 	.update_status = progearbl_set_intensity,
 };
diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 8871662..df9e0b3 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -56,7 +56,7 @@ static int pwm_backlight_get_brightness(struct backlight_device *bl)
 	return bl->props.brightness;
 }
 
-static struct backlight_ops pwm_backlight_ops = {
+static const struct backlight_ops pwm_backlight_ops = {
 	.update_status	= pwm_backlight_update_status,
 	.get_brightness	= pwm_backlight_get_brightness,
 };
diff --git a/drivers/video/backlight/tosa_bl.c b/drivers/video/backlight/tosa_bl.c
index 43edbad..e14ce4d 100644
--- a/drivers/video/backlight/tosa_bl.c
+++ b/drivers/video/backlight/tosa_bl.c
@@ -72,7 +72,7 @@ static int tosa_bl_get_brightness(struct backlight_device *dev)
 	return props->brightness;
 }
 
-static struct backlight_ops bl_ops = {
+static const struct backlight_ops bl_ops = {
 	.get_brightness		= tosa_bl_get_brightness,
 	.update_status		= tosa_bl_update_status,
 };
diff --git a/drivers/video/backlight/wm831x_bl.c b/drivers/video/backlight/wm831x_bl.c
index 467bdb7..e32add3 100644
--- a/drivers/video/backlight/wm831x_bl.c
+++ b/drivers/video/backlight/wm831x_bl.c
@@ -112,7 +112,7 @@ static int wm831x_backlight_get_brightness(struct backlight_device *bl)
 	return data->current_brightness;
 }
 
-static struct backlight_ops wm831x_backlight_ops = {
+static const struct backlight_ops wm831x_backlight_ops = {
 	.options = BL_CORE_SUSPENDRESUME,
 	.update_status	= wm831x_backlight_update_status,
 	.get_brightness	= wm831x_backlight_get_brightness,
diff --git a/include/linux/backlight.h b/include/linux/backlight.h
index 0f5f578..8c4f884 100644
--- a/include/linux/backlight.h
+++ b/include/linux/backlight.h
@@ -36,18 +36,18 @@ struct backlight_device;
 struct fb_info;
 
 struct backlight_ops {
-	unsigned int options;
+	const unsigned int options;
 
 #define BL_CORE_SUSPENDRESUME	(1 << 0)
 
 	/* Notify the backlight driver some property has changed */
-	int (*update_status)(struct backlight_device *);
+	int (* const update_status)(struct backlight_device *);
 	/* Return the current backlight brightness (accounting for power,
 	   fb_blank etc.) */
-	int (*get_brightness)(struct backlight_device *);
+	int (* const get_brightness)(struct backlight_device *);
 	/* Check if given framebuffer device is the one bound to this backlight;
 	   return 0 if not, !=0 if it is. If NULL, backlight always matches the fb. */
-	int (*check_fb)(struct fb_info *);
+	int (* const check_fb)(struct fb_info *);
 };
 
 /* This structure defines all the properties of a backlight */
@@ -86,7 +86,7 @@ struct backlight_device {
 	   registered this device has been unloaded, and if class_get_devdata()
 	   points to something in the body of that driver, it is also invalid. */
 	struct mutex ops_lock;
-	struct backlight_ops *ops;
+	const struct backlight_ops *ops;
 
 	/* The framebuffer notifier block */
 	struct notifier_block fb_notif;
@@ -103,7 +103,7 @@ static inline void backlight_update_status(struct backlight_device *bd)
 }
 
 extern struct backlight_device *backlight_device_register(const char *name,
-	struct device *dev, void *devdata, struct backlight_ops *ops);
+	struct device *dev, void *devdata, const struct backlight_ops *ops);
 extern void backlight_device_unregister(struct backlight_device *bd);
 extern void backlight_force_update(struct backlight_device *bd,
 				   enum backlight_update_reason reason);
-- 
1.6.5.3

