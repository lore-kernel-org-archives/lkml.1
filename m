Return-Path: <linux-kernel-owner+w=401wt.eu-S1762449AbZDAIys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762449AbZDAIys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 04:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762283AbZDAIyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 04:54:17 -0400
Received: from relay.atmel.no ([80.232.32.139]:57009 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761165AbZDAIyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 04:54:14 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Andrew Victor <linux@maxim.org.za>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Peter Ma <pma@mediamatech.com>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH 1/2] avr32: add RTS/CTS/CLK pin selection for the USARTs
Date: Wed,  1 Apr 2009 10:53:57 +0200
Message-Id: <1238576038-8915-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Ma <pma@mediamatech.com>

Adds extra parameter to AT32 at32_map_usart(), so as to reserve
RTS/CTS/CLK pins.

All boards under arch/avr32/boards have been updated (trivial change), but
not all have been tested.

Signed-off-by: Peter Ma <pma@mediamatech.com>
Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
This first patch is mostly FYI, as I intend to merge this through the
avr32 tree, but I figured it might help you to do something similar to
enable hardware handshaking on AT91.

I can take the second patch through the avr32 tree as well if someone
ACKs it.

 arch/avr32/boards/atngw100/setup.c          |    2 +-
 arch/avr32/boards/atstk1000/atstk1002.c     |    6 ++--
 arch/avr32/boards/atstk1000/atstk1003.c     |    6 ++--
 arch/avr32/boards/atstk1000/atstk1004.c     |    6 ++--
 arch/avr32/boards/favr-32/setup.c           |    2 +-
 arch/avr32/boards/hammerhead/setup.c        |    2 +-
 arch/avr32/boards/mimc200/setup.c           |    8 +++---
 arch/avr32/mach-at32ap/at32ap700x.c         |   30 ++++++++++++++++++--------
 arch/avr32/mach-at32ap/include/mach/board.h |    7 +++++-
 9 files changed, 43 insertions(+), 26 deletions(-)

diff --git a/arch/avr32/boards/atngw100/setup.c b/arch/avr32/boards/atngw100/setup.c
index feac003..5b022aa 100644
--- a/arch/avr32/boards/atngw100/setup.c
+++ b/arch/avr32/boards/atngw100/setup.c
@@ -118,7 +118,7 @@ static void __init set_hw_addr(struct platform_device *pdev)
 
 void __init setup_board(void)
 {
-	at32_map_usart(1, 0);	/* USART 1: /dev/ttyS0, DB9 */
+	at32_map_usart(1, 0, 0);	/* USART 1: /dev/ttyS0, DB9 */
 	at32_setup_serial_console(0);
 }
 
diff --git a/arch/avr32/boards/atstk1000/atstk1002.c b/arch/avr32/boards/atstk1000/atstk1002.c
index 1f33a10..2adc261 100644
--- a/arch/avr32/boards/atstk1000/atstk1002.c
+++ b/arch/avr32/boards/atstk1000/atstk1002.c
@@ -252,12 +252,12 @@ static void __init atstk1002_setup_extdac(void)
 void __init setup_board(void)
 {
 #ifdef	CONFIG_BOARD_ATSTK100X_SW2_CUSTOM
-	at32_map_usart(0, 1);	/* USART 0/B: /dev/ttyS1, IRDA */
+	at32_map_usart(0, 1, 0);	/* USART 0/B: /dev/ttyS1, IRDA */
 #else
-	at32_map_usart(1, 0);	/* USART 1/A: /dev/ttyS0, DB9 */
+	at32_map_usart(1, 0, 0);	/* USART 1/A: /dev/ttyS0, DB9 */
 #endif
 	/* USART 2/unused: expansion connector */
-	at32_map_usart(3, 2);	/* USART 3/C: /dev/ttyS2, DB9 */
+	at32_map_usart(3, 2, 0);	/* USART 3/C: /dev/ttyS2, DB9 */
 
 	at32_setup_serial_console(0);
 }
diff --git a/arch/avr32/boards/atstk1000/atstk1003.c b/arch/avr32/boards/atstk1000/atstk1003.c
index b3a23c8..ff7e232 100644
--- a/arch/avr32/boards/atstk1000/atstk1003.c
+++ b/arch/avr32/boards/atstk1000/atstk1003.c
@@ -115,12 +115,12 @@ static void __init atstk1003_setup_extdac(void)
 void __init setup_board(void)
 {
 #ifdef	CONFIG_BOARD_ATSTK100X_SW2_CUSTOM
-	at32_map_usart(0, 1);	/* USART 0/B: /dev/ttyS1, IRDA */
+	at32_map_usart(0, 1, 0);	/* USART 0/B: /dev/ttyS1, IRDA */
 #else
-	at32_map_usart(1, 0);	/* USART 1/A: /dev/ttyS0, DB9 */
+	at32_map_usart(1, 0, 0);	/* USART 1/A: /dev/ttyS0, DB9 */
 #endif
 	/* USART 2/unused: expansion connector */
-	at32_map_usart(3, 2);	/* USART 3/C: /dev/ttyS2, DB9 */
+	at32_map_usart(3, 2, 0);	/* USART 3/C: /dev/ttyS2, DB9 */
 
 	at32_setup_serial_console(0);
 }
