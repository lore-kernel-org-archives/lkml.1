Return-Path: <linux-kernel-owner+w=401wt.eu-S1752348AbYEPOm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbYEPOm0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 10:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbYEPOl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:41:59 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:49178 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbYEPOl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:41:58 -0400
X-Greylist: delayed 515 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 May 2008 10:41:57 EDT
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [PATCH 67/67] merge aufs
Date: Fri, 16 May 2008 23:33:21 +0900
Message-Id: <121094840365-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <12109484031925-git-send-email-hooanon05@yahoo.co.jp>
References: <12109484013324-git-send-email-hooanon05@yahoo.co.jp> <12109484012532-git-send-email-hooanon05@yahoo.co.jp> <12109484012997-git-send-email-hooanon05@yahoo.co.jp> <12109484013051-git-send-email-hooanon05@yahoo.co.jp> <12109484013436-git-send-email-hooanon05@yahoo.co.jp> <1210948401415-git-send-email-hooanon05@yahoo.co.jp> <12109484011533-git-send-email-hooanon05@yahoo.co.jp> <1210948401506-git-send-email-hooanon05@yahoo.co.jp> <12109484013156-git-send-email-hooanon05@yahoo.co.jp> <12109484012724-git-send-email-hooanon05@yahoo.co.jp> <12109484013264-git-send-email-hooanon05@yahoo.co.jp> <12109484012658-git-send-email-hooanon05@yahoo.co.jp> <12109484011282-git-send-email-hooanon05@yahoo.co.jp> <12109484012543-git-send-email-hooanon05@yahoo.co.jp> <12109484013834-git-send-email-hooanon05@yahoo.co.jp> <12109484012213-git-send-email-hooanon05@yahoo.co.jp> <12109484012301-git-send-email-hooanon05@yahoo.co.jp> <1210948401175-git-send-email-hooanon05@yahoo.co.jp> <1210948!
 4013702-git-send-email-hooanon05@yahoo.co.jp> <12109484012871-git-send-email-hooanon05@yahoo.co.jp> <12109484013438-git-send-email-hooanon05@yahoo.co.jp> <12109484013559-git-send-email-hooanon05@yahoo.co.jp> <12109484012111-git-send-email-hooanon05@yahoo.co.jp> <1210948401543-git-send-email-hooanon05@yahoo.co.jp> <1210948401147-git-send-email-hooanon05@yahoo.co.jp> <12109484012904-git-send-email-hooanon05@yahoo.co.jp> <121094840127-git-send-email-hooanon05@yahoo.co.jp> <12109484011862-git-send-email-hooanon05@yahoo.co.jp> <12109484011143-git-send-email-hooanon05@yahoo.co.jp> <12109484011867-git-send-email-hooanon05@yahoo.co.jp> <12109484021033-git-send-email-hooanon05@yahoo.co.jp> <12109484021234-git-send-email-hooanon05@yahoo.co.jp> <12109484022680-git-send-email-hooanon05@yahoo.co.jp> <12109484021974-git-send-email-hooanon05@yahoo.co.jp> <12109484021281-git-send-email-hooanon05@yahoo.co.jp> <12109484022659-git-send-email-hooanon05@yahoo.co.jp> <12109484023036-git-send-ema!
 il-hooanon05@yahoo.co.jp> <12109484021939-git-send-email-hooanon05@yahoo.co.jp> <12109484022745-git-send-email-hooanon05@yahoo.co.jp> <12109484023224-git-send-email-hooanon05@yahoo.co.jp> <12109484023618-git-send-email-hooanon05@yahoo.co.jp> <12109484023820-git-send-email-hooanon05@yahoo.co.jp> <12109484021927-git-send-email
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

	incorporate aufs, export __lookup_hash() and deeper lockdep

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 fs/Kconfig              |    2 ++
 fs/Makefile             |    1 +
 fs/namei.c              |    2 +-
 include/linux/lockdep.h |    4 ++++
 include/linux/namei.h   |    1 +
 5 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 379eb47..6df842f 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1072,6 +1072,8 @@ config UNION_FS_DEBUG
 	help
 	  If you say Y here, you can turn on debugging output from Unionfs.
 
+source "fs/aufs/Kconfig"
+
 endmenu
 
 menu "Miscellaneous filesystems"
diff --git a/fs/Makefile b/fs/Makefile
index 7996220..bc5964a 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -121,3 +121,4 @@ obj-$(CONFIG_DEBUG_FS)		+= debugfs/
 obj-$(CONFIG_OCFS2_FS)		+= ocfs2/
 obj-$(CONFIG_GFS2_FS)           += gfs2/
 obj-$(CONFIG_UNION_FS)		+= unionfs/
+obj-$(CONFIG_AUFS)		+= aufs/
diff --git a/fs/namei.c b/fs/namei.c
index 185d56c..1b9e577 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1297,7 +1297,7 @@ int __user_path_lookup_open(const char __user *name, unsigned int lookup_flags,
 	return err;
 }
 
-static struct dentry *__lookup_hash(struct qstr *name,
+struct dentry *__lookup_hash(struct qstr *name,
 		struct dentry *base, struct nameidata *nd)
 {
 	struct dentry *dentry;
diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 4c4d236..f5d0642 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -58,7 +58,11 @@ enum lock_usage_bit
 #define LOCKF_USED_IN_IRQ_READ \
 		(LOCKF_USED_IN_HARDIRQ_READ | LOCKF_USED_IN_SOFTIRQ_READ)
 
+#ifdef CONFIG_AUFS
+#define MAX_LOCKDEP_SUBCLASSES		16UL
+#else
 #define MAX_LOCKDEP_SUBCLASSES		8UL
+#endif
 
 /*
  * Lock-classes are keyed via unique addresses, by embedding the
diff --git a/include/linux/namei.h b/include/linux/namei.h
index 24d88e9..33c7f23 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -74,6 +74,7 @@ extern struct file *lookup_instantiate_filp(struct nameidata *nd, struct dentry
 extern struct file *nameidata_to_filp(struct nameidata *nd, int flags);
 extern void release_open_intent(struct nameidata *);
 
+struct dentry * __lookup_hash(struct qstr *name, struct dentry * base, struct nameidata *nd);
 extern struct dentry *lookup_one_len(const char *, struct dentry *, int);
 extern struct dentry *lookup_one_noperm(const char *, struct dentry *);
 
-- 
1.4.4.4

