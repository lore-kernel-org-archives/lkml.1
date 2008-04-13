Return-Path: <linux-kernel-owner+w=401wt.eu-S1752768AbYDMRUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbYDMRUs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 13:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbYDMRUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 13:20:40 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39414 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751152AbYDMRUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 13:20:40 -0400
Date: Sun, 13 Apr 2008 18:16:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org
Subject: [PATCH] serial167: switch to int put_char method
Message-ID: <20080413181640.4a4d38ed@core>
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

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm2/drivers/char/serial167.c linux-2.6.25-rc8-mm2/drivers/char/serial167.c
--- linux.vanilla-2.6.25-rc8-mm2/drivers/char/serial167.c	2008-04-13 15:36:53.000000000 +0100
+++ linux-2.6.25-rc8-mm2/drivers/char/serial167.c	2008-04-13 15:41:05.000000000 +0100
@@ -1060,7 +1060,7 @@
 
 }				/* config_setup */
 
-static void cy_put_char(struct tty_struct *tty, unsigned char ch)
+static int cy_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	struct cyclades_port *info = (struct cyclades_port *)tty->driver_data;
 	unsigned long flags;
@@ -1070,7 +1070,7 @@
 #endif
 
 	if (serial_paranoia_check(info, tty->name, "cy_put_char"))
-		return;
+		return 0;
 
 	if (!info->xmit_buf)
 		return;
@@ -1078,13 +1078,14 @@
 	local_irq_save(flags);
 	if (info->xmit_cnt >= PAGE_SIZE - 1) {
 		local_irq_restore(flags);
-		return;
+		return 0;
 	}
 
 	info->xmit_buf[info->xmit_head++] = ch;
 	info->xmit_head &= PAGE_SIZE - 1;
 	info->xmit_cnt++;
 	local_irq_restore(flags);
+	return 1;
 }				/* cy_put_char */
 
 static void cy_flush_chars(struct tty_struct *tty)
