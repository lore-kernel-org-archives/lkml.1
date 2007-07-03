Return-Path: <linux-kernel-owner+w=401wt.eu-S1758737AbXGCOco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737AbXGCOco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 10:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754772AbXGCOcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 10:32:36 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45982 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753738AbXGCOcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 10:32:36 -0400
Date: Tue, 3 Jul 2007 15:38:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: [PATCH] visor and whiteheat: remove bogus termios change checks
Message-ID: <20070703153848.5b628b93@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.22-rc6-mm1/drivers/usb/serial/visor.c linux-2.6.22-rc6-mm1/drivers/usb/serial/visor.c
--- linux.vanilla-2.6.22-rc6-mm1/drivers/usb/serial/visor.c	2007-07-02 20:50:14.000000000 +0100
+++ linux-2.6.22-rc6-mm1/drivers/usb/serial/visor.c	2007-07-02 21:25:13.000000000 +0100
@@ -948,14 +948,6 @@
 	}
 
 	cflag = port->tty->termios->c_cflag;
-	/* check that they really want us to change something */
-	if (old_termios) {
-		if ((cflag == old_termios->c_cflag) &&
-		    (RELEVANT_IFLAG(port->tty->termios->c_iflag) == RELEVANT_IFLAG(old_termios->c_iflag))) {
-			dbg("%s - nothing to change...", __FUNCTION__);
-			return;
-		}
-	}
 
 	/* get the byte size */
 	switch (cflag & CSIZE) {
diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.22-rc6-mm1/drivers/usb/serial/whiteheat.c linux-2.6.22-rc6-mm1/drivers/usb/serial/whiteheat.c
--- linux.vanilla-2.6.22-rc6-mm1/drivers/usb/serial/whiteheat.c	2007-07-02 20:50:14.000000000 +0100
+++ linux-2.6.22-rc6-mm1/drivers/usb/serial/whiteheat.c	2007-07-02 21:25:25.000000000 +0100
@@ -891,15 +891,6 @@
 		goto exit;
 	}
 	
-	/* check that they really want us to change something */
-	if (old_termios) {
-		if ((port->tty->termios->c_cflag == old_termios->c_cflag) &&
-		    (port->tty->termios->c_iflag == old_termios->c_iflag)) {
-			dbg("%s - nothing to change...", __FUNCTION__);
-			goto exit;
-		}
-	}
-
 	firm_setup_port(port);
 
 exit:
