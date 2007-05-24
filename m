Return-Path: <linux-kernel-owner+w=401wt.eu-S1763372AbXEXCA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763372AbXEXCA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 22:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762156AbXEXB7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 21:59:36 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:42587 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762147AbXEXB7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 21:59:30 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org,
       akpm@linux-foundation.org, viro@ftp.linux.org.uk,
       Trond.Myklebust@netapp.com, neilb@suse.de, mhalcrow@us.ibm.com,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 4/5] fs: Mark link_path_walk static
Date: Wed, 23 May 2007 21:54:37 -0400
Message-Id: <1179971678305-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
In-Reply-To: <11799716781687-git-send-email-jsipek@cs.sunysb.edu>
References: <11799716781687-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/namei.c            |    4 +++-
 include/linux/namei.h |    1 -
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index a30efbc..50285a1 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -107,6 +107,8 @@
  * any extra contention...
  */
 
+static int fastcall link_path_walk(const char *name, struct nameidata *nd);
+
 /* In order to reduce some races, while at the same time doing additional
  * checking and hopefully speeding things up, we copy filenames to the
  * kernel data space before using them..
@@ -998,7 +1000,7 @@ return_err:
  * Retry the whole path once, forcing real lookup requests
  * instead of relying on the dcache.
  */
-int fastcall link_path_walk(const char *name, struct nameidata *nd)
+static int fastcall link_path_walk(const char *name, struct nameidata *nd)
 {
 	struct nameidata save = *nd;
 	int result;
diff --git a/include/linux/namei.h b/include/linux/namei.h
index 4718788..d60a5eb 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -73,7 +73,6 @@ extern int FASTCALL(path_lookup(const char *, unsigned, struct nameidata *));
 extern int vfs_path_lookup(struct dentry *, struct vfsmount *,
 			   const char *, unsigned int, struct nameidata *);
 extern int FASTCALL(path_walk(const char *, struct nameidata *));
-extern int FASTCALL(link_path_walk(const char *, struct nameidata *));
 extern void path_release(struct nameidata *);
 extern void path_release_on_umount(struct nameidata *);
 
-- 
1.5.2.rc1.165.gaf9b

