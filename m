Return-Path: <linux-kernel-owner+w=401wt.eu-S1762104AbYFXOvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762104AbYFXOvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 10:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757675AbYFXOur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 10:50:47 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58183 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756065AbYFXOup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 10:50:45 -0400
Message-Id: <20080624145042.623178221@szeredi.hu>
References: <20080624145011.722691277@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 24 Jun 2008 16:50:12 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, akpm@linux-foundation.org
Subject: [patch 1/5] vfs: truncate: dont check immutable twice
Content-Disposition: inline; filename=vfs-truncate-dont-check-immutable-twice.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

vfs_permission(MAY_WRITE) already checked for the inode being
immutable, so no need to repeat it.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Christoph Hellwig <hch@infradead.org>
---
 fs/open.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/fs/open.c
===================================================================
--- linux-2.6.orig/fs/open.c	2008-06-11 10:16:13.000000000 +0200
+++ linux-2.6/fs/open.c	2008-06-13 13:15:01.000000000 +0200
@@ -254,7 +254,7 @@ static long do_sys_truncate(const char _
 		goto mnt_drop_write_and_out;
 
 	error = -EPERM;
-	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
+	if (IS_APPEND(inode))
 		goto mnt_drop_write_and_out;
 
 	error = get_write_access(inode);

--
