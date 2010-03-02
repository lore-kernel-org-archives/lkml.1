Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112Ab0CBXsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:48:32 -0500
Received: from kroah.org ([198.145.64.141]:51634 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755240Ab0CBXhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:37:04 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Maxime Bizon <mbizon@freebox.fr>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 25/36] serial: bcm63xx_uart: allow more than one uart to be registered.
Date: Tue,  2 Mar 2010 15:36:32 -0800
Message-Id: <1267573003-782-25-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230956.GC32287@kroah.com>
References: <20100302230956.GC32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxime Bizon <mbizon@freebox.fr>

The bcm6358 CPU has two uarts, make it possible to use the second one.

Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/bcm63xx_uart.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/bcm63xx_uart.c b/drivers/serial/bcm63xx_uart.c
index f78ede8..a1a0e55 100644
--- a/drivers/serial/bcm63xx_uart.c
+++ b/drivers/serial/bcm63xx_uart.c
@@ -35,7 +35,7 @@
 #include <bcm63xx_regs.h>
 #include <bcm63xx_io.h>
 
-#define BCM63XX_NR_UARTS	1
+#define BCM63XX_NR_UARTS	2
 
 static struct uart_port ports[BCM63XX_NR_UARTS];
 
@@ -784,7 +784,7 @@ static struct uart_driver bcm_uart_driver = {
 	.dev_name	= "ttyS",
 	.major		= TTY_MAJOR,
 	.minor		= 64,
-	.nr		= 1,
+	.nr		= BCM63XX_NR_UARTS,
 	.cons		= BCM63XX_CONSOLE,
 };
 
@@ -826,6 +826,7 @@ static int __devinit bcm_uart_probe(struct platform_device *pdev)
 	port->dev = &pdev->dev;
 	port->fifosize = 16;
 	port->uartclk = clk_get_rate(clk) / 2;
+	port->line = pdev->id;
 	clk_put(clk);
 
 	ret = uart_add_one_port(&bcm_uart_driver, port);
-- 
1.7.0.1

