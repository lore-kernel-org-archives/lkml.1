Return-Path: <linux-kernel-owner+w=401wt.eu-S1752390AbYDMRRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390AbYDMRRT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 13:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbYDMRRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 13:17:12 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53500 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750895AbYDMRRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 13:17:11 -0400
Date: Sun, 13 Apr 2008 18:13:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mxser: switch to put_char being int
Message-ID: <20080413181312.17311129@core>
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

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm2/drivers/char/mxser.c linux-2.6.25-rc8-mm2/drivers/char/mxser.c
--- linux.vanilla-2.6.25-rc8-mm2/drivers/char/mxser.c	2008-04-13 15:36:53.000000000 +0100
+++ linux-2.6.25-rc8-mm2/drivers/char/mxser.c	2008-04-13 15:41:04.000000000 +0100
@@ -1289,16 +1289,16 @@
 	return total;
 }
 
-static void mxser_put_char(struct tty_struct *tty, unsigned char ch)
+static int mxser_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	struct mxser_port *info = tty->driver_data;
 	unsigned long flags;
 
 	if (!info->xmit_buf)
-		return;
+		return 0;
 
 	if (info->xmit_cnt >= SERIAL_XMIT_SIZE - 1)
-		return;
+		return 0;
 
 	spin_lock_irqsave(&info->slock, flags);
 	info->xmit_buf[info->xmit_head++] = ch;
@@ -1316,6 +1316,7 @@
 			spin_unlock_irqrestore(&info->slock, flags);
 		}
 	}
+	return 1;
 }
 
 
