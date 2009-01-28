Return-Path: <linux-kernel-owner+w=401wt.eu-S1756886AbZA1Udc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbZA1Udc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:33:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755328AbZA1U3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:29:19 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:32860 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279AbZA1U3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:29:15 -0500
MBOX-Line: From nobody Wed Jan 28 12:27:31 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH E 01/14] OMAP2 SDRC: move mach-omap2/memory.h into
	include/asm-arm/arch-omap/sdrc.h
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
       Tony Lindgren <tony@atomide.com>
Date: Wed, 28 Jan 2009 12:27:31 -0700
Message-ID: <20090128192725.29333.88359.stgit@localhost.localdomain>
In-Reply-To: <20090128192551.29333.82943.stgit@localhost.localdomain>
References: <20090128192551.29333.82943.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the contents of the arch/arm/mach-omap2/memory.h file to the
existing include/asm-arm/arch-omap/sdrc.h file, and remove memory.h.
Modify files which include memory.h to include asm/arch/sdrc.h instead.

linux-omap source commit is e7ae2d89921372fc4b9712a32cc401d645597807.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clock.c            |    2 +
 arch/arm/mach-omap2/clock24xx.c        |    2 +
 arch/arm/mach-omap2/clock34xx.c        |    2 +
 arch/arm/mach-omap2/io.c               |    4 +--
 arch/arm/mach-omap2/memory.c           |    9 ++++++-
 arch/arm/mach-omap2/memory.h           |   43 --------------------------------
 arch/arm/plat-omap/include/mach/gpmc.h |    2 +
 arch/arm/plat-omap/include/mach/sdrc.h |   21 ++++++++++++++++
 8 files changed, 35 insertions(+), 50 deletions(-)
 delete mode 100644 arch/arm/mach-omap2/memory.h

diff --git a/arch/arm/mach-omap2/clock.c b/arch/arm/mach-omap2/clock.c
index 0cd4761..9c62ada 100644
--- a/arch/arm/mach-omap2/clock.c
+++ b/arch/arm/mach-omap2/clock.c
@@ -31,7 +31,7 @@
 #include <mach/control.h>
 #include <asm/div64.h>
 
-#include "memory.h"
+#include <mach/sdrc.h>
 #include "sdrc.h"
 #include "clock.h"
 #include "prm.h"
diff --git a/arch/arm/mach-omap2/clock24xx.c b/arch/arm/mach-omap2/clock24xx.c
index e66287f..a11ba09 100644
--- a/arch/arm/mach-omap2/clock24xx.c
+++ b/arch/arm/mach-omap2/clock24xx.c
@@ -34,7 +34,7 @@
 
 #include <asm/div64.h>
 
-#include "memory.h"
+#include <asm/arch/sdrc.h>
 #include "clock.h"
 #include "clock24xx.h"
 #include "prm.h"
diff --git a/arch/arm/mach-omap2/clock34xx.c b/arch/arm/mach-omap2/clock34xx.c
index c3c8537..3dba9ca 100644
--- a/arch/arm/mach-omap2/clock34xx.c
+++ b/arch/arm/mach-omap2/clock34xx.c
@@ -31,7 +31,7 @@
 #include <mach/sram.h>
 #include <asm/div64.h>
 
-#include "memory.h"
+#include <mach/sdrc.h>
 #include "clock.h"
 #include "clock34xx.h"
 #include "prm.h"
diff --git a/arch/arm/mach-omap2/io.c b/arch/arm/mach-omap2/io.c
index 5ea64f9..2b5f28a 100644
--- a/arch/arm/mach-omap2/io.c
+++ b/arch/arm/mach-omap2/io.c
@@ -27,8 +27,8 @@
 #include <mach/mux.h>
 #include <mach/omapfb.h>
 #include <mach/sram.h>
-
-#include "memory.h"
+#include <mach/sdrc.h>
+#include <mach/gpmc.h>
 
 #include "clock.h"
 
diff --git a/arch/arm/mach-omap2/memory.c b/arch/arm/mach-omap2/memory.c
index db024fd..62a87cf 100644
--- a/arch/arm/mach-omap2/memory.c
+++ b/arch/arm/mach-omap2/memory.c
@@ -31,9 +31,16 @@
 
 #include "clock.h"
 
-#include "memory.h"
+#include <mach/sdrc.h>
 #include "sdrc.h"
 
