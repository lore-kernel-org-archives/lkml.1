Return-Path: <linux-kernel-owner+w=401wt.eu-S1756637AbZFEINE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbZFEINE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:13:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755784AbZFEIGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:06:13 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37478 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753340AbZFEIFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:05:32 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Graf Yang <graf.yang@analog.com>
Subject: [PATCH 20/62] Blackfin: add MDMA defines to make cross-variant coding easier
Date: Fri,  5 Jun 2009 04:04:29 -0400
Message-Id: <1244189111-19639-21-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

Add some defines to make the BF538/BF561 look like most other Blackfin
parts in that it has a MDMA0 channel available for low level init.

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf538/include/mach/blackfin.h  |   19 -------
 arch/blackfin/mach-bf538/include/mach/cdefBF538.h |   59 +++++++++++++++++++++
 arch/blackfin/mach-bf538/include/mach/defBF539.h  |   56 +++++++++++++++++++
 arch/blackfin/mach-bf561/include/mach/cdefBF561.h |   29 ++++++++++
 arch/blackfin/mach-bf561/include/mach/defBF561.h  |   56 +++++++++++++++++++
 5 files changed, 200 insertions(+), 19 deletions(-)

diff --git a/arch/blackfin/mach-bf538/include/mach/blackfin.h b/arch/blackfin/mach-bf538/include/mach/blackfin.h
index ea25371..6f62835 100644
--- a/arch/blackfin/mach-bf538/include/mach/blackfin.h
+++ b/arch/blackfin/mach-bf538/include/mach/blackfin.h
@@ -68,25 +68,6 @@
 #define OFFSET_SCR              0x1C	/* SCR Scratch Register                 */
 #define OFFSET_GCTL             0x24	/* Global Control Register              */
 
-
-#define bfin_write_MDMA_D0_IRQ_STATUS	bfin_write_MDMA0_D0_IRQ_STATUS
-#define bfin_write_MDMA_D0_START_ADDR   bfin_write_MDMA0_D0_START_ADDR
-#define bfin_write_MDMA_S0_START_ADDR   bfin_write_MDMA0_S0_START_ADDR
-#define bfin_write_MDMA_D0_X_COUNT      bfin_write_MDMA0_D0_X_COUNT
-#define bfin_write_MDMA_S0_X_COUNT      bfin_write_MDMA0_S0_X_COUNT
-#define bfin_write_MDMA_D0_Y_COUNT      bfin_write_MDMA0_D0_Y_COUNT
-#define bfin_write_MDMA_S0_Y_COUNT      bfin_write_MDMA0_S0_Y_COUNT
-#define bfin_write_MDMA_D0_X_MODIFY     bfin_write_MDMA0_D0_X_MODIFY
-#define bfin_write_MDMA_S0_X_MODIFY     bfin_write_MDMA0_S0_X_MODIFY
-#define bfin_write_MDMA_D0_Y_MODIFY     bfin_write_MDMA0_D0_Y_MODIFY
-#define bfin_write_MDMA_S0_Y_MODIFY     bfin_write_MDMA0_S0_Y_MODIFY
-#define bfin_write_MDMA_S0_CONFIG       bfin_write_MDMA0_S0_CONFIG
-#define bfin_write_MDMA_D0_CONFIG       bfin_write_MDMA0_D0_CONFIG
-#define bfin_read_MDMA_S0_CONFIG        bfin_read_MDMA0_S0_CONFIG
-#define bfin_read_MDMA_D0_IRQ_STATUS    bfin_read_MDMA0_D0_IRQ_STATUS
-#define bfin_write_MDMA_S0_IRQ_STATUS   bfin_write_MDMA0_S0_IRQ_STATUS
-
-
 /* DPMC*/
 #define bfin_read_STOPCK_OFF() bfin_read_STOPCK()
 #define bfin_write_STOPCK_OFF(val) bfin_write_STOPCK(val)
