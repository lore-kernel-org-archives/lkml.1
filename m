Return-Path: <linux-kernel-owner+w=401wt.eu-S1765545AbXGNB33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765545AbXGNB33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 21:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764740AbXGNB1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 21:27:10 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:38484 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764730AbXGNB1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 21:27:05 -0400
Message-Id: <20070714012623.528545293@polymtl.ca>
References: <20070714012439.285079881@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 13 Jul 2007 21:24:42 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 3/8] Immediate Values - Non Optimized Architectures
Content-Disposition: inline; filename=immediate-values-non-optimized-architectures.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sat, 14 Jul 2007 01:26:24 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Architecture agnostic, generic, version of the immediate values. It uses a
global variable to mimic the immediate values.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/asm-alpha/immediate.h     |    1 +
 include/asm-arm/immediate.h       |    1 +
 include/asm-arm26/immediate.h     |    1 +
 include/asm-blackfin/immediate.h  |    1 +
 include/asm-cris/immediate.h      |    1 +
 include/asm-frv/immediate.h       |    1 +
 include/asm-generic/immediate.h   |   19 +++++++++++++++++++
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
 26 files changed, 44 insertions(+)

Index: linux-2.6-lttng/include/asm-generic/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-generic/immediate.h	2007-07-13 19:30:52.000000000 -0400
@@ -0,0 +1,19 @@
+#ifndef _ASM_GENERIC_IMMEDIATE_H
+#define _ASM_GENERIC_IMMEDIATE_H
+
+/*
+ * Generic immediate values: a simple, standard, memory load.
+ */
+
+struct module;
+
+#define immediate_read(var)		_immediate_read(var)
+#define immediate_set(var, i)		((var)->value = (i))
+#define _immediate_set(var, i)		immediate_set(var, i)
+#define immediate_set_early(var, i)	immediate_set(var, i)
+#define immediate_if(var)		if (immediate_read(var))
+
+static inline void module_immediate_setup(struct module *mod) { }
+static inline void immediate_update_early(void) { }
+
+#endif /* _ASM_GENERIC_IMMEDIATE_H */
Index: linux-2.6-lttng/include/asm-alpha/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-alpha/immediate.h	2007-07-13 19:30:52.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-arm/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-arm/immediate.h	2007-07-13 19:30:52.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-arm26/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-arm26/immediate.h	2007-07-13 19:30:52.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-cris/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-cris/immediate.h	2007-07-13 19:30:52.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-frv/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-frv/immediate.h	2007-07-13 19:30:52.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-h8300/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-h8300/immediate.h	2007-07-13 19:30:52.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-ia64/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-ia64/immediate.h	2007-07-13 19:30:52.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-m32r/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-m32r/immediate.h	2007-07-13 19:30:52.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-m68k/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-m68k/immediate.h	2007-07-13 19:30:52.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-m68knommu/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-m68knommu/immediate.h	2007-07-13 19:30:52.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-mips/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-mips/immediate.h	2007-07-13 19:30:52.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-parisc/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-parisc/immediate.h	2007-07-13 19:30:52.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-ppc/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-ppc/immediate.h	2007-07-13 19:30:52.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-s390/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-s390/immediate.h	2007-07-13 19:30:52.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-sh/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-sh/immediate.h	2007-07-13 19:30:52.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-sh64/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-sh64/immediate.h	2007-07-13 19:30:52.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-sparc/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-sparc/immediate.h	2007-07-13 19:30:52.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-sparc64/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-sparc64/immediate.h	2007-07-13 19:30:52.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-um/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-um/immediate.h	2007-07-13 19:30:52.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-v850/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-v850/immediate.h	2007-07-13 19:30:52.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-x86_64/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-x86_64/immediate.h	2007-07-13 19:30:52.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-xtensa/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-xtensa/immediate.h	2007-07-13 19:30:52.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-i386/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-i386/immediate.h	2007-07-13 20:02:08.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-powerpc/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-powerpc/immediate.h	2007-07-13 20:02:08.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>
Index: linux-2.6-lttng/include/asm-blackfin/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-blackfin/immediate.h	2007-07-13 20:02:35.000000000 -0400
@@ -0,0 +1 @@
+#include <asm-generic/immediate.h>

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
