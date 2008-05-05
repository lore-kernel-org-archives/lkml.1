Return-Path: <linux-kernel-owner+w=401wt.eu-S1758372AbYEEOFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758372AbYEEOFj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 10:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753683AbYEEOF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 10:05:28 -0400
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:62540 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754877AbYEEOFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 10:05:23 -0400
Message-ID: <481F145C.1020809@seznam.cz>
Date: Mon, 05 May 2008 16:06:20 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 33/56] microblaze_v2: ioctl support
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz> <8aba2d82c85cd1d5b56de328c1fd080ee51f0211.1209897266.git.monstr@monstr.eu> <c4000ff625bd217f9bb683e3bf8c7193a82bd744.1209897266.git.monstr@monstr.eu> <200805042334.56020.arnd@arndb.de>
In-Reply-To: <200805042334.56020.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fixed it. I use asm-generic version too. ioctl.h and ioctls.h too.

M


>>  include/asm-microblaze/ioctl.h  |   84 +++++++++++++++++++++++++++++++++++
> 
> This is a direct copy of asm-generic/ioctl.h, so just include that
> one instead.
> 
>>  include/asm-microblaze/ioctls.h |   93 +++++++++++++++++++++++++++++++++++++++
> 
> I've already prototyped an asm-generic version of that, which would be the patch
> below.
> 
> 	Arnd <><
> 
> ---
> 
> Consolidate include/asm*/ioctls.h
> 
> Most architectures have an identical implementation of ioctls.h, so we can
> just as well move it to asm-generic. While it should have been defined
> using _IO style macros in the first place, there is enough precendent
> to give up on that now, and just document what every architecture is
> doing already.
> 
> The major difference between architectures at this time is the definition
> of FIOQSIZE, which sometimes conflicts with TIOCGHAYESESP, so I use an
> #ifdef for that.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> Index: linux-2.6/include/asm-arm/ioctls.h
> ===================================================================
> --- linux-2.6.orig/include/asm-arm/ioctls.h
> +++ linux-2.6/include/asm-arm/ioctls.h
> @@ -1,84 +1,6 @@
>  #ifndef __ASM_ARM_IOCTLS_H
>  #define __ASM_ARM_IOCTLS_H
>  
> -#include <asm/ioctl.h>
> -
> -/* 0x54 is just a magic number to make these relatively unique ('T') */
> -
> -#define TCGETS		0x5401
> -#define TCSETS		0x5402
> -#define TCSETSW		0x5403
> -#define TCSETSF		0x5404
> -#define TCGETA		0x5405
> -#define TCSETA		0x5406
> -#define TCSETAW		0x5407
> -#define TCSETAF		0x5408
> -#define TCSBRK		0x5409
> -#define TCXONC		0x540A
> -#define TCFLSH		0x540B
> -#define TIOCEXCL	0x540C
> -#define TIOCNXCL	0x540D
> -#define TIOCSCTTY	0x540E
> -#define TIOCGPGRP	0x540F
> -#define TIOCSPGRP	0x5410
> -#define TIOCOUTQ	0x5411
> -#define TIOCSTI		0x5412
> -#define TIOCGWINSZ	0x5413
> -#define TIOCSWINSZ	0x5414
> -#define TIOCMGET	0x5415
> -#define TIOCMBIS	0x5416
> -#define TIOCMBIC	0x5417
> -#define TIOCMSET	0x5418
> -#define TIOCGSOFTCAR	0x5419
> -#define TIOCSSOFTCAR	0x541A
> -#define FIONREAD	0x541B
> -#define TIOCINQ		FIONREAD
> -#define TIOCLINUX	0x541C
> -#define TIOCCONS	0x541D
> -#define TIOCGSERIAL	0x541E
> -#define TIOCSSERIAL	0x541F
> -#define TIOCPKT		0x5420
> -#define FIONBIO		0x5421
> -#define TIOCNOTTY	0x5422
> -#define TIOCSETD	0x5423
> -#define TIOCGETD	0x5424
> -#define TCSBRKP		0x5425	/* Needed for POSIX tcsendbreak() */
> -#define TIOCSBRK	0x5427  /* BSD compatibility */
> -#define TIOCCBRK	0x5428  /* BSD compatibility */
> -#define TIOCGSID	0x5429  /* Return the session ID of FD */
> -#define TCGETS2		_IOR('T',0x2A, struct termios2)
> -#define TCSETS2		_IOW('T',0x2B, struct termios2)
> -#define TCSETSW2	_IOW('T',0x2C, struct termios2)
> -#define TCSETSF2	_IOW('T',0x2D, struct termios2)
> -#define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
> -#define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
> -
> -#define FIONCLEX	0x5450  /* these numbers need to be adjusted. */
> -#define FIOCLEX		0x5451
> -#define FIOASYNC	0x5452
> -#define TIOCSERCONFIG	0x5453
> -#define TIOCSERGWILD	0x5454
> -#define TIOCSERSWILD	0x5455
> -#define TIOCGLCKTRMIOS	0x5456
> -#define TIOCSLCKTRMIOS	0x5457
> -#define TIOCSERGSTRUCT	0x5458 /* For debugging only */
> -#define TIOCSERGETLSR   0x5459 /* Get line status register */
> -#define TIOCSERGETMULTI 0x545A /* Get multiport config  */
> -#define TIOCSERSETMULTI 0x545B /* Set multiport config */
> -
> -#define TIOCMIWAIT	0x545C	/* wait for a change on serial input line(s) */
> -#define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
> -#define FIOQSIZE	0x545E
> -
> -/* Used for packet mode */
> -#define TIOCPKT_DATA		 0
> -#define TIOCPKT_FLUSHREAD	 1
> -#define TIOCPKT_FLUSHWRITE	 2
> -#define TIOCPKT_STOP		 4
> -#define TIOCPKT_START		 8
> -#define TIOCPKT_NOSTOP		16
> -#define TIOCPKT_DOSTOP		32
> -
> -#define TIOCSER_TEMT	0x01	/* Transmitter physically empty */
> +#include <asm-generic/ioctls.h>
>  
>  #endif
> Index: linux-2.6/include/asm-avr32/ioctls.h
> ===================================================================
> --- linux-2.6.orig/include/asm-avr32/ioctls.h
> +++ linux-2.6/include/asm-avr32/ioctls.h
> @@ -1,83 +1,15 @@
>  #ifndef __ASM_AVR32_IOCTLS_H
>  #define __ASM_AVR32_IOCTLS_H
>  
> -#include <asm/ioctl.h>
> -
> -/* 0x54 is just a magic number to make these relatively unique ('T') */
> -
> -#define TCGETS		0x5401
> -#define TCSETS		0x5402 /* Clashes with SNDCTL_TMR_START sound ioctl */
> -#define TCSETSW		0x5403
> -#define TCSETSF		0x5404
> -#define TCGETA		0x5405
> -#define TCSETA		0x5406
> -#define TCSETAW		0x5407
> -#define TCSETAF		0x5408
> -#define TCSBRK		0x5409
> -#define TCXONC		0x540A
> -#define TCFLSH		0x540B
> -#define TIOCEXCL	0x540C
> -#define TIOCNXCL	0x540D
> -#define TIOCSCTTY	0x540E
> -#define TIOCGPGRP	0x540F
> -#define TIOCSPGRP	0x5410
> -#define TIOCOUTQ	0x5411
> -#define TIOCSTI		0x5412
> -#define TIOCGWINSZ	0x5413
> -#define TIOCSWINSZ	0x5414
> -#define TIOCMGET	0x5415
> -#define TIOCMBIS	0x5416
> -#define TIOCMBIC	0x5417
> -#define TIOCMSET	0x5418
> -#define TIOCGSOFTCAR	0x5419
> -#define TIOCSSOFTCAR	0x541A
> -#define FIONREAD	0x541B
> -#define TIOCINQ		FIONREAD
> -#define TIOCLINUX	0x541C
> -#define TIOCCONS	0x541D
> -#define TIOCGSERIAL	0x541E
> -#define TIOCSSERIAL	0x541F
> -#define TIOCPKT		0x5420
> -#define FIONBIO		0x5421
> -#define TIOCNOTTY	0x5422
> -#define TIOCSETD	0x5423
> -#define TIOCGETD	0x5424
> -#define TCSBRKP		0x5425	/* Needed for POSIX tcsendbreak() */
> -/* #define TIOCTTYGSTRUCT 0x5426 - Former debugging-only ioctl */
> -#define TIOCSBRK	0x5427  /* BSD compatibility */
> -#define TIOCCBRK	0x5428  /* BSD compatibility */
> -#define TIOCGSID	0x5429  /* Return the session ID of FD */
> -#define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
> -#define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
> -
> -#define FIONCLEX	0x5450
> -#define FIOCLEX		0x5451
> -#define FIOASYNC	0x5452
> -#define TIOCSERCONFIG	0x5453
> -#define TIOCSERGWILD	0x5454
> -#define TIOCSERSWILD	0x5455
> -#define TIOCGLCKTRMIOS	0x5456
> -#define TIOCSLCKTRMIOS	0x5457
> -#define TIOCSERGSTRUCT	0x5458 /* For debugging only */
> -#define TIOCSERGETLSR   0x5459 /* Get line status register */
> -#define TIOCSERGETMULTI 0x545A /* Get multiport config  */
> -#define TIOCSERSETMULTI 0x545B /* Set multiport config */
> -
> -#define TIOCMIWAIT	0x545C	/* wait for a change on serial input line(s) */
> -#define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
>  #define TIOCGHAYESESP   0x545E  /* Get Hayes ESP configuration */
>  #define TIOCSHAYESESP   0x545F  /* Set Hayes ESP configuration */
>  #define FIOQSIZE	0x5460
>  
> -/* Used for packet mode */
> -#define TIOCPKT_DATA		 0
> -#define TIOCPKT_FLUSHREAD	 1
> -#define TIOCPKT_FLUSHWRITE	 2
> -#define TIOCPKT_STOP		 4
> -#define TIOCPKT_START		 8
> -#define TIOCPKT_NOSTOP		16
> -#define TIOCPKT_DOSTOP		32
> +#include <asm-generic/ioctls.h>
>  
> -#define TIOCSER_TEMT    0x01	/* Transmitter physically empty */
> +#undef TCGETS2
> +#undef TCSETS2
> +#undef TCSETSW2
> +#undef TCSETSF2
>  
> -#endif /* __ASM_AVR32_IOCTLS_H */
> +#endif
> Index: linux-2.6/include/asm-blackfin/ioctls.h
> ===================================================================
> --- linux-2.6.orig/include/asm-blackfin/ioctls.h
> +++ linux-2.6/include/asm-blackfin/ioctls.h
> @@ -1,87 +1,7 @@
>  #ifndef __ARCH_BFIN_IOCTLS_H__
>  #define __ARCH_BFIN_IOCTLS_H__
>  
> -#include <asm/ioctl.h>
> +#include <asm-generic/ioctls.h>
>  
> -/* 0x54 is just a magic number to make these relatively unique ('T') */
> -
> -#define TCGETS		0x5401
> -#define TCSETS		0x5402
> -#define TCSETSW		0x5403
> -#define TCSETSF		0x5404
> -#define TCGETA		0x5405
> -#define TCSETA		0x5406
> -#define TCSETAW		0x5407
> -#define TCSETAF		0x5408
> -#define TCSBRK		0x5409
> -#define TCXONC		0x540A
> -#define TCFLSH		0x540B
> -#define TIOCEXCL	0x540C
> -#define TIOCNXCL	0x540D
> -#define TIOCSCTTY	0x540E
> -#define TIOCGPGRP	0x540F
> -#define TIOCSPGRP	0x5410
> -#define TIOCOUTQ	0x5411
> -#define TIOCSTI		0x5412
> -#define TIOCGWINSZ	0x5413
> -#define TIOCSWINSZ	0x5414
> -#define TIOCMGET	0x5415
> -#define TIOCMBIS	0x5416
> -#define TIOCMBIC	0x5417
> -#define TIOCMSET	0x5418
> -#define TIOCGSOFTCAR	0x5419
> -#define TIOCSSOFTCAR	0x541A
> -#define FIONREAD	0x541B
> -#define TIOCINQ		FIONREAD
> -#define TIOCLINUX	0x541C
> -#define TIOCCONS	0x541D
> -#define TIOCGSERIAL	0x541E
> -#define TIOCSSERIAL	0x541F
> -#define TIOCPKT		0x5420
> -#define FIONBIO		0x5421
> -#define TIOCNOTTY	0x5422
> -#define TIOCSETD	0x5423
> -#define TIOCGETD	0x5424
> -#define TCSBRKP		0x5425	/* Needed for POSIX tcsendbreak() */
>  #define TIOCTTYGSTRUCT	0x5426	/* For debugging only */
> -#define TIOCSBRK	0x5427	/* BSD compatibility */
> -#define TIOCCBRK	0x5428	/* BSD compatibility */
> -#define TIOCGSID	0x5429	/* Return the session ID of FD */
> -#define TCGETS2		_IOR('T', 0x2A, struct termios2)
> -#define TCSETS2		_IOW('T', 0x2B, struct termios2)
> -#define TCSETSW2	_IOW('T', 0x2C, struct termios2)
> -#define TCSETSF2	_IOW('T', 0x2D, struct termios2)
> -/* Get Pty Number (of pty-mux device) */
> -#define TIOCGPTN	_IOR('T', 0x30, unsigned int)
> -#define TIOCSPTLCK	_IOW('T', 0x31, int)	/* Lock/unlock Pty */
> -
> -#define FIONCLEX	0x5450	/* these numbers need to be adjusted. */
> -#define FIOCLEX		0x5451
> -#define FIOASYNC	0x5452
> -#define TIOCSERCONFIG	0x5453
> -#define TIOCSERGWILD	0x5454
> -#define TIOCSERSWILD	0x5455
> -#define TIOCGLCKTRMIOS	0x5456
> -#define TIOCSLCKTRMIOS	0x5457
> -#define TIOCSERGSTRUCT	0x5458	/* For debugging only */
> -#define TIOCSERGETLSR   0x5459	/* Get line status register */
> -#define TIOCSERGETMULTI 0x545A	/* Get multiport config  */
> -#define TIOCSERSETMULTI 0x545B	/* Set multiport config */
> -
> -#define TIOCMIWAIT	0x545C	/* wait for a change on serial input line(s) */
> -#define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
> -
> -#define FIOQSIZE	0x545E
> -
> -/* Used for packet mode */
> -#define TIOCPKT_DATA		 0
> -#define TIOCPKT_FLUSHREAD	 1
> -#define TIOCPKT_FLUSHWRITE	 2
> -#define TIOCPKT_STOP		 4
> -#define TIOCPKT_START		 8
> -#define TIOCPKT_NOSTOP		16
> -#define TIOCPKT_DOSTOP		32
> -
> -#define TIOCSER_TEMT    0x01	/* Transmitter physically empty */
> -
> -#endif				/* __ARCH_BFIN_IOCTLS_H__ */
> +#endif
> Index: linux-2.6/include/asm-cris/ioctls.h
> ===================================================================
> --- linux-2.6.orig/include/asm-cris/ioctls.h
> +++ linux-2.6/include/asm-cris/ioctls.h
> @@ -1,91 +1,12 @@
>  #ifndef __ARCH_CRIS_IOCTLS_H__
>  #define __ARCH_CRIS_IOCTLS_H__
>  
> -/* verbatim copy of asm-i386/ioctls.h */
> -
> -#include <asm/ioctl.h>
> -
> -/* 0x54 is just a magic number to make these relatively unique ('T') */
> -
> -#define TCGETS		0x5401
> -#define TCSETS		0x5402
> -#define TCSETSW		0x5403
> -#define TCSETSF		0x5404
> -#define TCGETA		0x5405
> -#define TCSETA		0x5406
> -#define TCSETAW		0x5407
> -#define TCSETAF		0x5408
> -#define TCSBRK		0x5409
> -#define TCXONC		0x540A
> -#define TCFLSH		0x540B
> -#define TIOCEXCL	0x540C
> -#define TIOCNXCL	0x540D
> -#define TIOCSCTTY	0x540E
> -#define TIOCGPGRP	0x540F
> -#define TIOCSPGRP	0x5410
> -#define TIOCOUTQ	0x5411
> -#define TIOCSTI		0x5412
> -#define TIOCGWINSZ	0x5413
> -#define TIOCSWINSZ	0x5414
> -#define TIOCMGET	0x5415
> -#define TIOCMBIS	0x5416
> -#define TIOCMBIC	0x5417
> -#define TIOCMSET	0x5418
> -#define TIOCGSOFTCAR	0x5419
> -#define TIOCSSOFTCAR	0x541A
> -#define FIONREAD	0x541B
> -#define TIOCINQ		FIONREAD
> -#define TIOCLINUX	0x541C
> -#define TIOCCONS	0x541D
> -#define TIOCGSERIAL	0x541E
> -#define TIOCSSERIAL	0x541F
> -#define TIOCPKT		0x5420
> -#define FIONBIO		0x5421
> -#define TIOCNOTTY	0x5422
> -#define TIOCSETD	0x5423
> -#define TIOCGETD	0x5424
> -#define TCSBRKP		0x5425	/* Needed for POSIX tcsendbreak() */
> -#define TIOCSBRK	0x5427  /* BSD compatibility */
> -#define TIOCCBRK	0x5428  /* BSD compatibility */
> -#define TIOCGSID	0x5429  /* Return the session ID of FD */
> -#define TCGETS2		_IOR('T',0x2A, struct termios2)
> -#define TCSETS2		_IOW('T',0x2B, struct termios2)
> -#define TCSETSW2	_IOW('T',0x2C, struct termios2)
> -#define TCSETSF2	_IOW('T',0x2D, struct termios2)
> -#define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
> -#define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
> -
> -#define FIONCLEX	0x5450  /* these numbers need to be adjusted. */
> -#define FIOCLEX		0x5451
> -#define FIOASYNC	0x5452
> -#define TIOCSERCONFIG	0x5453
> -#define TIOCSERGWILD	0x5454
> -#define TIOCSERSWILD	0x5455
> -#define TIOCGLCKTRMIOS	0x5456
> -#define TIOCSLCKTRMIOS	0x5457
> -#define TIOCSERGSTRUCT	0x5458 /* For debugging only */
> -#define TIOCSERGETLSR   0x5459 /* Get line status register */
> -#define TIOCSERGETMULTI 0x545A /* Get multiport config  */
> -#define TIOCSERSETMULTI 0x545B /* Set multiport config */
> -
> -#define TIOCMIWAIT	0x545C	/* wait for a change on serial input line(s) */
> -#define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
>  #define TIOCGHAYESESP   0x545E  /* Get Hayes ESP configuration */
>  #define TIOCSHAYESESP   0x545F  /* Set Hayes ESP configuration */
>  #define FIOQSIZE	0x5460
> -
>  #define TIOCSERSETRS485 0x5461  /* enable rs-485 */
>  #define TIOCSERWRRS485  0x5462  /* write rs-485 */
>  
> -/* Used for packet mode */
> -#define TIOCPKT_DATA		 0
> -#define TIOCPKT_FLUSHREAD	 1
> -#define TIOCPKT_FLUSHWRITE	 2
> -#define TIOCPKT_STOP		 4
> -#define TIOCPKT_START		 8
> -#define TIOCPKT_NOSTOP		16
> -#define TIOCPKT_DOSTOP		32
> -
> -#define TIOCSER_TEMT    0x01	/* Transmitter physically empty */
> +#include <asm-generic/ioctls.h>
>  
>  #endif
> Index: linux-2.6/include/asm-frv/ioctls.h
> ===================================================================
> --- linux-2.6.orig/include/asm-frv/ioctls.h
> +++ linux-2.6/include/asm-frv/ioctls.h
> @@ -1,82 +1,13 @@
>  #ifndef __ASM_IOCTLS_H__
>  #define __ASM_IOCTLS_H__
>  
> -#include <asm/ioctl.h>
> +#include <asm-generic/ioctls.h>
>  
> -/* 0x54 is just a magic number to make these relatively unique ('T') */
> -
> -#define TCGETS		0x5401
> -#define TCSETS		0x5402
> -#define TCSETSW		0x5403
> -#define TCSETSF		0x5404
> -#define TCGETA		0x5405
> -#define TCSETA		0x5406
> -#define TCSETAW		0x5407
> -#define TCSETAF		0x5408
> -#define TCSBRK		0x5409
> -#define TCXONC		0x540A
> -#define TCFLSH		0x540B
> -#define TIOCEXCL	0x540C
> -#define TIOCNXCL	0x540D
> -#define TIOCSCTTY	0x540E
> -#define TIOCGPGRP	0x540F
> -#define TIOCSPGRP	0x5410
> -#define TIOCOUTQ	0x5411
> -#define TIOCSTI		0x5412
> -#define TIOCGWINSZ	0x5413
> -#define TIOCSWINSZ	0x5414
> -#define TIOCMGET	0x5415
> -#define TIOCMBIS	0x5416
> -#define TIOCMBIC	0x5417
> -#define TIOCMSET	0x5418
> -#define TIOCGSOFTCAR	0x5419
> -#define TIOCSSOFTCAR	0x541A
> -#define FIONREAD	0x541B
> -#define TIOCINQ		FIONREAD
> -#define TIOCLINUX	0x541C
> -#define TIOCCONS	0x541D
> -#define TIOCGSERIAL	0x541E
> -#define TIOCSSERIAL	0x541F
> -#define TIOCPKT		0x5420
> -#define FIONBIO		0x5421
> -#define TIOCNOTTY	0x5422
> -#define TIOCSETD	0x5423
> -#define TIOCGETD	0x5424
> -#define TCSBRKP		0x5425	/* Needed for POSIX tcsendbreak() */
>  #define TIOCTTYGSTRUCT	0x5426  /* For debugging only */
> -#define TIOCSBRK	0x5427  /* BSD compatibility */
> -#define TIOCCBRK	0x5428  /* BSD compatibility */
> -#define TIOCGSID	0x5429  /* Return the session ID of FD */
> -#define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
> -#define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
> -
> -#define FIONCLEX	0x5450  /* these numbers need to be adjusted. */
> -#define FIOCLEX		0x5451
> -#define FIOASYNC	0x5452
> -#define TIOCSERCONFIG	0x5453
> -#define TIOCSERGWILD	0x5454
> -#define TIOCSERSWILD	0x5455
> -#define TIOCGLCKTRMIOS	0x5456
> -#define TIOCSLCKTRMIOS	0x5457
> -#define TIOCSERGSTRUCT	0x5458 /* For debugging only */
> -#define TIOCSERGETLSR   0x5459 /* Get line status register */
> -#define TIOCSERGETMULTI 0x545A /* Get multiport config  */
> -#define TIOCSERSETMULTI 0x545B /* Set multiport config */
> -
> -#define TIOCMIWAIT	0x545C	/* wait for a change on serial input line(s) */
> -#define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
> -#define FIOQSIZE	0x545E
> -
> -/* Used for packet mode */
> -#define TIOCPKT_DATA		 0
> -#define TIOCPKT_FLUSHREAD	 1
> -#define TIOCPKT_FLUSHWRITE	 2
> -#define TIOCPKT_STOP		 4
> -#define TIOCPKT_START		 8
> -#define TIOCPKT_NOSTOP		16
> -#define TIOCPKT_DOSTOP		32
> -
> -#define TIOCSER_TEMT    0x01	/* Transmitter physically empty */
>  
> -#endif /* __ASM_IOCTLS_H__ */
> +#undef TCGETS2
> +#undef TCSETS2
> +#undef TCSETSW2
> +#undef TCSETSF2
>  
> +#endif
> Index: linux-2.6/include/asm-generic/ioctls.h
> ===================================================================
> --- /dev/null
> +++ linux-2.6/include/asm-generic/ioctls.h
> @@ -0,0 +1,87 @@
> +#ifndef __ASM_ARM_IOCTLS_H
> +#define __ASM_ARM_IOCTLS_H
> +
> +#include <linux/ioctl.h>
> +
> +/* 0x54 is just a magic number to make these relatively unique ('T') */
> +
> +#define TCGETS		0x5401
> +#define TCSETS		0x5402
> +#define TCSETSW		0x5403
> +#define TCSETSF		0x5404
> +#define TCGETA		0x5405
> +#define TCSETA		0x5406
> +#define TCSETAW		0x5407
> +#define TCSETAF		0x5408
> +#define TCSBRK		0x5409
> +#define TCXONC		0x540A
> +#define TCFLSH		0x540B
> +#define TIOCEXCL	0x540C
> +#define TIOCNXCL	0x540D
> +#define TIOCSCTTY	0x540E
> +#define TIOCGPGRP	0x540F
> +#define TIOCSPGRP	0x5410
> +#define TIOCOUTQ	0x5411
> +#define TIOCSTI		0x5412
> +#define TIOCGWINSZ	0x5413
> +#define TIOCSWINSZ	0x5414
> +#define TIOCMGET	0x5415
> +#define TIOCMBIS	0x5416
> +#define TIOCMBIC	0x5417
> +#define TIOCMSET	0x5418
> +#define TIOCGSOFTCAR	0x5419
> +#define TIOCSSOFTCAR	0x541A
> +#define FIONREAD	0x541B
> +#define TIOCINQ		FIONREAD
> +#define TIOCLINUX	0x541C
> +#define TIOCCONS	0x541D
> +#define TIOCGSERIAL	0x541E
> +#define TIOCSSERIAL	0x541F
> +#define TIOCPKT		0x5420
> +#define FIONBIO		0x5421
> +#define TIOCNOTTY	0x5422
> +#define TIOCSETD	0x5423
> +#define TIOCGETD	0x5424
> +#define TCSBRKP		0x5425	/* Needed for POSIX tcsendbreak() */
> +#define TIOCSBRK	0x5427  /* BSD compatibility */
> +#define TIOCCBRK	0x5428  /* BSD compatibility */
> +#define TIOCGSID	0x5429  /* Return the session ID of FD */
> +#define TCGETS2		_IOR('T', 0x2A, struct termios2)
> +#define TCSETS2		_IOW('T', 0x2B, struct termios2)
> +#define TCSETSW2	_IOW('T', 0x2C, struct termios2)
> +#define TCSETSF2	_IOW('T', 0x2D, struct termios2)
> +#define TIOCGPTN	_IOR('T', 0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
> +#define TIOCSPTLCK	_IOW('T', 0x31, int)  /* Lock/unlock Pty */
> +
> +#define FIONCLEX	0x5450  /* these numbers need to be adjusted. */
> +#define FIOCLEX		0x5451
> +#define FIOASYNC	0x5452
> +#define TIOCSERCONFIG	0x5453
> +#define TIOCSERGWILD	0x5454
> +#define TIOCSERSWILD	0x5455
> +#define TIOCGLCKTRMIOS	0x5456
> +#define TIOCSLCKTRMIOS	0x5457
> +#define TIOCSERGSTRUCT	0x5458 /* For debugging only */
> +#define TIOCSERGETLSR   0x5459 /* Get line status register */
> +#define TIOCSERGETMULTI 0x545A /* Get multiport config  */
> +#define TIOCSERSETMULTI 0x545B /* Set multiport config */
> +
> +#define TIOCMIWAIT	0x545C	/* wait for a change on serial input line(s) */
> +#define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
> +
> +#ifndef FIOQSIZE /* some architectures define their own */
> +#define FIOQSIZE	0x545E
> +#endif
> +
> +/* Used for packet mode */
> +#define TIOCPKT_DATA		 0
> +#define TIOCPKT_FLUSHREAD	 1
> +#define TIOCPKT_FLUSHWRITE	 2
> +#define TIOCPKT_STOP		 4
> +#define TIOCPKT_START		 8
> +#define TIOCPKT_NOSTOP		16
> +#define TIOCPKT_DOSTOP		32
> +
> +#define TIOCSER_TEMT	0x01	/* Transmitter physically empty */
> +
> +#endif
> Index: linux-2.6/include/asm-h8300/ioctls.h
> ===================================================================
> --- linux-2.6.orig/include/asm-h8300/ioctls.h
> +++ linux-2.6/include/asm-h8300/ioctls.h
> @@ -1,85 +1,8 @@
>  #ifndef __ARCH_H8300_IOCTLS_H__
>  #define __ARCH_H8300_IOCTLS_H__
>  
> -#include <asm/ioctl.h>
> +#include <asm-generic/ioctls.h>
>  
> -/* 0x54 is just a magic number to make these relatively unique ('T') */
> -
> -#define TCGETS		0x5401
> -#define TCSETS		0x5402
> -#define TCSETSW		0x5403
> -#define TCSETSF		0x5404
> -#define TCGETA		0x5405
> -#define TCSETA		0x5406
> -#define TCSETAW		0x5407
> -#define TCSETAF		0x5408
> -#define TCSBRK		0x5409
> -#define TCXONC		0x540A
> -#define TCFLSH		0x540B
> -#define TIOCEXCL	0x540C
> -#define TIOCNXCL	0x540D
> -#define TIOCSCTTY	0x540E
> -#define TIOCGPGRP	0x540F
> -#define TIOCSPGRP	0x5410
> -#define TIOCOUTQ	0x5411
> -#define TIOCSTI		0x5412
> -#define TIOCGWINSZ	0x5413
> -#define TIOCSWINSZ	0x5414
> -#define TIOCMGET	0x5415
> -#define TIOCMBIS	0x5416
> -#define TIOCMBIC	0x5417
> -#define TIOCMSET	0x5418
> -#define TIOCGSOFTCAR	0x5419
> -#define TIOCSSOFTCAR	0x541A
> -#define FIONREAD	0x541B
> -#define TIOCINQ		FIONREAD
> -#define TIOCLINUX	0x541C
> -#define TIOCCONS	0x541D
> -#define TIOCGSERIAL	0x541E
> -#define TIOCSSERIAL	0x541F
> -#define TIOCPKT		0x5420
> -#define FIONBIO		0x5421
> -#define TIOCNOTTY	0x5422
> -#define TIOCSETD	0x5423
> -#define TIOCGETD	0x5424
> -#define TCSBRKP		0x5425	/* Needed for POSIX tcsendbreak() */
>  #define TIOCTTYGSTRUCT	0x5426  /* For debugging only */
> -#define TIOCSBRK	0x5427  /* BSD compatibility */
> -#define TIOCCBRK	0x5428  /* BSD compatibility */
> -#define TIOCGSID	0x5429  /* Return the session ID of FD */
> -#define TCGETS2		_IOR('T',0x2A, struct termios2)
> -#define TCSETS2		_IOW('T',0x2B, struct termios2)
> -#define TCSETSW2	_IOW('T',0x2C, struct termios2)
> -#define TCSETSF2	_IOW('T',0x2D, struct termios2)
> -#define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
> -#define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
> -
> -#define FIONCLEX	0x5450  /* these numbers need to be adjusted. */
> -#define FIOCLEX		0x5451
> -#define FIOASYNC	0x5452
> -#define TIOCSERCONFIG	0x5453
> -#define TIOCSERGWILD	0x5454
> -#define TIOCSERSWILD	0x5455
> -#define TIOCGLCKTRMIOS	0x5456
> -#define TIOCSLCKTRMIOS	0x5457
> -#define TIOCSERGSTRUCT	0x5458 /* For debugging only */
> -#define TIOCSERGETLSR   0x5459 /* Get line status register */
> -#define TIOCSERGETMULTI 0x545A /* Get multiport config  */
> -#define TIOCSERSETMULTI 0x545B /* Set multiport config */
> -
> -#define TIOCMIWAIT	0x545C	/* wait for a change on serial input line(s) */
> -#define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
> -#define FIOQSIZE	0x545E
> -
> -/* Used for packet mode */
> -#define TIOCPKT_DATA		 0
> -#define TIOCPKT_FLUSHREAD	 1
> -#define TIOCPKT_FLUSHWRITE	 2
> -#define TIOCPKT_STOP		 4
> -#define TIOCPKT_START		 8
> -#define TIOCPKT_NOSTOP		16
> -#define TIOCPKT_DOSTOP		32
> -
> -#define TIOCSER_TEMT    0x01	/* Transmitter physically empty */
>  
> -#endif /* __ARCH_H8300_IOCTLS_H__ */
> +#endif
> Index: linux-2.6/include/asm-ia64/ioctls.h
> ===================================================================
> --- linux-2.6.orig/include/asm-ia64/ioctls.h
> +++ linux-2.6/include/asm-ia64/ioctls.h
> @@ -1,93 +1,10 @@
>  #ifndef _ASM_IA64_IOCTLS_H
>  #define _ASM_IA64_IOCTLS_H
>  
> -/*
> - * Based on <asm-i386/ioctls.h>
> - *
> - * Modified 1998, 1999, 2002
> - *	David Mosberger-Tang <davidm@hpl.hp.com>, Hewlett-Packard Co
> - */
> -
> -#include <asm/ioctl.h>
> -
> -/* 0x54 is just a magic number to make these relatively unique ('T') */
> -
> -#define TCGETS		0x5401
> -#define TCSETS		0x5402	/* Clashes with SNDCTL_TMR_START sound ioctl */
> -#define TCSETSW		0x5403
> -#define TCSETSF		0x5404
> -#define TCGETA		0x5405
> -#define TCSETA		0x5406
> -#define TCSETAW		0x5407
> -#define TCSETAF		0x5408
> -#define TCSBRK		0x5409
> -#define TCXONC		0x540A
> -#define TCFLSH		0x540B
> -#define TIOCEXCL	0x540C
> -#define TIOCNXCL	0x540D
> -#define TIOCSCTTY	0x540E
> -#define TIOCGPGRP	0x540F
> -#define TIOCSPGRP	0x5410
> -#define TIOCOUTQ	0x5411
> -#define TIOCSTI		0x5412
> -#define TIOCGWINSZ	0x5413
> -#define TIOCSWINSZ	0x5414
> -#define TIOCMGET	0x5415
> -#define TIOCMBIS	0x5416
> -#define TIOCMBIC	0x5417
> -#define TIOCMSET	0x5418
> -#define TIOCGSOFTCAR	0x5419
> -#define TIOCSSOFTCAR	0x541A
> -#define FIONREAD	0x541B
> -#define TIOCINQ		FIONREAD
> -#define TIOCLINUX	0x541C
> -#define TIOCCONS	0x541D
> -#define TIOCGSERIAL	0x541E
> -#define TIOCSSERIAL	0x541F
> -#define TIOCPKT		0x5420
> -#define FIONBIO		0x5421
> -#define TIOCNOTTY	0x5422
> -#define TIOCSETD	0x5423
> -#define TIOCGETD	0x5424
> -#define TCSBRKP		0x5425	/* Needed for POSIX tcsendbreak() */
> -#define TIOCSBRK	0x5427  /* BSD compatibility */
> -#define TIOCCBRK	0x5428  /* BSD compatibility */
> -#define TIOCGSID	0x5429  /* Return the session ID of FD */
> -#define TCGETS2		_IOR('T',0x2A, struct termios2)
> -#define TCSETS2		_IOW('T',0x2B, struct termios2)
> -#define TCSETSW2	_IOW('T',0x2C, struct termios2)
> -#define TCSETSF2	_IOW('T',0x2D, struct termios2)
> -#define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
> -#define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
> -
> -#define FIONCLEX	0x5450  /* these numbers need to be adjusted. */
> -#define FIOCLEX		0x5451
> -#define FIOASYNC	0x5452
> -#define TIOCSERCONFIG	0x5453
> -#define TIOCSERGWILD	0x5454
> -#define TIOCSERSWILD	0x5455
> -#define TIOCGLCKTRMIOS	0x5456
> -#define TIOCSLCKTRMIOS	0x5457
> -#define TIOCSERGSTRUCT	0x5458 /* For debugging only */
> -#define TIOCSERGETLSR   0x5459 /* Get line status register */
> -#define TIOCSERGETMULTI 0x545A /* Get multiport config  */
> -#define TIOCSERSETMULTI 0x545B /* Set multiport config */
> -
> -#define TIOCMIWAIT	0x545C	/* wait for a change on serial input line(s) */
> -#define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
>  #define TIOCGHAYESESP   0x545E  /* Get Hayes ESP configuration */
>  #define TIOCSHAYESESP   0x545F  /* Set Hayes ESP configuration */
>  #define FIOQSIZE	0x5460
>  
> -/* Used for packet mode */
> -#define TIOCPKT_DATA		 0
> -#define TIOCPKT_FLUSHREAD	 1
> -#define TIOCPKT_FLUSHWRITE	 2
> -#define TIOCPKT_STOP		 4
> -#define TIOCPKT_START		 8
> -#define TIOCPKT_NOSTOP		16
> -#define TIOCPKT_DOSTOP		32
> -
> -#define TIOCSER_TEMT    0x01	/* Transmitter physically empty */
> +#include <asm-generic/ioctls.h>
>  
> -#endif /* _ASM_IA64_IOCTLS_H */
> +#endif
> Index: linux-2.6/include/asm-m32r/ioctls.h
> ===================================================================
> --- linux-2.6.orig/include/asm-m32r/ioctls.h
> +++ linux-2.6/include/asm-m32r/ioctls.h
> @@ -1,87 +1,11 @@
>  #ifndef __ARCH_M32R_IOCTLS_H__
>  #define __ARCH_M32R_IOCTLS_H__
>  
> -#include <asm/ioctl.h>
> -
> -/* 0x54 is just a magic number to make these relatively unique ('T') */
> -
> -#define TCGETS		0x5401
> -#define TCSETS		0x5402 /* Clashes with SNDCTL_TMR_START sound ioctl */
> -#define TCSETSW		0x5403
> -#define TCSETSF		0x5404
> -#define TCGETA		0x5405
> -#define TCSETA		0x5406
> -#define TCSETAW		0x5407
> -#define TCSETAF		0x5408
> -#define TCSBRK		0x5409
> -#define TCXONC		0x540A
> -#define TCFLSH		0x540B
> -#define TIOCEXCL	0x540C
> -#define TIOCNXCL	0x540D
> -#define TIOCSCTTY	0x540E
> -#define TIOCGPGRP	0x540F
> -#define TIOCSPGRP	0x5410
> -#define TIOCOUTQ	0x5411
> -#define TIOCSTI		0x5412
> -#define TIOCGWINSZ	0x5413
> -#define TIOCSWINSZ	0x5414
> -#define TIOCMGET	0x5415
> -#define TIOCMBIS	0x5416
> -#define TIOCMBIC	0x5417
> -#define TIOCMSET	0x5418
> -#define TIOCGSOFTCAR	0x5419
> -#define TIOCSSOFTCAR	0x541A
> -#define FIONREAD	0x541B
> -#define TIOCINQ		FIONREAD
> -#define TIOCLINUX	0x541C
> -#define TIOCCONS	0x541D
> -#define TIOCGSERIAL	0x541E
> -#define TIOCSSERIAL	0x541F
> -#define TIOCPKT		0x5420
> -#define FIONBIO		0x5421
> -#define TIOCNOTTY	0x5422
> -#define TIOCSETD	0x5423
> -#define TIOCGETD	0x5424
> -#define TCSBRKP		0x5425	/* Needed for POSIX tcsendbreak() */
>  /* #define TIOCTTYGSTRUCT 0x5426 - Former debugging-only ioctl */
> -#define TIOCSBRK	0x5427  /* BSD compatibility */
> -#define TIOCCBRK	0x5428  /* BSD compatibility */
> -#define TIOCGSID	0x5429  /* Return the session ID of FD */
> -#define TCGETS2		_IOR('T',0x2A, struct termios2)
> -#define TCSETS2		_IOW('T',0x2B, struct termios2)
> -#define TCSETSW2	_IOW('T',0x2C, struct termios2)
> -#define TCSETSF2	_IOW('T',0x2D, struct termios2)
> -#define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
> -#define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
> -
> -#define FIONCLEX	0x5450
> -#define FIOCLEX		0x5451
> -#define FIOASYNC	0x5452
> -#define TIOCSERCONFIG	0x5453
> -#define TIOCSERGWILD	0x5454
> -#define TIOCSERSWILD	0x5455
> -#define TIOCGLCKTRMIOS	0x5456
> -#define TIOCSLCKTRMIOS	0x5457
> -#define TIOCSERGSTRUCT	0x5458 /* For debugging only */
> -#define TIOCSERGETLSR   0x5459 /* Get line status register */
> -#define TIOCSERGETMULTI 0x545A /* Get multiport config  */
> -#define TIOCSERSETMULTI 0x545B /* Set multiport config */
> -
> -#define TIOCMIWAIT	0x545C	/* wait for a change on serial input line(s) */
> -#define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
>  #define TIOCGHAYESESP   0x545E  /* Get Hayes ESP configuration */
>  #define TIOCSHAYESESP   0x545F  /* Set Hayes ESP configuration */
>  #define FIOQSIZE	0x5460
>  
> -/* Used for packet mode */
> -#define TIOCPKT_DATA		 0
> -#define TIOCPKT_FLUSHREAD	 1
> -#define TIOCPKT_FLUSHWRITE	 2
> -#define TIOCPKT_STOP		 4
> -#define TIOCPKT_START		 8
> -#define TIOCPKT_NOSTOP		16
> -#define TIOCPKT_DOSTOP		32
> -
> -#define TIOCSER_TEMT    0x01	/* Transmitter physically empty */
> +#include <asm-generic/ioctls.h>
>  
> -#endif /* __ARCH_M32R_IOCTLS_H__ */
> +#endif
> Index: linux-2.6/include/asm-m68k/ioctls.h
> ===================================================================
> --- linux-2.6.orig/include/asm-m68k/ioctls.h
> +++ linux-2.6/include/asm-m68k/ioctls.h
> @@ -1,84 +1,6 @@
>  #ifndef __ARCH_M68K_IOCTLS_H__
>  #define __ARCH_M68K_IOCTLS_H__
>  
> -#include <asm/ioctl.h>
> +#include <asm-generic/ioctls.h>
>  
> -/* 0x54 is just a magic number to make these relatively unique ('T') */
> -
> -#define TCGETS		0x5401
> -#define TCSETS		0x5402
> -#define TCSETSW		0x5403
> -#define TCSETSF		0x5404
> -#define TCGETA		0x5405
> -#define TCSETA		0x5406
> -#define TCSETAW		0x5407
> -#define TCSETAF		0x5408
> -#define TCSBRK		0x5409
> -#define TCXONC		0x540A
> -#define TCFLSH		0x540B
> -#define TIOCEXCL	0x540C
> -#define TIOCNXCL	0x540D
> -#define TIOCSCTTY	0x540E
> -#define TIOCGPGRP	0x540F
> -#define TIOCSPGRP	0x5410
> -#define TIOCOUTQ	0x5411
> -#define TIOCSTI		0x5412
> -#define TIOCGWINSZ	0x5413
> -#define TIOCSWINSZ	0x5414
> -#define TIOCMGET	0x5415
> -#define TIOCMBIS	0x5416
> -#define TIOCMBIC	0x5417
> -#define TIOCMSET	0x5418
> -#define TIOCGSOFTCAR	0x5419
> -#define TIOCSSOFTCAR	0x541A
> -#define FIONREAD	0x541B
> -#define TIOCINQ		FIONREAD
> -#define TIOCLINUX	0x541C
> -#define TIOCCONS	0x541D
> -#define TIOCGSERIAL	0x541E
> -#define TIOCSSERIAL	0x541F
> -#define TIOCPKT		0x5420
> -#define FIONBIO		0x5421
> -#define TIOCNOTTY	0x5422
> -#define TIOCSETD	0x5423
> -#define TIOCGETD	0x5424
> -#define TCSBRKP		0x5425	/* Needed for POSIX tcsendbreak() */
> -#define TIOCSBRK	0x5427  /* BSD compatibility */
> -#define TIOCCBRK	0x5428  /* BSD compatibility */
> -#define TIOCGSID	0x5429  /* Return the session ID of FD */
> -#define TCGETS2		_IOR('T',0x2A, struct termios2)
> -#define TCSETS2		_IOW('T',0x2B, struct termios2)
> -#define TCSETSW2	_IOW('T',0x2C, struct termios2)
> -#define TCSETSF2	_IOW('T',0x2D, struct termios2)
> -#define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
> -#define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
> -
> -#define FIONCLEX	0x5450  /* these numbers need to be adjusted. */
> -#define FIOCLEX		0x5451
> -#define FIOASYNC	0x5452
> -#define TIOCSERCONFIG	0x5453
> -#define TIOCSERGWILD	0x5454
> -#define TIOCSERSWILD	0x5455
> -#define TIOCGLCKTRMIOS	0x5456
> -#define TIOCSLCKTRMIOS	0x5457
> -#define TIOCSERGSTRUCT	0x5458 /* For debugging only */
> -#define TIOCSERGETLSR   0x5459 /* Get line status register */
> -#define TIOCSERGETMULTI 0x545A /* Get multiport config  */
> -#define TIOCSERSETMULTI 0x545B /* Set multiport config */
> -
> -#define TIOCMIWAIT	0x545C	/* wait for a change on serial input line(s) */
> -#define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
> -#define FIOQSIZE	0x545E
> -
> -/* Used for packet mode */
> -#define TIOCPKT_DATA		 0
> -#define TIOCPKT_FLUSHREAD	 1
> -#define TIOCPKT_FLUSHWRITE	 2
> -#define TIOCPKT_STOP		 4
> -#define TIOCPKT_START		 8
> -#define TIOCPKT_NOSTOP		16
> -#define TIOCPKT_DOSTOP		32
> -
> -#define TIOCSER_TEMT    0x01	/* Transmitter physically empty */
> -
> -#endif /* __ARCH_M68K_IOCTLS_H__ */
> +#endif
> Index: linux-2.6/include/asm-microblaze/ioctls.h
> ===================================================================
> --- linux-2.6.orig/include/asm-microblaze/ioctls.h
> +++ linux-2.6/include/asm-microblaze/ioctls.h
> @@ -11,83 +11,6 @@
>  #ifndef _ASM_MICROBLAZE_IOCTLS_H
>  #define _ASM_MICROBLAZE_IOCTLS_H
>  
> -#include <asm/ioctl.h>
> +#include <asm-generic/ioctls.h>
>  
> -/* 0x54 is just a magic number to make these relatively unique ('T') */
> -
> -#define TCGETS		0x5401
> -#define TCSETS		0x5402
> -#define TCSETSW		0x5403
> -#define TCSETSF		0x5404
> -#define TCGETA		0x5405
> -#define TCSETA		0x5406
> -#define TCSETAW		0x5407
> -#define TCSETAF		0x5408
> -#define TCSBRK		0x5409
> -#define TCXONC		0x540A
> -#define TCFLSH		0x540B
> -#define TIOCEXCL	0x540C
> -#define TIOCNXCL	0x540D
> -#define TIOCSCTTY	0x540E
> -#define TIOCGPGRP	0x540F
> -#define TIOCSPGRP	0x5410
> -#define TIOCOUTQ	0x5411
> -#define TIOCSTI		0x5412
> -#define TIOCGWINSZ	0x5413
> -#define TIOCSWINSZ	0x5414
> -#define TIOCMGET	0x5415
> -#define TIOCMBIS	0x5416
> -#define TIOCMBIC	0x5417
> -#define TIOCMSET	0x5418
> -#define TIOCGSOFTCAR	0x5419
> -#define TIOCSSOFTCAR	0x541A
> -#define FIONREAD	0x541B
> -#define TIOCINQ		FIONREAD
> -#define TIOCLINUX	0x541C
> -#define TIOCCONS	0x541D
> -#define TIOCGSERIAL	0x541E
> -#define TIOCSSERIAL	0x541F
> -#define TIOCPKT		0x5420
> -#define FIONBIO		0x5421
> -#define TIOCNOTTY	0x5422
> -#define TIOCSETD	0x5423
> -#define TIOCGETD	0x5424
> -#define TCSBRKP		0x5425 /* Needed for POSIX tcsendbreak() */
> -#define TIOCTTYGSTRUCT	0x5426 /* For debugging only */
> -#define TIOCSBRK	0x5427 /* BSD compatibility */
> -#define TIOCCBRK	0x5428 /* BSD compatibility */
> -#define TIOCGSID	0x5429 /* Return the session ID of FD */
> -/* Get Pty Number (of pty-mux device) */
> -#define TIOCGPTN	_IOR('T', 0x30, unsigned int)
> -#define TIOCSPTLCK	_IOW('T', 0x31, int) /* Lock/unlock Pty */
> -
> -#define FIONCLEX	0x5450 /* these numbers need to be adjusted. */
> -#define FIOCLEX		0x5451
> -#define FIOASYNC	0x5452
> -#define TIOCSERCONFIG	0x5453
> -#define TIOCSERGWILD	0x5454
> -#define TIOCSERSWILD	0x5455
> -#define TIOCGLCKTRMIOS	0x5456
> -#define TIOCSLCKTRMIOS	0x5457
> -#define TIOCSERGSTRUCT	0x5458 /* For debugging only */
> -#define TIOCSERGETLSR	0x5459 /* Get line status register */
> -#define TIOCSERGETMULTI 0x545A /* Get multiport config */
> -#define TIOCSERSETMULTI 0x545B /* Set multiport config */
> -
> -#define TIOCMIWAIT	0x545C /* wait for a change on serial input line(s) */
> -#define TIOCGICOUNT	0x545D /* read serial port inline interrupt counts */
> -
> -#define	FIOQSIZE	0x545E
> -
> -/* Used for packet mode */
> -#define TIOCPKT_DATA		0
> -#define TIOCPKT_FLUSHREAD	1
> -#define TIOCPKT_FLUSHWRITE	2
> -#define TIOCPKT_STOP		4
> -#define TIOCPKT_START		8
> -#define TIOCPKT_NOSTOP		16
> -#define TIOCPKT_DOSTOP		32
> -
> -#define TIOCSER_TEMT	0x01 /* Transmitter physically empty */
> -
> -#endif /* _ASM_MICROBLAZE_IOCTLS_H */
> +#endif
> Index: linux-2.6/include/asm-mn10300/ioctls.h
> ===================================================================
> --- linux-2.6.orig/include/asm-mn10300/ioctls.h
> +++ linux-2.6/include/asm-mn10300/ioctls.h
> @@ -1,88 +1,12 @@
>  #ifndef _ASM_IOCTLS_H
>  #define _ASM_IOCTLS_H
>  
> -#include <asm/ioctl.h>
> -
> -/* 0x54 is just a magic number to make these relatively unique ('T') */
> -
> -#define TCGETS		0x5401
> -#define TCSETS		0x5402
> -#define TCSETSW		0x5403
> -#define TCSETSF		0x5404
> -#define TCGETA		0x5405
> -#define TCSETA		0x5406
> -#define TCSETAW		0x5407
> -#define TCSETAF		0x5408
> -#define TCSBRK		0x5409
> -#define TCXONC		0x540A
> -#define TCFLSH		0x540B
> -#define TIOCEXCL	0x540C
> -#define TIOCNXCL	0x540D
> -#define TIOCSCTTY	0x540E
> -#define TIOCGPGRP	0x540F
> -#define TIOCSPGRP	0x5410
> -#define TIOCOUTQ	0x5411
> -#define TIOCSTI		0x5412
> -#define TIOCGWINSZ	0x5413
> -#define TIOCSWINSZ	0x5414
> -#define TIOCMGET	0x5415
> -#define TIOCMBIS	0x5416
> -#define TIOCMBIC	0x5417
> -#define TIOCMSET	0x5418
> -#define TIOCGSOFTCAR	0x5419
> -#define TIOCSSOFTCAR	0x541A
> -#define FIONREAD	0x541B
> -#define TIOCINQ		FIONREAD
> -#define TIOCLINUX	0x541C
> -#define TIOCCONS	0x541D
> -#define TIOCGSERIAL	0x541E
> -#define TIOCSSERIAL	0x541F
> -#define TIOCPKT		0x5420
> -#define FIONBIO		0x5421
> -#define TIOCNOTTY	0x5422
> -#define TIOCSETD	0x5423
> -#define TIOCGETD	0x5424
> -#define TCSBRKP		0x5425	/* Needed for POSIX tcsendbreak() */
>  /* #define TIOCTTYGSTRUCT 0x5426 - Former debugging-only ioctl */
> -#define TIOCSBRK	0x5427  /* BSD compatibility */
> -#define TIOCCBRK	0x5428  /* BSD compatibility */
> -#define TIOCGSID	0x5429  /* Return the session ID of FD */
> -#define TCGETS2		_IOR('T', 0x2A, struct termios2)
> -#define TCSETS2		_IOW('T', 0x2B, struct termios2)
> -#define TCSETSW2	_IOW('T', 0x2C, struct termios2)
> -#define TCSETSF2	_IOW('T', 0x2D, struct termios2)
> -#define TIOCGPTN	_IOR('T', 0x30, unsigned int) /* Get Pty Number
> -						       * (of pty-mux device) */
> -#define TIOCSPTLCK	_IOW('T', 0x31, int)  /* Lock/unlock Pty */
> -
> -#define FIONCLEX	0x5450
> -#define FIOCLEX		0x5451
> -#define FIOASYNC	0x5452
> -#define TIOCSERCONFIG	0x5453
> -#define TIOCSERGWILD	0x5454
> -#define TIOCSERSWILD	0x5455
> -#define TIOCGLCKTRMIOS	0x5456
> -#define TIOCSLCKTRMIOS	0x5457
> -#define TIOCSERGSTRUCT	0x5458 /* For debugging only */
> -#define TIOCSERGETLSR   0x5459 /* Get line status register */
> -#define TIOCSERGETMULTI 0x545A /* Get multiport config  */
> -#define TIOCSERSETMULTI 0x545B /* Set multiport config */
> -
> -#define TIOCMIWAIT	0x545C	/* wait for a change on serial input line(s) */
> -#define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
>  #define TIOCGHAYESESP   0x545E  /* Get Hayes ESP configuration */
>  #define TIOCSHAYESESP   0x545F  /* Set Hayes ESP configuration */
>  #define FIOQSIZE	0x5460
>  
> -/* Used for packet mode */
> -#define TIOCPKT_DATA		 0
> -#define TIOCPKT_FLUSHREAD	 1
> -#define TIOCPKT_FLUSHWRITE	 2
> -#define TIOCPKT_STOP		 4
> -#define TIOCPKT_START		 8
> -#define TIOCPKT_NOSTOP		16
> -#define TIOCPKT_DOSTOP		32
> +#include <asm-generic/ioctls.h>
>  
> -#define TIOCSER_TEMT    0x01	/* Transmitter physically empty */
>  
> -#endif /* _ASM_IOCTLS_H */
> +#endif
> Index: linux-2.6/include/asm-parisc/ioctls.h
> ===================================================================
> --- linux-2.6.orig/include/asm-parisc/ioctls.h
> +++ linux-2.6/include/asm-parisc/ioctls.h
> @@ -81,6 +81,6 @@
>  #define TIOCPKT_NOSTOP		16
>  #define TIOCPKT_DOSTOP		32
>  
> -#define TIOCSER_TEMT    0x01	/* Transmitter physically empty */
> +#define TIOCSER_TEMT	0x01	/* Transmitter physically empty */
>  
> -#endif /* _ASM_PARISC_IOCTLS_H */
> +#endif
> Index: linux-2.6/include/asm-s390/ioctls.h
> ===================================================================
> --- linux-2.6.orig/include/asm-s390/ioctls.h
> +++ linux-2.6/include/asm-s390/ioctls.h
> @@ -1,92 +1,6 @@
> -/*
> - *  include/asm-s390/ioctls.h
> - *
> - *  S390 version
> - *
> - *  Derived from "include/asm-i386/ioctls.h"
> - */
> -
>  #ifndef __ARCH_S390_IOCTLS_H__
>  #define __ARCH_S390_IOCTLS_H__
>  
> -#include <asm/ioctl.h>
> -
> -/* 0x54 is just a magic number to make these relatively unique ('T') */
> -
> -#define TCGETS		0x5401
> -#define TCSETS		0x5402
> -#define TCSETSW		0x5403
> -#define TCSETSF		0x5404
> -#define TCGETA		0x5405
> -#define TCSETA		0x5406
> -#define TCSETAW		0x5407
> -#define TCSETAF		0x5408
> -#define TCSBRK		0x5409
> -#define TCXONC		0x540A
> -#define TCFLSH		0x540B
> -#define TIOCEXCL	0x540C
> -#define TIOCNXCL	0x540D
> -#define TIOCSCTTY	0x540E
> -#define TIOCGPGRP	0x540F
> -#define TIOCSPGRP	0x5410
> -#define TIOCOUTQ	0x5411
> -#define TIOCSTI		0x5412
> -#define TIOCGWINSZ	0x5413
> -#define TIOCSWINSZ	0x5414
> -#define TIOCMGET	0x5415
> -#define TIOCMBIS	0x5416
> -#define TIOCMBIC	0x5417
> -#define TIOCMSET	0x5418
> -#define TIOCGSOFTCAR	0x5419
> -#define TIOCSSOFTCAR	0x541A
> -#define FIONREAD	0x541B
> -#define TIOCINQ		FIONREAD
> -#define TIOCLINUX	0x541C
> -#define TIOCCONS	0x541D
> -#define TIOCGSERIAL	0x541E
> -#define TIOCSSERIAL	0x541F
> -#define TIOCPKT		0x5420
> -#define FIONBIO		0x5421
> -#define TIOCNOTTY	0x5422
> -#define TIOCSETD	0x5423
> -#define TIOCGETD	0x5424
> -#define TCSBRKP		0x5425	/* Needed for POSIX tcsendbreak() */
> -#define TIOCSBRK	0x5427  /* BSD compatibility */
> -#define TIOCCBRK	0x5428  /* BSD compatibility */
> -#define TIOCGSID	0x5429  /* Return the session ID of FD */
> -#define TCGETS2		_IOR('T',0x2A, struct termios2)
> -#define TCSETS2		_IOW('T',0x2B, struct termios2)
> -#define TCSETSW2	_IOW('T',0x2C, struct termios2)
> -#define TCSETSF2	_IOW('T',0x2D, struct termios2)
> -#define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
> -#define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
> -
> -#define FIONCLEX	0x5450  /* these numbers need to be adjusted. */
> -#define FIOCLEX		0x5451
> -#define FIOASYNC	0x5452
> -#define TIOCSERCONFIG	0x5453
> -#define TIOCSERGWILD	0x5454
> -#define TIOCSERSWILD	0x5455
> -#define TIOCGLCKTRMIOS	0x5456
> -#define TIOCSLCKTRMIOS	0x5457
> -#define TIOCSERGSTRUCT	0x5458 /* For debugging only */
> -#define TIOCSERGETLSR   0x5459 /* Get line status register */
> -#define TIOCSERGETMULTI 0x545A /* Get multiport config  */
> -#define TIOCSERSETMULTI 0x545B /* Set multiport config */
> -
> -#define TIOCMIWAIT	0x545C	/* wait for a change on serial input line(s) */
> -#define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
> -#define FIOQSIZE	0x545E
> -
> -/* Used for packet mode */
> -#define TIOCPKT_DATA		 0
> -#define TIOCPKT_FLUSHREAD	 1
> -#define TIOCPKT_FLUSHWRITE	 2
> -#define TIOCPKT_STOP		 4
> -#define TIOCPKT_START		 8
> -#define TIOCPKT_NOSTOP		16
> -#define TIOCPKT_DOSTOP		32
> -
> -#define TIOCSER_TEMT    0x01	/* Transmitter physically empty */
> +#include <asm-generic/ioctls.h>
>  
>  #endif
> Index: linux-2.6/include/asm-v850/ioctls.h
> ===================================================================
> --- linux-2.6.orig/include/asm-v850/ioctls.h
> +++ linux-2.6/include/asm-v850/ioctls.h
> @@ -1,84 +1,6 @@
>  #ifndef __V850_IOCTLS_H__
>  #define __V850_IOCTLS_H__
>  
> -#include <asm/ioctl.h>
> +#include <asm-generic/ioctls.h>
>  
> -/* 0x54 is just a magic number to make these relatively unique ('T') */
> -
> -#define TCGETS		0x5401
> -#define TCSETS		0x5402
> -#define TCSETSW		0x5403
> -#define TCSETSF		0x5404
> -#define TCGETA		0x5405
> -#define TCSETA		0x5406
> -#define TCSETAW		0x5407
> -#define TCSETAF		0x5408
> -#define TCSBRK		0x5409
> -#define TCXONC		0x540A
> -#define TCFLSH		0x540B
> -#define TIOCEXCL	0x540C
> -#define TIOCNXCL	0x540D
> -#define TIOCSCTTY	0x540E
> -#define TIOCGPGRP	0x540F
> -#define TIOCSPGRP	0x5410
> -#define TIOCOUTQ	0x5411
> -#define TIOCSTI		0x5412
> -#define TIOCGWINSZ	0x5413
> -#define TIOCSWINSZ	0x5414
> -#define TIOCMGET	0x5415
> -#define TIOCMBIS	0x5416
> -#define TIOCMBIC	0x5417
> -#define TIOCMSET	0x5418
> -#define TIOCGSOFTCAR	0x5419
> -#define TIOCSSOFTCAR	0x541A
> -#define FIONREAD	0x541B
> -#define TIOCINQ		FIONREAD
> -#define TIOCLINUX	0x541C
> -#define TIOCCONS	0x541D
> -#define TIOCGSERIAL	0x541E
> -#define TIOCSSERIAL	0x541F
> -#define TIOCPKT		0x5420
> -#define FIONBIO		0x5421
> -#define TIOCNOTTY	0x5422
> -#define TIOCSETD	0x5423
> -#define TIOCGETD	0x5424
> -#define TCSBRKP		0x5425	/* Needed for POSIX tcsendbreak() */
> -#define TIOCSBRK	0x5427  /* BSD compatibility */
> -#define TIOCCBRK	0x5428  /* BSD compatibility */
> -#define TIOCGSID	0x5429  /* Return the session ID of FD */
> -#define TCGETS2		_IOR('T',0x2A, struct termios2)
> -#define TCSETS2		_IOW('T',0x2B, struct termios2)
> -#define TCSETSW2	_IOW('T',0x2C, struct termios2)
> -#define TCSETSF2	_IOW('T',0x2D, struct termios2)
> -#define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
> -#define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
> -
> -#define FIONCLEX	0x5450  /* these numbers need to be adjusted. */
> -#define FIOCLEX		0x5451
> -#define FIOASYNC	0x5452
> -#define TIOCSERCONFIG	0x5453
> -#define TIOCSERGWILD	0x5454
> -#define TIOCSERSWILD	0x5455
> -#define TIOCGLCKTRMIOS	0x5456
> -#define TIOCSLCKTRMIOS	0x5457
> -#define TIOCSERGSTRUCT	0x5458 /* For debugging only */
> -#define TIOCSERGETLSR   0x5459 /* Get line status register */
> -#define TIOCSERGETMULTI 0x545A /* Get multiport config  */
> -#define TIOCSERSETMULTI 0x545B /* Set multiport config */
> -
> -#define TIOCMIWAIT	0x545C	/* wait for a change on serial input line(s) */
> -#define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
> -#define FIOQSIZE	0x545E
> -
> -/* Used for packet mode */
> -#define TIOCPKT_DATA		 0
> -#define TIOCPKT_FLUSHREAD	 1
> -#define TIOCPKT_FLUSHWRITE	 2
> -#define TIOCPKT_STOP		 4
> -#define TIOCPKT_START		 8
> -#define TIOCPKT_NOSTOP		16
> -#define TIOCPKT_DOSTOP		32
> -
> -#define TIOCSER_TEMT    0x01	/* Transmitter physically empty */
> -
> -#endif /* __V850_IOCTLS_H__ */
> +#endif
> Index: linux-2.6/include/asm-x86/ioctls.h
> ===================================================================
> --- linux-2.6.orig/include/asm-x86/ioctls.h
> +++ linux-2.6/include/asm-x86/ioctls.h
> @@ -1,88 +1,10 @@
>  #ifndef _ASM_X86_IOCTLS_H
>  #define _ASM_X86_IOCTLS_H
>  
> -#include <asm/ioctl.h>
> -
> -/* 0x54 is just a magic number to make these relatively unique ('T') */
> -
> -#define TCGETS		0x5401
> -#define TCSETS		0x5402 /* Clashes with SNDCTL_TMR_START sound ioctl */
> -#define TCSETSW		0x5403
> -#define TCSETSF		0x5404
> -#define TCGETA		0x5405
> -#define TCSETA		0x5406
> -#define TCSETAW		0x5407
> -#define TCSETAF		0x5408
> -#define TCSBRK		0x5409
> -#define TCXONC		0x540A
> -#define TCFLSH		0x540B
> -#define TIOCEXCL	0x540C
> -#define TIOCNXCL	0x540D
> -#define TIOCSCTTY	0x540E
> -#define TIOCGPGRP	0x540F
> -#define TIOCSPGRP	0x5410
> -#define TIOCOUTQ	0x5411
> -#define TIOCSTI		0x5412
> -#define TIOCGWINSZ	0x5413
> -#define TIOCSWINSZ	0x5414
> -#define TIOCMGET	0x5415
> -#define TIOCMBIS	0x5416
> -#define TIOCMBIC	0x5417
> -#define TIOCMSET	0x5418
> -#define TIOCGSOFTCAR	0x5419
> -#define TIOCSSOFTCAR	0x541A
> -#define FIONREAD	0x541B
> -#define TIOCINQ		FIONREAD
> -#define TIOCLINUX	0x541C
> -#define TIOCCONS	0x541D
> -#define TIOCGSERIAL	0x541E
> -#define TIOCSSERIAL	0x541F
> -#define TIOCPKT		0x5420
> -#define FIONBIO		0x5421
> -#define TIOCNOTTY	0x5422
> -#define TIOCSETD	0x5423
> -#define TIOCGETD	0x5424
> -#define TCSBRKP		0x5425	/* Needed for POSIX tcsendbreak() */
> -/* #define TIOCTTYGSTRUCT 0x5426 - Former debugging-only ioctl */
> -#define TIOCSBRK	0x5427  /* BSD compatibility */
> -#define TIOCCBRK	0x5428  /* BSD compatibility */
> -#define TIOCGSID	0x5429  /* Return the session ID of FD */
> -#define TCGETS2		_IOR('T', 0x2A, struct termios2)
> -#define TCSETS2		_IOW('T', 0x2B, struct termios2)
> -#define TCSETSW2	_IOW('T', 0x2C, struct termios2)
> -#define TCSETSF2	_IOW('T', 0x2D, struct termios2)
> -#define TIOCGPTN	_IOR('T', 0x30, unsigned int)
> -				/* Get Pty Number (of pty-mux device) */
> -#define TIOCSPTLCK	_IOW('T', 0x31, int)  /* Lock/unlock Pty */
> -
> -#define FIONCLEX	0x5450
> -#define FIOCLEX		0x5451
> -#define FIOASYNC	0x5452
> -#define TIOCSERCONFIG	0x5453
> -#define TIOCSERGWILD	0x5454
> -#define TIOCSERSWILD	0x5455
> -#define TIOCGLCKTRMIOS	0x5456
> -#define TIOCSLCKTRMIOS	0x5457
> -#define TIOCSERGSTRUCT	0x5458 /* For debugging only */
> -#define TIOCSERGETLSR   0x5459 /* Get line status register */
> -#define TIOCSERGETMULTI 0x545A /* Get multiport config  */
> -#define TIOCSERSETMULTI 0x545B /* Set multiport config */
> -
> -#define TIOCMIWAIT	0x545C	/* wait for a change on serial input line(s) */
> -#define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
>  #define TIOCGHAYESESP   0x545E  /* Get Hayes ESP configuration */
>  #define TIOCSHAYESESP   0x545F  /* Set Hayes ESP configuration */
>  #define FIOQSIZE	0x5460
>  
> -/* Used for packet mode */
> -#define TIOCPKT_DATA		 0
> -#define TIOCPKT_FLUSHREAD	 1
> -#define TIOCPKT_FLUSHWRITE	 2
> -#define TIOCPKT_STOP		 4
> -#define TIOCPKT_START		 8
> -#define TIOCPKT_NOSTOP		16
> -#define TIOCPKT_DOSTOP		32
> -
> -#define TIOCSER_TEMT    0x01	/* Transmitter physically empty */
> +#include <asm-generic/ioctls.h>
>  
>  #endif
> 
> 
