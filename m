Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbXKSO73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbXKSO73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 09:59:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbXKSO7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 09:59:22 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35931 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753159AbXKSO7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 09:59:21 -0500
Date: Mon, 19 Nov 2007 14:57:07 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] rocket: Don't let random users reset the controller
Message-ID: <20071119145707.34a089ce@the-village.bc.nu>
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

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc2-mm1/drivers/char/rocket.c linux-2.6.24-rc2-mm1/drivers/char/rocket.c
--- linux.vanilla-2.6.24-rc2-mm1/drivers/char/rocket.c	2007-11-16 17:55:11.000000000 +0000
+++ linux-2.6.24-rc2-mm1/drivers/char/rocket.c	2007-11-16 18:20:23.000000000 +0000
@@ -1401,6 +1399,9 @@
 {
 	int reset;
 
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	if (copy_from_user(&reset, arg, sizeof (int)))
 		return -EFAULT;
 	if (reset)
