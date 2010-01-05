Return-Path: <linux-kernel-owner+w=401wt.eu-S932155Ab0AEWFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab0AEWFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 17:05:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755265Ab0AEWFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 17:05:44 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:40234 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212Ab0AEWFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 17:05:43 -0500
Message-Id: <20100105220437.940473705@quilx.com>
References: <20100105220417.400092933@quilx.com>
User-Agent: quilt/0.46-1
Date: Tue, 05 Jan 2010 16:04:18 -0600
From: Christoph Lameter <cl@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC local_t removal V1 1/4] Add add_local() and add_local_return()
Content-Disposition: inline; filename=remove_local_t_add_local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already have cmpxchg_local that can work on an arbitrary type. The cmpxchg
is only safe from concurrent access on the local cpu.

Add another operation that in the similar fasion allow "local" safe adds to
a variable.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 arch/alpha/include/asm/add-local.h      |    2 +
 arch/arm/include/asm/add-local.h        |    2 +
 arch/avr32/include/asm/add-local.h      |    2 +
 arch/blackfin/include/asm/add-local.h   |    2 +
 arch/cris/include/asm/add-local.h       |    2 +
 arch/frv/include/asm/add-local.h        |    2 +
 arch/h8300/include/asm/add-local.h      |    2 +
 arch/ia64/include/asm/add-local.h       |    2 +
 arch/m32r/include/asm/add-local.h       |    2 +
 arch/m68k/include/asm/add-local.h       |    2 +
 arch/microblaze/include/asm/add-local.h |    2 +
 arch/mips/include/asm/add-local.h       |    2 +
 arch/mn10300/include/asm/add-local.h    |    2 +
 arch/parisc/include/asm/add-local.h     |    2 +
 arch/powerpc/include/asm/add-local.h    |    2 +
 arch/s390/include/asm/add-local.h       |    2 +
 arch/score/include/asm/add-local.h      |    2 +
 arch/sh/include/asm/add-local.h         |    2 +
 arch/sparc/include/asm/add-local.h      |    2 +
 arch/um/include/asm/add-local.h         |    2 +
 arch/x86/include/asm/add-local.h        |    2 +
 arch/xtensa/include/asm/add-local.h     |    2 +
 include/asm-generic/add-local-generic.h |   40 ++++++++++++++++++++++++++++++++
 include/asm-generic/add-local.h         |   13 ++++++++++
 24 files changed, 97 insertions(+)

