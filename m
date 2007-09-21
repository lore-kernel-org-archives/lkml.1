Return-Path: <linux-kernel-owner+w=401wt.eu-S1759310AbXIUNgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310AbXIUNgX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 09:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757923AbXIUNgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 09:36:16 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:15642 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757579AbXIUNgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 09:36:15 -0400
From: Andrey Mirkin <amirkin@sw.ru>
To: John McCutchan <ttb@tentacle.dhs.org>,
       Robert Love <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@osdl.org>
Subject: [PATCH] change inotifyfs magic as the same magic is used for futexfs
Date: Fri, 21 Sep 2007 17:35:43 +0400
User-Agent: KMail/1.8.2
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709211735.44814.amirkin@sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrey Mirkin <major@openvz.org>

Right now futexfs and inotifyfs have one magic 0xBAD1DEA, that looks a little 
bit confusing.
Use 0xBAD1DEA as magic for futexfs and 0x2BAD1DEA as magic for inotifyfs.

Signed-off-by: Andrey Mirkin <major@openvz.org>

----

diff --git a/fs/inotify_user.c b/fs/inotify_user.c
index 9bf2f6c..9b1a195 100644
--- a/fs/inotify_user.c
+++ b/fs/inotify_user.c
@@ -684,7 +684,7 @@ static int
 inotify_get_sb(struct file_system_type *fs_type, int flags,
 	       const char *dev_name, void *data, struct vfsmount *mnt)
 {
-	return get_sb_pseudo(fs_type, "inotify", NULL, 0xBAD1DEA, mnt);
+	return get_sb_pseudo(fs_type, "inotify", NULL, INOTIFYFS_MAGIC, mnt);
 }
 
 static struct file_system_type inotify_fs_type = {
diff --git a/include/linux/futex.h b/include/linux/futex.h
index 9965035..89611cc 100644
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -3,6 +3,8 @@ #define _LINUX_FUTEX_H
 
 #include <linux/sched.h>
 
+#define FUTEXFS_MAGIC 0xBAD1DEA
+
 union ktime;
 
 /* Second argument to futex syscall */
diff --git a/include/linux/inotify.h b/include/linux/inotify.h
index d4f48c6..2579c4d 100644
--- a/include/linux/inotify.h
+++ b/include/linux/inotify.h
@@ -9,6 +9,8 @@ #define _LINUX_INOTIFY_H
 
 #include <linux/types.h>
 
+#define INOTIFYFS_MAGIC 0x2BAD1DEA
+
 /*
  * struct inotify_event - structure read from the inotify device for each 
event
  *
diff --git a/kernel/futex.c b/kernel/futex.c
index e8935b1..6b57355 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2074,7 +2074,7 @@ static int futexfs_get_sb(struct file_sy
 			  int flags, const char *dev_name, void *data,
 			  struct vfsmount *mnt)
 {
-	return get_sb_pseudo(fs_type, "futex", NULL, 0xBAD1DEA, mnt);
+	return get_sb_pseudo(fs_type, "futex", NULL, FUTEXFS_MAGIC, mnt);
 }
 
 static struct file_system_type futex_fs_type = {
