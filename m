Return-Path: <linux-kernel-owner+w=401wt.eu-S1765402AbYDYSAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765402AbYDYSAx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 14:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763751AbYDYR5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 13:57:11 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:53127 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764781AbYDYR5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 13:57:02 -0400
Date: Fri, 25 Apr 2008 13:56:09 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Cc: linux-arch@vger.kernel.org
Subject: [PATCH 8/19] asm/futex.h should include linux/uaccess.h
Message-ID: <20080425175609.GA11186@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lots of asm-*/futex.h call pagefault_enable and pagefault_disable,
which are declared in linux/uaccess.h, without including
linux/uaccess.h.

They all include asm/uaccess.h, so this patch replaces asm/uaccess.h
with linux/uaccess.h.

Compile-tested on sparc64, x86, ia64, mips, and powerpc.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 include/asm-generic/futex.h |    2 +-
 include/asm-ia64/futex.h    |    2 +-
 include/asm-mips/futex.h    |    2 +-
 include/asm-parisc/futex.h  |    2 +-
 include/asm-powerpc/futex.h |    2 +-
 include/asm-sh/futex.h      |    2 +-
 include/asm-sparc64/futex.h |    2 +-
 include/asm-x86/futex.h     |    2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

Index: linux-2.6.22/include/asm-generic/futex.h
===================================================================
--- linux-2.6.22.orig/include/asm-generic/futex.h	2008-02-12 12:47:49.000000000 -0500
+++ linux-2.6.22/include/asm-generic/futex.h	2008-02-12 12:47:52.000000000 -0500
@@ -4,8 +4,8 @@
 #ifdef __KERNEL__
 
 #include <linux/futex.h>
+#include <linux/uaccess.h>
 #include <asm/errno.h>
-#include <asm/uaccess.h>
 
 static inline int
 futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
Index: linux-2.6.22/include/asm-ia64/futex.h
===================================================================
--- linux-2.6.22.orig/include/asm-ia64/futex.h	2007-07-08 19:32:17.000000000 -0400
+++ linux-2.6.22/include/asm-ia64/futex.h	2008-02-12 12:49:31.000000000 -0500
@@ -2,9 +2,9 @@
 #define _ASM_FUTEX_H
 
 #include <linux/futex.h>
+#include <linux/uaccess.h>
 #include <asm/errno.h>
 #include <asm/system.h>
-#include <asm/uaccess.h>
 
 #define __futex_atomic_op1(insn, ret, oldval, uaddr, oparg) \
 do {									\
Index: linux-2.6.22/include/asm-mips/futex.h
===================================================================
--- linux-2.6.22.orig/include/asm-mips/futex.h	2007-12-05 10:29:35.000000000 -0500
+++ linux-2.6.22/include/asm-mips/futex.h	2008-02-12 12:49:49.000000000 -0500
@@ -11,9 +11,9 @@
 #ifdef __KERNEL__
 
 #include <linux/futex.h>
+#include <linux/uaccess.h>
 #include <asm/barrier.h>
 #include <asm/errno.h>
-#include <asm/uaccess.h>
 #include <asm/war.h>
 
 #define __futex_atomic_op(insn, ret, oldval, uaddr, oparg)		\
Index: linux-2.6.22/include/asm-parisc/futex.h
===================================================================
--- linux-2.6.22.orig/include/asm-parisc/futex.h	2007-07-08 19:32:17.000000000 -0400
+++ linux-2.6.22/include/asm-parisc/futex.h	2008-02-12 12:50:03.000000000 -0500
@@ -4,8 +4,8 @@
 #ifdef __KERNEL__
 
 #include <linux/futex.h>
+#include <linux/uaccess.h>
 #include <asm/errno.h>
-#include <asm/uaccess.h>
 
 static inline int
 futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
Index: linux-2.6.22/include/asm-powerpc/futex.h
===================================================================
--- linux-2.6.22.orig/include/asm-powerpc/futex.h	2007-07-08 19:32:17.000000000 -0400
+++ linux-2.6.22/include/asm-powerpc/futex.h	2008-02-12 12:50:22.000000000 -0500
@@ -4,9 +4,9 @@
 #ifdef __KERNEL__
 
 #include <linux/futex.h>
+#include <linux/uaccess.h>
 #include <asm/errno.h>
 #include <asm/synch.h>
-#include <asm/uaccess.h>
 #include <asm/asm-compat.h>
 
 #define __futex_atomic_op(insn, ret, oldval, uaddr, oparg) \
Index: linux-2.6.22/include/asm-sh/futex.h
===================================================================
--- linux-2.6.22.orig/include/asm-sh/futex.h	2007-10-12 12:07:06.000000000 -0400
+++ linux-2.6.22/include/asm-sh/futex.h	2008-02-12 12:51:17.000000000 -0500
@@ -4,8 +4,8 @@
 #ifdef __KERNEL__
 
 #include <linux/futex.h>
+#include <linux/uaccess.h>
 #include <asm/errno.h>
-#include <asm/uaccess.h>
 
 /* XXX: UP variants, fix for SH-4A and SMP.. */
 #include <asm/futex-irq.h>
Index: linux-2.6.22/include/asm-sparc64/futex.h
===================================================================
--- linux-2.6.22.orig/include/asm-sparc64/futex.h	2007-11-14 10:33:41.000000000 -0500
+++ linux-2.6.22/include/asm-sparc64/futex.h	2008-02-12 12:51:35.000000000 -0500
@@ -2,9 +2,9 @@
 #define _SPARC64_FUTEX_H
 
 #include <linux/futex.h>
+#include <linux/uaccess.h>
 #include <asm/errno.h>
 #include <asm/system.h>
-#include <asm/uaccess.h>
 
 #define __futex_cas_op(insn, ret, oldval, uaddr, oparg)	\
 	__asm__ __volatile__(				\
Index: linux-2.6.22/include/asm-x86/futex.h
===================================================================
--- linux-2.6.22.orig/include/asm-x86/futex.h	2008-02-05 12:25:21.000000000 -0500
+++ linux-2.6.22/include/asm-x86/futex.h	2008-02-12 12:51:51.000000000 -0500
@@ -4,12 +4,12 @@
 #ifdef __KERNEL__
 
 #include <linux/futex.h>
+#include <linux/uaccess.h>
 
 #include <asm/asm.h>
 #include <asm/errno.h>
 #include <asm/processor.h>
 #include <asm/system.h>
-#include <asm/uaccess.h>
 
 #define __futex_atomic_op1(insn, ret, oldval, uaddr, oparg)	\
   __asm__ __volatile(						\
