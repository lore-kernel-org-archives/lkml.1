Return-Path: <linux-kernel-owner+w=401wt.eu-S1764108AbYD2NfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764108AbYD2NfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 09:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756877AbYD2NfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 09:35:10 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51459 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755729AbYD2NfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 09:35:08 -0400
Date: Tue, 29 Apr 2008 14:27:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ip2: switch remaining direct call of ops->flush_buffer
Message-ID: <20080429142714.35c70a54@core>
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

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-mm1/drivers/char/ip2/ip2main.c linux-2.6.25-mm1/drivers/char/ip2/ip2main.c
--- linux.vanilla-2.6.25-mm1/drivers/char/ip2/ip2main.c	2008-04-28 11:36:48.000000000 +0100
+++ linux-2.6.25-mm1/drivers/char/ip2/ip2main.c	2008-04-28 11:46:15.000000000 +0100
@@ -1616,9 +1616,8 @@
 
 	serviceOutgoingFifo ( pCh->pMyBord );
 
-	if ( tty->driver->ops->flush_buffer )
-		tty->driver->ops->flush_buffer(tty);
 	tty_ldisc_flush(tty);
+	tty_driver_flush_buffer(tty);
 	tty->closing = 0;
 	
 	pCh->pTTY = NULL;
