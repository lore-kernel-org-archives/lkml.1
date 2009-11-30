Return-Path: <linux-kernel-owner+w=401wt.eu-S1753680AbZK3DBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbZK3DBM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 22:01:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbZK3DBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 22:01:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753529AbZK3DAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 22:00:50 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, vgoyal@redhat.com,
       czoccolo@gmail.com, Alan.Brunelle@hp.com
Subject: [PATCH 01/21] blkio: Set must_dispatch only if we decided to not dispatch the request
Date: Sun, 29 Nov 2009 21:59:08 -0500
Message-Id: <1259549968-10369-2-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
References: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o must_dispatch flag should be set only if we decided not to run the quue
  dispatch the request.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index a5de31f..9adfa48 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2494,9 +2494,9 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 			if (blk_rq_bytes(rq) > PAGE_CACHE_SIZE ||
 			    cfqd->busy_queues > 1) {
 				del_timer(&cfqd->idle_slice_timer);
-			__blk_run_queue(cfqd->queue);
-			}
-			cfq_mark_cfqq_must_dispatch(cfqq);
+				__blk_run_queue(cfqd->queue);
+			} else
+				cfq_mark_cfqq_must_dispatch(cfqq);
 		}
 	} else if (cfq_should_preempt(cfqd, cfqq, rq)) {
 		/*
-- 
1.6.2.5

