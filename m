Return-Path: <linux-kernel-owner+w=401wt.eu-S934352AbZHENYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934352AbZHENYY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 09:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934334AbZHENYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 09:24:23 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:51935 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933743AbZHENYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 09:24:22 -0400
Date: Wed, 5 Aug 2009 15:24:20 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 3/4] drivers/serial: Use UPIO_MEM rather than SERIAL_IO_MEM
Message-ID: <Pine.LNX.4.64.0908051523490.20453@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

As in the commit 9b4a1617772d6d5ab5eeda0cd95302fae119e359, use UPIO_MEM
rather than SERIAL_IO_MEM.  Both have the same value.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@has_sc@
@@

#include <linux/serial_core.h>

@depends on has_sc@
@@

- SERIAL_IO_MEM
+ UPIO_MEM
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/serial/mcf.c           |    4 ++--
 drivers/serial/mpsc.c          |    2 +-
 drivers/serial/pnx8xxx_uart.c  |    2 +-
 drivers/serial/sa1100.c        |    2 +-
 drivers/serial/serial_ks8695.c |    2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff -u -p a/drivers/serial/mcf.c b/drivers/serial/mcf.c
--- a/drivers/serial/mcf.c
+++ b/drivers/serial/mcf.c
@@ -464,7 +464,7 @@ int __init early_mcf_setup(struct mcf_pl
 		port->mapbase = platp[i].mapbase;
 		port->membase = (platp[i].membase) ? platp[i].membase :
 			(unsigned char __iomem *) port->mapbase;
-		port->iotype = SERIAL_IO_MEM;
+		port->iotype = UPIO_MEM;
 		port->irq = platp[i].irq;
 		port->uartclk = MCF_BUSCLK;
 		port->flags = ASYNC_BOOT_AUTOCONF;
@@ -588,7 +588,7 @@ static int __devinit mcf_probe(struct pl
 		port->mapbase = platp[i].mapbase;
 		port->membase = (platp[i].membase) ? platp[i].membase :
 			(unsigned char __iomem *) platp[i].mapbase;
-		port->iotype = SERIAL_IO_MEM;
+		port->iotype = UPIO_MEM;
 		port->irq = platp[i].irq;
 		port->uartclk = MCF_BUSCLK;
 		port->ops = &mcf_uart_ops;
diff -u -p a/drivers/serial/mpsc.c b/drivers/serial/mpsc.c
--- a/drivers/serial/mpsc.c
+++ b/drivers/serial/mpsc.c
@@ -1521,7 +1521,7 @@ static int mpsc_verify_port(struct uart_
 		rc = -EINVAL;
 	else if (pi->port.irq != ser->irq)
 		rc = -EINVAL;
-	else if (ser->io_type != SERIAL_IO_MEM)
+	else if (ser->io_type != UPIO_MEM)
 		rc = -EINVAL;
 	else if (pi->port.uartclk / 16 != ser->baud_base) /* Not sure */
 		rc = -EINVAL;
diff -u -p a/drivers/serial/pnx8xxx_uart.c b/drivers/serial/pnx8xxx_uart.c
--- a/drivers/serial/pnx8xxx_uart.c
+++ b/drivers/serial/pnx8xxx_uart.c
@@ -601,7 +601,7 @@ pnx8xxx_verify_port(struct uart_port *po
 		ret = -EINVAL;
 	if (sport->port.irq != ser->irq)
 		ret = -EINVAL;
-	if (ser->io_type != SERIAL_IO_MEM)
+	if (ser->io_type != UPIO_MEM)
 		ret = -EINVAL;
 	if (sport->port.uartclk / 16 != ser->baud_base)
 		ret = -EINVAL;
diff -u -p a/drivers/serial/sa1100.c b/drivers/serial/sa1100.c
--- a/drivers/serial/sa1100.c
+++ b/drivers/serial/sa1100.c
@@ -564,7 +564,7 @@ sa1100_verify_port(struct uart_port *por
 		ret = -EINVAL;
 	if (sport->port.irq != ser->irq)
 		ret = -EINVAL;
-	if (ser->io_type != SERIAL_IO_MEM)
+	if (ser->io_type != UPIO_MEM)
 		ret = -EINVAL;
 	if (sport->port.uartclk / 16 != ser->baud_base)
 		ret = -EINVAL;
diff -u -p a/drivers/serial/serial_ks8695.c b/drivers/serial/serial_ks8695.c
--- a/drivers/serial/serial_ks8695.c
+++ b/drivers/serial/serial_ks8695.c
@@ -547,7 +547,7 @@ static struct uart_port ks8695uart_ports
 	{
 		.membase	= (void *) KS8695_UART_VA,
 		.mapbase	= KS8695_UART_VA,
-		.iotype		= SERIAL_IO_MEM,
+		.iotype		= UPIO_MEM,
 		.irq		= KS8695_IRQ_UART_TX,
 		.uartclk	= CLOCK_TICK_RATE * 16,
 		.fifosize	= 16,
