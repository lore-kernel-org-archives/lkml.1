Return-Path: <linux-kernel-owner+w=401wt.eu-S1755282AbXD3Mcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbXD3Mcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 08:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755253AbXD3Mcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 08:32:31 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:43220 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237AbXD3Mc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 08:32:27 -0400
Date: Mon, 30 Apr 2007 14:30:53 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: v4l-dvb-maintainer@linuxtv.org
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       video4linux-list@redhat.com, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 36/36] Use menuconfig objects II - V4L
In-Reply-To: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704301430200.29151@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Change Kconfig objects from "menu, config" into "menuconfig" so
that the user can disable the whole feature without having to
enter the menu first.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 drivers/media/radio/Kconfig           |    9 +++++--
 drivers/media/video/Kconfig           |   43 ++++++++++++++++++----------------
 drivers/media/video/em28xx/Kconfig    |    2 -
 drivers/media/video/et61x251/Kconfig  |    2 -
 drivers/media/video/pvrusb2/Kconfig   |    2 -
 drivers/media/video/pwc/Kconfig       |    2 -
 drivers/media/video/sn9c102/Kconfig   |    2 -
 drivers/media/video/usbvideo/Kconfig  |    8 +++---
 drivers/media/video/usbvision/Kconfig |    2 -
 drivers/media/video/zc0301/Kconfig    |    2 -
 10 files changed, 42 insertions(+), 32 deletions(-)

Index: linux-2.6.21-mm_20070428/drivers/media/radio/Kconfig
===================================================================
--- linux-2.6.21-mm_20070428.orig/drivers/media/radio/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/media/radio/Kconfig
@@ -2,8 +2,12 @@
 # Multimedia Video device configuration
 #
 
-menu "Radio Adapters"
+menuconfig RADIO_ADAPTERS
+	bool "Radio Adapters"
 	depends on VIDEO_DEV
+	default y
+
+if RADIO_ADAPTERS
 
 config RADIO_CADET
 	tristate "ADS Cadet AM/FM Tuner"
@@ -328,4 +332,5 @@ config USB_DSBR
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called dsbr100.
-endmenu
+
+endif # RADIO_ADAPTERS
Index: linux-2.6.21-mm_20070428/drivers/media/video/Kconfig
===================================================================
--- linux-2.6.21-mm_20070428.orig/drivers/media/video/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/media/video/Kconfig
@@ -2,14 +2,15 @@
 # Multimedia Video device configuration
 #
 
-menu "Video Capture Adapters"
+menuconfig VIDEO_CAPTURE_DRIVERS
+	bool "Video capture adapters"
 	depends on VIDEO_DEV
+	default y
 
-comment "Video Capture Adapters"
+if VIDEO_CAPTURE_DRIVERS
 
 config VIDEO_ADV_DEBUG
 	bool "Enable advanced debug functionality"
-	depends on VIDEO_DEV
 	default n
 	---help---
 	  Say Y here to enable advanced debugging functionality on some
@@ -34,7 +35,7 @@ config VIDEO_HELPER_CHIPS_AUTO
 #
 
 menu "Encoders/decoders and other helper chips"
-	depends on VIDEO_DEV && !VIDEO_HELPER_CHIPS_AUTO
+	depends on !VIDEO_HELPER_CHIPS_AUTO
 
 comment "Audio decoders"
 
@@ -61,7 +62,7 @@ config VIDEO_TDA7432
 
 config VIDEO_TDA9840
 	tristate "Philips TDA9840 audio processor"
-	depends on VIDEO_DEV && I2C
+	depends on I2C
 	---help---
 	  Support for tda9840 audio decoder chip found on some Zoran boards.
 
@@ -79,7 +80,7 @@ config VIDEO_TDA9875
 
 config VIDEO_TEA6415C
 	tristate "Philips TEA6415C audio processor"
-	depends on VIDEO_DEV && I2C
+	depends on I2C
 	---help---
 	  Support for tea6415c audio decoder chip found on some bt8xx boards.
 
@@ -88,7 +89,7 @@ config VIDEO_TEA6415C
 
 config VIDEO_TEA6420
 	tristate "Philips TEA6420 audio processor"
-	depends on VIDEO_DEV && I2C
+	depends on I2C
 	---help---
 	  Support for tea6420 audio decoder chip found on some bt8xx boards.
 
@@ -469,7 +470,7 @@ config VIDEO_SAA5246A
 
 config VIDEO_SAA5249
 	tristate "SAA5249 Teletext processor"
-	depends on VIDEO_DEV && I2C && VIDEO_V4L2
+	depends on I2C && VIDEO_V4L2
 	help
 	  Support for I2C bus based teletext using the SAA5249 chip. At the
 	  moment this is only useful on some European WinTV cards.
