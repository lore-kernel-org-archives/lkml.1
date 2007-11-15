Return-Path: <linux-kernel-owner+w=401wt.eu-S1762967AbXKOLSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762967AbXKOLSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 06:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755258AbXKOLSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 06:18:08 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:54920 "EHLO
	dorka.pomaz.szeredi.hu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754270AbXKOLSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 06:18:07 -0500
To: akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] fuse: fix uninitialized field in fuse_inode
Message-Id: <E1Iscir-0000SZ-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 15 Nov 2007 12:17:25 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Please queue these two fixes for 2.6.24, along with the rest of the
fuse patches currently in -mm.

Thanks,
Miklos

----
From: John Muir <muirj@nortel.com>

I found problems accessing (executing) previously existing files, until
I did chmod on them (or setattr).

If the fi->attr_version is not initialized, then it could be
larger than fc->attr_version until a setattr is executed, and as a
result the inode attributes would never be set.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/inode.c
===================================================================
--- linux.orig/fs/fuse/inode.c	2007-11-13 17:44:53.000000000 +0100
+++ linux/fs/fuse/inode.c	2007-11-13 17:49:13.000000000 +0100
@@ -56,6 +56,7 @@ static struct inode *fuse_alloc_inode(st
 	fi->i_time = 0;
 	fi->nodeid = 0;
 	fi->nlookup = 0;
+	fi->attr_version = 0;
 	INIT_LIST_HEAD(&fi->write_files);
 	fi->forget_req = fuse_request_alloc();
 	if (!fi->forget_req) {
