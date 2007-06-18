Return-Path: <linux-kernel-owner+w=401wt.eu-S1765060AbXFRTnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765060AbXFRTnG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 15:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761429AbXFRTm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 15:42:56 -0400
Received: from CHOKECHERRY.SRV.CS.CMU.EDU ([128.2.185.41]:38089 "EHLO
	chokecherry.srv.cs.cmu.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761454AbXFRTmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 15:42:55 -0400
From: Benjamin Gilbert <bgilbert@cs.cmu.edu>
Subject: [TRIVIAL PATCH] Kill blk_congestion_wait() stub for !CONFIG_BLOCK
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, bgilbert@cs.cmu.edu
Date: Mon, 18 Jun 2007 15:42:49 -0400
Message-ID: <20070618194249.7946.30327.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

blk_congestion_wait() doesn't exist anymore, but there's still a stub
in blkdev.h for the !CONFIG_BLOCK case.  Kill it.

Signed-off-by: Benjamin Gilbert <bgilbert@cs.cmu.edu>
---

 include/linux/blkdev.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index db5b00a..fae138b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -868,11 +868,6 @@ void kblockd_flush_work(struct work_struct *work);
  */
 #define buffer_heads_over_limit 0
 
-static inline long blk_congestion_wait(int rw, long timeout)
-{
-	return io_schedule_timeout(timeout);
-}
-
 static inline long nr_blockdev_pages(void)
 {
 	return 0;

