Return-Path: <linux-kernel-owner+w=401wt.eu-S1756683AbXKSPO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683AbXKSPO1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 10:14:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753898AbXKSPOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 10:14:19 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44458 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753777AbXKSPOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 10:14:19 -0500
Date: Mon, 19 Nov 2007 15:12:22 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-arm@vger.kernel.org
Subject: [PATCH] 21285: Report baud rate back via termios
Message-ID: <20071119151222.6cfa9c4c@the-village.bc.nu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently reports back the requested rate not the result of the divides
but thats an easy fix for someone with h/w

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc2-mm1/drivers/serial/21285.c linux-2.6.24-rc2-mm1/drivers/serial/21285.c
--- linux.vanilla-2.6.24-rc2-mm1/drivers/serial/21285.c	2007-11-16 17:20:48.000000000 +0000
+++ linux-2.6.24-rc2-mm1/drivers/serial/21285.c	2007-11-16 18:35:29.000000000 +0000
@@ -277,6 +279,8 @@
 	if (termios->c_iflag & INPCK)
 		port->read_status_mask |= RXSTAT_FRAME | RXSTAT_PARITY;
 
+	tty_encode_baud_rate(tty,  baud, baud);
+
 	/*
 	 * Which character status flags should we ignore?
 	 */
@@ -301,6 +305,7 @@
 	*CSR_UARTCON = 1;
 
 	spin_unlock_irqrestore(&port->lock, flags);
+	
 }
 
 static const char *serial21285_type(struct uart_port *port)
