Return-Path: <linux-kernel-owner+w=401wt.eu-S1757767AbYCWVUD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767AbYCWVUD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 17:20:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbYCWVTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 17:19:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650AbYCWVTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 17:19:53 -0400
From: Roland McGrath <roland@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sparc64 exec PT_DTRACE
X-Fcc: ~/Mail/linus
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20080323211951.522C026FA0A@magilla.localdomain>
Date: Sun, 23 Mar 2008 14:19:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PT_DTRACE flag is meaningless and obsolete.
Don't touch it.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/sparc64/kernel/process.c     |    3 ---
 arch/sparc64/kernel/sys_sparc32.c |    3 ---
 2 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/sparc64/kernel/process.c b/arch/sparc64/kernel/process.c
index e116e38..c80d850 100644
--- a/arch/sparc64/kernel/process.c
+++ b/arch/sparc64/kernel/process.c
@@ -731,9 +731,6 @@ asmlinkage int sparc_execve(struct pt_regs *regs)
 		current_thread_info()->xfsr[0] = 0;
 		current_thread_info()->fpsaved[0] = 0;
 		regs->tstate &= ~TSTATE_PEF;
-		task_lock(current);
-		current->ptrace &= ~PT_DTRACE;
-		task_unlock(current);
 	}
 out:
 	return error;
diff --git a/arch/sparc64/kernel/sys_sparc32.c b/arch/sparc64/kernel/sys_sparc32.c
index deaba2b..41cbc6b 100644
--- a/arch/sparc64/kernel/sys_sparc32.c
+++ b/arch/sparc64/kernel/sys_sparc32.c
@@ -678,9 +678,6 @@ asmlinkage long sparc32_execve(struct pt_regs *regs)
 		current_thread_info()->xfsr[0] = 0;
 		current_thread_info()->fpsaved[0] = 0;
 		regs->tstate &= ~TSTATE_PEF;
-		task_lock(current);
-		current->ptrace &= ~PT_DTRACE;
-		task_unlock(current);
 	}
 out:
 	return error;
