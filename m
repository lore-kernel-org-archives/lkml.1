Return-Path: <linux-kernel-owner+w=401wt.eu-S1753220AbZHLQvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbZHLQvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 12:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbZHLQvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 12:51:38 -0400
Received: from brick.kernel.dk ([93.163.65.50]:57370 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbZHLQvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 12:51:38 -0400
Date: Wed, 12 Aug 2009 18:51:38 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Alan.Brunelle@hp.com
Subject: [GIT PULL] blktrace fix for 2.6.31
Message-ID: <20090812165138.GN12579@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Just a single patch there, fixing a critical issue with blktrace. Please
pull.

  git://git.kernel.dk/linux-2.6-block.git for-linus

Alan D. Brunelle (1):
      Remove double removal of blktrace directory

 kernel/trace/blktrace.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 1090b0a..7a34cb5 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -267,8 +267,8 @@ static void blk_trace_free(struct blk_trace *bt)
 {
 	debugfs_remove(bt->msg_file);
 	debugfs_remove(bt->dropped_file);
-	debugfs_remove(bt->dir);
 	relay_close(bt->rchan);
+	debugfs_remove(bt->dir);
 	free_percpu(bt->sequence);
 	free_percpu(bt->msg_data);
 	kfree(bt);
@@ -378,18 +378,8 @@ static int blk_subbuf_start_callback(struct rchan_buf *buf, void *subbuf,
 
 static int blk_remove_buf_file_callback(struct dentry *dentry)
 {
-	struct dentry *parent = dentry->d_parent;
 	debugfs_remove(dentry);
 
-	/*
-	* this will fail for all but the last file, but that is ok. what we
-	* care about is the top level buts->name directory going away, when
-	* the last trace file is gone. Then we don't have to rmdir() that
-	* manually on trace stop, so it nicely solves the issue with
-	* force killing of running traces.
-	*/
-
-	debugfs_remove(parent);
 	return 0;
 }
 

-- 
Jens Axboe

