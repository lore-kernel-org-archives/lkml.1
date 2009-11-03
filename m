Return-Path: <linux-kernel-owner+w=401wt.eu-S1752941AbZKCPZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbZKCPZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 10:25:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbZKCPZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 10:25:35 -0500
Received: from mail.atmel.fr ([81.80.104.162]:60292 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751475AbZKCPZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 10:25:32 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: haavard.skinnemoen@atmel.com, linux-arm-kernel@lists.infradead.org,
       avictor.za@gmail.com
Cc: linux-kernel@vger.kernel.org, kernel@avr32linux.org,
       Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: [PATCH 2/3] at91: Kconfig simplification
Date: Tue,  3 Nov 2009 17:30:55 +0100
Message-Id: <0298b92002245b119cdc8fff62f073f4862712f4.1257263893.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1256049173-17373-1-git-send-email-nicolas.ferre@atmel.com>
References: <1256049173-17373-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <08f444c605fb38ee8b82821f28746b21ed06d9f7.1257263893.git.nicolas.ferre@atmel.com>
References: <08f444c605fb38ee8b82821f28746b21ed06d9f7.1257263893.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Instead of adding "depends on" at config level, introduce HAVE_* config
variables. Add them at machine or soc level to specify the ability of a
particular support.
It will ease new board introduction and readability.

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/Kconfig |   53 +++++++++++++++++++++++++++++++++++++++----
 1 files changed, 48 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 4301c6b..bb4cd27 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -1,5 +1,20 @@
 if ARCH_AT91
 
+config HAVE_AT91_DATAFLASH_CARD
+	bool
+
+config HAVE_NAND_ATMEL_BUSWIDTH_16
+	bool
+
+config HAVE_AT91_USART3
+	bool
+
+config HAVE_AT91_USART4
+	bool
+
+config HAVE_AT91_USART5
+	bool
+
 menu "Atmel AT91 System-on-Chip"
 
 choice
@@ -10,12 +25,16 @@ config ARCH_AT91RM9200
 	select CPU_ARM920T
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
+	select HAVE_AT91_USART3
 
 config ARCH_AT91SAM9260
 	bool "AT91SAM9260 or AT91SAM9XE"
 	select CPU_ARM926T
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
+	select HAVE_AT91_USART3
+	select HAVE_AT91_USART4
+	select HAVE_AT91_USART5
 
 config ARCH_AT91SAM9261
 	bool "AT91SAM9261"
@@ -40,18 +59,23 @@ config ARCH_AT91SAM9RL
 	select CPU_ARM926T
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
+	select HAVE_AT91_USART3
 
 config ARCH_AT91SAM9G20
 	bool "AT91SAM9G20"
 	select CPU_ARM926T
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
+	select HAVE_AT91_USART3
+	select HAVE_AT91_USART4
+	select HAVE_AT91_USART5
 
 config ARCH_AT91SAM9G45
 	bool "AT91SAM9G45"
 	select CPU_ARM926T
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
+	select HAVE_AT91_USART3
 
 config ARCH_AT91CAP9
 	bool "AT91CAP9"
@@ -82,12 +106,14 @@ config MACH_ONEARM
 
 config ARCH_AT91RM9200DK
 	bool "Atmel AT91RM9200-DK Development board"
+	select HAVE_AT91_DATAFLASH_CARD
 	help
 	  Select this if you are using Atmel's AT91RM9200-DK Development board.
 	  (Discontinued)
 
 config MACH_AT91RM9200EK
 	bool "Atmel AT91RM9200-EK Evaluation Kit"
+	select HAVE_AT91_DATAFLASH_CARD
 	help
 	  Select this if you are using Atmel's AT91RM9200-EK Evaluation Kit.
 	  <http://www.atmel.com/dyn/products/tools_card.asp?tool_id=3507>
@@ -135,6 +161,7 @@ config MACH_KAFA
 
 config MACH_ECBAT91
 	bool "emQbit ECB_AT91 SBC"
+	select HAVE_AT91_DATAFLASH_CARD
 	help
 	  Select this if you are using emQbit's ECB_AT91 board.
 	  <http://wiki.emqbit.com/free-ecb-at91>
@@ -168,6 +195,8 @@ comment "AT91SAM9260 / AT91SAM9XE Board Type"
 
 config MACH_AT91SAM9260EK
 	bool "Atmel AT91SAM9260-EK / AT91SAM9XE Evaluation Kit"
+	select HAVE_AT91_DATAFLASH_CARD
+	select HAVE_NAND_ATMEL_BUSWIDTH_16
 	help
 	  Select this if you are using Atmel's AT91SAM9260-EK or AT91SAM9XE Evaluation Kit
 	  <http://www.atmel.com/dyn/products/tools_card.asp?tool_id=3933>
@@ -180,6 +209,7 @@ config MACH_CAM60
 
 config MACH_SAM9_L9260
 	bool "Olimex SAM9-L9260 board"
+	select HAVE_AT91_DATAFLASH_CARD
 	help
 	  Select this if you are using Olimex's SAM9-L9260 board based on the Atmel AT91SAM9260.
 	  <http://www.olimex.com/dev/sam9-L9260.html>
@@ -220,6 +250,8 @@ comment "AT91SAM9261 Board Type"
 
 config MACH_AT91SAM9261EK
 	bool "Atmel AT91SAM9261-EK Evaluation Kit"
+	select HAVE_AT91_DATAFLASH_CARD
+	select HAVE_NAND_ATMEL_BUSWIDTH_16
 	help
 	  Select this if you are using Atmel's AT91SAM9261-EK Evaluation Kit.
 	  <http://www.atmel.com/dyn/products/tools_card.asp?tool_id=3820>
@@ -234,6 +266,8 @@ comment "AT91SAM9G10 Board Type"
 
 config MACH_AT91SAM9G10EK
 	bool "Atmel AT91SAM9G10-EK Evaluation Kit"
+	select HAVE_AT91_DATAFLASH_CARD
+	select HAVE_NAND_ATMEL_BUSWIDTH_16
 	help
 	  Select this if you are using Atmel's AT91SAM9G10-EK Evaluation Kit.
 	  <http://www.atmel.com/dyn/products/tools_card.asp?tool_id=4588>
@@ -248,6 +282,8 @@ comment "AT91SAM9263 Board Type"
 
 config MACH_AT91SAM9263EK
 	bool "Atmel AT91SAM9263-EK Evaluation Kit"
+	select HAVE_AT91_DATAFLASH_CARD
+	select HAVE_NAND_ATMEL_BUSWIDTH_16
 	help
 	  Select this if you are using Atmel's AT91SAM9263-EK Evaluation Kit.
 	  <http://www.atmel.com/dyn/products/tools_card.asp?tool_id=4057>
@@ -260,6 +296,7 @@ config MACH_USB_A9263
 
 config MACH_NEOCORE926
 	bool "Adeneo NEOCORE926"
+	select HAVE_AT91_DATAFLASH_CARD
 	help
 	  Select this if you are using the Adeneo Neocore 926 board.
 
@@ -286,12 +323,15 @@ comment "AT91SAM9G20 Board Type"
 
 config MACH_AT91SAM9G20EK
 	bool "Atmel AT91SAM9G20-EK Evaluation Kit"
+	select HAVE_AT91_DATAFLASH_CARD
+	select HAVE_NAND_ATMEL_BUSWIDTH_16
 	help
 	  Select this if you are using Atmel's AT91SAM9G20-EK Evaluation Kit
 	  that embeds only one SD/MMC slot.
 
 config MACH_AT91SAM9G20EK_2MMC
 	bool "Atmel AT91SAM9G20-EK Evaluation Kit with 2 SD/MMC Slots"
+	select HAVE_NAND_ATMEL_BUSWIDTH_16
 	help
 	  Select this if you are using an Atmel AT91SAM9G20-EK Evaluation Kit
 	  with 2 SD/MMC Slots. This is the case for AT91SAM9G20-EK rev. C and
@@ -313,6 +353,7 @@ comment "AT91SAM9G45 Board Type"
 
 config MACH_AT91SAM9G45EKES
 	bool "Atmel AT91SAM9G45-EKES Evaluation Kit"
+	select HAVE_NAND_ATMEL_BUSWIDTH_16
 	help
 	  Select this if you are using Atmel's AT91SAM9G45-EKES Evaluation Kit.
 	  "ES" at the end of the name means that this board is an
@@ -328,6 +369,8 @@ comment "AT91CAP9 Board Type"
 
 config MACH_AT91CAP9ADK
 	bool "Atmel AT91CAP9A-DK Evaluation Kit"
+	select HAVE_AT91_DATAFLASH_CARD
+	select HAVE_NAND_ATMEL_BUSWIDTH_16
 	help
 	  Select this if you are using Atmel's AT91CAP9A-DK Evaluation Kit.
 	  <http://www.atmel.com/dyn/products/tools_card.asp?tool_id=4138>
@@ -356,13 +399,13 @@ comment "AT91 Board Options"
 
 config MTD_AT91_DATAFLASH_CARD
 	bool "Enable DataFlash Card support"
-	depends on (ARCH_AT91RM9200DK || MACH_AT91RM9200EK || MACH_AT91SAM9260EK || MACH_AT91SAM9261EK || MACH_AT91SAM9G10EK || MACH_AT91SAM9263EK || MACH_AT91SAM9G20EK || MACH_ECBAT91 || MACH_SAM9_L9260 || MACH_AT91CAP9ADK || MACH_NEOCORE926)
+	depends on HAVE_AT91_DATAFLASH_CARD
 	help
 	  Enable support for the DataFlash card.
 
 config MTD_NAND_ATMEL_BUSWIDTH_16
 	bool "Enable 16-bit data bus interface to NAND flash"
-	depends on (MACH_AT91SAM9260EK || MACH_AT91SAM9261EK || MACH_AT91SAM9G10EK || MACH_AT91SAM9263EK || MACH_AT91SAM9G20EK || MACH_AT91SAM9G20EK_2MMC || MACH_AT91SAM9G45EKES || MACH_AT91CAP9ADK)
+	depends on HAVE_NAND_ATMEL_BUSWIDTH_16
 	help
 	  On AT91SAM926x boards both types of NAND flash can be present
 	  (8 and 16 bit data bus width).
@@ -424,15 +467,15 @@ config AT91_EARLY_USART2
 
 config AT91_EARLY_USART3
 	bool "USART3"
-	depends on (ARCH_AT91RM9200 || ARCH_AT91SAM9RL || ARCH_AT91SAM9260 || ARCH_AT91SAM9G20 || ARCH_AT91SAM9G45)
+	depends on HAVE_AT91_USART3
 
 config AT91_EARLY_USART4
 	bool "USART4"
-	depends on ARCH_AT91SAM9260 || ARCH_AT91SAM9G20
+	depends on HAVE_AT91_USART4
 
 config AT91_EARLY_USART5
 	bool "USART5"
-	depends on ARCH_AT91SAM9260 || ARCH_AT91SAM9G20
+	depends on HAVE_AT91_USART5
 
 endchoice
 
-- 
1.5.6.5