diff --git a/arch/blackfin/mach-bf538/include/mach/cdefBF538.h b/arch/blackfin/mach-bf538/include/mach/cdefBF538.h
index 7a5f74c..99ca3f4 100644
--- a/arch/blackfin/mach-bf538/include/mach/cdefBF538.h
+++ b/arch/blackfin/mach-bf538/include/mach/cdefBF538.h
@@ -1247,6 +1247,65 @@
 #define bfin_write_MDMA1_S1_CURR_X_COUNT(val) bfin_write16(MDMA1_S1_CURR_X_COUNT, val)
 #define bfin_read_MDMA1_S1_CURR_Y_COUNT() bfin_read16(MDMA1_S1_CURR_Y_COUNT)
 #define bfin_write_MDMA1_S1_CURR_Y_COUNT(val) bfin_write16(MDMA1_S1_CURR_Y_COUNT, val)
+
+#define bfin_read_MDMA_S0_CONFIG()  bfin_read_MDMA0_S0_CONFIG()
+#define bfin_write_MDMA_S0_CONFIG(val) bfin_write_MDMA0_S0_CONFIG(val)
+#define bfin_read_MDMA_S0_IRQ_STATUS()  bfin_read_MDMA0_S0_IRQ_STATUS()
+#define bfin_write_MDMA_S0_IRQ_STATUS(val) bfin_write_MDMA0_S0_IRQ_STATUS(val)
+#define bfin_read_MDMA_S0_X_MODIFY()  bfin_read_MDMA0_S0_X_MODIFY()
+#define bfin_write_MDMA_S0_X_MODIFY(val) bfin_write_MDMA0_S0_X_MODIFY(val)
+#define bfin_read_MDMA_S0_Y_MODIFY()  bfin_read_MDMA0_S0_Y_MODIFY()
+#define bfin_write_MDMA_S0_Y_MODIFY(val) bfin_write_MDMA0_S0_Y_MODIFY(val)
+#define bfin_read_MDMA_S0_X_COUNT()  bfin_read_MDMA0_S0_X_COUNT()
+#define bfin_write_MDMA_S0_X_COUNT(val) bfin_write_MDMA0_S0_X_COUNT(val)
+#define bfin_read_MDMA_S0_Y_COUNT()  bfin_read_MDMA0_S0_Y_COUNT()
+#define bfin_write_MDMA_S0_Y_COUNT(val) bfin_write_MDMA0_S0_Y_COUNT(val)
+#define bfin_read_MDMA_S0_START_ADDR()  bfin_read_MDMA0_S0_START_ADDR()
+#define bfin_write_MDMA_S0_START_ADDR(val) bfin_write_MDMA0_S0_START_ADDR(val)
+#define bfin_read_MDMA_D0_CONFIG()  bfin_read_MDMA0_D0_CONFIG()
+#define bfin_write_MDMA_D0_CONFIG(val) bfin_write_MDMA0_D0_CONFIG(val)
+#define bfin_read_MDMA_D0_IRQ_STATUS()  bfin_read_MDMA0_D0_IRQ_STATUS()
+#define bfin_write_MDMA_D0_IRQ_STATUS(val) bfin_write_MDMA0_D0_IRQ_STATUS(val)
+#define bfin_read_MDMA_D0_X_MODIFY()  bfin_read_MDMA0_D0_X_MODIFY()
+#define bfin_write_MDMA_D0_X_MODIFY(val) bfin_write_MDMA0_D0_X_MODIFY(val)
+#define bfin_read_MDMA_D0_Y_MODIFY()  bfin_read_MDMA0_D0_Y_MODIFY()
+#define bfin_write_MDMA_D0_Y_MODIFY(val) bfin_write_MDMA0_D0_Y_MODIFY(val)
+#define bfin_read_MDMA_D0_X_COUNT()  bfin_read_MDMA0_D0_X_COUNT()
+#define bfin_write_MDMA_D0_X_COUNT(val) bfin_write_MDMA0_D0_X_COUNT(val)
+#define bfin_read_MDMA_D0_Y_COUNT()  bfin_read_MDMA0_D0_Y_COUNT()
+#define bfin_write_MDMA_D0_Y_COUNT(val) bfin_write_MDMA0_D0_Y_COUNT(val)
+#define bfin_read_MDMA_D0_START_ADDR()  bfin_read_MDMA0_D0_START_ADDR()
+#define bfin_write_MDMA_D0_START_ADDR(val) bfin_write_MDMA0_D0_START_ADDR(val)
+
+#define bfin_read_MDMA_S1_CONFIG()  bfin_read_MDMA0_S1_CONFIG()
+#define bfin_write_MDMA_S1_CONFIG(val) bfin_write_MDMA0_S1_CONFIG(val)
+#define bfin_read_MDMA_S1_IRQ_STATUS()  bfin_read_MDMA0_S1_IRQ_STATUS()
+#define bfin_write_MDMA_S1_IRQ_STATUS(val) bfin_write_MDMA0_S1_IRQ_STATUS(val)
+#define bfin_read_MDMA_S1_X_MODIFY()  bfin_read_MDMA0_S1_X_MODIFY()
+#define bfin_write_MDMA_S1_X_MODIFY(val) bfin_write_MDMA0_S1_X_MODIFY(val)
+#define bfin_read_MDMA_S1_Y_MODIFY()  bfin_read_MDMA0_S1_Y_MODIFY()
+#define bfin_write_MDMA_S1_Y_MODIFY(val) bfin_write_MDMA0_S1_Y_MODIFY(val)
+#define bfin_read_MDMA_S1_X_COUNT()  bfin_read_MDMA0_S1_X_COUNT()
+#define bfin_write_MDMA_S1_X_COUNT(val) bfin_write_MDMA0_S1_X_COUNT(val)
+#define bfin_read_MDMA_S1_Y_COUNT()  bfin_read_MDMA0_S1_Y_COUNT()
+#define bfin_write_MDMA_S1_Y_COUNT(val) bfin_write_MDMA0_S1_Y_COUNT(val)
+#define bfin_read_MDMA_S1_START_ADDR()  bfin_read_MDMA0_S1_START_ADDR()
+#define bfin_write_MDMA_S1_START_ADDR(val) bfin_write_MDMA0_S1_START_ADDR(val)
+#define bfin_read_MDMA_D1_CONFIG()  bfin_read_MDMA0_D1_CONFIG()
+#define bfin_write_MDMA_D1_CONFIG(val) bfin_write_MDMA0_D1_CONFIG(val)
+#define bfin_read_MDMA_D1_IRQ_STATUS()  bfin_read_MDMA0_D1_IRQ_STATUS()
+#define bfin_write_MDMA_D1_IRQ_STATUS(val) bfin_write_MDMA0_D1_IRQ_STATUS(val)
+#define bfin_read_MDMA_D1_X_MODIFY()  bfin_read_MDMA0_D1_X_MODIFY()
+#define bfin_write_MDMA_D1_X_MODIFY(val) bfin_write_MDMA0_D1_X_MODIFY(val)
+#define bfin_read_MDMA_D1_Y_MODIFY()  bfin_read_MDMA0_D1_Y_MODIFY()
+#define bfin_write_MDMA_D1_Y_MODIFY(val) bfin_write_MDMA0_D1_Y_MODIFY(val)
+#define bfin_read_MDMA_D1_X_COUNT()  bfin_read_MDMA0_D1_X_COUNT()
+#define bfin_write_MDMA_D1_X_COUNT(val) bfin_write_MDMA0_D1_X_COUNT(val)
+#define bfin_read_MDMA_D1_Y_COUNT()  bfin_read_MDMA0_D1_Y_COUNT()
+#define bfin_write_MDMA_D1_Y_COUNT(val) bfin_write_MDMA0_D1_Y_COUNT(val)
+#define bfin_read_MDMA_D1_START_ADDR()  bfin_read_MDMA0_D1_START_ADDR()
+#define bfin_write_MDMA_D1_START_ADDR(val) bfin_write_MDMA0_D1_START_ADDR(val)
+
 #define bfin_read_PPI_CONTROL()        bfin_read16(PPI_CONTROL)
 #define bfin_write_PPI_CONTROL(val)    bfin_write16(PPI_CONTROL, val)
 #define bfin_read_PPI_STATUS()         bfin_read16(PPI_STATUS)
