Return-Path: <linux-kernel-owner+w=401wt.eu-S1762653AbXJTKhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762653AbXJTKhY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 06:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755660AbXJTKhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 06:37:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755299AbXJTKhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 06:37:10 -0400
Date: Sat, 20 Oct 2007 06:37:01 -0400
From: Chris Snook <csnook@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: unify a.out{,_32,_64}.h
Message-ID: <20071020103701.GA2728@shell.boston.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Snook <csnook@redhat.com>

Unify x86 a.out_32.h and a.out_64.h

Signed-off-by: Chris Snook <csnook@redhat.com>

diff -Nurp a/include/asm-x86/a.out_32.h b/include/asm-x86/a.out_32.h
--- a/include/asm-x86/a.out_32.h	2007-10-20 06:20:01.000000000 -0400
+++ b/include/asm-x86/a.out_32.h	1969-12-31 19:00:00.000000000 -0500
@@ -1,27 +0,0 @@
-#ifndef __I386_A_OUT_H__
-#define __I386_A_OUT_H__
-
-struct exec
-{
-  unsigned long a_info;		/* Use macros N_MAGIC, etc for access */
-  unsigned a_text;		/* length of text, in bytes */
-  unsigned a_data;		/* length of data, in bytes */
-  unsigned a_bss;		/* length of uninitialized data area for file, in bytes */
-  unsigned a_syms;		/* length of symbol table data in file, in bytes */
-  unsigned a_entry;		/* start address */
-  unsigned a_trsize;		/* length of relocation info for text, in bytes */
-  unsigned a_drsize;		/* length of relocation info for data, in bytes */
-};
-
-#define N_TRSIZE(a)	((a).a_trsize)
-#define N_DRSIZE(a)	((a).a_drsize)
-#define N_SYMSIZE(a)	((a).a_syms)
-
-#ifdef __KERNEL__
-
-#define STACK_TOP	TASK_SIZE
-#define STACK_TOP_MAX	STACK_TOP
-
-#endif
-
-#endif /* __A_OUT_GNU_H__ */
diff -Nurp a/include/asm-x86/a.out_64.h b/include/asm-x86/a.out_64.h
--- a/include/asm-x86/a.out_64.h	2007-10-20 06:20:01.000000000 -0400
+++ b/include/asm-x86/a.out_64.h	1969-12-31 19:00:00.000000000 -0500
@@ -1,28 +0,0 @@
-#ifndef __X8664_A_OUT_H__
-#define __X8664_A_OUT_H__
-
-/* 32bit a.out */
-
-struct exec
-{
-  unsigned int a_info;		/* Use macros N_MAGIC, etc for access */
-  unsigned a_text;		/* length of text, in bytes */
-  unsigned a_data;		/* length of data, in bytes */
-  unsigned a_bss;		/* length of uninitialized data area for file, in bytes */
-  unsigned a_syms;		/* length of symbol table data in file, in bytes */
-  unsigned a_entry;		/* start address */
-  unsigned a_trsize;		/* length of relocation info for text, in bytes */
-  unsigned a_drsize;		/* length of relocation info for data, in bytes */
-};
-
-#define N_TRSIZE(a)	((a).a_trsize)
-#define N_DRSIZE(a)	((a).a_drsize)
-#define N_SYMSIZE(a)	((a).a_syms)
-
-#ifdef __KERNEL__
-#include <linux/thread_info.h>
-#define STACK_TOP	TASK_SIZE
-#define STACK_TOP_MAX	TASK_SIZE64
-#endif
-
-#endif /* __A_OUT_GNU_H__ */
diff -Nurp a/include/asm-x86/a.out.h b/include/asm-x86/a.out.h
--- a/include/asm-x86/a.out.h	2007-10-20 06:20:01.000000000 -0400
+++ b/include/asm-x86/a.out.h	2007-10-20 06:14:26.000000000 -0400
@@ -1,13 +1,32 @@
+#ifndef _ASM_X86_A_OUT_H
+#define _ASM_X86_A_OUT_H
+
+/* 32bit a.out */
+
+struct exec
+{
+  unsigned int a_info;		/* Use macros N_MAGIC, etc for access */
+  unsigned a_text;		/* length of text, in bytes */
+  unsigned a_data;		/* length of data, in bytes */
+  unsigned a_bss;		/* length of uninitialized data area for file, in bytes */
+  unsigned a_syms;		/* length of symbol table data in file, in bytes */
+  unsigned a_entry;		/* start address */
+  unsigned a_trsize;		/* length of relocation info for text, in bytes */
+  unsigned a_drsize;		/* length of relocation info for data, in bytes */
+};
+
+#define N_TRSIZE(a)	((a).a_trsize)
+#define N_DRSIZE(a)	((a).a_drsize)
+#define N_SYMSIZE(a)	((a).a_syms)
+
 #ifdef __KERNEL__
+# include <linux/thread_info.h>
+# define STACK_TOP	TASK_SIZE
 # ifdef CONFIG_X86_32
-#  include "a.out_32.h"
+#  define STACK_TOP_MAX	STACK_TOP
 # else
-#  include "a.out_64.h"
-# endif
-#else
-# ifdef __i386__
-#  include "a.out_32.h"
-# else
-#  include "a.out_64.h"
+#  define STACK_TOP_MAX	TASK_SIZE64
 # endif
 #endif
+
+#endif /* _ASM_X86_A_OUT_H */
