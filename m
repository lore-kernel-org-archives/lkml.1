Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbYCMSwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbYCMSwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 14:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754033AbYCMSv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 14:51:56 -0400
Received: from lx1.pxnet.com ([195.227.45.3]:48723 "EHLO lx1.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754027AbYCMSvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 14:51:55 -0400
From: Tilman Schmidt <tilman@imap.cc>
To: Greg KH <greg@kroah.com>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
CC: Roland Kletzing <devzero@web.de>
Subject: [PATCH] usb.h: reduce syslog clutter [v3]
Message-Id: <20080313185142.459F411005B@xenon.ts.pxnet.com>
Date: Thu, 13 Mar 2008 19:51:42 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The the err() / info() / warn() macros in usb.h inserted __FILE__ at
the beginning of the message, which expands to the complete pathname
of the source file within the kernel tree, frequently taking up half
of an 80 character screen line before the actual message even begins.
Use the module name instead.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
---

The previous version of this patch was posted and discussed in March
2006, and while displaying module names instead of file pathnames in
messages to users was generally approved of, the patch itself was
rejected on the grounds that these macros should rather be gotten
rid of entirely, and their use replaced by dev_err() / dev_info() /
dev_warn() everywhere.

Two years later, there's not much progress on this front, and on a
typical desktop system, dmesg still shows a substantial number of
full source path names from these macros. I would therefore like to
re-propose this patch as a short-term fix until the bigger goal can
be achieved.

Tested on x86 with modular and non-modular kernel builds.

 include/linux/usb.h |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/include/linux/usb.h b/include/linux/usb.h
index 583e048..394cb5f 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -1661,13 +1661,12 @@ extern void usb_unregister_notify(struct notifier_block *nb);
 #define dbg(format, arg...) do {} while (0)
 #endif
 
-#define err(format, arg...) printk(KERN_ERR "%s: " format "\n" , \
-	__FILE__ , ## arg)
-#define info(format, arg...) printk(KERN_INFO "%s: " format "\n" , \
-	__FILE__ , ## arg)
-#define warn(format, arg...) printk(KERN_WARNING "%s: " format "\n" , \
-	__FILE__ , ## arg)
-
+#define err(format, arg...) printk(KERN_ERR KBUILD_MODNAME ": " \
+	format "\n" , ## arg)
+#define info(format, arg...) printk(KERN_INFO KBUILD_MODNAME ": " \
+	format "\n" , ## arg)
+#define warn(format, arg...) printk(KERN_WARNING KBUILD_MODNAME ": " \
+	format "\n" , ## arg)
 
 #endif  /* __KERNEL__ */
 
-- 
1.5.4.7.gd8534-dirty

