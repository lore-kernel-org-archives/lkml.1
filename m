Return-Path: <linux-kernel-owner+w=401wt.eu-S933129AbZFLQb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933129AbZFLQb7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764748AbZFLQZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:25:21 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39104 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762548AbZFLQZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:25:09 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 21/27] Blackfin: move custom sections into sections.h
Date: Fri, 12 Jun 2009 12:24:39 -0400
Message-Id: <1244823885-22410-22-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
References: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Blackfin arch has a bunch of custom section markings for its on-chip
regions, but they aren't declared in the right header.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/bfin-global.h |   11 +----------
 arch/blackfin/include/asm/sections.h    |   11 +++++++++++
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/blackfin/include/asm/bfin-global.h b/arch/blackfin/include/asm/bfin-global.h
index daffc06..e39277e 100644
--- a/arch/blackfin/include/asm/bfin-global.h
+++ b/arch/blackfin/include/asm/bfin-global.h
@@ -31,7 +31,7 @@
 
 #ifndef __ASSEMBLY__
 
-#include <asm-generic/sections.h>
+#include <asm/sections.h>
 #include <asm/ptrace.h>
 #include <asm/user.h>
 #include <linux/linkage.h>
@@ -99,15 +99,6 @@ extern const char bfin_board_name[];
 extern unsigned long bfin_sic_iwr[];
 extern unsigned vr_wakeup;
 extern u16 _bfin_swrst; /* shadow for Software Reset Register (SWRST) */
-extern unsigned long _ramstart, _ramend, _rambase;
-extern unsigned long memory_start, memory_end, physical_mem_end;
-extern char _stext_l1[], _etext_l1[], _sdata_l1[], _edata_l1[], _sbss_l1[],
-	_ebss_l1[], _l1_lma_start[], _sdata_b_l1[], _sbss_b_l1[], _ebss_b_l1[],
-	_stext_l2[], _etext_l2[], _sdata_l2[], _edata_l2[], _sbss_l2[],
-	_ebss_l2[], _l2_lma_start[];
-
-/* only used when MTD_UCLINUX */
-extern unsigned long memory_mtd_start, memory_mtd_end, mtd_size;
 
 #ifdef CONFIG_BFIN_ICACHE_LOCK
 extern void cache_grab_lock(int way);
diff --git a/arch/blackfin/include/asm/sections.h b/arch/blackfin/include/asm/sections.h
index 1443c33..e7fd0ec 100644
--- a/arch/blackfin/include/asm/sections.h
+++ b/arch/blackfin/include/asm/sections.h
@@ -4,4 +4,15 @@
 /* nothing to see, move along */
 #include <asm-generic/sections.h>
 
+/* only used when MTD_UCLINUX */
+extern unsigned long memory_mtd_start, memory_mtd_end, mtd_size;
+
+extern unsigned long _ramstart, _ramend, _rambase;
+extern unsigned long memory_start, memory_end, physical_mem_end;
+
+extern char _stext_l1[], _etext_l1[], _sdata_l1[], _edata_l1[], _sbss_l1[],
+	_ebss_l1[], _l1_lma_start[], _sdata_b_l1[], _sbss_b_l1[], _ebss_b_l1[],
+	_stext_l2[], _etext_l2[], _sdata_l2[], _edata_l2[], _sbss_l2[],
+	_ebss_l2[], _l2_lma_start[];
+
 #endif
-- 
1.6.3.1

