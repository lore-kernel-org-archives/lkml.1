Return-Path: <linux-kernel-owner+w=401wt.eu-S1751639AbXBEQyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639AbXBEQyP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 11:54:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbXBEQyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 11:54:15 -0500
Received: from an-out-0708.google.com ([209.85.132.242]:39192 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbXBEQyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 11:54:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=JsQ811BQiJhdjNtsISgvk1gqhz2mHKrgQ99Hqcn4EAiCGK4H4lRsoi6AAq3J+13GbCsK2P/QJDRtqEu7RridswIbjWfcauiLoK/xvO+ro8RpYjzfeKqYyaw4IWo5Zv/VjGWjWvSGy8xWN7/H7VzclTSauliNGCGnCMARMLj9fxM=
Date: Mon, 5 Feb 2007 18:54:00 +0200
To: mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.20] misc-video: use ARRAY_SIZE macro when appropriate
Message-ID: <20070205165400.GC3896@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070205165134.GA3896@Ahmed>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

A patch to use ARRAY_SIZE macro in miscellaneous video drivers found
with no specific maintaners.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---
Patches are compile tested.

diff --git a/drivers/media/video/cpia2/cpia2_v4l.c b/drivers/media/video/cpia2/cpia2_v4l.c
index d09f499..3237c25 100644
--- a/drivers/media/video/cpia2/cpia2_v4l.c
+++ b/drivers/media/video/cpia2/cpia2_v4l.c
@@ -33,6 +33,7 @@
 
 
 #include <linux/module.h>
+#include <linux/kernel.h>
 #include <linux/time.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -105,7 +106,7 @@ static struct control_menu_info framerate_controls[] =
 	{ CPIA2_VP_FRAMERATE_25,   "25 fps"   },
 	{ CPIA2_VP_FRAMERATE_30,   "30 fps"   },
 };
-#define NUM_FRAMERATE_CONTROLS (sizeof(framerate_controls)/sizeof(framerate_controls[0]))
+#define NUM_FRAMERATE_CONTROLS ARRAY_SIZE(framerate_controls)
 
 static struct control_menu_info flicker_controls[] =
 {
@@ -113,7 +114,7 @@ static struct control_menu_info flicker_controls[] =
 	{ FLICKER_50,    "50 Hz" },
 	{ FLICKER_60,    "60 Hz"  },
 };
-#define NUM_FLICKER_CONTROLS (sizeof(flicker_controls)/sizeof(flicker_controls[0]))
+#define NUM_FLICKER_CONTROLS ARRAY_SIZE(flicker_controls)
 
 static struct control_menu_info lights_controls[] =
 {
@@ -122,7 +123,7 @@ static struct control_menu_info lights_controls[] =
 	{ 128, "Bottom"  },
 	{ 192, "Both"  },
 };
-#define NUM_LIGHTS_CONTROLS (sizeof(lights_controls)/sizeof(lights_controls[0]))
+#define NUM_LIGHTS_CONTROLS ARRAY_SIZE(lights_controls)
 #define GPIO_LIGHTS_MASK 192
 
 static struct v4l2_queryctrl controls[] = {
@@ -235,7 +236,7 @@ static struct v4l2_queryctrl controls[] = {
 		.default_value = 0,
 	},
 };
