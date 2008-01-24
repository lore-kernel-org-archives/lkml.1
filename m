Return-Path: <linux-kernel-owner+w=401wt.eu-S1757032AbYAXTgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032AbYAXTgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 14:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756421AbYAXTev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 14:34:51 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46525 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151AbYAXTe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 14:34:27 -0500
Message-Id: <20080124193423.239049229@szeredi.hu>
References: <20080124193341.166753833@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 24 Jan 2008 20:33:47 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 06/26] mount options: fix autofs4
Content-Disposition: inline; filename=autofs4_opts.patch
Cc: Ian Kent <raven@themaw.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add uid= and gid= options to /proc/mounts for autofs4 filesystems.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/autofs4/inode.c
===================================================================
--- linux.orig/fs/autofs4/inode.c	2008-01-22 15:52:42.000000000 +0100
+++ linux/fs/autofs4/inode.c	2008-01-22 23:36:02.000000000 +0100
@@ -188,11 +188,16 @@ out_kill_sb:
 static int autofs4_show_options(struct seq_file *m, struct vfsmount *mnt)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(mnt->mnt_sb);
+	struct inode *root_inode = mnt->mnt_sb->s_root->d_inode;
 
 	if (!sbi)
 		return 0;
 
 	seq_printf(m, ",fd=%d", sbi->pipefd);
+	if (root_inode->i_uid != 0)
+		seq_printf(m, ",uid=%u", root_inode->i_uid);
+	if (root_inode->i_gid != 0)
+		seq_printf(m, ",gid=%u", root_inode->i_gid);
 	seq_printf(m, ",pgrp=%d", sbi->oz_pgrp);
 	seq_printf(m, ",timeout=%lu", sbi->exp_timeout/HZ);
 	seq_printf(m, ",minproto=%d", sbi->min_proto);

--
