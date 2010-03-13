Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965290Ab0CMBfs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:35:48 -0500
Received: from kroah.org ([198.145.64.141]:60535 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934804Ab0CMATg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:19:36 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:05 2010
Message-Id: <20100313001505.780277390@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:11:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jiri Kosina <jkosina@suse.cz>
Subject: [patch 007/123] HID: remove TENX iBuddy from blacklist
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Jiri Kosina <jkosina@suse.cz>

commit 4bb9508bbbb06f10bc3e249dd34375b4a4d6bfc0 upstream.

There were multiple reports which indicate that vendor messed up horribly
and the same VID/PID combination is used for completely different devices,
some of them requiring the blacklist entry and other not.

Remove the blacklist entry for this combination of VID/PID completely, and let
the user decide and unbind the driver via sysfs eventually, if needed. Proper
fix would be fixing the vendor.

http://lkml.org/lkml/2009/2/10/434
http://bugzilla.kernel.org/show_bug.cgi?id=13411

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/hid-core.c |    2 --
 drivers/hid/hid-ids.h  |    4 ----
 2 files changed, 6 deletions(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1661,8 +1661,6 @@ static const struct hid_device_id hid_ig
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PANJIT, 0x0004) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PHILIPS, USB_DEVICE_ID_PHILIPS_IEEE802154_DONGLE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_POWERCOM, USB_DEVICE_ID_POWERCOM_UPS) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_TENX, USB_DEVICE_ID_TENX_IBUDDY1) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_TENX, USB_DEVICE_ID_TENX_IBUDDY2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_VERNIER, USB_DEVICE_ID_VERNIER_LABPRO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_VERNIER, USB_DEVICE_ID_VERNIER_GOTEMP) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_VERNIER, USB_DEVICE_ID_VERNIER_SKIP) },
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -402,10 +402,6 @@
 #define USB_VENDOR_ID_SUNPLUS		0x04fc
 #define USB_DEVICE_ID_SUNPLUS_WDESKTOP	0x05d8
 
-#define USB_VENDOR_ID_TENX		0x1130
-#define USB_DEVICE_ID_TENX_IBUDDY1	0x0001
-#define USB_DEVICE_ID_TENX_IBUDDY2	0x0002
-
 #define USB_VENDOR_ID_THRUSTMASTER	0x044f
 
 #define USB_VENDOR_ID_TOPMAX		0x0663


