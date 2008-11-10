Return-Path: <linux-kernel-owner+w=401wt.eu-S1755213AbYKJHwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbYKJHwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 02:52:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbYKJHwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 02:52:14 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58445 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656AbYKJHwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 02:52:12 -0500
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <20081110909.153463053@firstfloor.org>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] [1/2] Move iomap.h into arch/x86/include/asm
Date: Mon, 10 Nov 2008 09:09:38 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Otherwise DRM doesn't compile:

In file included from linux-2.6.28-rc4/drivers/gpu/drm/i915/i915_drv.h:34,
                 from linux-2.6.28-rc4/drivers/gpu/drm/i915/i915_drv.c:33:
linux-2.6.28-rc4/include/linux/io-mapping.h:24:23: error: asm/iomap.h: No such file or directory


Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/include/asm/iomap.h |   30 ++++++++++++++++++++++++++++++
 include/asm-x86/iomap.h      |   30 ------------------------------
 2 files changed, 30 insertions(+), 30 deletions(-)

Index: linux-2.6.28-rc4-test/include/asm-x86/iomap.h
===================================================================
--- linux-2.6.28-rc4-test.orig/include/asm-x86/iomap.h	2008-11-10 09:03:09.000000000 +0100
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,30 +0,0 @@
-/*
- * Copyright © 2008 Ingo Molnar
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License along
- * with this program; if not, write to the Free Software Foundation, Inc.,
- * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
- */
-
-#include <linux/fs.h>
-#include <linux/mm.h>
-#include <linux/uaccess.h>
-#include <asm/cacheflush.h>
-#include <asm/pgtable.h>
-#include <asm/tlbflush.h>
-
-void *
-iomap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot);
-
-void
-iounmap_atomic(void *kvaddr, enum km_type type);
Index: linux-2.6.28-rc4-test/arch/x86/include/asm/iomap.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.28-rc4-test/arch/x86/include/asm/iomap.h	2008-11-10 09:03:09.000000000 +0100
@@ -0,0 +1,30 @@
+/*
+ * Copyright © 2008 Ingo Molnar
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ */
+
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/uaccess.h>
+#include <asm/cacheflush.h>
+#include <asm/pgtable.h>
+#include <asm/tlbflush.h>
+
+void *
+iomap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot);
+
+void
+iounmap_atomic(void *kvaddr, enum km_type type);
