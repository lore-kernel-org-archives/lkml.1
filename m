Return-Path: <linux-kernel-owner+w=401wt.eu-S935249AbYD1Pk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935249AbYD1Pk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935877AbYD1PjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:39:13 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:49090 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935870AbYD1PjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:39:12 -0400
Date: Mon, 28 Apr 2008 18:38:39 +0300
From: Adrian Bunk <bunk@kernel.org>
To: axboe@kernel.dk
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@mailshack.com>, jdike@addtoit.com,
       Ingo Molnar <mingo@elte.hu>
Subject: [2.6 patch] block/blk-barrier.c:blk_ordered_cur_seq() mustn't be
	inline
Message-ID: <20080428153839.GE2813@cs181133002.pp.htv.fi>
References: <20080424215739.GA32378@elte.hu> <alpine.LFD.1.10.0804241510420.2779@woody.linux-foundation.org> <20080426151516.GA27894@elte.hu> <alpine.LFD.1.10.0804260955300.2813@woody.linux-foundation.org> <20080426172222.GD17345@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080426172222.GD17345@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following build error with UML and gcc 4.3:

<--  snip  -->

...
  CC      block/blk-barrier.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/block/blk-barrier.c: In function ‘blk_do_ordered’:
/home/bunk/linux/kernel-2.6/git/linux-2.6/block/blk-barrier.c:57: sorry, unimplemented: inlining failed in call to ‘blk_ordered_cur_seq’: function body not available
/home/bunk/linux/kernel-2.6/git/linux-2.6/block/blk-barrier.c:252: sorry, unimplemented: called from here
/home/bunk/linux/kernel-2.6/git/linux-2.6/block/blk-barrier.c:57: sorry, unimplemented: inlining failed in call to ‘blk_ordered_cur_seq’: function body not available
/home/bunk/linux/kernel-2.6/git/linux-2.6/block/blk-barrier.c:253: sorry, unimplemented: called from here
make[2]: *** [block/blk-barrier.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
e322a237766808e2c198f4521a9c8ba1fae6b77c diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index 55c5f1f..2b9f2e9 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -53,7 +53,7 @@ EXPORT_SYMBOL(blk_queue_ordered);
 /*
  * Cache flushing for ordered writes handling
  */
-inline unsigned blk_ordered_cur_seq(struct request_queue *q)
+unsigned blk_ordered_cur_seq(struct request_queue *q)
 {
 	if (!q->ordseq)
 		return 0;

