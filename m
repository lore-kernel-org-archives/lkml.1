Return-Path: <linux-kernel-owner+w=401wt.eu-S933387AbZLKLHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933387AbZLKLHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 06:07:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762254AbZLKLHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 06:07:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:35286 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761146AbZLKLHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 06:07:40 -0500
Date: Fri, 11 Dec 2009 11:06:32 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, tglx@linutronix.de, sfr@canb.auug.org.au,
       prasad@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tglx@linutronix.de, sfr@canb.auug.org.au,
       prasad@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1260529122-6260-1-git-send-regression-fweisbec@gmail.com>
References: <1260529122-6260-1-git-send-regression-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] hw-breakpoints: Handle bad modify_user_hw_breakpoint off-case return value
Message-ID: <tip-99ac64c826e62a07e5818cfde620be4d524f1edf@git.kernel.org>
Git-Commit-ID: 99ac64c826e62a07e5818cfde620be4d524f1edf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  99ac64c826e62a07e5818cfde620be4d524f1edf
Gitweb:     http://git.kernel.org/tip/99ac64c826e62a07e5818cfde620be4d524f1edf
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Fri, 11 Dec 2009 11:58:42 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 11 Dec 2009 12:03:53 +0100

hw-breakpoints: Handle bad modify_user_hw_breakpoint off-case return value

While converting modify_user_hw_breakpoint() return value, we
forgot to handle the off-case. It's not returning a pointer
anymore.

This solves the build warning reported by Stephen Rothwell against
linux-next.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
LKML-Reference: <1260529122-6260-1-git-send-regression-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Prasad <prasad@linux.vnet.ibm.com>
---
 include/linux/hw_breakpoint.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index 69f07a9..41235c9 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -93,7 +93,7 @@ register_user_hw_breakpoint(struct perf_event_attr *attr,
 			    struct task_struct *tsk)	{ return NULL; }
 static inline int
 modify_user_hw_breakpoint(struct perf_event *bp,
-			  struct perf_event_attr *attr)	{ return NULL; }
+			  struct perf_event_attr *attr)	{ return -ENOSYS; }
 static inline struct perf_event *
 register_wide_hw_breakpoint_cpu(struct perf_event_attr *attr,
 				perf_overflow_handler_t	 triggered,
