Return-Path: <linux-kernel-owner+w=401wt.eu-S1751502AbZL1NR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbZL1NR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 08:17:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751043AbZL1NR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 08:17:28 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:32779 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbZL1NR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 08:17:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type;
        b=GmMBoFwVog2IiaRE8z+aNs6NKVB4sVt+crMQ3+vMs7RGQfI6AbngCkap55W7tma5FF
         qlYxIZZUvaCmCNL6jzBS7WoC/MhX3p4kVxk4C9EQXpMZiojI+hxW2CsTtcOVeIGSPc2e
         NdktrbkBju/EMGbhrvqYGcfvJ9rw2PcxxX4Wo=
Message-ID: <4B38AFDE.8000203@gmail.com>
Date: Mon, 28 Dec 2009 14:17:18 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-13.1 Thunderbird/3.0
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-input@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Christian Schuerer-Waldheim <csw@xray.at>
Subject: Re: Device IDs for new Apple Wireless Keyboard
X-Enigmail-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080702090106000903070908"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080702090106000903070908
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi, I added some proper CCs. For me they look good. Care to add
signed-off-by line? Thanks.

---- original message ----
Hello Jiri,

I'm writing to you because you are the last in the list of contributors
in the
file hid-apple.c of the linux kernel.

Since November 2009 Apple is selling a new make of its Wireless Keyboard,
which have new device IDs. In order to make the kernel driver hid-apple to
take care about this new devices, the new IDs have to be added. I've
created
patches for the 2.6.31 and 2.6.32 kernel. Could you please integrate
them into
the main kernel?

If you are not responsible for it anymore, please tell me whom I may
contact
instead. Thank you!

N.B.: The ID of the JIS-version is an assumption. The other two IDs
where read
from the new devices.

Greetings,

Christian Schürer-Waldheim



--------------080702090106000903070908
Content-Type: text/x-patch;
 name="apple-wireless-keyboard-2009-linux-2.6.31.9.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="apple-wireless-keyboard-2009-linux-2.6.31.9.diff"

=== modified file 'drivers/hid/hid-apple.c'
--- old/drivers/hid/hid-apple.c	2009-12-23 23:29:17 +0000
+++ new/drivers/hid/hid-apple.c	2009-12-23 23:51:58 +0000
@@ -413,6 +413,13 @@
 			APPLE_ISO_KEYBOARD },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_JIS),
 		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ANSI),
+		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO),
+		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN |
+			APPLE_ISO_KEYBOARD },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_JIS),
+		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_ANSI),
 		.driver_data = APPLE_HAS_FN },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_ISO),

=== modified file 'drivers/hid/hid-core.c'
--- old/drivers/hid/hid-core.c	2009-12-23 23:29:17 +0000
+++ new/drivers/hid/hid-core.c	2009-12-23 23:51:58 +0000
@@ -1250,6 +1250,9 @@
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_ANSI) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_ISO) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_JIS) },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ANSI) },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO) },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_JIS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_ANSI) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_ISO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_JIS) },

=== modified file 'drivers/hid/hid-ids.h'
--- old/drivers/hid/hid-ids.h	2009-12-23 23:29:17 +0000
+++ new/drivers/hid/hid-ids.h	2009-12-23 23:51:58 +0000
@@ -82,6 +82,9 @@
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_ANSI  0x022c
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_ISO   0x022d
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_JIS   0x022e
+#define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ANSI  0x0239
+#define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO   0x023a
+#define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_JIS   0x023b
 #define USB_DEVICE_ID_APPLE_WELLSPRING2_ANSI	0x0230
 #define USB_DEVICE_ID_APPLE_WELLSPRING2_ISO	0x0231
 #define USB_DEVICE_ID_APPLE_WELLSPRING2_JIS	0x0232




--------------080702090106000903070908
Content-Type: text/x-patch;
 name="apple-wireless-keyboard-2009-linux-2.6.32.2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="apple-wireless-keyboard-2009-linux-2.6.32.2.diff"

=== modified file 'drivers/hid/hid-apple.c'
--- old/drivers/hid/hid-apple.c	2009-12-24 00:17:19 +0000
+++ new/drivers/hid/hid-apple.c	2009-12-24 00:19:58 +0000
@@ -413,6 +413,13 @@
 			APPLE_ISO_KEYBOARD },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_JIS),
 		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ANSI),
+		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO),
+		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN |
+			APPLE_ISO_KEYBOARD },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_JIS),
+		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_ANSI),
 		.driver_data = APPLE_HAS_FN },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_ISO),

=== modified file 'drivers/hid/hid-core.c'
--- old/drivers/hid/hid-core.c	2009-12-24 00:17:19 +0000
+++ new/drivers/hid/hid-core.c	2009-12-24 00:19:58 +0000
@@ -1278,6 +1278,9 @@
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_ANSI) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_ISO) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_JIS) },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ANSI) },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO) },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_JIS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_ANSI) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_ISO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_JIS) },

=== modified file 'drivers/hid/hid-ids.h'
--- old/drivers/hid/hid-ids.h	2009-12-24 00:17:19 +0000
+++ new/drivers/hid/hid-ids.h	2009-12-24 00:19:58 +0000
@@ -82,6 +82,9 @@
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_ANSI  0x022c
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_ISO   0x022d
 #define USB_DEVICE_ID_APPLE_ALU_WIRELESS_JIS   0x022e
+#define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ANSI  0x0239
+#define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO   0x023a
+#define USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_JIS   0x023b
 #define USB_DEVICE_ID_APPLE_WELLSPRING2_ANSI	0x0230
 #define USB_DEVICE_ID_APPLE_WELLSPRING2_ISO	0x0231
 #define USB_DEVICE_ID_APPLE_WELLSPRING2_JIS	0x0232




--------------080702090106000903070908--
