Return-Path: <linux-kernel-owner+w=401wt.eu-S1755161AbYKLU0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbYKLU0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 15:26:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbYKLU0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 15:26:15 -0500
Received: from kroah.org ([198.145.64.141]:53190 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752960AbYKLU0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 15:26:14 -0500
Subject: patch usb-wusb-annotate-association-types-withe-proper-endianness.patch added to gregkh-2.6 tree
To: harvey.harrison@gmail.com, akpm@linux-foundation.org, david.vrabel@csr.com,
       gregkh@suse.de, greg@kroah.com, inaky.perez-gonzalez@intel.com,
       linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Wed, 12 Nov 2008 12:25:10 -0800
In-Reply-To: <1226039536.11596.5.camel@brick>
Message-ID: <12265215102213@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: USB: wusb: annotate association types withe proper endianness

to my gregkh-2.6 tree.  Its filename is

    usb-wusb-annotate-association-types-withe-proper-endianness.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From harvey.harrison@gmail.com  Wed Nov 12 11:46:58 2008
From: Harvey Harrison <harvey.harrison@gmail.com>
Date: Thu, 06 Nov 2008 22:32:15 -0800
Subject: USB: wusb: annotate association types withe proper endianness
To: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Message-ID: <1226039536.11596.5.camel@brick>


Also a trivial annotation in rh.c for:
drivers/usb/wusbcore/rh.c:366:9: warning: incorrect type in assignment (different base types)
drivers/usb/wusbcore/rh.c:366:9:    expected unsigned short [unsigned] [short] [usertype] <noident>
drivers/usb/wusbcore/rh.c:366:9:    got restricted __le16 [usertype] <noident>
drivers/usb/wusbcore/rh.c:367:9: warning: incorrect type in assignment (different base types)
drivers/usb/wusbcore/rh.c:367:9:    expected unsigned short [unsigned] [short] [usertype] <noident>
drivers/usb/wusbcore/rh.c:367:9:    got restricted __le16 [usertype] <noident>

Association types annotation fixes piles of warnings similar to:
drivers/usb/wusbcore/cbaf.c:238:30: warning: incorrect type in initializer (different base types)
drivers/usb/wusbcore/cbaf.c:238:30:    expected restricted __le16 [usertype] id
drivers/usb/wusbcore/cbaf.c:238:30:    got int
drivers/usb/wusbcore/cbaf.c:238:30: warning: incorrect type in initializer (different base types)
drivers/usb/wusbcore/cbaf.c:238:30:    expected restricted __le16 [usertype] len
drivers/usb/wusbcore/cbaf.c:238:30:    got int

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: David Vrabel <david.vrabel@csr.com>
Cc: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/wusbcore/rh.c       |    2 +-
 include/linux/usb/association.h |   22 +++++++++++-----------
 2 files changed, 12 insertions(+), 12 deletions(-)

--- a/drivers/usb/wusbcore/rh.c
+++ b/drivers/usb/wusbcore/rh.c
@@ -352,7 +352,7 @@ static int wusbhc_rh_get_port_status(str
 				     u32 *_buf, u16 wLength)
 {
 	int result = -EINVAL;
-	u16 *buf = (u16 *) _buf;
+	__le16 *buf = (__le16 *)_buf;
 
 	d_fnstart(1, wusbhc->dev, "(wusbhc %p port_idx %u wLength %u)\n",
 		  wusbhc, port_idx, wLength);
--- a/include/linux/usb/association.h
+++ b/include/linux/usb/association.h
@@ -28,17 +28,17 @@ struct wusb_am_attr {
 };
 
 /* Different fields defined by the spec */
-#define WUSB_AR_AssociationTypeId	{ .id = 0x0000, .len =  2 }
-#define WUSB_AR_AssociationSubTypeId	{ .id = 0x0001, .len =  2 }
-#define WUSB_AR_Length			{ .id = 0x0002, .len =  4 }
-#define WUSB_AR_AssociationStatus	{ .id = 0x0004, .len =  4 }
-#define WUSB_AR_LangID			{ .id = 0x0008, .len =  2 }
-#define WUSB_AR_DeviceFriendlyName	{ .id = 0x000b, .len = 64 } /* max */
-#define WUSB_AR_HostFriendlyName	{ .id = 0x000c, .len = 64 } /* max */
-#define WUSB_AR_CHID			{ .id = 0x1000, .len = 16 }
-#define WUSB_AR_CDID			{ .id = 0x1001, .len = 16 }
-#define WUSB_AR_ConnectionContext	{ .id = 0x1002, .len = 48 }
-#define WUSB_AR_BandGroups		{ .id = 0x1004, .len =  2 }
+#define WUSB_AR_AssociationTypeId	{ .id = cpu_to_le16(0x0000), .len = cpu_to_le16(2) }
+#define WUSB_AR_AssociationSubTypeId	{ .id = cpu_to_le16(0x0001), .len = cpu_to_le16(2) }
+#define WUSB_AR_Length			{ .id = cpu_to_le16(0x0002), .len = cpu_to_le16(4) }
+#define WUSB_AR_AssociationStatus	{ .id = cpu_to_le16(0x0004), .len = cpu_to_le16(4) }
+#define WUSB_AR_LangID			{ .id = cpu_to_le16(0x0008), .len = cpu_to_le16(2) }
+#define WUSB_AR_DeviceFriendlyName	{ .id = cpu_to_le16(0x000b), .len = cpu_to_le16(64) } /* max */
+#define WUSB_AR_HostFriendlyName	{ .id = cpu_to_le16(0x000c), .len = cpu_to_le16(64) } /* max */
+#define WUSB_AR_CHID			{ .id = cpu_to_le16(0x1000), .len = cpu_to_le16(16) }
+#define WUSB_AR_CDID			{ .id = cpu_to_le16(0x1001), .len = cpu_to_le16(16) }
+#define WUSB_AR_ConnectionContext	{ .id = cpu_to_le16(0x1002), .len = cpu_to_le16(48) }
+#define WUSB_AR_BandGroups		{ .id = cpu_to_le16(0x1004), .len = cpu_to_le16(2) }
 
 /* CBAF Control Requests (AMS1.0[T4-1] */
 enum {


Patches currently in gregkh-2.6 which might be from harvey.harrison@gmail.com are

usb/usb-avoid-needless-address-taking-of-function-parameters.patch
usb/usb-wusb-annotate-association-types-withe-proper-endianness.patch
staging/staging-correct-dubious-use-of-x-y.patch
