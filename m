Return-Path: <linux-kernel-owner+w=401wt.eu-S1752066AbZIYGUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbZIYGUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 02:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbZIYGUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 02:20:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:49346 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbZIYGUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 02:20:52 -0400
Date: Fri, 25 Sep 2009 06:20:19 GMT
From: tip-bot for Darren Hart <dvhltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, dvhltc@us.ibm.com, hpa@zytor.com,
       mingo@redhat.com, eric.dumazet@gmail.com, johnstul@us.ibm.com,
       peterz@infradead.org, dino@in.ibm.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, dvhltc@us.ibm.com,
       linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
       johnstul@us.ibm.com, peterz@infradead.org, dino@in.ibm.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090924185447.694.38948.stgit@Aeon>
References: <20090924185447.694.38948.stgit@Aeon>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] futex: Add memory barrier commentary to futex_wait_queue_me()
Message-ID: <tip-9beba3c54dd180a26a1da2027cfbe9edfaf9c40e@git.kernel.org>
Git-Commit-ID: 9beba3c54dd180a26a1da2027cfbe9edfaf9c40e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 25 Sep 2009 06:20:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9beba3c54dd180a26a1da2027cfbe9edfaf9c40e
Gitweb:     http://git.kernel.org/tip/9beba3c54dd180a26a1da2027cfbe9edfaf9c40e
Author:     Darren Hart <dvhltc@us.ibm.com>
AuthorDate: Thu, 24 Sep 2009 11:54:47 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 24 Sep 2009 22:30:10 +0200

futex: Add memory barrier commentary to futex_wait_queue_me()

The memory barrier semantics of futex_wait_queue_me() are
non-obvious. Add some commentary to try and clarify it.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Dinakar Guniguntala <dino@in.ibm.com>
Cc: John Stultz <johnstul@us.ibm.com>
LKML-Reference: <20090924185447.694.38948.stgit@Aeon>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
 
