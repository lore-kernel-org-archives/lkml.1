Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbXLEKYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbXLEKYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 05:24:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbXLEKYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 05:24:17 -0500
Received: from barracuda.cse.unsw.EDU.AU ([129.94.172.9]:56546 "EHLO
	barracuda.cse.unsw.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbXLEKYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 05:24:15 -0500
X-ASG-Debug-ID: 1196849212-7b1400130000-xx1T2L
X-Barracuda-URL: http://129.94.172.9:8000/cgi-bin/mark.cgi
X-CSE-Spam-Checker-Version: SpamAssassin 3.1.3 (2006-06-01) on 
	tone.orchestra.cse.unsw.EDU.AU
X-CSE-Spam-Level: 
X-CSE-Spam-Status: No, score=-2.6 required=4.0 tests=BAYES_00,UNPARSEABLE_RELAY 
	autolearn=ham version=3.1.3
From: Aaron Carroll <aaronc@gelato.unsw.edu.au>
To: Jens Axboe <jens.axboe@oracle.com>
Date: Wed, 05 Dec 2007 21:06:50 +1100
Message-ID: <4756783A.5020204@gelato.unsw.edu.au>
User-Agent: Thunderbird 2.0.0.9 (X11/20071116)
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org, npiggin@suse.de,
       Peter Chubb <peterc@gelato.unsw.edu.au>
X-ASG-Orig-Subj: [PATCH] as-iosched: fix incorrect comments
Subject: [PATCH] as-iosched: fix incorrect comments
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: tone.orchestra.cse.unsw.EDU.AU[129.94.242.59]
X-Barracuda-Start-Time: 1196849212
X-Barracuda-Virus-Scanned: by Barracuda Spam Firewall at cse.unsw.edu.au
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two comments refer to deadlines applying to reads only.  This is
not the case.

Signed-off-by: Aaron Carroll <aaronc@gelato.unsw.edu.au>
---
 block/as-iosched.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/as-iosched.c b/block/as-iosched.c
index dc715a5..4513fc5 100644
--- a/block/as-iosched.c
+++ b/block/as-iosched.c
@@ -880,7 +880,7 @@ static void as_remove_queued_request(struct request_queue *q,
 }
 
 /*
- * as_fifo_expired returns 0 if there are no expired reads on the fifo,
+ * as_fifo_expired returns 0 if there are no expired requests on the fifo,
  * 1 otherwise.  It is ratelimited so that we only perform the check once per
  * `fifo_expire' interval.  Otherwise a large number of expired requests
  * would create a hopeless seekstorm.
@@ -1159,7 +1159,7 @@ static void as_add_request(struct request_queue *q, struct request *rq)
 	as_add_rq_rb(ad, rq);
 
 	/*
-	 * set expire time (only used for reads) and add to fifo list
+	 * set expire time and add to fifo list
 	 */
 	rq_set_fifo_time(rq, jiffies + ad->fifo_expire[data_dir]);
 	list_add_tail(&rq->queuelist, &ad->fifo_list[data_dir]);
-- 
