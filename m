Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013AbZIWGVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbZIWGVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 02:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbZIWGVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 02:21:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbZIWGVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 02:21:31 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, jan.kratochvil@redhat.com,
       Oleg Nesterov <oleg@redhat.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/4] x86: syscall_get_nr returns int
In-Reply-To: Roland McGrath's message of  Tuesday, 22 September 2009 23:18:34 -0700 <20090923061834.BE13A22@magilla.sf.frob.com>
X-Fcc: ~/Mail/linus
References: <20090923004651.2D99513F37@magilla.sf.frob.com>
	<alpine.LFD.2.01.0909221757200.4950@localhost.localdomain>
	<20090923024049.AA85913F37@magilla.sf.frob.com>
	<20090923061834.BE13A22@magilla.sf.frob.com>
X-Shopping-List: (1) Oligarchical enemas
   (2) Inglorious bits
   (3) Bouffant robber vagrants
   (4) Vacant mounds
Message-Id: <20090923062015.D1A4214093@magilla.sf.frob.com>
Date: Tue, 22 Sep 2009 23:20:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make syscall_get_nr() return int, so we always sign-extend
the low 32 bits of orig_ax in checks.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/include/asm/syscall.h |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/syscall.h b/arch/x86/include/asm/syscall.h
index d82f39b..8d33bc5 100644
--- a/arch/x86/include/asm/syscall.h
+++ b/arch/x86/include/asm/syscall.h
@@ -1,7 +1,7 @@
 /*
  * Access to user system call parameters and results
  *
- * Copyright (C) 2008 Red Hat, Inc.  All rights reserved.
+ * Copyright (C) 2008-2009 Red Hat, Inc.  All rights reserved.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
@@ -16,13 +16,13 @@
 #include <linux/sched.h>
 #include <linux/err.h>
 
-static inline long syscall_get_nr(struct task_struct *task,
-				  struct pt_regs *regs)
+/*
+ * Only the low 32 bits of orig_ax are meaningful, so we return int.
+ * This importantly ignores the high bits on 64-bit, so comparisons
+ * sign-extend the low 32 bits.
+ */
+static inline int syscall_get_nr(struct task_struct *task, struct pt_regs *regs)
 {
-	/*
-	 * We always sign-extend a -1 value being set here,
-	 * so this is always either -1L or a syscall number.
-	 */
 	return regs->orig_ax;
 }
 