diff --git a/arch/avr32/boards/atstk1000/atstk1004.c b/arch/avr32/boards/atstk1000/atstk1004.c
index 29b35ac..69a9f0f 100644
--- a/arch/avr32/boards/atstk1000/atstk1004.c
+++ b/arch/avr32/boards/atstk1000/atstk1004.c
@@ -120,12 +120,12 @@ static void __init atstk1004_setup_extdac(void)
 void __init setup_board(void)
 {
 #ifdef	CONFIG_BOARD_ATSTK100X_SW2_CUSTOM
-	at32_map_usart(0, 1);	/* USART 0/B: /dev/ttyS1, IRDA */
+	at32_map_usart(0, 1, 0);	/* USART 0/B: /dev/ttyS1, IRDA */
 #else
-	at32_map_usart(1, 0);	/* USART 1/A: /dev/ttyS0, DB9 */
+	at32_map_usart(1, 0, 0);	/* USART 1/A: /dev/ttyS0, DB9 */
 #endif
 	/* USART 2/unused: expansion connector */
-	at32_map_usart(3, 2);	/* USART 3/C: /dev/ttyS2, DB9 */
+	at32_map_usart(3, 2, 0);	/* USART 3/C: /dev/ttyS2, DB9 */
 
 	at32_setup_serial_console(0);
 }
diff --git a/arch/avr32/boards/favr-32/setup.c b/arch/avr32/boards/favr-32/setup.c
index cf6e4e5..46c9b0a 100644
--- a/arch/avr32/boards/favr-32/setup.c
+++ b/arch/avr32/boards/favr-32/setup.c
@@ -250,7 +250,7 @@ static void __init favr32_setup_atmel_pwm_bl(void)
 
 void __init setup_board(void)
 {
-	at32_map_usart(3, 0);	/* USART 3 => /dev/ttyS0 */
+	at32_map_usart(3, 0, 0);	/* USART 3 => /dev/ttyS0 */
 	at32_setup_serial_console(0);
 }
 
diff --git a/arch/avr32/boards/hammerhead/setup.c b/arch/avr32/boards/hammerhead/setup.c
index a5c2da2..dd00987 100644
--- a/arch/avr32/boards/hammerhead/setup.c
+++ b/arch/avr32/boards/hammerhead/setup.c
@@ -165,7 +165,7 @@ static void __init set_hw_addr(struct platform_device *pdev)
 
 void __init setup_board(void)
 {
-	at32_map_usart(1, 0);	/* USART 1: /dev/ttyS0, DB9 */
+	at32_map_usart(1, 0, 0);	/* USART 1: /dev/ttyS0, DB9 */
 	at32_setup_serial_console(0);
 }
 
