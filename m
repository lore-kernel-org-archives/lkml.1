Return-Path: <linux-kernel-owner+w=401wt.eu-S1762335AbXIZWGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762335AbXIZWGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 18:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbXIZWGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 18:06:06 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60929 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752370AbXIZWGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 18:06:05 -0400
Date: Wed, 26 Sep 2007 23:12:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: greg@kroah.com, akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb serial: Kill another case we pass NULL and shouldn't
Message-ID: <20070926231205.2dde3700@the-village.bc.nu>
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

diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.23rc8-mm1/drivers/usb/serial/console.c linux-2.6.23rc8-mm1/drivers/usb/serial/console.c
--- linux.vanilla-2.6.23rc8-mm1/drivers/usb/serial/console.c	2007-09-26 16:41:47.000000000 +0100
+++ linux-2.6.23rc8-mm1/drivers/usb/serial/console.c	2007-09-18 16:30:08.000000000 +0100
@@ -164,6 +164,7 @@
 	}
 
 	if (serial->type->set_termios) {
+		struct ktermios dummy;
 		/* build up a fake tty structure so that the open call has something
 		 * to look at to get the cflag value */
 		tty = kzalloc(sizeof(*tty), GFP_KERNEL);
@@ -177,12 +178,13 @@
 			kfree (tty);
 			return -ENOMEM;
 		}
+		memset(&dummy, 0, sizeof(struct ktermios));
 		termios->c_cflag = cflag;
 		tty->termios = termios;
 		port->tty = tty;
 
 		/* set up the initial termios settings */
-		serial->type->set_termios(port, NULL);
+		serial->type->set_termios(port, &dummy);
 		port->tty = NULL;
 		kfree (termios);
 		kfree (tty);
