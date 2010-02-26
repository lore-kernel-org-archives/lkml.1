Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936179Ab0BZMW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 07:22:27 -0500
Received: from legolas.restena.lu ([158.64.1.34]:33904 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936136Ab0BZMVl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 07:21:41 -0500
Date: Fri, 26 Feb 2010 12:56:48 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Richard Purdie <rpurdie@linux.intel.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] backlight: mark struct backlight_ops const
Message-ID: <20100226125648.630120fd@neptune.home>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i686-pc-linux-gnu)
References: <20100221001851.673db863@neptune.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
---
 drivers/acpi/video.c                            |    2 +-
 drivers/gpu/drm/nouveau/nouveau_backlight.c     |    4 ++--
 drivers/macintosh/via-pmu-backlight.c           |    4 ++--
 drivers/platform/x86/acer-wmi.c                 |    2 +-
 drivers/platform/x86/asus-laptop.c              |    2 +-
 drivers/platform/x86/asus_acpi.c                |    2 +-
 drivers/platform/x86/compal-laptop.c            |    2 +-
 drivers/platform/x86/dell-laptop.c              |    2 +-
 drivers/platform/x86/eeepc-laptop.c             |    2 +-
 drivers/platform/x86/fujitsu-laptop.c           |    2 +-
 drivers/platform/x86/panasonic-laptop.c         |    2 +-
 drivers/platform/x86/sony-laptop.c              |    2 +-
 drivers/platform/x86/thinkpad_acpi.c            |    2 +-
 drivers/platform/x86/toshiba_acpi.c             |    2 +-
 drivers/staging/samsung-laptop/samsung-laptop.c |    2 +-
 drivers/video/atmel_lcdfb.c                     |    2 +-
 drivers/video/aty/aty128fb.c                    |    2 +-
 drivers/video/aty/atyfb_base.c                  |    2 +-
 drivers/video/aty/radeon_backlight.c            |    2 +-
 drivers/video/nvidia/nv_backlight.c             |    2 +-
 drivers/video/omap2/displays/panel-taal.c       |    2 +-
 drivers/video/riva/fbdev.c                      |    2 +-
 22 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index b765790..c86c401 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -366,7 +366,7 @@ static int acpi_video_set_brightness(struct backlight_device *bd)
 				vd->brightness->levels[request_level]);
 }
 
-static struct backlight_ops acpi_backlight_ops = {
+static const struct backlight_ops acpi_backlight_ops = {
 	.get_brightness = acpi_video_get_brightness,
 	.update_status  = acpi_video_set_brightness,
 };
diff --git a/drivers/gpu/drm/nouveau/nouveau_backlight.c b/drivers/gpu/drm/nouveau/nouveau_backlight.c
index 20564f8..9a8c990 100644
--- a/drivers/gpu/drm/nouveau/nouveau_backlight.c
+++ b/drivers/gpu/drm/nouveau/nouveau_backlight.c
@@ -58,7 +58,7 @@ static int nv40_set_intensity(struct backlight_device *bd)
 	return 0;
 }
 
