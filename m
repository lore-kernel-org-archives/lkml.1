Return-Path: <linux-kernel-owner+w=401wt.eu-S1758253AbYAXTnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758253AbYAXTnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 14:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756746AbYAXTf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 14:35:57 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46566 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756320AbYAXTer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 14:34:47 -0500
Message-Id: <20080124193441.886260037@szeredi.hu>
References: <20080124193341.166753833@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 24 Jan 2008 20:33:58 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 17/26] mount options: fix hugetlbfs
Content-Disposition: inline; filename=hugetlbfs_opts.patch
Cc: William Irwin <wli@holomorphy.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add a .show_options super operation to hugetlbfs.

Use generic_show_options() and save the complete option string in
hugetlbfs_fill_super().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/hugetlbfs/inode.c
===================================================================
--- linux.orig/fs/hugetlbfs/inode.c	2008-01-22 21:31:53.000000000 +0100
+++ linux/fs/hugetlbfs/inode.c	2008-01-22 21:32:20.000000000 +0100
@@ -734,6 +734,7 @@ static const struct super_operations hug
 	.delete_inode	= hugetlbfs_delete_inode,
 	.drop_inode	= hugetlbfs_drop_inode,
 	.put_super	= hugetlbfs_put_super,
+	.show_options	= generic_show_options,
 };
 
 static int
@@ -817,6 +818,8 @@ hugetlbfs_fill_super(struct super_block 
 	struct hugetlbfs_config config;
 	struct hugetlbfs_sb_info *sbinfo;
 
+	save_mount_options(sb, data);
+
 	config.nr_blocks = -1; /* No limit on size by default */
 	config.nr_inodes = -1; /* No limit on number of inodes by default */
 	config.uid = current->fsuid;

--
