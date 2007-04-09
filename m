Return-Path: <linux-kernel-owner+w=401wt.eu-S964976AbXDIPAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964976AbXDIPAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 11:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933701AbXDIOyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 10:54:36 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:43999 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933660AbXDIOye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 10:54:34 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 05/21] Unionfs: Rename unionfs_data sbcount field to more appropriate open_files
Date: Mon,  9 Apr 2007 10:53:56 -0400
Message-Id: <11761304531531-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.3.268.g3dda
In-Reply-To: <11761304521844-git-send-email-jsipek@cs.sunysb.edu>
References: <11761304521844-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/fanout.h |    8 ++++----
 fs/unionfs/union.h  |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/unionfs/fanout.h b/fs/unionfs/fanout.h
index e2acb75..3d1dd4c 100644
--- a/fs/unionfs/fanout.h
+++ b/fs/unionfs/fanout.h
@@ -106,22 +106,22 @@ static inline void unionfs_set_lower_super(struct super_block *sb, struct super_
 /* Branch count macros. */
 static inline int branch_count(const struct super_block *sb, int index)
 {
-	return atomic_read(&UNIONFS_SB(sb)->data[index].sbcount);
+	return atomic_read(&UNIONFS_SB(sb)->data[index].open_files);
 }
 
 static inline void set_branch_count(struct super_block *sb, int index, int val)
 {
-	atomic_set(&UNIONFS_SB(sb)->data[index].sbcount, val);
+	atomic_set(&UNIONFS_SB(sb)->data[index].open_files, val);
 }
 
 static inline void branchget(struct super_block *sb, int index)
 {
-	atomic_inc(&UNIONFS_SB(sb)->data[index].sbcount);
+	atomic_inc(&UNIONFS_SB(sb)->data[index].open_files);
 }
 
 static inline void branchput(struct super_block *sb, int index)
 {
-	atomic_dec(&UNIONFS_SB(sb)->data[index].sbcount);
+	atomic_dec(&UNIONFS_SB(sb)->data[index].open_files);
 }
 
 /* Dentry macros */
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 5676394..df9b8c0 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -121,7 +121,7 @@ struct unionfs_dentry_info {
 /* These are the pointers to our various objects. */
 struct unionfs_data {
 	struct super_block *sb;
-	atomic_t sbcount;
+	atomic_t open_files;	/* number of open files on branch */
 	int branchperms;
 };
 
-- 
1.5.0.3.268.g3dda

