Return-Path: <linux-kernel-owner+w=401wt.eu-S932326AbZFLDB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326AbZFLDB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 23:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbZFLDBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 23:01:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53274 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbZFLDBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 23:01:52 -0400
Message-ID: <4A31C4B9.9090009@cn.fujitsu.com>
Date: Fri, 12 Jun 2009 11:00:09 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: jens.axboe@oracle.com
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] cfq: cleanup for last_end_request in cfq_data
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Actually, last_end_request in cfq_data isn't used now.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/cfq-iosched.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index a55a9bd..48f809c 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -122,7 +122,6 @@ struct cfq_data {
 	struct cfq_queue *async_idle_cfqq;
 
 	sector_t last_position;
-	unsigned long last_end_request;
 
 	/*
 	 * tunables, see top of file
@@ -2164,9 +2163,6 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 	if (cfq_cfqq_sync(cfqq))
 		cfqd->sync_flight--;
 
-	if (!cfq_class_idle(cfqq))
-		cfqd->last_end_request = now;
-
 	if (sync)
 		RQ_CIC(rq)->last_end_request = now;
 
@@ -2479,7 +2475,6 @@ static void *cfq_init_queue(struct request_queue *q)
 
 	INIT_WORK(&cfqd->unplug_work, cfq_kick_queue);
 
-	cfqd->last_end_request = jiffies;
 	cfqd->cfq_quantum = cfq_quantum;
 	cfqd->cfq_fifo_expire[0] = cfq_fifo_expire[0];
 	cfqd->cfq_fifo_expire[1] = cfq_fifo_expire[1];
-- 
1.5.4.rc3


