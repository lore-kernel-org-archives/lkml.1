Return-Path: <linux-kernel-owner+w=401wt.eu-S1753819AbZGOVW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbZGOVW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 17:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151AbZGOVVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 17:21:52 -0400
Received: from cobra.newdream.net ([66.33.216.30]:42912 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbZGOVVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 17:21:12 -0400
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sage Weil <sage@newdream.net>
Subject: [PATCH 18/20] ceph: debugging
Date: Wed, 15 Jul 2009 14:24:48 -0700
Message-Id: <1247693090-27796-19-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1247693090-27796-18-git-send-email-sage@newdream.net>
References: <1247693090-27796-1-git-send-email-sage@newdream.net>
 <1247693090-27796-2-git-send-email-sage@newdream.net>
 <1247693090-27796-3-git-send-email-sage@newdream.net>
 <1247693090-27796-4-git-send-email-sage@newdream.net>
 <1247693090-27796-5-git-send-email-sage@newdream.net>
 <1247693090-27796-6-git-send-email-sage@newdream.net>
 <1247693090-27796-7-git-send-email-sage@newdream.net>
 <1247693090-27796-8-git-send-email-sage@newdream.net>
 <1247693090-27796-9-git-send-email-sage@newdream.net>
 <1247693090-27796-10-git-send-email-sage@newdream.net>
 <1247693090-27796-11-git-send-email-sage@newdream.net>
 <1247693090-27796-12-git-send-email-sage@newdream.net>
 <1247693090-27796-13-git-send-email-sage@newdream.net>
 <1247693090-27796-14-git-send-email-sage@newdream.net>
 <1247693090-27796-15-git-send-email-sage@newdream.net>
 <1247693090-27796-16-git-send-email-sage@newdream.net>
 <1247693090-27796-17-git-send-email-sage@newdream.net>
 <1247693090-27796-18-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some debugging infrastructure, including the ability to adjust the
level of debug output on a per-file basis.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/ceph/ceph_debug.h |   86 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 86 insertions(+), 0 deletions(-)
 create mode 100644 fs/ceph/ceph_debug.h

diff --git a/fs/ceph/ceph_debug.h b/fs/ceph/ceph_debug.h
new file mode 100644
index 0000000..70a2521
--- /dev/null
+++ b/fs/ceph/ceph_debug.h
@@ -0,0 +1,86 @@
+#ifndef _FS_CEPH_DEBUG_H
+#define _FS_CEPH_DEBUG_H
+
+#include <linux/string.h>
+
+extern int ceph_debug __read_mostly;         /* debug level. */
+extern int ceph_debug_console __read_mostly; /* send debug output to console? */
+extern int ceph_debug_mask __read_mostly;
+
+/*
+ * different debug levels for different modules.  These default to -1.
+ * If they are >= 0, then they override the global ceph_debug value.
+ */
+extern int ceph_debug_addr __read_mostly;
+extern int ceph_debug_caps __read_mostly;
+extern int ceph_debug_dir __read_mostly;
+extern int ceph_debug_export __read_mostly;
+extern int ceph_debug_file __read_mostly;
+extern int ceph_debug_inode __read_mostly;
+extern int ceph_debug_ioctl __read_mostly;
+extern int ceph_debug_mdsc __read_mostly;
+extern int ceph_debug_mdsmap __read_mostly;
+extern int ceph_debug_msgr __read_mostly;
+extern int ceph_debug_mon __read_mostly;
+extern int ceph_debug_osdc __read_mostly;
+extern int ceph_debug_osdmap __read_mostly;
+extern int ceph_debug_snap __read_mostly;
+extern int ceph_debug_super __read_mostly;
+extern int ceph_debug_protocol __read_mostly;
+extern int ceph_debug_proc __read_mostly;
+extern int ceph_debug_tools __read_mostly;
+
+#define DOUT_MASK_ADDR		0x00000001
+#define DOUT_MASK_CAPS		0x00000002
+#define DOUT_MASK_DIR		0x00000004
+#define DOUT_MASK_EXPORT	0x00000008
+#define DOUT_MASK_FILE		0x00000010
+#define DOUT_MASK_INODE		0x00000020
+#define DOUT_MASK_IOCTL		0x00000040
+#define DOUT_MASK_MDSC		0x00000080
+#define DOUT_MASK_MDSMAP	0x00000100
+#define DOUT_MASK_MSGR		0x00000200
+#define DOUT_MASK_MON		0x00000400
+#define DOUT_MASK_OSDC		0x00000800
+#define DOUT_MASK_OSDMAP	0x00001000
+#define DOUT_MASK_SNAP		0x00002000
+#define DOUT_MASK_SUPER		0x00004000
+#define DOUT_MASK_PROTOCOL	0x00008000
+#define DOUT_MASK_PROC		0x00010000
+#define DOUT_MASK_TOOLS		0x00020000
+
+#define DOUT_UNMASKABLE	0x80000000
+
+#define _STRINGIFY(x) #x
+#define STRINGIFY(x) _STRINGIFY(x)
+
+#define FMT_PREFIX "%-30.30s: "
+#define FMT_SUFFIX "%s"
+#define LOG_ARGS __FILE__ ":" STRINGIFY(__LINE__)
+#define TRAIL_PARAM ""
+
+#define LOG_LINE FMT_PREFIX fmt, LOG_ARGS, args
+
+#define dout_flag(x, mask, fmt, args...) do {				\
+		if (((ceph_debug_mask | DOUT_UNMASKABLE) & mask) &&	\
+		    ((DOUT_VAR >= 0 && (x) <= DOUT_VAR) ||		\
+		     (DOUT_VAR < 0 && (x) <= ceph_debug))) {		\
+			if (ceph_debug_console)				\
+				printk(KERN_ERR FMT_PREFIX fmt, LOG_ARGS, \
+				       args);				\
+			else						\
+				printk(KERN_DEBUG FMT_PREFIX fmt, LOG_ARGS, \
+				       args);				\
+		}							\
+	} while (0)
+
+#define _dout(x, fmt, args...) dout_flag((x), DOUT_MASK, fmt FMT_SUFFIX, args)
+
+#define _derr(x, fmt, args...) do {					\
+		printk(KERN_ERR FMT_PREFIX fmt FMT_SUFFIX, LOG_ARGS, args); \
+	} while (0)
+
+#define dout(x, args...) _dout((x), args, TRAIL_PARAM)
+#define derr(x, args...) _derr((x), args, TRAIL_PARAM)
+
+#endif
-- 
1.5.6.5

