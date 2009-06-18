Return-Path: <linux-kernel-owner+w=401wt.eu-S1762335AbZFRPM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762335AbZFRPM6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 11:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753402AbZFRPMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 11:12:49 -0400
Received: from mail.atmel.fr ([81.80.104.162]:37753 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669AbZFRPMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 11:12:48 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: avictor.za@gmail.com, linux-arm-kernel@lists.arm.linux.org.uk
Cc: patrice.vilchez@atmel.com, linux-kernel@vger.kernel.org,
       Hong Xu <hong.xu@atmel.com>
Subject: [PATCH 1/5] at91: Basic support for at91sam9g10: header files
Date: Thu, 18 Jun 2009 18:16:08 +0200
Message-Id: <1245341772-1689-2-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1245341772-1689-1-git-send-email-nicolas.ferre@atmel.com>
References: <1245341772-1689-1-git-send-email-nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hong Xu <hong.xu@atmel.com>

AT91sam9g10 is an ARM 926ej-s SOC. It is an evolution of the at91sam9261 with a
faster clock speed: 266/133MHz.

Here is the basic header file support for this product.

Signed-off-by: Hong Xu <hong.xu@atmel.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/include/mach/at91sam9261.h |    3 +++
 arch/arm/mach-at91/include/mach/cpu.h         |    7 +++++++
 arch/arm/mach-at91/include/mach/hardware.h    |    2 +-
 arch/arm/mach-at91/include/mach/timex.h       |    5 +++++
 4 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-at91/include/mach/at91sam9261.h b/arch/arm/mach-at91/include/mach/at91sam9261.h
index 3a348ca..87de8be 100644
--- a/arch/arm/mach-at91/include/mach/at91sam9261.h
+++ b/arch/arm/mach-at91/include/mach/at91sam9261.h
@@ -95,6 +95,9 @@
 #define AT91SAM9261_SRAM_BASE	0x00300000	/* Internal SRAM base address */
 #define AT91SAM9261_SRAM_SIZE	0x00028000	/* Internal SRAM size (160Kb) */
 
+#define AT91SAM9G10_SRAM_BASE	AT91SAM9261_SRAM_BASE	/* Internal SRAM base address */
+#define AT91SAM9G10_SRAM_SIZE	0x00004000	/* Internal SRAM size (16Kb) */
+
 #define AT91SAM9261_ROM_BASE	0x00400000	/* Internal ROM base address */
 #define AT91SAM9261_ROM_SIZE	SZ_32K		/* Internal ROM size (32Kb) */
 
diff --git a/arch/arm/mach-at91/include/mach/cpu.h b/arch/arm/mach-at91/include/mach/cpu.h
index b73e7bf..34a9502 100644
--- a/arch/arm/mach-at91/include/mach/cpu.h
+++ b/arch/arm/mach-at91/include/mach/cpu.h
@@ -21,6 +21,7 @@
 #define ARCH_ID_AT91SAM9260	0x019803a0
 #define ARCH_ID_AT91SAM9261	0x019703a0
 #define ARCH_ID_AT91SAM9263	0x019607a0
+#define ARCH_ID_AT91SAM9G10	0x819903a0
 #define ARCH_ID_AT91SAM9G20	0x019905a0
 #define ARCH_ID_AT91SAM9RL64	0x019b03a0
 #define ARCH_ID_AT91SAM9G45	0x819b05a0
@@ -97,6 +98,12 @@ static inline unsigned long at91cap9_rev_identify(void)
 #define cpu_is_at91sam9261()	(0)
 #endif
 
+#ifdef CONFIG_ARCH_AT91SAM9G10
+#define cpu_is_at91sam9g10()	(at91_cpu_identify() == ARCH_ID_AT91SAM9G10)
+#else
+#define cpu_is_at91sam9g10()	(0)
+#endif
+
 #ifdef CONFIG_ARCH_AT91SAM9263
 #define cpu_is_at91sam9263()	(at91_cpu_identify() == ARCH_ID_AT91SAM9263)
 #else
diff --git a/arch/arm/mach-at91/include/mach/hardware.h b/arch/arm/mach-at91/include/mach/hardware.h
index f086917..a0df8b0 100644
--- a/arch/arm/mach-at91/include/mach/hardware.h
+++ b/arch/arm/mach-at91/include/mach/hardware.h
@@ -20,7 +20,7 @@
 #include <mach/at91rm9200.h>
 #elif defined(CONFIG_ARCH_AT91SAM9260) || defined(CONFIG_ARCH_AT91SAM9G20)
 #include <mach/at91sam9260.h>
-#elif defined(CONFIG_ARCH_AT91SAM9261)
+#elif defined(CONFIG_ARCH_AT91SAM9261) || defined(CONFIG_ARCH_AT91SAM9G10)
 #include <mach/at91sam9261.h>
 #elif defined(CONFIG_ARCH_AT91SAM9263)
 #include <mach/at91sam9263.h>
diff --git a/arch/arm/mach-at91/include/mach/timex.h b/arch/arm/mach-at91/include/mach/timex.h
index 38f6c42..31ac2d9 100644
--- a/arch/arm/mach-at91/include/mach/timex.h
+++ b/arch/arm/mach-at91/include/mach/timex.h
@@ -42,6 +42,11 @@
 #define AT91SAM9_MASTER_CLOCK	99300000
 #define CLOCK_TICK_RATE		(AT91SAM9_MASTER_CLOCK/16)
 
+#elif defined(CONFIG_ARCH_AT91SAM9G10)
+
+#define AT91SAM9_MASTER_CLOCK	133000000
+#define CLOCK_TICK_RATE		(AT91SAM9_MASTER_CLOCK/16)
+
 #elif defined(CONFIG_ARCH_AT91SAM9263)
 
 #if defined(CONFIG_MACH_USB_A9263)
-- 
1.5.3.7

