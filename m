Return-Path: <linux-kernel-owner+w=401wt.eu-S932293AbXJTMPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293AbXJTMPp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 08:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbXJTMPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 08:15:25 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:49768 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088AbXJTMPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 08:15:24 -0400
Date: Sat, 20 Oct 2007 16:20:21 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
Cc: Nick <gentuu@gmail.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] blk_sync_queue() should cancel request_queue->unplug_work
Message-ID: <20071020122021.GA2490@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(untested, needs an explicit ack/nack from maintainer)

blk_sync_queue() cancels the timer, but forgets to cancel the work.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- K/block/ll_rw_blk.c~2_blk	2007-10-13 14:51:42.000000000 +0400
+++ K/block/ll_rw_blk.c	2007-10-20 16:10:08.000000000 +0400
@@ -1723,6 +1723,7 @@ EXPORT_SYMBOL(blk_stop_queue);
 void blk_sync_queue(struct request_queue *q)
 {
 	del_timer_sync(&q->unplug_timer);
+	kblockd_flush_work(&q->unplug_work);
 }
 EXPORT_SYMBOL(blk_sync_queue);
 

