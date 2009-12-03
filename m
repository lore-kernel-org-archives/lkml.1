Return-Path: <linux-kernel-owner+w=401wt.eu-S1751443AbZLCFUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443AbZLCFUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 00:20:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbZLCFUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 00:20:39 -0500
Received: from leo.clearchain.com ([199.73.29.74]:18996 "EHLO
	mail.clearchain.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbZLCFUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 00:20:38 -0500
X-Greylist: delayed 680 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Dec 2009 00:20:37 EST
Date: Thu, 3 Dec 2009 15:08:10 +1000
From: Peter Hutterer <peter.hutterer@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] HID: add multi-input quirk for NextWindow Touchscreen.
Message-ID: <20091203050810.GA26595@barra.bne.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-4.0.1 (mail.clearchain.com [127.0.0.1]); Thu, 03 Dec 2009 15:39:20 +1030 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These touchscreens are mounted onto HP TouchSmart and the Dell Studio One
19. Without a quirk they report a wrong button set and the x/y coordinates
through ABS_Z/ABS_RX, confusing the higher levels (most notably X.Org's
evdev driver).

Device id 0x003 covers models 1900, 2150, and 2700 [1] though testing could
only be performed on a model 1900.

[1] http://www.nextwindow.com/nextwindow_support/latest_tech_info.html

Signed-off-by: Peter Hutterer <peter.hutterer@redhat.com>
---
 drivers/hid/hid-ids.h           |    3 +++
 drivers/hid/usbhid/hid-quirks.c |    1 +
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index adbef5d..f5144b8 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -346,6 +346,9 @@
 #define USB_VENDOR_ID_NEC		0x073e
 #define USB_DEVICE_ID_NEC_USB_GAME_PAD	0x0301
 
+#define USB_VENDOR_ID_NEXTWINDOW	0x1926
+#define USB_DEVICE_ID_NEXTWINDOW_TOUCHSCREEN	0x0003
+
 #define USB_VENDOR_ID_NTRIG                0x1b96
 #define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN   0x0001
 
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index 0d9045a..e987562 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -37,6 +37,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_FIGHTING, HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_NATSU, USB_DEVICE_ID_NATSU_GAMEPAD, HID_QUIRK_BADPAD },
 	{ USB_VENDOR_ID_NEC, USB_DEVICE_ID_NEC_USB_GAME_PAD, HID_QUIRK_BADPAD },
+	{ USB_VENDOR_ID_NEXTWINDOW, USB_DEVICE_ID_NEXTWINDOW_TOUCHSCREEN, HID_QUIRK_MULTI_INPUT},
 	{ USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_RUMBLEPAD, HID_QUIRK_BADPAD },
 	{ USB_VENDOR_ID_TOPMAX, USB_DEVICE_ID_TOPMAX_COBRAPAD, HID_QUIRK_BADPAD },
 
-- 
1.6.5.2

