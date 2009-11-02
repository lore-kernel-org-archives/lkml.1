Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbZKBKKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbZKBKKu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:10:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754523AbZKBKHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:07:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58540 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402AbZKBKHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:07:04 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Coly Li <coly.li@suse.de>, David VomLehn <dvomlehn@cisco.com>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 14/27] BKL: Remove BKL from cramfs
Date: Mon,  2 Nov 2009 11:04:54 +0100
Message-Id: <1257156307-24175-15-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1257156307-24175-1-git-send-email-jblunck@suse.de>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BKL is only used in fill_super. It is safe to remove it.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/cramfs/inode.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index 13e696a..dd3634e 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -227,15 +227,11 @@ static int cramfs_fill_super(struct super_block *sb, void *data, int silent)
 	struct cramfs_sb_info *sbi;
 	struct inode *root;
 
-	lock_kernel();
-
 	sb->s_flags |= MS_RDONLY;
 
 	sbi = kzalloc(sizeof(struct cramfs_sb_info), GFP_KERNEL);
-	if (!sbi) {
-		unlock_kernel();
+	if (!sbi)
 		return -ENOMEM;
-	}
 	sb->s_fs_info = sbi;
 
 	/* Invalidate the read buffers on mount: think disk change.. */
@@ -312,12 +308,10 @@ static int cramfs_fill_super(struct super_block *sb, void *data, int silent)
 		iput(root);
 		goto out;
 	}
-	unlock_kernel();
 	return 0;
 out:
 	kfree(sbi);
 	sb->s_fs_info = NULL;
-	unlock_kernel();
 	return -EINVAL;
 }
 
-- 
1.6.4.2