Index: linux-2.6/include/asm-generic/add-local.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/include/asm-generic/add-local.h	2010-01-05 15:36:02.000000000 -0600
@@ -0,0 +1,13 @@
+#ifndef __ASM_GENERIC_ADD_LOCAL_H
+#define __ASM_GENERIC_ADD_LOCAL_H
+
+#include <asm-generic/add-local-generic.h>
+
+#define add_return_local(ptr, v)				  	\
+	((__typeof__(*(ptr)))__add_return_local_generic((ptr), 		\
+			(unsigned long)(v), sizeof(*(ptr))))
+
+#define add_local(ptr, v) (void)__add_return_local_generic((ptr),	\
+			(unsigned long)(v), sizeof(*(ptr)))
+
+#endif
Index: linux-2.6/arch/alpha/include/asm/add-local.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/arch/alpha/include/asm/add-local.h	2010-01-05 15:36:02.000000000 -0600
@@ -0,0 +1,2 @@
+#include <asm-generic/add-local.h>
+
Index: linux-2.6/arch/arm/include/asm/add-local.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/arch/arm/include/asm/add-local.h	2010-01-05 15:36:02.000000000 -0600
@@ -0,0 +1,2 @@
+#include <asm-generic/add-local.h>
+
Index: linux-2.6/arch/avr32/include/asm/add-local.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/arch/avr32/include/asm/add-local.h	2010-01-05 15:36:02.000000000 -0600
@@ -0,0 +1,2 @@
+#include <asm-generic/add-local.h>
+
Index: linux-2.6/arch/blackfin/include/asm/add-local.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/arch/blackfin/include/asm/add-local.h	2010-01-05 15:36:02.000000000 -0600
@@ -0,0 +1,2 @@
+#include <asm-generic/add-local.h>
+
Index: linux-2.6/arch/cris/include/asm/add-local.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/arch/cris/include/asm/add-local.h	2010-01-05 15:36:02.000000000 -0600
@@ -0,0 +1,2 @@
+#include <asm-generic/add-local.h>
+
Index: linux-2.6/arch/frv/include/asm/add-local.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/arch/frv/include/asm/add-local.h	2010-01-05 15:36:02.000000000 -0600
@@ -0,0 +1,2 @@
+#include <asm-generic/add-local.h>
+
Index: linux-2.6/arch/h8300/include/asm/add-local.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/arch/h8300/include/asm/add-local.h	2010-01-05 15:36:02.000000000 -0600
@@ -0,0 +1,2 @@
+#include <asm-generic/add-local.h>
+
Index: linux-2.6/arch/ia64/include/asm/add-local.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/arch/ia64/include/asm/add-local.h	2010-01-05 15:36:02.000000000 -0600
@@ -0,0 +1,2 @@
+#include <asm-generic/add-local.h>
+
Index: linux-2.6/arch/m32r/include/asm/add-local.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/arch/m32r/include/asm/add-local.h	2010-01-05 15:36:02.000000000 -0600
@@ -0,0 +1,2 @@
+#include <asm-generic/add-local.h>
+
Index: linux-2.6/arch/m68k/include/asm/add-local.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/arch/m68k/include/asm/add-local.h	2010-01-05 15:36:02.000000000 -0600
@@ -0,0 +1,2 @@
+#include <asm-generic/add-local.h>
+
Index: linux-2.6/arch/microblaze/include/asm/add-local.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/arch/microblaze/include/asm/add-local.h	2010-01-05 15:36:02.000000000 -0600
@@ -0,0 +1,2 @@
+#include <asm-generic/add-local.h>
+
Index: linux-2.6/arch/mips/include/asm/add-local.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/arch/mips/include/asm/add-local.h	2010-01-05 15:36:02.000000000 -0600
@@ -0,0 +1,2 @@
+#include <asm-generic/add-local.h>
+
Index: linux-2.6/arch/mn10300/include/asm/add-local.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/arch/mn10300/include/asm/add-local.h	2010-01-05 15:36:02.000000000 -0600
@@ -0,0 +1,2 @@
+#include <asm-generic/add-local.h>
+
Index: linux-2.6/arch/parisc/include/asm/add-local.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/arch/parisc/include/asm/add-local.h	2010-01-05 15:36:02.000000000 -0600
@@ -0,0 +1,2 @@
+#include <asm-generic/add-local.h>
+
Index: linux-2.6/arch/powerpc/include/asm/add-local.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/arch/powerpc/include/asm/add-local.h	2010-01-05 15:36:02.000000000 -0600
@@ -0,0 +1,2 @@
+#include <asm-generic/add-local.h>
+
Index: linux-2.6/arch/s390/include/asm/add-local.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/arch/s390/include/asm/add-local.h	2010-01-05 15:36:02.000000000 -0600
@@ -0,0 +1,2 @@
+#include <asm-generic/add-local.h>
+
Index: linux-2.6/arch/score/include/asm/add-local.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/arch/score/include/asm/add-local.h	2010-01-05 15:36:02.000000000 -0600
@@ -0,0 +1,2 @@
+#include <asm-generic/add-local.h>
+
Index: linux-2.6/arch/sh/include/asm/add-local.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/arch/sh/include/asm/add-local.h	2010-01-05 15:36:02.000000000 -0600
@@ -0,0 +1,2 @@
+#include <asm-generic/add-local.h>
+
Index: linux-2.6/arch/sparc/include/asm/add-local.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/arch/sparc/include/asm/add-local.h	2010-01-05 15:36:02.000000000 -0600
@@ -0,0 +1,2 @@
+#include <asm-generic/add-local.h>
+
Index: linux-2.6/arch/um/include/asm/add-local.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/arch/um/include/asm/add-local.h	2010-01-05 15:36:02.000000000 -0600
@@ -0,0 +1,2 @@
+#include <asm-generic/add-local.h>
+
Index: linux-2.6/arch/x86/include/asm/add-local.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/arch/x86/include/asm/add-local.h	2010-01-05 15:36:02.000000000 -0600
@@ -0,0 +1,2 @@
+#include <asm-generic/add-local.h>
+
Index: linux-2.6/arch/xtensa/include/asm/add-local.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/arch/xtensa/include/asm/add-local.h	2010-01-05 15:36:02.000000000 -0600
@@ -0,0 +1,2 @@
+#include <asm-generic/add-local.h>
+
Index: linux-2.6/include/asm-generic/add-local-generic.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/include/asm-generic/add-local-generic.h	2010-01-05 15:36:02.000000000 -0600
@@ -0,0 +1,40 @@
+#ifndef __ASM_GENERIC_ADD_LOCAL_GENERIC_H
+#define __ASM_GENERIC_ADD_LOCAL_GENERIC_H
+
+#include <linux/types.h>
+
+extern unsigned long wrong_size_add_local(volatile void *ptr);
+
+/*
+ * Generic version of __add_return_local (disables interrupts). Takes an
+ * unsigned long parameter, supporting various types of architectures.
+ */
+static inline unsigned long __add_return_local_generic(volatile void *ptr,
+		unsigned long value, int size)
+{
+	unsigned long flags, r;
+
+	/*
+	 * Sanity checking, compile-time.
+	 */
+	if (size == 8 && sizeof(unsigned long) != 8)
+		wrong_size_add_local(ptr);
+
+	local_irq_save(flags);
+	switch (size) {
+	case 1: r = (*((u8 *)ptr) += value);
+		break;
+	case 2: r = (*((u16 *)ptr) += value);
+		break;
+	case 4: r = (*((u32 *)ptr) += value);
+		break;
+	case 8: r = (*((u64 *)ptr) += value);
+		break;
+	default:
+		wrong_size_add_local(ptr);
+	}
+	local_irq_restore(flags);
+	return r;
+}
+
+#endif

-- 
