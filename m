Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab0BBDnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 22:43:18 -0500
Received: from leo.clearchain.com ([199.73.29.74]:21036 "EHLO
	mail.clearchain.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463Ab0BBDnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 22:43:15 -0500
Date: Tue, 2 Feb 2010 13:40:40 +1000
From: Peter Hutterer <peter.hutterer@who-t.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] HID: add multi-input quirk for eGalax Touchcontroller
Message-ID: <20100202034040.GA16880@barra.bne.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-4.0.1 (mail.clearchain.com [127.0.0.1]); Tue, 02 Feb 2010 14:13:12 +1030 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Hutterer <peter.hutterer@who-t.net>
---
I've got one of these devices on my desk and it seems that it suffers from
the ABS_Z/ABS_RX issue that we've seen in other devices before. This patch
uses the same reasoning as 9db630b48a99adb4156e205b812fba8959644280.

Nonetheless, I'm not sure about whether that's the right thing to do. With
this patch applied, it gives me two devices, one mute, the other one
announces BTN_PEN and BTN_TOUCH + abs axes, though only BTN_TOUCH is ever
triggered. Loading usbtouchscreen instead of usbhid for this device makes
the device look more sane BTN_TOUCH + abs axes but the actual data is
random. So I'm not quite sure what the fix is supposed to be, any hints are
appreciated if it's not the patch below.

Cheers,
  Peter


 drivers/hid/hid-ids.h           |    3 +++
 drivers/hid/usbhid/hid-quirks.c |    1 +
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index f5144b8..2e698a2 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -158,6 +158,9 @@
 
 #define USB_VENDOR_ID_DRAGONRISE	0x0079
 
+#define USB_VENDOR_ID_EGALAX		0x0EEF
+#define USB_DEVICE_ID_EGALAX_TOUCHCONTROLLER	0x0001
+
 #define USB_VENDOR_ID_ELO		0x04E7
 #define USB_DEVICE_ID_ELO_TS2700	0x0020
 
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index e987562..dc27d74 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -32,6 +32,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_AASHIMA, USB_DEVICE_ID_AASHIMA_PREDATOR, HID_QUIRK_BADPAD },
 	{ USB_VENDOR_ID_ALPS, USB_DEVICE_ID_IBM_GAMEPAD, HID_QUIRK_BADPAD },
 	{ USB_VENDOR_ID_CHIC, USB_DEVICE_ID_CHIC_GAMEPAD, HID_QUIRK_BADPAD },
+	{ USB_VENDOR_ID_EGALAX, USB_DEVICE_ID_EGALAX_TOUCHCONTROLLER, HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_DRIVING, HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_FLYING, HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_FIGHTING, HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
-- 
1.6.5.2
