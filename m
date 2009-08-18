Return-Path: <linux-kernel-owner+w=401wt.eu-S1751824AbZHRFJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbZHRFJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 01:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbZHRFJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 01:09:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55643 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbZHRFJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 01:09:44 -0400
Message-ID: <4A8A3711.7020005@cn.fujitsu.com>
Date: Tue, 18 Aug 2009 13:07:29 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: jens.axboe@oracle.com
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] CFQ: get rid of must_alloc flag
References: <4A7B930D.6060206@cn.fujitsu.com>
In-Reply-To: <4A7B930D.6060206@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of must_alloc flag since it's redundant now.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/cfq-iosched.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index fd7080e..f5770ad 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -191,7 +191,6 @@ enum cfqq_state_flags {
 	CFQ_CFQQ_FLAG_on_rr = 0,	/* on round-robin busy list */
 	CFQ_CFQQ_FLAG_wait_request,	/* waiting for a request */
 	CFQ_CFQQ_FLAG_must_dispatch,	/* must be allowed a dispatch */
-	CFQ_CFQQ_FLAG_must_alloc,	/* must be allowed rq alloc */
 	CFQ_CFQQ_FLAG_must_alloc_slice,	/* per-slice must_alloc flag */
 	CFQ_CFQQ_FLAG_fifo_expire,	/* FIFO checked in this slice */
 	CFQ_CFQQ_FLAG_idle_window,	/* slice idling enabled */
@@ -218,7 +217,6 @@ static inline int cfq_cfqq_##name(const struct cfq_queue *cfqq)		\
 CFQ_CFQQ_FNS(on_rr);
 CFQ_CFQQ_FNS(wait_request);
 CFQ_CFQQ_FNS(must_dispatch);
-CFQ_CFQQ_FNS(must_alloc);
 CFQ_CFQQ_FNS(must_alloc_slice);
 CFQ_CFQQ_FNS(fifo_expire);
 CFQ_CFQQ_FNS(idle_window);
@@ -2229,8 +2227,7 @@ static void cfq_prio_boost(struct cfq_queue *cfqq)
 
 static inline int __cfq_may_queue(struct cfq_queue *cfqq)
 {
-	if ((cfq_cfqq_wait_request(cfqq) || cfq_cfqq_must_alloc(cfqq)) &&
-	    !cfq_cfqq_must_alloc_slice(cfqq)) {
+	if ((cfq_cfqq_wait_request(cfqq) && !cfq_cfqq_must_alloc_slice(cfqq)) {
 		cfq_mark_cfqq_must_alloc_slice(cfqq);
 		return ELV_MQUEUE_MUST;
 	}
@@ -2317,7 +2314,6 @@ cfq_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
 	}
 
 	cfqq->allocated[rw]++;
-	cfq_clear_cfqq_must_alloc(cfqq);
 	atomic_inc(&cfqq->ref);
 
 	spin_unlock_irqrestore(q->queue_lock, flags);
-- 
1.5.4.rc3