+/* Memory timing, DLL mode flags */
+#define M_DDR		1
+#define M_LOCK_CTRL	(1 << 2)
+#define M_UNLOCK	0
+#define M_LOCK		1
+
+
 void __iomem *omap2_sdrc_base;
 void __iomem *omap2_sms_base;
 
diff --git a/arch/arm/mach-omap2/memory.h b/arch/arm/mach-omap2/memory.h
deleted file mode 100644
index bb3db80..0000000
--- a/arch/arm/mach-omap2/memory.h
+++ /dev/null
@@ -1,43 +0,0 @@
-/*
- * linux/arch/arm/mach-omap2/memory.h
- *
- * Interface for memory timing related functions for OMAP24XX
- *
- * Copyright (C) 2005 Texas Instruments Inc.
- * Richard Woodruff <r-woodruff2@ti.com>
- *
- * Copyright (C) 2005 Nokia Corporation
- * Tony Lindgren <tony@atomide.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef ARCH_ARM_MACH_OMAP2_MEMORY_H
-#define ARCH_ARM_MACH_OMAP2_MEMORY_H
-
-/* Memory timings */
-#define M_DDR		1
-#define M_LOCK_CTRL	(1 << 2)
-#define M_UNLOCK	0
-#define M_LOCK		1
-
-struct memory_timings {
-	u32 m_type;		/* ddr = 1, sdr = 0 */
-	u32 dll_mode;		/* use lock mode = 1, unlock mode = 0 */
-	u32 slow_dll_ctrl;	/* unlock mode, dll value for slow speed */
-	u32 fast_dll_ctrl;	/* unlock mode, dll value for fast speed */
-	u32 base_cs;		/* base chip select to use for calculations */
-};
-
-extern void omap2_init_memory_params(u32 force_lock_to_unlock_mode);
-extern u32 omap2_memory_get_slow_dll_ctrl(void);
-extern u32 omap2_memory_get_fast_dll_ctrl(void);
-extern u32 omap2_memory_get_type(void);
-u32 omap2_dll_force_needed(void);
-u32 omap2_reprogram_sdrc(u32 level, u32 force);
-void __init omap2_init_memory(void);
-void __init gpmc_init(void);
-
-#endif
diff --git a/arch/arm/plat-omap/include/mach/gpmc.h b/arch/arm/plat-omap/include/mach/gpmc.h
index 45b6784..921b165 100644
--- a/arch/arm/plat-omap/include/mach/gpmc.h
+++ b/arch/arm/plat-omap/include/mach/gpmc.h
@@ -103,6 +103,6 @@ extern int gpmc_cs_request(int cs, unsigned long size, unsigned long *base);
 extern void gpmc_cs_free(int cs);
 extern int gpmc_cs_set_reserved(int cs, int reserved);
 extern int gpmc_cs_reserved(int cs);
-extern void gpmc_init(void);
+extern void __init gpmc_init(void);
 
 #endif
diff --git a/arch/arm/plat-omap/include/mach/sdrc.h b/arch/arm/plat-omap/include/mach/sdrc.h
index a98c6c3..c905b52 100644
--- a/arch/arm/plat-omap/include/mach/sdrc.h
+++ b/arch/arm/plat-omap/include/mach/sdrc.h
@@ -74,4 +74,25 @@
 #define SMS_SYSCONFIG		0x010
 /* REVISIT: fill in other SMS registers here */
 
+#ifndef __ASSEMBLER__
+
+struct memory_timings {
+	u32 m_type;		/* ddr = 1, sdr = 0 */
+	u32 dll_mode;		/* use lock mode = 1, unlock mode = 0 */
+	u32 slow_dll_ctrl;	/* unlock mode, dll value for slow speed */
+	u32 fast_dll_ctrl;	/* unlock mode, dll value for fast speed */
+	u32 base_cs;		/* base chip select to use for calculations */
+};
+
+extern void omap2_init_memory_params(u32 force_lock_to_unlock_mode);
+extern u32 omap2_memory_get_slow_dll_ctrl(void);
+extern u32 omap2_memory_get_fast_dll_ctrl(void);
+extern u32 omap2_memory_get_type(void);
+u32 omap2_dll_force_needed(void);
+u32 omap2_reprogram_sdrc(u32 level, u32 force);
+void __init omap2_init_memory(void);
+
+#endif
+
+
 #endif


