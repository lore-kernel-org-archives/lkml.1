Return-Path: <linux-kernel-owner+w=401wt.eu-S1764902AbYBAHdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764902AbYBAHdc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 02:33:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759410AbYBAHdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 02:33:08 -0500
Received: from rex.snapgear.com ([203.143.235.140]:47300 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758712AbYBAHdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 02:33:07 -0500
Date: Fri, 1 Feb 2008 17:32:00 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200802010732.m117W0Yj022553@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: configure support for new ColdFire serial driver
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add configure support for new ColdFire serial driver.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

--- linux-2.6.24/drivers/serial/Kconfig	2008-01-25 08:58:37.000000000 +1000
+++ linux-2.6.24.1/drivers/serial/Kconfig	2008-01-30 21:34:11.000000000 +1000
@@ -960,6 +960,30 @@
 	  This driver supports the built-in serial ports of the Motorola ColdFire
 	  family of CPUs.
 
+config SERIAL_MCF
+	bool "Coldfire serial support (new style driver)"
+	depends on COLDFIRE
+	select SERIAL_CORE
+	help
+	  This new serial driver supports the Freescale Coldfire serial ports
+	  using the new serial driver subsystem.
+
+config SERIAL_MCF_BAUDRATE
+	int "Default baudrate for Coldfire serial ports"
+	depends on SERIAL_MCF
+	default 19200
+	help
+	  This setting lets you define what the default baudrate is for the
+	  ColdFire serial ports. The usual default varies from board to board,
+	  and this setting is a way of catering for that.
+
+config SERIAL_MCF_CONSOLE
+	bool "Coldfire serial console support"
+	depends on SERIAL_MCF
+	select SERIAL_CORE_CONSOLE
+	help
+	  Enable a ColdFire internal serial port to be the system console.
+
 config SERIAL_68360_SMC
 	bool "68360 SMC uart support"
 	depends on M68360
