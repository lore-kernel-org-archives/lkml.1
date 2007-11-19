Return-Path: <linux-kernel-owner+w=401wt.eu-S1757291AbXKSPSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291AbXKSPSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 10:18:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757177AbXKSPSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 10:18:42 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59861 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755194AbXKSPSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 10:18:41 -0500
Date: Mon, 19 Nov 2007 15:16:57 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] serial_core: Bring mostly into line with coding style
Message-ID: <20071119151657.7bff9b31@the-village.bc.nu>
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

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc2-mm1/drivers/serial/serial_core.c linux-2.6.24-rc2-mm1/drivers/serial/serial_core.c
--- linux.vanilla-2.6.24-rc2-mm1/drivers/serial/serial_core.c	2007-11-16 17:55:12.000000000 +0000
+++ linux-2.6.24-rc2-mm1/drivers/serial/serial_core.c	2007-11-16 18:35:53.000000000 +0000
@@ -58,7 +58,8 @@
 #define uart_console(port)	(0)
 #endif
 
-static void uart_change_speed(struct uart_state *state, struct ktermios *old_termios);
+static void uart_change_speed(struct uart_state *state,
+					struct ktermios *old_termios);
 static void uart_wait_until_sent(struct tty_struct *tty, int timeout);
 static void uart_change_pm(struct uart_state *state, int pm_state);
 
@@ -129,8 +130,8 @@
 	spin_unlock_irqrestore(&port->lock, flags);
 }
 
-#define uart_set_mctrl(port,set)	uart_update_mctrl(port,set,0)
-#define uart_clear_mctrl(port,clear)	uart_update_mctrl(port,0,clear)
+#define uart_set_mctrl(port, set)	uart_update_mctrl(port, set, 0)
+#define uart_clear_mctrl(port, clear)	uart_update_mctrl(port, 0, clear)
 
 /*
  * Startup the port.  This will be called once per open.  All calls
@@ -290,7 +291,7 @@
 		break;
 	default:
 		bits = 10;
-		break; // CS8
+		break; /* CS8 */
 	}
 
 	if (cflag & CSTOPB)
@@ -621,7 +623,7 @@
 	tmp.close_delay	    = state->close_delay / 10;
 	tmp.closing_wait    = state->closing_wait == USF_CLOSING_WAIT_NONE ?
 				ASYNC_CLOSING_WAIT_NONE :
-			        state->closing_wait / 10;
+				state->closing_wait / 10;
 	tmp.custom_divisor  = port->custom_divisor;
 	tmp.hub6	    = port->hub6;
 	tmp.io_type         = port->iotype;
@@ -787,7 +789,8 @@
 			 * We failed anyway.
 			 */
 			retval = -EBUSY;
-			goto exit;  // Added to return the correct error -Ram Gupta
+			/* Added to return the correct error -Ram Gupta */
+			goto exit;
 		}
 	}
 
@@ -857,7 +860,7 @@
 	    ((uart_circ_chars_pending(&state->info->xmit) > 0) &&
 	     !state->info->tty->stopped && !state->info->tty->hw_stopped))
 		result &= ~TIOCSER_TEMT;
-	
+
 	return put_user(result, value);
 }
 
@@ -995,8 +998,8 @@
 		    ((arg & TIOCM_DSR) && (cnow.dsr != cprev.dsr)) ||
 		    ((arg & TIOCM_CD)  && (cnow.dcd != cprev.dcd)) ||
 		    ((arg & TIOCM_CTS) && (cnow.cts != cprev.cts))) {
-		    	ret = 0;
-		    	break;
+			ret = 0;
+			break;
 		}
 
 		schedule();
@@ -1136,7 +1139,8 @@
 	return ret;
 }
 
-static void uart_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
+static void uart_set_termios(struct tty_struct *tty,
+						struct ktermios *old_termios)
 {
 	struct uart_state *state = tty->driver_data;
 	unsigned long flags;
@@ -1212,7 +1216,7 @@
 {
 	struct uart_state *state = tty->driver_data;
 	struct uart_port *port;
-	
+
 	BUG_ON(!kernel_locked());
 
 	if (!state || !state->port)
@@ -1277,8 +1281,8 @@
 	uart_shutdown(state);
 	uart_flush_buffer(tty);
 
-	tty_ldisc_flush(tty);	
-	
+	tty_ldisc_flush(tty);
+
 	tty->closing = 0;
 	state->info->tty = NULL;
 
@@ -1340,7 +1344,7 @@
 	expire = jiffies + timeout;
 
 	pr_debug("uart_wait_until_sent(%d), jiffies=%lu, expire=%lu...\n",
-	        port->line, jiffies, expire);
+		port->line, jiffies, expire);
 
 	/*
 	 * Check whether the transmitter is empty every 'char_time'.
@@ -1459,10 +1463,9 @@
 		 * have set TTY_IO_ERROR for a non-existant port.
 		 */
 		if ((filp->f_flags & O_NONBLOCK) ||
-	            (info->tty->termios->c_cflag & CLOCAL) ||
-		    (info->tty->flags & (1 << TTY_IO_ERROR))) {
+		    (info->tty->termios->c_cflag & CLOCAL) ||
+		    (info->tty->flags & (1 << TTY_IO_ERROR)))
 			break;
-		}
 
 		/*
 		 * Set DTR to allow modem to know we're waiting.  Do
@@ -1673,7 +1676,7 @@
 			port->line, uart_type(port),
 			mmio ? "mmio:0x" : "port:",
 			mmio ? (unsigned long long)port->mapbase
-		             : (unsigned long long) port->iobase,
+			     : (unsigned long long) port->iobase,
 			port->irq);
 
 	if (port->type == PORT_UNKNOWN) {
@@ -1681,8 +1684,7 @@
 		return ret + 1;
 	}
 
-	if(capable(CAP_SYS_ADMIN))
-	{
+	if (capable(CAP_SYS_ADMIN)) {
 		mutex_lock(&state->mutex);
 		pm_state = state->pm_state;
 		if (pm_state)
@@ -1708,12 +1710,12 @@
 		if (port->icount.overrun)
 			ret += sprintf(buf + ret, " oe:%d",
 				port->icount.overrun);
-	
-#define INFOBIT(bit,str) \
+
+#define INFOBIT(bit, str) \
 	if (port->mctrl & (bit)) \
 		strncat(stat_buf, (str), sizeof(stat_buf) - \
 			strlen(stat_buf) - 2)
-#define STATBIT(bit,str) \
+#define STATBIT(bit, str) \
 	if (status & (bit)) \
 		strncat(stat_buf, (str), sizeof(stat_buf) - \
 		       strlen(stat_buf) - 2)
@@ -1729,7 +1731,7 @@
 		if (stat_buf[0])
 			stat_buf[0] = ' ';
 		strcat(stat_buf, "\n");
-	
+
 		ret += sprintf(buf + ret, stat_buf);
 	} else {
 		strcat(buf, "\n");
@@ -1990,9 +1992,8 @@
 		/*
 		 * Wait for the transmitter to empty.
 		 */
-		while (!ops->tx_empty(port)) {
+		while (!ops->tx_empty(port))
 			msleep(10);
-		}
 
 		ops->shutdown(port);
 	}
