Return-Path: <linux-kernel-owner+w=401wt.eu-S933536AbZLJHwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933536AbZLJHwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 02:52:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933520AbZLJHws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 02:52:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:40034 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933280AbZLJHwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 02:52:46 -0500
Date: Thu, 10 Dec 2009 07:50:44 GMT
From: tip-bot for Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, vapier@gentoo.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       peterz@infradead.org, vapier@gentoo.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1260407223-10900-1-git-send-email-vapier@gentoo.org>
References: <1260407223-10900-1-git-send-email-vapier@gentoo.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] sched: Mark sched_clock() as notrace
Message-ID: <tip-1bbfa6f25673019dc0acc9308b667c96f6cda8bf@git.kernel.org>
Git-Commit-ID: 1bbfa6f25673019dc0acc9308b667c96f6cda8bf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1bbfa6f25673019dc0acc9308b667c96f6cda8bf
Gitweb:     http://git.kernel.org/tip/1bbfa6f25673019dc0acc9308b667c96f6cda8bf
Author:     Mike Frysinger <vapier@gentoo.org>
AuthorDate: Wed, 9 Dec 2009 20:07:03 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 10 Dec 2009 08:30:27 +0100

sched: Mark sched_clock() as notrace

The core ftrace code (trace_clock_local) calls sched_clock()
directly, so we don't want to recurisvely trigger the ftrace
code.  Rather than update every sched_clock() definition, tag
the prototype for everyone as notrace.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1260407223-10900-1-git-send-email-vapier@gentoo.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 75e6e60..576d838 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1836,7 +1836,8 @@ static inline int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask)
 extern int sched_clock_stable;
 #endif
 
-extern unsigned long long sched_clock(void);
+/* ftrace calls sched_clock() directly */
+extern unsigned long long notrace sched_clock(void);
 
 extern void sched_clock_init(void);
 extern u64 sched_clock_cpu(int cpu);
