Return-Path: <linux-kernel-owner+w=401wt.eu-S933502AbXEEUS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933502AbXEEUS5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 16:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933340AbXEEUSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 16:18:37 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:48853 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933409AbXEEUSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 16:18:33 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Adrian Brunyate <abrunyate@yahoo.com>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 1/3] Unionfs: Accept MS_SILENT during remount
Date: Sat,  5 May 2007 16:18:23 -0400
Message-Id: <11783963051857-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.3.1043.g4342
In-Reply-To: <11783963052286-git-send-email-jsipek@cs.sunysb.edu>
References: <11783963052286-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Brunyate <abrunyate@yahoo.com>

[jsipek: whitespace cleanup]
Signed-off-by: Adrian Brunyate <abrunyate@yahoo.com>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/super.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index e6a6cc1..ee12d03 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -425,11 +425,12 @@ static int unionfs_remount_fs(struct super_block *sb, int *flags,
 	unionfs_write_lock(sb);
 
 	/*
-	 * The VFS will take care of "ro" and "rw" flags, so anything else
-	 * is an error.  So we need to check if any other flags may have
-	 * been passed (none are allowed/supported as of now).
+	 * The VFS will take care of "ro" and "rw" flags, and we can safely
+	 * ignore MS_SILENT, but anything else left over is an error.  So we
+	 * need to check if any other flags may have been passed (none are
+	 * allowed/supported as of now).
 	 */
-	if ((*flags & ~MS_RDONLY) != 0) {
+	if ((*flags & ~(MS_RDONLY | MS_SILENT)) != 0) {
 		printk(KERN_WARNING
 		       "unionfs: remount flags 0x%x unsupported\n", *flags);
 		err = -EINVAL;
@@ -731,7 +732,8 @@ out_no_change:
 	i = atomic_inc_return(&UNIONFS_SB(sb)->generation);
 	atomic_set(&UNIONFS_D(sb->s_root)->generation, i);
 	atomic_set(&UNIONFS_I(sb->s_root->d_inode)->generation, i);
-	printk("unionfs: new generation number %d\n", i);
+	if (!(*flags & MS_SILENT)) 
+		printk("unionfs: new generation number %d\n", i);
 	err = 0;		/* reset to success */
 
 	/*
-- 
1.5.0.3.1043.g4342

