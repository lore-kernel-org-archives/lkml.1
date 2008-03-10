Return-Path: <linux-kernel-owner+w=401wt.eu-S1753279AbYCJNiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbYCJNiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 09:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492AbYCJNh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 09:37:59 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39604 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750857AbYCJNh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 09:37:59 -0400
Date: Mon, 10 Mar 2008 13:24:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: torvalds@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] riscom8: Fix hang on load
Message-ID: <20080310132449.56ef57e9@core>
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

This has been around for a while but nobody reported it until recently.
Resubmitting the fix as it's appropriate for 2.6.25

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc2-mm1/drivers/char/riscom8.c linux-2.6.25-rc2-mm1/drivers/char/riscom8.c
--- linux.vanilla-2.6.25-rc2-mm1/drivers/char/riscom8.c	2008-02-19 11:03:00.000000000 +0000
+++ linux-2.6.25-rc2-mm1/drivers/char/riscom8.c	2008-02-20 22:00:16.000000000 +0000
@@ -1620,14 +1617,8 @@
 
 static void rc_release_drivers(void)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&riscom_lock, flags);
-
 	tty_unregister_driver(riscom_driver);
 	put_tty_driver(riscom_driver);
-
-	spin_unlock_irqrestore(&riscom_lock, flags);
 }
 
 #ifndef MODULE
