Return-Path: <linux-kernel-owner+w=401wt.eu-S1765311AbXKOLUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765311AbXKOLUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 06:20:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760532AbXKOLTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 06:19:53 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:54925 "EHLO
	dorka.pomaz.szeredi.hu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754371AbXKOLTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 06:19:52 -0500
To: akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org
In-reply-to: <E1Iscir-0000SZ-00@dorka.pomaz.szeredi.hu> (message from Miklos
	Szeredi on Thu, 15 Nov 2007 12:17:25 +0100)
Subject: [PATCH 2/2] fuse: fix attribute caching after rename
References: <E1Iscir-0000SZ-00@dorka.pomaz.szeredi.hu>
Message-Id: <E1Isckb-0000T2-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 15 Nov 2007 12:19:13 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Invalidate attributes on rename, since some filesystems may update
st_ctime.  Reported by Szabolcs Szakacsits

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux-2.6.24-rc2/fs/fuse/dir.c
===================================================================
--- linux-2.6.24-rc2.orig/fs/fuse/dir.c	2007-11-13 18:43:40.000000000 +0100
+++ linux-2.6.24-rc2/fs/fuse/dir.c	2007-11-13 18:44:58.000000000 +0100
@@ -646,6 +646,9 @@ static int fuse_rename(struct inode *old
 	err = req->out.h.error;
 	fuse_put_request(fc, req);
 	if (!err) {
+		/* ctime changes */
+		fuse_invalidate_attr(oldent->d_inode);
+
 		fuse_invalidate_attr(olddir);
 		if (olddir != newdir)
 			fuse_invalidate_attr(newdir);
