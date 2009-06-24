Return-Path: <linux-kernel-owner+w=401wt.eu-S1761602AbZFXRsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761602AbZFXRsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 13:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760889AbZFXRsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 13:48:14 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:38848 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761253AbZFXRsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 13:48:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=VelBthn9R3ZF9zgHDP3VCp+eJbqKDhS6Ug+z23+ov0eqiX/y7KVxrG9AAiEE7wLmFz
         kgrgnhNJqufinC627z81Xqis0kgH6YiMp7l++avuObJL9MooN3EJCLQOtUdr/6hqEMbQ
         612NIXQJLZS/xMtPwGva0KQBC7xa5XMSkxgB4=
Message-ID: <4A4266CC.5000005@gmail.com>
Date: Wed, 24 Jun 2009 19:47:56 +0200
From: rubenatch <rubenatch@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: jkosina@suse.cz
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] HID: Supporting rumble in another Thrustmaster gamepad
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rubén Aós Garralda

This patch enables rumble in Thrustmaster Dual 3-in-1 trigger gamepads
(both PC and PS3 modes). It only informs hid-tmff.c the USB IDs and
force feedback modes for that gamepad, and puts the gamepad in the
"forbidden" list in hid-core.c

Signed-off-by: Rubén Aós Garralda <rubenatch@gmail.com>

---

diff -uprN linux-source-2.6.30/drivers/hid/hid-core.c
linux-source-test/drivers/hid/hid-core.c
--- linux-source-2.6.30/drivers/hid/hid-core.c  2009-06-10
05:05:27.000000000 +0200
+++ linux-source-test/drivers/hid/hid-core.c    2009-06-24
18:39:41.000000000 +0200
@@ -1309,6 +1309,8 @@ static const struct hid_device_id hid_bl
        { HID_USB_DEVICE(USB_VENDOR_ID_SUNPLUS,
USB_DEVICE_ID_SUNPLUS_WDESKTOP) },
        { HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb300) },
        { HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb304) },
+       { HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb323) },
+        { HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb324) },
        { HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb651) },
        { HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb654) },
        { HID_USB_DEVICE(USB_VENDOR_ID_TOPSEED,
USB_DEVICE_ID_TOPSEED_CYBERLINK) },
diff -uprN linux-source-2.6.30/drivers/hid/hid-tmff.c
linux-source-test/drivers/hid/hid-tmff.c
--- linux-source-2.6.30/drivers/hid/hid-tmff.c  2009-06-10
05:05:27.000000000 +0200
+++ linux-source-test/drivers/hid/hid-tmff.c    2009-06-24
18:41:04.000000000 +0200
@@ -238,6 +238,10 @@ static const struct hid_device_id tm_dev
                .driver_data = (unsigned long)ff_rumble },
        { HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb304),
                .driver_data = (unsigned long)ff_rumble },
+       { HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb323),   /* Dual
Trigger 3-in-1 (PC Mode) */
+                .driver_data = (unsigned long)ff_rumble },
+        { HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb324),   /* Dual
Trigger 3-in-1 (PS3 Mode) */
+                .driver_data = (unsigned long)ff_rumble },
        { HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb651),   /* FGT
Rumble Force Wheel */
                .driver_data = (unsigned long)ff_rumble },
        { HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb654),   /* FGT
Force Feedback Wheel */

