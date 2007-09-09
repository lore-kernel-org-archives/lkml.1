Return-Path: <linux-kernel-owner+w=401wt.eu-S1760461AbXIIVMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760461AbXIIVMs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 17:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759967AbXIIVLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 17:11:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57959 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759456AbXIIVLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 17:11:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH -mm 5/5] Hibernation: Introduce exportable suspend ioctls header (rev. 2)
Date: Sun, 9 Sep 2007 23:18:50 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Johannes Berg <johannes@sipsolutions.net>
References: <200709092257.16085.rjw@sisk.pl>
In-Reply-To: <200709092257.16085.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709092318.51374.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Move the definitions of hibernation ioctls to a separate header file in
include/linux, which can be exported to the user space.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/power/userland-swsusp.txt |   10 +++++-----
 include/linux/Kbuild                    |    1 +
 include/linux/suspend_ioctls.h          |   32 ++++++++++++++++++++++++++++++++
 kernel/power/power.h                    |   29 +----------------------------
 4 files changed, 39 insertions(+), 33 deletions(-)

Index: linux-2.6.23-rc5/include/linux/suspend_ioctls.h
===================================================================
--- /dev/null
+++ linux-2.6.23-rc5/include/linux/suspend_ioctls.h
@@ -0,0 +1,32 @@
+#ifndef _LINUX_SUSPEND_IOCTLS_H
+#define _LINUX_SUSPEND_IOCTLS_H
+
+/*
+ * This structure is used to pass the values needed for the identification
+ * of the resume swap area from a user space to the kernel via the
+ * SNAPSHOT_SET_SWAP_AREA ioctl
+ */
+struct resume_swap_area {
+	loff_t offset;
+	u_int32_t dev;
+} __attribute__((packed));
+
+#define SNAPSHOT_IOC_MAGIC	'3'
+#define SNAPSHOT_FREEZE			_IO(SNAPSHOT_IOC_MAGIC, 1)
+#define SNAPSHOT_UNFREEZE		_IO(SNAPSHOT_IOC_MAGIC, 2)
+#define SNAPSHOT_ATOMIC_RESTORE		_IO(SNAPSHOT_IOC_MAGIC, 4)
+#define SNAPSHOT_FREE			_IO(SNAPSHOT_IOC_MAGIC, 5)
+#define SNAPSHOT_FREE_SWAP_PAGES	_IO(SNAPSHOT_IOC_MAGIC, 9)
+#define SNAPSHOT_S2RAM			_IO(SNAPSHOT_IOC_MAGIC, 11)
+#define SNAPSHOT_SET_SWAP_AREA		_IOW(SNAPSHOT_IOC_MAGIC, 13, \
+							struct resume_swap_area)
+#define SNAPSHOT_GET_IMAGE_SIZE		_IOR(SNAPSHOT_IOC_MAGIC, 14, loff_t)
+#define SNAPSHOT_PLATFORM_SUPPORT	_IO(SNAPSHOT_IOC_MAGIC, 15)
+#define SNAPSHOT_POWER_OFF		_IO(SNAPSHOT_IOC_MAGIC, 16)
+#define SNAPSHOT_CREATE_IMAGE		_IOW(SNAPSHOT_IOC_MAGIC, 17, int)
+#define SNAPSHOT_PREF_IMAGE_SIZE	_IO(SNAPSHOT_IOC_MAGIC, 18)
+#define SNAPSHOT_AVAIL_SWAP_SIZE	_IOR(SNAPSHOT_IOC_MAGIC, 19, loff_t)
+#define SNAPSHOT_ALLOC_SWAP_PAGE	_IOR(SNAPSHOT_IOC_MAGIC, 20, loff_t)
+#define SNAPSHOT_IOC_MAXNR	20
+
+#endif /* _LINUX_SUSPEND_IOCTLS_H */
Index: linux-2.6.23-rc5/kernel/power/power.h
===================================================================
--- linux-2.6.23-rc5.orig/kernel/power/power.h
+++ linux-2.6.23-rc5/kernel/power/power.h
@@ -1,4 +1,5 @@
 #include <linux/suspend.h>
