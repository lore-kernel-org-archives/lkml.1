Return-Path: <linux-kernel-owner+w=401wt.eu-S1762990AbZJOToy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762990AbZJOToy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 15:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759355AbZJOToy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 15:44:54 -0400
Received: from 139.254.232.72.static.reverse.ltdomains.com ([72.232.254.139]:38455
	"EHLO liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758627AbZJOTox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 15:44:53 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: trivial@kernel.org
Cc: akpm@linux-foundation.org, adobriyan@gmail.com, linux-mmc@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH 1/8] trivial: coding style fixes
Date: Thu, 15 Oct 2009 16:44:00 -0300
Message-Id: <1255635840-5691-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/mmc/card/sdio_uart.c |   40 +++++++++++++++++++++-------------------
 1 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/mmc/card/sdio_uart.c b/drivers/mmc/card/sdio_uart.c
index 36a8d53..b8e7c5a 100644
--- a/drivers/mmc/card/sdio_uart.c
+++ b/drivers/mmc/card/sdio_uart.c
@@ -231,7 +231,8 @@ static unsigned int sdio_uart_get_mctrl(struct sdio_uart_port *port)
 	return ret;
 }
 
-static void sdio_uart_write_mctrl(struct sdio_uart_port *port, unsigned int mctrl)
+static void sdio_uart_write_mctrl(struct sdio_uart_port *port,
+				  unsigned int mctrl)
 {
 	unsigned char mcr = 0;
 
@@ -387,7 +388,8 @@ static void sdio_uart_stop_rx(struct sdio_uart_port *port)
 	sdio_out(port, UART_IER, port->ier);
 }
 
-static void sdio_uart_receive_chars(struct sdio_uart_port *port, unsigned int *status)
+static void sdio_uart_receive_chars(struct sdio_uart_port *port,
+				    unsigned int *status)
 {
 	struct tty_struct *tty = port->tty;
 	unsigned int ch, flag;
@@ -399,7 +401,7 @@ static void sdio_uart_receive_chars(struct sdio_uart_port *port, unsigned int *s
 		port->icount.rx++;
 
 		if (unlikely(*status & (UART_LSR_BI | UART_LSR_PE |
-				        UART_LSR_FE | UART_LSR_OE))) {
+					UART_LSR_FE | UART_LSR_OE))) {
 			/*
 			 * For statistics only
 			 */
@@ -417,9 +419,9 @@ static void sdio_uart_receive_chars(struct sdio_uart_port *port, unsigned int *s
 			 * Mask off conditions which should be ignored.
 			 */
 			*status &= port->read_status_mask;
-			if (*status & UART_LSR_BI) {
+			if (*status & UART_LSR_BI)
 				flag = TTY_BREAK;
-			} else if (*status & UART_LSR_PE)
+			else if (*status & UART_LSR_PE)
 				flag = TTY_PARITY;
 			else if (*status & UART_LSR_FE)
 				flag = TTY_FRAME;
@@ -574,7 +576,7 @@ static int sdio_uart_startup(struct sdio_uart_port *port)
 	 */
 	sdio_out(port, UART_FCR, UART_FCR_ENABLE_FIFO);
 	sdio_out(port, UART_FCR, UART_FCR_ENABLE_FIFO |
-			UART_FCR_CLEAR_RCVR | UART_FCR_CLEAR_XMIT);
+		       UART_FCR_CLEAR_RCVR | UART_FCR_CLEAR_XMIT);
 	sdio_out(port, UART_FCR, 0);
 
 	/*
@@ -635,7 +637,7 @@ static void sdio_uart_shutdown(struct sdio_uart_port *port)
 	if (port->tty->termios->c_cflag & HUPCL)
 		sdio_uart_clear_mctrl(port, TIOCM_DTR | TIOCM_RTS);
 
-	 /* Disable interrupts from this port */
+	/* Disable interrupts from this port */
 	sdio_release_irq(port->func);
 	port->ier = 0;
 	sdio_out(port, UART_IER, 0);
@@ -659,7 +661,7 @@ skip:
 	free_page((unsigned long)port->xmit.buf);
 }
 
-static int sdio_uart_open (struct tty_struct *tty, struct file * filp)
+static int sdio_uart_open(struct tty_struct *tty, struct file *filp)
 {
 	struct sdio_uart_port *port;
 	int ret;
@@ -846,7 +848,7 @@ static void sdio_uart_set_termios(struct tty_struct *tty, struct ktermios *old_t
 	struct sdio_uart_port *port = tty->driver_data;
 	unsigned int cflag = tty->termios->c_cflag;
 
-#define RELEVANT_IFLAG(iflag)   ((iflag) & (IGNBRK|BRKINT|IGNPAR|PARMRK|INPCK))
+#define RELEVANT_IFLAG(iflag)	((iflag) & (IGNBRK|BRKINT|IGNPAR|PARMRK|INPCK))
 
 	if ((cflag ^ old_termios->c_cflag) == 0 &&
 	    RELEVANT_IFLAG(tty->termios->c_iflag ^ old_termios->c_iflag) == 0)
@@ -925,7 +927,7 @@ static int sdio_uart_tiocmset(struct tty_struct *tty, struct file *file,
 	struct sdio_uart_port *port = tty->driver_data;
 	int result;
 
-	result =sdio_uart_claim_func(port);
+	result = sdio_uart_claim_func(port);
 	if(!result) {
 		sdio_uart_update_mctrl(port, set, clear);
 		sdio_uart_release_func(port);
@@ -946,31 +948,31 @@ static int sdio_uart_proc_show(struct seq_file *m, void *v)
 			seq_printf(m, "%d: uart:SDIO", i);
 			if(capable(CAP_SYS_ADMIN)) {
 				seq_printf(m, " tx:%d rx:%d",
-					       port->icount.tx, port->icount.rx);
+					      port->icount.tx, port->icount.rx);
 				if (port->icount.frame)
 					seq_printf(m, " fe:%d",
-						       port->icount.frame);
+						      port->icount.frame);
 				if (port->icount.parity)
 					seq_printf(m, " pe:%d",
-						       port->icount.parity);
+						      port->icount.parity);
 				if (port->icount.brk)
 					seq_printf(m, " brk:%d",
-						       port->icount.brk);
+						      port->icount.brk);
 				if (port->icount.overrun)
 					seq_printf(m, " oe:%d",
-						       port->icount.overrun);
+						      port->icount.overrun);
 				if (port->icount.cts)
 					seq_printf(m, " cts:%d",
-						       port->icount.cts);
+						      port->icount.cts);
 				if (port->icount.dsr)
 					seq_printf(m, " dsr:%d",
-						       port->icount.dsr);
+						      port->icount.dsr);
 				if (port->icount.rng)
 					seq_printf(m, " rng:%d",
-						       port->icount.rng);
+						      port->icount.rng);
 				if (port->icount.dcd)
 					seq_printf(m, " dcd:%d",
-						       port->icount.dcd);
+						      port->icount.dcd);
 			}
 			sdio_uart_port_put(port);
 			seq_putc(m, '\n');
-- 
1.6.3.3