@@ -479,14 +480,14 @@ config VIDEO_SAA5249
 
 config TUNER_3036
 	tristate "SAB3036 tuner"
-	depends on VIDEO_DEV && I2C && VIDEO_V4L1
+	depends on I2C && VIDEO_V4L1
 	help
 	  Say Y here to include support for Philips SAB3036 compatible tuners.
 	  If in doubt, say N.
 
 config TUNER_TEA5761
 	tristate "TEA 5761 radio tuner (EXPERIMENTAL)"
-	depends on VIDEO_DEV && I2C
+	depends on I2C
 	select VIDEO_TUNER
 	help
 	  Say Y here to include support for Philips TEA5761 radio tuner.
@@ -689,8 +690,12 @@ config VIDEO_CAFE_CCIC
 # USB Multimedia device configuration
 #
 
-menu "V4L USB devices"
-	depends on USB && VIDEO_DEV
+menuconfig V4L_USB_DRIVERS
+	bool "V4L USB devices"
+	depends on USB
+	default y
+
+if V4L_USB_DRIVERS
 
 source "drivers/media/video/pvrusb2/Kconfig"
 
@@ -715,7 +720,7 @@ config VIDEO_OVCAMCHIP
 
 config USB_W9968CF
 	tristate "USB W996[87]CF JPEG Dual Mode Camera support"
-	depends on USB && VIDEO_V4L1 && I2C
+	depends on VIDEO_V4L1 && I2C
 	select VIDEO_OVCAMCHIP
 	---help---
 	  Say Y here if you want support for cameras based on OV681 or
@@ -733,7 +738,7 @@ config USB_W9968CF
 
 config USB_OV511
 	tristate "USB OV511 Camera support"
-	depends on USB && VIDEO_V4L1
+	depends on VIDEO_V4L1
 	---help---
 	  Say Y here if you want to connect this type of camera to your
 	  computer's USB port. See <file:Documentation/video4linux/ov511.txt>
@@ -744,7 +749,7 @@ config USB_OV511
 
 config USB_SE401
 	tristate "USB SE401 Camera support"
-	depends on USB && VIDEO_V4L1
+	depends on VIDEO_V4L1
 	---help---
 	  Say Y here if you want to connect this type of camera to your
 	  computer's USB port. See <file:Documentation/video4linux/se401.txt>
@@ -757,7 +762,7 @@ source "drivers/media/video/sn9c102/Kcon
 
 config USB_STV680
 	tristate "USB STV680 (Pencam) Camera support"
-	depends on USB && VIDEO_V4L1
+	depends on VIDEO_V4L1
 	---help---
 	  Say Y here if you want to connect this type of camera to your
 	  computer's USB port. This includes the Pencam line of cameras.
@@ -773,7 +778,7 @@ source "drivers/media/video/pwc/Kconfig"
 
 config USB_ZR364XX
 	tristate "USB ZR364XX Camera support"
-	depends on USB && VIDEO_V4L2
+	depends on VIDEO_V4L2
 	---help---
 	  Say Y here if you want to connect this type of camera to your
 	  computer's USB port.
@@ -783,6 +788,6 @@ config USB_ZR364XX
 	  To compile this driver as a module, choose M here: the
 	  module will be called zr364xx.
 
-endmenu # V4L USB devices
+endif # V4L_USB_DRIVERS
 
-endmenu
+endif # VIDEO_CAPTURE_DRIVERS
Index: linux-2.6.21-mm_20070428/drivers/media/video/em28xx/Kconfig
===================================================================
--- linux-2.6.21-mm_20070428.orig/drivers/media/video/em28xx/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/media/video/em28xx/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_EM28XX
 	tristate "Empia EM2800/2820/2840 USB video capture support"
-	depends on VIDEO_V4L1 && USB && I2C
+	depends on VIDEO_V4L1 && I2C
 	select VIDEO_BUF
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
Index: linux-2.6.21-mm_20070428/drivers/media/video/et61x251/Kconfig
===================================================================
--- linux-2.6.21-mm_20070428.orig/drivers/media/video/et61x251/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/media/video/et61x251/Kconfig
@@ -1,6 +1,6 @@
 config USB_ET61X251
 	tristate "USB ET61X[12]51 PC Camera Controller support"
-	depends on USB && VIDEO_V4L1
+	depends on VIDEO_V4L1
 	---help---
 	  Say Y here if you want support for cameras based on Etoms ET61X151
 	  or ET61X251 PC Camera Controllers.
Index: linux-2.6.21-mm_20070428/drivers/media/video/pvrusb2/Kconfig
===================================================================
--- linux-2.6.21-mm_20070428.orig/drivers/media/video/pvrusb2/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/media/video/pvrusb2/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_PVRUSB2
 	tristate "Hauppauge WinTV-PVR USB2 support"
