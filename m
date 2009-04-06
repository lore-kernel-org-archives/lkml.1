Return-Path: <linux-kernel-owner+w=401wt.eu-S1758565AbZDFMug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758565AbZDFMug (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 08:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755144AbZDFMsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 08:48:20 -0400
Received: from brick.kernel.dk ([93.163.65.50]:50498 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754976AbZDFMsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 08:48:16 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: tytso@mit.edu, torvalds@linux-foundation.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 8/8] block: switch sync_dirty_buffer() over to WRITE_SYNC
Date: Mon,  6 Apr 2009 14:48:08 +0200
Message-Id: <1239022088-29002-9-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.2.1.423.g442d
In-Reply-To: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com>
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should now have the logic in place to handle this properly
without regressing on the write performance, so re-enable
the sync writes.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/buffer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 43afaa5..6e35762 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3010,7 +3010,7 @@ int sync_dirty_buffer(struct buffer_head *bh)
 	if (test_clear_buffer_dirty(bh)) {
 		get_bh(bh);
 		bh->b_end_io = end_buffer_write_sync;
-		ret = submit_bh(WRITE, bh);
+		ret = submit_bh(WRITE_SYNC, bh);
 		wait_on_buffer(bh);
 		if (buffer_eopnotsupp(bh)) {
 			clear_buffer_eopnotsupp(bh);
-- 
1.6.2.1.423.g442d

