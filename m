Return-Path: <linux-kernel-owner+w=401wt.eu-S1752356AbZL1KN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356AbZL1KN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 05:13:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbZL1KNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 05:13:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:48204 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbZL1KNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 05:13:16 -0500
Date: Mon, 28 Dec 2009 10:10:55 GMT
From: tip-bot for Simon Kagstrom <simon.kagstrom@netinsight.net>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       simon.kagstrom@netinsight.net, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, simon.kagstrom@netinsight.net, mingo@elte.hu
In-Reply-To: <20091223110818.442d848e@marrow.netinsight.se>
References: <20091223110818.442d848e@marrow.netinsight.se>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: might_sleep(): Make file parameter const char *
Message-ID: <tip-d894837f23f491aa7ed167aae767fc07cfe6e6e6@git.kernel.org>
Git-Commit-ID: d894837f23f491aa7ed167aae767fc07cfe6e6e6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d894837f23f491aa7ed167aae767fc07cfe6e6e6
Gitweb:     http://git.kernel.org/tip/d894837f23f491aa7ed167aae767fc07cfe6e6e6
Author:     Simon Kagstrom <simon.kagstrom@netinsight.net>
AuthorDate: Wed, 23 Dec 2009 11:08:18 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 28 Dec 2009 10:50:13 +0100

sched: might_sleep(): Make file parameter const char *

Fixes a warning when building with g++:

 warning: deprecated conversion from string constant to 'char*'

And the file parameter use is constant, so mark it as such.

Signed-off-by: Simon Kagstrom <simon.kagstrom@netinsight.net>
Cc: peterz@infradead.org
LKML-Reference: <20091223110818.442d848e@marrow.netinsight.se>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/kernel.h |    5 +++--
 kernel/sched.c         |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 3fc9f5a..785d7d1 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -124,7 +124,7 @@ extern int _cond_resched(void);
 #endif
 
 #ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
-  void __might_sleep(char *file, int line, int preempt_offset);
+  void __might_sleep(const char *file, int line, int preempt_offset);
 /**
  * might_sleep - annotation for functions that can sleep
  *
@@ -138,7 +138,8 @@ extern int _cond_resched(void);
 # define might_sleep() \
 	do { __might_sleep(__FILE__, __LINE__, 0); might_resched(); } while (0)
 #else
-  static inline void __might_sleep(char *file, int line, int preempt_offset) { }
+  static inline void __might_sleep(const char *file, int line,
+				   int preempt_offset) { }
 # define might_sleep() do { might_resched(); } while (0)
 #endif
 
diff --git a/kernel/sched.c b/kernel/sched.c
index c535cc4..64298a5 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9694,7 +9694,7 @@ static inline int preempt_count_equals(int preempt_offset)
 	return (nested == PREEMPT_INATOMIC_BASE + preempt_offset);
 }
 
-void __might_sleep(char *file, int line, int preempt_offset)
+void __might_sleep(const char *file, int line, int preempt_offset)
 {
 #ifdef in_atomic
 	static unsigned long prev_jiffy;	/* ratelimiting */
