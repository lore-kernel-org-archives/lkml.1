Return-Path: <linux-kernel-owner+w=401wt.eu-S932959AbXF2H1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932959AbXF2H1Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 03:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932457AbXF2H0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 03:26:38 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:46313 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761937AbXF2H0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 03:26:33 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 3/5] Unionfs: Use file->f_path instead of file->f_dentry
Date: Fri, 29 Jun 2007 03:26:19 -0400
Message-Id: <1183101982261-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <1183101981740-git-send-email-jsipek@cs.sunysb.edu>
References: <1183101981740-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/commonfops.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index 8527ac6..28cb4e9 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -708,10 +708,10 @@ int unionfs_flush(struct file *file, fl_owner_t id)
 {
 	int err = 0;
 	struct file *lower_file = NULL;
-	struct dentry *dentry = file->f_dentry;
+	struct dentry *dentry = file->f_path.dentry;
 	int bindex, bstart, bend;
 
-	unionfs_read_lock(file->f_path.dentry->d_sb);
+	unionfs_read_lock(dentry->d_sb);
 
 	if ((err = unionfs_file_revalidate(file, 1)))
 		goto out;
@@ -745,6 +745,6 @@ int unionfs_flush(struct file *file, fl_owner_t id)
 out_lock:
 	unionfs_unlock_dentry(dentry);
 out:
-	unionfs_read_unlock(file->f_path.dentry->d_sb);
+	unionfs_read_unlock(dentry->d_sb);
 	return err;
 }
-- 
1.5.2.2.238.g7cbf2f2

