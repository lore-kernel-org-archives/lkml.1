Return-Path: <linux-kernel-owner+w=401wt.eu-S1759574AbYAJPBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759574AbYAJPBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 10:01:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755890AbYAJPAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 10:00:23 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:56967 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585AbYAJPAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 10:00:19 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       hch@infradead.org, viro@ftp.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 27/29] VFS path get/put ops used by Unionfs
Date: Thu, 10 Jan 2008 09:59:46 -0500
Message-Id: <1199977207623-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11999771882152-git-send-email-ezk@cs.sunysb.edu>
References: <11999771882152-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: this will become obsolete once similar patches, now in -mm, make it to
mainline.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 include/linux/namei.h |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/include/linux/namei.h b/include/linux/namei.h
index 4cb4f8d..63f16d9 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -3,6 +3,7 @@
 
 #include <linux/dcache.h>
 #include <linux/linkage.h>
+#include <linux/mount.h>
 
 struct vfsmount;
 
@@ -100,4 +101,16 @@ static inline char *nd_get_link(struct nameidata *nd)
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
1.5.2.2

