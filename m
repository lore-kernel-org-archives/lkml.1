Return-Path: <linux-kernel-owner+w=401wt.eu-S1758131AbZFWN2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131AbZFWN2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 09:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753066AbZFWN2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 09:28:41 -0400
Received: from mail.atmel.fr ([81.80.104.162]:34313 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910AbZFWN2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 09:28:41 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: haavard.skinnemoen@atmel.com, linux-arm-kernel@lists.arm.linux.org.uk,
       plagnioj@jcrosoft.com
Cc: linux-kernel@vger.kernel.org, avictor.za@gmail.com,
       nicolas.ferre@atmel.com
Subject: [RFC PATCH] atmel_lcdfb Kconfig: remove long dependency line
Date: Tue, 23 Jun 2009 16:30:56 +0200
Message-Id: <1245767456-6434-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <4A40D695.5000302@atmel.com>
References: <4A40D695.5000302@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many Atmel SOC are embedding a LCD controller. This patch removes the long
dependency line for this Atmel LCD framebuffer driver configuration entry.
The ARCH_ATMEL_HAS_FB configuration option is located in the video Kconfig file
as it may be setup by ARM/AT91 and AVR32 chips.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Beware, this proposition goes on top of at91sam9g45 & at91sam9g10 patchsets
already posted. My proposition is to wait for those series are queued before
applying this modification.

 arch/arm/mach-at91/Kconfig |    6 ++++++
 arch/avr32/Kconfig         |    1 +
 drivers/video/Kconfig      |    7 ++++++-
 3 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 8f3e15a..00c7e08 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -22,24 +22,28 @@ config ARCH_AT91SAM9261
 	select CPU_ARM926T
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
+	select ARCH_ATMEL_HAS_FB
 
 config ARCH_AT91SAM9G10
 	bool "AT91SAM9G10"
 	select CPU_ARM926T
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
+	select ARCH_ATMEL_HAS_FB
 
 config ARCH_AT91SAM9263
 	bool "AT91SAM9263"
 	select CPU_ARM926T
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
+	select ARCH_ATMEL_HAS_FB
 
 config ARCH_AT91SAM9RL
 	bool "AT91SAM9RL"
 	select CPU_ARM926T
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
+	select ARCH_ATMEL_HAS_FB
 
 config ARCH_AT91SAM9G20
 	bool "AT91SAM9G20"
@@ -52,12 +56,14 @@ config ARCH_AT91SAM9G45
 	select CPU_ARM926T
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
+	select ARCH_ATMEL_HAS_FB
 
 config ARCH_AT91CAP9
 	bool "AT91CAP9"
 	select CPU_ARM926T
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
+	select ARCH_ATMEL_HAS_FB
 
 config ARCH_AT91X40
 	bool "AT91x40"
diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index 35e3bd9..43d4946 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -92,6 +92,7 @@ config PLATFORM_AT32AP
 	select PERFORMANCE_COUNTERS
 	select ARCH_REQUIRE_GPIOLIB
 	select GENERIC_ALLOCATOR
+	select ARCH_ATMEL_HAS_FB
 
 #
 # CPU types
diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 2dbede4..a2cdf88 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -931,9 +931,14 @@ config FB_S1D13XXX
 	  working with S1D13806). Product specs at
 	  <http://www.erd.epson.com/vdc/html/legacy_13xxx.htm>
 
+config ARCH_ATMEL_HAS_FB
+	bool
+	depends on FB
+	default n
+
 config FB_ATMEL
 	tristate "AT91/AT32 LCD Controller support"
-	depends on FB && (ARCH_AT91SAM9261 || ARCH_AT91SAM9G10 || ARCH_AT91SAM9263 || ARCH_AT91SAM9RL || ARCH_AT91SAM9G45 || ARCH_AT91CAP9 || AVR32)
+	depends on FB && ARCH_ATMEL_HAS_FB
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
-- 
1.5.3.7

