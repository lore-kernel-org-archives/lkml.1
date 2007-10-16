Return-Path: <linux-kernel-owner+w=401wt.eu-S1765483AbXJPAbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765483AbXJPAbP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 20:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756122AbXJPAaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 20:30:35 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:32384 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764787AbXJPAad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 20:30:33 -0400
Date: Mon, 15 Oct 2007 17:30:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>,
       lud <linux-usb-devel@lists.sourceforge.net>
Cc: torvalds <torvalds@linux-foundation.org>, akpm <akpm@linux-foundation.org>,
       gregkh <greg@kroah.com>, inaky@linux.intel.com
Subject: [PATCH 3/4] docbook: fix usb content
Message-Id: <20071015173002.09156c6a.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix USB docbook warnings.

Warning(linux-2.6.23-git8//include/linux/usb/gadget.h:487): No description found for parameter 'g'
Warning(linux-2.6.23-git8//include/linux/usb/gadget.h:506): No description found for parameter 'g'

Warning(linux-2.6.23-git8//drivers/usb/core/hub.c:1416): No description found for parameter 'usb_dev'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/usb/core/hub.c     |    6 +++++-
 include/linux/usb/gadget.h |    4 ++--
 2 files changed, 7 insertions(+), 3 deletions(-)

--- linux-2.6.23-git8.orig/include/linux/usb/gadget.h
+++ linux-2.6.23-git8/include/linux/usb/gadget.h
@@ -481,7 +481,7 @@ static inline void *get_gadget_data (str
 
 /**
  * gadget_is_dualspeed - return true iff the hardware handles high speed
- * @gadget: controller that might support both high and full speeds
+ * @g: controller that might support both high and full speeds
  */
 static inline int gadget_is_dualspeed(struct usb_gadget *g)
 {
@@ -497,7 +497,7 @@ static inline int gadget_is_dualspeed(st
 
 /**
  * gadget_is_otg - return true iff the hardware is OTG-ready
- * @gadget: controller that might have a Mini-AB connector
+ * @g: controller that might have a Mini-AB connector
  *
  * This is a runtime test, since kernels with a USB-OTG stack sometimes
  * run on boards which only have a Mini-B (or Mini-A) connector.
--- linux-2.6.23-git8.orig/drivers/usb/core/hub.c
+++ linux-2.6.23-git8/drivers/usb/core/hub.c
@@ -1407,7 +1407,11 @@ fail:
 
 
 /**
- * Similar to usb_disconnect()
+ * usb_deauthorize_device - deauthorize a device (usbcore-internal)
+ * @usb_dev: USB device
+ *
+ * Move the USB device to a very basic state where interfaces are disabled
+ * and the device is in fact unconfigured and unusable.
  *
  * We share a lock (that we have) with device_del(), so we need to
  * defer its call.
