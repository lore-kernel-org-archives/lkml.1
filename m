Return-Path: <linux-kernel-owner+w=401wt.eu-S2993007AbXDDSP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993007AbXDDSP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992999AbXDDSPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:15:21 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:40343 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422671AbXDDSOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:14:36 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <david-b@pacbell.net>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH 88/90] ARM: OMAP: OSK led fixes
Date: Wed,  4 Apr 2007 14:06:07 -0400
Message-Id: <11757102112115-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11757102082555-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com> <11757100011056-git-send-email-tony@atomide.com> <1175710003925-git-send-email-tony@atomide.com> <11757100063945-git-send-email-tony@atomide.com> <11757100092910-git-send-email-tony@atomide.com> <11757100112473-git-send-email-tony@atomide.com> <11757100143517-git-send-email-tony@atomide.com> <11757100163760-git-send-email-tony@atomide.com> <11757100181189-git-send-email-tony@atomide.com> <11757100214151-git-send-email-tony@atomide.com> <11757100242980-git-send-email-tony@atomide.com> <1175710026446-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <11757100302964-git-send-email-tony@atomide.com> <1175710033286-git-send-email-tony@atomide.com> <117!
 57100403021-git-send-email-tony@atomide.com> <11757100423982-git-send-email-tony@atomide.com> <117571004562-git-send-email-tony@atomide.com> <11757100491583-git-send-email-tony@atomide.com> <11757100511172-git-send-email-tony@atomide.com> <1175710059333-git-send-email-tony@atomide.com> <11757100623383-git-send-email-tony@atomide.com> <11757100641006-git-send-email-tony@atomide.com> <11757100661228-git-send-email-tony@atomide.com> <11757100691131-git-send-email-tony@atomide.com> <11757100713004-git-send-email-tony@atomide.com> <11757100752021-git-send-email-tony@atomide.com> <11757100781275-git-send-email-tony@atomide.com> <11757100811771-git-send-email-tony@atomide.com> <11757100821353-git-send-email-tony@atomide.com> <11757100853841-git-send-email-tony@atomide.com> <1175710087578-git-send-email-tony@atomide.com> <11757100911247-git-send-email-tony@atomide.com> <1175710093864-git-send-email-tony@atomide.com> <11757100952384-git-send-email-tony@atomide.com> <11757100982726-g!
 it-send-email-tony@atomide.com> <11757101012787-git-send-email-tony@atomide.com> <1175710103340-git-send-email-tony@atomide.com> <11757101072553-git-send-email-tony@atomide.com> <11757101101180-git-send-email-tony@atomide.com> <11757101123620-git-send-email-tony@atomide.com> <11757101141643-git-send-email-tony@atomide.com> <
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <david-b@pacbell.net>

Bugfixes for the OSK led support:

 - Fix Kconfig merge glitches:  Mistral handles idle and timer leds just fine
 - Fix pm_suspend() runtime botch:  can't sleep, so can't touch tps65010 leds

Improvements:
 - Switch sense of Mistral idle led, so idle == off

Probably the TPS65010 leds should be handled only by the "new led" API.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/Kconfig               |    7 +++++--
 arch/arm/mach-omap1/leds-osk.c |    6 +++---
 arch/arm/mach-omap1/pm.c       |   11 -----------
 3 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index b995945..ddaa5b3 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -668,7 +668,8 @@ config LEDS
 
 config LEDS_TIMER
 	bool "Timer LED" if (!ARCH_CDB89712 && !ARCH_OMAP) || \
-			    MACH_OMAP_H2 || MACH_OMAP_PERSEUS2
+			    OMAP_OSK_MISTRAL || MACH_OMAP_H2 \
+			    || MACH_OMAP_PERSEUS2
 	depends on LEDS
 	default y if ARCH_EBSA110
 	help
@@ -684,7 +685,9 @@ config LEDS_TIMER
 
 config LEDS_CPU
 	bool "CPU usage LED" if (!ARCH_CDB89712 && !ARCH_EBSA110 && \
-			!ARCH_OMAP) || MACH_OMAP_H2 || MACH_OMAP_PERSEUS2
+			!ARCH_OMAP) \
+			|| OMAP_OSK_MISTRAL || MACH_OMAP_H2 \
+			|| MACH_OMAP_PERSEUS2
 	depends on LEDS
 	help
 	  If you say Y here, the red LED will be used to give a good real
diff --git a/arch/arm/mach-omap1/leds-osk.c b/arch/arm/mach-omap1/leds-osk.c
index 0cbf1b0..86de303 100644
--- a/arch/arm/mach-omap1/leds-osk.c
+++ b/arch/arm/mach-omap1/leds-osk.c
@@ -133,13 +133,13 @@ void osk_leds_event(led_event_t evt)
 		mistral_setled();
 		break;
 
-	case led_idle_start:
-		hw_led_state |= IDLE_LED;
+	case led_idle_start:	/* idle == off */
+		hw_led_state &= ~IDLE_LED;
 		mistral_setled();
 		break;
 
 	case led_idle_end:
-		hw_led_state &= ~IDLE_LED;
+		hw_led_state |= IDLE_LED;
 		mistral_setled();
 		break;
 
diff --git a/arch/arm/mach-omap1/pm.c b/arch/arm/mach-omap1/pm.c
index 743029a..64c93ac 100644
--- a/arch/arm/mach-omap1/pm.c
+++ b/arch/arm/mach-omap1/pm.c
@@ -58,7 +58,6 @@
 #include <asm/arch/tc.h>
 #include <asm/arch/pm.h>
 #include <asm/arch/mux.h>
-#include <asm/arch/tps65010.h>
 #include <asm/arch/dma.h>
 #include <asm/arch/dsp_common.h>
 #include <asm/arch/dmtimer.h>
@@ -248,11 +247,6 @@ void omap_pm_suspend(void)
 
 	omap_serial_wake_trigger(1);
 
-	if (machine_is_omap_osk()) {
-		/* Stop LED1 (D9) blink */
-		tps65010_set_led(LED1, OFF);
-	}
-
 	if (!cpu_is_omap15xx())
 		omap_writew(0xffff, ULPD_SOFT_DISABLE_REQ_REG);
 
@@ -445,11 +439,6 @@ void omap_pm_suspend(void)
 	omap_serial_wake_trigger(0);
 
 	printk("PM: OMAP%x is re-starting from deep sleep...\n", system_rev);
-
-	if (machine_is_omap_osk()) {
-		/* Let LED1 (D9) blink again */
-		tps65010_set_led(LED1, BLINK);
-	}
 }
 
 #if defined(DEBUG) && defined(CONFIG_PROC_FS)
-- 
1.4.4.2

