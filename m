Return-Path: <linux-kernel-owner+w=401wt.eu-S1754639AbZC2W0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbZC2W0a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 18:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbZC2W0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 18:26:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:47429 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531AbZC2W0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 18:26:20 -0400
Date: Sun, 29 Mar 2009 22:24:36 GMT
From: Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, tglx@linutronix.de, hpa@linux.intel.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, tglx@linutronix.de, hpa@linux.intel.com,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:x86/mm] x86/mm: further cleanups of fault.c's include file section
Message-ID: <tip-56aea8468746e673a4bf50b6a13d97b2d1cbe1e8@git.kernel.org>
Git-Commit-ID: 56aea8468746e673a4bf50b6a13d97b2d1cbe1e8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 29 Mar 2009 22:24:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  56aea8468746e673a4bf50b6a13d97b2d1cbe1e8
Gitweb:     http://git.kernel.org/tip/56aea8468746e673a4bf50b6a13d97b2d1cbe1e8
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sun, 29 Mar 2009 23:47:48 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 30 Mar 2009 00:10:22 +0200

x86/mm: further cleanups of fault.c's include file section

Impact: cleanup

Eliminate more than 20 unnecessary #include lines in fault.c

Also fix include file dependency bug in asm/traps.h. (this was
masked before, by implicit inclusion)

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <new-submission>
Acked-by: H. Peter Anvin <hpa@linux.intel.com>


---
 arch/x86/include/asm/traps.h |    1 +
 arch/x86/mm/fault.c          |   41 ++++++++---------------------------------
 2 files changed, 9 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 0d53425..37fb07a 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -2,6 +2,7 @@
 #define _ASM_X86_TRAPS_H
 
 #include <asm/debugreg.h>
+#include <asm/siginfo.h>			/* TRAP_TRACE, ... */
 
 #ifdef CONFIG_X86_32
 #define dotraplinkage
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index a03b727..f3c4d03 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -3,40 +3,15 @@
  *  Copyright (C) 2001, 2002 Andi Kleen, SuSE Labs.
  *  Copyright (C) 2008-2009, Red Hat Inc., Ingo Molnar
  */
-#include <linux/interrupt.h>
-#include <linux/mmiotrace.h>
-#include <linux/bootmem.h>
-#include <linux/compiler.h>
-#include <linux/highmem.h>
-#include <linux/kprobes.h>
-#include <linux/uaccess.h>
-#include <linux/vmalloc.h>
-#include <linux/vt_kern.h>
-#include <linux/signal.h>
-#include <linux/kernel.h>
-#include <linux/ptrace.h>
-#include <linux/string.h>
-#include <linux/module.h>
-#include <linux/kdebug.h>
-#include <linux/errno.h>
-#include <linux/magic.h>
-#include <linux/sched.h>
-#include <linux/types.h>
-#include <linux/init.h>
-#include <linux/mman.h>
-#include <linux/tty.h>
-#include <linux/smp.h>
-#include <linux/mm.h>
-
-#include <asm-generic/sections.h>
-
-#include <asm/tlbflush.h>
-#include <asm/pgalloc.h>
-#include <asm/segment.h>
-#include <asm/system.h>
-#include <asm/proto.h>
-#include <asm/traps.h>
-#include <asm/desc.h>
+#include <linux/magic.h>		/* STACK_END_MAGIC		*/
+#include <linux/kdebug.h>		/* oops_begin/end, ...		*/
+#include <linux/module.h>		/* search_exception_table	*/
+#include <linux/bootmem.h>		/* max_low_pfn			*/
+#include <linux/kprobes.h>		/* __kprobes, ...		*/
+#include <linux/mmiotrace.h>		/* kmmio_handler, ...		*/
+
+#include <asm/traps.h>			/* dotraplinkage, ...		*/
+#include <asm/pgalloc.h>		/* pgd_*(), ...			*/
 
 /*
  * Page fault error code bits:
