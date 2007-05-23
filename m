Return-Path: <linux-kernel-owner+w=401wt.eu-S935136AbXEWQdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935136AbXEWQdv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 12:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759438AbXEWQdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 12:33:44 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49174 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758032AbXEWQdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 12:33:43 -0400
Date: Wed, 23 May 2007 17:38:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: tony.luck@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH] ia64: Arbitary speed tty ioctl support
Message-ID: <20070523173828.484c813f@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add the needed constants and defines to activate this for the IA64
platform.

Signed-off-by: Alan Cox <alan@redhat.com>


diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc1-mm1/include/asm-ia64/ioctls.h linux-2.6.22-rc1-mm1/include/asm-ia64/ioctls.h
--- linux.vanilla-2.6.22-rc1-mm1/include/asm-ia64/ioctls.h	2007-04-30 10:48:16.000000000 +0100
+++ linux-2.6.22-rc1-mm1/include/asm-ia64/ioctls.h	2007-05-23 16:40:00.942611696 +0100
@@ -53,6 +53,10 @@
 #define TIOCSBRK	0x5427  /* BSD compatibility */
 #define TIOCCBRK	0x5428  /* BSD compatibility */
 #define TIOCGSID	0x5429  /* Return the session ID of FD */
+#define TCGETS2		_IOR('T',0x2A, struct termios2)
+#define TCSETS2		_IOW('T',0x2B, struct termios2)
+#define TCSETSW2	_IOW('T',0x2C, struct termios2)
+#define TCSETSF2	_IOW('T',0x2D, struct termios2)
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
 
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc1-mm1/include/asm-ia64/termbits.h linux-2.6.22-rc1-mm1/include/asm-ia64/termbits.h
--- linux.vanilla-2.6.22-rc1-mm1/include/asm-ia64/termbits.h	2007-04-30 10:48:16.000000000 +0100
+++ linux-2.6.22-rc1-mm1/include/asm-ia64/termbits.h	2007-05-23 16:40:25.281911560 +0100
@@ -138,6 +138,7 @@
 #define HUPCL	0002000
 #define CLOCAL	0004000
 #define CBAUDEX 0010000
+#define    BOTHER 0010000
 #define    B57600 0010001
 #define   B115200 0010002
 #define   B230400 0010003
@@ -153,10 +154,12 @@
 #define  B3000000 0010015
 #define  B3500000 0010016
 #define  B4000000 0010017
-#define CIBAUD	  002003600000	/* input baud rate (not used) */
+#define CIBAUD	  002003600000		/* input baud rate */
 #define CMSPAR	  010000000000		/* mark or space (stick) parity */
 #define CRTSCTS	  020000000000		/* flow control */
 
+#define IBSHIFT	16		/* Shift from CBAUD to CIBAUD */
+
 /* c_lflag bits */
 #define ISIG	0000001
 #define ICANON	0000002
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc1-mm1/include/asm-ia64/termios.h linux-2.6.22-rc1-mm1/include/asm-ia64/termios.h
--- linux.vanilla-2.6.22-rc1-mm1/include/asm-ia64/termios.h	2007-04-30 11:00:07.000000000 +0100
+++ linux-2.6.22-rc1-mm1/include/asm-ia64/termios.h	2007-05-23 16:39:52.016968600 +0100
@@ -87,8 +87,10 @@
 	copy_to_user((termio)->c_cc, (termios)->c_cc, NCC);	\
 })
 
-#define user_termios_to_kernel_termios(k, u) copy_from_user(k, u, sizeof(struct termios))
-#define kernel_termios_to_user_termios(u, k) copy_to_user(u, k, sizeof(struct termios))
+#define user_termios_to_kernel_termios(k, u) copy_from_user(k, u, sizeof(struct termios2))
+#define kernel_termios_to_user_termios(u, k) copy_to_user(u, k, sizeof(struct termios2))
+#define user_termios_to_kernel_termios_1(k, u) copy_from_user(k, u, sizeof(struct termios))
+#define kernel_termios_to_user_termios_1(u, k) copy_to_user(u, k, sizeof(struct termios))
 
 # endif /* __KERNEL__ */
 
