Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768Ab0BYOf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 09:35:59 -0500
Received: from mx2.zhaw.ch ([160.85.104.51]:34354 "EHLO mx2.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932718Ab0BYOft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 09:35:49 -0500
From: Tobias Klauser <tklauser@distanz.ch>
To: linux-serial@vger.kernel.org
Cc: nios2-dev@sopc.et.ntust.edu.tw, linux-kernel@vger.kernel.org,
       Tobias Klauser <tklauser@distanz.ch>
Subject: [PATCH 2/2] serial: Add driver for the Altera UART
Date: Thu, 25 Feb 2010 15:35:23 +0100
Message-Id: <1267108523-32767-2-git-send-email-tklauser@distanz.ch>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267108523-32767-1-git-send-email-tklauser@distanz.ch>
References: <1267108523-32767-1-git-send-email-tklauser@distanz.ch>
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.2.25.142728
X-PerlMx-Spam: Gauge=X, Probability=10%, Report='
 TO_IN_SUBJECT 0.5, BODY_SIZE_2000_2999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, TO_NO_NAME 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NS '
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an UART driver for the UART component available as a SOPC (System on
Programmable Chip) component for Altera FPGAs.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 drivers/serial/Kconfig      |   32 ++++++++++++++++++++++++++++++++
 drivers/serial/Makefile     |    1 +
 include/linux/serial_core.h |    1 +
 3 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 34f58d0..546bd6f 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -1512,4 +1512,36 @@ config SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS
 	  Bypass console output and keep going even if there is no
 	  JTAG terminal connection with the host.
 
+config SERIAL_ALTERA_UART
+	bool "Altera UART support"
+	depends on EMBEDDED
+	select SERIAL_CORE
+	help
+	  This driver supports the Altera softcore UART port.
+
+config SERIAL_ALTERA_UART_MAXPORTS
+	int "Maximum number of Altera UART ports"
+	depends on SERIAL_ALTERA_UART
+	default 4
+	help
+	  This setting lets you define the maximum number of the Altera
+	  UART ports. The usual default varies from board to board, and
+	  this setting is a way of catering for that.
+
+config SERIAL_ALTERA_UART_BAUDRATE
+	int "Default baudrate for Altera UART ports"
+	depends on SERIAL_ALTERA_UART
+	default 115200
+	help
+	  This setting lets you define what the default baudrate is for the
+	  Altera UART ports. The usual default varies from board to board,
+	  and this setting is a way of catering for that.
+
+config SERIAL_ALTERA_UART_CONSOLE
+	bool "Altera UART console support"
+	depends on SERIAL_ALTERA_UART
+	select SERIAL_CORE_CONSOLE
+	help
+	  Enable a Altera UART port to be the system console.
+
 endmenu
diff --git a/drivers/serial/Makefile b/drivers/serial/Makefile
index 6228b6e..39007e6 100644
--- a/drivers/serial/Makefile
+++ b/drivers/serial/Makefile
@@ -83,3 +83,4 @@ obj-$(CONFIG_SERIAL_QE) += ucc_uart.o
 obj-$(CONFIG_SERIAL_TIMBERDALE)	+= timbuart.o
 obj-$(CONFIG_SERIAL_GRLIB_GAISLER_APBUART) += apbuart.o
 obj-$(CONFIG_SERIAL_ALTERA_JTAGUART) += altera_jtaguart.o
+obj-$(CONFIG_SERIAL_ALTERA_UART) += altera_uart.o
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 28aa7c9..9206120 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -184,6 +184,7 @@
 
 /* Altera UARTs */
 #define PORT_ALTERA_JTAGUART	91
+#define PORT_ALTERA_UART	92
 
 #ifdef __KERNEL__
 
-- 
1.6.3.3

