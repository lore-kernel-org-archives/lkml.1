Return-Path: <linux-kernel-owner+w=401wt.eu-S1756074AbYKGGcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbYKGGcd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 01:32:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbYKGGcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 01:32:21 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:18856 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbYKGGcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 01:32:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=YjaBxC6SXLowd7NqdLit+6CvLlF2Nr3P7PtJn7uRs/fA2399UpVi3NuA4vZOdbylUy
         ffE8AmZ/4xPBeyL8SlAeFVm6ROxBzT5aw/5oKQf9g34csUr0qRqCoAU5hmBWBgY0kuYm
         bW9Jo4ysNG/RY3lg+cwOP3gbVJReNJVMcuCo0=
Subject: [PATCH] wusb: annotate association types withe proper endianness
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 06 Nov 2008 22:32:15 -0800
Message-Id: <1226039536.11596.5.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 drivers/usb/wusbcore/rh.c       |    2 +-
 include/linux/usb/association.h |   22 +++++++++++-----------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/wusbcore/rh.c b/drivers/usb/wusbcore/rh.c
index 1c73319..380dabf 100644
--- a/drivers/usb/wusbcore/rh.c
+++ b/drivers/usb/wusbcore/rh.c
@@ -356,7 +356,7 @@ static int wusbhc_rh_get_port_status(struct wusbhc *wusbhc, u16 port_idx,
 				     u32 *_buf, u16 wLength)
 {
 	int result = -EINVAL;
-	u16 *buf = (u16 *) _buf;
+	__le16 *buf = (__le16 *)_buf;
 
 	d_fnstart(1, wusbhc->dev, "(wusbhc %p port_idx %u wLength %u)\n",
 		  wusbhc, port_idx, wLength);
diff --git a/include/linux/usb/association.h b/include/linux/usb/association.h
index 07c5e3c..0a4a18b 100644
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
-- 
1.6.0.3.756.gb776d



