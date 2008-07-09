Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbYGJAGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbYGJAGh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 20:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbYGJAG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 20:06:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49025 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbYGJAG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 20:06:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 1/8] PM: Add new PM_EVENT codes for runtime power transitions
Date: Thu, 10 Jul 2008 01:55:33 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
References: <200807100152.17755.rjw@sisk.pl>
In-Reply-To: <200807100152.17755.rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807100155.34153.rjw@sisk.pl>
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>
Subject: PM: Add new PM_EVENT codes for runtime power transitions

This patch (as1112) adds some new PM_EVENT_* codes for use by kernel
subsystems.  They describe runtime power-state transitions of the sort
already implemented by the USB subsystem.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---

 include/linux/pm.h |   39 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 36 insertions(+), 3 deletions(-)

Index: linux-next/include/linux/pm.h
===================================================================
--- linux-next.orig/include/linux/pm.h
+++ linux-next/include/linux/pm.h
@@ -245,6 +245,21 @@ struct pm_ext_ops {
  * RECOVER	Creation of a hibernation image or restoration of the main
  *		memory contents from a hibernation image has failed, call
  *		->thaw() and ->complete() for all devices.
+ *
+ * The following PM_EVENT_ messages are defined for internal use by
+ * kernel subsystems.  They are never issued by the PM core.
+ *
+ * USER_SUSPEND		Manual selective suspend was issued by userspace.
+ *
+ * USER_RESUME		Manual selective resume was issued by userspace.
+ *
+ * REMOTE_WAKEUP	Remote-wakeup request was received from the device.
+ *
+ * AUTO_SUSPEND		Automatic (device idle) runtime suspend was
+ *			initiated by the subsystem.
+ *
+ * AUTO_RESUME		Automatic (device needed) runtime resume was
+ *			requested by a driver.
  */
 
 #define PM_EVENT_ON		0x0000
@@ -256,9 +271,18 @@ struct pm_ext_ops {
 #define PM_EVENT_THAW		0x0020
 #define PM_EVENT_RESTORE	0x0040
 #define PM_EVENT_RECOVER	0x0080
+#define PM_EVENT_USER		0x0100
+#define PM_EVENT_REMOTE		0x0200
+#define PM_EVENT_AUTO		0x0400
+
+#define PM_EVENT_SLEEP		(PM_EVENT_SUSPEND | PM_EVENT_HIBERNATE)
+#define PM_EVENT_USER_SUSPEND	(PM_EVENT_USER | PM_EVENT_SUSPEND)
+#define PM_EVENT_USER_RESUME	(PM_EVENT_USER | PM_EVENT_RESUME)
+#define PM_EVENT_REMOTE_WAKEUP	(PM_EVENT_REMOTE | PM_EVENT_RESUME)
+#define PM_EVENT_AUTO_SUSPEND	(PM_EVENT_AUTO | PM_EVENT_SUSPEND)
+#define PM_EVENT_AUTO_RESUME	(PM_EVENT_AUTO | PM_EVENT_RESUME)
 
-#define PM_EVENT_SLEEP	(PM_EVENT_SUSPEND | PM_EVENT_HIBERNATE)
-
+#define PMSG_ON		((struct pm_message){ .event = PM_EVENT_ON, })
 #define PMSG_FREEZE	((struct pm_message){ .event = PM_EVENT_FREEZE, })
 #define PMSG_QUIESCE	((struct pm_message){ .event = PM_EVENT_QUIESCE, })
 #define PMSG_SUSPEND	((struct pm_message){ .event = PM_EVENT_SUSPEND, })
@@ -267,7 +291,16 @@ struct pm_ext_ops {
 #define PMSG_THAW	((struct pm_message){ .event = PM_EVENT_THAW, })
 #define PMSG_RESTORE	((struct pm_message){ .event = PM_EVENT_RESTORE, })
 #define PMSG_RECOVER	((struct pm_message){ .event = PM_EVENT_RECOVER, })
-#define PMSG_ON		((struct pm_message){ .event = PM_EVENT_ON, })
+#define PMSG_USER_SUSPEND	((struct pm_messge) \
+					{ .event = PM_EVENT_USER_SUSPEND, })
+#define PMSG_USER_RESUME	((struct pm_messge) \
+					{ .event = PM_EVENT_USER_RESUME, })
+#define PMSG_REMOTE_RESUME	((struct pm_messge) \
+					{ .event = PM_EVENT_REMOTE_RESUME, })
+#define PMSG_AUTO_SUSPEND	((struct pm_messge) \
+					{ .event = PM_EVENT_AUTO_SUSPEND, })
+#define PMSG_AUTO_RESUME		((struct pm_messge) \
+					{ .event = PM_EVENT_AUTO_RESUME, })
 
 /**
  * Device power management states

