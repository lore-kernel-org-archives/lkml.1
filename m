Return-Path: <linux-kernel-owner+w=401wt.eu-S1161182AbXBAQRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161182AbXBAQRU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 11:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161184AbXBAQRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 11:17:20 -0500
Received: from www.osadl.org ([213.239.205.134]:40326 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161182AbXBAQRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 11:17:19 -0500
Subject: [PATCH 2.6.20-rc7] at91: correct value for AT91_RSTC_KEY
From: Jan Altenberg <jan@linutronix.de>
To: andrew@sanpeople.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Thu, 01 Feb 2007 17:17:08 +0100
Message-Id: <1170346628.20424.12.camel@jan-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

- Remove a duplicated define for AT91_RSTC_KEY
- Set AT91_RSTC_KEY to the correct value
- Replace the hardcoded keys in at91sam9620.c and at91sam9261.c
  by AT91_RSTC_KEY

Signed-off-by: Jan Altenberg <jan@linutronix.de>

---
 arch/arm/mach-at91rm9200/at91sam9260.c      |    2 +-
 arch/arm/mach-at91rm9200/at91sam9261.c      |    2 +-
 include/asm-arm/arch-at91rm9200/at91_rstc.h |    3 +--
 3 files changed, 3 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/arm/mach-at91rm9200/at91sam9260.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-at91rm9200/at91sam9260.c
+++ linux-2.6/arch/arm/mach-at91rm9200/at91sam9260.c
@@ -213,7 +213,7 @@ static struct at91_gpio_bank at91sam9260
 
 static void at91sam9260_reset(void)
 {
-	at91_sys_write(AT91_RSTC_CR, (0xA5 << 24) | AT91_RSTC_PROCRST | AT91_RSTC_PERRST);
+	at91_sys_write(AT91_RSTC_CR, AT91_RSTC_KEY | AT91_RSTC_PROCRST | AT91_RSTC_PERRST);
 }
 
 
Index: linux-2.6/arch/arm/mach-at91rm9200/at91sam9261.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-at91rm9200/at91sam9261.c
+++ linux-2.6/arch/arm/mach-at91rm9200/at91sam9261.c
@@ -208,7 +208,7 @@ static struct at91_gpio_bank at91sam9261
 
 static void at91sam9261_reset(void)
 {
-	at91_sys_write(AT91_RSTC_CR, (0xA5 << 24) | AT91_RSTC_PROCRST | AT91_RSTC_PERRST);
+	at91_sys_write(AT91_RSTC_CR, AT91_RSTC_KEY | AT91_RSTC_PROCRST | AT91_RSTC_PERRST);
 }
 
 
Index: linux-2.6/include/asm-arm/arch-at91rm9200/at91_rstc.h
===================================================================
--- linux-2.6.orig/include/asm-arm/arch-at91rm9200/at91_rstc.h
+++ linux-2.6/include/asm-arm/arch-at91rm9200/at91_rstc.h
@@ -17,7 +17,7 @@
 #define		AT91_RSTC_PROCRST	(1 << 0)		/* Processor Reset */
 #define		AT91_RSTC_PERRST	(1 << 2)		/* Peripheral Reset */
 #define		AT91_RSTC_EXTRST	(1 << 3)		/* External Reset */
-#define		AT91_RSTC_KEY		(0xff << 24)		/* KEY Password */
+#define		AT91_RSTC_KEY		(0xa5 << 24)		/* KEY Password */
 
 #define AT91_RSTC_SR		(AT91_RSTC + 0x04)	/* Reset Controller Status Register */
 #define		AT91_RSTC_URSTS		(1 << 0)		/* User Reset Status */
@@ -34,6 +34,5 @@
 #define		AT91_RSTC_URSTEN	(1 << 0)		/* User Reset Enable */
 #define		AT91_RSTC_URSTIEN	(1 << 4)		/* User Reset Interrupt Enable */
 #define		AT91_RSTC_ERSTL		(0xf << 8)		/* External Reset Length */
-#define		AT91_RSTC_KEY		(0xff << 24)		/* KEY Password */
 
 #endif


