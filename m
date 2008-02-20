Return-Path: <linux-kernel-owner+w=401wt.eu-S935110AbYBTUw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935110AbYBTUw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:52:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765656AbYBTUv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:51:59 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57358 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S934016AbYBTUv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:51:57 -0500
Date: Wed, 20 Feb 2008 20:42:19 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crisv10: prepare for BKL push down
Message-ID: <20080220204219.1f030f2c@core>
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

Just the modem bits this time

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc2-mm1/drivers/serial/crisv10.c linux-2.6.25-rc2-mm1/drivers/serial/crisv10.c
--- linux.vanilla-2.6.25-rc2-mm1/drivers/serial/crisv10.c	2008-02-19 11:03:01.000000000 +0000
+++ linux-2.6.25-rc2-mm1/drivers/serial/crisv10.c	2008-02-20 11:52:24.000000000 +0000
@@ -3581,6 +3581,8 @@
 		unsigned int set, unsigned int clear)
 {
 	struct e100_serial *info = (struct e100_serial *)tty->driver_data;
+	
+	lock_kernel();
 
 	if (clear & TIOCM_RTS)
 		e100_rts(info, 0);
@@ -3601,6 +3603,8 @@
 		e100_ri_out(info, 1);
 	if (set & TIOCM_CD)
 		e100_cd_out(info, 1);
+		
+	unlock_kernel();
 	return 0;
 }
 
@@ -3610,6 +3614,7 @@
 	struct e100_serial *info = (struct e100_serial *)tty->driver_data;
 	unsigned int result;
 
+	lock_kernel();
 	result =
 		(!E100_RTS_GET(info) ? TIOCM_RTS : 0)
 		| (!E100_DTR_GET(info) ? TIOCM_DTR : 0)
@@ -3617,6 +3622,8 @@
 		| (!E100_DSR_GET(info) ? TIOCM_DSR : 0)
 		| (!E100_CD_GET(info) ? TIOCM_CAR : 0)
 		| (!E100_CTS_GET(info) ? TIOCM_CTS : 0);
+		
+	unlock_kernel();
 
 #ifdef SERIAL_DEBUG_IO
 	printk(KERN_DEBUG "ser%i: modem state: %i 0x%08X\n",
