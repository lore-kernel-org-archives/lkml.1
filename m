Return-Path: <linux-kernel-owner+w=401wt.eu-S1756114AbZFHTZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbZFHTZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 15:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755140AbZFHTXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 15:23:21 -0400
Received: from thunk.org ([69.25.196.29]:39535 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301AbZFHTXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 15:23:14 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Frank Mayhar <fmayhar@google.com>
Subject: [PATCH 41/49] ext4: remove unused function __ext4_write_dirty_metadata
Date: Mon,  8 Jun 2009 15:22:59 -0400
Message-Id: <1244488987-32564-42-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.3.2.1.gb9f7d.dirty
In-Reply-To: <1244488987-32564-41-git-send-email-tytso@mit.edu>
References: <1244488987-32564-1-git-send-email-tytso@mit.edu>
 <1244488987-32564-2-git-send-email-tytso@mit.edu>
 <1244488987-32564-3-git-send-email-tytso@mit.edu>
 <1244488987-32564-4-git-send-email-tytso@mit.edu>
 <1244488987-32564-5-git-send-email-tytso@mit.edu>
 <1244488987-32564-6-git-send-email-tytso@mit.edu>
 <1244488987-32564-7-git-send-email-tytso@mit.edu>
 <1244488987-32564-8-git-send-email-tytso@mit.edu>
 <1244488987-32564-9-git-send-email-tytso@mit.edu>
 <1244488987-32564-10-git-send-email-tytso@mit.edu>
 <1244488987-32564-11-git-send-email-tytso@mit.edu>
 <1244488987-32564-12-git-send-email-tytso@mit.edu>
 <1244488987-32564-13-git-send-email-tytso@mit.edu>
 <1244488987-32564-14-git-send-email-tytso@mit.edu>
 <1244488987-32564-15-git-send-email-tytso@mit.edu>
 <1244488987-32564-16-git-send-email-tytso@mit.edu>
 <1244488987-32564-17-git-send-email-tytso@mit.edu>
 <1244488987-32564-18-git-send-email-tytso@mit.edu>
 <1244488987-32564-19-git-send-email-tytso@mit.edu>
 <1244488987-32564-20-git-send-email-tytso@mit.edu>
 <1244488987-32564-21-git-send-email-tytso@mit.edu>
 <1244488987-32564-22-git-send-email-tytso@mit.edu>
 <1244488987-32564-23-git-send-email-tytso@mit.edu>
 <1244488987-32564-24-git-send-email-tytso@mit.edu>
 <1244488987-32564-25-git-send-email-tytso@mit.edu>
 <1244488987-32564-26-git-send-email-tytso@mit.edu>
 <1244488987-32564-27-git-send-email-tytso@mit.edu>
 <1244488987-32564-28-git-send-email-tytso@mit.edu>
 <1244488987-32564-29-git-send-email-tytso@mit.edu>
 <1244488987-32564-30-git-send-email-tytso@mit.edu>
 <1244488987-32564-31-git-send-email-tytso@mit.edu>
 <1244488987-32564-32-git-send-email-tytso@mit.edu>
 <1244488987-32564-33-git-send-email-tytso@mit.edu>
 <1244488987-32564-34-git-send-email-tytso@mit.edu>
 <1244488987-32564-35-git-send-email-tytso@mit.edu>
 <1244488987-32564-36-git-send-email-tytso@mit.edu>
 <1244488987-32564-37-git-send-email-tytso@mit.edu>
 <1244488987-32564-38-git-send-email-tytso@mit.edu>
 <1244488987-32564-39-git-send-email-tytso@mit.edu>
 <1244488987-32564-40-git-send-email-tytso@mit.edu>
 <1244488987-32564-41-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __ext4_write_dirty_metadata() function was introduced by commit
0390131b, "ext4: Allow ext4 to run without a journal", but nothing
ever used the function, either then or since.  So let's remove it and
save a bit of space.

Cc: Frank Mayhar <fmayhar@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |   19 -------------------
 1 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index dadd3f9..14c00ff 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4790,25 +4790,6 @@ int ext4_write_inode(struct inode *inode, int wait)
 	return ext4_force_commit(inode->i_sb);
 }
 
-int __ext4_write_dirty_metadata(struct inode *inode, struct buffer_head *bh)
-{
-	int err = 0;
-
-	mark_buffer_dirty(bh);
-	if (inode && inode_needs_sync(inode)) {
-		sync_dirty_buffer(bh);
-		if (buffer_req(bh) && !buffer_uptodate(bh)) {
-			ext4_error(inode->i_sb, __func__,
-				   "IO error syncing inode, "
-				   "inode=%lu, block=%llu",
-				   inode->i_ino,
-				   (unsigned long long)bh->b_blocknr);
-			err = -EIO;
-		}
-	}
-	return err;
-}
-
 /*
  * ext4_setattr()
  *
-- 
1.6.3.2.1.gb9f7d.dirty