diff --git a/arch/avr32/boards/mimc200/setup.c b/arch/avr32/boards/mimc200/setup.c
index 2b58d61..c1b2175 100644
--- a/arch/avr32/boards/mimc200/setup.c
+++ b/arch/avr32/boards/mimc200/setup.c
@@ -175,10 +175,10 @@ static void __init set_hw_addr(struct platform_device *pdev)
 
 void __init setup_board(void)
 {
-	at32_map_usart(0, 0);	/* USART 0: /dev/ttyS0 (TTL --> Altera) */
-	at32_map_usart(1, 1);	/* USART 1: /dev/ttyS1 (RS232) */
-	at32_map_usart(2, 2);	/* USART 2: /dev/ttyS2 (RS485) */
-	at32_map_usart(3, 3);	/* USART 3: /dev/ttyS3 (RS422 Multidrop) */
+	at32_map_usart(0, 0, 0);	/* USART 0: /dev/ttyS0 (TTL --> Altera) */
+	at32_map_usart(1, 1, 0);	/* USART 1: /dev/ttyS1 (RS232) */
+	at32_map_usart(2, 2, 0);	/* USART 2: /dev/ttyS2 (RS485) */
+	at32_map_usart(3, 3, 0);	/* USART 3: /dev/ttyS3 (RS422 Multidrop) */
 }
 
 static struct i2c_gpio_platform_data i2c_gpio_data = {
diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index 62501d6..7cc6537 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -966,56 +966,68 @@ static struct resource atmel_usart3_resource[] = {
 DEFINE_DEV_DATA(atmel_usart, 3);
 DEV_CLK(usart, atmel_usart3, pba, 6);
 
-static inline void configure_usart0_pins(void)
+static inline void configure_usart0_pins(int flags)
 {
 	u32 pin_mask = (1 << 8) | (1 << 9); /* RXD & TXD */
+	if (flags & ATMEL_USART_RTS)	pin_mask |= (1 << 6);
+	if (flags & ATMEL_USART_CTS)	pin_mask |= (1 << 7);
+	if (flags & ATMEL_USART_CLK)	pin_mask |= (1 << 10);
 
 	select_peripheral(PIOA, pin_mask, PERIPH_B, AT32_GPIOF_PULLUP);
 }
 
-static inline void configure_usart1_pins(void)
+static inline void configure_usart1_pins(int flags)
 {
 	u32 pin_mask = (1 << 17) | (1 << 18); /* RXD & TXD */
+	if (flags & ATMEL_USART_RTS)	pin_mask |= (1 << 19);
+	if (flags & ATMEL_USART_CTS)	pin_mask |= (1 << 20);
+	if (flags & ATMEL_USART_CLK)	pin_mask |= (1 << 16);
 
 	select_peripheral(PIOA, pin_mask, PERIPH_A, AT32_GPIOF_PULLUP);
 }
 
-static inline void configure_usart2_pins(void)
+static inline void configure_usart2_pins(int flags)
 {
 	u32 pin_mask = (1 << 26) | (1 << 27); /* RXD & TXD */
+	if (flags & ATMEL_USART_RTS)	pin_mask |= (1 << 30);
+	if (flags & ATMEL_USART_CTS)	pin_mask |= (1 << 29);
+	if (flags & ATMEL_USART_CLK)	pin_mask |= (1 << 28);
 
 	select_peripheral(PIOB, pin_mask, PERIPH_B, AT32_GPIOF_PULLUP);
 }
 
-static inline void configure_usart3_pins(void)
+static inline void configure_usart3_pins(int flags)
 {
 	u32 pin_mask = (1 << 18) | (1 << 17); /* RXD & TXD */
+	if (flags & ATMEL_USART_RTS)	pin_mask |= (1 << 16);
+	if (flags & ATMEL_USART_CTS)	pin_mask |= (1 << 15);
+	if (flags & ATMEL_USART_CLK)	pin_mask |= (1 << 19);
 
 	select_peripheral(PIOB, pin_mask, PERIPH_B, AT32_GPIOF_PULLUP);
 }
 
 static struct platform_device *__initdata at32_usarts[4];
 
-void __init at32_map_usart(unsigned int hw_id, unsigned int line)
+void __init at32_map_usart(unsigned int hw_id, unsigned int line, int flags)
 {
 	struct platform_device *pdev;
 
 	switch (hw_id) {
 	case 0:
 		pdev = &atmel_usart0_device;
-		configure_usart0_pins();
+		configure_usart0_pins(flags);
 		break;
 	case 1:
 		pdev = &atmel_usart1_device;
-		configure_usart1_pins();
+		configure_usart1_pins(flags);
 		break;
 	case 2:
 		pdev = &atmel_usart2_device;
-		configure_usart2_pins();
+		configure_usart2_pins(flags);
 		break;
 	case 3:
 		pdev = &atmel_usart3_device;
-		configure_usart3_pins();
+		configure_usart3_pins(flags);
 		break;
 	default:
 		return;
diff --git a/arch/avr32/mach-at32ap/include/mach/board.h b/arch/avr32/mach-at32ap/include/mach/board.h
index b363b06..0b81642 100644
--- a/arch/avr32/mach-at32ap/include/mach/board.h
+++ b/arch/avr32/mach-at32ap/include/mach/board.h
@@ -26,12 +26,17 @@ static inline void __deprecated at32_add_system_devices(void)
 #define ATMEL_MAX_UART	4
 extern struct platform_device *atmel_default_console_device;
 
+/* Flags for selecting USART extra pins */
+#define	ATMEL_USART_RTS		0x01
+#define	ATMEL_USART_CTS		0x02
+#define	ATMEL_USART_CLK		0x03
+
 struct atmel_uart_data {
 	short		use_dma_tx;	/* use transmit DMA? */
 	short		use_dma_rx;	/* use receive DMA? */
 	void __iomem	*regs;		/* virtual base address, if any */
 };
-void at32_map_usart(unsigned int hw_id, unsigned int line);
+void at32_map_usart(unsigned int hw_id, unsigned int line, int flags);
 struct platform_device *at32_add_device_usart(unsigned int id);
 
 struct eth_platform_data {
-- 
1.6.0.4

