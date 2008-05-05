Return-Path: <linux-kernel-owner+w=401wt.eu-S1759489AbYEEJ73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489AbYEEJ73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 05:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758602AbYEEJzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 05:55:44 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:38364 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758470AbYEEJzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 05:55:37 -0400
Message-Id: <20080505095530.431609833@szeredi.hu>
References: <20080505095440.820370974@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Mon, 05 May 2008 11:54:55 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>
Subject: [patch 14/15] vfs: utimes immutable fix
Content-Disposition: inline; filename=utimes_immutable_fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

If updating file times to the current time and using a file
descriptor, then don't check for immutable inode, only if the file is
opened for write.  In this case immutability has been checked at open
time.  This is the same as how write() and ftruncate() are handled.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: Ulrich Drepper <drepper@redhat.com>
---
 fs/utimes.c |    3 ---
 1 file changed, 3 deletions(-)

Index: linux-2.6/fs/utimes.c
===================================================================
--- linux-2.6.orig/fs/utimes.c	2008-05-05 11:29:28.000000000 +0200
+++ linux-2.6/fs/utimes.c	2008-05-05 11:29:28.000000000 +0200
@@ -110,9 +110,6 @@ static int do_fd_utimes(int fd, struct t
 		struct inode *inode = file->f_path.dentry->d_inode;
 
 		error = -EACCES;
-		if (IS_IMMUTABLE(inode))
-			goto out_fput;
-
 		if (!is_owner_or_cap(inode) && !(file->f_mode & FMODE_WRITE))
 			goto out_fput;
 	}

--
