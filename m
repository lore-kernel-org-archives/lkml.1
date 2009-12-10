Return-Path: <linux-kernel-owner+w=401wt.eu-S1757500AbZLJBHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500AbZLJBHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 20:07:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbZLJBHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 20:07:00 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:39080 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679AbZLJBG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 20:06:59 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] sched: mark sched_clock() as notrace
Date: Wed,  9 Dec 2009 20:07:03 -0500
Message-Id: <1260407223-10900-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The core ftrace code (trace_clock_local) calls sched_clock() directly, so
we don't want to recurisvely trigger the ftrace code.  Rather than update
every sched_clock() definition, tag the prototype for everyone as notrace.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/linux/sched.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 89115ec..3f4fa73 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1840,7 +1840,8 @@ static inline int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask)
 extern int sched_clock_stable;
 #endif
 
-extern unsigned long long sched_clock(void);
+/* ftrace calls sched_clock() directly */
+extern unsigned long long notrace sched_clock(void);
 
 extern void sched_clock_init(void);
 extern u64 sched_clock_cpu(int cpu);
-- 
1.6.5.5

