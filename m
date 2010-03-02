Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084Ab0CBXtc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:49:32 -0500
Received: from kroah.org ([198.145.64.141]:51615 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754914Ab0CBXhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:37:01 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Sonic Zhang <sonic.zhang@analog.com>, Mike Frysinger <vapier@gentoo.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 20/36] serial: bfin_5xx: remove useless gpio handling with hard flow control
Date: Tue,  2 Mar 2010 15:36:27 -0800
Message-Id: <1267573003-782-20-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230956.GC32287@kroah.com>
References: <20100302230956.GC32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

For UARTs that have dedicated hardware flow control support, there will be
no gpios to request/free as they are part of the normal peripheral pins.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/bfin_5xx.c |   16 +---------------
 1 files changed, 1 insertions(+), 15 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 50abb7e..15843cc 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -746,15 +746,6 @@ static int bfin_serial_startup(struct uart_port *port)
 			Status interrupt.\n");
 	}
 
-	if (uart->cts_pin >= 0) {
-		gpio_request(uart->cts_pin, DRIVER_NAME);
-		gpio_direction_output(uart->cts_pin, 1);
-	}
-	if (uart->rts_pin >= 0) {
-		gpio_request(uart->rts_pin, DRIVER_NAME);
-		gpio_direction_output(uart->rts_pin, 0);
-	}
-
 	/* CTS RTS PINs are negative assertive. */
 	UART_PUT_MCR(uart, ACTS);
 	UART_SET_IER(uart, EDSSI);
@@ -801,10 +792,6 @@ static void bfin_serial_shutdown(struct uart_port *port)
 		gpio_free(uart->rts_pin);
 #endif
 #ifdef CONFIG_SERIAL_BFIN_HARD_CTSRTS
-	if (uart->cts_pin >= 0)
-		gpio_free(uart->cts_pin);
-	if (uart->rts_pin >= 0)
-		gpio_free(uart->rts_pin);
 	if (UART_GET_IER(uart) && EDSSI)
 		free_irq(uart->status_irq, uart);
 #endif
@@ -1409,8 +1396,7 @@ static int bfin_serial_remove(struct platform_device *dev)
 			continue;
 		uart_remove_one_port(&bfin_serial_reg, &bfin_serial_ports[i].port);
 		bfin_serial_ports[i].port.dev = NULL;
-#if defined(CONFIG_SERIAL_BFIN_CTSRTS) || \
-	defined(CONFIG_SERIAL_BFIN_HARD_CTSRTS)
+#if defined(CONFIG_SERIAL_BFIN_CTSRTS)
 		gpio_free(bfin_serial_ports[i].cts_pin);
 		gpio_free(bfin_serial_ports[i].rts_pin);
 #endif
-- 
1.7.0.1

