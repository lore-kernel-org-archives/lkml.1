Return-Path: <linux-kernel-owner+w=401wt.eu-S1759655AbYDMRLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759655AbYDMRLR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 13:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754594AbYDMRLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 13:11:04 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46920 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754371AbYDMRLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 13:11:03 -0400
Date: Sun, 13 Apr 2008 18:07:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] serial m68k: put_char returns
Message-ID: <20080413180703.4c937f9f@core>
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

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm2/drivers/serial/68328serial.c linux-2.6.25-rc8-mm2/drivers/serial/68328serial.c
--- linux.vanilla-2.6.25-rc8-mm2/drivers/serial/68328serial.c	2008-04-13 15:36:54.000000000 +0100
+++ linux-2.6.25-rc8-mm2/drivers/serial/68328serial.c	2008-04-13 15:41:06.000000000 +0100
@@ -200,7 +200,7 @@
 	local_irq_restore(flags);
 }
 
-static void rs_put_char(char ch)
+static int rs_put_char(char ch)
 {
         int flags, loops = 0;
 
@@ -214,6 +214,7 @@
 	UTX_TXDATA = ch;
         udelay(5);
         local_irq_restore(flags);
+        return 1;
 }
 
 static void rs_start(struct tty_struct *tty)
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm2/drivers/serial/68360serial.c linux-2.6.25-rc8-mm2/drivers/serial/68360serial.c
--- linux.vanilla-2.6.25-rc8-mm2/drivers/serial/68360serial.c	2008-04-13 15:36:54.000000000 +0100
+++ linux-2.6.25-rc8-mm2/drivers/serial/68360serial.c	2008-04-13 15:41:07.000000000 +0100
@@ -994,10 +994,10 @@
 	volatile QUICC_BD	*bdp;
 
 	if (serial_paranoia_check(info, tty->name, "rs_put_char"))
-		return;
+		return 0;
 
 	if (!tty)
-		return;
+		return 0;
 
 	bdp = info->tx_cur;
 	while (bdp->status & BD_SC_READY);
@@ -1015,6 +1015,7 @@
 		bdp++;
 
 	info->tx_cur = (QUICC_BD *)bdp;
+	return 1;
 
 }
 
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm2/drivers/serial/mcfserial.c linux-2.6.25-rc8-mm2/drivers/serial/mcfserial.c
--- linux.vanilla-2.6.25-rc8-mm2/drivers/serial/mcfserial.c	2008-04-13 15:36:54.000000000 +0100
+++ linux-2.6.25-rc8-mm2/drivers/serial/mcfserial.c	2008-04-13 15:41:06.000000000 +0100
@@ -1898,7 +1898,7 @@
  *	This is used for console output.
  */
 
-void mcfrs_put_char(char ch)
+int mcfrs_put_char(char ch)
 {
 	volatile unsigned char	*uartp;
 	unsigned long		flags;
@@ -1922,7 +1922,7 @@
 		mcfrs_init_console(); /* try and get it back */
 	local_irq_restore(flags);
 
-	return;
+	return 1;
 }
 
 
