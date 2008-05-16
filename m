Return-Path: <linux-kernel-owner+w=401wt.eu-S1759888AbYEPQg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759888AbYEPQg0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 12:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757226AbYEPQcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 12:32:46 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33726 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756808AbYEPQcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 12:32:39 -0400
Message-Id: <20080516163226.007338262@szeredi.hu>
References: <20080516163136.560107038@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 16 May 2008 18:31:45 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 09/22] vfs: truncate: dont check immutable twice
Content-Disposition: inline; filename=truncate_immutable_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

vfs_permission(MAY_WRITE) already checked for the inode being
immutable, so no need to repeat it.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/open.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/fs/open.c
===================================================================
--- linux-2.6.orig/fs/open.c	2008-05-16 17:50:45.000000000 +0200
+++ linux-2.6/fs/open.c	2008-05-16 17:50:46.000000000 +0200
@@ -254,7 +254,7 @@ static long do_sys_truncate(const char _
 		goto mnt_drop_write_and_out;
 
 	error = -EPERM;
-	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
+	if (IS_APPEND(inode))
 		goto mnt_drop_write_and_out;
 
 	error = get_write_access(inode);

--
