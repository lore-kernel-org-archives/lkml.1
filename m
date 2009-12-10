Return-Path: <linux-kernel-owner+w=401wt.eu-S933023AbZLJGBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023AbZLJGBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 01:01:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932884AbZLJGBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 01:01:51 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61050 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932858AbZLJGBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 01:01:50 -0500
Message-ID: <4B208DD3.8040500@cn.fujitsu.com>
Date: Thu, 10 Dec 2009 13:57:39 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] cfq: Remove wait_request flag when idle time is being deleted
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

I post this patch a few month ago, it seems to get missing, repost again.

Remove wait_request flag when idle time is being deleted.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/cfq-iosched.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 69ecee7..96f59ae 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3202,6 +3202,7 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 			if (blk_rq_bytes(rq) > PAGE_CACHE_SIZE ||
 			    cfqd->busy_queues > 1) {
 				del_timer(&cfqd->idle_slice_timer);
+				cfq_clear_cfqq_wait_request(cfqq);
 				__blk_run_queue(cfqd->queue);
 			} else
 				cfq_mark_cfqq_must_dispatch(cfqq);
-- 
1.5.4.rc3