diff --git a/arch/blackfin/mach-bf538/include/mach/defBF539.h b/arch/blackfin/mach-bf538/include/mach/defBF539.h
index 6adbfcc..bdc330c 100644
--- a/arch/blackfin/mach-bf538/include/mach/defBF539.h
+++ b/arch/blackfin/mach-bf538/include/mach/defBF539.h
@@ -412,6 +412,62 @@
 #define	MDMA0_S1_CURR_X_COUNT	0xFFC00EF0	/* MemDMA0 Stream 1 Source Current X Count Register */
 #define	MDMA0_S1_CURR_Y_COUNT	0xFFC00EF8	/* MemDMA0 Stream 1 Source Current Y Count Register */
 
+#define MDMA_D0_NEXT_DESC_PTR MDMA0_D0_NEXT_DESC_PTR
+#define MDMA_D0_START_ADDR MDMA0_D0_START_ADDR
+#define MDMA_D0_CONFIG MDMA0_D0_CONFIG
+#define MDMA_D0_X_COUNT MDMA0_D0_X_COUNT
+#define MDMA_D0_X_MODIFY MDMA0_D0_X_MODIFY
+#define MDMA_D0_Y_COUNT MDMA0_D0_Y_COUNT
+#define MDMA_D0_Y_MODIFY MDMA0_D0_Y_MODIFY
+#define MDMA_D0_CURR_DESC_PTR MDMA0_D0_CURR_DESC_PTR
+#define MDMA_D0_CURR_ADDR MDMA0_D0_CURR_ADDR
+#define MDMA_D0_IRQ_STATUS MDMA0_D0_IRQ_STATUS
+#define MDMA_D0_PERIPHERAL_MAP MDMA0_D0_PERIPHERAL_MAP
+#define MDMA_D0_CURR_X_COUNT MDMA0_D0_CURR_X_COUNT
+#define MDMA_D0_CURR_Y_COUNT MDMA0_D0_CURR_Y_COUNT
+
+#define MDMA_S0_NEXT_DESC_PTR MDMA0_S0_NEXT_DESC_PTR
+#define MDMA_S0_START_ADDR MDMA0_S0_START_ADDR
+#define MDMA_S0_CONFIG MDMA0_S0_CONFIG
+#define MDMA_S0_X_COUNT MDMA0_S0_X_COUNT
+#define MDMA_S0_X_MODIFY MDMA0_S0_X_MODIFY
+#define MDMA_S0_Y_COUNT MDMA0_S0_Y_COUNT
+#define MDMA_S0_Y_MODIFY MDMA0_S0_Y_MODIFY
+#define MDMA_S0_CURR_DESC_PTR MDMA0_S0_CURR_DESC_PTR
+#define MDMA_S0_CURR_ADDR MDMA0_S0_CURR_ADDR
+#define MDMA_S0_IRQ_STATUS MDMA0_S0_IRQ_STATUS
+#define MDMA_S0_PERIPHERAL_MAP MDMA0_S0_PERIPHERAL_MAP
+#define MDMA_S0_CURR_X_COUNT MDMA0_S0_CURR_X_COUNT
+#define MDMA_S0_CURR_Y_COUNT MDMA0_S0_CURR_Y_COUNT
+
+#define MDMA_D1_NEXT_DESC_PTR MDMA0_D1_NEXT_DESC_PTR
+#define MDMA_D1_START_ADDR MDMA0_D1_START_ADDR
+#define MDMA_D1_CONFIG MDMA0_D1_CONFIG
+#define MDMA_D1_X_COUNT MDMA0_D1_X_COUNT
+#define MDMA_D1_X_MODIFY MDMA0_D1_X_MODIFY
+#define MDMA_D1_Y_COUNT MDMA0_D1_Y_COUNT
+#define MDMA_D1_Y_MODIFY MDMA0_D1_Y_MODIFY
+#define MDMA_D1_CURR_DESC_PTR MDMA0_D1_CURR_DESC_PTR
+#define MDMA_D1_CURR_ADDR MDMA0_D1_CURR_ADDR
+#define MDMA_D1_IRQ_STATUS MDMA0_D1_IRQ_STATUS
+#define MDMA_D1_PERIPHERAL_MAP MDMA0_D1_PERIPHERAL_MAP
+#define MDMA_D1_CURR_X_COUNT MDMA0_D1_CURR_X_COUNT
+#define MDMA_D1_CURR_Y_COUNT MDMA0_D1_CURR_Y_COUNT
+
+#define MDMA_S1_NEXT_DESC_PTR MDMA0_S1_NEXT_DESC_PTR
+#define MDMA_S1_START_ADDR MDMA0_S1_START_ADDR
+#define MDMA_S1_CONFIG MDMA0_S1_CONFIG
+#define MDMA_S1_X_COUNT MDMA0_S1_X_COUNT
+#define MDMA_S1_X_MODIFY MDMA0_S1_X_MODIFY
+#define MDMA_S1_Y_COUNT MDMA0_S1_Y_COUNT
+#define MDMA_S1_Y_MODIFY MDMA0_S1_Y_MODIFY
+#define MDMA_S1_CURR_DESC_PTR MDMA0_S1_CURR_DESC_PTR
+#define MDMA_S1_CURR_ADDR MDMA0_S1_CURR_ADDR
+#define MDMA_S1_IRQ_STATUS MDMA0_S1_IRQ_STATUS
+#define MDMA_S1_PERIPHERAL_MAP MDMA0_S1_PERIPHERAL_MAP
+#define MDMA_S1_CURR_X_COUNT MDMA0_S1_CURR_X_COUNT
+#define MDMA_S1_CURR_Y_COUNT MDMA0_S1_CURR_Y_COUNT
+
 
 /* Parallel Peripheral Interface (PPI) (0xFFC01000 - 0xFFC010FF) */
 #define	PPI_CONTROL			0xFFC01000	/* PPI Control Register */
diff --git a/arch/blackfin/mach-bf561/include/mach/cdefBF561.h b/arch/blackfin/mach-bf561/include/mach/cdefBF561.h
index 95d609f..9d9858c 100644
--- a/arch/blackfin/mach-bf561/include/mach/cdefBF561.h
+++ b/arch/blackfin/mach-bf561/include/mach/cdefBF561.h
@@ -1526,6 +1526,35 @@
 #define bfin_read_MDMA_D0_START_ADDR()  bfin_read_MDMA1_D0_START_ADDR()
 #define bfin_write_MDMA_D0_START_ADDR(val) bfin_write_MDMA1_D0_START_ADDR(val)
 
+#define bfin_read_MDMA_S1_CONFIG()  bfin_read_MDMA1_S1_CONFIG()
+#define bfin_write_MDMA_S1_CONFIG(val) bfin_write_MDMA1_S1_CONFIG(val)
+#define bfin_read_MDMA_S1_IRQ_STATUS()  bfin_read_MDMA1_S1_IRQ_STATUS()
+#define bfin_write_MDMA_S1_IRQ_STATUS(val) bfin_write_MDMA1_S1_IRQ_STATUS(val)
+#define bfin_read_MDMA_S1_X_MODIFY()  bfin_read_MDMA1_S1_X_MODIFY()
+#define bfin_write_MDMA_S1_X_MODIFY(val) bfin_write_MDMA1_S1_X_MODIFY(val)
+#define bfin_read_MDMA_S1_Y_MODIFY()  bfin_read_MDMA1_S1_Y_MODIFY()
+#define bfin_write_MDMA_S1_Y_MODIFY(val) bfin_write_MDMA1_S1_Y_MODIFY(val)
+#define bfin_read_MDMA_S1_X_COUNT()  bfin_read_MDMA1_S1_X_COUNT()
+#define bfin_write_MDMA_S1_X_COUNT(val) bfin_write_MDMA1_S1_X_COUNT(val)
+#define bfin_read_MDMA_S1_Y_COUNT()  bfin_read_MDMA1_S1_Y_COUNT()
+#define bfin_write_MDMA_S1_Y_COUNT(val) bfin_write_MDMA1_S1_Y_COUNT(val)
+#define bfin_read_MDMA_S1_START_ADDR()  bfin_read_MDMA1_S1_START_ADDR()
+#define bfin_write_MDMA_S1_START_ADDR(val) bfin_write_MDMA1_S1_START_ADDR(val)
+#define bfin_read_MDMA_D1_CONFIG()  bfin_read_MDMA1_D1_CONFIG()
+#define bfin_write_MDMA_D1_CONFIG(val) bfin_write_MDMA1_D1_CONFIG(val)
+#define bfin_read_MDMA_D1_IRQ_STATUS()  bfin_read_MDMA1_D1_IRQ_STATUS()
+#define bfin_write_MDMA_D1_IRQ_STATUS(val) bfin_write_MDMA1_D1_IRQ_STATUS(val)
+#define bfin_read_MDMA_D1_X_MODIFY()  bfin_read_MDMA1_D1_X_MODIFY()
+#define bfin_write_MDMA_D1_X_MODIFY(val) bfin_write_MDMA1_D1_X_MODIFY(val)
+#define bfin_read_MDMA_D1_Y_MODIFY()  bfin_read_MDMA1_D1_Y_MODIFY()
+#define bfin_write_MDMA_D1_Y_MODIFY(val) bfin_write_MDMA1_D1_Y_MODIFY(val)
+#define bfin_read_MDMA_D1_X_COUNT()  bfin_read_MDMA1_D1_X_COUNT()
+#define bfin_write_MDMA_D1_X_COUNT(val) bfin_write_MDMA1_D1_X_COUNT(val)
+#define bfin_read_MDMA_D1_Y_COUNT()  bfin_read_MDMA1_D1_Y_COUNT()
+#define bfin_write_MDMA_D1_Y_COUNT(val) bfin_write_MDMA1_D1_Y_COUNT(val)
+#define bfin_read_MDMA_D1_START_ADDR()  bfin_read_MDMA1_D1_START_ADDR()
+#define bfin_write_MDMA_D1_START_ADDR(val) bfin_write_MDMA1_D1_START_ADDR(val)
+
 /* These need to be last due to the cdef/linux inter-dependencies */
 #include <asm/irq.h>
 
