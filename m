Return-Path: <linux-kernel-owner+w=401wt.eu-S1752586AbXCEB4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbXCEB4H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 20:56:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbXCEBzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:55:50 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:38373 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbXCEBzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:55:22 -0500
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 02/13] fs/unionfs/: Fix a memory leak in unionfs_read_super
Date: Sun,  4 Mar 2007 20:54:52 -0500
Message-Id: <1173059704786-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.2.260.g2eb065
In-Reply-To: <11730597033857-git-send-email-jsipek@cs.sunysb.edu>
References: <11730597033857-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/main.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/unionfs/main.c b/fs/unionfs/main.c
index ca7ee26..bd64242 100644
--- a/fs/unionfs/main.c
+++ b/fs/unionfs/main.c
@@ -584,10 +584,11 @@ static int unionfs_read_super(struct super_block *sb, void *raw_data,
 	atomic_set(&UNIONFS_D(sb->s_root)->generation, 1);
 
 	/* call interpose to create the upper level inode */
-	if ((err = unionfs_interpose(sb->s_root, sb, 0)))
-		goto out_freedpd;
+	err = unionfs_interpose(sb->s_root, sb, 0);
 	unionfs_unlock_dentry(sb->s_root);
-	goto out;
+	if (!err)
+		goto out;
+	/* else fall through */
 
 out_freedpd:
 	if (UNIONFS_D(sb->s_root)) {
-- 
1.5.0.2.260.g2eb065

