Return-Path: <linux-kernel-owner+w=401wt.eu-S1753860AbYKYPXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbYKYPXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 10:23:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbYKYPW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 10:22:58 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:21846 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbYKYPWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 10:22:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fDB1nriIOQWUm4KnTWpJ0yDDkr3nWwi2jZ3aK5czeCqaEvLGYOGEGc0q4Q+18H2t3O
         gJVIc5b38NNtlR7nC7DUUq11dQpKiyHVft/hcRAk4NM7O0LgEvRHgdOYtiM4HqT4YDEq
         JkPDz+o/Xbd0+XbOa1Ijtrh24vv9+maDXkhPQ=
From: "Antonio R. Costa" <costa.antonior@gmail.com>
To: linux@maxim.org.za, nicolas.ferre@atmel.com
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       "Antonio R. Costa" <costa.antonior@gmail.com>
Subject: [PATCH 3/5] [RFC PATCH] Support for AT572D940HF-EK [RFC PATCH]
Date: Tue, 25 Nov 2008 16:22:43 +0100
Message-Id: <1227626565-25209-3-git-send-email-costa.antonior@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1227626565-25209-2-git-send-email-costa.antonior@gmail.com>
References: <>
 <1227626565-25209-1-git-send-email-costa.antonior@gmail.com>
 <1227626565-25209-2-git-send-email-costa.antonior@gmail.com>
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

Shared files in arch/arm and drivers/net

	arch/arm/Kconfig
	arch/arm/mach-at91/Kconfig
	arch/arm/mach-at91/Makefile
	arch/arm/mach-at91/clock.c
	arch/arm/mach-at91/clock.h
	arch/arm/mach-at91/generic.h
	arch/arm/mm/Kconfig
	arch/arm/tools/mach-types
	drivers/net/Kconfig

Signed-off-by: Antonio R. Costa <costa.antonior@gmail.com>
---
 arch/arm/Kconfig             |    2 +-
 arch/arm/mach-at91/Kconfig   |   33 +++++++++++++++++++++++++++++++--
 arch/arm/mach-at91/Makefile  |    4 ++++
 arch/arm/mach-at91/clock.c   |    5 +++++
 arch/arm/mach-at91/clock.h   |    5 +++++
 arch/arm/mach-at91/generic.h |    2 ++
 arch/arm/mm/Kconfig          |    4 ++--
 arch/arm/tools/mach-types    |    1 +
 drivers/net/Kconfig          |    2 +-
 9 files changed, 52 insertions(+), 6 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index b786e68..9dbf7a0 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -217,7 +217,7 @@ config ARCH_AT91
 	select GENERIC_GPIO
 	help
 	  This enables support for systems based on the Atmel AT91RM9200,
-	  AT91SAM9 and AT91CAP9 processors.
+	  AT91SAM9, AT91CAP9 and AT572D940HF processors.
 
 config ARCH_CLPS7500
 	bool "Cirrus CL-PS7500FE"
diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 0fc07b6..e688c1a 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -38,6 +38,14 @@ config ARCH_AT91CAP9
 config ARCH_AT91X40
 	bool "AT91x40"
 
+config ARCH_AT572D940HF
+	bool "AT572D940HF"
+	select GENERIC_TIME
+	select GENERIC_CLOCKEVENTS
+	help
+	  Select this if you are using Atmel AT572D940HF ARM926EJS + mAgicV 40-points floating DSP
+          <http://www.atmel.com/products/diopsis/default.asp>
+
 endchoice
 
 config AT91_PMC_UNIT
@@ -241,19 +249,40 @@ config MACH_AT91EB01
 
 endif
 
+if ARCH_AT572D940HF
+
+comment "AT572D940HF Board Type"
+
+config MACH_AT572D940HF_EB
+	bool "AT572D940HF-EK"
+	depends on ARCH_AT572D940HF
+	help
+	  Select this if you are using Atmel's AT572D940HF-EK evaluation kit.
+	  <http://www.atmel.com/products/diopsis/default.asp>
+endif
+
 # ----------------------------------------------------------
 
 comment "AT91 Board Options"
 
+if MACH_AT572D940HF_EB
+config NUM_SERIAL
+	int "Number of UARTs to configure"
+	range 1 4
+	help
+	  Defines the number of USARTs to configure in the following list DBGU, USART0, USART1, USART2
+endif
+
+
 config MTD_AT91_DATAFLASH_CARD
 	bool "Enable DataFlash Card support"
