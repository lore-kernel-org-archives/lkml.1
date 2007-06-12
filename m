Return-Path: <linux-kernel-owner+w=401wt.eu-S1758674AbXFLHAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674AbXFLHAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 03:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbXFLHAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 03:00:31 -0400
Received: from brick.kernel.dk ([80.160.20.94]:13560 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369AbXFLHAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 03:00:30 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 5/18] sendfile: kill generic_file_sendfile()
Date: Tue, 12 Jun 2007 08:58:01 +0200
Message-Id: <11816314952364-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.1.174.gcd03
In-Reply-To: <11816314942627-git-send-email-jens.axboe@oracle.com>
References: <11816314942627-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It's no longer used.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 include/linux/fs.h |    1 -
 mm/filemap.c       |   20 --------------------
 2 files changed, 0 insertions(+), 21 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index b3ae77c..61ebf32 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1735,7 +1735,6 @@ extern ssize_t generic_file_buffered_write(struct kiocb *, const struct iovec *,
 		unsigned long, loff_t, loff_t *, size_t, ssize_t);
 extern ssize_t do_sync_read(struct file *filp, char __user *buf, size_t len, loff_t *ppos);
 extern ssize_t do_sync_write(struct file *filp, const char __user *buf, size_t len, loff_t *ppos);
-extern ssize_t generic_file_sendfile(struct file *, loff_t *, size_t, read_actor_t, void *);
 extern void do_generic_mapping_read(struct address_space *mapping,
 				    struct file_ra_state *, struct file *,
 				    loff_t *, read_descriptor_t *, read_actor_t);
diff --git a/mm/filemap.c b/mm/filemap.c
index edb1b0b..14ad45a 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1245,26 +1245,6 @@ int file_send_actor(read_descriptor_t * desc, struct page *page, unsigned long o
 	return written;
 }
 
-ssize_t generic_file_sendfile(struct file *in_file, loff_t *ppos,
-			 size_t count, read_actor_t actor, void *target)
-{
-	read_descriptor_t desc;
-
-	if (!count)
-		return 0;
-
-	desc.written = 0;
-	desc.count = count;
-	desc.arg.data = target;
-	desc.error = 0;
-
-	do_generic_file_read(in_file, ppos, &desc, actor);
-	if (desc.written)
-		return desc.written;
-	return desc.error;
-}
-EXPORT_SYMBOL(generic_file_sendfile);
-
 static ssize_t
 do_readahead(struct address_space *mapping, struct file *filp,
 	     unsigned long index, unsigned long nr)
-- 
1.5.2.1.174.gcd03