-#define NUM_CONTROLS (sizeof(controls)/sizeof(controls[0]))
+#define NUM_CONTROLS ARRAY_SIZE(controls)
 
 
 /******************************************************************************
diff --git a/drivers/media/video/ov7670.c b/drivers/media/video/ov7670.c
index 5ed0adc..0f6020e 100644
--- a/drivers/media/video/ov7670.c
+++ b/drivers/media/video/ov7670.c
@@ -11,6 +11,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/videodev.h>
@@ -503,7 +504,7 @@ static struct ov7670_format_struct {
 		.cmatrix	= { 179, -179, 0, -61, -176, 228 },
 	},
 };
-#define N_OV7670_FMTS (sizeof(ov7670_formats)/sizeof(ov7670_formats[0]))
+#define N_OV7670_FMTS ARRAY_SIZE(ov7670_formats)
 
 /*
  * All formats we support are 2 bytes/pixel.
@@ -596,7 +597,7 @@ static struct ov7670_win_size {
 	},
 };
 
-#define N_WIN_SIZES (sizeof(ov7670_win_sizes)/sizeof(ov7670_win_sizes[0]))
+#define N_WIN_SIZES ARRAY_SIZE(ov7670_win_sizes)
 
 
 /*
@@ -1149,7 +1150,7 @@ static struct ov7670_control {
 		.query = ov7670_q_hflip,
 	},
 };
-#define N_CONTROLS (sizeof(ov7670_controls)/sizeof(ov7670_controls[0]))
+#define N_CONTROLS ARRAY_SIZE(ov7670_controls)
 
 static struct ov7670_control *ov7670_find_control(__u32 id)
 {
diff --git a/drivers/media/video/tveeprom.c b/drivers/media/video/tveeprom.c
index 4e7c1fa..4439080 100644
--- a/drivers/media/video/tveeprom.c
+++ b/drivers/media/video/tveeprom.c
@@ -453,7 +453,7 @@ void tveeprom_hauppauge_analog(struct i2c_client *c, struct tveeprom *tvee,
 			to indicate 4052 mux was removed in favor of using MSP
 			inputs directly. */
 			audioic = eeprom_data[i+2] & 0x7f;
-			if (audioic < sizeof(audioIC)/sizeof(*audioIC))
+			if (audioic < ARRAY_SIZE(audioIC))
 				tvee->audio_processor = audioIC[audioic].id;
 			else
 				tvee->audio_processor = AUDIO_CHIP_UNKNOWN;
@@ -486,7 +486,7 @@ void tveeprom_hauppauge_analog(struct i2c_client *c, struct tveeprom *tvee,
 			to indicate 4052 mux was removed in favor of using MSP
 			inputs directly. */
 			audioic = eeprom_data[i+1] & 0x7f;
-			if (audioic < sizeof(audioIC)/sizeof(*audioIC))
+			if (audioic < ARRAY_SIZE(audioIC))
 				tvee->audio_processor = audioIC[audioic].id;
 			else
 				tvee->audio_processor = AUDIO_CHIP_UNKNOWN;
@@ -641,7 +641,7 @@ void tveeprom_hauppauge_analog(struct i2c_client *c, struct tveeprom *tvee,
 		tveeprom_info("audio processor is unknown (no idx)\n");
 		tvee->audio_processor=AUDIO_CHIP_UNKNOWN;
 	} else {
-		if (audioic < sizeof(audioIC)/sizeof(*audioIC))
+		if (audioic < ARRAY_SIZE(audioIC))
 			tveeprom_info("audio processor is %s (idx %d)\n",
 					audioIC[audioic].name,audioic);
 		else
diff --git a/drivers/media/video/tvp5150.c b/drivers/media/video/tvp5150.c
index bc0a4fc..9eeefee 100644
--- a/drivers/media/video/tvp5150.c
+++ b/drivers/media/video/tvp5150.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/i2c.h>
+#include <linux/kernel.h>
 #include <linux/videodev.h>
 #include <linux/delay.h>
 #include <linux/video_decoder.h>
@@ -1012,7 +1013,7 @@ static int tvp5150_command(struct i2c_client *c,
 		{
 			struct v4l2_control *ctrl = arg;
 			u8 i, n;
-			n = sizeof(tvp5150_qctrl) / sizeof(tvp5150_qctrl[0]);
+			n = ARRAY_SIZE(tvp5150_qctrl);
 			for (i = 0; i < n; i++)
 				if (ctrl->id == tvp5150_qctrl[i].id) {
 					if (ctrl->value <
diff --git a/drivers/media/video/usbvideo/quickcam_messenger.c b/drivers/media/video/usbvideo/quickcam_messenger.c
index ec0ff22..082560e 100644
--- a/drivers/media/video/usbvideo/quickcam_messenger.c
+++ b/drivers/media/video/usbvideo/quickcam_messenger.c
@@ -439,7 +439,7 @@ static int qcm_sensor_init(struct uvd *uvd)
 	int ret;
 	int i;
 
-	for (i=0; i < sizeof(regval_table)/sizeof(regval_table[0]) ; i++) {
+	for (i = 0; i < ARRAY_SIZE(regval_table); i++) {
 		CHECK_RET(ret, qcm_stv_setb(uvd->dev,
 					regval_table[i].reg,
 					regval_table[i].val));

-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
