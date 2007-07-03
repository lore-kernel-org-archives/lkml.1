Return-Path: <linux-kernel-owner+w=401wt.eu-S1758043AbXGCOQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043AbXGCOQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 10:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758093AbXGCOQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 10:16:23 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57137 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757471AbXGCOQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 10:16:22 -0400
Date: Tue, 3 Jul 2007 15:22:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH] stallion: Remove unneeded lock_kernel
Message-ID: <20070703152201.5a8dc86d@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.22-rc6-mm1/drivers/char/stallion.c linux-2.6.22-rc6-mm1/drivers/char/stallion.c
--- linux.vanilla-2.6.22-rc6-mm1/drivers/char/stallion.c	2007-07-02 20:50:11.000000000 +0100
+++ linux-2.6.22-rc6-mm1/drivers/char/stallion.c	2007-07-02 21:06:25.000000000 +0100
@@ -1788,7 +1788,6 @@
 	if (tty == NULL)
 		return;
 
-	lock_kernel();
 	if (test_bit(ASYI_TXLOW, &portp->istate))
 		tty_wakeup(tty);
 
@@ -1802,7 +1801,6 @@
 			if (portp->flags & ASYNC_CHECK_CD)
 				tty_hangup(tty);	/* FIXME: module removal race here - AKPM */
 	}
-	unlock_kernel();
 }
 
 /*****************************************************************************/
