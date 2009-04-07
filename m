Return-Path: <linux-kernel-owner+w=401wt.eu-S1757300AbZDGOvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbZDGOvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 10:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757791AbZDGOuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 10:50:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34155 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757547AbZDGOuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 10:50:17 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 05/11] Add support for the MAX3100 SPI UART.
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Tue, 07 Apr 2009 16:48:51 +0100
Message-ID: <20090407154840.18020.82549.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090407154715.18020.44616.stgit@t61.ukuu.org.uk>
References: <20090407154715.18020.44616.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Pellegrin <chripell@gmail.com>

(akpm: queued pending confirmation of the new major number)

[randy.dunlap@oracle.com: select SERIAL_CORE]
Signed-off-by: Christian Pellegrin <chripell@fsfe.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 drivers/serial/Kconfig      |    7 +++++++
 drivers/serial/Makefile     |    1 +
 include/linux/serial_core.h |    3 +++
 3 files changed, 11 insertions(+), 0 deletions(-)


diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 07c03b9..d89972b 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -533,6 +533,13 @@ config SERIAL_S3C6400
 	  Serial port support for the Samsung S3C6400 and S3C6410
 	  SoCs
 
+config SERIAL_MAX3100
+	tristate "MAX3100 support"
+	depends on SPI
+	select SERIAL_CORE
+	help
+	  MAX3100 chip support
+
 config SERIAL_DZ
 	bool "DECstation DZ serial driver"
 	depends on MACH_DECSTATION && 32BIT
diff --git a/drivers/serial/Makefile b/drivers/serial/Makefile
index 8844c0a..d438eb2 100644
--- a/drivers/serial/Makefile
+++ b/drivers/serial/Makefile
@@ -43,6 +43,7 @@ obj-$(CONFIG_SERIAL_S3C2412) += s3c2412.o
 obj-$(CONFIG_SERIAL_S3C2440) += s3c2440.o
 obj-$(CONFIG_SERIAL_S3C24A0) += s3c24a0.o
 obj-$(CONFIG_SERIAL_S3C6400) += s3c6400.o
+obj-$(CONFIG_SERIAL_MAX3100) += max3100.o
 obj-$(CONFIG_SERIAL_IP22_ZILOG) += ip22zilog.o
 obj-$(CONFIG_SERIAL_MUX) += mux.o
 obj-$(CONFIG_SERIAL_68328) += 68328serial.o
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 83e4b3f..57a97e5 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -164,6 +164,9 @@
 /* NWPSERIAL */
 #define PORT_NWPSERIAL	85
 
+/* MAX3100 */
+#define PORT_MAX3100    86
+
 #ifdef __KERNEL__
 
 #include <linux/compiler.h>

