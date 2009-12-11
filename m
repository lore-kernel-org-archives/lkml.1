Return-Path: <linux-kernel-owner+w=401wt.eu-S934954AbZLKXgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934954AbZLKXgc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934940AbZLKXgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:36:12 -0500
Received: from kroah.org ([198.145.64.141]:50440 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934315AbZLKX3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:29:15 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 32/58] tty: sdio_uart: Style fixes
Date: Fri, 11 Dec 2009 15:28:16 -0800
Message-Id: <1260574122-10676-32-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Running the current code through checkpatch shows a few bits of noise
mostly but not entirely from before the changes.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/mmc/card/sdio_uart.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/mmc/card/sdio_uart.c b/drivers/mmc/card/sdio_uart.c
index 2104397..b999972 100644
--- a/drivers/mmc/card/sdio_uart.c
+++ b/drivers/mmc/card/sdio_uart.c
@@ -465,7 +465,8 @@ static void sdio_uart_transmit_chars(struct sdio_uart_port *port)
 
 	tty = tty_port_tty_get(&port->port);
 
-	if (tty == NULL || circ_empty(xmit) || tty->stopped || tty->hw_stopped) {
+	if (tty == NULL || circ_empty(xmit) ||
+				tty->stopped || tty->hw_stopped) {
 		sdio_uart_stop_tx(port);
 		tty_kref_put(tty);
 		return;
@@ -645,7 +646,7 @@ static int sdio_uart_activate(struct tty_port *tport, struct tty_struct *tty)
 	 */
 	sdio_out(port, UART_LCR, UART_LCR_WLEN8);
 
-	port->ier = UART_IER_RLSI | UART_IER_RDI | UART_IER_RTOIE | UART_IER_UUE;
+	port->ier = UART_IER_RLSI|UART_IER_RDI|UART_IER_RTOIE|UART_IER_UUE;
 	port->mctrl = TIOCM_OUT2;
 
 	sdio_uart_change_speed(port, tty->termios, NULL);
@@ -674,7 +675,6 @@ err1:
 	return ret;
 }
 
-
 /**
  *	sdio_uart_shutdown	-	stop hardware
  *	@tport: tty port to shut down
@@ -745,7 +745,6 @@ static int sdio_uart_install(struct tty_driver *driver, struct tty_struct *tty)
 	} else
 		sdio_uart_port_put(port);
 	return ret;
-
 }
 
 /**
@@ -785,7 +784,7 @@ static void sdio_uart_hangup(struct tty_struct *tty)
 	tty_port_hangup(&port->port);
 }
 
-static int sdio_uart_write(struct tty_struct * tty, const unsigned char *buf,
+static int sdio_uart_write(struct tty_struct *tty, const unsigned char *buf,
 			   int count)
 {
 	struct sdio_uart_port *port = tty->driver_data;
@@ -810,7 +809,7 @@ static int sdio_uart_write(struct tty_struct * tty, const unsigned char *buf,
 	}
 	spin_unlock(&port->write_lock);
 
-	if ( !(port->ier & UART_IER_THRI)) {
+	if (!(port->ier & UART_IER_THRI)) {
 		int err = sdio_uart_claim_func(port);
 		if (!err) {
 			sdio_uart_start_tx(port);
@@ -897,7 +896,8 @@ static void sdio_uart_unthrottle(struct tty_struct *tty)
 	sdio_uart_release_func(port);
 }
 
-static void sdio_uart_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
+static void sdio_uart_set_termios(struct tty_struct *tty,
+						struct ktermios *old_termios)
 {
 	struct sdio_uart_port *port = tty->driver_data;
 	unsigned int cflag = tty->termios->c_cflag;
@@ -976,7 +976,7 @@ static int sdio_uart_tiocmset(struct tty_struct *tty, struct file *file,
 	int result;
 
 	result = sdio_uart_claim_func(port);
-	if(!result) {
+	if (!result) {
 		sdio_uart_update_mctrl(port, set, clear);
 		sdio_uart_release_func(port);
 	}
@@ -994,7 +994,7 @@ static int sdio_uart_proc_show(struct seq_file *m, void *v)
 		struct sdio_uart_port *port = sdio_uart_port_get(i);
 		if (port) {
 			seq_printf(m, "%d: uart:SDIO", i);
-			if(capable(CAP_SYS_ADMIN)) {
+			if (capable(CAP_SYS_ADMIN)) {
 				seq_printf(m, " tx:%d rx:%d",
 					      port->icount.tx, port->icount.rx);
 				if (port->icount.frame)
@@ -1100,7 +1100,7 @@ static int sdio_uart_probe(struct sdio_func *func,
 		}
 		if (!tpl) {
 			printk(KERN_WARNING
-			       "%s: can't find tuple 0x91 subtuple 0 (SUBTPL_SIOREG) for GPS class\n",
+       "%s: can't find tuple 0x91 subtuple 0 (SUBTPL_SIOREG) for GPS class\n",
 			       sdio_func_id(func));
 			kfree(port);
 			return -EINVAL;
@@ -1133,7 +1133,8 @@ static int sdio_uart_probe(struct sdio_func *func,
 		kfree(port);
 	} else {
 		struct device *dev;
-		dev = tty_register_device(sdio_uart_tty_driver, port->index, &func->dev);
+		dev = tty_register_device(sdio_uart_tty_driver,
+						port->index, &func->dev);
 		if (IS_ERR(dev)) {
 			sdio_uart_port_remove(port);
 			ret = PTR_ERR(dev);
-- 
1.6.5.5

