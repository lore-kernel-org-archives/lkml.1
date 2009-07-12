Return-Path: <linux-kernel-owner+w=401wt.eu-S1755228AbZGLS5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbZGLS5o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 14:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754639AbZGLS5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 14:57:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60183 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754288AbZGLS5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 14:57:33 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       vgoyal@redhat.com
Subject: [PATCH 1/2] cfq-iosched: Introduce an ioscheduler tunable "fairness"
Date: Sun, 12 Jul 2009 14:57:09 -0400
Message-Id: <1247425030-25344-2-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1247425030-25344-1-git-send-email-vgoyal@redhat.com>
References: <1247425030-25344-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Introduce a tunable "fairness" for CFQ ioscheduler. If this is set, CFQ will
  try to focus more on fairness and disable some of the hooks geared towards
  throughput at the expense of fairness.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 87276eb..658ea7b 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -185,6 +185,7 @@ struct cfq_data {
 	 * Fallback dummy cfqq for extreme OOM conditions
 	 */
 	struct cfq_queue oom_cfqq;
+	unsigned int cfq_fairness;
 };
 
 enum cfqq_state_flags {
@@ -2495,6 +2496,7 @@ static void *cfq_init_queue(struct request_queue *q)
 	cfqd->cfq_slice_async_rq = cfq_slice_async_rq;
 	cfqd->cfq_slice_idle = cfq_slice_idle;
 	cfqd->hw_tag = 1;
+	cfqd->cfq_fairness = 0;
 
 	return cfqd;
 }
@@ -2563,6 +2565,7 @@ SHOW_FUNCTION(cfq_slice_idle_show, cfqd->cfq_slice_idle, 1);
 SHOW_FUNCTION(cfq_slice_sync_show, cfqd->cfq_slice[1], 1);
 SHOW_FUNCTION(cfq_slice_async_show, cfqd->cfq_slice[0], 1);
 SHOW_FUNCTION(cfq_slice_async_rq_show, cfqd->cfq_slice_async_rq, 0);
+SHOW_FUNCTION(cfq_fairness_show, cfqd->cfq_fairness, 0);
 #undef SHOW_FUNCTION
 
 #define STORE_FUNCTION(__FUNC, __PTR, MIN, MAX, __CONV)			\
@@ -2594,6 +2597,7 @@ STORE_FUNCTION(cfq_slice_sync_store, &cfqd->cfq_slice[1], 1, UINT_MAX, 1);
 STORE_FUNCTION(cfq_slice_async_store, &cfqd->cfq_slice[0], 1, UINT_MAX, 1);
 STORE_FUNCTION(cfq_slice_async_rq_store, &cfqd->cfq_slice_async_rq, 1,
 		UINT_MAX, 0);
+STORE_FUNCTION(cfq_fairness_store, &cfqd->cfq_fairness, 0, 1, 0);
 #undef STORE_FUNCTION
 
 #define CFQ_ATTR(name) \
@@ -2609,6 +2613,7 @@ static struct elv_fs_entry cfq_attrs[] = {
 	CFQ_ATTR(slice_async),
 	CFQ_ATTR(slice_async_rq),
 	CFQ_ATTR(slice_idle),
+	CFQ_ATTR(fairness),
 	__ATTR_NULL
 };
 
-- 
1.6.0.6

