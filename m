Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbZKUNj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbZKUNj2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:39:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754600AbZKUNj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:39:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:36468 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754552AbZKUNj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:39:27 -0500
Date: Sat, 21 Nov 2009 13:38:54 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, tglx@linutronix.de, prasad@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
In-Reply-To: <1258114575-32655-1-git-send-email-fweisbec@gmail.com>
References: <1258114575-32655-1-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] hw-breakpoints: Provide an off-case for counter_arch_bp()
Message-ID: <tip-687b16fb617bd446439425a368ad7c7bbd202c73@git.kernel.org>
Git-Commit-ID: 687b16fb617bd446439425a368ad7c7bbd202c73
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  687b16fb617bd446439425a368ad7c7bbd202c73
Gitweb:     http://git.kernel.org/tip/687b16fb617bd446439425a368ad7c7bbd202c73
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Fri, 13 Nov 2009 13:16:15 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 14 Nov 2009 00:27:38 +0100

hw-breakpoints: Provide an off-case for counter_arch_bp()

If an arch doesn't support the hw breakpoints, counter_arch_bp()
has no off case to cover the missing breakpoint info structure
from the perf event. The result is a build error in non-x86
configs.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
LKML-Reference: <1258114575-32655-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Prasad <prasad@linux.vnet.ibm.com>
---
 include/linux/hw_breakpoint.h |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index 7eba9b9..18710e0 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -16,11 +16,6 @@ enum {
 	HW_BREAKPOINT_X = 4,
 };
 
-static inline struct arch_hw_breakpoint *counter_arch_bp(struct perf_event *bp)
-{
-	return &bp->hw.info;
-}
-
 static inline unsigned long hw_breakpoint_addr(struct perf_event *bp)
 {
 	return bp->attr.bp_addr;
@@ -83,6 +78,11 @@ extern void release_bp_slot(struct perf_event *bp);
 
 extern void flush_ptrace_hw_breakpoint(struct task_struct *tsk);
 
+static inline struct arch_hw_breakpoint *counter_arch_bp(struct perf_event *bp)
+{
+	return &bp->hw.info;
+}
+
 #else /* !CONFIG_HAVE_HW_BREAKPOINT */
 
 static inline struct perf_event *
@@ -126,6 +126,11 @@ static inline void release_bp_slot(struct perf_event *bp) 		{ }
 
 static inline void flush_ptrace_hw_breakpoint(struct task_struct *tsk)	{ }
 
+static inline struct arch_hw_breakpoint *counter_arch_bp(struct perf_event *bp)
+{
+	return NULL;
+}
+
 #endif /* CONFIG_HAVE_HW_BREAKPOINT */
 
 #endif /* _LINUX_HW_BREAKPOINT_H */
