Return-Path: <linux-kernel-owner+w=401wt.eu-S1756143AbYAXThM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbYAXThM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 14:37:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756549AbYAXTe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 14:34:58 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46536 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060AbYAXTeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 14:34:31 -0500
Message-Id: <20080124193426.214262500@szeredi.hu>
References: <20080124193341.166753833@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 24 Jan 2008 20:33:49 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 08/26] mount options: fix befs
Content-Disposition: inline; filename=befs_opts.patch
Cc: "Sergey S. Kostyliov" <rathamahata@php4.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add a .show_options super operation to befs.

Use generic_show_options() and save the complete option string in
befs_fill_super().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/befs/linuxvfs.c
===================================================================
--- linux.orig/fs/befs/linuxvfs.c	2008-01-17 19:00:54.000000000 +0100
+++ linux/fs/befs/linuxvfs.c	2008-01-22 21:40:05.000000000 +0100
@@ -57,6 +57,7 @@ static const struct super_operations bef
 	.put_super	= befs_put_super,	/* uninit super */
 	.statfs		= befs_statfs,	/* statfs */
 	.remount_fs	= befs_remount,
+	.show_options	= generic_show_options,
 };
 
 /* slab cache for befs_inode_info objects */
@@ -759,10 +760,11 @@ befs_fill_super(struct super_block *sb, 
 	befs_super_block *disk_sb;
 	struct inode *root;
 	long ret = -EINVAL;
-
 	const unsigned long sb_block = 0;
 	const off_t x86_sb_off = 512;
 
+	save_mount_options(sb, data);
+
 	sb->s_fs_info = kmalloc(sizeof (*befs_sb), GFP_KERNEL);
 	if (sb->s_fs_info == NULL) {
 		printk(KERN_ERR

--
