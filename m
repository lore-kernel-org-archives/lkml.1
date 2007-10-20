Return-Path: <linux-kernel-owner+w=401wt.eu-S1765813AbXJTNGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765813AbXJTNGy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 09:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbXJTNGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 09:06:47 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:45791 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030AbXJTNGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 09:06:47 -0400
Date: Sat, 20 Oct 2007 17:11:48 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] cfq_get_queue: fix possible NULL pointer access
Message-ID: <20071020131148.GA3033@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cfq_get_queue()->cfq_find_alloc_queue() can fail, check the returned value.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- K/block/cfq-iosched.c~3_get	2007-10-20 15:48:35.000000000 +0400
+++ K/block/cfq-iosched.c	2007-10-20 17:05:30.000000000 +0400
@@ -1443,8 +1443,11 @@ cfq_get_queue(struct cfq_data *cfqd, int
 		cfqq = *async_cfqq;
 	}
 
-	if (!cfqq)
+	if (!cfqq) {
 		cfqq = cfq_find_alloc_queue(cfqd, is_sync, tsk, gfp_mask);
+		if (!cfqq)
+			return NULL;
+	}
 
 	/*
 	 * pin the queue now that it's allocated, scheduler exit will prune it

