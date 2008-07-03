Return-Path: <linux-kernel-owner+w=401wt.eu-S1757673AbYGCO2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673AbYGCO2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 10:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757670AbYGCO2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 10:28:04 -0400
Received: from relay1.sgi.com ([192.48.171.29]:51384 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756439AbYGCO2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 10:28:02 -0400
Date: Thu, 3 Jul 2008 09:28:00 -0500
From: Jack Steiner <steiner@sgi.com>
To: linux-kernel@vger.kernel.org, sfr@canb.auug.org.au
Subject: [PATCH] - Fix compile errors in SGI console drivers (linux-next tree)
Message-ID: <20080703142800.GA18169@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix compile errors in SGI console drivers caused by changes to the
tty_port structures in the linux-next tree.

Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 drivers/serial/ioc3_serial.c |   14 +++++++-------
 drivers/serial/sn_console.c  |    2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

Index: linux/drivers/serial/ioc3_serial.c
===================================================================
--- linux.orig/drivers/serial/ioc3_serial.c	2008-07-03 08:23:12.000000000 -0500
+++ linux/drivers/serial/ioc3_serial.c	2008-07-03 08:40:08.633449253 -0500
@@ -905,7 +905,7 @@ static void transmit_chars(struct uart_p
 		return;
 
 	info = the_port->info;
-	tty = info->tty;
+	tty = info->port.tty;
 
 	if (uart_circ_empty(&info->xmit) || uart_tx_stopped(the_port)) {
 		/* Nothing to do or hw stopped */
@@ -997,14 +997,14 @@ ioc3_change_speed(struct uart_port *the_
 
 	the_port->ignore_status_mask = N_ALL_INPUT;
 
-	info->tty->low_latency = 1;
+	info->port.tty->low_latency = 1;
 
-	if (I_IGNPAR(info->tty))
+	if (I_IGNPAR(info->port.tty))
 		the_port->ignore_status_mask &= ~(N_PARITY_ERROR
 						  | N_FRAMING_ERROR);
-	if (I_IGNBRK(info->tty)) {
+	if (I_IGNBRK(info->port.tty)) {
 		the_port->ignore_status_mask &= ~N_BREAK;
-		if (I_IGNPAR(info->tty))
+		if (I_IGNPAR(info->port.tty))
 			the_port->ignore_status_mask &= ~N_OVERRUN_ERROR;
 	}
 	if (!(cflag & CREAD)) {
@@ -1399,14 +1399,14 @@ static int receive_chars(struct uart_por
 	/* Make sure all the pointers are "good" ones */
 	if (!info)
 		return 0;
-	if (!info->tty)
+	if (!info->port.tty)
 		return 0;
 
 	if (!(port->ip_flags & INPUT_ENABLE))
 		return 0;
 
 	spin_lock_irqsave(&the_port->lock, pflags);
-	tty = info->tty;
+	tty = info->port.tty;
 
 	read_count = do_read(the_port, ch, MAX_CHARS);
 	if (read_count > 0) {
Index: linux/drivers/serial/sn_console.c
===================================================================
--- linux.orig/drivers/serial/sn_console.c	2008-07-03 08:23:12.000000000 -0500
+++ linux/drivers/serial/sn_console.c	2008-07-03 08:38:34.097652215 -0500
@@ -471,7 +471,7 @@ sn_receive_chars(struct sn_cons_port *po
 
 	if (port->sc_port.info) {
 		/* The serial_core stuffs are initilized, use them */
-		tty = port->sc_port.info->tty;
+		tty = port->sc_port.info->port.tty;
 	}
 	else {
 		/* Not registered yet - can't pass to tty layer.  */
