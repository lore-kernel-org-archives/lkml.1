Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbYDMSRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbYDMSRd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 14:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839AbYDMSQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 14:16:40 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:54157 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792AbYDMSQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 14:16:39 -0400
Date: Sun, 13 Apr 2008 21:15:38 +0300
From: Adrian Bunk <adrian.bunk@movial.fi>
To: Takuo Koguchi <takuo.koguchi.sw@hitachi.com>,
       Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6.25 patch] sh64: add missing #include <asm/fpu.h>'s
Message-ID: <20080413181538.GE2182@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes some compile errors due to missing save_fpu() 
prototypes on sh64 caused by
commit 9bbafce2eec190ef7e44b0eb1095ba17ce6ad3af
(sh: Fix occasional FPU register corruption under preempt).

Signed-off-by: Adrian Bunk <adrian.bunk@movial.fi>

---

 arch/sh/kernel/process_64.c |    1 +
 arch/sh/kernel/ptrace_64.c  |    1 +
 arch/sh/kernel/signal_64.c  |    1 +
 arch/sh/kernel/traps_64.c   |    1 +
 4 files changed, 4 insertions(+)

f98fec7956bd7156a11c42acdcf49dc41c5df61e diff --git a/arch/sh/kernel/process_64.c b/arch/sh/kernel/process_64.c
index 046999b..0283d81 100644
--- a/arch/sh/kernel/process_64.c
+++ b/arch/sh/kernel/process_64.c
@@ -28,6 +28,7 @@
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/mmu_context.h>
+#include <asm/fpu.h>
 
 struct task_struct *last_task_used_math = NULL;
 
diff --git a/arch/sh/kernel/ptrace_64.c b/arch/sh/kernel/ptrace_64.c
index f6fbdfa..d453c47 100644
--- a/arch/sh/kernel/ptrace_64.c
+++ b/arch/sh/kernel/ptrace_64.c
@@ -33,6 +33,7 @@
 #include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/mmu_context.h>
+#include <asm/fpu.h>
 
 /* This mask defines the bits of the SR which the user is not allowed to
    change, which are everything except S, Q, M, PR, SZ, FR. */
diff --git a/arch/sh/kernel/signal_64.c b/arch/sh/kernel/signal_64.c
index 80bde19..552eb81 100644
--- a/arch/sh/kernel/signal_64.c
+++ b/arch/sh/kernel/signal_64.c
@@ -26,6 +26,7 @@
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/cacheflush.h>
+#include <asm/fpu.h>
 
 #define REG_RET 9
 #define REG_ARG1 2
diff --git a/arch/sh/kernel/traps_64.c b/arch/sh/kernel/traps_64.c
index 1b58a74..a85831c 100644
--- a/arch/sh/kernel/traps_64.c
+++ b/arch/sh/kernel/traps_64.c
@@ -30,6 +30,7 @@
 #include <asm/atomic.h>
 #include <asm/processor.h>
 #include <asm/pgtable.h>
+#include <asm/fpu.h>
 
 #undef DEBUG_EXCEPTION
 #ifdef DEBUG_EXCEPTION

