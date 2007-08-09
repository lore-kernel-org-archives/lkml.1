Return-Path: <linux-kernel-owner+w=401wt.eu-S939115AbXHIJab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939115AbXHIJab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 05:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938825AbXHIJ0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 05:26:24 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:39021 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938803AbXHIJ0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 05:26:23 -0400
Message-Id: <20070809092528.169389391@szeredi.hu>
References: <20070809092046.656183199@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 09 Aug 2007 11:20:55 +0200
From: miklos@szeredi.hu
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 9/9] fix warnings is revoked_inode.c
Content-Disposition: inline; filename=mm_fix_bothersome_warning.patch
CC: Nick Piggin <npiggin@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Fix following warnings introduced by
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch 

fs/revoked_inode.c:381: warning: ‘revoked_write_begin’ defined but not used
fs/revoked_inode.c:388: warning: ‘revoked_write_end’ defined but not used

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/revoked_inode.c
===================================================================
--- linux.orig/fs/revoked_inode.c	2007-08-09 11:01:55.000000000 +0200
+++ linux/fs/revoked_inode.c	2007-08-09 11:04:37.000000000 +0200
@@ -363,18 +363,6 @@ static int revoked_writepage(struct page
 	return -EIO;
 }
 
-static int revoked_prepare_write(struct file *file, struct page *page,
-				 unsigned from, unsigned to)
-{
-	return -EIO;
-}
-
-static int revoked_commit_write(struct file *file, struct page *page,
-				unsigned from, unsigned to)
-{
-	return -EIO;
-}
-
 static int revoked_write_begin(struct file *file, struct address_space *mapping,
 				loff_t pos, unsigned len, unsigned flags,
 				struct page **pagep, void **fsdata)
@@ -399,8 +387,8 @@ static ssize_t revoked_direct_IO(int rw,
 static const struct address_space_operations revoked_aops = {
         .readpage       = revoked_readpage,
         .writepage      = revoked_writepage,
-        .prepare_write  = revoked_prepare_write,
-        .commit_write   = revoked_commit_write,
+	.write_begin	= revoked_write_begin,
+	.write_end	= revoked_write_end,
         .direct_IO      = revoked_direct_IO,
 };
 

--
