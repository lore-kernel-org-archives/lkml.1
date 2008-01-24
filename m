Return-Path: <linux-kernel-owner+w=401wt.eu-S1756747AbYAXTgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbYAXTgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 14:36:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756389AbYAXTeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 14:34:50 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46526 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369AbYAXTe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 14:34:28 -0500
Message-Id: <20080124193424.681167891@szeredi.hu>
References: <20080124193341.166753833@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 24 Jan 2008 20:33:48 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 07/26] mount options: fix autofs
Content-Disposition: inline; filename=autofs_opts.patch
Cc: "H. Peter Anvin" <hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add a .show_options super operation to autofs.

Use generic_show_options() and save the complete option string in
autofs_fill_super().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/autofs/inode.c
===================================================================
--- linux.orig/fs/autofs/inode.c	2008-01-17 19:00:54.000000000 +0100
+++ linux/fs/autofs/inode.c	2008-01-24 11:16:30.000000000 +0100
@@ -54,6 +54,7 @@ out_kill_sb:
 
 static const struct super_operations autofs_sops = {
 	.statfs		= simple_statfs,
+	.show_options	= generic_show_options,
 };
 
 enum {Opt_err, Opt_fd, Opt_uid, Opt_gid, Opt_pgrp, Opt_minproto, Opt_maxproto};
@@ -140,6 +141,8 @@ int autofs_fill_super(struct super_block
 	int minproto, maxproto;
 	pid_t pgid;
 
+	save_mount_options(s, data);
+
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
 		goto fail_unlock;

--
