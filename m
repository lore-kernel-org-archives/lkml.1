Return-Path: <linux-kernel-owner+w=401wt.eu-S1759731AbZFTSui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759731AbZFTSui (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 14:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758042AbZFTSrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 14:47:21 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48190 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758220AbZFTSrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 14:47:20 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Graf Yang <graf.yang@analog.com>
Subject: [PATCH 21/25] Blackfin: bf526-ezbrd: handle different SDRAM chips
Date: Sat, 20 Jun 2009 14:44:44 -0400
Message-Id: <1245523488-26536-22-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
References: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

The BF526-EZBRD changed SDRAM chips between board revisions, so create a
timing table that can accommodate both.

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/Kconfig                |    7 ++-
 arch/blackfin/include/asm/mem_init.h |   86 ++++++++++++++++++++++++++++++++++
 2 files changed, 92 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 220635a..384f7cd 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -358,7 +358,7 @@ config MEM_MT48LC8M32B2B5_7
 
 config MEM_MT48LC32M16A2TG_75
 	bool
-	depends on (BFIN527_EZKIT || BFIN532_IP0X || BLACKSTAMP || BFIN526_EZBRD)
+	depends on (BFIN527_EZKIT || BFIN532_IP0X || BLACKSTAMP)
 	default y
 
 config MEM_MT48LC32M8A2_75
@@ -366,6 +366,11 @@ config MEM_MT48LC32M8A2_75
 	depends on (BFIN518F_EZBRD)
 	default y
 
+config MEM_MT48H32M16LFCJ_75
+	bool
+	depends on (BFIN526_EZBRD)
+	default y
+
 source "arch/blackfin/mach-bf518/Kconfig"
 source "arch/blackfin/mach-bf527/Kconfig"
 source "arch/blackfin/mach-bf533/Kconfig"
diff --git a/arch/blackfin/include/asm/mem_init.h b/arch/blackfin/include/asm/mem_init.h
index fc164b3..4179e32 100644
--- a/arch/blackfin/include/asm/mem_init.h
+++ b/arch/blackfin/include/asm/mem_init.h
@@ -89,6 +89,85 @@
 #endif
 #endif
 
+/*
+ * The BF526-EZ-Board changed SDRAM chips between revisions,
+ * so we use below timings to accommodate both.
+ */
+#if defined(CONFIG_MEM_MT48H32M16LFCJ_75)
+#if (CONFIG_SCLK_HZ > 119402985)
+#define SDRAM_tRP       TRP_2
+#define SDRAM_tRP_num   2
+#define SDRAM_tRAS      TRAS_8
+#define SDRAM_tRAS_num  8
+#define SDRAM_tRCD      TRCD_2
+#define SDRAM_tWR       TWR_2
+#endif
+#if (CONFIG_SCLK_HZ > 104477612) && (CONFIG_SCLK_HZ <= 119402985)
+#define SDRAM_tRP       TRP_2
+#define SDRAM_tRP_num   2
+#define SDRAM_tRAS      TRAS_7
+#define SDRAM_tRAS_num  7
+#define SDRAM_tRCD      TRCD_2
+#define SDRAM_tWR       TWR_2
+#endif
+#if (CONFIG_SCLK_HZ > 89552239) && (CONFIG_SCLK_HZ <= 104477612)
+#define SDRAM_tRP       TRP_2
+#define SDRAM_tRP_num   2
+#define SDRAM_tRAS      TRAS_6
+#define SDRAM_tRAS_num  6
+#define SDRAM_tRCD      TRCD_2
+#define SDRAM_tWR       TWR_2
+#endif
+#if (CONFIG_SCLK_HZ > 74626866) && (CONFIG_SCLK_HZ <= 89552239)
+#define SDRAM_tRP       TRP_2
+#define SDRAM_tRP_num   2
+#define SDRAM_tRAS      TRAS_5
+#define SDRAM_tRAS_num  5
+#define SDRAM_tRCD      TRCD_2
+#define SDRAM_tWR       TWR_2
+#endif
+#if (CONFIG_SCLK_HZ > 66666667) && (CONFIG_SCLK_HZ <= 74626866)
+#define SDRAM_tRP       TRP_2
+#define SDRAM_tRP_num   2
+#define SDRAM_tRAS      TRAS_4
+#define SDRAM_tRAS_num  4
+#define SDRAM_tRCD      TRCD_2
+#define SDRAM_tWR       TWR_2
+#endif
+#if (CONFIG_SCLK_HZ > 59701493) && (CONFIG_SCLK_HZ <= 66666667)
+#define SDRAM_tRP       TRP_2
+#define SDRAM_tRP_num   2
+#define SDRAM_tRAS      TRAS_4
+#define SDRAM_tRAS_num  4
+#define SDRAM_tRCD      TRCD_1
+#define SDRAM_tWR       TWR_2
+#endif
+#if (CONFIG_SCLK_HZ > 44776119) && (CONFIG_SCLK_HZ <= 59701493)
+#define SDRAM_tRP       TRP_2
+#define SDRAM_tRP_num   2
+#define SDRAM_tRAS      TRAS_3
+#define SDRAM_tRAS_num  3
+#define SDRAM_tRCD      TRCD_1
+#define SDRAM_tWR       TWR_2
+#endif
+#if (CONFIG_SCLK_HZ > 29850746) && (CONFIG_SCLK_HZ <= 44776119)
+#define SDRAM_tRP       TRP_1
+#define SDRAM_tRP_num   1
+#define SDRAM_tRAS      TRAS_3
+#define SDRAM_tRAS_num  3
+#define SDRAM_tRCD      TRCD_1
+#define SDRAM_tWR       TWR_2
+#endif
+#if (CONFIG_SCLK_HZ <= 29850746)
+#define SDRAM_tRP       TRP_1
+#define SDRAM_tRP_num   1
+#define SDRAM_tRAS      TRAS_2
+#define SDRAM_tRAS_num  2
+#define SDRAM_tRCD      TRCD_1
+#define SDRAM_tWR       TWR_2
+#endif
+#endif
+
 #if defined(CONFIG_MEM_MT48LC16M8A2TG_75) || \
     defined(CONFIG_MEM_MT48LC8M32B2B5_7)
   /*SDRAM INFORMATION: */
@@ -109,6 +188,13 @@
 #define SDRAM_CL    CL_3
 #endif
 
+#if defined(CONFIG_MEM_MT48H32M16LFCJ_75)
+  /*SDRAM INFORMATION: */
+#define SDRAM_Tref  64		/* Refresh period in milliseconds   */
+#define SDRAM_NRA   8192	/* Number of row addresses in SDRAM */
+#define SDRAM_CL    CL_2
+#endif
+
 
 #ifdef CONFIG_BFIN_KERNEL_CLOCK_MEMINIT_CALC
 /* Equation from section 17 (p17-46) of BF533 HRM */
-- 
1.6.3.1

