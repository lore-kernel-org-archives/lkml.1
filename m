Return-Path: <linux-kernel-owner+w=401wt.eu-S1757906AbXJXLP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906AbXJXLP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 07:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755989AbXJXLOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 07:14:42 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:49720 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790AbXJXLOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 07:14:41 -0400
Message-Id: <20071024111430.681596109@szeredi.hu>
References: <20071024111333.530227696@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 24 Oct 2007 13:13:38 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 5/5] fuse: fix FUSE_FILE_OPS sending
Content-Disposition: inline; filename=fuse_file_ops_notyet.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

FUSE_FILE_OPS is meant to signal, that the kernel will send the open
file to to the userspace filesystem for operations on open files, so
that sillyrenaming unlinked files becomes unnecessary.

However this needs VFS changes, which won't make it into 2.6.24.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/inode.c
===================================================================
--- linux.orig/fs/fuse/inode.c	2007-10-24 11:33:40.000000000 +0200
+++ linux/fs/fuse/inode.c	2007-10-24 12:10:31.000000000 +0200
@@ -579,8 +579,7 @@ static void fuse_send_init(struct fuse_c
 	arg->major = FUSE_KERNEL_VERSION;
 	arg->minor = FUSE_KERNEL_MINOR_VERSION;
 	arg->max_readahead = fc->bdi.ra_pages * PAGE_CACHE_SIZE;
-	arg->flags |= FUSE_ASYNC_READ | FUSE_POSIX_LOCKS | FUSE_FILE_OPS |
-		FUSE_ATOMIC_O_TRUNC;
+	arg->flags |= FUSE_ASYNC_READ | FUSE_POSIX_LOCKS | FUSE_ATOMIC_O_TRUNC;
 	req->in.h.opcode = FUSE_INIT;
 	req->in.numargs = 1;
 	req->in.args[0].size = sizeof(*arg);

--
