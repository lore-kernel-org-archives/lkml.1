Return-Path: <linux-kernel-owner+w=401wt.eu-S1759689AbXK0Qam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759689AbXK0Qam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 11:30:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759188AbXK0Q32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 11:29:28 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:23570 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758932AbXK0Q3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 11:29:24 -0500
Message-Id: <20071127162920.358220309@de.ibm.com>
References: <20071127162210.262064983@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 27 Nov 2007 17:22:14 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 4/4] Fix compile error on 31bit without preemption
Content-Disposition: inline; filename=004-non-preempt.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

Commit b8e7a54cd06b0b0174029ef3a7f5a1415a2c28f2 introduced a compile
error if CONFIG_PREEMPT is not set:

arch/s390/kernel/built-in.o: In function `cleanup_io_leave_insn':
/space/kvm/arch/s390/kernel/entry.S:(.text+0xbfce): undefined reference to `preempt_schedule_irq'

This patch hides preempt_schedule_irq if CONFIG_PREEMPT is not set.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/entry.S |    2 ++
 1 file changed, 2 insertions(+)

Index: quilt-2.6/arch/s390/kernel/entry.S
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/entry.S
+++ quilt-2.6/arch/s390/kernel/entry.S
@@ -1079,8 +1079,10 @@ cleanup_io_leave_insn:
 .Lexecve_tail:	.long	execve_tail
 .Ljump_table:	.long	pgm_check_table
 .Lschedule:	.long	schedule
+#ifdef CONFIG_PREEMPT
 .Lpreempt_schedule_irq:
 		.long	preempt_schedule_irq
+#endif
 .Ltrace:	.long	syscall_trace
 .Lschedtail:	.long	schedule_tail
 .Lsysc_table:	.long	sys_call_table

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

