Return-Path: <linux-kernel-owner+w=401wt.eu-S933883AbXDIPCH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933883AbXDIPCH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 11:02:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933869AbXDIPBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 11:01:46 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:43988 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933662AbXDIOyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 10:54:31 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 01/21] fs: Introduce path{get,put}
Date: Mon,  9 Apr 2007 10:53:52 -0400
Message-Id: <11761304531137-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.3.268.g3dda
In-Reply-To: <11761304521844-git-send-email-jsipek@cs.sunysb.edu>
References: <11761304521844-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezkcs.sunysb.edu>

Export drop_pagecache_sb symbol (for branch-management).

Signed-off-by: Erez Zadok <ezkcs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipekcs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 include/linux/namei.h |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/include/linux/namei.h b/include/linux/namei.h
index 941be96..92b422b 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -3,6 +3,7 @@
 
 #include <linux/dcache.h>
 #include <linux/linkage.h>
+#include <linux/mount.h>
 
 struct vfsmount;
 
@@ -107,4 +108,16 @@ static inline char *nd_get_link(struct nameidata *nd)
 	return nd->saved_names[nd->depth];
 }
 
+static inline void pathget(struct path *path)
+{
+	mntget(path->mnt);
+	dget(path->dentry);
+}
+
+static inline void pathput(struct path *path)
+{
+	dput(path->dentry);
+	mntput(path->mnt);
+}
+
 #endif /* _LINUX_NAMEI_H */
-- 
1.5.0.3.268.g3dda

