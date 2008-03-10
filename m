Return-Path: <linux-kernel-owner+w=401wt.eu-S1753273AbYCJWFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273AbYCJWFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 18:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbYCJWFC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 18:05:02 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39197 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751196AbYCJWFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 18:05:01 -0400
Date: Mon, 10 Mar 2008 21:51:17 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] istallion: TIOCG/SSOFTCAR handling removal
Message-ID: <20080310215117.78c41ee9@core>
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

This is handled (and correctly) by the core code so does not belong
incorrectly in the driver.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc3-mm1/drivers/char/istallion.c linux-2.6.25-rc3-mm1/drivers/char/istallion.c
--- linux.vanilla-2.6.25-rc3-mm1/drivers/char/istallion.c	2008-03-10 12:57:52.000000000 +0000
+++ linux-2.6.25-rc3-mm1/drivers/char/istallion.c	2008-03-10 13:19:38.000000000 +0000
@@ -1682,16 +1682,6 @@
 	rc = 0;
 
 	switch (cmd) {
-	case TIOCGSOFTCAR:
-		rc = put_user(((tty->termios->c_cflag & CLOCAL) ? 1 : 0),
-			(unsigned __user *) arg);
-		break;
-	case TIOCSSOFTCAR:
-		if ((rc = get_user(ival, (unsigned __user *) arg)) == 0)
-			tty->termios->c_cflag =
-				(tty->termios->c_cflag & ~CLOCAL) |
-				(ival ? CLOCAL : 0);
-		break;
 	case TIOCGSERIAL:
 		rc = stli_getserial(portp, argp);
 		break;
