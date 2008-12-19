Return-Path: <linux-kernel-owner+w=401wt.eu-S1751932AbYLSUsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbYLSUsI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 15:48:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbYLSUr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 15:47:27 -0500
Received: from kumera.dghda.com ([80.68.90.171]:35257 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617AbYLSUr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 15:47:26 -0500
From: "Duane Griffin" <duaneg@dghda.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Eric Van Hensbergen <ericvh@gmail.com>,
       Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>,
       v9fs-developer@lists.sourceforge.net
Subject: [PATCH, v5] 9p: don't print IS_ERR strings
Date: Fri, 19 Dec 2008 20:47:09 +0000
Message-Id: <1229719638-6982-2-git-send-email-duaneg@dghda.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1229719638-6982-1-git-send-email-duaneg@dghda.com>
References: <1229719638-6982-1-git-send-email-duaneg@dghda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the printk inside the !IS_ERR test.

Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Cc: v9fs-developer@lists.sourceforge.net
Signed-off-by: Duane Griffin <duaneg@dghda.com>
---

Unchanged from original version.

 fs/9p/vfs_inode.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 8fddfe8..c50d555 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -1022,9 +1022,10 @@ v9fs_vfs_put_link(struct dentry *dentry, struct nameidata *nd, void *p)
 {
 	char *s = nd_get_link(nd);
 
-	P9_DPRINTK(P9_DEBUG_VFS, " %s %s\n", dentry->d_name.name, s);
-	if (!IS_ERR(s))
+	if (!IS_ERR(s)) {
+		P9_DPRINTK(P9_DEBUG_VFS, " %s %s\n", dentry->d_name.name, s);
 		__putname(s);
+	}
 }
 
 /**
-- 
1.6.0.4

