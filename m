Return-Path: <linux-kernel-owner+w=401wt.eu-S1760032AbYBAHoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760032AbYBAHoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 02:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935139AbYBAHjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 02:39:17 -0500
Received: from rex.snapgear.com ([203.143.235.140]:48077 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758717AbYBAHjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 02:39:12 -0500
Date: Fri, 1 Feb 2008 17:38:34 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200802010738.m117cYR6022741@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: use container_of in mcf.c
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use container_of() instead of assuming local uart struct is first member
of uart_port struct.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.24/drivers/serial/mcf.c linux-2.6.24-uc0/drivers/serial/mcf.c
--- linux-2.6.24/drivers/serial/mcf.c	2008-01-25 08:58:37.000000000 +1000
+++ linux-2.6.24-uc0/drivers/serial/mcf.c	2007-10-29 11:59:53.000000000 +1000
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
@@ -273,7 +273,7 @@ static void mcf_set_termios(struct uart_
 
 static void mcf_rx_chars(struct mcf_uart *pp)
 {
-	struct uart_port *port = (struct uart_port *) pp;
+	struct uart_port *port = &pp->port;
 	unsigned char status, ch, flag;
 
 	while ((status = readb(port->membase + MCFUART_USR)) & MCFUART_USR_RXREADY) {
@@ -319,7 +319,7 @@ static void mcf_rx_chars(struct mcf_uart
 
 static void mcf_tx_chars(struct mcf_uart *pp)
 {
-	struct uart_port *port = (struct uart_port *) pp;
+	struct uart_port *port = &pp->port;
 	struct circ_buf *xmit = &port->info->xmit;
 
 	if (port->x_char) {
@@ -352,7 +352,7 @@ static void mcf_tx_chars(struct mcf_uart
 static irqreturn_t mcf_interrupt(int irq, void *data)
 {
 	struct uart_port *port = data;
-	struct mcf_uart *pp = (struct mcf_uart *) port;
+	struct mcf_uart *pp = container_of(port, struct mcf_uart, port);
 	unsigned int isr;
 
 	isr = readb(port->membase + MCFUART_UISR) & pp->imr;
