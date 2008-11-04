Return-Path: <linux-kernel-owner+w=401wt.eu-S1758027AbYKDXlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027AbYKDXlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:41:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756454AbYKDXiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:38:15 -0500
Received: from mx1.suse.de ([195.135.220.2]:47322 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756283AbYKDXiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:38:13 -0500
Date: Tue, 4 Nov 2008 15:31:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Dan Nicholson <dbn.lists@gmail.com>,
       Jiri Kosina <jkosina@suse.cz>
Subject: [patch 12/57] Revert "HID: Invert HWHEEL mappings for some
	Logitech mice"
Message-ID: <20081104233122.GM659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="revert-hid-invert-hwheel-mappings-for-some-logitech-mice.patch"
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Dan Nicholson <dbn.lists@gmail.com>

commit 022b7024d4bb1f9a2f30021a2672a0f940ebfa7a upstream.

This reverts commit 740f370dc61dc478d891d7d47660bb3ae39ddb4f.

It turned out to be correct in the first place: a positive value should
be sent when the wheel is moved to the right, and a negative value when
moved to the left. This is the behavior expected by the Xorg evdev
driver. I must have had a remapping somewhere else in my system when
originally testing this. Testing on another system shows that the
unpatched kernel is correct.

Here is a bug report from Mandriva that brought the problem to my
attention:

    https://qa.mandriva.com/show_bug.cgi?id=44309#c19

Signed-off-by: Dan Nicholson <dbn.lists@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/usbhid/hid-quirks.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -247,8 +247,6 @@
 #define USB_DEVICE_ID_LD_MACHINETEST	0x2040
 
 #define USB_VENDOR_ID_LOGITECH		0x046d
-#define USB_DEVICE_ID_LOGITECH_LX3	0xc044
-#define USB_DEVICE_ID_LOGITECH_V150	0xc047
 #define USB_DEVICE_ID_LOGITECH_RECEIVER	0xc101
 #define USB_DEVICE_ID_LOGITECH_HARMONY  0xc110
 #define USB_DEVICE_ID_LOGITECH_HARMONY_2 0xc111
@@ -603,8 +601,6 @@ static const struct hid_blacklist {
 
 	{ USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_ELITE_KBD, HID_QUIRK_LOGITECH_IGNORE_DOUBLED_WHEEL | HID_QUIRK_LOGITECH_EXPANDED_KEYMAP },
 	{ USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_CORDLESS_DESKTOP_LX500, HID_QUIRK_LOGITECH_IGNORE_DOUBLED_WHEEL | HID_QUIRK_LOGITECH_EXPANDED_KEYMAP },
-	{ USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_LX3, HID_QUIRK_INVERT_HWHEEL },
-	{ USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_V150, HID_QUIRK_INVERT_HWHEEL },
 
 	{ USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_NE4K, HID_QUIRK_MICROSOFT_KEYS },
 	{ USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_LK6K, HID_QUIRK_MICROSOFT_KEYS },

-- 
