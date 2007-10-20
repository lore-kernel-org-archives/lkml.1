Return-Path: <linux-kernel-owner+w=401wt.eu-S934030AbXJTG5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934030AbXJTG5S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 02:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753769AbXJTG5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 02:57:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129AbXJTG5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 02:57:08 -0400
Date: Sat, 20 Oct 2007 02:56:59 -0400
From: Chris Snook <csnook@redhat.com>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: merge mmu{,_32,_64}.h
Message-ID: <20071020065659.GA12404@shell.boston.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Snook <csnook@redhat.com>

Merge mmu_32.h and mmu_64.h into mmu.h.

Signed-off-by: Chris Snook <csnook@redhat.com>

diff -Nurp a/include/asm-x86/mmu_32.h b/include/asm-x86/mmu_32.h
--- a/include/asm-x86/mmu_32.h	2007-10-20 02:42:24.000000000 -0400
+++ b/include/asm-x86/mmu_32.h	1969-12-31 19:00:00.000000000 -0500
@@ -1,18 +0,0 @@
-#ifndef __i386_MMU_H
-#define __i386_MMU_H
-
-#include <linux/mutex.h>
-/*
- * The i386 doesn't have a mmu context, but
- * we put the segment information here.
- *
- * cpu_vm_mask is used to optimize ldt flushing.
- */
-typedef struct { 
-	int size;
-	struct mutex lock;
-	void *ldt;
-	void *vdso;
-} mm_context_t;
-
-#endif
diff -Nurp a/include/asm-x86/mmu_64.h b/include/asm-x86/mmu_64.h
--- a/include/asm-x86/mmu_64.h	2007-10-20 02:42:24.000000000 -0400
+++ b/include/asm-x86/mmu_64.h	1969-12-31 19:00:00.000000000 -0500
@@ -1,21 +0,0 @@
-#ifndef __x86_64_MMU_H
-#define __x86_64_MMU_H
-
-#include <linux/spinlock.h>
-#include <linux/mutex.h>
-
-/*
- * The x86_64 doesn't have a mmu context, but
- * we put the segment information here.
- *
- * cpu_vm_mask is used to optimize ldt flushing.
- */
-typedef struct { 
-	void *ldt;
-	rwlock_t ldtlock; 
-	int size;
-	struct mutex lock;
-	void *vdso;
-} mm_context_t;
-
-#endif
diff -Nurp a/include/asm-x86/mmu.h b/include/asm-x86/mmu.h
--- a/include/asm-x86/mmu.h	2007-10-20 02:42:24.000000000 -0400
+++ b/include/asm-x86/mmu.h	2007-10-20 02:38:36.000000000 -0400
@@ -1,5 +1,23 @@
-#ifdef CONFIG_X86_32
-# include "mmu_32.h"
-#else
-# include "mmu_64.h"
+#ifndef _ASM_X86_MMU_H
+#define _ASM_X86_MMU_H
+
+#include <linux/spinlock.h>
+#include <linux/mutex.h>
+
+/*
+ * The x86 doesn't have a mmu context, but
+ * we put the segment information here.
+ *
+ * cpu_vm_mask is used to optimize ldt flushing.
+ */
+typedef struct { 
+	void *ldt;
+#ifdef CONFIG_X86_64
+	rwlock_t ldtlock; 
 #endif
+	int size;
+	struct mutex lock;
+	void *vdso;
+} mm_context_t;
+
+#endif /* _ASM_X86_MMU_H */