-	depends on VIDEO_V4L2 && USB && I2C && EXPERIMENTAL
+	depends on VIDEO_V4L2 && I2C && EXPERIMENTAL
 	select FW_LOADER
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
Index: linux-2.6.21-mm_20070428/drivers/media/video/pwc/Kconfig
===================================================================
--- linux-2.6.21-mm_20070428.orig/drivers/media/video/pwc/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/media/video/pwc/Kconfig
@@ -1,6 +1,6 @@
 config USB_PWC
 	tristate "USB Philips Cameras"
-	depends on USB && VIDEO_V4L1
+	depends on VIDEO_V4L1
 	---help---
 	  Say Y or M here if you want to use one of these Philips & OEM
 	  webcams:
Index: linux-2.6.21-mm_20070428/drivers/media/video/sn9c102/Kconfig
===================================================================
--- linux-2.6.21-mm_20070428.orig/drivers/media/video/sn9c102/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/media/video/sn9c102/Kconfig
@@ -1,6 +1,6 @@
 config USB_SN9C102
 	tristate "USB SN9C1xx PC Camera Controller support"
-	depends on USB && VIDEO_V4L2
+	depends on VIDEO_V4L2
 	---help---
 	  Say Y here if you want support for cameras based on SONiX SN9C101,
 	  SN9C102, SN9C103, SN9C105 and SN9C120 PC Camera Controllers.
Index: linux-2.6.21-mm_20070428/drivers/media/video/usbvideo/Kconfig
===================================================================
--- linux-2.6.21-mm_20070428.orig/drivers/media/video/usbvideo/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/media/video/usbvideo/Kconfig
@@ -3,7 +3,7 @@ config VIDEO_USBVIDEO
 
 config USB_VICAM
 	tristate "USB 3com HomeConnect (aka vicam) support (EXPERIMENTAL)"
-	depends on USB && VIDEO_DEV && VIDEO_V4L1 && EXPERIMENTAL
+	depends on VIDEO_V4L1 && EXPERIMENTAL
 	select VIDEO_USBVIDEO
 	---help---
 	  Say Y here if you have 3com homeconnect camera (vicam).
@@ -13,7 +13,7 @@ config USB_VICAM
 
 config USB_IBMCAM
 	tristate "USB IBM (Xirlink) C-it Camera support"
-	depends on USB && VIDEO_DEV && VIDEO_V4L1
+	depends on VIDEO_V4L1
 	select VIDEO_USBVIDEO
 	---help---
 	  Say Y here if you want to connect a IBM "C-It" camera, also known as
@@ -28,7 +28,7 @@ config USB_IBMCAM
 
 config USB_KONICAWC
 	tristate "USB Konica Webcam support"
-	depends on USB && VIDEO_DEV && VIDEO_V4L1
+	depends on VIDEO_V4L1
 	select VIDEO_USBVIDEO
 	---help---
 	  Say Y here if you want support for webcams based on a Konica
@@ -39,7 +39,7 @@ config USB_KONICAWC
 
 config USB_QUICKCAM_MESSENGER
 	tristate "USB Logitech Quickcam Messenger"
-	depends on USB && VIDEO_DEV && VIDEO_V4L1
+	depends on VIDEO_V4L1
 	select VIDEO_USBVIDEO
 	---help---
 	  Say Y or M here to enable support for the USB Logitech Quickcam
Index: linux-2.6.21-mm_20070428/drivers/media/video/usbvision/Kconfig
===================================================================
--- linux-2.6.21-mm_20070428.orig/drivers/media/video/usbvision/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/media/video/usbvision/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_USBVISION
 	tristate "USB video devices based on Nogatech NT1003/1004/1005"
-	depends on I2C && VIDEO_V4L2 && USB
+	depends on I2C && VIDEO_V4L2
 	select VIDEO_TUNER
 	select VIDEO_SAA711X if VIDEO_HELPER_CHIPS_AUTO
 	---help---
Index: linux-2.6.21-mm_20070428/drivers/media/video/zc0301/Kconfig
===================================================================
--- linux-2.6.21-mm_20070428.orig/drivers/media/video/zc0301/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/media/video/zc0301/Kconfig
@@ -1,6 +1,6 @@
 config USB_ZC0301
 	tristate "USB ZC0301[P] Image Processor and Control Chip support"
-	depends on USB && VIDEO_V4L1
+	depends on VIDEO_V4L1
 	---help---
 	  Say Y here if you want support for cameras based on the ZC0301 or
 	  ZC0301P Image Processors and Control Chips.
