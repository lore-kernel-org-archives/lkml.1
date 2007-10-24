Return-Path: <linux-kernel-owner+w=401wt.eu-S1763355AbXJXQtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763355AbXJXQtj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760539AbXJXQ1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:27:11 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:32798 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756591AbXJXQ1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:27:05 -0400
Date: Wed, 24 Oct 2007 18:27:34 +0200
From: Adrian Bunk <bunk@kernel.org>
To: KaiGai Kohei <kaigai@ak.jp.nec.com>, David Woodhouse <dwmw2@infradead.org>
Cc: jffs-dev@axis.com, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make jffs2_get_acl() static
Message-ID: <20071024162734.GU30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

jffs2_get_acl() can now become static again.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/jffs2/acl.c |    2 +-
 fs/jffs2/acl.h |    2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

add2b887d64536f3fe978e62f0774292456f1ddb 
diff --git a/fs/jffs2/acl.c b/fs/jffs2/acl.c
index 9728614..b14e805 100644
--- a/fs/jffs2/acl.c
+++ b/fs/jffs2/acl.c
@@ -176,7 +176,7 @@ static void jffs2_iset_acl(struct inode *inode, struct posix_acl **i_acl, struct
 	spin_unlock(&inode->i_lock);
 }
 
-struct posix_acl *jffs2_get_acl(struct inode *inode, int type)
+static struct posix_acl *jffs2_get_acl(struct inode *inode, int type)
 {
 	struct jffs2_inode_info *f = JFFS2_INODE_INFO(inode);
 	struct posix_acl *acl;
diff --git a/fs/jffs2/acl.h b/fs/jffs2/acl.h
index 76c6ebd..0bb7f00 100644
--- a/fs/jffs2/acl.h
+++ b/fs/jffs2/acl.h
@@ -28,7 +28,6 @@ struct jffs2_acl_header {
 
 #define JFFS2_ACL_NOT_CACHED ((void *)-1)
 
-extern struct posix_acl *jffs2_get_acl(struct inode *inode, int type);
 extern int jffs2_permission(struct inode *, int, struct nameidata *);
 extern int jffs2_acl_chmod(struct inode *);
 extern int jffs2_init_acl_pre(struct inode *, struct inode *, int *);
@@ -40,7 +39,6 @@ extern struct xattr_handler jffs2_acl_default_xattr_handler;
 
 #else
 
-#define jffs2_get_acl(inode, type)		(NULL)
 #define jffs2_permission			(NULL)
 #define jffs2_acl_chmod(inode)			(0)
 #define jffs2_init_acl_pre(dir_i,inode,mode)	(0)

