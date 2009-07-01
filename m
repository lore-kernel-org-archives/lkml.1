Return-Path: <linux-kernel-owner+w=401wt.eu-S1753474AbZGAQr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbZGAQr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 12:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752207AbZGAQrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 12:47:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36657 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbZGAQrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 12:47:19 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] FRV: Add basic performance counter support
To: mingo@elte.hu
Cc: torvalds@osdl.org, akpm@linux-foundation.org, paulus@samba.org,
       arnd@arndb.de, dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Wed, 01 Jul 2009 17:47:05 +0100
Message-ID: <20090701164705.29780.60902.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090701144913.GA28172@elte.hu>
References: <20090701144913.GA28172@elte.hu>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add basic performance counter support to the FRV arch.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/Kconfig                    |    1 +
 arch/frv/include/asm/perf_counter.h |   17 +++++++++++++++++
 arch/frv/lib/Makefile               |    2 +-
 arch/frv/lib/perf_counter.c         |   19 +++++++++++++++++++
 4 files changed, 38 insertions(+), 1 deletions(-)
 create mode 100644 arch/frv/include/asm/perf_counter.h
 create mode 100644 arch/frv/lib/perf_counter.c


diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index 8a5bd7a..b86e19c 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -7,6 +7,7 @@ config FRV
 	default y
 	select HAVE_IDE
 	select HAVE_ARCH_TRACEHOOK
+	select HAVE_PERF_COUNTERS
 
 config ZONE_DMA
 	bool
diff --git a/arch/frv/include/asm/perf_counter.h b/arch/frv/include/asm/perf_counter.h
new file mode 100644
index 0000000..ccf726e
--- /dev/null
+++ b/arch/frv/include/asm/perf_counter.h
@@ -0,0 +1,17 @@
+/* FRV performance counter support
+ *
+ * Copyright (C) 2009 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_PERF_COUNTER_H
+#define _ASM_PERF_COUNTER_H
+
+#define PERF_COUNTER_INDEX_OFFSET	0
+
+#endif /* _ASM_PERF_COUNTER_H */
diff --git a/arch/frv/lib/Makefile b/arch/frv/lib/Makefile
index 4ff2fb1..0a37721 100644
--- a/arch/frv/lib/Makefile
+++ b/arch/frv/lib/Makefile
@@ -5,4 +5,4 @@
 lib-y := \
 	__ashldi3.o __lshrdi3.o __muldi3.o __ashrdi3.o __negdi2.o __ucmpdi2.o \
 	checksum.o memcpy.o memset.o atomic-ops.o atomic64-ops.o \
-	outsl_ns.o outsl_sw.o insl_ns.o insl_sw.o cache.o
+	outsl_ns.o outsl_sw.o insl_ns.o insl_sw.o cache.o perf_counter.o
diff --git a/arch/frv/lib/perf_counter.c b/arch/frv/lib/perf_counter.c
new file mode 100644
index 0000000..2000fee
--- /dev/null
+++ b/arch/frv/lib/perf_counter.c
@@ -0,0 +1,19 @@
+/* Performance counter handling
+ *
+ * Copyright (C) 2009 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/perf_counter.h>
+
+/*
+ * mark the performance counter as pending
+ */
+void set_perf_counter_pending(void)
+{
+}

