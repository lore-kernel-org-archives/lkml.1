Return-Path: <linux-kernel-owner+w=401wt.eu-S1753734AbZHBUnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734AbZHBUnn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 16:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbZHBUnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 16:43:42 -0400
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:58574 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753622AbZHBUnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 16:43:42 -0400
X-Greylist: delayed 1528 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Aug 2009 16:43:41 EDT
Date: Sun, 2 Aug 2009 22:18:12 +0200
From: Henning Glawe <glaweh@debian.org>
To: linux-input@vger.kernel.org
Cc: jkosina@suse.cz, linux-kernel@vger.kernel.org
Subject: [PATCH] Ignore Philips IEEE802.15.4 RF Dongle in hid-core
Message-ID: <20090802201812.GA5631@ruprecht.physik.fu-berlin.de>
Mail-Followup-To: linux-input@vger.kernel.org, jkosina@suse.cz,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Originating-IP: 87.160.220.90
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This usb device claims to be of HID class, but is in fact a 802.15.4
lowpan transceiver, therefore the generic HID driver cannot operate this
device. A separate driver for this device will be written for this using
the new 802.15.4 stack.

 Signed-off-by: Henning Glawe <glaweh@debian.org>
---
 drivers/hid/hid-core.c |    1 +
 drivers/hid/hid-ids.h  |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 8551693..7755949 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1618,6 +1618,7 @@ static const struct hid_device_id hid_ignore_list[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PANJIT, 0x0002) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PANJIT, 0x0003) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PANJIT, 0x0004) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_PHILIPS, USB_DEVICE_ID_PHILIPS_IEEE802154_DONGLE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_POWERCOM, USB_DEVICE_ID_POWERCOM_UPS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SOUNDGRAPH, USB_DEVICE_ID_SOUNDGRAPH_IMON_LCD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SOUNDGRAPH, USB_DEVICE_ID_SOUNDGRAPH_IMON_LCD2) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 4d5ee2b..7f59854 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -359,6 +359,9 @@
 #define USB_VENDOR_ID_PETALYNX		0x18b1
 #define USB_DEVICE_ID_PETALYNX_MAXTER_REMOTE	0x0037
 
+#define USB_VENDOR_ID_PHILIPS       0x0471
+#define USB_DEVICE_ID_PHILIPS_IEEE802154_DONGLE 0x0617
+
 #define USB_VENDOR_ID_PLAYDOTCOM	0x0b43
 #define USB_DEVICE_ID_PLAYDOTCOM_EMS_USBII	0x0003
 
-- 
1.5.6.5



-- 
c u
henning
