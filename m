Return-Path: <linux-kernel-owner+w=401wt.eu-S1759020AbXGCOei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759020AbXGCOei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 10:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754772AbXGCOea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 10:34:30 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41003 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753849AbXGCOe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 10:34:29 -0400
Date: Tue, 3 Jul 2007 15:40:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: [PATCH] mos7720: Remove bogus no termios change check
Message-ID: <20070703154033.4325d11c@the-village.bc.nu>
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

diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.22-rc6-mm1/drivers/usb/serial/mos7720.c linux-2.6.22-rc6-mm1/drivers/usb/serial/mos7720.c
--- linux.vanilla-2.6.22-rc6-mm1/drivers/usb/serial/mos7720.c	2007-07-02 20:50:14.000000000 +0100
+++ linux-2.6.22-rc6-mm1/drivers/usb/serial/mos7720.c	2007-07-02 21:25:13.000000000 +0100
@@ -1238,16 +1238,6 @@
 		return;
 	}
 
-	/* check that they really want us to change something */
-	if (old_termios) {
-		if ((cflag == old_termios->c_cflag) &&
-		    (RELEVANT_IFLAG(tty->termios->c_iflag) ==
-		     RELEVANT_IFLAG(old_termios->c_iflag))) {
-			dbg("Nothing to change");
-			return;
-		}
-	}
-
 	dbg("%s - clfag %08x iflag %08x", __FUNCTION__,
 	    tty->termios->c_cflag,
 	    RELEVANT_IFLAG(tty->termios->c_iflag));
