Return-Path: <linux-kernel-owner+w=401wt.eu-S1763206AbXFGPRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763206AbXFGPRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 11:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760920AbXFGPRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 11:17:41 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51159 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760655AbXFGPRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 11:17:40 -0400
Date: Thu, 7 Jun 2007 16:22:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: [PATCH] intel-rng: Undo mess made by an 80 column extremist
Message-ID: <20070607162251.5f291325@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The intel-rng printed a nice well formatted message when the port was
disabled. Someone then came along and blindly trashed it by screwing up a
trim down to 80 columns.

Put it back into the right format and keep the overlong lines as the
result is also MUCH easier to read in this specific case.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc4-mm2/drivers/char/hw_random/intel-rng.c linux-2.6.22-rc4-mm2/drivers/char/hw_random/intel-rng.c
--- linux.vanilla-2.6.22-rc4-mm2/drivers/char/hw_random/intel-rng.c	2007-06-07 14:25:57.000000000 +0100
+++ linux-2.6.22-rc4-mm2/drivers/char/hw_random/intel-rng.c	2007-06-07 14:32:36.000000000 +0100
@@ -296,12 +296,10 @@
 	     (BIOS_CNTL_LOCK_ENABLE_MASK|BIOS_CNTL_WRITE_ENABLE_MASK))
 	    == BIOS_CNTL_LOCK_ENABLE_MASK) {
 		static __initdata /*const*/ char warning[] =
-			KERN_WARNING PFX "Firmware space is locked read-only. "
-			KERN_WARNING PFX "If you can't or\n don't want to "
-			KERN_WARNING PFX "disable this in firmware setup, and "
-			KERN_WARNING PFX "if\n you are certain that your "
-			KERN_WARNING PFX "system has a functional\n RNG, try"
-			KERN_WARNING PFX "using the 'no_fwh_detect' option.\n";
+			KERN_WARNING PFX "Firmware space is locked read-only. If you can't or\n"
+			KERN_WARNING PFX "don't want to disable this in firmware setup, and if\n"
+			KERN_WARNING PFX "you are certain that your system has a functional\n"
+			KERN_WARNING PFX "RNG, try using the 'no_fwh_detect' option.\n";
 
 		if (no_fwh_detect)
 			return -ENODEV;
