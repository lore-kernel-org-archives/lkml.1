Return-Path: <linux-kernel-owner+w=401wt.eu-S1031402AbXDZSI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031402AbXDZSI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 14:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031394AbXDZSI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 14:08:29 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:3384 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031402AbXDZSI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 14:08:28 -0400
Message-Id: <20070426180555.793133540@mvista.com>
User-Agent: quilt/0.46-1
Date: Thu, 26 Apr 2007 11:05:55 -0700
From: Daniel Walker <dwalker@mvista.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, roland@redhat.com
Subject: [PATCH] posix-cpu-clocks: cleanup clock macros
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These macros were a little confused looking, so I cleaned then up
a bit. I think this way it's a little clearer what's what ..

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 include/linux/posix-timers.h |   38 +++++++++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 11 deletions(-)

Index: linux-2.6.21/include/linux/posix-timers.h
===================================================================
--- linux-2.6.21.orig/include/linux/posix-timers.h
+++ linux-2.6.21/include/linux/posix-timers.h
@@ -17,22 +17,38 @@ struct cpu_timer_list {
 	int firing;
 };
 
-#define CPUCLOCK_PID(clock)		((pid_t) ~((clock) >> 3))
-#define CPUCLOCK_PERTHREAD(clock) \
-	(((clock) & (clockid_t) CPUCLOCK_PERTHREAD_MASK) != 0)
-#define CPUCLOCK_PID_MASK	7
-#define CPUCLOCK_PERTHREAD_MASK	4
+
+/*
+ * CPU Clock types
+ */
+#define CPUCLOCK_PROF		0x0
+#define CPUCLOCK_VIRT		0x1
+#define CPUCLOCK_SCHED		0x2
+#define CPUCLOCK_MAX		0x3
+
+#define CPUCLOCK_CLOCK_MASK	(CPUCLOCK_SCHED | CPUCLOCK_VIRT | CPUCLOCK_PROF)
+
 #define CPUCLOCK_WHICH(clock)	((clock) & (clockid_t) CPUCLOCK_CLOCK_MASK)
-#define CPUCLOCK_CLOCK_MASK	3
-#define CPUCLOCK_PROF		0
-#define CPUCLOCK_VIRT		1
-#define CPUCLOCK_SCHED		2
-#define CPUCLOCK_MAX		3
+
+/*
+ * Per thread flag
+ */
+#define CPUCLOCK_PERTHREAD_FLAG	0x4
+#define CPUCLOCK_PERTHREAD(clock) \
+	(((clock) & (clockid_t) CPUCLOCK_PERTHREAD_FLAG) != 0)
+
+/*
+ * Bits used for the PID within the clockid
+ */
+#define CPUCLOCK_PID_MASK	0x7
+#define CPUCLOCK_PID(clock)	((pid_t) ~((clock) >> 3))
+
 
 #define MAKE_PROCESS_CPUCLOCK(pid, clock) \
 	((~(clockid_t) (pid) << 3) | (clockid_t) (clock))
 #define MAKE_THREAD_CPUCLOCK(tid, clock) \
-	MAKE_PROCESS_CPUCLOCK((tid), (clock) | CPUCLOCK_PERTHREAD_MASK)
+	MAKE_PROCESS_CPUCLOCK((tid), (clock) | CPUCLOCK_PERTHREAD_FLAG)
+
 
 /* POSIX.1b interval timer structure. */
 struct k_itimer {
-- 

-- 
