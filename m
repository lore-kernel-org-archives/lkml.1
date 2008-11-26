Return-Path: <linux-kernel-owner+w=401wt.eu-S1755044AbYKZTVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbYKZTVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 14:21:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbYKZTVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 14:21:12 -0500
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:44300 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751449AbYKZTVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 14:21:10 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=e38GNbiBOJO3KGT2lujxn1oaptLSWwyEsRrtVTTiMem3GD3qq+J3EvacC66jCL4n0zhDTduOjlW3k7VyThkFJhaZv04JfHPj/vTHiT6Wa31Bl+d/kaC0TVWv1bSFGZkMbZA93VMFcYHii+eBaEI6gFyrtvv1nj8ILUr6XnS+9nQ=  ;
X-YMail-OSG: zAvQGPkVM1mVaVVvK6I44KC.XvJYwMLErUb74qFqmLeBsWgQv6xE7hgolxMKCkgz.ek1B.IXNxX7WSpMKL4ge9998y4yFE7.hOkHZHqJS.9ElLP85mT4GsEISdvk.EdGfTwPnbDWSLFvvU4qngEN8EQY
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Samuel Ortiz <sameo@openedhand.com>
Subject: [patch 2.6.28-rc6 2/3] mfd: twl4030: cleanup symbols and OMAP dependency
Date: Wed, 26 Nov 2008 10:58:11 -0800
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
       Mark Brown <broonie@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811261058.12061.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Finish removing dependency of TWL driver stack on platform-specific
IRQ definitions ... and remove the build dependency on OMAP.

This lets the TWL4030 code be included in test builds for most
platforms, and will make it easier for non-OMAP folk to update
most of this code for new APIs etc.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
Relies on patch #1 to hand this data to drivers explicitly,
rather than through global #defines.  Build tested only on
X86_64 and ARM/OMAP.

 drivers/mfd/Kconfig         |    2 +-
 include/linux/i2c/twl4030.h |   31 -------------------------------
 2 files changed, 1 insertion(+), 32 deletions(-)

--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -63,7 +63,7 @@ config UCB1400_CORE
 
 config TWL4030_CORE
 	bool "Texas Instruments TWL4030/TPS659x0 Support"
-	depends on I2C=y && GENERIC_HARDIRQS && (ARCH_OMAP2 || ARCH_OMAP3)
+	depends on I2C=y && GENERIC_HARDIRQS
 	help
 	  Say yes here if you have TWL4030 family chip on your board.
 	  This core driver provides register access and IRQ handling
--- a/include/linux/i2c/twl4030.h
+++ b/include/linux/i2c/twl4030.h
@@ -285,33 +285,6 @@ struct twl4030_platform_data {
 
 int twl4030_sih_setup(int module);
 
-/*
- * FIXME completely stop using TWL4030_IRQ_BASE ... instead, pass the
- * IRQ data to subsidiary devices using platform device resources.
- */
-
-/* IRQ information-need base */
-#include <mach/irqs.h>
-/* TWL4030 interrupts */
-
-/* #define TWL4030_MODIRQ_GPIO		(TWL4030_IRQ_BASE + 0) */
-#define TWL4030_MODIRQ_KEYPAD		(TWL4030_IRQ_BASE + 1)
-#define TWL4030_MODIRQ_BCI		(TWL4030_IRQ_BASE + 2)
-#define TWL4030_MODIRQ_MADC		(TWL4030_IRQ_BASE + 3)
-/* #define TWL4030_MODIRQ_USB		(TWL4030_IRQ_BASE + 4) */
-/* #define TWL4030_MODIRQ_PWR		(TWL4030_IRQ_BASE + 5) */
-
-#define TWL4030_PWRIRQ_PWRBTN		(TWL4030_PWR_IRQ_BASE + 0)
-/* #define TWL4030_PWRIRQ_CHG_PRES		(TWL4030_PWR_IRQ_BASE + 1) */
-/* #define TWL4030_PWRIRQ_USB_PRES		(TWL4030_PWR_IRQ_BASE + 2) */
-/* #define TWL4030_PWRIRQ_RTC		(TWL4030_PWR_IRQ_BASE + 3) */
-/* #define TWL4030_PWRIRQ_HOT_DIE		(TWL4030_PWR_IRQ_BASE + 4) */
-/* #define TWL4030_PWRIRQ_PWROK_TIMEOUT	(TWL4030_PWR_IRQ_BASE + 5) */
-/* #define TWL4030_PWRIRQ_MBCHG		(TWL4030_PWR_IRQ_BASE + 6) */
-/* #define TWL4030_PWRIRQ_SC_DETECT	(TWL4030_PWR_IRQ_BASE + 7) */
-
-/* Rest are unsued currently*/
-
 /* Offsets to Power Registers */
 #define TWL4030_VDAC_DEV_GRP		0x3B
 #define TWL4030_VDAC_DEDICATED		0x3E
@@ -322,10 +295,6 @@ int twl4030_sih_setup(int module);
 #define TWL4030_VAUX3_DEV_GRP		0x1F
 #define TWL4030_VAUX3_DEDICATED		0x22
 
-/* TWL4030 GPIO interrupt definitions */
-
-#define TWL4030_GPIO_IRQ_NO(n)		(TWL4030_GPIO_IRQ_BASE + (n))
-
 /*
  * Exported TWL4030 GPIO APIs
  *
