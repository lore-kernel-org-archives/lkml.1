Return-Path: <linux-kernel-owner+w=401wt.eu-S1756817AbZFLKsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817AbZFLKsN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 06:48:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751099AbZFLKr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 06:47:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:56600 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbZFLKr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 06:47:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier.adi@gmail.com>
Subject: [PATCH] blackfin: update ioctls.h
Date: Fri, 12 Jun 2009 12:47:50 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <1244802468-13667-1-git-send-email-vapier@gentoo.org> <20090612113320.73e6f7f1@lxorguk.ukuu.org.uk> <8bd0f97a0906120334v2a1bfabr3af883b5cd1ee3a0@mail.gmail.com>
In-Reply-To: <8bd0f97a0906120334v2a1bfabr3af883b5cd1ee3a0@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <200906121247.50745.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19tmktJdjGKa9mjbhpNSoQ3w2oGL1hB73s75zw
 4N2LWReZHxByIWvM9cSto7TqR9eiqoAtzwwlO/rsatnwDStmlf
 hiTX+k7oprNxldwMVk6sA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The blackfin version of ioctls.h is a copy of the x86 version, just missing
some fixes that were not included in all copies. This change brings it back
in line with the latest version. Once my asm-generic tree gets merged, the
file can be replaced with an '#include <asm-generic/ioctls.h>'.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

---
On Friday 12 June 2009, Mike Frysinger wrote:
> On Fri, Jun 12, 2009 at 06:33, Alan Cox wrote:
> > On Fri, 12 Jun 2009 06:27:48 -0400 Mike Frysinger wrote:
> >> If TCGETX is not defined, we end up with this warning:
> >> drivers/char/tty_ioctl.c: In function ‘tty_mode_ioctl’:
> >> drivers/char/tty_ioctl.c:950: warning: unused variable ‘ktermx’
> >>
> >> Since the variable is only used in one case statement, push it down to
> >> the local case scope.
> >
> > If I wasn't so nice I'd just make it and the lack of BOTHER definitions
> > on platforms error. Really there shouldn't be anyone without the features
> > defined ;)
> 
> if i knew a lick about these extended tty pieces, i'd look at hooking them up
> 
> are these really arch specific ?

diff --git a/arch/blackfin/include/asm/ioctls.h b/arch/blackfin/include/asm/ioctls.h
index 895e317..3bcc071 100644
--- a/arch/blackfin/include/asm/ioctls.h
+++ b/arch/blackfin/include/asm/ioctls.h
@@ -43,7 +43,7 @@
 #define TIOCSETD	0x5423
 #define TIOCGETD	0x5424
 #define TCSBRKP		0x5425	/* Needed for POSIX tcsendbreak() */
-#define TIOCTTYGSTRUCT	0x5426	/* For debugging only */
+/* #define TIOCTTYGSTRUCT	0x5426	For debugging only */
 #define TIOCSBRK	0x5427	/* BSD compatibility */
 #define TIOCCBRK	0x5428	/* BSD compatibility */
 #define TIOCGSID	0x5429	/* Return the session ID of FD */
@@ -51,11 +51,17 @@
 #define TCSETS2		_IOW('T', 0x2B, struct termios2)
 #define TCSETSW2	_IOW('T', 0x2C, struct termios2)
 #define TCSETSF2	_IOW('T', 0x2D, struct termios2)
-/* Get Pty Number (of pty-mux device) */
-#define TIOCGPTN	_IOR('T', 0x30, unsigned int)
+#define TIOCGRS485	0x542E
+#define TIOCSRS485	0x542F
+#define TIOCGPTN	_IOR('T', 0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T', 0x31, int)	/* Lock/unlock Pty */
+#define TCGETX		0x5432 /* SYS5 TCGETX compatibility */
+#define TCSETX		0x5433
+#define TCSETXF		0x5434
+#define TCSETXW		0x5435
 
-#define FIONCLEX	0x5450	/* these numbers need to be adjusted. */
+
+#define FIONCLEX	0x5450
 #define FIOCLEX		0x5451
 #define FIOASYNC	0x5452
 #define TIOCSERCONFIG	0x5453
