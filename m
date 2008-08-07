Return-Path: <linux-kernel-owner+w=401wt.eu-S1756294AbYHGSPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294AbYHGSPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 14:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753146AbYHGSOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 14:14:52 -0400
Received: from smtp-out.google.com ([216.239.33.17]:40500 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbYHGSOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 14:14:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=to:subject:cc:message-id:date:from;
	b=XaI2eBozSzJGX0y3aBeA0kj8U/Q3f2WxxtvRPFafipzWLo+VL95yKzT7UyXMMfRCE
	7b40or+jVPTK3c6idhlHQ==
To: mingo@redhat.com, tglx@linutronix.de
Subject: [PATCH] x86: audit syscalls based on type of syscall not type of binary
Cc: linux-kernel@vger.kernel.org
Message-Id: <20080807181416.D239429627@localhost>
Date: Thu,  7 Aug 2008 11:14:16 -0700 (PDT)
From: md@google.com (Michael Davidson)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix syscall auditing to audit based on the actual type of system
call that was made, not the type of binary that made it.

Signed-off-by: Michael Davidson <md@google.com>

---

Index: linux-2.6.26.2/arch/x86/kernel/ptrace.c
===================================================================
--- linux-2.6.26.2.orig/arch/x86/kernel/ptrace.c	2008-08-06 09:19:01.000000000 -0700
+++ linux-2.6.26.2/arch/x86/kernel/ptrace.c	2008-08-07 11:01:25.976235000 -0700
@@ -1491,7 +1491,7 @@
 		syscall_trace(regs);
 
 	if (unlikely(current->audit_context)) {
-		if (test_thread_flag(TIF_IA32)) {
+		if (current_thread_info()->status & TS_COMPAT) {
 			audit_syscall_entry(AUDIT_ARCH_I386,
 					    regs->orig_ax,
 					    regs->bx, regs->cx,
