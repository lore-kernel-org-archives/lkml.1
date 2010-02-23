Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab0BWVtx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 16:49:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:35522 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754207Ab0BWVtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 16:49:52 -0500
Date: Tue, 23 Feb 2010 21:49:18 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       roland@redhat.com, suresh.b.siddha@intel.com, oleg@redhat.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       roland@redhat.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       oleg@redhat.com
In-Reply-To: <20100222225240.642169080@sbs-t61.sc.intel.com>
References: <20100222225240.642169080@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/ptrace] x86, ptrace: Remove set_stopped_child_used_math() in [x]fpregs_set
Message-ID: <tip-6dbbe14f21368a45aedba7eab0221857b8ad8d16@git.kernel.org>
Git-Commit-ID: 6dbbe14f21368a45aedba7eab0221857b8ad8d16
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 23 Feb 2010 21:49:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6dbbe14f21368a45aedba7eab0221857b8ad8d16
Gitweb:     http://git.kernel.org/tip/6dbbe14f21368a45aedba7eab0221857b8ad8d16
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Mon, 22 Feb 2010 14:51:34 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 23 Feb 2010 13:45:27 -0800

x86, ptrace: Remove set_stopped_child_used_math() in [x]fpregs_set

init_fpu() already ensures that the used_math() is set for the stopped child.
Remove the redundant set_stopped_child_used_math() in [x]fpregs_set()

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <20100222225240.642169080@sbs-t61.sc.intel.com>
Acked-by: Rolan McGrath <roland@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/i387.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 81e23bf..c01a2b8 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -209,8 +209,6 @@ int xfpregs_set(struct task_struct *target, const struct user_regset *regset,
 	if (ret)
 		return ret;
 
-	set_stopped_child_used_math(target);
-
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
 				 &target->thread.xstate->fxsave, 0, -1);
 
@@ -471,8 +469,6 @@ int fpregs_set(struct task_struct *target, const struct user_regset *regset,
 	if (ret)
 		return ret;
 
-	set_stopped_child_used_math(target);
-
 	if (!HAVE_HWFP)
 		return fpregs_soft_set(target, regset, pos, count, kbuf, ubuf);
 
