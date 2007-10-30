Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbXJ3EnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbXJ3EnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 00:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbXJ3EmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 00:42:23 -0400
Received: from rex.snapgear.com ([203.143.235.140]:37112 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752607AbXJ3EmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 00:42:21 -0400
Date: Tue, 30 Oct 2007 14:41:19 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200710300441.l9U4fJaa032202@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: use container_of() to access uart struct in Coldfire serial driver
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use container_of() to get at uart struct field in port struct
in ColdFire serial driver.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

diff -Naurp linux-2.6.23-rc1/drivers/serial/mcf.c linux-2.6.23-rc1.platform/drivers/serial/mcf.c
--- linux-2.6.23-rc1/drivers/serial/mcf.c	2007-10-25 10:49:13.000000000 +1000
+++ linux-2.6.23-rc1.platform/drivers/serial/mcf.c	2007-10-30 11:18:30.000000000 +1000
@@ -69,7 +69,7 @@ static unsigned int mcf_tx_empty(struct 
 
 static unsigned int mcf_get_mctrl(struct uart_port *port)
 {
-	struct mcf_uart *pp = (struct mcf_uart *) port;
+	struct mcf_uart *pp = container_of(port, struct mcf_uart, port);
 	unsigned long flags;
 	unsigned int sigs;
 
@@ -87,7 +87,7 @@ static unsigned int mcf_get_mctrl(struct
 
 static void mcf_set_mctrl(struct uart_port *port, unsigned int sigs)
 {
-	struct mcf_uart *pp = (struct mcf_uart *) port;
+	struct mcf_uart *pp = container_of(port, struct mcf_uart, port);
 	unsigned long flags;
 
 	spin_lock_irqsave(&port->lock, flags);
@@ -104,7 +104,7 @@ static void mcf_set_mctrl(struct uart_po
 
 static void mcf_start_tx(struct uart_port *port)
 {
-	struct mcf_uart *pp = (struct mcf_uart *) port;
+	struct mcf_uart *pp = container_of(port, struct mcf_uart, port);
 	unsigned long flags;
 
 	spin_lock_irqsave(&port->lock, flags);
@@ -117,7 +117,7 @@ static void mcf_start_tx(struct uart_por
 
 static void mcf_stop_tx(struct uart_port *port)
 {
-	struct mcf_uart *pp = (struct mcf_uart *) port;
+	struct mcf_uart *pp = container_of(port, struct mcf_uart, port);
 	unsigned long flags;
 
 	spin_lock_irqsave(&port->lock, flags);
@@ -130,7 +130,7 @@ static void mcf_stop_tx(struct uart_port
 
 static void mcf_stop_rx(struct uart_port *port)
 {
-	struct mcf_uart *pp = (struct mcf_uart *) port;
+	struct mcf_uart *pp = container_of(port, struct mcf_uart, port);
 	unsigned long flags;
 
 	spin_lock_irqsave(&port->lock, flags);
@@ -163,7 +163,7 @@ static void mcf_enable_ms(struct uart_po
 
 static int mcf_startup(struct uart_port *port)
 {
-	struct mcf_uart *pp = (struct mcf_uart *) port;
+	struct mcf_uart *pp = container_of(port, struct mcf_uart, port);
 	unsigned long flags;
 
 	spin_lock_irqsave(&port->lock, flags);
@@ -189,7 +189,7 @@ static int mcf_startup(struct uart_port 
 
 static void mcf_shutdown(struct uart_port *port)
 {
-	struct mcf_uart *pp = (struct mcf_uart *) port;
+	struct mcf_uart *pp = container_of(port, struct mcf_uart, port);
 	unsigned long flags;
 
 	spin_lock_irqsave(&port->lock, flags);
@@ -352,7 +352,7 @@ static void mcf_tx_chars(struct mcf_uart
 static irqreturn_t mcf_interrupt(int irq, void *data)
 {
 	struct uart_port *port = data;
-	struct mcf_uart *pp = (struct mcf_uart *) port;
+	struct mcf_uart *pp = container_of(port, struct mcf_uart, port);
 	unsigned int isr;
 
 	isr = readb(port->membase + MCFUART_UISR) & pp->imr;
