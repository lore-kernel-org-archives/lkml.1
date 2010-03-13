Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935975Ab0CMBJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:09:47 -0500
Received: from kroah.org ([198.145.64.141]:46750 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935377Ab0CMAbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:31:00 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:07 2010
Message-Id: <20100313002707.774311827@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:26:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Peter Hutterer <peter.hutterer@redhat.com>,
       Jiri Kosina <jkosina@suse.cz>, maximilian attems <max@stro.at>
Subject: [029/145] HID: add multi-input quirk for NextWindow Touchscreen.
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Peter Hutterer <peter.hutterer@redhat.com>

commit 9db630b48a99adb4156e205b812fba8959644280 upstream.

These touchscreens are mounted onto HP TouchSmart and the Dell Studio One
19. Without a quirk they report a wrong button set and the x/y coordinates
through ABS_Z/ABS_RX, confusing the higher levels (most notably X.Org's
evdev driver).

Device id 0x003 covers models 1900, 2150, and 2700 [1] though testing could
only be performed on a model 1900.

[1] http://www.nextwindow.com/nextwindow_support/latest_tech_info.html

Signed-off-by: Peter Hutterer <peter.hutterer@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/hid-ids.h           |    3 +++
 drivers/hid/usbhid/hid-quirks.c |    1 +
 2 files changed, 4 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -349,6 +349,9 @@
 #define USB_VENDOR_ID_NEC		0x073e
 #define USB_DEVICE_ID_NEC_USB_GAME_PAD	0x0301
 
+#define USB_VENDOR_ID_NEXTWINDOW	0x1926
+#define USB_DEVICE_ID_NEXTWINDOW_TOUCHSCREEN	0x0003
+
 #define USB_VENDOR_ID_NTRIG                0x1b96
 #define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN   0x0001
 
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -37,6 +37,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_FIGHTING, HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_NATSU, USB_DEVICE_ID_NATSU_GAMEPAD, HID_QUIRK_BADPAD },
 	{ USB_VENDOR_ID_NEC, USB_DEVICE_ID_NEC_USB_GAME_PAD, HID_QUIRK_BADPAD },
+	{ USB_VENDOR_ID_NEXTWINDOW, USB_DEVICE_ID_NEXTWINDOW_TOUCHSCREEN, HID_QUIRK_MULTI_INPUT},
 	{ USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_RUMBLEPAD, HID_QUIRK_BADPAD },
 	{ USB_VENDOR_ID_TOPMAX, USB_DEVICE_ID_TOPMAX_COBRAPAD, HID_QUIRK_BADPAD },
 


