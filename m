Return-Path: <linux-kernel-owner+w=401wt.eu-S1754680AbZILUsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbZILUsy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 16:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754500AbZILUsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 16:48:52 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:57277 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496AbZILUsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 16:48:52 -0400
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: linux-arm-kernel@lists.infradead.org,
       Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org,
       Bityutskiy Artem <Artem.Bityutskiy@nokia.com>,
       Siarhei Siamashka <siarhei.siamashka@nokia.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH v3 1/2] ARM: Introduce ARM_L1_CACHE_SHIFT to define cache line size
Date: Sat, 12 Sep 2009 23:48:30 +0300
Message-Id: <188e5f14411c04ec999ef25bfe3616f77f1387b0.1252788311.git.kirill@shutemov.name>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently kernel believes that all ARM CPUs have L1_CACHE_SHIFT == 5.
It's not true at least for CPUs based on Cortex-A8.

List of CPUs with cache line size != 32 should be expanded later.

V2:
  - remove unnecessary parens

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 arch/arm/include/asm/cache.h |    2 +-
 arch/arm/mm/Kconfig          |    5 +++++
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/arm/include/asm/cache.h b/arch/arm/include/asm/cache.h
index feaa75f..66c160b 100644
--- a/arch/arm/include/asm/cache.h
+++ b/arch/arm/include/asm/cache.h
@@ -4,7 +4,7 @@
 #ifndef __ASMARM_CACHE_H
 #define __ASMARM_CACHE_H
 
-#define L1_CACHE_SHIFT		5
+#define L1_CACHE_SHIFT		CONFIG_ARM_L1_CACHE_SHIFT
 #define L1_CACHE_BYTES		(1 << L1_CACHE_SHIFT)
 
 /*
diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index 83c025e..3c37d4c 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -771,3 +771,8 @@ config CACHE_XSC3L2
 	select OUTER_CACHE
 	help
 	  This option enables the L2 cache on XScale3.
+
+config ARM_L1_CACHE_SHIFT
+	int
+	default 6 if ARCH_OMAP3
+	default 5
-- 
1.6.4.2

