Return-Path: <linux-kernel-owner+w=401wt.eu-S1762465AbYFTUXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762465AbYFTUXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760476AbYFTUSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:18:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35171 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760441AbYFTUSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:18:16 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 21/70] termios: Termios defines for other platforms
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:00:52 +0100
Message-ID: <20080620200044.1479.60200.stgit@localhost.localdomain>
In-Reply-To: <20080620195406.1479.12620.stgit@localhost.localdomain>
References: <20080620195406.1479.12620.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

Fix up the termios of the people who have not yet got with the program

Signed-off-by: Alan Cox <alan@redhat.com>
---

 include/asm-avr32/ioctls.h |    4 ++++
 include/asm-frv/ioctls.h   |    4 ++++
 include/asm-frv/termbits.h |    5 ++++-
 3 files changed, 12 insertions(+), 1 deletions(-)


diff --git a/include/asm-avr32/ioctls.h b/include/asm-avr32/ioctls.h
index 0500426..0cf2c0a 100644
--- a/include/asm-avr32/ioctls.h
+++ b/include/asm-avr32/ioctls.h
@@ -47,6 +47,10 @@
 #define TIOCSBRK	0x5427  /* BSD compatibility */
 #define TIOCCBRK	0x5428  /* BSD compatibility */
 #define TIOCGSID	0x5429  /* Return the session ID of FD */
+#define TCGETS2		_IOR('T',0x2A, struct termios2)
+#define TCSETS2		_IOW('T',0x2B, struct termios2)
+#define TCSETSW2	_IOW('T',0x2C, struct termios2)
+#define TCSETSF2	_IOW('T',0x2D, struct termios2)
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
 
diff --git a/include/asm-frv/ioctls.h b/include/asm-frv/ioctls.h
index 341c7dd..d0c30e3 100644
--- a/include/asm-frv/ioctls.h
+++ b/include/asm-frv/ioctls.h
@@ -47,6 +47,10 @@
 #define TIOCSBRK	0x5427  /* BSD compatibility */
 #define TIOCCBRK	0x5428  /* BSD compatibility */
 #define TIOCGSID	0x5429  /* Return the session ID of FD */
+#define TCGETS2		_IOR('T',0x2A, struct termios2)
+#define TCSETS2		_IOW('T',0x2B, struct termios2)
+#define TCSETSW2	_IOW('T',0x2C, struct termios2)
+#define TCSETSF2	_IOW('T',0x2D, struct termios2)
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
 
diff --git a/include/asm-frv/termbits.h b/include/asm-frv/termbits.h
index 74851b4..5568492 100644
--- a/include/asm-frv/termbits.h
+++ b/include/asm-frv/termbits.h
@@ -141,6 +141,7 @@ struct ktermios {
 #define HUPCL	0002000
 #define CLOCAL	0004000
 #define CBAUDEX 0010000
+#define    BOTHER 0010000
 #define    B57600 0010001
 #define   B115200 0010002
 #define   B230400 0010003
@@ -156,11 +157,13 @@ struct ktermios {
 #define  B3000000 0010015
 #define  B3500000 0010016
 #define  B4000000 0010017
-#define CIBAUD	  002003600000	/* input baud rate (not used) */
+#define CIBAUD	  002003600000		/* Input baud rate */
 #define CTVB	  004000000000		/* VisioBraille Terminal flow control */
 #define CMSPAR	  010000000000		/* mark or space (stick) parity */
 #define CRTSCTS	  020000000000		/* flow control */
 
+#define IBSHIFT	16			/* Shift from CBAUD to CIBAUD */
+
 /* c_lflag bits */
 #define ISIG	0000001
 #define ICANON	0000002

