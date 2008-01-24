Return-Path: <linux-kernel-owner+w=401wt.eu-S1758126AbYAXTkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126AbYAXTkY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 14:40:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756163AbYAXTfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 14:35:24 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46569 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361AbYAXTes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 14:34:48 -0500
Message-Id: <20080124193443.306296794@szeredi.hu>
References: <20080124193341.166753833@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 24 Jan 2008 20:33:59 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 18/26] mount options: fix isofs
Content-Disposition: inline; filename=isofs_opts.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add a .show_options super operation to isofs.

Use generic_show_options() and save the complete option string in
isofs_fill_super().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/isofs/inode.c
===================================================================
--- linux.orig/fs/isofs/inode.c	2008-01-17 19:00:55.000000000 +0100
+++ linux/fs/isofs/inode.c	2008-01-23 22:07:51.000000000 +0100
@@ -110,6 +110,7 @@ static const struct super_operations iso
 	.put_super	= isofs_put_super,
 	.statfs		= isofs_statfs,
 	.remount_fs	= isofs_remount,
+	.show_options	= generic_show_options,
 };
 
 
@@ -554,6 +555,8 @@ static int isofs_fill_super(struct super
 	int table, error = -EINVAL;
 	unsigned int vol_desc_start;
 
+	save_mount_options(s, data);
+
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
 		return -ENOMEM;

--
