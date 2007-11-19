Return-Path: <linux-kernel-owner+w=401wt.eu-S1756489AbXKSPRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489AbXKSPRA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 10:17:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbXKSPQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 10:16:52 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59858 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753669AbXKSPQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 10:16:52 -0500
Date: Mon, 19 Nov 2007 15:15:08 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] 8250: Enable rate reporting via termios
Message-ID: <20071119151508.3a769354@the-village.bc.nu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc2-mm1/drivers/serial/8250.c linux-2.6.24-rc2-mm1/drivers/serial/8250.c
--- linux.vanilla-2.6.24-rc2-mm1/drivers/serial/8250.c	2007-11-16 17:20:48.000000000 +0000
+++ linux-2.6.24-rc2-mm1/drivers/serial/8250.c	2007-11-16 18:35:29.000000000 +0000
@@ -2173,6 +2176,7 @@
 	}
 	serial8250_set_mctrl(&up->port, up->port.mctrl);
 	spin_unlock_irqrestore(&up->port.lock, flags);
+	tty_termios_encode_baud_rate(termios, baud, baud);
 }
 
 static void
