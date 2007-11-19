Return-Path: <linux-kernel-owner+w=401wt.eu-S1754579AbXKSMyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbXKSMyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 07:54:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbXKSMyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 07:54:31 -0500
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:2275 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbXKSMya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 07:54:30 -0500
Date: Mon, 19 Nov 2007 13:54:15 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 3/3] tty: s390 support for termios2.
Message-ID: <20071119125415.GC8623@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Backend for s390.

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

 include/asm-s390/ioctls.h   |    4 ++++
 include/asm-s390/termbits.h |    5 ++++-
 include/asm-s390/termios.h  |    3 +++
 3 files changed, 11 insertions(+), 1 deletion(-)

Index: linux-2.6/include/asm-s390/ioctls.h
===================================================================
--- linux-2.6.orig/include/asm-s390/ioctls.h
+++ linux-2.6/include/asm-s390/ioctls.h
@@ -54,6 +54,10 @@
 #define TIOCSBRK	0x5427  /* BSD compatibility */
 #define TIOCCBRK	0x5428  /* BSD compatibility */
 #define TIOCGSID	0x5429  /* Return the session ID of FD */
+#define TCGETS2		_IOR('T',0x2A, struct termios2)
+#define TCSETS2		_IOW('T',0x2B, struct termios2)
+#define TCSETSW2	_IOW('T',0x2C, struct termios2)
+#define TCSETSF2	_IOW('T',0x2D, struct termios2)
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
 
Index: linux-2.6/include/asm-s390/termbits.h
===================================================================
--- linux-2.6.orig/include/asm-s390/termbits.h
+++ linux-2.6/include/asm-s390/termbits.h
@@ -148,6 +148,7 @@ struct ktermios {
 #define HUPCL	0002000
 #define CLOCAL	0004000
 #define CBAUDEX 0010000
+#define  BOTHER  0010000
 #define  B57600  0010001
 #define  B115200 0010002
 #define  B230400 0010003
@@ -163,10 +164,12 @@ struct ktermios {
 #define  B3000000 0010015
 #define  B3500000 0010016
 #define  B4000000 0010017
-#define CIBAUD	  002003600000	/* input baud rate (not used) */
+#define CIBAUD	  002003600000	/* input baud rate */
 #define CMSPAR	  010000000000		/* mark or space (stick) parity */
 #define CRTSCTS	  020000000000		/* flow control */
 
+#define IBSHIFT	  16		/* Shift from CBAUD to CIBAUD */
+
 /* c_lflag bits */
 #define ISIG	0000001
 #define ICANON	0000002
Index: linux-2.6/include/asm-s390/termios.h
===================================================================
--- linux-2.6.orig/include/asm-s390/termios.h
+++ linux-2.6/include/asm-s390/termios.h
@@ -57,6 +57,9 @@ struct termio {
 */
 #define INIT_C_CC "\003\034\177\025\004\0\1\0\021\023\032\0\022\017\027\026\0"
 
+#define user_termios_to_kernel_termios(k, u) copy_from_user(k, u, sizeof(struct termios2))
+#define kernel_termios_to_user_termios(u, k) copy_to_user(u, k, sizeof(struct termios2))
+
 #include <asm-generic/termios.h>
 
 #endif	/* __KERNEL__ */
