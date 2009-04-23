Return-Path: <linux-kernel-owner+w=401wt.eu-S1752038AbZDWTjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038AbZDWTjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 15:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753443AbZDWTjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 15:39:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46684 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583AbZDWTja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 15:39:30 -0400
Date: Thu, 23 Apr 2009 21:32:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Cc: Chris Zankel <chris@zankel.net>, David Howells <dhowells@redhat.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@uclinux.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Helge Deller <deller@gmx.de>, Hirokazu Takata <takata@linux-m32r.org>,
       Jeff Dike <jdike@addtoit.com>, Kyle McMartin <kyle@mcmartin.ca>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] ptrace: remove PT_DTRACE from arch/m32r
Message-ID: <20090423193215.GA14895@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

m32r: PTRACE_SINGLESTEP sets PT_DTRACE, it is never used except cleared
after do_execve().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

 arch/m32r/kernel/process.c |    5 -----
 arch/m32r/kernel/ptrace.c  |    4 ----
 2 files changed, 9 deletions(-)

--- PTRACE/arch/m32r/kernel/process.c~DT_4_m32r	2009-04-06 00:03:35.000000000 +0200
+++ PTRACE/arch/m32r/kernel/process.c	2009-04-22 22:01:44.000000000 +0200
@@ -302,11 +302,6 @@ asmlinkage int sys_execve(char __user *u
 		goto out;
 
 	error = do_execve(filename, uargv, uenvp, &regs);
-	if (error == 0) {
-		task_lock(current);
-		current->ptrace &= ~PT_DTRACE;
-		task_unlock(current);
-	}
 	putname(filename);
 out:
 	return error;
--- PTRACE/arch/m32r/kernel/ptrace.c~DT_4_m32r	2009-04-06 00:03:35.000000000 +0200
+++ PTRACE/arch/m32r/kernel/ptrace.c	2009-04-22 22:00:13.000000000 +0200
@@ -676,10 +676,6 @@ arch_ptrace(struct task_struct *child, l
 		if (!valid_signal(data))
 			break;
 		clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		if ((child->ptrace & PT_DTRACE) == 0) {
-			/* Spurious delayed TF traps may occur */
-			child->ptrace |= PT_DTRACE;
-		}
 
 		/* Compute next pc.  */
 		pc = get_stack_long(child, PT_BPC);