+#include <linux/suspend_ioctls.h>
 #include <linux/utsname.h>
 
 struct swsusp_info {
@@ -136,34 +137,6 @@ extern int snapshot_write_next(struct sn
 extern void snapshot_write_finalize(struct snapshot_handle *handle);
 extern int snapshot_image_loaded(struct snapshot_handle *handle);
 
-/*
- * This structure is used to pass the values needed for the identification
- * of the resume swap area from a user space to the kernel via the
- * SNAPSHOT_SET_SWAP_AREA ioctl
- */
-struct resume_swap_area {
-	loff_t offset;
-	u_int32_t dev;
-} __attribute__((packed));
-
-#define SNAPSHOT_IOC_MAGIC	'3'
-#define SNAPSHOT_FREEZE			_IO(SNAPSHOT_IOC_MAGIC, 1)
-#define SNAPSHOT_UNFREEZE		_IO(SNAPSHOT_IOC_MAGIC, 2)
-#define SNAPSHOT_ATOMIC_RESTORE		_IO(SNAPSHOT_IOC_MAGIC, 4)
-#define SNAPSHOT_FREE			_IO(SNAPSHOT_IOC_MAGIC, 5)
-#define SNAPSHOT_FREE_SWAP_PAGES	_IO(SNAPSHOT_IOC_MAGIC, 9)
-#define SNAPSHOT_S2RAM			_IO(SNAPSHOT_IOC_MAGIC, 11)
-#define SNAPSHOT_SET_SWAP_AREA		_IOW(SNAPSHOT_IOC_MAGIC, 13, \
-							struct resume_swap_area)
-#define SNAPSHOT_GET_IMAGE_SIZE		_IOR(SNAPSHOT_IOC_MAGIC, 14, loff_t)
-#define SNAPSHOT_PLATFORM_SUPPORT	_IO(SNAPSHOT_IOC_MAGIC, 15)
-#define SNAPSHOT_POWER_OFF		_IO(SNAPSHOT_IOC_MAGIC, 16)
-#define SNAPSHOT_CREATE_IMAGE		_IOW(SNAPSHOT_IOC_MAGIC, 17, int)
-#define SNAPSHOT_PREF_IMAGE_SIZE	_IO(SNAPSHOT_IOC_MAGIC, 18)
-#define SNAPSHOT_AVAIL_SWAP_SIZE	_IOR(SNAPSHOT_IOC_MAGIC, 19, loff_t)
-#define SNAPSHOT_ALLOC_SWAP_PAGE	_IOR(SNAPSHOT_IOC_MAGIC, 20, loff_t)
-#define SNAPSHOT_IOC_MAXNR	20
-
 /* If unset, the snapshot device cannot be open. */
 extern atomic_t snapshot_device_available;
 
Index: linux-2.6.23-rc5/Documentation/power/userland-swsusp.txt
===================================================================
--- linux-2.6.23-rc5.orig/Documentation/power/userland-swsusp.txt
+++ linux-2.6.23-rc5/Documentation/power/userland-swsusp.txt
@@ -14,7 +14,7 @@ are going to develop your own suspend/re
 
 The interface consists of a character device providing the open(),
 release(), read(), and write() operations as well as several ioctl()
-commands defined in kernel/power/power.h.  The major and minor
+commands defined in include/linux/suspend_ioctls.h .  The major and minor
 numbers of the device are, respectively, 10 and 231, and they can
 be read from /sys/class/misc/snapshot/dev.
 
@@ -70,10 +70,10 @@ SNAPSHOT_FREE_SWAP_PAGES - free all swap
 SNAPSHOT_SET_SWAP_AREA - set the resume partition and the offset (in <PAGE_SIZE>
 	units) from the beginning of the partition at which the swap header is
 	located (the last ioctl() argument should point to a struct
-	resume_swap_area, as defined in kernel/power/power.h, containing the
-	resume device specification and the offset); for swap partitions the
-	offset is always 0, but it is different from zero for swap files (see
-	Documentation/swsusp-and-swap-files.txt for details).
+	resume_swap_area, as defined in kernel/power/suspend_ioctls.h,
+	containing the resume device specification and the offset); for swap
+	partitions the offset is always 0, but it is different from zero for
+	swap files (see Documentation/swsusp-and-swap-files.txt for details).
 
 SNAPSHOT_PLATFORM_SUPPORT - enable/disable the hibernation platform support,
 	depending on the argument value (enable, if the argument is nonzero)
Index: linux-2.6.23-rc5/include/linux/Kbuild
===================================================================
--- linux-2.6.23-rc5.orig/include/linux/Kbuild
+++ linux-2.6.23-rc5/include/linux/Kbuild
@@ -144,6 +144,7 @@ header-y += snmp.h
 header-y += sockios.h
 header-y += som.h
 header-y += sound.h
+header-y += suspend_ioctls.h
 header-y += taskstats.h
 header-y += telephony.h
 header-y += termios.h
