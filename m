Return-Path: <linux-kernel-owner+w=401wt.eu-S1759956AbXGCOWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759956AbXGCOWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 10:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593AbXGCOWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 10:22:30 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52209 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754467AbXGCOW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 10:22:29 -0400
Date: Tue, 3 Jul 2007 15:28:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       paulkf@microgate.com
Subject: [PATCH] synclink: Remove bogus 'no change' termios optimisation
 from synclink drivers
Message-ID: <20070703152804.5669a6d9@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Again this check is wrong now, and un-needed

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.22-rc6-mm1/drivers/char/synclink.c linux-2.6.22-rc6-mm1/drivers/char/synclink.c
--- linux.vanilla-2.6.22-rc6-mm1/drivers/char/synclink.c	2007-07-02 20:48:49.000000000 +0100
+++ linux-2.6.22-rc6-mm1/drivers/char/synclink.c	2007-07-02 21:06:50.000000000 +0100
@@ -160,8 +160,6 @@
 
 #define IO_PIN_SHUTDOWN_LIMIT 100
 
-#define RELEVANT_IFLAG(iflag) (iflag & (IGNBRK|BRKINT|IGNPAR|PARMRK|INPCK))
-
 struct	_input_signal_events {
 	int	ri_up;	
 	int	ri_down;
@@ -3064,12 +3062,6 @@
 		printk("%s(%d):mgsl_set_termios %s\n", __FILE__,__LINE__,
 			tty->driver->name );
 	
-	/* just return if nothing has changed */
-	if ((tty->termios->c_cflag == old_termios->c_cflag)
-	    && (RELEVANT_IFLAG(tty->termios->c_iflag) 
-		== RELEVANT_IFLAG(old_termios->c_iflag)))
-	  return;
-
 	mgsl_change_params(info);
 
 	/* Handle transition to B0 status */
diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.22-rc6-mm1/drivers/char/synclink_gt.c linux-2.6.22-rc6-mm1/drivers/char/synclink_gt.c
--- linux.vanilla-2.6.22-rc6-mm1/drivers/char/synclink_gt.c	2007-07-02 20:48:49.000000000 +0100
+++ linux-2.6.22-rc6-mm1/drivers/char/synclink_gt.c	2007-07-02 21:06:50.000000000 +0100
@@ -144,8 +144,6 @@
 /*
  * tty support and callbacks
  */
-#define RELEVANT_IFLAG(iflag) (iflag & (IGNBRK|BRKINT|IGNPAR|PARMRK|INPCK))
-
 static struct tty_driver *serial_driver;
 
 static int  open(struct tty_struct *tty, struct file * filp);
@@ -823,12 +821,6 @@
 
 	DBGINFO(("%s set_termios\n", tty->driver->name));
 
-	/* just return if nothing has changed */
-	if ((tty->termios->c_cflag == old_termios->c_cflag)
-	    && (RELEVANT_IFLAG(tty->termios->c_iflag)
-		== RELEVANT_IFLAG(old_termios->c_iflag)))
-		return;
-
 	change_params(info);
 
 	/* Handle transition to B0 status */
diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.22-rc6-mm1/drivers/char/synclinkmp.c linux-2.6.22-rc6-mm1/drivers/char/synclinkmp.c
--- linux.vanilla-2.6.22-rc6-mm1/drivers/char/synclinkmp.c	2007-07-02 20:47:23.000000000 +0100
+++ linux-2.6.22-rc6-mm1/drivers/char/synclinkmp.c	2007-07-02 21:06:50.000000000 +0100
@@ -135,8 +135,6 @@
 
 #define IO_PIN_SHUTDOWN_LIMIT 100
 
-#define RELEVANT_IFLAG(iflag) (iflag & (IGNBRK|BRKINT|IGNPAR|PARMRK|INPCK))
-
 struct	_input_signal_events {
 	int	ri_up;
 	int	ri_down;
@@ -927,12 +925,6 @@
 		printk("%s(%d):%s set_termios()\n", __FILE__,__LINE__,
 			tty->driver->name );
 
-	/* just return if nothing has changed */
-	if ((tty->termios->c_cflag == old_termios->c_cflag)
-	    && (RELEVANT_IFLAG(tty->termios->c_iflag)
-		== RELEVANT_IFLAG(old_termios->c_iflag)))
-	  return;
-
 	change_params(info);
 
 	/* Handle transition to B0 status */
