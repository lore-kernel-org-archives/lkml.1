Return-Path: <linux-kernel-owner+w=401wt.eu-S935009AbXEWQ2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935009AbXEWQ2K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 12:28:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760721AbXEWQ14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 12:27:56 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59358 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760478AbXEWQ1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 12:27:54 -0400
Date: Wed, 23 May 2007 17:32:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, dev-etrax@axis.com, linux-kernel@vger.kernel.org
Subject: [PATCH] etrax: Enable arbitary speed setting on tty ports
Message-ID: <20070523173243.70400fe4@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add the needed constants and bits. The actual code is already in the tty
layer and turned on by the definitions

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc1-mm1/include/asm-cris/ioctls.h linux-2.6.22-rc1-mm1/include/asm-cris/ioctls.h
--- linux.vanilla-2.6.22-rc1-mm1/include/asm-cris/ioctls.h	2007-04-30 10:48:14.000000000 +0100
+++ linux-2.6.22-rc1-mm1/include/asm-cris/ioctls.h	2007-05-23 16:29:31.018374736 +0100
@@ -48,6 +48,10 @@
 #define TIOCSBRK	0x5427  /* BSD compatibility */
 #define TIOCCBRK	0x5428  /* BSD compatibility */
 #define TIOCGSID	0x5429  /* Return the session ID of FD */
+#define TCGETS2		_IOR('T',0x2A, struct termios2)
+#define TCSETS2		_IOW('T',0x2B, struct termios2)
+#define TCSETSW2	_IOW('T',0x2C, struct termios2)
+#define TCSETSF2	_IOW('T',0x2D, struct termios2)
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
 
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc1-mm1/include/asm-cris/termbits.h linux-2.6.22-rc1-mm1/include/asm-cris/termbits.h
--- linux.vanilla-2.6.22-rc1-mm1/include/asm-cris/termbits.h	2007-04-30 10:48:14.000000000 +0100
+++ linux-2.6.22-rc1-mm1/include/asm-cris/termbits.h	2007-05-23 16:29:08.727763424 +0100
@@ -155,6 +155,7 @@
 #define HUPCL	0002000
 #define CLOCAL	0004000
 #define CBAUDEX 0010000
+#define  BOTHER  0010000
 #define  B57600  0010001
 #define  B115200 0010002
 #define  B230400 0010003
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc1-mm1/include/asm-cris/termios.h linux-2.6.22-rc1-mm1/include/asm-cris/termios.h
--- linux.vanilla-2.6.22-rc1-mm1/include/asm-cris/termios.h	2007-04-30 11:00:07.000000000 +0100
+++ linux-2.6.22-rc1-mm1/include/asm-cris/termios.h	2007-05-23 16:30:07.115887080 +0100
@@ -81,8 +81,10 @@
 	copy_to_user((termio)->c_cc, (termios)->c_cc, NCC); \
 })
 
-#define user_termios_to_kernel_termios(k, u) copy_from_user(k, u, sizeof(struct termios))
-#define kernel_termios_to_user_termios(u, k) copy_to_user(u, k, sizeof(struct termios))
+#define user_termios_to_kernel_termios(k, u) copy_from_user(k, u, sizeof(struct termios2))
+#define kernel_termios_to_user_termios(u, k) copy_to_user(u, k, sizeof(struct termios2))
+#define user_termios_to_kernel_termios_1(k, u) copy_from_user(k, u, sizeof(struct termios))
+#define kernel_termios_to_user_termios_1(u, k) copy_to_user(u, k, sizeof(struct termios))
 
 #endif	/* __KERNEL__ */
 
