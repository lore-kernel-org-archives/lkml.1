Return-Path: <linux-kernel-owner+w=401wt.eu-S933482AbXC1Chj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933482AbXC1Chj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 22:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933535AbXC1Chj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 22:37:39 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:54469 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933482AbXC1Chi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 22:37:38 -0400
Date: Wed, 28 Mar 2007 03:37:24 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Bunk <bunk@stusta.de>, "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mips@linux-mips.org
Subject: [CHAR] Wire up DEC serial drivers in Kconfig
Message-ID: <20070328023724.GA31980@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

 drivers/char/Kconfig |   33 +++++++++++++++++++++++++++++++++

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 3429ece..d0c978f 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -386,6 +386,39 @@ config AU1000_SERIAL_CONSOLE
 	  If you have an Alchemy AU1000 processor (MIPS based) and you want
 	  to use a console on a serial port, say Y.  Otherwise, say N.
 
+config SERIAL_DEC
+	bool "DECstation serial support"
+	depends on MACH_DECSTATION
+	default y
+	help
+	  This selects whether you want to be asked about drivers for
+	  DECstation serial ports.
+
+	  Note that the answer to this question won't directly affect the
+	  kernel: saying N will just cause the configurator to skip all
+	  the questions about DECstation serial ports.
+
+config SERIAL_DEC_CONSOLE
+	bool "Support for console on a DECstation serial port"
+	depends on SERIAL_DEC
+	default y
+	help
+	  If you say Y here, it will be possible to use a serial port as the
+	  system console (the system console is the device which receives all
+	  kernel messages and warnings and which allows logins in single user
+	  mode).  Note that the firmware uses ttyS0 as the serial console on
+	  the Maxine and ttyS2 on the others.
+
+	  If unsure, say Y.
+
+config ZS
+	bool "Z85C30 Serial Support"
+	depends on SERIAL_DEC
+	default y
+	help
+	  Documentation on the Zilog 85C350 serial communications controller
+	  is downloadable at <http://www.zilog.com/pdfs/serial/z85c30.pdf>
+
 config A2232
 	tristate "Commodore A2232 serial support (EXPERIMENTAL)"
 	depends on EXPERIMENTAL && ZORRO && BROKEN_ON_SMP
