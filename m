Return-Path: <linux-kernel-owner+w=401wt.eu-S1752844AbYKYPYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbYKYPYG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 10:24:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbYKYPW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 10:22:59 -0500
Received: from an-out-0708.google.com ([209.85.132.244]:4410 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbYKYPWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 10:22:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=iGtpnsGb0hoW099d2dvUkiXU/OkSIWbhgTxiON4rrLTx4pMrAibJvinOr7WK1Y0OKj
         5g00VzoMOZiLzTyTYrAv+QG4gDzpHanV07IHYQnApgB5vNQEbG4LAcOaJPccr6SdbslJ
         QLcT3JlDQUVlzK0vDu/xSylrr1hr6SPm6ssMg=
From: "Antonio R. Costa" <costa.antonior@gmail.com>
To: linux@maxim.org.za, nicolas.ferre@atmel.com
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       "Antonio R. Costa" <costa.antonior@gmail.com>
Subject: [PATCH 4/5] [RFC PATCH] Support for AT572D940HF-EK [RFC PATCH]
Date: Tue, 25 Nov 2008 16:22:44 +0100
Message-Id: <1227626565-25209-4-git-send-email-costa.antonior@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1227626565-25209-3-git-send-email-costa.antonior@gmail.com>
References: <>
 <1227626565-25209-1-git-send-email-costa.antonior@gmail.com>
 <1227626565-25209-2-git-send-email-costa.antonior@gmail.com>
 <1227626565-25209-3-git-send-email-costa.antonior@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AT572D940HF (Diopsis) is an ARM926 + a 40-bits floating point DSP
(mAgicV)

Reference for machine type:
1783    Atmel DIOPSIS AT572D940HF EK

This RFC patch starts from v2.6.26 because we needed to
test it together with Xenomai 2.4.5.

This patch, if approved, will be rebased to the latest linux kernel.

Shared files in include/asm-arm

	include/asm-arm/arch-at91/board.h
	include/asm-arm/arch-at91/cpu.h
	include/asm-arm/arch-at91/hardware.h
	include/asm-arm/arch-at91/timex.h

Signed-off-by: Antonio R. Costa <costa.antonior@gmail.com>
---
 include/asm-arm/arch-at91/board.h    |    2 +-
 include/asm-arm/arch-at91/cpu.h      |    9 +++++++++
 include/asm-arm/arch-at91/hardware.h |    2 ++
 include/asm-arm/arch-at91/timex.h    |    5 +++++
 4 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/include/asm-arm/arch-at91/board.h b/include/asm-arm/arch-at91/board.h
index dc189f0..ada176e 100644
--- a/include/asm-arm/arch-at91/board.h
+++ b/include/asm-arm/arch-at91/board.h
@@ -73,7 +73,7 @@ struct at91_eth_data {
 };
 extern void __init at91_add_device_eth(struct at91_eth_data *data);
 
-#if defined(CONFIG_ARCH_AT91SAM9260) || defined(CONFIG_ARCH_AT91SAM9263) || defined(CONFIG_ARCH_AT91CAP9)
+#if defined(CONFIG_ARCH_AT91SAM9260) || defined(CONFIG_ARCH_AT91SAM9263) || defined(CONFIG_ARCH_AT91CAP9) || defined(CONFIG_ARCH_AT572D940HF)
 #define eth_platform_data	at91_eth_data
 #endif
 
diff --git a/include/asm-arm/arch-at91/cpu.h b/include/asm-arm/arch-at91/cpu.h
index 7145166..de1fc8c 100644
--- a/include/asm-arm/arch-at91/cpu.h
+++ b/include/asm-arm/arch-at91/cpu.h
@@ -28,6 +28,9 @@
 #define ARCH_ID_AT91SAM9XE256	0x329a93a0
 #define ARCH_ID_AT91SAM9XE512	0x329aa3a0
 
+#define CIDR_AT572D940HF	0x0e0303e0
+#define ARCH_ID_AT572D940HF	(CIDR_AT572D940HF)
+
 #define ARCH_ID_AT91M40800	0x14080044
 #define ARCH_ID_AT91R40807	0x44080746
 #define ARCH_ID_AT91M40807	0x14080745
@@ -87,6 +90,12 @@ static inline unsigned long at91_arch_identify(void)
 #define cpu_is_at91cap9()	(0)
 #endif
 
+#ifdef CONFIG_ARCH_AT572D940HF
+#define cpu_is_at572d940hf() (at91_cpu_identify() == ARCH_ID_AT572D940HF)
+#else
+#define cpu_is_at572d940hf() (0)
+#endif
+
 /*
  * Since this is ARM, we will never run on any AVR32 CPU. But these
  * definitions may reduce clutter in common drivers.
diff --git a/include/asm-arm/arch-at91/hardware.h b/include/asm-arm/arch-at91/hardware.h
index 2c826d8..c89b6df 100644
--- a/include/asm-arm/arch-at91/hardware.h
+++ b/include/asm-arm/arch-at91/hardware.h
@@ -30,6 +30,8 @@
 #include <asm/arch/at91cap9.h>
 #elif defined(CONFIG_ARCH_AT91X40)
 #include <asm/arch/at91x40.h>
+#elif defined(CONFIG_ARCH_AT572D940HF)
+#include <asm/arch/at572d940hf.h>
 #else
 #error "Unsupported AT91 processor"
 #endif
diff --git a/include/asm-arm/arch-at91/timex.h b/include/asm-arm/arch-at91/timex.h
index f1933b0..9fd19ed 100644
--- a/include/asm-arm/arch-at91/timex.h
+++ b/include/asm-arm/arch-at91/timex.h
@@ -52,6 +52,11 @@
 #define AT91X40_MASTER_CLOCK	40000000
 #define CLOCK_TICK_RATE		(AT91X40_MASTER_CLOCK)
 
+#elif defined(CONFIG_ARCH_AT572D940HF)
+
+#define AT572D940HF_MASTER_CLOCK	80000000
+#define CLOCK_TICK_RATE		(AT572D940HF_MASTER_CLOCK/16)
+
 #endif
 
 #endif
-- 
1.5.4.3

