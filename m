Return-Path: <linux-kernel-owner+w=401wt.eu-S1753706AbYDMR1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbYDMR1f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 13:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbYDMR12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 13:27:28 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54846 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751563AbYDMR11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 13:27:27 -0400
Date: Sun, 13 Apr 2008 18:17:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org, R.E.Wolff@BitWizard.nl
Subject: [PATCH] specialix: Switch to int put_char method
Message-ID: <20080413181756.5463f265@core>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm2/drivers/char/specialix.c linux-2.6.25-rc8-mm2/drivers/char/specialix.c
--- linux.vanilla-2.6.25-rc8-mm2/drivers/char/specialix.c	2008-04-13 15:36:53.000000000 +0100
+++ linux-2.6.25-rc8-mm2/drivers/char/specialix.c	2008-04-13 15:41:03.000000000 +0100
@@ -1692,7 +1692,7 @@
 }
 
 
-static void sx_put_char(struct tty_struct * tty, unsigned char ch)
+static int sx_put_char(struct tty_struct * tty, unsigned char ch)
 {
 	struct specialix_port *port = (struct specialix_port *)tty->driver_data;
 	unsigned long flags;
@@ -1702,12 +1702,12 @@
 
 	if (sx_paranoia_check(port, tty->name, "sx_put_char")) {
 		func_exit();
-		return;
+		return 0;
 	}
 	dprintk (SX_DEBUG_TX, "check tty: %p %p\n", tty, port->xmit_buf);
 	if (!port->xmit_buf) {
 		func_exit();
-		return;
+		return 0;
 	}
 	bp = port_Board(port);
 	spin_lock_irqsave(&port->lock, flags);
@@ -1717,7 +1717,7 @@
 		spin_unlock_irqrestore(&port->lock, flags);
 		dprintk (SX_DEBUG_TX, "Exit size\n");
 		func_exit();
-		return;
+		return 0;
 	}
 	dprintk (SX_DEBUG_TX, "Handle xmit: %p %p\n", port, port->xmit_buf);
 	port->xmit_buf[port->xmit_head++] = ch;
@@ -1726,6 +1726,7 @@
 	spin_unlock_irqrestore(&port->lock, flags);
 
 	func_exit();
+	return 1;
 }
 
 
