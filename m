Return-Path: <linux-kernel-owner+w=401wt.eu-S1753949AbZIWGUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbZIWGUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 02:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbZIWGUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 02:20:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbZIWGUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 02:20:54 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, jan.kratochvil@redhat.com,
       Oleg Nesterov <oleg@redhat.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/4] asm-generic: syscall_get_nr returns int
In-Reply-To: Roland McGrath's message of  Tuesday, 22 September 2009 23:18:34 -0700 <20090923061834.BE13A22@magilla.sf.frob.com>
X-Fcc: ~/Mail/linus
References: <20090923004651.2D99513F37@magilla.sf.frob.com>
	<alpine.LFD.2.01.0909221757200.4950@localhost.localdomain>
	<20090923024049.AA85913F37@magilla.sf.frob.com>
	<20090923061834.BE13A22@magilla.sf.frob.com>
Emacs: freely redistributable; void where prohibited by law.
Message-Id: <20090923061949.29E4F14093@magilla.sf.frob.com>
Date: Tue, 22 Sep 2009 23:19:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only 32 bits of system call number are meaningful, so make the
specification for syscall_get_nr() be to return int, not long.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/asm-generic/syscall.h |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/syscall.h b/include/asm-generic/syscall.h
index ea8087b..5c122ae 100644
--- a/include/asm-generic/syscall.h
+++ b/include/asm-generic/syscall.h
@@ -1,7 +1,7 @@
 /*
  * Access to user system call parameters and results
  *
- * Copyright (C) 2008 Red Hat, Inc.  All rights reserved.
+ * Copyright (C) 2008-2009 Red Hat, Inc.  All rights reserved.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
@@ -32,9 +32,13 @@ struct pt_regs;
  * If @task is not executing a system call, i.e. it's blocked
  * inside the kernel for a fault or signal, returns -1.
  *
+ * Note this returns int even on 64-bit machines.  Only 32 bits of
+ * system call number can be meaningful.  If the actual arch value
+ * is 64 bits, this truncates to 32 bits so 0xffffffff means -1.
+ *
  * It's only valid to call this when @task is known to be blocked.
  */
-long syscall_get_nr(struct task_struct *task, struct pt_regs *regs);
+int syscall_get_nr(struct task_struct *task, struct pt_regs *regs);
 
 /**
  * syscall_rollback - roll back registers after an aborted system call
