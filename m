Return-Path: <linux-kernel-owner+w=401wt.eu-S1754964AbXJ3Fz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964AbXJ3Fz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 01:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbXJ3FzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 01:55:13 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:40011 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbXJ3FzL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 01:55:11 -0400
Date: Mon, 29 Oct 2007 22:56:14 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] serial: fix compiling warning about putc
To: Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <200710292256.14213.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] serial: fix compiling warning about putc

CC      drivers/serial/8250_early.o
drivers/serial/8250_early.c:80: warning: conflicting types for built-in function ‘putc’

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/drivers/serial/8250_early.c b/drivers/serial/8250_early.c
index 4d4c9f0..1f16de7 100644
--- a/drivers/serial/8250_early.c
+++ b/drivers/serial/8250_early.c
@@ -76,7 +76,7 @@ static void __init wait_for_xmitr(struct uart_port *port)
 	}
 }
 
-static void __init putc(struct uart_port *port, int c)
+static void __init serial_putc(struct uart_port *port, int c)
 {
 	wait_for_xmitr(port);
 	serial_out(port, UART_TX, c);
@@ -91,7 +91,7 @@ static void __init early_serial8250_write(struct console *console, const char *s
 	ier = serial_in(port, UART_IER);
 	serial_out(port, UART_IER, 0);
 
-	uart_console_write(port, s, count, putc);
+	uart_console_write(port, s, count, serial_putc);
 
 	/* Wait for transmitter to become empty and restore the IER */
 	wait_for_xmitr(port);
