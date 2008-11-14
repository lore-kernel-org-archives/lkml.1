Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004AbYKNRSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbYKNRSQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 12:18:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbYKNRSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 12:18:00 -0500
Received: from stag.seas.upenn.edu ([158.130.70.79]:56907 "EHLO
	stag.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbYKNRR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 12:17:59 -0500
X-Greylist: delayed 577 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Nov 2008 12:17:59 EST
Date: Fri, 14 Nov 2008 12:08:18 -0500 (EST)
From: Raphael Yoram Rubin <rafi@seas.upenn.edu>
To: Jiri Kosina <jkosina@suse.cz>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] n-trig digitizer quirks
Message-ID: <Pine.LNX.4.61.0811141207210.12963@minus.seas.upenn.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added quirks for the N-Trig digitizer.
Signed-off-by: Rafi Rubin <rafi@seas.upenn.edu>

---
diff -uprN linux-2.6.27.6-vanilla/drivers/hid/hid-input-quirks.c linux-2.6.27.6/drivers/hid/hid-input-quirks.c
--- linux-2.6.27.6-vanilla/drivers/hid/hid-input-quirks.c	2008-11-13 12:56:21.000000000 -0500
+++ linux-2.6.27.6/drivers/hid/hid-input-quirks.c	2008-11-14 07:17:54.721758855 -0500
@@ -314,6 +314,17 @@ static int quirk_sunplus_wdesktop(struct
  	return 1;
  }

+static int quirk_ntrig_touch_screen(struct hid_usage *usage, struct input_dev *input,
+			      unsigned long **bit, int *max)
+{
+	if ( (usage->hid & HID_USAGE_PAGE) == HID_UP_DIGITIZER &&
+	    (usage->hid & 0xff) == 0x47) {
+      map_key_clear(BTN_TOOL_DOUBLETAP);
+		return 1;
+	}
+   return 0;
+}
+
  #define VENDOR_ID_BELKIN			0x1020
  #define DEVICE_ID_BELKIN_WIRELESS_KEYBOARD	0x0006

@@ -335,6 +346,9 @@ static int quirk_sunplus_wdesktop(struct
  #define DEVICE_ID_S510_RECEIVER_2		0xc517
  #define DEVICE_ID_MX3000_RECEIVER		0xc513

+#define VENDOR_ID_NTRIG                0x1b96
+#define DEVICE_ID_NTRIG_TOUCH_SCREEN	0x0001
+
  #define VENDOR_ID_MICROSOFT			0x045e
  #define DEVICE_ID_MS4K				0x00db
  #define DEVICE_ID_MS6K				0x00f9
@@ -380,6 +394,7 @@ static const struct hid_input_blacklist
  	{ VENDOR_ID_PETALYNX, DEVICE_ID_PETALYNX_MAXTER_REMOTE, quirk_petalynx_remote },

  	{ VENDOR_ID_SUNPLUS, DEVICE_ID_SUNPLUS_WDESKTOP, quirk_sunplus_wdesktop },
+	{ VENDOR_ID_NTRIG, DEVICE_ID_NTRIG_TOUCH_SCREEN, quirk_ntrig_touch_screen },

  	{ 0, 0, NULL }
  };
diff -uprN linux-2.6.27.6-vanilla/drivers/hid/usbhid/hid-quirks.c linux-2.6.27.6/drivers/hid/usbhid/hid-quirks.c
--- linux-2.6.27.6-vanilla/drivers/hid/usbhid/hid-quirks.c	2008-11-13 12:56:21.000000000 -0500
+++ linux-2.6.27.6/drivers/hid/usbhid/hid-quirks.c	2008-11-14 07:17:54.722758633 -0500
@@ -359,6 +359,9 @@
  #define USB_VENDOR_ID_NEC		0x073e
  #define USB_DEVICE_ID_NEC_USB_GAME_PAD	0x0301

+#define USB_VENDOR_ID_NTRIG		0x1b96
+#define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN	0x0001
+
  #define USB_VENDOR_ID_ONTRAK		0x0a07
  #define USB_DEVICE_ID_ONTRAK_ADU100	0x0064

@@ -448,6 +451,7 @@ static const struct hid_blacklist {
  	{ USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_FIGHTING, HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
  	{ USB_VENDOR_ID_NATSU, USB_DEVICE_ID_NATSU_GAMEPAD, HID_QUIRK_BADPAD },
  	{ USB_VENDOR_ID_NEC, USB_DEVICE_ID_NEC_USB_GAME_PAD, HID_QUIRK_BADPAD },
+	{ USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN, HID_QUIRK_DUPLICATE_USAGES },
  	{ USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_RUMBLEPAD, HID_QUIRK_BADPAD },
  	{ USB_VENDOR_ID_TOPMAX, USB_DEVICE_ID_TOPMAX_COBRAPAD, HID_QUIRK_BADPAD },