-	depends on (ARCH_AT91RM9200DK || MACH_AT91RM9200EK || MACH_AT91SAM9260EK || MACH_AT91SAM9261EK || MACH_AT91SAM9263EK || MACH_AT91CAP9ADK || MACH_SAM9_L9260 || MACH_ECBAT91)
+	depends on (ARCH_AT91RM9200DK || MACH_AT91RM9200EK || MACH_AT91SAM9260EK || MACH_AT91SAM9261EK || MACH_AT91SAM9263EK || MACH_AT91CAP9ADK || MACH_SAM9_L9260 || MACH_ECBAT91 || MACH_AT572D940HF_EB)
 	help
 	  Enable support for the DataFlash card.
 
 config MTD_NAND_AT91_BUSWIDTH_16
 	bool "Enable 16-bit data bus interface to NAND flash"
-	depends on (MACH_AT91SAM9260EK || MACH_AT91SAM9261EK || MACH_AT91SAM9263EK || MACH_AT91CAP9ADK)
+	depends on (MACH_AT91SAM9260EK || MACH_AT91SAM9261EK || MACH_AT91SAM9263EK || MACH_AT91CAP9ADK || MACH_AT572D940HF_EB)
 	help
 	  On AT91SAM926x boards both types of NAND flash can be present
 	  (8 and 16 bit data bus width).
diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
index 8d9bc01..0d68a51 100644
--- a/arch/arm/mach-at91/Makefile
+++ b/arch/arm/mach-at91/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_ARCH_AT91SAM9263)	+= at91sam9263.o at91sam926x_time.o at91sam9263_d
 obj-$(CONFIG_ARCH_AT91SAM9RL)	+= at91sam9rl.o at91sam926x_time.o at91sam9rl_devices.o
 obj-$(CONFIG_ARCH_AT91CAP9)	+= at91cap9.o at91sam926x_time.o at91cap9_devices.o
 obj-$(CONFIG_ARCH_AT91X40)	+= at91x40.o at91x40_time.o
+obj-$(CONFIG_ARCH_AT572D940HF)  += at572d940hf.o at91sam926x_time.o at572d940hf_devices.o
 
 # AT91RM9200 board-specific support
 obj-$(CONFIG_MACH_ONEARM)	+= board-1arm.o
@@ -51,6 +52,9 @@ obj-$(CONFIG_MACH_AT91CAP9ADK)	+= board-cap9adk.o
 # AT91X40 board-specific support
 obj-$(CONFIG_MACH_AT91EB01)	+= board-eb01.o
 
+# AT572D940HF board-specific support
+obj-$(CONFIG_MACH_AT572D940HF_EB)	+= board-at572d940hf_ek.o
+
 # Drivers
 obj-y				+= leds.o
 
diff --git a/arch/arm/mach-at91/clock.c b/arch/arm/mach-at91/clock.c
index a33dfe4..e2ab66d 100644
--- a/arch/arm/mach-at91/clock.c
+++ b/arch/arm/mach-at91/clock.c
@@ -575,7 +575,12 @@ int __init at91_clock_init(unsigned long main_clock)
 		udpck.pmc_mask = AT91SAM926x_PMC_UDP;
 	} else if (cpu_is_at91cap9()) {
 		uhpck.pmc_mask = AT91CAP9_PMC_UHP;
+	} else if (cpu_is_at572d940hf()) {
+		printk("Architecture recognised\n");
+		uhpck.pmc_mask = (1<<6);
+		udpck.pmc_mask = AT572D940HF_PMC_UDP;
 	}
+
 	at91_sys_write(AT91_CKGR_PLLBR, 0);
 
 	udpck.rate_hz = at91_usb_rate(&pllb, pllb.rate_hz, at91_pllb_usb_init);
diff --git a/arch/arm/mach-at91/clock.h b/arch/arm/mach-at91/clock.h
index 1ba3b95..0212c37 100644
--- a/arch/arm/mach-at91/clock.h
+++ b/arch/arm/mach-at91/clock.h
@@ -22,10 +22,15 @@ struct clk {
 	struct clk	*parent;
 	u32		pmc_mask;
 	void		(*mode)(struct clk *, int);
+#ifdef ARCH_AT572D940HF
+	unsigned	id:3;		/* AT572D940HF needs an extra bit */
+#else
 	unsigned	id:2;		/* PCK0..3, or 32k/main/a/b */
+#endif
 	unsigned	type;		/* clock type */
 	u16		users;
 };
 
 
+
 extern int __init clk_register(struct clk *clk);
diff --git a/arch/arm/mach-at91/generic.h b/arch/arm/mach-at91/generic.h
index 7b9ce7a..9faf1f5 100644
--- a/arch/arm/mach-at91/generic.h
+++ b/arch/arm/mach-at91/generic.h
@@ -16,6 +16,7 @@ extern void __init at91sam9263_initialize(unsigned long main_clock);
 extern void __init at91sam9rl_initialize(unsigned long main_clock);
 extern void __init at91x40_initialize(unsigned long main_clock);
 extern void __init at91cap9_initialize(unsigned long main_clock);
