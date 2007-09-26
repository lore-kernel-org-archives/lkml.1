Return-Path: <linux-kernel-owner+w=401wt.eu-S1763158AbXIZWCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763158AbXIZWCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 18:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759501AbXIZWCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 18:02:39 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53661 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759805AbXIZWCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 18:02:38 -0400
Date: Wed, 26 Sep 2007 23:08:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org, greg@kroah.com
Subject: [PATCH] usb_serial: Stop passing NULL to functions that expect data
Message-ID: <20070926230840.231df58e@the-village.bc.nu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Earlier patches have removed the checking for old v new differences from
the USB drivers so we can now pass in a valid blank old termios so that
we don't to fill the drivers with magic hacks for console support

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.23rc8-mm1/drivers/serial/serial_core.c linux-2.6.23rc8-mm1/drivers/serial/serial_core.c
--- linux.vanilla-2.6.23rc8-mm1/drivers/serial/serial_core.c	2007-09-26 16:46:54.000000000 +0100
+++ linux-2.6.23rc8-mm1/drivers/serial/serial_core.c	2007-09-18 16:28:20.000000000 +0100
@@ -1885,6 +1885,7 @@
 		 int baud, int parity, int bits, int flow)
 {
 	struct ktermios termios;
+	static struct ktermios dummy;
 	int i;
 
 	/*
@@ -1930,7 +1931,7 @@
 	 */
 	port->mctrl |= TIOCM_DTR;
 
-	port->ops->set_termios(port, &termios, NULL);
+	port->ops->set_termios(port, &termios, &dummy);
 	co->cflag = termios.c_cflag;
 
 	return 0;
