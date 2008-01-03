Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902AbYACQ5C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbYACQ5C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 11:57:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbYACQ4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 11:56:54 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54528 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752358AbYACQ4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 11:56:53 -0500
Date: Thu, 3 Jan 2008 16:55:07 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] serial: speed setup failure reporting
Message-ID: <20080103165507.3fe5b7a4@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Invalid speeds are forced to 9600. Update the code for this to encode new
style baud rates properly.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc6-mm1/drivers/serial/serial_core.c linux-2.6.24-rc6-mm1/drivers/serial/serial_core.c
--- linux.vanilla-2.6.24-rc6-mm1/drivers/serial/serial_core.c	2008-01-02 16:04:23.000000000 +0000
+++ linux-2.6.24-rc6-mm1/drivers/serial/serial_core.c	2008-01-02 16:17:50.000000000 +0000
@@ -372,7 +372,8 @@
 		 */
 		termios->c_cflag &= ~CBAUD;
 		if (old) {
-			termios->c_cflag |= old->c_cflag & CBAUD;
+			baud = tty_termios_baud_rate(old);
+			tty_termios_encode_baud_rate(termios, baud, baud);
 			old = NULL;
 			continue;
 		}
@@ -381,7 +382,7 @@
 		 * As a last resort, if the quotient is zero,
 		 * default to 9600 bps
 		 */
-		termios->c_cflag |= B9600;
+		tty_termios_encode_baud_rate(termios, 9600, 9600);
 	}
 
 	return 0;
