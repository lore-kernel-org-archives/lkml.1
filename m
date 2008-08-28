Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbYH1Rne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbYH1Rne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 13:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755239AbYH1Rmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 13:42:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:52427 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755153AbYH1Rmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 13:42:37 -0400
From: Tejun Heo <tj@kernel.org>
To: fuse-devel@lists.sourceforge.net, miklos@szeredi.hu, greg@kroah.com,
       linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/7] FUSE: add include protectors
Date: Fri, 29 Aug 2008 02:40:57 +0900
Message-Id: <1219945263-21074-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219945263-21074-1-git-send-email-tj@kernel.org>
References: <1219945263-21074-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 28 Aug 2008 17:42:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add include protectors to include/linux/fuse.h and fs/fuse/fuse_i.h.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/fuse/fuse_i.h     |    5 +++++
 include/linux/fuse.h |    5 +++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 3a87607..e2b3b72 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -6,6 +6,9 @@
   See the file COPYING.
 */
 
+#ifndef __FS_FUSE_I_H
+#define __FS_FUSE_I_H
+
 #include <linux/fuse.h>
 #include <linux/fs.h>
 #include <linux/mount.h>
@@ -655,3 +658,5 @@ void fuse_set_nowrite(struct inode *inode);
 void fuse_release_nowrite(struct inode *inode);
 
 u64 fuse_get_attr_version(struct fuse_conn *fc);
+
+#endif /* __FS_FUSE_I_H */
diff --git a/include/linux/fuse.h b/include/linux/fuse.h
index 265635d..776ab72 100644
--- a/include/linux/fuse.h
+++ b/include/linux/fuse.h
@@ -19,6 +19,9 @@
  *  - add file flags field to fuse_read_in and fuse_write_in
  */
 
+#ifndef __LINUX_FUSE_H
+#define __LINUX_FUSE_H
+
 #include <asm/types.h>
 #include <linux/major.h>
 
@@ -409,3 +412,5 @@ struct fuse_dirent {
 #define FUSE_DIRENT_ALIGN(x) (((x) + sizeof(__u64) - 1) & ~(sizeof(__u64) - 1))
 #define FUSE_DIRENT_SIZE(d) \
 	FUSE_DIRENT_ALIGN(FUSE_NAME_OFFSET + (d)->namelen)
+
+#endif /* __LINUX_FUSE_H */
-- 
1.5.4.5

