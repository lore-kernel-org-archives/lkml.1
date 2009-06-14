Return-Path: <linux-kernel-owner+w=401wt.eu-S1760874AbZFNMEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760874AbZFNMEZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 08:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758672AbZFNMBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 08:01:39 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:52685 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758736AbZFNMBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 08:01:37 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 11/17] Blackfin: convert termios to asm-generic
Date: Sun, 14 Jun 2009 08:01:12 -0400
Message-Id: <1244980878-2124-12-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244980878-2124-1-git-send-email-vapier@gentoo.org>
References: <1244980878-2124-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/termbits.h |  199 +---------------------------------
 arch/blackfin/include/asm/termios.h  |   95 +----------------
 2 files changed, 2 insertions(+), 292 deletions(-)

diff --git a/arch/blackfin/include/asm/termbits.h b/arch/blackfin/include/asm/termbits.h
index f37feb7..3935b10 100644
--- a/arch/blackfin/include/asm/termbits.h
+++ b/arch/blackfin/include/asm/termbits.h
@@ -1,198 +1 @@
-#ifndef __ARCH_BFIN_TERMBITS_H__
-#define __ARCH_BFIN_TERMBITS_H__
-
-#include <linux/posix_types.h>
-
-typedef unsigned char cc_t;
-typedef unsigned int speed_t;
-typedef unsigned int tcflag_t;
-
-#define NCCS 19
-struct termios {
-	tcflag_t c_iflag;	/* input mode flags */
-	tcflag_t c_oflag;	/* output mode flags */
-	tcflag_t c_cflag;	/* control mode flags */
-	tcflag_t c_lflag;	/* local mode flags */
-	cc_t c_line;		/* line discipline */
-	cc_t c_cc[NCCS];	/* control characters */
-};
-
-struct termios2 {
-	tcflag_t c_iflag;               /* input mode flags */
-	tcflag_t c_oflag;               /* output mode flags */
-	tcflag_t c_cflag;               /* control mode flags */
-	tcflag_t c_lflag;               /* local mode flags */
-	cc_t c_line;                    /* line discipline */
-	cc_t c_cc[NCCS];                /* control characters */
-	speed_t c_ispeed;               /* input speed */
-	speed_t c_ospeed;               /* output speed */
-};
-
-struct ktermios {
-	tcflag_t c_iflag;               /* input mode flags */
-	tcflag_t c_oflag;               /* output mode flags */
-	tcflag_t c_cflag;               /* control mode flags */
-	tcflag_t c_lflag;               /* local mode flags */
-	cc_t c_line;                    /* line discipline */
-	cc_t c_cc[NCCS];                /* control characters */
-	speed_t c_ispeed;               /* input speed */
-	speed_t c_ospeed;               /* output speed */
-};
-
-/* c_cc characters */
-#define VINTR 0
-#define VQUIT 1
-#define VERASE 2
-#define VKILL 3
-#define VEOF 4
-#define VTIME 5
-#define VMIN 6
-#define VSWTC 7
-#define VSTART 8
-#define VSTOP 9
-#define VSUSP 10
-#define VEOL 11
-#define VREPRINT 12
-#define VDISCARD 13
-#define VWERASE 14
-#define VLNEXT 15
-#define VEOL2 16
-
-/* c_iflag bits */
-#define IGNBRK	0000001
-#define BRKINT	0000002
-#define IGNPAR	0000004
-#define PARMRK	0000010
-#define INPCK	0000020
-#define ISTRIP	0000040
-#define INLCR	0000100
-#define IGNCR	0000200
-#define ICRNL	0000400
-#define IUCLC	0001000
-#define IXON	0002000
-#define IXANY	0004000
-#define IXOFF	0010000
-#define IMAXBEL	0020000
-#define IUTF8	0040000
-
-/* c_oflag bits */
-#define OPOST	0000001
-#define OLCUC	0000002
-#define ONLCR	0000004
-#define OCRNL	0000010
-#define ONOCR	0000020
-#define ONLRET	0000040
-#define OFILL	0000100
-#define OFDEL	0000200
-#define NLDLY	0000400
-#define   NL0	0000000
-#define   NL1	0000400
-#define CRDLY	0003000
-#define   CR0	0000000
-#define   CR1	0001000
-#define   CR2	0002000
-#define   CR3	0003000
-#define TABDLY	0014000
-#define   TAB0	0000000
-#define   TAB1	0004000
-#define   TAB2	0010000
-#define   TAB3	0014000
-#define   XTABS	0014000
-#define BSDLY	0020000
-#define   BS0	0000000
-#define   BS1	0020000
-#define VTDLY	0040000
-#define   VT0	0000000
-#define   VT1	0040000
-#define FFDLY	0100000
-#define   FF0	0000000
-#define   FF1	0100000
-
-/* c_cflag bit meaning */
-#define CBAUD	0010017
-#define  B0	0000000		/* hang up */
-#define  B50	0000001
-#define  B75	0000002
-#define  B110	0000003
-#define  B134	0000004
-#define  B150	0000005
-#define  B200	0000006
-#define  B300	0000007
-#define  B600	0000010
-#define  B1200	0000011
-#define  B1800	0000012
-#define  B2400	0000013
-#define  B4800	0000014
-#define  B9600	0000015
-#define  B19200	0000016
-#define  B38400	0000017
-#define EXTA B19200
-#define EXTB B38400
-#define CSIZE	0000060
-#define   CS5	0000000
-#define   CS6	0000020
-#define   CS7	0000040
-#define   CS8	0000060
-#define CSTOPB	0000100
-#define CREAD	0000200
-#define PARENB	0000400
-#define PARODD	0001000
-#define HUPCL	0002000
-#define CLOCAL	0004000
-#define CBAUDEX 0010000
-#define BOTHER	0010000
-#define    B57600 0010001
-#define   B115200 0010002
-#define   B230400 0010003
-#define   B460800 0010004
-#define   B500000 0010005
-#define   B576000 0010006
-#define   B921600 0010007
-#define  B1000000 0010010
-#define  B1152000 0010011
-#define  B1500000 0010012
-#define  B2000000 0010013
-#define  B2500000 0010014
-#define  B3000000 0010015
-#define  B3500000 0010016
-#define  B4000000 0010017
-#define CIBAUD	  002003600000	/* input baud rate */
-#define CMSPAR	  010000000000	/* mark or space (stick) parity */
-#define CRTSCTS	  020000000000	/* flow control */
-
-#define IBSHIFT	16	/* Shift from CBAUD to CIBAUD */
-
-/* c_lflag bits */
-#define ISIG	0000001
-#define ICANON	0000002
-#define XCASE	0000004
-#define ECHO	0000010
-#define ECHOE	0000020
-#define ECHOK	0000040
-#define ECHONL	0000100
-#define NOFLSH	0000200
-#define TOSTOP	0000400
-#define ECHOCTL	0001000
-#define ECHOPRT	0002000
-#define ECHOKE	0004000
-#define FLUSHO	0010000
-#define PENDIN	0040000
-#define IEXTEN	0100000
-
-/* tcflow() and TCXONC use these */
-#define	TCOOFF		0
-#define	TCOON		1
-#define	TCIOFF		2
-#define	TCION		3
-
-/* tcflush() and TCFLSH use these */
-#define	TCIFLUSH	0
-#define	TCOFLUSH	1
-#define	TCIOFLUSH	2
-
-/* tcsetattr uses these */
-#define	TCSANOW		0
-#define	TCSADRAIN	1
-#define	TCSAFLUSH	2
-
-#endif				/* __ARCH_BFIN_TERMBITS_H__ */
+#include <asm-generic/termbits.h>
diff --git a/arch/blackfin/include/asm/termios.h b/arch/blackfin/include/asm/termios.h
index d50d063..280d78a 100644
--- a/arch/blackfin/include/asm/termios.h
+++ b/arch/blackfin/include/asm/termios.h
@@ -1,94 +1 @@
-#ifndef __BFIN_TERMIOS_H__
-#define __BFIN_TERMIOS_H__
-
-#include <asm/termbits.h>
-#include <asm/ioctls.h>
-
-struct winsize {
-	unsigned short ws_row;
-	unsigned short ws_col;
-	unsigned short ws_xpixel;
-	unsigned short ws_ypixel;
-};
-
-#define NCC 8
-struct termio {
-	unsigned short c_iflag;	/* input mode flags */
-	unsigned short c_oflag;	/* output mode flags */
-	unsigned short c_cflag;	/* control mode flags */
-	unsigned short c_lflag;	/* local mode flags */
-	unsigned char c_line;	/* line discipline */
-	unsigned char c_cc[NCC];	/* control characters */
-};
-
-/* modem lines */
-#define TIOCM_LE	0x001
-#define TIOCM_DTR	0x002
-#define TIOCM_RTS	0x004
-#define TIOCM_ST	0x008
-#define TIOCM_SR	0x010
-#define TIOCM_CTS	0x020
-#define TIOCM_CAR	0x040
-#define TIOCM_RNG	0x080
-#define TIOCM_DSR	0x100
-#define TIOCM_CD	TIOCM_CAR
-#define TIOCM_RI	TIOCM_RNG
-#define TIOCM_OUT1	0x2000
-#define TIOCM_OUT2	0x4000
-#define TIOCM_LOOP	0x8000
-
-/* ioctl (fd, TIOCSERGETLSR, &result) where result may be as below */
-
-#ifdef __KERNEL__
-
-/*	intr=^C		quit=^\		erase=del	kill=^U
-	eof=^D		vtime=\0	vmin=\1		sxtc=\0
-	start=^Q	stop=^S		susp=^Z		eol=\0
-	reprint=^R	discard=^U	werase=^W	lnext=^V
-	eol2=\0
-*/
-#define INIT_C_CC "\003\034\177\025\004\0\1\0\021\023\032\0\022\017\027\026\0"
-
-/*
- * Translate a "termio" structure into a "termios". Ugh.
- */
-#define SET_LOW_TERMIOS_BITS(termios, termio, x) { \
-	unsigned short __tmp; \
-	get_user(__tmp,&(termio)->x); \
-	*(unsigned short *) &(termios)->x = __tmp; \
-}
-
-#define user_termio_to_kernel_termios(termios, termio) \
-({ \
-	SET_LOW_TERMIOS_BITS(termios, termio, c_iflag); \
-	SET_LOW_TERMIOS_BITS(termios, termio, c_oflag); \
-	SET_LOW_TERMIOS_BITS(termios, termio, c_cflag); \
-	SET_LOW_TERMIOS_BITS(termios, termio, c_lflag); \
-	copy_from_user((termios)->c_cc, (termio)->c_cc, NCC); \
-})
-
-/*
- * Translate a "termios" structure into a "termio". Ugh.
- */
-#define kernel_termios_to_user_termio(termio, termios) \
-({ \
-	put_user((termios)->c_iflag, &(termio)->c_iflag); \
-	put_user((termios)->c_oflag, &(termio)->c_oflag); \
-	put_user((termios)->c_cflag, &(termio)->c_cflag); \
-	put_user((termios)->c_lflag, &(termio)->c_lflag); \
-	put_user((termios)->c_line,  &(termio)->c_line); \
-	copy_to_user((termio)->c_cc, (termios)->c_cc, NCC); \
-})
-
-#define user_termios_to_kernel_termios(k, u) \
-	copy_from_user(k, u, sizeof(struct termios2))
-#define kernel_termios_to_user_termios(u, k) \
-	copy_to_user(u, k, sizeof(struct termios2))
-#define user_termios_to_kernel_termios_1(k, u) \
-	copy_from_user(k, u, sizeof(struct termios))
-#define kernel_termios_to_user_termios_1(u, k) \
-	copy_to_user(u, k, sizeof(struct termios))
-
-#endif				/* __KERNEL__ */
-
-#endif				/* __BFIN_TERMIOS_H__ */
+#include <asm-generic/termios.h>
-- 
1.6.3.1

