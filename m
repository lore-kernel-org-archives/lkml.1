Return-Path: <linux-kernel-owner+w=401wt.eu-S1752612AbZEEPC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbZEEPC2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 11:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbZEEPCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 11:02:16 -0400
Received: from mx1.emlix.com ([193.175.82.87]:59433 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbZEEPCP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 11:02:15 -0400
From: =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [PATCH] xtensa: generalize logic for variant/irq.h inclusion
Date: Tue,  5 May 2009 17:02:14 +0200
Message-Id: <1241535734-17479-1-git-send-email-dg@emlix.com>
In-Reply-To: <4A0054A0.3030104@emlix.com>
References: <4A0054A0.3030104@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_VARIANT_IRQ_SWITCH has been replaced by CONFIG_VARIANT_IRQ_EXT
and a #define VARIANT_HAS_IRQ_ENABLE in variant/irq.h.

This change was made to allow further extensions to the irq handling by
the variant in variant/irq.h independent of the CONFIG_VARIANT_IRQ_SWITCH
functionality and without forcing all variants to provide this header.

Signed-off-by: Daniel Glöckner <dg@emlix.com>
---
 arch/xtensa/Kconfig                              |    4 ++--
 arch/xtensa/configs/s6105_defconfig              |    2 +-
 arch/xtensa/include/asm/irq.h                    |    6 ++++--
 arch/xtensa/variants/s6000/include/variant/irq.h |    1 +
 4 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index ac02f3c..76dee02 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -57,7 +57,7 @@ source "kernel/Kconfig.freezer"
 config MMU
 	def_bool n
 
-config VARIANT_IRQ_SWITCH
+config VARIANT_IRQ_EXT
 	def_bool n
 
 menu "Processor type and features"
@@ -78,7 +78,7 @@ config XTENSA_VARIANT_DC232B
 
 config XTENSA_VARIANT_S6000
 	bool "s6000 - Stretch software configurable processor"
-	select VARIANT_IRQ_SWITCH
+	select VARIANT_IRQ_EXT
 	select ARCH_REQUIRE_GPIOLIB
 	select XTENSA_CALIBRATE_CCOUNT
 endchoice
diff --git a/arch/xtensa/configs/s6105_defconfig b/arch/xtensa/configs/s6105_defconfig
index 768bee0..51d4bae 100644
--- a/arch/xtensa/configs/s6105_defconfig
+++ b/arch/xtensa/configs/s6105_defconfig
@@ -103,7 +103,7 @@ CONFIG_DEFAULT_CFQ=y
 CONFIG_DEFAULT_IOSCHED="cfq"
 # CONFIG_FREEZER is not set
 # CONFIG_MMU is not set
-CONFIG_VARIANT_IRQ_SWITCH=y
+CONFIG_VARIANT_IRQ_EXT=y
 
 #
 # Processor type and features
diff --git a/arch/xtensa/include/asm/irq.h b/arch/xtensa/include/asm/irq.h
index dfac82d..4a39bb5 100644
--- a/arch/xtensa/include/asm/irq.h
+++ b/arch/xtensa/include/asm/irq.h
@@ -14,9 +14,11 @@
 #include <platform/hardware.h>
 #include <variant/core.h>
 
-#ifdef CONFIG_VARIANT_IRQ_SWITCH
+#ifdef CONFIG_VARIANT_IRQ_EXT
 #include <variant/irq.h>
-#else
+#endif
+
+#ifndef VARIANT_HAS_IRQ_ENABLE
 static inline void variant_irq_enable(unsigned int irq) { }
 static inline void variant_irq_disable(unsigned int irq) { }
 #endif
diff --git a/arch/xtensa/variants/s6000/include/variant/irq.h b/arch/xtensa/variants/s6000/include/variant/irq.h
index fa031cb..bcd496d 100644
--- a/arch/xtensa/variants/s6000/include/variant/irq.h
+++ b/arch/xtensa/variants/s6000/include/variant/irq.h
@@ -3,6 +3,7 @@
 
 #define NO_IRQ		(-1)
 
+#define VARIANT_HAS_IRQ_ENABLE
 extern void variant_irq_enable(unsigned int irq);
 extern void variant_irq_disable(unsigned int irq);
 
-- 
1.6.1.3

