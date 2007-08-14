Return-Path: <linux-kernel-owner+w=401wt.eu-S932331AbXHNVgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331AbXHNVgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756820AbXHNVXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:23:33 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:38458 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756288AbXHNVXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:23:32 -0400
Date: Tue, 14 Aug 2007 23:23:23 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] make fs/libfs.c:simple_commit_write() static
Message-ID: <20070814212323.GO18945@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

simple_commit_write() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 13 Jul 2007
- 15 Jun 2007

 fs/libfs.c         |    5 ++---
 include/linux/fs.h |    2 --
 2 files changed, 2 insertions(+), 5 deletions(-)

--- linux-2.6.22-rc4-mm2/include/linux/fs.h.old	2007-06-14 02:05:36.000000000 +0200
+++ linux-2.6.22-rc4-mm2/include/linux/fs.h	2007-06-14 02:05:43.000000000 +0200
@@ -1973,8 +1973,6 @@
 extern int simple_readpage(struct file *file, struct page *page);
 extern int simple_prepare_write(struct file *file, struct page *page,
 			unsigned offset, unsigned to);
-extern int simple_commit_write(struct file *file, struct page *page,
-				unsigned offset, unsigned to);
 extern int simple_write_begin(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned flags,
 			struct page **pagep, void **fsdata);
--- linux-2.6.22-rc4-mm2/fs/libfs.c.old	2007-06-14 02:05:50.000000000 +0200
+++ linux-2.6.22-rc4-mm2/fs/libfs.c	2007-06-14 02:06:16.000000000 +0200
@@ -371,8 +371,8 @@
 	return simple_prepare_write(file, page, from, from+len);
 }
 
-int simple_commit_write(struct file *file, struct page *page,
-			unsigned from, unsigned to)
+static int simple_commit_write(struct file *file, struct page *page,
+			       unsigned from, unsigned to)
 {
 	struct inode *inode = page->mapping->host;
 	loff_t pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
@@ -686,7 +686,6 @@
 EXPORT_SYMBOL(get_sb_pseudo);
 EXPORT_SYMBOL(simple_write_begin);
 EXPORT_SYMBOL(simple_write_end);
-EXPORT_SYMBOL(simple_commit_write);
 EXPORT_SYMBOL(simple_dir_inode_operations);
 EXPORT_SYMBOL(simple_dir_operations);
 EXPORT_SYMBOL(simple_empty);

