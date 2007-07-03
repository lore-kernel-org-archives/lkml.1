Return-Path: <linux-kernel-owner+w=401wt.eu-S1757556AbXGCOgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556AbXGCOgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 10:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754306AbXGCOgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 10:36:32 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41007 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753789AbXGCOgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 10:36:32 -0400
Date: Tue, 3 Jul 2007 15:42:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: [PATCH] io_*: Remove bogus termios no change checks
Message-ID: <20070703154239.29114caf@the-village.bc.nu>
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

diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.22-rc6-mm1/drivers/usb/serial/io_edgeport.c linux-2.6.22-rc6-mm1/drivers/usb/serial/io_edgeport.c
--- linux.vanilla-2.6.22-rc6-mm1/drivers/usb/serial/io_edgeport.c	2007-07-02 20:50:14.000000000 +0100
+++ linux-2.6.22-rc6-mm1/drivers/usb/serial/io_edgeport.c	2007-07-02 21:12:36.000000000 +0100
@@ -1513,15 +1513,6 @@
 	}
 
 	cflag = tty->termios->c_cflag;
-	/* check that they really want us to change something */
-	if (old_termios) {
-		if (cflag == old_termios->c_cflag &&
-		    tty->termios->c_iflag == old_termios->c_iflag) {
-			dbg("%s - nothing to change", __FUNCTION__);
-			return;
-		}
-	}
-
 	dbg("%s - clfag %08x iflag %08x", __FUNCTION__, 
 	    tty->termios->c_cflag, tty->termios->c_iflag);
 	if (old_termios) {
diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.22-rc6-mm1/drivers/usb/serial/io_ti.c linux-2.6.22-rc6-mm1/drivers/usb/serial/io_ti.c
--- linux.vanilla-2.6.22-rc6-mm1/drivers/usb/serial/io_ti.c	2007-07-02 20:50:14.000000000 +0100
+++ linux-2.6.22-rc6-mm1/drivers/usb/serial/io_ti.c	2007-07-02 21:23:37.000000000 +0100
@@ -2544,14 +2544,6 @@
 	}
 
 	cflag = tty->termios->c_cflag;
-	/* check that they really want us to change something */
-	if (old_termios) {
-		if (cflag == old_termios->c_cflag &&
-		    tty->termios->c_iflag == old_termios->c_iflag) {
-			dbg ("%s - nothing to change", __FUNCTION__);
-			return;
-		}
-	}
 
 	dbg("%s - clfag %08x iflag %08x", __FUNCTION__, 
 	    tty->termios->c_cflag, tty->termios->c_iflag);
