Return-Path: <linux-kernel-owner+w=401wt.eu-S1752359AbZLACeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359AbZLACeu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 21:34:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbZLACet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 21:34:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbZLACes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 21:34:48 -0500
Date: Mon, 30 Nov 2009 21:34:14 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Jens Axboe <jens.axboe@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Amerigo Wang <amwang@redhat.com>, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, "Theodore Ts'o" <tytso@mit.edu>
Message-Id: <20091201023714.3863.92566.sendpatchset@localhost.localdomain>
Subject: [Patch] fs: remove a useless BUG()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This BUG() is suspicious, it makes its following statements
unreachable, and it seems to be useless, since the caller
of this function already handles the failure properly.
Remove it.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>

---
diff --git a/fs/buffer.c b/fs/buffer.c
index 6fa5302..ac111d7 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1041,7 +1041,6 @@ grow_dev_page(struct block_device *bdev, sector_t block,
 	return page;
 
 failed:
-	BUG();
 	unlock_page(page);
 	page_cache_release(page);
 	return NULL;
