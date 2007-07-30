Return-Path: <linux-kernel-owner+w=401wt.eu-S938497AbXG3QOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938497AbXG3QOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932107AbXG3QOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:14:07 -0400
Received: from mx1.suse.de ([195.135.220.2]:40546 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764281AbXG3QOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:14:05 -0400
Message-Id: <20070730161323.329111957@weierstrass.suse.de>
References: <20070730161323.100048969@weierstrass.suse.de>
User-Agent: quilt/0.46-62.2
Date: Mon, 30 Jul 2007 18:13:25 +0200
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: [RFC 02/26] VFS: Export dput_path() and path_to_nameidata()
Content-Disposition: inline; filename=um/vfs-export-dput_path.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes dput_path() and path_to_nameidata() general available.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/namei.c            |   16 ----------------
 include/linux/namei.h |   15 +++++++++++++++
 2 files changed, 15 insertions(+), 16 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -573,22 +573,6 @@ fail:
 	return PTR_ERR(link);
 }
 
-static inline void dput_path(struct path *path, struct nameidata *nd)
-{
-	dput(path->dentry);
-	if (path->mnt != nd->mnt)
-		mntput(path->mnt);
-}
-
-static inline void path_to_nameidata(struct path *path, struct nameidata *nd)
-{
-	dput(nd->dentry);
-	if (nd->mnt != path->mnt)
-		mntput(nd->mnt);
-	nd->mnt = path->mnt;
-	nd->dentry = path->dentry;
-}
-
 static __always_inline int __do_follow_link(struct path *path, struct nameidata *nd)
 {
 	int error;
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -119,5 +119,20 @@ static inline void pathput(struct path *
 	dput(path->dentry);
 	mntput(path->mnt);
 }
+static inline void dput_path(struct path *path, struct nameidata *nd)
+{
+	dput(path->dentry);
+	if (path->mnt != nd->mnt)
+		mntput(path->mnt);
+}
+
+static inline void path_to_nameidata(struct path *path, struct nameidata *nd)
+{
+	dput(nd->dentry);
+	if (nd->mnt != path->mnt)
+		mntput(nd->mnt);
+	nd->mnt = path->mnt;
+	nd->dentry = path->dentry;
+}
 
 #endif /* _LINUX_NAMEI_H */

-- 

