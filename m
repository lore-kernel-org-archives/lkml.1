Return-Path: <linux-kernel-owner+w=401wt.eu-S1759601AbXFLHHC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759601AbXFLHHC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 03:07:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758584AbXFLHAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 03:00:48 -0400
Received: from brick.kernel.dk ([80.160.20.94]:13569 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119AbXFLHAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 03:00:32 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 15/18] sendfile: remove bad_sendfile() from bad_file_ops
Date: Tue, 12 Jun 2007 08:58:11 +0200
Message-Id: <11816314951861-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.1.174.gcd03
In-Reply-To: <11816314942627-git-send-email-jens.axboe@oracle.com>
References: <11816314942627-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

do_sendfile() prefers splice over sendfile, so it should not trigger
(directly, at least).

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/bad_inode.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index 329ee47..521ff7c 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -114,12 +114,6 @@ static int bad_file_lock(struct file *file, int cmd, struct file_lock *fl)
 	return -EIO;
 }
 
-static ssize_t bad_file_sendfile(struct file *in_file, loff_t *ppos,
-			size_t count, read_actor_t actor, void *target)
-{
-	return -EIO;
-}
-
 static ssize_t bad_file_sendpage(struct file *file, struct page *page,
 			int off, size_t len, loff_t *pos, int more)
 {
@@ -182,7 +176,6 @@ static const struct file_operations bad_file_ops =
 	.aio_fsync	= bad_file_aio_fsync,
 	.fasync		= bad_file_fasync,
 	.lock		= bad_file_lock,
-	.sendfile	= bad_file_sendfile,
 	.sendpage	= bad_file_sendpage,
 	.get_unmapped_area = bad_file_get_unmapped_area,
 	.check_flags	= bad_file_check_flags,
-- 
1.5.2.1.174.gcd03

