Return-Path: <linux-kernel-owner+w=401wt.eu-S1756884AbYHKT2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbYHKT2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 15:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbYHKT2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 15:28:33 -0400
Received: from smtp05.msg.oleane.net ([62.161.4.5]:54647 "EHLO
	smtp05.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbYHKT2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 15:28:32 -0400
X-Greylist: delayed 1769 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Aug 2008 15:28:32 EDT
From: "Tosoni" <jp.tosoni@acksys.fr>
To: "'Laurent Pinchart'" <laurentp@cse-semaphore.com>,
       "'Aristeu Rozanski'" <arozansk@redhat.com>
Cc: <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1] 8250: add support for DTR/DSR hardware flow control
Date: Thu, 7 Aug 2008 14:54:05 +0200
Message-ID: <000f01c8f88c$ad29d950$2e01a8c0@acksys.local>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0010_01C8F89D.70B2A950"
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook CWS, Build 9.0.2416 (9.0.2910.0)
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Importance: Normal
In-Reply-To: <200808071032.16709.laurentp@cse-semaphore.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0010_01C8F89D.70B2A950
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

In my opinion, DSR/DTR is another (wrong) way to do RTS/CTS flow control, so
I would have it implemented in setserial as a modifier to the CRTSCTS flag.

About a RS485 ioctl: could you consider the attached files which are already
in the Linux kernel (in include/asm-cris).
They define a TIOCSERSETRS485 (ioctl.h), and the data structure (rs485.h)
with allows to specify timings. Sounds just like what we want ?

JP Tosoni

