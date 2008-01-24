Return-Path: <linux-kernel-owner+w=401wt.eu-S1757903AbYAXTjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903AbYAXTjX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 14:39:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754163AbYAXTfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 14:35:14 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46555 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756171AbYAXTej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 14:34:39 -0500
Message-Id: <20080124193435.863860304@szeredi.hu>
References: <20080124193341.166753833@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 24 Jan 2008 20:33:55 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 14/26] mount options: fix fuse
Content-Disposition: inline; filename=fuse_opts.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add blksize= option to /proc/mounts for fuseblk filesystems.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/inode.c
===================================================================
--- linux.orig/fs/fuse/inode.c	2008-01-19 11:56:34.000000000 +0100
+++ linux/fs/fuse/inode.c	2008-01-21 17:53:06.000000000 +0100
@@ -29,6 +29,8 @@ DEFINE_MUTEX(fuse_mutex);
 
 #define FUSE_SUPER_MAGIC 0x65735546
 
+#define FUSE_DEFAULT_BLKSIZE 512
+
 struct fuse_mount_data {
 	int fd;
 	unsigned rootmode;
@@ -355,7 +357,7 @@ static int parse_fuse_opt(char *opt, str
 	char *p;
 	memset(d, 0, sizeof(struct fuse_mount_data));
 	d->max_read = ~0;
-	d->blksize = 512;
+	d->blksize = FUSE_DEFAULT_BLKSIZE;
 
 	while ((p = strsep(&opt, ",")) != NULL) {
 		int token;
@@ -440,6 +442,9 @@ static int fuse_show_options(struct seq_
 		seq_puts(m, ",allow_other");
 	if (fc->max_read != ~0)
 		seq_printf(m, ",max_read=%u", fc->max_read);
+	if (mnt->mnt_sb->s_bdev &&
+	    mnt->mnt_sb->s_blocksize != FUSE_DEFAULT_BLKSIZE)
+		seq_printf(m, ",blksize=%lu", mnt->mnt_sb->s_blocksize);
 	return 0;
 }
 

--
