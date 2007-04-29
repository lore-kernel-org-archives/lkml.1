Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbXD2DXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbXD2DXp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 23:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754317AbXD2DXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 23:23:12 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:34270 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbXD2DWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 23:22:33 -0400
X-IronPort-AV: i="4.14,465,1170651600"; 
   d="scan'208"; a="36822435:sNHT23804977"
From: Bryan Wu <bryan.wu@analog.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 6/7] blackfin serial core driver: UART1 should depend on BF534/BF536/BF537, remove experimental marking from on-chip serial core driver and make options less wordy.
Date: Sun, 29 Apr 2007 11:23:12 +0800
Message-Id: <1177816996104-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11778169933996-git-send-email-bryan.wu@analog.com>
References: <11778169933996-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/serial/Kconfig |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 3484834..e8efe93 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -513,8 +513,8 @@ config SERIAL_SA1100_CONSOLE
 	  kernel at boot time.)
 
 config SERIAL_BFIN
-	tristate "Blackfin serial port support (EXPERIMENTAL)"
-	depends on BFIN && EXPERIMENTAL
+	tristate "Blackfin serial port support"
+	depends on BFIN
 	select SERIAL_CORE
 	select SERIAL_BFIN_UART0 if (BF531 || BF532 || BF533 || BF561)
 	help
@@ -529,7 +529,7 @@ config SERIAL_BFIN_CONSOLE
 	select SERIAL_CORE_CONSOLE
 
 choice
-	prompt  "Blackfin UART Mode"
+	prompt "UART Mode"
 	depends on SERIAL_BFIN
 	default SERIAL_BFIN_DMA
 	help
@@ -537,14 +537,14 @@ choice
 	  of CPUs
 
 config SERIAL_BFIN_DMA
-	bool "Blackfin UART DMA mode"
+	bool "DMA mode"
 	depends on DMA_UNCACHED_1M
 	help
 	  This driver works under DMA mode. If this option is selected, the
 	  blackfin simple dma driver is also enabled.
 
 config SERIAL_BFIN_PIO
-	bool "Blackfin UART PIO mode"
+	bool "PIO mode"
 	help
 	  This driver works under PIO mode.
 
@@ -581,7 +581,7 @@ config UART0_RTS_PIN
 
 config SERIAL_BFIN_UART1
 	bool "Enable UART1"
-	depends on SERIAL_BFIN && BF537
+	depends on SERIAL_BFIN && (BF534 || BF536 || BF537)
 	help
 	  Enable UART1
 
-- 
1.5.1.2
