Return-Path: <linux-kernel-owner+w=401wt.eu-S1755251AbZLMX7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbZLMX7V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 18:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbZLMX7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:59:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34753 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755264AbZLMX64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:58:56 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, gregkh@suse.de,
       stern@rowland.harvard.edu, dbrownell@users.sourceforge.net,
       torvalds@linux-foundation.org
Subject: [PATCH 1/1] Constify struct usb_mon_operations for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 01:00:35 +0100
Message-Id: <6f4e0550c00629ec465fe27792868717f2375423.1260663005.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260663005.git.re.emese@gmail.com>
References: <cover.1260663005.git.re.emese@gmail.com>
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 drivers/usb/core/hcd.c     |    4 ++--
 drivers/usb/core/hcd.h     |   10 +++++-----
 drivers/usb/mon/mon_main.c |    2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 6dac3b8..e160b54 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -2246,7 +2246,7 @@ EXPORT_SYMBOL_GPL(usb_hcd_platform_shutdown);
 
 #if defined(CONFIG_USB_MON) || defined(CONFIG_USB_MON_MODULE)
 
-struct usb_mon_operations *mon_ops;
+const struct usb_mon_operations *mon_ops;
 
 /*
  * The registration is unlocked.
@@ -2256,7 +2256,7 @@ struct usb_mon_operations *mon_ops;
  * symbols from usbcore, usbcore gets referenced and cannot be unloaded first.
  */
  
-int usb_mon_register (struct usb_mon_operations *ops)
+int usb_mon_register (const struct usb_mon_operations *ops)
 {
 
 	if (mon_ops)
diff --git a/drivers/usb/core/hcd.h b/drivers/usb/core/hcd.h
index d8b43ae..17521a6 100644
--- a/drivers/usb/core/hcd.h
+++ b/drivers/usb/core/hcd.h
@@ -501,13 +501,13 @@ static inline void usbfs_cleanup(void) { }
 #if defined(CONFIG_USB_MON) || defined(CONFIG_USB_MON_MODULE)
 
 struct usb_mon_operations {
-	void (*urb_submit)(struct usb_bus *bus, struct urb *urb);
-	void (*urb_submit_error)(struct usb_bus *bus, struct urb *urb, int err);
-	void (*urb_complete)(struct usb_bus *bus, struct urb *urb, int status);
+	void (* const urb_submit)(struct usb_bus *bus, struct urb *urb);
+	void (* const urb_submit_error)(struct usb_bus *bus, struct urb *urb, int err);
+	void (* const urb_complete)(struct usb_bus *bus, struct urb *urb, int status);
 	/* void (*urb_unlink)(struct usb_bus *bus, struct urb *urb); */
 };
 
-extern struct usb_mon_operations *mon_ops;
+extern const struct usb_mon_operations *mon_ops;
 
 static inline void usbmon_urb_submit(struct usb_bus *bus, struct urb *urb)
 {
@@ -529,7 +529,7 @@ static inline void usbmon_urb_complete(struct usb_bus *bus, struct urb *urb,
 		(*mon_ops->urb_complete)(bus, urb, status);
 }
 
-int usb_mon_register(struct usb_mon_operations *ops);
+int usb_mon_register(const struct usb_mon_operations *ops);
 void usb_mon_deregister(void);
 
 #else
diff --git a/drivers/usb/mon/mon_main.c b/drivers/usb/mon/mon_main.c
index e0c2db3..bd8cb66 100644
--- a/drivers/usb/mon/mon_main.c
+++ b/drivers/usb/mon/mon_main.c
@@ -238,7 +238,7 @@ static struct notifier_block mon_nb = {
 /*
  * Ops
  */
-static struct usb_mon_operations mon_ops_0 = {
+static const struct usb_mon_operations mon_ops_0 = {
 	.urb_submit =	mon_submit,
 	.urb_submit_error = mon_submit_error,
 	.urb_complete =	mon_complete,
-- 
1.6.5.3