diff --git a/arch/blackfin/mach-bf561/include/mach/defBF561.h b/arch/blackfin/mach-bf561/include/mach/defBF561.h
index cf92229..5fc0f05 100644
--- a/arch/blackfin/mach-bf561/include/mach/defBF561.h
+++ b/arch/blackfin/mach-bf561/include/mach/defBF561.h
@@ -796,6 +796,62 @@
 #define MDMA2_S1_IRQ_STATUS 0xFFC00FE8	/*MemDMA2 Stream 1 Source Interrupt/Status Register */
 #define MDMA2_S1_PERIPHERAL_MAP 0xFFC00FEC	/*MemDMA2 Stream 1 Source Peripheral Map register */
 
+#define MDMA_D0_NEXT_DESC_PTR MDMA1_D0_NEXT_DESC_PTR
+#define MDMA_D0_START_ADDR MDMA1_D0_START_ADDR
+#define MDMA_D0_CONFIG MDMA1_D0_CONFIG
+#define MDMA_D0_X_COUNT MDMA1_D0_X_COUNT
+#define MDMA_D0_X_MODIFY MDMA1_D0_X_MODIFY
+#define MDMA_D0_Y_COUNT MDMA1_D0_Y_COUNT
+#define MDMA_D0_Y_MODIFY MDMA1_D0_Y_MODIFY
+#define MDMA_D0_CURR_DESC_PTR MDMA1_D0_CURR_DESC_PTR
+#define MDMA_D0_CURR_ADDR MDMA1_D0_CURR_ADDR
+#define MDMA_D0_IRQ_STATUS MDMA1_D0_IRQ_STATUS
+#define MDMA_D0_PERIPHERAL_MAP MDMA1_D0_PERIPHERAL_MAP
+#define MDMA_D0_CURR_X_COUNT MDMA1_D0_CURR_X_COUNT
+#define MDMA_D0_CURR_Y_COUNT MDMA1_D0_CURR_Y_COUNT
+
+#define MDMA_S0_NEXT_DESC_PTR MDMA1_S0_NEXT_DESC_PTR
+#define MDMA_S0_START_ADDR MDMA1_S0_START_ADDR
+#define MDMA_S0_CONFIG MDMA1_S0_CONFIG
+#define MDMA_S0_X_COUNT MDMA1_S0_X_COUNT
+#define MDMA_S0_X_MODIFY MDMA1_S0_X_MODIFY
+#define MDMA_S0_Y_COUNT MDMA1_S0_Y_COUNT
+#define MDMA_S0_Y_MODIFY MDMA1_S0_Y_MODIFY
+#define MDMA_S0_CURR_DESC_PTR MDMA1_S0_CURR_DESC_PTR
+#define MDMA_S0_CURR_ADDR MDMA1_S0_CURR_ADDR
+#define MDMA_S0_IRQ_STATUS MDMA1_S0_IRQ_STATUS
+#define MDMA_S0_PERIPHERAL_MAP MDMA1_S0_PERIPHERAL_MAP
+#define MDMA_S0_CURR_X_COUNT MDMA1_S0_CURR_X_COUNT
+#define MDMA_S0_CURR_Y_COUNT MDMA1_S0_CURR_Y_COUNT
+
+#define MDMA_D1_NEXT_DESC_PTR MDMA1_D1_NEXT_DESC_PTR
+#define MDMA_D1_START_ADDR MDMA1_D1_START_ADDR
+#define MDMA_D1_CONFIG MDMA1_D1_CONFIG
+#define MDMA_D1_X_COUNT MDMA1_D1_X_COUNT
+#define MDMA_D1_X_MODIFY MDMA1_D1_X_MODIFY
+#define MDMA_D1_Y_COUNT MDMA1_D1_Y_COUNT
+#define MDMA_D1_Y_MODIFY MDMA1_D1_Y_MODIFY
+#define MDMA_D1_CURR_DESC_PTR MDMA1_D1_CURR_DESC_PTR
+#define MDMA_D1_CURR_ADDR MDMA1_D1_CURR_ADDR
+#define MDMA_D1_IRQ_STATUS MDMA1_D1_IRQ_STATUS
+#define MDMA_D1_PERIPHERAL_MAP MDMA1_D1_PERIPHERAL_MAP
+#define MDMA_D1_CURR_X_COUNT MDMA1_D1_CURR_X_COUNT
+#define MDMA_D1_CURR_Y_COUNT MDMA1_D1_CURR_Y_COUNT
+
+#define MDMA_S1_NEXT_DESC_PTR MDMA1_S1_NEXT_DESC_PTR
+#define MDMA_S1_START_ADDR MDMA1_S1_START_ADDR
+#define MDMA_S1_CONFIG MDMA1_S1_CONFIG
+#define MDMA_S1_X_COUNT MDMA1_S1_X_COUNT
+#define MDMA_S1_X_MODIFY MDMA1_S1_X_MODIFY
+#define MDMA_S1_Y_COUNT MDMA1_S1_Y_COUNT
+#define MDMA_S1_Y_MODIFY MDMA1_S1_Y_MODIFY
+#define MDMA_S1_CURR_DESC_PTR MDMA1_S1_CURR_DESC_PTR
+#define MDMA_S1_CURR_ADDR MDMA1_S1_CURR_ADDR
+#define MDMA_S1_IRQ_STATUS MDMA1_S1_IRQ_STATUS
+#define MDMA_S1_PERIPHERAL_MAP MDMA1_S1_PERIPHERAL_MAP
+#define MDMA_S1_CURR_X_COUNT MDMA1_S1_CURR_X_COUNT
+#define MDMA_S1_CURR_Y_COUNT MDMA1_S1_CURR_Y_COUNT
+
 /* Internal Memory DMA Registers (0xFFC0_1800 - 0xFFC0_19FF) */
 #define IMDMA_D0_CONFIG 0xFFC01808	/*IMDMA Stream 0 Destination Configuration */
 #define IMDMA_D0_NEXT_DESC_PTR 0xFFC01800	/*IMDMA Stream 0 Destination Next Descriptor Ptr Reg */
-- 
1.6.3.1

