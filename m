Return-Path: <linux-kernel-owner+w=401wt.eu-S1765795AbXG2PEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765795AbXG2PEQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764336AbXG2O6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 10:58:17 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47805 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764335AbXG2O6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 10:58:15 -0400
Date: Sun, 29 Jul 2007 16:57:52 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] remove mm/filemap.c:file_send_actor()
Message-ID: <20070729145752.GR16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the no longer used file_send_actor().

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 include/linux/fs.h |    1 -
 mm/filemap.c       |   20 --------------------
 2 files changed, 21 deletions(-)

--- linux-2.6.23-rc1-mm1/include/linux/fs.h.old	2007-07-26 14:57:09.000000000 +0200
+++ linux-2.6.23-rc1-mm1/include/linux/fs.h	2007-07-26 14:57:15.000000000 +0200
@@ -1776,7 +1776,6 @@
 extern int generic_file_mmap(struct file *, struct vm_area_struct *);
 extern int generic_file_readonly_mmap(struct file *, struct vm_area_struct *);
 extern int file_read_actor(read_descriptor_t * desc, struct page *page, unsigned long offset, unsigned long size);
-extern int file_send_actor(read_descriptor_t * desc, struct page *page, unsigned long offset, unsigned long size);
 int generic_write_checks(struct file *file, loff_t *pos, size_t *count, int isblk);
 extern ssize_t generic_file_aio_read(struct kiocb *, const struct iovec *, unsigned long, loff_t);
 extern ssize_t generic_file_aio_write(struct kiocb *, const struct iovec *, unsigned long, loff_t);
--- linux-2.6.23-rc1-mm1/mm/filemap.c.old	2007-07-26 14:59:05.000000000 +0200
+++ linux-2.6.23-rc1-mm1/mm/filemap.c	2007-07-26 14:59:16.000000000 +0200
@@ -1205,26 +1205,6 @@
 }
 EXPORT_SYMBOL(generic_file_aio_read);
 
-int file_send_actor(read_descriptor_t * desc, struct page *page, unsigned long offset, unsigned long size)
-{
-	ssize_t written;
-	unsigned long count = desc->count;
-	struct file *file = desc->arg.data;
-
-	if (size > count)
-		size = count;
-
-	written = file->f_op->sendpage(file, page, offset,
-				       size, &file->f_pos, size<count);
-	if (written < 0) {
-		desc->error = written;
-		written = 0;
-	}
-	desc->count = count - written;
-	desc->written += written;
-	return written;
-}
-
 static ssize_t
 do_readahead(struct address_space *mapping, struct file *filp,
 	     pgoff_t index, unsigned long nr)

