Return-Path: <linux-kernel-owner+w=401wt.eu-S1759811AbXERKgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759811AbXERKgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 06:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755705AbXERKga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 06:36:30 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:59582 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578AbXERKg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 06:36:29 -0400
To: akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org
In-reply-to: <E1Hozmu-0003qO-00@dorka.pomaz.szeredi.hu> (message from Miklos
	Szeredi on Fri, 18 May 2007 12:34:20 +0200)
Subject: [patch 2/2] fuse: delete inode on drop
References: <E1Hozmu-0003qO-00@dorka.pomaz.szeredi.hu>
Message-Id: <E1HozoB-0003qj-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 18 May 2007 12:35:39 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

When inode is dropped (no more references) delete it from cache.

There's not much point in keeping it cached, when a new lookup will
refresh the attributes anyway.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/inode.c
===================================================================
--- linux.orig/fs/fuse/inode.c	2007-05-18 11:32:21.000000000 +0200
+++ linux/fs/fuse/inode.c	2007-05-18 11:47:36.000000000 +0200
@@ -470,6 +470,7 @@ static const struct super_operations fus
 	.destroy_inode  = fuse_destroy_inode,
 	.read_inode	= fuse_read_inode,
 	.clear_inode	= fuse_clear_inode,
+	.drop_inode	= generic_delete_inode,
 	.remount_fs	= fuse_remount_fs,
 	.put_super	= fuse_put_super,
 	.umount_begin	= fuse_umount_begin,
