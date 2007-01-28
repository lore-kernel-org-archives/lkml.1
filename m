Return-Path: <linux-kernel-owner+w=401wt.eu-S932541AbXA1NSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932541AbXA1NSK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 08:18:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932412AbXA1NSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 08:18:09 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:6440 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932173AbXA1NSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 08:18:08 -0500
To: linux-kernel@vger.kernel.org
CC: ext4 development <linux-ext4@vger.kernel.org>, <devel@openvz.org>
Subject: [PATCH] :EXT[3,4] jbd layer function called instead of fs specific one
From: Dmitriy Monakhov <dmonakhov@openvz.org>
Date: Sun, 28 Jan 2007 16:18:24 +0300
Message-ID: <873b5vmgrj.fsf@sw.ru>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

jbd function called instead of fs specific one.

Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>
------

--=-=-=
Content-Disposition: inline; filename=diff-ms-fs-ext_3_4-cleanup

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index beaf25f..8a824f4 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -947,7 +947,7 @@ out:
 static int ext3_get_block(struct inode *inode, sector_t iblock,
 			struct buffer_head *bh_result, int create)
 {
-	handle_t *handle = journal_current_handle();
+	handle_t *handle = ext3_journal_current_handle();
 	int ret = 0;
 	unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
 
@@ -1717,7 +1717,7 @@ static ssize_t ext3_direct_IO(int rw, st
 	/*
 	 * Reacquire the handle: ext3_get_block() can restart the transaction
 	 */
-	handle = journal_current_handle();
+	handle = ext3_journal_current_handle();
 
 out_stop:
 	if (handle) {
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a127cc0..fbff4b9 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -946,7 +946,7 @@ out:
 static int ext4_get_block(struct inode *inode, sector_t iblock,
 			struct buffer_head *bh_result, int create)
 {
-	handle_t *handle = journal_current_handle();
+	handle_t *handle = ext4_journal_current_handle();
 	int ret = 0;
 	unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
 
@@ -1716,7 +1716,7 @@ static ssize_t ext4_direct_IO(int rw, st
 	/*
 	 * Reacquire the handle: ext4_get_block() can restart the transaction
 	 */
-	handle = journal_current_handle();
+	handle = ext4_journal_current_handle();
 
 out_stop:
 	if (handle) {

--=-=-=--

