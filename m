Return-Path: <linux-kernel-owner+w=401wt.eu-S1752521AbZDFO6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbZDFO6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 10:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbZDFO6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 10:58:14 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:56964 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbZDFO6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 10:58:13 -0400
Date: Mon, 6 Apr 2009 16:58:06 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] kernel/hrtimer.c: use function hrtimer_is_queued
Message-ID: <Pine.LNX.4.64.0904061656500.20450@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use the hrtimer_is_queued function rather than an explicit bit-and for
testing timer->state, as done elsewhere.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@header@
@@

#include <linux/hrtimer.h>

@depends on header@
struct hrtimer *timer;
@@

- (timer->state & HRTIMER_STATE_ENQUEUED)
+ hrtimer_is_queued(timer)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 kernel/hrtimer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/kernel/hrtimer.c b/kernel/hrtimer.c
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -850,7 +850,7 @@ static void __remove_hrtimer(struct hrti
 			     struct hrtimer_clock_base *base,
 			     unsigned long newstate, int reprogram)
 {
-	if (timer->state & HRTIMER_STATE_ENQUEUED) {
+	if (hrtimer_is_queued(timer)) {
 		/*
 		 * Remove the timer from the rbtree and replace the
 		 * first entry pointer if necessary.
