Return-Path: <linux-kernel-owner+w=401wt.eu-S1754486AbZKBKHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbZKBKHI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:07:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754435AbZKBKHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:07:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58539 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403AbZKBKHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:07:04 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Coly Li <coly.li@suse.de>
Subject: [PATCH 16/27] BKL: Remove BKL from efs
Date: Mon,  2 Nov 2009 11:04:56 +0100
Message-Id: <1257156307-24175-17-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1257156307-24175-1-git-send-email-jblunck@suse.de>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BKL is only used in fill_super. It is safe to remove it.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/efs/super.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/efs/super.c b/fs/efs/super.c
index 0981141..f049428 100644
--- a/fs/efs/super.c
+++ b/fs/efs/super.c
@@ -249,13 +249,9 @@ static int efs_fill_super(struct super_block *s, void *d, int silent)
 	struct inode *root;
 	int ret = -EINVAL;
 
-	lock_kernel();
-
-	sb = kzalloc(sizeof(struct efs_sb_info), GFP_KERNEL);
-	if (!sb) {
-		unlock_kernel();
+ 	sb = kzalloc(sizeof(struct efs_sb_info), GFP_KERNEL);
+	if (!sb)
 		return -ENOMEM;
-	}
 	s->s_fs_info = sb;
  
 	s->s_magic		= EFS_SUPER_MAGIC;
@@ -323,14 +319,12 @@ static int efs_fill_super(struct super_block *s, void *d, int silent)
 		goto out_no_fs;
 	}
 
-	unlock_kernel();
 	return 0;
 
 out_no_fs_ul:
 out_no_fs:
 	s->s_fs_info = NULL;
 	kfree(sb);
-	unlock_kernel();
 	return ret;
 }
 
-- 
1.6.4.2

