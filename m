Return-Path: <linux-kernel-owner+w=401wt.eu-S1755243AbZLWKI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbZLWKI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 05:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754891AbZLWKI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 05:08:26 -0500
Received: from ernst.netinsight.se ([194.16.221.21]:62639 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754836AbZLWKI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 05:08:26 -0500
Date: Wed, 23 Dec 2009 11:08:18 +0100
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, peterz@infradead.org
Subject: [PATCH/trivial] might_sleep: Make file parameter const char *
Message-ID: <20091223110818.442d848e@marrow.netinsight.se>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes a warning when building with g++:

 warning: deprecated conversion from string constant to 'char*'

And the file parameter use is constant, so mark it as such.

Signed-off-by: Simon Kagstrom <simon.kagstrom@netinsight.net>
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
index 87f1f47..506e0ac 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9695,7 +9695,7 @@ static inline int preempt_count_equals(int preempt_offset)
 	return (nested == PREEMPT_INATOMIC_BASE + preempt_offset);
 }
 
-void __might_sleep(char *file, int line, int preempt_offset)
+void __might_sleep(const char *file, int line, int preempt_offset)
 {
 #ifdef in_atomic
 	static unsigned long prev_jiffy;	/* ratelimiting */
-- 
1.6.0.4

