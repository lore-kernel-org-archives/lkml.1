Return-Path: <linux-kernel-owner+w=401wt.eu-S1754600AbZKBKKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbZKBKKj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754429AbZKBKHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:07:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58542 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754404AbZKBKHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:07:04 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, Coly Li <coly.li@suse.de>,
       Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 20/27] BKL: Remove BKL from minix
Date: Mon,  2 Nov 2009 11:05:00 +0100
Message-Id: <1257156307-24175-21-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1257156307-24175-1-git-send-email-jblunck@suse.de>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BKL is only used in fill_super. It is safe to remove it.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/minix/inode.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index b8aa0a6..74ea82d 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -147,13 +147,9 @@ static int minix_fill_super(struct super_block *s, void *data, int silent)
 	struct minix_sb_info *sbi;
 	int ret = -EINVAL;
 
-	lock_kernel();
-
 	sbi = kzalloc(sizeof(struct minix_sb_info), GFP_KERNEL);
-	if (!sbi) {
-		unlock_kernel();
+	if (!sbi)
 		return -ENOMEM;
-	}
 	s->s_fs_info = sbi;
 
 	BUILD_BUG_ON(32 != sizeof (struct minix_inode));
@@ -269,7 +265,6 @@ static int minix_fill_super(struct super_block *s, void *data, int silent)
  	else if (sbi->s_mount_state & MINIX_ERROR_FS)
 		printk("MINIX-fs: mounting file system with errors, "
 			"running fsck is recommended\n");
-	unlock_kernel();
 	return 0;
 
 out_iput:
@@ -319,7 +314,6 @@ out_bad_sb:
 out:
 	s->s_fs_info = NULL;
 	kfree(sbi);
-	unlock_kernel();
 	return ret;
 }
 
-- 
1.6.4.2

