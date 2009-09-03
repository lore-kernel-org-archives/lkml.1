Return-Path: <linux-kernel-owner+w=401wt.eu-S1752921AbZICH5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbZICH5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 03:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbZICH5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 03:57:46 -0400
Received: from brick.kernel.dk ([93.163.65.50]:38592 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709AbZICH5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 03:57:46 -0400
Date: Thu, 3 Sep 2009 09:57:48 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block fix for 2.6.31
Message-ID: <20090903075748.GM12579@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This fixes a regression with setting max_sectors_kb higher than our
default of 512kb. Please pull.

  git://git.kernel.dk/linux-2.6-block.git for-linus

Nikanth Karthikesan (1):
      block: Allow changing max_sectors_kb above the default 512

 block/blk-sysfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 418d636..d3aa2aa 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -133,7 +133,7 @@ queue_max_sectors_store(struct request_queue *q, const char *page, size_t count)
 		return -EINVAL;
 
 	spin_lock_irq(q->queue_lock);
-	blk_queue_max_sectors(q, max_sectors_kb << 1);
+	q->limits.max_sectors = max_sectors_kb << 1;
 	spin_unlock_irq(q->queue_lock);
 
 	return ret;

-- 
Jens Axboe

