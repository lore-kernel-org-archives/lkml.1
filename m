Return-Path: <linux-kernel-owner+w=401wt.eu-S1754139AbXFKOdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbXFKOdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 10:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753769AbXFKOci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 10:32:38 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:53674 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709AbXFKOch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 10:32:37 -0400
To: akpm@osdl.org
CC: adobriyan@gmail.com, linux-kernel@vger.kernel.org
Subject: [mm patch] fuse: fix double fs_flags initializer
Message-Id: <E1HxkwN-0006iA-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 11 Jun 2007 16:32:19 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Thanks to Alexey Dobriyan for spotting the other one.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/inode.c
===================================================================
--- linux.orig/fs/fuse/inode.c	2007-06-11 16:14:46.000000000 +0200
+++ linux/fs/fuse/inode.c	2007-06-11 16:20:14.000000000 +0200
@@ -659,10 +659,9 @@ static int fuse_get_sb(struct file_syste
 static struct file_system_type fuse_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "fuse",
-	.fs_flags	= FS_HAS_SUBTYPE,
 	.get_sb		= fuse_get_sb,
 	.kill_sb	= kill_anon_super,
-	.fs_flags	= FS_SAFE,
+	.fs_flags	= FS_HAS_SUBTYPE | FS_SAFE,
 };
 
 #ifdef CONFIG_BLOCK
