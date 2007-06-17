Return-Path: <linux-kernel-owner+w=401wt.eu-S1759721AbXFQTOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759721AbXFQTOr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 15:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760108AbXFQTKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 15:10:35 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:36888 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761201AbXFQTKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 15:10:10 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 08/16] Unionfs: Remove unnecessary #define
Date: Sun, 17 Jun 2007 15:09:15 -0400
Message-Id: <11821073643763-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
In-Reply-To: <11821073632989-git-send-email-jsipek@cs.sunysb.edu>
References: <11821073632989-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

UNIONFS_TMPNAM_LEN is used in only one place, and we have calculate the
length of the string to begin with.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/commonfops.c |    2 +-
 fs/unionfs/union.h      |    3 ---
 2 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index 28635d8..db8c334 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -64,7 +64,7 @@ retry:
 		       dentry->d_name.name, name);
 
 		tmp_dentry = lookup_one_len(name, hidden_dentry->d_parent,
-					    UNIONFS_TMPNAM_LEN);
+					    nlen);
 		if (IS_ERR(tmp_dentry)) {
 			err = PTR_ERR(tmp_dentry);
 			goto out;
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 335d579..01e29f3 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -54,9 +54,6 @@
 /* unionfs root inode number */
 #define UNIONFS_ROOT_INO     1
 
-/* number of characters while generating unique temporary file names */
-#define	UNIONFS_TMPNAM_LEN	12
-
 /* number of times we try to get a unique temporary file name */
 #define GET_TMPNAM_MAX_RETRY	5
 
-- 
1.5.2.rc1.165.gaf9b

