Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbZHUBxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbZHUBxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 21:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbZHUBxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 21:53:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59044 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbZHUBxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 21:53:39 -0400
Message-ID: <4A8DFDF1.5030904@cn.fujitsu.com>
Date: Fri, 21 Aug 2009 09:52:49 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] CFQ: clear wait_request flag if needed
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

IMHO wait_request flag should be cleared if a request goes in
and idle timer needs to shut down. Otherwise, it will walk into
that path every time when a request is enqueued.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/cfq-iosched.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index fd7080e..67f1910 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2093,6 +2093,7 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 			if (blk_rq_bytes(rq) > PAGE_CACHE_SIZE ||
 			    cfqd->busy_queues > 1) {
 				del_timer(&cfqd->idle_slice_timer);
+				cfq_clear_cfqq_wait_request(cfqq);
 			__blk_run_queue(cfqd->queue);
 			}
 			cfq_mark_cfqq_must_dispatch(cfqq);
-- 
1.5.4.rc3

