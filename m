Return-Path: <linux-kernel-owner+w=401wt.eu-S1757935AbYAXTl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935AbYAXTl1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 14:41:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756618AbYAXTf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 14:35:27 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46588 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721AbYAXTe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 14:34:56 -0500
Message-Id: <20080124193452.416385893@szeredi.hu>
References: <20080124193341.166753833@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 24 Jan 2008 20:34:04 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 23/26] mount options: fix spufs
Content-Disposition: inline; filename=spufs_opts.patch
Cc: Paul Mackerras <paulus@samba.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add a .show_options super operation to spufs.

Use generic_show_options() and save the complete option string in
spufs_fill_super().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/arch/powerpc/platforms/cell/spufs/inode.c
===================================================================
--- linux.orig/arch/powerpc/platforms/cell/spufs/inode.c	2008-01-17 19:00:52.000000000 +0100
+++ linux/arch/powerpc/platforms/cell/spufs/inode.c	2008-01-23 23:44:36.000000000 +0100
@@ -744,8 +744,11 @@ spufs_fill_super(struct super_block *sb,
 		.statfs = simple_statfs,
 		.delete_inode = spufs_delete_inode,
 		.drop_inode = generic_delete_inode,
+		.show_options = generic_show_options,
 	};
 
+	save_mount_options(sb, data);
+
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
 	sb->s_blocksize = PAGE_CACHE_SIZE;
 	sb->s_blocksize_bits = PAGE_CACHE_SHIFT;

--
