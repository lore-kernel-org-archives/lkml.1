Return-Path: <linux-kernel-owner+w=401wt.eu-S1765792AbYA2SSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765792AbYA2SSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 13:18:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbYA2SSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 13:18:31 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:39860 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbYA2SSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 13:18:30 -0500
Message-Id: <20080129181826.085333823@szeredi.hu>
References: <20080129181750.616092886@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 29 Jan 2008 19:17:51 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 1/3] fuse: fix attribute caching after create
Content-Disposition: inline; filename=fuse_create_fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Invalidate attributes on create, since st_ctime is updated.  Reported
by Szabolcs Szakacsits

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/dir.c
===================================================================
--- linux.orig/fs/fuse/dir.c	2008-01-29 17:12:56.000000000 +0100
+++ linux/fs/fuse/dir.c	2008-01-29 17:13:04.000000000 +0100
@@ -416,6 +416,7 @@ static int fuse_create_open(struct inode
 	fuse_put_request(fc, forget_req);
 	d_instantiate(entry, inode);
 	fuse_change_entry_timeout(entry, &outentry);
+	fuse_invalidate_attr(dir);
 	file = lookup_instantiate_filp(nd, entry, generic_file_open);
 	if (IS_ERR(file)) {
 		ff->fh = outopen.fh;

--
