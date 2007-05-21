Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbXEUJm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbXEUJm3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 05:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755065AbXEUJmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 05:42:21 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:60750 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbXEUJmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 05:42:20 -0400
To: akpm@linux-foundation.org, stable@kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [patch] fuse: fix mknod of regular file
Message-Id: <E1Hq4Mw-0002qK-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 21 May 2007 11:39:58 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

The wrong lookup flag was tested in ->create() causing havoc (error or
Oops) when a regular file was created with mknod() in a fuse
filesystem.

Thanks to J. Cameijo Cerdeira for the report.

Kernels 2.6.18 onward are affected.  Please apply to -stable as well.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/dir.c
===================================================================
--- linux.orig/fs/fuse/dir.c	2007-05-21 11:34:32.000000000 +0200
+++ linux/fs/fuse/dir.c	2007-05-21 11:34:34.000000000 +0200
@@ -485,7 +485,7 @@ static int fuse_mknod(struct inode *dir,
 static int fuse_create(struct inode *dir, struct dentry *entry, int mode,
 		       struct nameidata *nd)
 {
-	if (nd && (nd->flags & LOOKUP_CREATE)) {
+	if (nd && (nd->flags & LOOKUP_OPEN)) {
 		int err = fuse_create_open(dir, entry, mode, nd);
 		if (err != -ENOSYS)
 			return err;