+extern void __init at572d940hf_initialize(unsigned long main_clock);
 
  /* Interrupts */
 extern void __init at91rm9200_init_interrupts(unsigned int priority[]);
@@ -25,6 +26,7 @@ extern void __init at91sam9263_init_interrupts(unsigned int priority[]);
 extern void __init at91sam9rl_init_interrupts(unsigned int priority[]);
 extern void __init at91x40_init_interrupts(unsigned int priority[]);
 extern void __init at91cap9_init_interrupts(unsigned int priority[]);
+extern void __init at572d940hf_init_interrupts(unsigned int priority[]);
 extern void __init at91_aic_init(unsigned int priority[]);
 
  /* Timer */
diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index 33ed048..36142ae 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -180,8 +180,8 @@ config CPU_ARM925T
 # ARM926T
 config CPU_ARM926T
 	bool "Support ARM926T processor"
-	depends on ARCH_INTEGRATOR || ARCH_VERSATILE_PB || MACH_VERSATILE_AB || ARCH_OMAP730 || ARCH_OMAP16XX || MACH_REALVIEW_EB || ARCH_PNX4008 || ARCH_NETX || CPU_S3C2412 || ARCH_AT91SAM9260 || ARCH_AT91SAM9261 || ARCH_AT91SAM9263 || ARCH_AT91SAM9RL || ARCH_AT91CAP9 || ARCH_NS9XXX || ARCH_DAVINCI
-	default y if ARCH_VERSATILE_PB || MACH_VERSATILE_AB || ARCH_OMAP730 || ARCH_OMAP16XX || ARCH_PNX4008 || ARCH_NETX || CPU_S3C2412 || ARCH_AT91SAM9260 || ARCH_AT91SAM9261 || ARCH_AT91SAM9263 || ARCH_AT91SAM9RL || ARCH_AT91CAP9 || ARCH_NS9XXX || ARCH_DAVINCI
+	depends on ARCH_INTEGRATOR || ARCH_VERSATILE_PB || MACH_VERSATILE_AB || ARCH_OMAP730 || ARCH_OMAP16XX || MACH_REALVIEW_EB || ARCH_PNX4008 || ARCH_NETX || CPU_S3C2412 || ARCH_AT91SAM9260 || ARCH_AT91SAM9261 || ARCH_AT91SAM9263 || ARCH_AT91SAM9RL || ARCH_AT91CAP9 || ARCH_AT572D940HF || ARCH_NS9XXX || ARCH_DAVINCI
+	default y if ARCH_VERSATILE_PB || MACH_VERSATILE_AB || ARCH_OMAP730 || ARCH_OMAP16XX || ARCH_PNX4008 || ARCH_NETX || CPU_S3C2412 || ARCH_AT91SAM9260 || ARCH_AT91SAM9261 || ARCH_AT91SAM9263 || ARCH_AT91SAM9RL || ARCH_AT91CAP9 || ARCH_AT572D940HF || ARCH_NS9XXX || ARCH_DAVINCI
 	select CPU_32v5
 	select CPU_ABRT_EV5TJ
 	select CPU_PABRT_NOIFAR
diff --git a/arch/arm/tools/mach-types b/arch/arm/tools/mach-types
index 207a8b5..fea25ce 100644
--- a/arch/arm/tools/mach-types
+++ b/arch/arm/tools/mach-types
@@ -1720,3 +1720,4 @@ htc_kaiser		MACH_HTC_KAISER		HTC_KAISER		1724
 lg_ks20			MACH_LG_KS20		LG_KS20			1725
 hhgps			MACH_HHGPS		HHGPS			1726
 nokia_n810_wimax	MACH_NOKIA_N810_WIMAX	NOKIA_N810_WIMAX	1727
+at572d940hf		MACH_AT572D940HF_EB	AT572D940HF_EB		1783
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index f4182cf..bb03261 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -217,7 +217,7 @@ config MII
 
 config MACB
 	tristate "Atmel MACB support"
-	depends on AVR32 || ARCH_AT91SAM9260 || ARCH_AT91SAM9263 || ARCH_AT91CAP9
+	depends on AVR32 || ARCH_AT91SAM9260 || ARCH_AT91SAM9263 || ARCH_AT91CAP9 || ARCH_AT572D940HF
 	select PHYLIB
 	help
 	  The Atmel MACB ethernet interface is found on many AT32 and AT91
-- 
1.5.4.3