> -----Original Message-----
> From: linux-serial-owner@vger.kernel.org
> [mailto:linux-serial-owner@vger.kernel.org]On Behalf Of
> Laurent Pinchart
> Sent: Thursday, August 07, 2008 10:32 AM
> To: Aristeu Rozanski
> Cc: linux-serial@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v1] 8250: add support for DTR/DSR hardware flow
> control
>
>
> Hi,
>
> On Wednesday 06 August 2008, Aristeu Rozanski wrote:
> > This patch adds support for DTR/DSR hardware flow control
> on 8250 driver on
> > x86 machines. It's done by adding a CDTRDSR flag to work
> just like CRTSCTS,
> > which is not done on other architectures on purpose (so
> each maintainer can
> > allocate it).
>
> It's funny, serial flow control hasn't been discussed for a
> long time, and you're the third person to start a flow
> control related thread on this mailing list in a few days.
>
> > This patch was tested with success with a serial printer
> configured with a
> > small buffer and DTR/DSR flow control.
> >
> > This is based on the work of Michael Westermann
> > (http://lkml.org/lkml/2007/8/31/133)
> >
> > Comments more than welcome.
>
> Please read the '[PATCH/RFC] 8250: Auto RS485 direction
> control' thread for background information. In a nutshell we
> need more than just CTS/RTS and DTR/DSR, and we don't have
> enough c_cflags bits. We will probably have to create a new ioctl.
>
> Best regards,
>
> --
> Laurent Pinchart
> CSE Semaphore Belgium
>
> Chaussee de Bruxelles, 732A
> B-1410 Waterloo
> Belgium
>
> T +32 (2) 387 42 59
> F +32 (2) 387 42 75
>

------=_NextPart_000_0010_01C8F89D.70B2A950
Content-Type: text/plain;
	name="ioctls.h"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="ioctls.h"

#ifndef __ARCH_CRIS_IOCTLS_H__=0A=
#define __ARCH_CRIS_IOCTLS_H__=0A=
=0A=
/* verbatim copy of asm-i386/ioctls.h */=0A=
=0A=
#include <asm/ioctl.h>=0A=
=0A=
/* 0x54 is just a magic number to make these relatively unique ('T') */=0A=
=0A=
#define TCGETS		0x5401=0A=
#define TCSETS		0x5402=0A=
#define TCSETSW		0x5403=0A=
#define TCSETSF		0x5404=0A=
#define TCGETA		0x5405=0A=
#define TCSETA		0x5406=0A=
#define TCSETAW		0x5407=0A=
#define TCSETAF		0x5408=0A=
#define TCSBRK		0x5409=0A=
#define TCXONC		0x540A=0A=
#define TCFLSH		0x540B=0A=
#define TIOCEXCL	0x540C=0A=
#define TIOCNXCL	0x540D=0A=
#define TIOCSCTTY	0x540E=0A=
#define TIOCGPGRP	0x540F=0A=
#define TIOCSPGRP	0x5410=0A=
#define TIOCOUTQ	0x5411=0A=
#define TIOCSTI		0x5412=0A=
#define TIOCGWINSZ	0x5413=0A=
#define TIOCSWINSZ	0x5414=0A=
#define TIOCMGET	0x5415=0A=
#define TIOCMBIS	0x5416=0A=
#define TIOCMBIC	0x5417=0A=
#define TIOCMSET	0x5418=0A=
#define TIOCGSOFTCAR	0x5419=0A=
#define TIOCSSOFTCAR	0x541A=0A=
#define FIONREAD	0x541B=0A=
#define TIOCINQ		FIONREAD=0A=
#define TIOCLINUX	0x541C=0A=
#define TIOCCONS	0x541D=0A=
#define TIOCGSERIAL	0x541E=0A=
#define TIOCSSERIAL	0x541F=0A=
#define TIOCPKT		0x5420=0A=
#define FIONBIO		0x5421=0A=
#define TIOCNOTTY	0x5422=0A=
#define TIOCSETD	0x5423=0A=
#define TIOCGETD	0x5424=0A=
#define TCSBRKP		0x5425	/* Needed for POSIX tcsendbreak() */=0A=
#define TIOCSBRK	0x5427  /* BSD compatibility */=0A=
#define TIOCCBRK	0x5428  /* BSD compatibility */=0A=
#define TIOCGSID	0x5429  /* Return the session ID of FD */=0A=
#define TCGETS2		_IOR('T',0x2A, struct termios2)=0A=
#define TCSETS2		_IOW('T',0x2B, struct termios2)=0A=
#define TCSETSW2	_IOW('T',0x2C, struct termios2)=0A=
#define TCSETSF2	_IOW('T',0x2D, struct termios2)=0A=
#define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of =
pty-mux device) */=0A=
#define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */=0A=
=0A=
#define FIONCLEX	0x5450  /* these numbers need to be adjusted. */=0A=
#define FIOCLEX		0x5451=0A=
#define FIOASYNC	0x5452=0A=
#define TIOCSERCONFIG	0x5453=0A=
#define TIOCSERGWILD	0x5454=0A=
#define TIOCSERSWILD	0x5455=0A=
#define TIOCGLCKTRMIOS	0x5456=0A=
#define TIOCSLCKTRMIOS	0x5457=0A=
#define TIOCSERGSTRUCT	0x5458 /* For debugging only */=0A=
#define TIOCSERGETLSR   0x5459 /* Get line status register */=0A=
#define TIOCSERGETMULTI 0x545A /* Get multiport config  */=0A=
#define TIOCSERSETMULTI 0x545B /* Set multiport config */=0A=
=0A=
#define TIOCMIWAIT	0x545C	/* wait for a change on serial input line(s) */=0A=
#define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */=0A=
#define TIOCGHAYESESP   0x545E  /* Get Hayes ESP configuration */=0A=
#define TIOCSHAYESESP   0x545F  /* Set Hayes ESP configuration */=0A=
#define FIOQSIZE	0x5460=0A=
=0A=
#define TIOCSERSETRS485 0x5461  /* enable rs-485 */=0A=
#define TIOCSERWRRS485  0x5462  /* write rs-485 */=0A=
=0A=
/* Used for packet mode */=0A=
#define TIOCPKT_DATA		 0=0A=
#define TIOCPKT_FLUSHREAD	 1=0A=
#define TIOCPKT_FLUSHWRITE	 2=0A=
#define TIOCPKT_STOP		 4=0A=
#define TIOCPKT_START		 8=0A=
#define TIOCPKT_NOSTOP		16=0A=
#define TIOCPKT_DOSTOP		32=0A=
=0A=
#define TIOCSER_TEMT    0x01	/* Transmitter physically empty */=0A=
=0A=
#endif=0A=

------=_NextPart_000_0010_01C8F89D.70B2A950
Content-Type: text/plain;
	name="rs485.h"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="rs485.h"

/* RS-485 structures */=0A=
=0A=
/* RS-485 support */=0A=
/* Used with ioctl() TIOCSERSETRS485 */=0A=
struct rs485_control {=0A=
        unsigned short rts_on_send;=0A=
        unsigned short rts_after_sent;=0A=
        unsigned long delay_rts_before_send;=0A=
        unsigned short enabled;=0A=
#ifdef __KERNEL__=0A=
        int disable_serial_loopback;=0A=
#endif=0A=
};=0A=
=0A=
/* Used with ioctl() TIOCSERWRRS485 */=0A=
struct rs485_write {=0A=
        unsigned short outc_size;=0A=
        unsigned char *outc;=0A=
};=0A=
=0A=

------=_NextPart_000_0010_01C8F89D.70B2A950--

