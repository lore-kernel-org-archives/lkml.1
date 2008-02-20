Return-Path: <linux-kernel-owner+w=401wt.eu-S934598AbYBTUse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934598AbYBTUse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:48:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760908AbYBTUsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:48:25 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57352 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757176AbYBTUsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:48:24 -0500
Date: Wed, 20 Feb 2008 20:39:22 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] 68360serial: Note that there isn't any info->mcr locking
Message-ID: <20080220203922.2015195a@core>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Noticed while auditing the code for the BKL elimination project

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc2-mm1/drivers/serial/68360serial.c linux-2.6.25-rc2-mm1/drivers/serial/68360serial.c
--- linux.vanilla-2.6.25-rc2-mm1/drivers/serial/68360serial.c	2008-02-19 11:01:44.000000000 +0000
+++ linux-2.6.25-rc2-mm1/drivers/serial/68360serial.c	2008-02-20 11:52:17.000000000 +0000
@@ -1281,7 +1281,7 @@
 
 	if (tty->flags & (1 << TTY_IO_ERROR))
 		return -EIO;
-
+	/* FIXME: locking on info->mcr */
  	if (set & TIOCM_RTS)
  		info->mcr |= UART_MCR_RTS;
  	if (set & TIOCM_DTR)
