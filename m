Return-Path: <linux-kernel-owner+w=401wt.eu-S1758744AbYHNJEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758744AbYHNJEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 05:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758348AbYHNJDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 05:03:42 -0400
Received: from lemon.ertos.nicta.com.au ([203.143.174.143]:40751 "EHLO
	lemon.gelato.unsw.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758293AbYHNJDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 05:03:41 -0400
From: Aaron Carroll <aaronc@gelato.unsw.edu.au>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] block: update documentation for deadline fifo_batch tunable
Date: Thu, 14 Aug 2008 18:17:15 +1000
Message-Id: <1218701835-17327-4-git-send-email-aaronc@gelato.unsw.edu.au>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218701835-17327-1-git-send-email-aaronc@gelato.unsw.edu.au>
References: <1218701835-17327-1-git-send-email-aaronc@gelato.unsw.edu.au>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 203.143.161.65
X-SA-Exim-Mail-From: aaronc@gelato.unsw.edu.au
X-SA-Exim-Scanned: No (on lemon.gelato.unsw.edu.au); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the description of fifo_batch to match the current implementation,
and include a description of how to tune it.

Signed-off-by: Aaron Carroll <aaronc@gelato.unsw.edu.au>
---
 Documentation/block/deadline-iosched.txt |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/Documentation/block/deadline-iosched.txt b/Documentation/block/deadline-iosched.txt
index c23cab1..7257676 100644
--- a/Documentation/block/deadline-iosched.txt
+++ b/Documentation/block/deadline-iosched.txt
@@ -30,12 +30,18 @@ write_expire	(in ms)
 Similar to read_expire mentioned above, but for writes.
 
 
-fifo_batch
+fifo_batch	(number of requests)
 ----------
 
-When a read request expires its deadline, we must move some requests from
-the sorted io scheduler list to the block device dispatch queue. fifo_batch
-controls how many requests we move.
+Requests are grouped into ``batches'' of a particular data direction (read or
+write) which are serviced in increasing sector order.  To limit extra seeking,
+deadline expiries are only checked between batches.  fifo_batch controls the
+maximum number of requests per batch.
+
+This parameter tunes the balance between per-request latency and aggregate
+throughput.  When low latency is the primary concern, smaller is better (where
+a value of 1 yields first-come first-served behaviour).  Increasing fifo_batch
+generally improves throughput, at the cost of latency variation.
 
 
 writes_starved	(number of dispatches)
-- 
1.5.4.5

