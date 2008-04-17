Return-Path: <linux-kernel-owner+w=401wt.eu-S933904AbYDQJt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933904AbYDQJt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933719AbYDQJ0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:26:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760527AbYDQJ0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:26:22 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Adrian Bunk <bunk@kernel.org>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 33/48] [GFS2] proper extern for gfs2/locking/dlm/mount.c:gdlm_ops
Date: Thu, 17 Apr 2008 09:39:09 +0100
Message-Id: <12084216372363-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1208421634101-git-send-email-swhiteho@redhat.com>
References: 12084214272083-git-send-email-swhiteho@redhat.com
 <12084215642582-git-send-email-swhiteho@redhat.com>
 <1208421571478-git-send-email-swhiteho@redhat.com>
 <12084215742081-git-send-email-swhiteho@redhat.com>
 <12084215763647-git-send-email-swhiteho@redhat.com>
 <12084215781246-git-send-email-swhiteho@redhat.com>
 <12084215802470-git-send-email-swhiteho@redhat.com>
 <12084215833555-git-send-email-swhiteho@redhat.com>
 <12084215851158-git-send-email-swhiteho@redhat.com>
 <120842158797-git-send-email-swhiteho@redhat.com>
 <12084215891940-git-send-email-swhiteho@redhat.com>
 <12084215913125-git-send-email-swhiteho@redhat.com>
 <12084215931509-git-send-email-swhiteho@redhat.com>
 <12084215961690-git-send-email-swhiteho@redhat.com>
 <1208421597980-git-send-email-swhiteho@redhat.com>
 <12084216003676-git-send-email-swhiteho@redhat.com>
 <12084216023999-git-send-email-swhiteho@redhat.com>
 <12084216044123-git-send-email-swhiteho@redhat.com>
 <12084216061172-git-send-email-swhiteho@redhat.com>
 <12084216082638-git-send-email-swhiteho@redhat.com>
 <12084216101961-git-send-email-swhiteho@redhat.com>
 <12084216121811-git-send-email-swhiteho@redhat.com>
 <12084216153016-git-send-email-swhiteho@redhat.com>
 <1208421617421-git-send-email-swhiteho@redhat.com>
 <12084216182363-git-send-email-swhiteho@redhat.com>
 <12084216204027-git-send-email-swhiteho@redhat.com>
 <12084216222853-git-send-email-swhiteho@redhat.com>
 <12084216241802-git-send-email-swhiteho@redhat.com>
 <12084216262937-git-send-email-swhiteho@redhat.com>
 <12084216281152-git-send-email-swhiteho@redhat.com>
 <12084216301107-git-send-email-swhiteho@redhat.com>
 <12084216323165-git-send-email-swhiteho@redhat.com>
 <1208421634101-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>

This patch adds a proper extern declaration for gdlm_ops in
fs/gfs2/locking/dlm/lock_dlm.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/locking/dlm/lock_dlm.h b/fs/gfs2/locking/dlm/lock_dlm.h
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
-- 
1.5.1.2

