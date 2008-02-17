Return-Path: <linux-kernel-owner+w=401wt.eu-S1757860AbYBQIYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860AbYBQIYX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 03:24:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758117AbYBQIVC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 03:21:02 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:59741 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759151AbYBQIVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 03:21:00 -0500
Date: Sun, 17 Feb 2008 10:20:34 +0200
From: Adrian Bunk <bunk@kernel.org>
To: swhiteho@redhat.com
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: [2.6 patch] proper extern for gfs2/locking/dlm/mount.c:gdlm_ops
Message-ID: <20080217082034.GT3848@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a proper extern declaration for gdlm_ops in 
fs/gfs2/locking/dlm/lock_dlm.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/gfs2/locking/dlm/lock_dlm.h |    5 +++++
 fs/gfs2/locking/dlm/main.c     |    2 --
 fs/gfs2/locking/dlm/sysfs.c    |    2 --
 3 files changed, 5 insertions(+), 4 deletions(-)

b4ac811ad577cd6039fdd1395cfa910294b8efdc diff --git a/fs/gfs2/locking/dlm/lock_dlm.h b/fs/gfs2/locking/dlm/lock_dlm.h
index 9e8265d..58fcf8c 100644
--- a/fs/gfs2/locking/dlm/lock_dlm.h
+++ b/fs/gfs2/locking/dlm/lock_dlm.h
@@ -183,5 +183,10 @@ int gdlm_plock_get(void *, struct lm_lockname *, struct file *,
 		struct file_lock *);
 int gdlm_punlock(void *, struct lm_lockname *, struct file *,
 		struct file_lock *);
+
+/* mount.c */
+
+extern const struct lm_lockops gdlm_ops;
+
 #endif
 
diff --git a/fs/gfs2/locking/dlm/main.c b/fs/gfs2/locking/dlm/main.c
index a0e7eda..36a2258 100644
--- a/fs/gfs2/locking/dlm/main.c
+++ b/fs/gfs2/locking/dlm/main.c
@@ -11,8 +11,6 @@
 
 #include "lock_dlm.h"
 
-extern struct lm_lockops gdlm_ops;
-
 static int __init init_lock_dlm(void)
 {
 	int error;
diff --git a/fs/gfs2/locking/dlm/sysfs.c b/fs/gfs2/locking/dlm/sysfs.c
index a87b098..8479da4 100644
--- a/fs/gfs2/locking/dlm/sysfs.c
+++ b/fs/gfs2/locking/dlm/sysfs.c
@@ -12,8 +12,6 @@
 
 #include "lock_dlm.h"
 
-extern struct lm_lockops gdlm_ops;
-
 static ssize_t proto_name_show(struct gdlm_ls *ls, char *buf)
 {
 	return sprintf(buf, "%s\n", gdlm_ops.lm_proto_name);

