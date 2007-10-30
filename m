Return-Path: <linux-kernel-owner+w=401wt.eu-S1753736AbXJ3Ema@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbXJ3Ema (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 00:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbXJ3EmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 00:42:22 -0400
Received: from rex.snapgear.com ([203.143.235.140]:37116 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752526AbXJ3EmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 00:42:21 -0400
Date: Tue, 30 Oct 2007 14:41:22 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200710300441.l9U4fMIw032208@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: cleanup port field access from uart struct in Coldfire serial driver
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use port field instead of silly struct/pointer casting to get at
port struct from local uart struct in ColdFire serial driver.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

diff -Naurp linux-2.6.23-rc1/drivers/serial/mcf.c linux-2.6.23-rc1.platform/drivers/serial/mcf.c
--- linux-2.6.23-rc1/drivers/serial/mcf.c	2007-10-25 10:49:13.000000000 +1000
+++ linux-2.6.23-rc1.platform/drivers/serial/mcf.c	2007-10-30 11:18:30.000000000 +1000
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
