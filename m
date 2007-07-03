Return-Path: <linux-kernel-owner+w=401wt.eu-S1760113AbXGCQqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760113AbXGCQqZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 12:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759336AbXGCQpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 12:45:25 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:45778 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755778AbXGCQpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 12:45:18 -0400
Message-Id: <20070703164514.067702380@polymtl.ca>
References: <20070703164046.645090494@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 03 Jul 2007 12:40:49 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 03/10] Immediate Values - Non Optimized Architectures
Content-Disposition: inline; filename=immediate-values-non-optimized-architectures.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue,  3 Jul 2007 16:45:14 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Architecture agnostic, generic, version of the immediate values. It uses a
global variable to mimic the immediate values.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/asm-alpha/immediate.h     |    1 +
 include/asm-arm/immediate.h       |    1 +
 include/asm-arm26/immediate.h     |    1 +
 include/asm-cris/immediate.h      |    1 +
 include/asm-frv/immediate.h       |    1 +
 include/asm-generic/immediate.h   |   14 ++++++++++++++
 include/asm-h8300/immediate.h     |    1 +
 include/asm-i386/immediate.h      |    1 +
 include/asm-ia64/immediate.h      |    1 +
 include/asm-m32r/immediate.h      |    1 +
 include/asm-m68k/immediate.h      |    1 +
 include/asm-m68knommu/immediate.h |    1 +
 include/asm-mips/immediate.h      |    1 +
 include/asm-parisc/immediate.h    |    1 +
 include/asm-powerpc/immediate.h   |    1 +
 include/asm-ppc/immediate.h       |    1 +
 include/asm-s390/immediate.h      |    1 +
 include/asm-sh/immediate.h        |    1 +
 include/asm-sh64/immediate.h      |    1 +
 include/asm-sparc/immediate.h     |    1 +
 include/asm-sparc64/immediate.h   |    1 +
 include/asm-um/immediate.h        |    1 +
 include/asm-v850/immediate.h      |    1 +
 include/asm-x86_64/immediate.h    |    1 +
 include/asm-xtensa/immediate.h    |    1 +
 25 files changed, 38 insertions(+)

Index: linux-2.6-lttng/include/asm-generic/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-generic/immediate.h	2007-06-15 16:13:55.000000000 -0400
@@ -0,0 +1,14 @@
+#ifndef _ASM_GENERIC_IMMEDIATE_H
+#define _ASM_GENERIC_IMMEDIATE_H
+
+/* Default flags, used by _immediate() */
+#define IF_DEFAULT			0
+
+/* Fallback on the generic immediate, since no optimized version is available */
+#define immediate_optimized		immediate_generic
+#define _immediate(flags, var)		immediate_generic(flags, var)
+
+/* immediate with default behavior */
+#define immediate(var)		_immediate(IF_DEFAULT, var)
+
+#endif /* _ASM_GENERIC_IMMEDIATE_H */
Index: linux-2.6-lttng/include/asm-alpha/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-alpha/immediate.h	2007-06-15 16:13:55.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-arm/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-arm/immediate.h	2007-06-15 16:13:55.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-arm26/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-arm26/immediate.h	2007-06-15 16:13:55.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-cris/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-cris/immediate.h	2007-06-15 16:13:55.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-frv/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-frv/immediate.h	2007-06-15 16:13:55.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-h8300/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-h8300/immediate.h	2007-06-15 16:13:55.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-ia64/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-ia64/immediate.h	2007-06-15 16:13:55.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-m32r/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-m32r/immediate.h	2007-06-15 16:13:55.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-m68k/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-m68k/immediate.h	2007-06-15 16:13:55.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-m68knommu/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-m68knommu/immediate.h	2007-06-15 16:13:55.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-mips/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-mips/immediate.h	2007-06-15 16:13:55.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-parisc/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-parisc/immediate.h	2007-06-15 16:13:55.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-ppc/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-ppc/immediate.h	2007-06-15 16:13:55.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-s390/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-s390/immediate.h	2007-06-15 16:13:55.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-sh/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-sh/immediate.h	2007-06-15 16:13:55.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-sh64/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-sh64/immediate.h	2007-06-15 16:13:55.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-sparc/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-sparc/immediate.h	2007-06-15 16:13:55.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-sparc64/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-sparc64/immediate.h	2007-06-15 16:13:55.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-um/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-um/immediate.h	2007-06-15 16:13:55.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-v850/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-v850/immediate.h	2007-06-15 16:13:55.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-x86_64/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-x86_64/immediate.h	2007-06-15 16:13:55.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-xtensa/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-xtensa/immediate.h	2007-06-15 16:13:55.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-i386/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-i386/immediate.h	2007-06-15 16:13:55.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-powerpc/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-powerpc/immediate.h	2007-06-15 16:13:55.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
