Return-Path: <linux-kernel-owner+w=401wt.eu-S1762730AbZBNBQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762730AbZBNBQj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:16:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761628AbZBNBCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:02:11 -0500
Received: from kroah.org ([198.145.64.141]:39937 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756089AbZBNBCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:02:03 -0500
Date: Fri, 13 Feb 2009 16:59:24 -0800
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
       alan@lxorguk.ukuu.org.uk, Jiri Kosina <jkosina@suse.cz>,
       Jan Scholz <Scholz@fias.uni-frankfurt.de>,
       Torsten Rausche <torsten@rausche.net>
Subject: [patch 41/47] bluetooth hid: enable quirk handling for Apple
	Wireless Keyboards in 2.6.27
Message-ID: <20090214005924.GP11282@kroah.com>
References: <20090214005130.617401075@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="bluetooth-hid-enable-quirk-handling-for-apple-wireless-keyboards-in-2.6.27.patch"
In-Reply-To: <20090214005726.GA11282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Torsten Rausche <torsten@rausche.net>

This patch is basically a backport of
commit ee8a1a0a1a5817accd03ced7e7ffde3a4430f485 upstream
which was made after the big HID overhaul in 2.6.28.

Kernel 2.6.27 fails to handle quirks for the aluminum Apple Wireless
Keyboard because it is handled as USB device and not as Bluetooth
device. This patch expands 'hidp_blacklist' to make the kernel handle
the keyboard in the same way as the Apple wireless Mighty Mouse (also a
Bluetooth device).

Signed-off-by: Torsten Rausche <torsten@rausche.net>
Cc: Jan Scholz <Scholz@fias.uni-frankfurt.de>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
---
 net/bluetooth/hidp/core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -684,6 +684,10 @@ static const struct {
 } hidp_blacklist[] = {
 	/* Apple wireless Mighty Mouse */
 	{ 0x05ac, 0x030c, HID_QUIRK_MIGHTYMOUSE | HID_QUIRK_INVERT_HWHEEL },
+	/* Apple Wireless Keyboard */
+	{ 0x05ac, 0x022c, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN },
+	{ 0x05ac, 0x022d, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_APPLE_ISO_KEYBOARD },
+	{ 0x05ac, 0x022e, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN },
 
 	{ }	/* Terminating entry */
 };

