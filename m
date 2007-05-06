Return-Path: <linux-kernel-owner+w=401wt.eu-S1754025AbXEFRml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbXEFRml (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 13:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbXEFRmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 13:42:25 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:60174 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686AbXEFRmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 13:42:11 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org,
       akpm@linux-foundation.org, viro@ftp.linux.org.uk,
       Trond.Myklebust@netapp.com, neilb@suse.de, mhalcrow@us.ibm.com,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 4/5] fs: Mark link_path_walk static
Date: Sun,  6 May 2007 13:41:28 -0400
Message-Id: <11784732901486-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.20.g86b9
In-Reply-To: <1178473289617-git-send-email-jsipek@cs.sunysb.edu>
References: <1178473289617-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/namei.c            |    5 ++++-
 include/linux/namei.h |    1 -
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 090cce4..d9eb621 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -108,6 +108,9 @@
  * any extra contention...
  */
 
+/* forward declaration */
+static int fastcall link_path_walk(const char *name, struct nameidata *nd);
+
 /* In order to reduce some races, while at the same time doing additional
  * checking and hopefully speeding things up, we copy filenames to the
  * kernel data space before using them..
@@ -999,7 +1002,7 @@ return_err:
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
1.5.2.rc1.20.g86b9

