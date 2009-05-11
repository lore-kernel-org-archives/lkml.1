Return-Path: <linux-kernel-owner+w=401wt.eu-S1758239AbZEKVxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239AbZEKVxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 17:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754584AbZEKVxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 17:53:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:39490 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753523AbZEKVxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 17:53:14 -0400
Date: Mon, 11 May 2009 21:51:44 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, jblunck@suse.de, hch@infradead.org,
       tglx@linutronix.de, mhiramat@redhat.com, harvey.harrison@gmail.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, jblunck@suse.de, hch@infradead.org,
       tglx@linutronix.de, harvey.harrison@gmail.com, mhiramat@redhat.com,
       mingo@elte.hu
In-Reply-To: <20090511210300.17332.67549.stgit@localhost.localdomain>
References: <20090511210300.17332.67549.stgit@localhost.localdomain>
Subject: [tip:x86/urgent] x86, 32-bit: fix kernel_trap_sp()
Message-ID: <tip-11d0f25f06fb67e707e6ed4bf9967b859e403639@git.kernel.org>
Git-Commit-ID: 11d0f25f06fb67e707e6ed4bf9967b859e403639
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 11 May 2009 21:51:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  11d0f25f06fb67e707e6ed4bf9967b859e403639
Gitweb:     http://git.kernel.org/tip/11d0f25f06fb67e707e6ed4bf9967b859e403639
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Mon, 11 May 2009 17:03:00 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 May 2009 23:49:17 +0200

x86, 32-bit: fix kernel_trap_sp()

Use &regs->sp instead of regs for getting the top of stack in kernel mode.
(on x86-64, regs->sp always points the top of stack)

[ Impact: Oprofile decodes only stack for backtracing on i386 ]

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap@sources.redhat.com
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Jan Blunck <jblunck@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <20090511210300.17332.67549.stgit@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/ptrace.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index e304b66..aed0894 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -187,14 +187,14 @@ static inline int v8086_mode(struct pt_regs *regs)
 
 /*
  * X86_32 CPUs don't save ss and esp if the CPU is already in kernel mode
- * when it traps.  So regs will be the current sp.
+ * when it traps.  So &regs->sp will be the current sp.
  *
  * This is valid only for kernel mode traps.
  */
 static inline unsigned long kernel_trap_sp(struct pt_regs *regs)
 {
 #ifdef CONFIG_X86_32
-	return (unsigned long)regs;
+	return (unsigned long)&regs->sp;
 #else
 	return regs->sp;
 #endif
