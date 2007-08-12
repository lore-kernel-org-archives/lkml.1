Return-Path: <linux-kernel-owner+w=401wt.eu-S934105AbXHLJrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934105AbXHLJrj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 05:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764919AbXHLJoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 05:44:00 -0400
Received: from europa.telenet-ops.be ([195.130.137.75]:40348 "EHLO
	europa.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758905AbXHLJnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 05:43:46 -0400
Message-Id: <20070812094118.726875719@mail.of.borg>
References: <20070812094050.522858761@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sun, 12 Aug 2007 11:40:56 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@redhat.com>
Subject: [patch 06/10] m68k: Enable arbitary speed tty support
Content-Disposition: inline; filename=m68k-arbitary-speed-tty-support.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Add the needed constants and defines to activate the existing code. 

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 include/asm-m68k/ioctls.h   |    4 ++++
 include/asm-m68k/termbits.h |    5 ++++-
 include/asm-m68k/termios.h  |    6 ++++--
 3 files changed, 12 insertions(+), 3 deletions(-)

--- a/include/asm-m68k/ioctls.h
+++ b/include/asm-m68k/ioctls.h
@@ -46,6 +46,10 @@
 #define TIOCSBRK	0x5427  /* BSD compatibility */
 #define TIOCCBRK	0x5428  /* BSD compatibility */
 #define TIOCGSID	0x5429  /* Return the session ID of FD */
+#define TCGETS2		_IOR('T',0x2A, struct termios2)
+#define TCSETS2		_IOW('T',0x2B, struct termios2)
+#define TCSETSW2	_IOW('T',0x2C, struct termios2)
+#define TCSETSF2	_IOW('T',0x2D, struct termios2)
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
 
--- a/include/asm-m68k/termbits.h
+++ b/include/asm-m68k/termbits.h
@@ -141,6 +141,7 @@ struct ktermios {
 #define HUPCL	0002000
 #define CLOCAL	0004000
 #define CBAUDEX 0010000
+#define    BOTHER 0010000
 #define    B57600 0010001
 #define   B115200 0010002
 #define   B230400 0010003
@@ -156,10 +157,12 @@ struct ktermios {
 #define  B3000000 0010015
 #define  B3500000 0010016
 #define  B4000000 0010017
-#define CIBAUD	  002003600000	/* input baud rate (not used) */
+#define CIBAUD	  002003600000		/* input baud rate */
 #define CMSPAR	  010000000000		/* mark or space (stick) parity */
 #define CRTSCTS	  020000000000		/* flow control */
 
+#define IBSHIFT	16			/* Shift from CBAUD to CIBAUD */
+
 /* c_lflag bits */
 #define ISIG	0000001
 #define ICANON	0000002
--- a/include/asm-m68k/termios.h
+++ b/include/asm-m68k/termios.h
@@ -82,8 +82,10 @@ struct termio {
 	copy_to_user((termio)->c_cc, (termios)->c_cc, NCC); \
 })
 
-#define user_termios_to_kernel_termios(k, u) copy_from_user(k, u, sizeof(struct termios))
-#define kernel_termios_to_user_termios(u, k) copy_to_user(u, k, sizeof(struct termios))
+#define user_termios_to_kernel_termios(k, u) copy_from_user(k, u, sizeof(struct termios2))
+#define kernel_termios_to_user_termios(u, k) copy_to_user(u, k, sizeof(struct termios2))
+#define user_termios_to_kernel_termios_1(k, u) copy_from_user(k, u, sizeof(struct termios))
+#define kernel_termios_to_user_termios_1(u, k) copy_to_user(u, k, sizeof(struct termios))
 
 #endif	/* __KERNEL__ */
 

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

