Return-Path: <linux-kernel-owner+w=401wt.eu-S934533AbXHVWDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934533AbXHVWDk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 18:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933772AbXHVWDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 18:03:10 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48133 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761754AbXHVWDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 18:03:07 -0400
Date: Wed, 22 Aug 2007 23:11:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net, greg@kroah.com
Subject: [PATCH] oti6858: Remove broken ioctl code in -mm tree and also the
 broken fixes
Message-ID: <20070822231106.38097b83@the-village.bc.nu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This stuff is simply not needed.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.23rc3-mm1/drivers/usb/serial/oti6858.c linux-2.6.23rc3-mm1/drivers/usb/serial/oti6858.c
--- linux.vanilla-2.6.23rc3-mm1/drivers/usb/serial/oti6858.c	2007-08-22 17:23:08.000000000 +0100
+++ linux-2.6.23rc3-mm1/drivers/usb/serial/oti6858.c	2007-08-22 17:48:48.000000000 +0100
@@ -817,21 +817,6 @@
 				__FUNCTION__, port->number, cmd, arg);
 
 	switch (cmd) {
-		case TCGETS:
-			if (kernel_termios_to_user_termios((struct ktermios __user *)arg,
-							   port->tty->termios))
-				return -EFAULT;
-			return 0;
-
-		case TCSETS:
-		case TCSETSW:	/* FIXME: this is not the same! */
-		case TCSETSF:	/* FIXME: this is not the same! */
-			if (user_termios_to_kernel_termios(port->tty->termios,
-						(struct ktermios __user *)arg))
-				return -EFAULT;
-			oti6858_set_termios(port, NULL);
-			return 0;
-
 		case TCFLSH:
 			/* FIXME */
 			return 0;
