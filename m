Return-Path: <linux-kernel-owner+w=401wt.eu-S1764172AbXHANXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764172AbXHANXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 09:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762099AbXHANW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 09:22:56 -0400
Received: from www.osadl.org ([213.239.205.134]:52039 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761683AbXHANWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 09:22:55 -0400
Subject: [PATCH] AT91: include atmel_lcdc.h in at91sam926{1,3}_devices.c
From: Jan Altenberg <jan.altenberg@linutronix.de>
To: Andrew Victor <andrew@sanpeople.com>,
       linux-fbdev-devel@lists.sourceforge.net
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Jan Altenberg <jan.altenberg@linutronix.de>,
       Patrice Vilchez <patrice.vilchez@rfo.atmel.com>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 01 Aug 2007 15:22:52 +0200
Message-Id: <1185974572.3854.52.camel@bender.lan>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

current git doesn't compile for CONFIG_ARCH_AT91SAM926{1,3} and
and CONFIG_FB_ATMEL enabled, due to a missing inclusion of atmel_lcdc.h:

/home/jan/kernel/git/linux-2.6/arch/arm/mach-at91/at91sam9263_devices.c: In function ‘at91_add_device_lcdc’:
/home/jan/kernel/git/linux-2.6/arch/arm/mach-at91/at91sam9263_devices.c:688: error: dereferencing pointer to incomplete type
/home/jan/kernel/git/linux-2.6/arch/arm/mach-at91/at91sam9263_devices.c:688: error: ‘lcdc_data’ has an incomplete type

This error should also have occured in the past, because atmel_lcdc.h
has never been included.

Signed-off-by: Jan Altenberg <jan.altenberg@linutronix.de>

---
 arch/arm/mach-at91/at91sam9261_devices.c |    2 ++
 arch/arm/mach-at91/at91sam9263_devices.c |    2 ++
 2 files changed, 4 insertions(+)

Index: linux-2.6/arch/arm/mach-at91/at91sam9261_devices.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-at91/at91sam9261_devices.c
+++ linux-2.6/arch/arm/mach-at91/at91sam9261_devices.c
@@ -15,6 +15,8 @@
 
 #include <linux/platform_device.h>
 
+#include <video/atmel_lcdc.h>
+
 #include <asm/arch/board.h>
 #include <asm/arch/gpio.h>
 #include <asm/arch/at91sam9261.h>
Index: linux-2.6/arch/arm/mach-at91/at91sam9263_devices.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-at91/at91sam9263_devices.c
+++ linux-2.6/arch/arm/mach-at91/at91sam9263_devices.c
@@ -14,6 +14,8 @@
 
 #include <linux/platform_device.h>
 
+#include <video/atmel_lcdc.h>
+
 #include <asm/arch/board.h>
 #include <asm/arch/gpio.h>
 #include <asm/arch/at91sam9263.h>