-static struct backlight_ops nv40_bl_ops = {
+static const struct backlight_ops nv40_bl_ops = {
 	.options = BL_CORE_SUSPENDRESUME,
 	.get_brightness = nv40_get_intensity,
 	.update_status = nv40_set_intensity,
@@ -81,7 +81,7 @@ static int nv50_set_intensity(struct backlight_device *bd)
 	return 0;
 }
 
-static struct backlight_ops nv50_bl_ops = {
+static const struct backlight_ops nv50_bl_ops = {
 	.options = BL_CORE_SUSPENDRESUME,
 	.get_brightness = nv50_get_intensity,
 	.update_status = nv50_set_intensity,
diff --git a/drivers/macintosh/via-pmu-backlight.c b/drivers/macintosh/via-pmu-backlight.c
index a348bb0..ecd9b3f 100644
--- a/drivers/macintosh/via-pmu-backlight.c
+++ b/drivers/macintosh/via-pmu-backlight.c
@@ -15,7 +15,7 @@
 
 #define MAX_PMU_LEVEL 0xFF
 
-static struct backlight_ops pmu_backlight_data;
+static const struct backlight_ops pmu_backlight_data;
 static DEFINE_SPINLOCK(pmu_backlight_lock);
 static int sleeping, uses_pmu_bl;
 static u8 bl_curve[FB_BACKLIGHT_LEVELS];
@@ -115,7 +115,7 @@ static int pmu_backlight_get_brightness(struct backlight_device *bd)
 	return bd->props.brightness;
 }
 
-static struct backlight_ops pmu_backlight_data = {
+static const struct backlight_ops pmu_backlight_data = {
 	.get_brightness	= pmu_backlight_get_brightness,
 	.update_status	= pmu_backlight_update_status,
 
diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 07d14df..f70bd41 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -915,7 +915,7 @@ static int update_bl_status(struct backlight_device *bd)
 	return 0;
 }
 
-static struct backlight_ops acer_bl_ops = {
+static const struct backlight_ops acer_bl_ops = {
 	.get_brightness = read_brightness,
 	.update_status = update_bl_status,
 };
diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 61a1c75..88e8554 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -251,7 +251,7 @@ static struct backlight_device *asus_backlight_device;
  */
 static int read_brightness(struct backlight_device *bd);
 static int update_bl_status(struct backlight_device *bd);
-static struct backlight_ops asusbl_ops = {
+static const struct backlight_ops asusbl_ops = {
 	.get_brightness = read_brightness,
 	.update_status = update_bl_status,
 };
diff --git a/drivers/platform/x86/asus_acpi.c b/drivers/platform/x86/asus_acpi.c
index c1d2aee..9980d51 100644
--- a/drivers/platform/x86/asus_acpi.c
+++ b/drivers/platform/x86/asus_acpi.c
@@ -1464,7 +1464,7 @@ static int asus_hotk_remove(struct acpi_device *device, int type)
 	return 0;
 }
 
-static struct backlight_ops asus_backlight_data = {
+static const struct backlight_ops asus_backlight_data = {
 	.get_brightness = read_brightness,
 	.update_status  = set_brightness_status,
 };
diff --git a/drivers/platform/x86/compal-laptop.c b/drivers/platform/x86/compal-laptop.c
index 1a387e7..2bd6c65 100644
--- a/drivers/platform/x86/compal-laptop.c
+++ b/drivers/platform/x86/compal-laptop.c
@@ -162,7 +162,7 @@ static int bl_update_status(struct backlight_device *b)
 	return set_lcd_level(b->props.brightness);
 }
 
-static struct backlight_ops compalbl_ops = {
+static const struct backlight_ops compalbl_ops = {
 	.get_brightness = bl_get_brightness,
 	.update_status	= bl_update_status,
 };
diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index 3780994..55640e5 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -333,7 +333,7 @@ static int dell_get_intensity(struct backlight_device *bd)
 	return buffer.output[1];
 }
 
-static struct backlight_ops dell_ops = {
+static const struct backlight_ops dell_ops = {
 	.get_brightness = dell_get_intensity,
 	.update_status  = dell_send_intensity,
 };
diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index e2be6bb..4f77774 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -1096,7 +1096,7 @@ static int update_bl_status(struct backlight_device *bd)
 	return set_brightness(bd, bd->props.brightness);
 }
 
-static struct backlight_ops eeepcbl_ops = {
+static const struct backlight_ops eeepcbl_ops = {
 	.get_brightness = read_brightness,
 	.update_status = update_bl_status,
 };
diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
index 5f3320d..b6a0941 100644
--- a/drivers/platform/x86/fujitsu-laptop.c
+++ b/drivers/platform/x86/fujitsu-laptop.c
@@ -436,7 +436,7 @@ static int bl_update_status(struct backlight_device *b)
 	return ret;
 }
 
-static struct backlight_ops fujitsubl_ops = {
+static const struct backlight_ops fujitsubl_ops = {
 	.get_brightness = bl_get_brightness,
 	.update_status = bl_update_status,
 };
diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index 3f71a60..75481e6 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -853,7 +853,7 @@ static int sony_backlight_get_brightness(struct backlight_device *bd)
 }
 
 static struct backlight_device *sony_backlight_device;
-static struct backlight_ops sony_backlight_ops = {
+static const struct backlight_ops sony_backlight_ops = {
 	.update_status = sony_backlight_update_status,
 	.get_brightness = sony_backlight_get_brightness,
 };
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index e67e4fe..950a2f7 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -6112,7 +6112,7 @@ static void tpacpi_brightness_notify_change(void)
 			       BACKLIGHT_UPDATE_HOTKEY);
 }
 
-static struct backlight_ops ibm_backlight_data = {
+static const struct backlight_ops ibm_backlight_data = {
 	.get_brightness = brightness_get,
 	.update_status  = brightness_update_status,
 };
diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 77bf5d8..0f0b69e 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -706,7 +706,7 @@ static acpi_status remove_device(void)
 	return AE_OK;
 }
 
-static struct backlight_ops toshiba_backlight_data = {
+static const struct backlight_ops toshiba_backlight_data = {
         .get_brightness = get_lcd,
         .update_status  = set_lcd_status,
 };
diff --git a/drivers/staging/samsung-laptop/samsung-laptop.c b/drivers/staging/samsung-laptop/samsung-laptop.c
index 4877138..0cf2d58 100644
--- a/drivers/staging/samsung-laptop/samsung-laptop.c
+++ b/drivers/staging/samsung-laptop/samsung-laptop.c
@@ -268,7 +268,7 @@ static int update_status(struct backlight_device *bd)
 	return 0;
 }
 
-static struct backlight_ops backlight_ops = {
+static const struct backlight_ops backlight_ops = {
 	.get_brightness	= get_brightness,
 	.update_status	= update_status,
 };
diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
index 3d886c6..22ee7f8 100644
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -110,7 +110,7 @@ static int atmel_bl_get_brightness(struct backlight_device *bl)
 	return lcdc_readl(sinfo, ATMEL_LCDC_CONTRAST_VAL);
 }
 
-static struct backlight_ops atmel_lcdc_bl_ops = {
+static const struct backlight_ops atmel_lcdc_bl_ops = {
 	.update_status = atmel_bl_update_status,
 	.get_brightness = atmel_bl_get_brightness,
 };
diff --git a/drivers/video/aty/aty128fb.c b/drivers/video/aty/aty128fb.c
index e4e4d43..137cd34 100644
--- a/drivers/video/aty/aty128fb.c
+++ b/drivers/video/aty/aty128fb.c
@@ -1787,7 +1787,7 @@ static int aty128_bl_get_brightness(struct backlight_device *bd)
 	return bd->props.brightness;
 }
 
-static struct backlight_ops aty128_bl_data = {
+static const struct backlight_ops aty128_bl_data = {
 	.get_brightness	= aty128_bl_get_brightness,
 	.update_status	= aty128_bl_update_status,
 };
diff --git a/drivers/video/aty/atyfb_base.c b/drivers/video/aty/atyfb_base.c
index 1ddeb4c..fc4e221 100644
--- a/drivers/video/aty/atyfb_base.c
+++ b/drivers/video/aty/atyfb_base.c
@@ -2225,7 +2225,7 @@ static int aty_bl_get_brightness(struct backlight_device *bd)
 	return bd->props.brightness;
 }
 
-static struct backlight_ops aty_bl_data = {
+static const struct backlight_ops aty_bl_data = {
 	.get_brightness = aty_bl_get_brightness,
 	.update_status	= aty_bl_update_status,
 };
diff --git a/drivers/video/aty/radeon_backlight.c b/drivers/video/aty/radeon_backlight.c
index 1a056ad..221bd6a 100644
--- a/drivers/video/aty/radeon_backlight.c
+++ b/drivers/video/aty/radeon_backlight.c
@@ -127,7 +127,7 @@ static int radeon_bl_get_brightness(struct backlight_device *bd)
 	return bd->props.brightness;
 }
 
-static struct backlight_ops radeon_bl_data = {
+static const struct backlight_ops radeon_bl_data = {
 	.get_brightness = radeon_bl_get_brightness,
 	.update_status	= radeon_bl_update_status,
 };
diff --git a/drivers/video/nvidia/nv_backlight.c b/drivers/video/nvidia/nv_backlight.c
index 443e3c8..c443d6a 100644
--- a/drivers/video/nvidia/nv_backlight.c
+++ b/drivers/video/nvidia/nv_backlight.c
@@ -87,7 +87,7 @@ static int nvidia_bl_get_brightness(struct backlight_device *bd)
 	return bd->props.brightness;
 }
 
-static struct backlight_ops nvidia_bl_ops = {
+static const struct backlight_ops nvidia_bl_ops = {
 	.get_brightness = nvidia_bl_get_brightness,
 	.update_status	= nvidia_bl_update_status,
 };
diff --git a/drivers/video/omap2/displays/panel-taal.c b/drivers/video/omap2/displays/panel-taal.c
index 1f01dfc..a5f7f82 100644
--- a/drivers/video/omap2/displays/panel-taal.c
+++ b/drivers/video/omap2/displays/panel-taal.c
@@ -313,7 +313,7 @@ static int taal_bl_get_intensity(struct backlight_device *dev)
 	return 0;
 }
 
-static struct backlight_ops taal_bl_ops = {
+static const struct backlight_ops taal_bl_ops = {
 	.get_brightness = taal_bl_get_intensity,
 	.update_status  = taal_bl_update_status,
 };
diff --git a/drivers/video/riva/fbdev.c b/drivers/video/riva/fbdev.c
index d94c57f..912984c 100644
--- a/drivers/video/riva/fbdev.c
+++ b/drivers/video/riva/fbdev.c
@@ -331,7 +331,7 @@ static int riva_bl_get_brightness(struct backlight_device *bd)
 	return bd->props.brightness;
 }
 
-static struct backlight_ops riva_bl_ops = {
+static const struct backlight_ops riva_bl_ops = {
 	.get_brightness = riva_bl_get_brightness,
 	.update_status	= riva_bl_update_status,
 };
-- 
1.6.4.4

