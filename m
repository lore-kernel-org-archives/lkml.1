Return-Path: <linux-kernel-owner+w=401wt.eu-S1752535AbYDMRSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbYDMRSd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 13:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750953AbYDMRSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 13:18:25 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53503 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750890AbYDMRSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 13:18:24 -0400
Date: Sun, 13 Apr 2008 18:14:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pcmcia: serial to int put_char method
Message-ID: <20080413181425.2816776c@core>
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

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm2/drivers/char/pcmcia/synclink_cs.c linux-2.6.25-rc8-mm2/drivers/char/pcmcia/synclink_cs.c
--- linux.vanilla-2.6.25-rc8-mm2/drivers/char/pcmcia/synclink_cs.c	2008-04-13 15:36:53.000000000 +0100
+++ linux-2.6.25-rc8-mm2/drivers/char/pcmcia/synclink_cs.c	2008-04-13 15:41:04.000000000 +0100
@@ -1547,7 +1547,7 @@
 
 /* Add a character to the transmit buffer
  */
-static void mgslpc_put_char(struct tty_struct *tty, unsigned char ch)
+static int mgslpc_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	MGSLPC_INFO *info = (MGSLPC_INFO *)tty->driver_data;
 	unsigned long flags;
@@ -1558,10 +1558,10 @@
 	}
 
 	if (mgslpc_paranoia_check(info, tty->name, "mgslpc_put_char"))
-		return;
+		return 0;
 
 	if (!info->tx_buf)
-		return;
+		return 0;
 
 	spin_lock_irqsave(&info->lock,flags);
 
@@ -1574,6 +1574,7 @@
 	}
 
 	spin_unlock_irqrestore(&info->lock,flags);
+	return 1;
 }
 
 /* Enable transmitter so remaining characters in the
