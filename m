Return-Path: <linux-kernel-owner+w=401wt.eu-S1755853AbZIUJfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853AbZIUJfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 05:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755788AbZIUJfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 05:35:39 -0400
Received: from mail.atmel.fr ([81.80.104.162]:60433 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755740AbZIUJfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 05:35:38 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, avictor.za@gmail.com,
       haavard.skinnemoen@atmel.com, kernel@avr32linux.org
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] at91: at91sam9g45 family: identify several chip versions
Date: Mon, 21 Sep 2009 12:40:01 +0200
Message-Id: <1253529601-15474-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpu_is_xxx() macros are identifying generic at91sam9g45 chip. This patch adds
the capacity to differentiate Engineering Samples and final lots through the
inclusion of  at91_cpu_fully_identify() and the related chip IDs with chip
version field preserved.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/include/mach/cpu.h     |    9 +++++++++
 arch/avr32/mach-at32ap/include/mach/cpu.h |    1 +
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-at91/include/mach/cpu.h b/arch/arm/mach-at91/include/mach/cpu.h
index 6d8c1b9..5a06501 100644
--- a/arch/arm/mach-at91/include/mach/cpu.h
+++ b/arch/arm/mach-at91/include/mach/cpu.h
@@ -25,6 +25,8 @@
 #define ARCH_ID_AT91SAM9G20	0x019905a0
 #define ARCH_ID_AT91SAM9RL64	0x019b03a0
 #define ARCH_ID_AT91SAM9G45	0x819b05a0
+#define ARCH_ID_AT91SAM9G45MRL	0x819b05a2	/* aka 9G45-ES2 & non ES lots */
+#define ARCH_ID_AT91SAM9G45ES	0x819b05a1	/* 9G45-ES (Engineering Sample) */
 #define ARCH_ID_AT91CAP9	0x039A03A0
 
 #define ARCH_ID_AT91SAM9XE128	0x329973a0
@@ -43,6 +45,11 @@ static inline unsigned long at91_cpu_identify(void)
 	return (at91_sys_read(AT91_DBGU_CIDR) & ~AT91_CIDR_VERSION);
 }
 
+static inline unsigned long at91_cpu_fully_identify(void)
+{
+	return at91_sys_read(AT91_DBGU_CIDR);
+}
+
 #define ARCH_EXID_AT91SAM9M11	0x00000001
 #define ARCH_EXID_AT91SAM9M10	0x00000002
 #define ARCH_EXID_AT91SAM9G45	0x00000004
@@ -120,8 +127,10 @@ static inline unsigned long at91cap9_rev_identify(void)
 
 #ifdef CONFIG_ARCH_AT91SAM9G45
 #define cpu_is_at91sam9g45()	(at91_cpu_identify() == ARCH_ID_AT91SAM9G45)
+#define cpu_is_at91sam9g45es()	(at91_cpu_fully_identify() == ARCH_ID_AT91SAM9G45ES)
 #else
 #define cpu_is_at91sam9g45()	(0)
+#define cpu_is_at91sam9g45es()	(0)
 #endif
 
 #ifdef CONFIG_ARCH_AT91CAP9
diff --git a/arch/avr32/mach-at32ap/include/mach/cpu.h b/arch/avr32/mach-at32ap/include/mach/cpu.h
index c253e9b..9c96a13 100644
--- a/arch/avr32/mach-at32ap/include/mach/cpu.h
+++ b/arch/avr32/mach-at32ap/include/mach/cpu.h
@@ -33,5 +33,6 @@
 #define cpu_is_at91cap9()	(0)
 #define cpu_is_at91sam9g10()	(0)
 #define cpu_is_at91sam9g45()	(0)
+#define cpu_is_at91sam9g45es()	(0)
 
 #endif /* __ASM_ARCH_CPU_H */
-- 
1.5.6.5

