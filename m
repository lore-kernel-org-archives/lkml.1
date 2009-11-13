Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbZKMPds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbZKMPds (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 10:33:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986AbZKMPdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 10:33:43 -0500
Received: from mail.atmel.fr ([81.80.104.162]:42533 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751912AbZKMPdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 10:33:42 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: haavard.skinnemoen@atmel.com, linux-arm-kernel@lists.infradead.org,
       avictor.za@gmail.com
Cc: linux-kernel@vger.kernel.org, kernel@avr32linux.org,
       linux@arm.linux.org.uk, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v2] atmel_lcdfb Kconfig: remove long dependency line
Date: Fri, 13 Nov 2009 17:39:58 +0100
Message-Id: <1258130398-13737-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <29424085870c8c8cc3fe9d6e1f382a24f8a9ca2b.1257263893.git.nicolas.ferre@atmel.com>
References: <29424085870c8c8cc3fe9d6e1f382a24f8a9ca2b.1257263893.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many Atmel SOC are embedding a LCD controller. This patch removes the long
dependency line for this Atmel LCD framebuffer driver configuration entry.
The HAVE_FB_ATMEL configuration option is located in the video Kconfig file
as it may be setup by ARM/AT91 and AVR32 chips.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/Kconfig |    6 ++++++
 arch/avr32/Kconfig         |    1 +
 drivers/video/Kconfig      |    5 ++++-
 3 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index bb4cd27..3df124e 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -41,18 +41,21 @@ config ARCH_AT91SAM9261
 	select CPU_ARM926T
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
+	select HAVE_FB_ATMEL
 
 config ARCH_AT91SAM9G10
 	bool "AT91SAM9G10"
 	select CPU_ARM926T
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
+	select HAVE_FB_ATMEL
 
 config ARCH_AT91SAM9263
 	bool "AT91SAM9263"
 	select CPU_ARM926T
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
+	select HAVE_FB_ATMEL
 
 config ARCH_AT91SAM9RL
 	bool "AT91SAM9RL"
@@ -60,6 +63,7 @@ config ARCH_AT91SAM9RL
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_AT91_USART3
+	select HAVE_FB_ATMEL
 
 config ARCH_AT91SAM9G20
 	bool "AT91SAM9G20"
@@ -76,12 +80,14 @@ config ARCH_AT91SAM9G45
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select HAVE_AT91_USART3
+	select HAVE_FB_ATMEL
 
 config ARCH_AT91CAP9
 	bool "AT91CAP9"
 	select CPU_ARM926T
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
+	select HAVE_FB_ATMEL
 
 config ARCH_AT91X40
 	bool "AT91x40"
diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index 35e3bd9..d856354 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -92,6 +92,7 @@ config PLATFORM_AT32AP
 	select PERFORMANCE_COUNTERS
 	select ARCH_REQUIRE_GPIOLIB
 	select GENERIC_ALLOCATOR
+	select HAVE_FB_ATMEL
 
 #
 # CPU types
diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 9bbb285..6d3f291 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -5,6 +5,9 @@
 menu "Graphics support"
 	depends on HAS_IOMEM
 
+config HAVE_FB_ATMEL
+	bool
+
 source "drivers/char/agp/Kconfig"
 
 source "drivers/gpu/vga/Kconfig"
@@ -937,7 +940,7 @@ config FB_S1D13XXX
 
 config FB_ATMEL
 	tristate "AT91/AT32 LCD Controller support"
-	depends on FB && (ARCH_AT91SAM9261 || ARCH_AT91SAM9G10 || ARCH_AT91SAM9263 || ARCH_AT91SAM9RL || ARCH_AT91SAM9G45 || ARCH_AT91CAP9 || AVR32)
+	depends on FB && HAVE_FB_ATMEL
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
-- 
1.5.6.5

