Return-Path: <linux-kernel-owner+w=401wt.eu-S936219AbXHHDhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936219AbXHHDhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 23:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935816AbXHHDgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 23:36:20 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:18048 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759468AbXHHDft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 23:35:49 -0400
X-IronPort-AV: i="4.19,233,1183348800"; 
   d="scan'208"; a="47739379:sNHT23735887"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Cc: dbrownell@users.sourceforge.net,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 12/12] Blackfin serial driver: use new GPIO API
Date: Wed,  8 Aug 2007 11:35:37 +0800
Message-Id: <11865441413182-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.2
In-Reply-To: <11865441373719-git-send-email-bryan.wu@analog.com>
References: <11865441373719-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 include/asm-blackfin/mach-bf548/bfin_serial_5xx.h |   39 ++++++++++-----------
 1 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h b/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
index 2f4afc9..f21a162 100644
--- a/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf548/bfin_serial_5xx.h
@@ -1,5 +1,6 @@
 #include <linux/serial.h>
 #include <asm/dma.h>
+#include <asm/portmux.h>
 
 #define NR_PORTS		4
 
@@ -143,50 +144,48 @@ struct bfin_serial_res bfin_serial_resource[] = {
 
 int nr_ports = ARRAY_SIZE(bfin_serial_resource);
 
+#define DRIVER_NAME "bfin-uart"
+
 static void bfin_serial_hw_init(struct bfin_serial_port *uart)
 {
 #ifdef CONFIG_SERIAL_BFIN_UART0
-	/* Enable UART0 RX and TX on pin 7 & 8 of PORT E */
-	bfin_write_PORTE_FER(0x180 | bfin_read_PORTE_FER());
-	bfin_write_PORTE_MUX(0x3C000 | bfin_read_PORTE_MUX());
+	peripheral_request(P_UART0_TX, DRIVER_NAME);
+	peripheral_request(P_UART0_RX, DRIVER_NAME);
 #endif
 
 #ifdef CONFIG_SERIAL_BFIN_UART1
-	/* Enable UART1 RX and TX on pin 0 & 1 of PORT H */
-	bfin_write_PORTH_FER(0x3 | bfin_read_PORTH_FER());
-	bfin_write_PORTH_MUX(~0xF & bfin_read_PORTH_MUX());
+	peripheral_request(P_UART1_TX, DRIVER_NAME);
+	peripheral_request(P_UART1_RX, DRIVER_NAME);
+
 #ifdef CONFIG_BFIN_UART1_CTSRTS
-	/* Enable UART1 RTS and CTS on pin 9 & 10 of PORT E */
-	bfin_write_PORTE_FER(0x600 | bfin_read_PORTE_FER());
-	bfin_write_PORTE_MUX(~0x3C0000 & bfin_read_PORTE_MUX());
+	peripheral_request(P_UART1_RTS, DRIVER_NAME);
+	peripheral_request(P_UART1_CTS DRIVER_NAME);
 #endif
 #endif
 
 #ifdef CONFIG_SERIAL_BFIN_UART2
-	/* Enable UART2 RX and TX on pin 4 & 5 of PORT B */
-	bfin_write_PORTB_FER(0x30 | bfin_read_PORTB_FER());
-	bfin_write_PORTB_MUX(~0xF00 & bfin_read_PORTB_MUX());
+	peripheral_request(P_UART2_TX, DRIVER_NAME);
+	peripheral_request(P_UART2_RX, DRIVER_NAME);
 #endif
 
 #ifdef CONFIG_SERIAL_BFIN_UART3
-	/* Enable UART3 RX and TX on pin 6 & 7 of PORT B */
-	bfin_write_PORTB_FER(0xC0 | bfin_read_PORTB_FER());
-	bfin_write_PORTB_MUX(~0xF000 | bfin_read_PORTB_MUX());
+	peripheral_request(P_UART3_TX, DRIVER_NAME);
+	peripheral_request(P_UART3_RX, DRIVER_NAME);
+
 #ifdef CONFIG_BFIN_UART3_CTSRTS
-	/* Enable UART3 RTS and CTS on pin 2 & 3 of PORT B */
-	bfin_write_PORTB_FER(0xC | bfin_read_PORTB_FER());
-	bfin_write_PORTB_MUX(~0xF0 | bfin_read_PORTB_MUX());
+	peripheral_request(P_UART3_RTS, DRIVER_NAME);
+	peripheral_request(P_UART3_CTS DRIVER_NAME);
 #endif
 #endif
 	SSYNC();
 #ifdef CONFIG_SERIAL_BFIN_CTSRTS
 	if (uart->cts_pin >= 0) {
-		gpio_request(uart->cts_pin, NULL);
+		gpio_request(uart->cts_pin, DRIVER_NAME);
 		gpio_direction_input(uart->cts_pin);
 	}
 
 	if (uart->rts_pin >= 0) {
-		gpio_request(uart->rts_pin, NULL);
+		gpio_request(uart->rts_pin, DRIVER_NAME);
 		gpio_direction_output(uart->rts_pin);
 	}
 #endif
-- 
1.5.2
