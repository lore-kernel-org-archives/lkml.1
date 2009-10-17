Return-Path: <linux-kernel-owner+w=401wt.eu-S1751920AbZJQGke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbZJQGke (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 02:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbZJQGkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 02:40:33 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:39098 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbZJQGkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 02:40:32 -0400
Date: Sat, 17 Oct 2009 08:40:34 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 8/14] drivers/cpuidle: Move dereference after NULL test
Message-ID: <Pine.LNX.4.64.0910170840030.9213@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

It does not seem possible that ldev can be NULL, so drop the unnecessary
test.  If ldev can somehow be NULL, then the initialization of last_idx
should be moved below the test.

A simplified version of the semantic match that detects this problem is as
follows (http://coccinelle.lip6.fr/):

// <smpl>
@match exists@
expression x, E;
identifier fld;
@@

* x->fld
  ... when != \(x = E\|&x\)
* x == NULL
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/cpuidle/governors/ladder.c  |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/cpuidle/governors/ladder.c b/drivers/cpuidle/governors/ladder.c
index a4bec3f..1c1ceb4 100644
--- a/drivers/cpuidle/governors/ladder.c
+++ b/drivers/cpuidle/governors/ladder.c
@@ -69,9 +69,6 @@ static int ladder_select_state(struct cpuidle_device *dev)
 	int last_residency, last_idx = ldev->last_state_idx;
 	int latency_req = pm_qos_requirement(PM_QOS_CPU_DMA_LATENCY);
 
-	if (unlikely(!ldev))
-		return 0;
-
 	/* Special case when user has set very strict latency requirement */
 	if (unlikely(latency_req == 0)) {
 		ladder_do_selection(ldev, last_idx, 0);
