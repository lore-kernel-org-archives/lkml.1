Return-Path: <linux-kernel-owner+w=401wt.eu-S1757623AbZLDWsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623AbZLDWsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 17:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757600AbZLDWsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 17:48:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60346 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444AbZLDWsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 17:48:33 -0500
Message-ID: <4B199238.3020805@gmail.com>
Date: Fri, 04 Dec 2009 23:50:32 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: gregkh@suse.de, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 30/31] Constify struct usb_mon_operations for 2.6.32 v1
References: <4B198670.2000406@gmail.com>
In-Reply-To: <4B198670.2000406@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>

Constify struct usb_mon_operations.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 drivers/usb/core/hcd.c     |    4 ++--
 drivers/usb/core/hcd.h     |   10 +++++-----
 drivers/usb/mon/mon_main.c |    2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 34de475..cfcb4fb 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -2216,7 +2216,7 @@ EXPORT_SYMBOL_GPL(usb_hcd_platform_shutdown);
 
 #if defined(CONFIG_USB_MON) || defined(CONFIG_USB_MON_MODULE)
 
-struct usb_mon_operations *mon_ops;
+const struct usb_mon_operations *mon_ops;
 
 /*
  * The registration is unlocked.
@@ -2226,7 +2226,7 @@ struct usb_mon_operations *mon_ops;
  * symbols from usbcore, usbcore gets referenced and cannot be unloaded first.
  */
  
-int usb_mon_register (struct usb_mon_operations *ops)
+int usb_mon_register (const struct usb_mon_operations *ops)
 {
 
 	if (mon_ops)
diff --git a/drivers/usb/core/hcd.h b/drivers/usb/core/hcd.h
index 79782a1..04bf5ea 100644
--- a/drivers/usb/core/hcd.h
+++ b/drivers/usb/core/hcd.h
@@ -486,13 +486,13 @@ static inline void usbfs_cleanup(void) { }
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
@@ -514,7 +514,7 @@ static inline void usbmon_urb_complete(struct usb_bus *bus, struct urb *urb,
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

