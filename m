Return-Path: <linux-kernel-owner+w=401wt.eu-S1752634AbZIQTbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbZIQTbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 15:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbZIQTbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 15:31:16 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:14347 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbZIQTbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 15:31:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=C/VbVEg67jl7sXL9Am/UPI/VKW7mMJFNnS32IvWPwda3h6a2Caq7+cAYcsRzTpyfxT
         Eu8PJmCf9+q1iOaiaPnu4XKM3l2jsIAcaoqw0GqxBF5sL2jAVQT2gip8TgZErkotpLz/
         5hLl5SDrMQUEm7l8lNLBX/OCJQ3Ub2toIyKNE=
From: getarunks@gmail.com
To: linux-kernel@vger.kernel.org, rpurdie@rpsys.net
Cc: eric.miao@marvell.com, mike@compulab.co.il, eric.y.miao@gmail.com,
       Arun KS <getarunks@gmail.com>
Subject: [PATCH] Adding LED1 & LED2 control for DA9034 backlight driver
Date: Thu, 17 Sep 2009 12:30:07 -0700
Message-Id: <1253215807-11718-1-git-send-email-getarunks@gmail.com>
X-Mailer: git-send-email 1.5.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arun KS <getarunks@gmail.com>

Signed-off-by: Arun KS <getarunks@gmail.com>
---
 drivers/video/backlight/Kconfig     |    2 +-
 drivers/video/backlight/da903x_bl.c |   12 ++++++++++++
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index 90861cd..1607bc9 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -203,7 +203,7 @@ config BACKLIGHT_DA903X
 	depends on BACKLIGHT_CLASS_DEVICE && PMIC_DA903X
 	help
 	  If you have a LCD backlight connected to the WLED output of DA9030
-	  or DA9034 WLED output, say Y here to enable this driver.
+	  or DA9034 WLED, LED1, LED2 outputs, say Y here to enable this driver.
 
 config BACKLIGHT_MBP_NVIDIA
        tristate "MacBook Pro Nvidia Backlight Driver"
diff --git a/drivers/video/backlight/da903x_bl.c b/drivers/video/backlight/da903x_bl.c
index 93bb434..c6ceb76 100644
--- a/drivers/video/backlight/da903x_bl.c
+++ b/drivers/video/backlight/da903x_bl.c
@@ -23,6 +23,8 @@
 #define DA9030_WLED_CP_EN	(1 << 6)
 #define DA9030_WLED_TRIM(x)	((x) & 0x7)
 
+#define DA9034_LED1_CONTROL	0x35
+#define DA9034_LED2_CONTROL	0x36
 #define DA9034_WLED_CONTROL1	0x3C
 #define DA9034_WLED_CONTROL2	0x3D
 
@@ -66,6 +68,14 @@ static int da903x_backlight_set(struct backlight_device *bl, int brightness)
 		val |= brightness ? DA9030_WLED_CP_EN : 0;
 		ret = da903x_write(dev, DA9030_WLED_CONTROL, val);
 		break;
+	case DA9034_ID_LED_1:
+		ret = da903x_update(dev, DA9034_LED1_CONTROL,
+				brightness, 0x7f);
+		break;
+	case DA9034_ID_LED_2:
+		ret = da903x_update(dev, DA9034_LED2_CONTROL,
+				brightness, 0x7f);
+		break;
 	}
 
 	if (ret)
@@ -114,6 +124,8 @@ static int da903x_backlight_probe(struct platform_device *pdev)
 		max_brightness = DA9030_MAX_BRIGHTNESS;
 		break;
 	case DA9034_ID_WLED:
+	case DA9034_ID_LED_1:
+	case DA9034_ID_LED_2:
 		max_brightness = DA9034_MAX_BRIGHTNESS;
 		break;
 	default:
-- 
1.5.4.3

