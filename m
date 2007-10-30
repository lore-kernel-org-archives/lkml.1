Return-Path: <linux-kernel-owner+w=401wt.eu-S1754391AbXJ3EoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbXJ3EoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 00:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553AbXJ3Emm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 00:42:42 -0400
Received: from rex.snapgear.com ([203.143.235.140]:37131 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754385AbXJ3Emk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 00:42:40 -0400
Date: Tue, 30 Oct 2007 14:41:46 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200710300441.l9U4fk0E032224@goober>
To: torvalds@linux-foundation.org
Subject: [PATCH]: add configure support for new ColdFire serial driver
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add configure support for the new style ColdFire serial driver.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

diff -Naurp linux-2.6.23-rc1/drivers/serial/Kconfig linux-2.6.23-rc1.platform/drivers/serial/Kconfig
--- linux-2.6.23-rc1/drivers/serial/Kconfig	2007-10-25 10:49:13.000000000 +1000
+++ linux-2.6.23-rc1.platform/drivers/serial/Kconfig	2007-10-30 11:20:44.000000000 +1000
@@ -960,6 +960,30 @@ config SERIAL_COLDFIRE
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
