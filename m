Return-Path: <linux-kernel-owner+w=401wt.eu-S1758285AbYE2S5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285AbYE2S5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 14:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754541AbYE2S4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 14:56:55 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:34208 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754030AbYE2S4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 14:56:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=HiU5QB1B69zbl0BGkvygwdCgkqj25Xy5XUDO4M16t5MgO3rJFxFsO7LrnK9X3nKCOrMSKOyhT6lAc2pHpTopoHFsSNsO6oPG2jPewTujVTkEeTy9oSX353ncZlImIfkgnlWZ27vfGhjkFPd6xqOSTy1hdT75PeEXPV8JsoXwAmo=  ;
X-YMail-OSG: PeI.PSUVM1k7QykJb_KInI6cpqyRl4gWdx7NGm_nHA1DEhiAB7gPOOsktpegllW7D7CDFyOHIH2JjPEKd4mQjcc5VWojpbXg4qhDhwUHlb0.0Hw7k3q9JSSuPCgsPN1NGtDAezNq29xMn4xwmtvtKJuB
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: lkml <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.26-rc4] add HAVE_CLK to Kconfig, for driver dependencies
Date: Thu, 29 May 2008 11:56:51 -0700
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Felipe Balbi <felipebalbi@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805291156.51933.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

This patch flags platforms as HAVE_CLK (or not) in Kconfig,
so that otherwise portable drivers which need those calls
can list that dependency.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
Something like this is a prerequisite for merging the musb_hdrc
driver, currently used on platforms including  Davinci, OMAP2430,
OMAP3xx ... and the discrete TUSB6010 chip, which doesn't have a
natural platform dependency.  (Used with OMAP 2420 in current
Nokia N8x0 tablets.)

 arch/Kconfig         |    7 +++++++
 arch/arm/Kconfig     |   13 +++++++++++++
 arch/avr32/Kconfig   |    1 +
 arch/powerpc/Kconfig |    1 +
 arch/sh/Kconfig      |    1 +
 5 files changed, 23 insertions(+)

--- a/arch/Kconfig	2008-04-29 12:29:26.000000000 -0700
+++ b/arch/Kconfig	2008-05-29 11:33:32.000000000 -0700
@@ -39,3 +39,10 @@ config HAVE_KRETPROBES
 
 config HAVE_DMA_ATTRS
 	def_bool n
+
+config HAVE_CLK
+	def_bool n
+	help
+	  The <linux/clk.h> calls support software clock gating and
+	  thus are a key power management tool on many systems.
+
--- a/arch/arm/Kconfig	2008-05-27 15:38:15.000000000 -0700
+++ b/arch/arm/Kconfig	2008-05-29 11:38:24.000000000 -0700
@@ -183,12 +183,14 @@ choice
 config ARCH_AAEC2000
 	bool "Agilent AAEC-2000 based"
 	select ARM_AMBA
+	select HAVE_CLK
 	help
 	  This enables support for systems based on the Agilent AAEC-2000
 
 config ARCH_INTEGRATOR
 	bool "ARM Ltd. Integrator family"
 	select ARM_AMBA
+	select HAVE_CLK
 	select ICST525
 	help
 	  Support for ARM's Integrator platform.
@@ -196,6 +198,7 @@ config ARCH_INTEGRATOR
 config ARCH_REALVIEW
 	bool "ARM Ltd. RealView family"
 	select ARM_AMBA
+	select HAVE_CLK
 	select ICST307
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
@@ -206,6 +209,7 @@ config ARCH_VERSATILE
 	bool "ARM Ltd. Versatile family"
 	select ARM_AMBA
 	select ARM_VIC
+	select HAVE_CLK
 	select ICST307
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
@@ -215,6 +219,7 @@ config ARCH_VERSATILE
 config ARCH_AT91
 	bool "Atmel AT91"
 	select GENERIC_GPIO
+	select HAVE_CLK
 	select HAVE_GPIO_LIB
 	help
 	  This enables support for systems based on the Atmel AT91RM9200,
@@ -255,6 +260,7 @@ config ARCH_EP93XX
 	select ARM_AMBA
 	select ARM_VIC
 	select GENERIC_GPIO
+	select HAVE_CLK
 	select HAVE_GPIO_LIB
 	help
 	  This enables support for the Cirrus EP93xx series of CPUs.
@@ -360,6 +366,7 @@ config ARCH_NS9XXX
 	select GENERIC_GPIO
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
+	select HAVE_CLK
 	help
 	  Say Y here if you intend to run this kernel on a NetSilicon NS9xxx
 	  System.
@@ -386,6 +393,7 @@ config ARCH_ORION5X
 
 config ARCH_PNX4008
 	bool "Philips Nexperia PNX4008 Mobile"
+	select HAVE_CLK
 	help
 	  This enables support for Philips PNX4008 mobile platform.
 
@@ -394,6 +402,7 @@ config ARCH_PXA
 	depends on MMU
 	select ARCH_MTD_XIP
 	select GENERIC_GPIO
+	select HAVE_CLK
 	select HAVE_GPIO_LIB
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
@@ -423,6 +432,7 @@ config ARCH_SA1100
 	select GENERIC_GPIO
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
+	select HAVE_CLK
 	select TICK_ONESHOT
 	select HAVE_GPIO_LIB
 	help
@@ -431,6 +441,7 @@ config ARCH_SA1100
 config ARCH_S3C2410
 	bool "Samsung S3C2410, S3C2412, S3C2413, S3C2440, S3C2442, S3C2443"
 	select GENERIC_GPIO
+	select HAVE_CLK
 	help
 	  Samsung S3C2410X CPU based systems, such as the Simtec Electronics
 	  BAST (<http://www.simtec.co.uk/products/EB110ITX/>), the IPAQ 1940 or
@@ -458,12 +469,14 @@ config ARCH_DAVINCI
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_GPIO
+	select HAVE_CLK
 	help
 	  Support for TI's DaVinci platform.
 
 config ARCH_OMAP
 	bool "TI OMAP"
 	select GENERIC_GPIO
+	select HAVE_CLK
 	select HAVE_GPIO_LIB
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
--- a/arch/avr32/Kconfig	2008-05-29 11:40:42.000000000 -0700
+++ b/arch/avr32/Kconfig	2008-05-29 11:41:08.000000000 -0700
@@ -10,6 +10,7 @@ config AVR32
 	# With EMBEDDED=n, we get lots of stuff automatically selected
 	# that we usually don't need on AVR32.
 	select EMBEDDED
+	select HAVE_CLK
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	help
--- a/arch/powerpc/Kconfig	2008-05-29 11:45:49.000000000 -0700
+++ b/arch/powerpc/Kconfig	2008-05-29 11:45:57.000000000 -0700
@@ -812,6 +812,7 @@ source "crypto/Kconfig"
 config PPC_CLOCK
 	bool
 	default n
+	select HAVE_CLK
 
 config PPC_LIB_RHEAP
 	bool
--- a/arch/sh/Kconfig	2008-05-29 11:42:32.000000000 -0700
+++ b/arch/sh/Kconfig	2008-05-29 11:42:42.000000000 -0700
@@ -8,6 +8,7 @@ mainmenu "Linux/SuperH Kernel Configurat
 config SUPERH
 	def_bool y
 	select EMBEDDED
+	select HAVE_CLK
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	help
