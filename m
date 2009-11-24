Return-Path: <linux-kernel-owner+w=401wt.eu-S933001AbZKXUHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001AbZKXUHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 15:07:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932931AbZKXUHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 15:07:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932938AbZKXUHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 15:07:04 -0500
Date: Tue, 24 Nov 2009 21:01:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, utrace-devel@redhat.com
Subject: [RFC,PATCH 04/14] ptrace: implement user_single_step_siginfo()
Message-ID: <20091124200142.GA5772@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(already in mm: ptrace-powerpc-implement-user_single_step_siginfo.patch)

Suggested by Roland.

Implement user_single_step_siginfo() for powerpc.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
---

 arch/powerpc/include/asm/ptrace.h |    2 ++
 arch/powerpc/kernel/traps.c       |    9 +++++++++
 2 files changed, 11 insertions(+)

--- V1/arch/powerpc/include/asm/ptrace.h~4_PPC_HELPER	2009-11-24 19:46:49.000000000 +0100
+++ V1/arch/powerpc/include/asm/ptrace.h	2009-11-24 19:51:41.000000000 +0100
@@ -140,6 +140,8 @@ extern void user_enable_single_step(stru
 extern void user_enable_block_step(struct task_struct *);
 extern void user_disable_single_step(struct task_struct *);
 
+#define ARCH_HAS_USER_SINGLE_STEP_INFO
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* __KERNEL__ */
--- V1/arch/powerpc/kernel/traps.c~4_PPC_HELPER	2009-11-24 19:46:49.000000000 +0100
+++ V1/arch/powerpc/kernel/traps.c	2009-11-24 19:51:41.000000000 +0100
@@ -174,6 +174,15 @@ int die(const char *str, struct pt_regs 
 	return 0;
 }
 
+void user_single_step_siginfo(struct task_struct *tsk,
+				struct pt_regs *regs, siginfo_t *info)
+{
+	memset(info, 0, sizeof(*info));
+	info->si_signo = SIGTRAP;
+	info->si_code = TRAP_TRACE;
+	info->si_addr = (void __user *)regs->nip;
+}
+
 void _exception(int signr, struct pt_regs *regs, int code, unsigned long addr)
 {
 	siginfo_t info;

