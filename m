Return-Path: <linux-kernel-owner+w=401wt.eu-S1752097AbZIBNLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbZIBNLz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 09:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751695AbZIBNLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 09:11:55 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:45576 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbZIBNLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 09:11:54 -0400
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Koskinen Aaro <aaro.koskinen@nokia.com>,
       Bityutskiy Artem <Artem.Bityutskiy@nokia.com>,
       Moiseichuk Leonid <leonid.moiseichuk@nokia.com>,
       Siarhei Siamashka <siarhei.siamashka@nokia.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH 1/2] ARM: Introduce ARM_L1_CACHE_SHIFT to define cache line size
Date: Wed,  2 Sep 2009 19:11:52 +0300
Message-Id: <1251907913-16261-1-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.6.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently kernel believes that all ARM CPUs have L1_CACHE_SHIFT == 5.
It's not true at least for CPUs based on Cortex-A8.

List of CPUs with cache line size != 32 should be expanded later.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 arch/arm/include/asm/cache.h |    2 +-
 arch/arm/mm/Kconfig          |    5 +++++
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/arm/include/asm/cache.h b/arch/arm/include/asm/cache.h
index feaa75f..2ee7743 100644
--- a/arch/arm/include/asm/cache.h
+++ b/arch/arm/include/asm/cache.h
@@ -4,7 +4,7 @@
 #ifndef __ASMARM_CACHE_H
 #define __ASMARM_CACHE_H
 
-#define L1_CACHE_SHIFT		5
+#define L1_CACHE_SHIFT		(CONFIG_ARM_L1_CACHE_SHIFT)
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
1.6.3.4

