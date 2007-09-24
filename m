Return-Path: <linux-kernel-owner+w=401wt.eu-S1755874AbXIXIqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbXIXIqL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 04:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbXIXIp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 04:45:57 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:44370 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348AbXIXIp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 04:45:56 -0400
From: Andrey Mirkin <major@openvz.org>
To: John McCutchan <ttb@tentacle.dhs.org>,
       Robert Love <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@osdl.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH] change inotifyfs magic as the same magic is used for futexfs (v2)
Date: Mon, 24 Sep 2007 12:46:06 +0400
User-Agent: KMail/1.8.2
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709241246.08138.major@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrey Mirkin <major@openvz.org>

Right now futexfs and inotifyfs have one magic 0xBAD1DEA, that looks a little 
bit confusing.
Use 0xBAD1DEA as magic for futexfs and 0x2BAD1DEA as magic for inotifyfs.

Signed-off-by: Andrey Mirkin <major@openvz.org>

----

 fs/inotify_user.c     |    4 +++-
 include/linux/magic.h |    3 +++
 kernel/futex.c        |    3 ++-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/inotify_user.c b/fs/inotify_user.c
index 9bf2f6c..5e00933 100644
--- a/fs/inotify_user.c
+++ b/fs/inotify_user.c
@@ -31,6 +31,7 @@ #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/inotify.h>
 #include <linux/syscalls.h>
+#include <linux/magic.h>
 
 #include <asm/ioctls.h>
 
@@ -684,7 +685,8 @@ static int
 inotify_get_sb(struct file_system_type *fs_type, int flags,
 	       const char *dev_name, void *data, struct vfsmount *mnt)
 {
-	return get_sb_pseudo(fs_type, "inotify", NULL, 0xBAD1DEA, mnt);
+	return get_sb_pseudo(fs_type, "inotify", NULL,
+			INOTIFYFS_SUPER_MAGIC, mnt);
 }
 
 static struct file_system_type inotify_fs_type = {
diff --git a/include/linux/futex.h b/include/linux/futex.h
diff --git a/include/linux/inotify.h b/include/linux/inotify.h
diff --git a/include/linux/magic.h b/include/linux/magic.h
index 36cc20d..722d475 100644
--- a/include/linux/magic.h
+++ b/include/linux/magic.h
@@ -38,4 +38,7 @@ #define REISER2FS_JR_SUPER_MAGIC_STRING	
 #define SMB_SUPER_MAGIC		0x517B
 #define USBDEVICE_SUPER_MAGIC	0x9fa2
 
+#define FUTEXFS_SUPER_MAGIC	0xBAD1DEA
+#define INOTIFYFS_SUPER_MAGIC	0x2BAD1DEA
+
 #endif /* __LINUX_MAGIC_H__ */
diff --git a/kernel/futex.c b/kernel/futex.c
index e8935b1..856dfba 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -52,6 +52,7 @@ #include <linux/pagemap.h>
 #include <linux/syscalls.h>
 #include <linux/signal.h>
 #include <linux/module.h>
+#include <linux/magic.h>
 #include <asm/futex.h>
 
 #include "rtmutex_common.h"
@@ -2074,7 +2075,7 @@ static int futexfs_get_sb(struct file_sy
 			  int flags, const char *dev_name, void *data,
 			  struct vfsmount *mnt)
 {
-	return get_sb_pseudo(fs_type, "futex", NULL, 0xBAD1DEA, mnt);
+	return get_sb_pseudo(fs_type, "futex", NULL, FUTEXFS_SUPER_MAGIC, mnt);
 }
 
 static struct file_system_type futex_fs_type = {
