Return-Path: <linux-kernel-owner+w=401wt.eu-S1754421AbZKBKHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbZKBKHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:07:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754400AbZKBKHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:07:20 -0500
Received: from cantor.suse.de ([195.135.220.2]:47301 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754401AbZKBKHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:07:04 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 22/27] BKL: Remove BKL from openpromfs
Date: Mon,  2 Nov 2009 11:05:02 +0100
Message-Id: <1257156307-24175-23-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1257156307-24175-1-git-send-email-jblunck@suse.de>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BKL is only used in fill_super and get_sb_single() is used. It is safe to
remove it.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/openpromfs/inode.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/openpromfs/inode.c b/fs/openpromfs/inode.c
index 50dc4be..ffcd04f 100644
--- a/fs/openpromfs/inode.c
+++ b/fs/openpromfs/inode.c
@@ -386,8 +386,6 @@ static int openprom_fill_super(struct super_block *s, void *data, int silent)
 	struct op_inode_info *oi;
 	int ret;
 
-	lock_kernel();
-
 	s->s_flags |= MS_NOATIME;
 	s->s_blocksize = 1024;
 	s->s_blocksize_bits = 10;
@@ -407,7 +405,6 @@ static int openprom_fill_super(struct super_block *s, void *data, int silent)
 	s->s_root = d_alloc_root(root_inode);
 	if (!s->s_root)
 		goto out_no_root_dentry;
-	unlock_kernel();
 	return 0;
 
 out_no_root_dentry:
@@ -415,7 +412,6 @@ out_no_root_dentry:
 	ret = -ENOMEM;
 out_no_root:
 	printk("openprom_fill_super: get root inode failed\n");
-	unlock_kernel();
 	return ret;
 }
 
-- 
1.6.4.2

