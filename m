Return-Path: <linux-kernel-owner+w=401wt.eu-S1756187AbXE3ODa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbXE3ODa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 10:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754788AbXE3OCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 10:02:36 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:46334 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754121AbXE3OCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 10:02:34 -0400
Message-Id: <20070530140227.682262714@polymtl.ca>
References: <20070530140025.917261793@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 30 May 2007 10:00:28 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 3/9] Conditional Calls - Non Optimized Architectures
Content-Disposition: inline; filename=conditional-calls-non-optimized-architectures.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed, 30 May 2007 14:02:28 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Architecture agnostic, generic, version of the cond_calls.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/asm-alpha/condcall.h     |    1 +
 include/asm-arm/condcall.h       |    1 +
 include/asm-arm26/condcall.h     |    1 +
 include/asm-cris/condcall.h      |    1 +
 include/asm-frv/condcall.h       |    1 +
 include/asm-generic/condcall.h   |   25 +++++++++++++++++++++++++
 include/asm-h8300/condcall.h     |    1 +
 include/asm-i386/condcall.h      |    1 +
 include/asm-ia64/condcall.h      |    1 +
 include/asm-m32r/condcall.h      |    1 +
 include/asm-m68k/condcall.h      |    1 +
 include/asm-m68knommu/condcall.h |    1 +
 include/asm-mips/condcall.h      |    1 +
 include/asm-parisc/condcall.h    |    1 +
 include/asm-powerpc/condcall.h   |    1 +
 include/asm-ppc/condcall.h       |    1 +
 include/asm-s390/condcall.h      |    1 +
 include/asm-sh/condcall.h        |    1 +
 include/asm-sh64/condcall.h      |    1 +
 include/asm-sparc/condcall.h     |    1 +
 include/asm-sparc64/condcall.h   |    1 +
 include/asm-um/condcall.h        |    1 +
 include/asm-v850/condcall.h      |    1 +
 include/asm-x86_64/condcall.h    |    1 +
 include/asm-xtensa/condcall.h    |    1 +
 25 files changed, 49 insertions(+)

Index: linux-2.6-lttng/include/asm-generic/condcall.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-generic/condcall.h	2007-05-29 11:56:07.000000000 -0400
@@ -0,0 +1,25 @@
+#ifndef _ASM_GENERIC_CONDCALL_H
+#define _ASM_GENERIC_CONDCALL_H
+
+/* Default flags, used by _cond_call() */
+#define CF_DEFAULT			0
+
+/* Fallback on the generic cond_call, since no optimized version is available */
+#define cond_call_optimized		cond_call_generic
+#define _cond_call(flags, name, func) cond_call_generic(flags, name, func)
+
+/* cond_call with default behavior */
+#define cond_call(name, func) _cond_call(CF_DEFAULT, name, func)
+
+/* Architecture dependant cond_call information, used internally for cond_call
+ * activation. */
+
+#define COND_CALL_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET \
+		COND_CALL_GENERIC_ENABLE_IMMEDIATE_OFFSET
+#define COND_CALL_OPTIMIZED_ENABLE_TYPE	COND_CALL_GENERIC_ENABLE_TYPE
+/* Dereference enable as lvalue from a pointer to its instruction */
+#define COND_CALL_OPTIMIZED_ENABLE	COND_CALL_GENERIC_ENABLE
+
+#define cond_call_optimized_set_enable cond_call_generic_set_enable
+
+#endif /* _ASM_GENERIC_MARKER_H */
Index: linux-2.6-lttng/include/asm-alpha/condcall.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-alpha/condcall.h	2007-05-29 11:55:58.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/condcall.h>
Index: linux-2.6-lttng/include/asm-arm/condcall.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-arm/condcall.h	2007-05-29 11:55:58.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/condcall.h>
Index: linux-2.6-lttng/include/asm-arm26/condcall.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-arm26/condcall.h	2007-05-29 11:55:58.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/condcall.h>
Index: linux-2.6-lttng/include/asm-cris/condcall.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-cris/condcall.h	2007-05-29 11:55:58.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/condcall.h>
Index: linux-2.6-lttng/include/asm-frv/condcall.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-frv/condcall.h	2007-05-29 11:55:58.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/condcall.h>
Index: linux-2.6-lttng/include/asm-h8300/condcall.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-h8300/condcall.h	2007-05-29 11:55:58.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/condcall.h>
Index: linux-2.6-lttng/include/asm-ia64/condcall.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-ia64/condcall.h	2007-05-29 11:55:58.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/condcall.h>
Index: linux-2.6-lttng/include/asm-m32r/condcall.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-m32r/condcall.h	2007-05-29 11:55:58.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/condcall.h>
Index: linux-2.6-lttng/include/asm-m68k/condcall.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-m68k/condcall.h	2007-05-29 11:55:58.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/condcall.h>
Index: linux-2.6-lttng/include/asm-m68knommu/condcall.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-m68knommu/condcall.h	2007-05-29 11:55:58.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/condcall.h>
Index: linux-2.6-lttng/include/asm-mips/condcall.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-mips/condcall.h	2007-05-29 11:55:58.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/condcall.h>
Index: linux-2.6-lttng/include/asm-parisc/condcall.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-parisc/condcall.h	2007-05-29 11:55:58.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/condcall.h>
Index: linux-2.6-lttng/include/asm-ppc/condcall.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-ppc/condcall.h	2007-05-29 11:55:58.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/condcall.h>
Index: linux-2.6-lttng/include/asm-s390/condcall.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-s390/condcall.h	2007-05-29 11:55:58.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/condcall.h>
Index: linux-2.6-lttng/include/asm-sh/condcall.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-sh/condcall.h	2007-05-29 11:55:58.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/condcall.h>
Index: linux-2.6-lttng/include/asm-sh64/condcall.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-sh64/condcall.h	2007-05-29 11:55:58.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/condcall.h>
Index: linux-2.6-lttng/include/asm-sparc/condcall.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-sparc/condcall.h	2007-05-29 11:55:58.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/condcall.h>
Index: linux-2.6-lttng/include/asm-sparc64/condcall.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-sparc64/condcall.h	2007-05-29 11:55:58.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/condcall.h>
Index: linux-2.6-lttng/include/asm-um/condcall.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-um/condcall.h	2007-05-29 11:55:58.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/condcall.h>
Index: linux-2.6-lttng/include/asm-v850/condcall.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-v850/condcall.h	2007-05-29 11:55:58.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/condcall.h>
Index: linux-2.6-lttng/include/asm-x86_64/condcall.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-x86_64/condcall.h	2007-05-29 11:55:58.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/condcall.h>
Index: linux-2.6-lttng/include/asm-xtensa/condcall.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-xtensa/condcall.h	2007-05-29 11:55:58.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/condcall.h>
Index: linux-2.6-lttng/include/asm-i386/condcall.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-i386/condcall.h	2007-05-29 11:55:58.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/condcall.h>
Index: linux-2.6-lttng/include/asm-powerpc/condcall.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-powerpc/condcall.h	2007-05-29 11:55:58.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/condcall.h>

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
