Return-Path: <linux-kernel-owner+w=401wt.eu-S1757480AbYCJWLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480AbYCJWLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 18:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757359AbYCJWLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 18:11:31 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47355 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757347AbYCJWLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 18:11:30 -0400
Date: Mon, 10 Mar 2008 21:58:17 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] serial_core: Fix baud handling bug I introduced
Message-ID: <20080310215817.4f311822@core>
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

Dumb bug, not reading the compiler warnings either

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc3-mm1/drivers/serial/serial_core.c linux-2.6.25-rc3-mm1/drivers/serial/serial_core.c
--- linux.vanilla-2.6.25-rc3-mm1/drivers/serial/serial_core.c	2008-03-10 12:57:53.000000000 +0000
+++ linux-2.6.25-rc3-mm1/drivers/serial/serial_core.c	2008-03-10 13:29:43.000000000 +0000
@@ -337,7 +337,7 @@
 		   struct ktermios *old, unsigned int min, unsigned int max)
 {
 	unsigned int try, baud, altbaud = 38400;
-	int hung_up;
+	int hung_up = 0;
 	upf_t flags = port->flags & UPF_SPD_MASK;
 
 	if (flags == UPF_SPD_HI)
