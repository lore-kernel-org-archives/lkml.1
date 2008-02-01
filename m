Return-Path: <linux-kernel-owner+w=401wt.eu-S933231AbYBAEpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933231AbYBAEpO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 23:45:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760225AbYBAEmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 23:42:06 -0500
Received: from mga05.intel.com ([192.55.52.89]:61252 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754507AbYBAEly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 23:41:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,288,1199692800"; 
   d="scan'208";a="511516545"
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>
Subject: [PATCH 03/37] Hibernation: Mark SNAPSHOT_SET_SWAP_FILE ioctl as deprecated (rev. 2)
Date: Thu, 31 Jan 2008 23:36:34 -0500
Message-Id: <dbb027badbbd8ae51e914eca50774755d207826a.1201840183.git.len.brown@intel.com>
X-Mailer: git-send-email 1.5.4.rc5.16.gc0279
In-Reply-To: <1201840628-23136-1-git-send-email-lenb@kernel.org>
References: <1201840628-23136-1-git-send-email-lenb@kernel.org>
In-Reply-To: <edae89f5d1eb1fbe1cab74333db5a8e29776900e.1201840183.git.len.brown@intel.com>
References: <edae89f5d1eb1fbe1cab74333db5a8e29776900e.1201840183.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Mark the SNAPSHOT_SET_SWAP_FILE ioctl belonging to the hibernation userland
interface as deprecated.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 Documentation/power/userland-swsusp.txt |   14 ++------------
 kernel/power/power.h                    |    1 -
 kernel/power/user.c                     |    9 +++++----
 3 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/Documentation/power/userland-swsusp.txt b/Documentation/power/userland-swsusp.txt
index 381e9c0..0785500 100644
--- a/Documentation/power/userland-swsusp.txt
+++ b/Documentation/power/userland-swsusp.txt
@@ -67,23 +67,13 @@ SNAPSHOT_GET_SWAP_PAGE - allocate a swap page from the resume partition
 SNAPSHOT_FREE_SWAP_PAGES - free all swap pages allocated with
 	SNAPSHOT_GET_SWAP_PAGE
 
-SNAPSHOT_SET_SWAP_FILE - set the resume partition (the last ioctl() argument
-	should specify the device's major and minor numbers in the old
-	two-byte format, as returned by the stat() function in the .st_rdev
-	member of the stat structure)
-
 SNAPSHOT_SET_SWAP_AREA - set the resume partition and the offset (in <PAGE_SIZE>
 	units) from the beginning of the partition at which the swap header is
 	located (the last ioctl() argument should point to a struct
 	resume_swap_area, as defined in kernel/power/power.h, containing the
-	resume device specification, as for the SNAPSHOT_SET_SWAP_FILE ioctl(),
-	and the offset); for swap partitions the offset is always 0, but it is
-	different to zero for swap files (please see
+	resume device specification and the offset); for swap partitions the
+	offset is always 0, but it is different from zero for swap files (see
 	Documentation/swsusp-and-swap-files.txt for details).
-	The SNAPSHOT_SET_SWAP_AREA ioctl() is considered as a replacement for
-	SNAPSHOT_SET_SWAP_FILE which is regarded as obsolete.   It is
-	recommended to always use this call, because the code to set the resume
-	partition may be removed from future kernels
 
 SNAPSHOT_PLATFORM_SUPPORT - enable/disable the hibernation platform support,
 	depending on the argument value (enable, if the argument is nonzero)
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 6ca85fd..8837ea3 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -154,7 +154,6 @@ struct resume_swap_area {
 #define SNAPSHOT_AVAIL_SWAP		_IOR(SNAPSHOT_IOC_MAGIC, 7, void *)
 #define SNAPSHOT_GET_SWAP_PAGE		_IOR(SNAPSHOT_IOC_MAGIC, 8, void *)
 #define SNAPSHOT_FREE_SWAP_PAGES	_IO(SNAPSHOT_IOC_MAGIC, 9)
-#define SNAPSHOT_SET_SWAP_FILE		_IOW(SNAPSHOT_IOC_MAGIC, 10, unsigned int)
 #define SNAPSHOT_S2RAM			_IO(SNAPSHOT_IOC_MAGIC, 11)
 #define SNAPSHOT_SET_SWAP_AREA		_IOW(SNAPSHOT_IOC_MAGIC, 13, \
 							struct resume_swap_area)
diff --git a/kernel/power/user.c b/kernel/power/user.c
index de3fb43..5e866e0 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -29,10 +29,11 @@
 #include "power.h"
 
 /*
- * NOTE: The SNAPSHOT_PMOPS ioctl is obsolete and will be removed in the
- * future.  It is only preserved here for compatibility with existing userland
- * utilities.
+ * NOTE: The SNAPSHOT_SET_SWAP_FILE and SNAPSHOT_PMOPS ioctls are obsolete and
+ * will be removed in the future.  They are only preserved here for
+ * compatibility with existing userland utilities.
  */
+#define SNAPSHOT_SET_SWAP_FILE	_IOW(SNAPSHOT_IOC_MAGIC, 10, unsigned int)
 #define SNAPSHOT_PMOPS		_IOW(SNAPSHOT_IOC_MAGIC, 12, unsigned int)
 
 #define PMOPS_PREPARE	1
@@ -260,7 +261,7 @@ static int snapshot_ioctl(struct inode *inode, struct file *filp,
 		free_all_swap_pages(data->swap);
 		break;
 
-	case SNAPSHOT_SET_SWAP_FILE:
+	case SNAPSHOT_SET_SWAP_FILE: /* This ioctl is deprecated */
 		if (!swsusp_swap_in_use()) {
 			/*
 			 * User space encodes device types as two-byte values,
-- 
1.5.4.rc5.16.gc0279

