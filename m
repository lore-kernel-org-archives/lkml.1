Return-Path: <linux-kernel-owner+w=401wt.eu-S1756961AbXKSPPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961AbXKSPPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 10:15:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755517AbXKSPPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 10:15:18 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44461 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754759AbXKSPPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 10:15:16 -0500
Date: Mon, 19 Nov 2007 15:13:32 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] serial8250: Coding style
Message-ID: <20071119151332.7654be17@the-village.bc.nu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc2-mm1/drivers/serial/8250.c linux-2.6.24-rc2-mm1/drivers/serial/8250.c
--- linux.vanilla-2.6.24-rc2-mm1/drivers/serial/8250.c	2007-11-16 17:20:48.000000000 +0000
+++ linux-2.6.24-rc2-mm1/drivers/serial/8250.c	2007-11-16 18:35:29.000000000 +0000
@@ -305,7 +305,7 @@
 	return au_io_out_map[offset];
 }
 
-#elif defined (CONFIG_SERIAL_8250_RM9K)
+#elif defined(CONFIG_SERIAL_8250_RM9K)
 
 static const u8
 	regmap_in[8] = {
@@ -475,7 +475,7 @@
 	serial_outp(up, UART_DLM, value >> 8 & 0xff);
 }
 
-#if defined (CONFIG_SERIAL_8250_AU1X00)
+#if defined(CONFIG_SERIAL_8250_AU1X00)
 /* Au1x00 haven't got a standard divisor latch */
 static int serial_dl_read(struct uart_8250_port *up)
 {
@@ -492,7 +492,7 @@
 	else
 		_serial_dl_write(up, value);
 }
-#elif defined (CONFIG_SERIAL_8250_RM9K)
+#elif defined(CONFIG_SERIAL_8250_RM9K)
 static int serial_dl_read(struct uart_8250_port *up)
 {
 	return	(up->port.iotype == UPIO_RM9000) ?
@@ -1185,8 +1185,8 @@
 
 	irqs = probe_irq_on();
 	serial_outp(up, UART_MCR, 0);
-	udelay (10);
-	if (up->port.flags & UPF_FOURPORT)  {
+	udelay(10);
+	if (up->port.flags & UPF_FOURPORT) {
 		serial_outp(up, UART_MCR,
 			    UART_MCR_DTR | UART_MCR_RTS);
 	} else {
@@ -1199,7 +1199,7 @@
 	(void)serial_inp(up, UART_IIR);
 	(void)serial_inp(up, UART_MSR);
 	serial_outp(up, UART_TX, 0xFF);
-	udelay (20);
+	udelay(20);
 	irq = probe_irq_off(irqs);
 
 	serial_outp(up, UART_MCR, save_mcr);
@@ -1343,7 +1343,7 @@
 
 		uart_insert_char(&up->port, lsr, UART_LSR_OE, ch, flag);
 
-	ignore_char:
+ignore_char:
 		lsr = serial_inp(up, UART_LSR);
 	} while ((lsr & UART_LSR_DR) && (max_count-- > 0));
 	spin_unlock(&up->port.lock);
@@ -1633,7 +1633,8 @@
 		serial_out(up, UART_IER, ier);
 
 	/* Standard timer interval plus 0.2s to keep the port running */
-	mod_timer(&up->timer, jiffies + poll_timeout(up->port.timeout) + HZ/5);
+	mod_timer(&up->timer,
+		jiffies + poll_timeout(up->port.timeout) + HZ / 5);
 }
 
 static unsigned int serial8250_tx_empty(struct uart_port *port)
@@ -1844,7 +1845,7 @@
 			up->timer.function = serial8250_backup_timeout;
 			up->timer.data = (unsigned long)up;
 			mod_timer(&up->timer, jiffies +
-			          poll_timeout(up->port.timeout) + HZ/5);
+				poll_timeout(up->port.timeout) + HZ / 5);
 		}
 	}
 
