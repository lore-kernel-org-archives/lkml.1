Return-Path: <linux-kernel-owner+w=401wt.eu-S1752697AbZGROXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbZGROXW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 10:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbZGROXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 10:23:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:53958 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369AbZGROXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 10:23:19 -0400
Date: Sat, 18 Jul 2009 14:22:23 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1247725694-6082-5-git-send-email-fweisbec@gmail.com>
References: <1247725694-6082-5-git-send-email-fweisbec@gmail.com>
Subject: [tip:sched/core] sched: Remove the CONFIG_PREEMPT_BKL case definition of cond_resched()
Message-ID: <tip-6f80bd985fe242c2e6a8b6209ed20b0495d3d63b@git.kernel.org>
Git-Commit-ID: 6f80bd985fe242c2e6a8b6209ed20b0495d3d63b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 18 Jul 2009 14:22:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6f80bd985fe242c2e6a8b6209ed20b0495d3d63b
Gitweb:     http://git.kernel.org/tip/6f80bd985fe242c2e6a8b6209ed20b0495d3d63b
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Thu, 16 Jul 2009 15:44:29 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 18 Jul 2009 15:51:43 +0200

sched: Remove the CONFIG_PREEMPT_BKL case definition of cond_resched()

CONFIG_PREEMPT_BKL doesn't exist anymore. So remove this
config-on case definition of cond_resched().

Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1247725694-6082-5-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/sched.h |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9bada20..e2bdf18 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2285,17 +2285,12 @@ static inline int need_resched(void)
  * cond_resched_softirq() will enable bhs before scheduling.
  */
 extern int _cond_resched(void);
-#ifdef CONFIG_PREEMPT_BKL
-static inline int cond_resched(void)
-{
-	return 0;
-}
-#else
+
 static inline int cond_resched(void)
 {
 	return _cond_resched();
 }
-#endif
+
 extern int cond_resched_lock(spinlock_t * lock);
 extern int cond_resched_softirq(void);
 static inline int cond_resched_bkl(void)
