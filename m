Return-Path: <linux-kernel-owner+w=401wt.eu-S1753313AbZIXSzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbZIXSzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 14:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbZIXSzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 14:55:07 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:47458 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbZIXSzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 14:55:05 -0400
From: Darren Hart <dvhltc@us.ibm.com>
Subject: [PATCH] futex: add memory barrier commentary to futex_wait_queue_me
To: linux-kernel@vger.kernel.org
Cc: Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       John Stultz <johnstul@us.ibm.com>
Date: Thu, 24 Sep 2009 11:54:47 -0700
Message-ID: <20090924185447.694.38948.stgit@Aeon>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The memory barrier semantics of futex_wait_queue_me() are non-obvious.
Add some commentary to try and clarify it.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Dinakar Guniguntala <dino@in.ibm.com>
CC: John Stultz <johnstul@us.ibm.com>
---

 kernel/futex.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 463af2e..b911adc 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1656,6 +1656,12 @@ out:
 static void futex_wait_queue_me(struct futex_hash_bucket *hb, struct futex_q *q,
 				struct hrtimer_sleeper *timeout)
 {
+	/*
+	 * The task state is guaranteed to be set before another task can
+	 * wake it. set_current_state() is implemented using set_mb() and
+	 * queue_me() calls spin_unlock() upon completion, both serializing
+	 * access to the hash list and forcing another memory barrier.
+	 */
 	set_current_state(TASK_INTERRUPTIBLE);
 	queue_me(q, hb);
 

