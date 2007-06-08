Return-Path: <linux-kernel-owner+w=401wt.eu-S938692AbXFHHjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938692AbXFHHjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967875AbXFHHYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:24:08 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:55142 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966956AbXFHHYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:24:05 -0400
Message-Id: <20070608072157.812376000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:21:42 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Daniel Drake <dsd@gentoo.org>, Clemens Ladisch <clemens@ladisch.de>,
       Jaroslav Kysela <perex@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 15/54] ALSA: usb-audio: explicitly match Logitech QuickCam
Content-Disposition: inline; filename=alsa-usb-audio-explicitly-match-logitech-quickcam.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Daniel Drake <dsd@gentoo.org>

Commit 93c8bf45e083b89dffe3a708363c15c1b220c723 modified the USB device
matching behaviour to ignore interface class matches if the device class
is vendor-specific.
This patch adds explicit ID matches for Logitech QuickCam devices, which
have a vendor specific device class (but standards-compliant audio
interfaces).
This fixes a 2.6.20 regression where the audio component of these
devices was no longer usable.
http://bugs.gentoo.org/show_bug.cgi?id=175715
https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.20/+bug/93822
https://bugtrack.alsa-project.org/alsa-bug/view.php?id=3040
Based on a patch from sergiom

Signed-off-by: Daniel Drake <dsd@gentoo.org>
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Jaroslav Kysela <perex@suse.cz>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
X-Git-Url: http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Ftorvalds%2Flinux-2.6.git;a=commitdiff_plain;h=a91214589e6527b18f52bc0b31253f9dfb4665e6

 sound/usb/usbquirks.h |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- linux-2.6.21.4.orig/sound/usb/usbquirks.h
+++ linux-2.6.21.4/sound/usb/usbquirks.h
@@ -40,6 +40,29 @@
 	.bInterfaceClass = USB_CLASS_VENDOR_SPEC
 
 /*
+ * Logitech QuickCam: bDeviceClass is vendor-specific, so generic interface
+ * class matches do not take effect without an explicit ID match.
+ */
+{
+	.match_flags = USB_DEVICE_ID_MATCH_DEVICE |
+		       USB_DEVICE_ID_MATCH_INT_CLASS |
+		       USB_DEVICE_ID_MATCH_INT_SUBCLASS,
+	.idVendor = 0x046d,
+	.idProduct = 0x08f0,
+	.bInterfaceClass = USB_CLASS_AUDIO,
+	.bInterfaceSubClass = USB_SUBCLASS_AUDIO_CONTROL
+},
+{
+	.match_flags = USB_DEVICE_ID_MATCH_DEVICE |
+		       USB_DEVICE_ID_MATCH_INT_CLASS |
+		       USB_DEVICE_ID_MATCH_INT_SUBCLASS,
+	.idVendor = 0x046d,
+	.idProduct = 0x08f6,
+	.bInterfaceClass = USB_CLASS_AUDIO,
+	.bInterfaceSubClass = USB_SUBCLASS_AUDIO_CONTROL
+},
+
+/*
  * Yamaha devices
  */
 

-- 
