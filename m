Return-Path: <linux-kernel-owner+w=401wt.eu-S1758437AbXGCOZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437AbXGCOZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 10:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754722AbXGCOZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 10:25:25 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46240 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753669AbXGCOZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 10:25:23 -0400
Date: Tue, 3 Jul 2007 15:31:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] 68360serial, remove broken optimisation
Message-ID: <20070703153107.25cb34ae@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the broken 'no termios change' optimisation for this driver.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.22-rc6-mm1/drivers/serial/68360serial.c linux-2.6.22-rc6-mm1/drivers/serial/68360serial.c
--- linux.vanilla-2.6.22-rc6-mm1/drivers/serial/68360serial.c	2007-07-02 20:47:31.000000000 +0100
+++ linux-2.6.22-rc6-mm1/drivers/serial/68360serial.c	2007-07-02 21:11:07.000000000 +0100
@@ -934,8 +934,6 @@
 	/*
 	 * Set up parity check flag
 	 */
-#define RELEVANT_IFLAG(iflag) (iflag & (IGNBRK|BRKINT|IGNPAR|PARMRK|INPCK))
-
 	info->read_status_mask = (BD_SC_EMPTY | BD_SC_OV);
 	if (I_INPCK(info->tty))
 		info->read_status_mask |= BD_SC_FR | BD_SC_PR;
@@ -1527,11 +1525,6 @@
 {
 	ser_info_t *info = (ser_info_t *)tty->driver_data;
 
-	if (   (tty->termios->c_cflag == old_termios->c_cflag)
-	    && (   RELEVANT_IFLAG(tty->termios->c_iflag) 
-		== RELEVANT_IFLAG(old_termios->c_iflag)))
-	  return;
-
 	change_speed(info);
 
 #ifdef modem_control
