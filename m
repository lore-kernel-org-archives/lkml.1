Return-Path: <linux-kernel-owner+w=401wt.eu-S1760813AbYFZMyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760813AbYFZMyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758058AbYFZMht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:37:49 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:20913 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758665AbYFZMhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:37:43 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       linuxppc-dev@ozlabs.org, vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk,
       hpa@zytor.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 36/60] microblaze_v4: ioctl support
Date: Thu, 26 Jun 2008 14:30:05 +0200
Message-Id: <1214483429-32360-37-git-send-email-monstr@seznam.cz>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <1214483429-32360-36-git-send-email-monstr@seznam.cz>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz>
 <1214483429-32360-2-git-send-email-monstr@seznam.cz>
 <1214483429-32360-3-git-send-email-monstr@seznam.cz>
 <1214483429-32360-4-git-send-email-monstr@seznam.cz>
 <1214483429-32360-5-git-send-email-monstr@seznam.cz>
 <1214483429-32360-6-git-send-email-monstr@seznam.cz>
 <1214483429-32360-7-git-send-email-monstr@seznam.cz>
 <1214483429-32360-8-git-send-email-monstr@seznam.cz>
 <1214483429-32360-9-git-send-email-monstr@seznam.cz>
 <1214483429-32360-10-git-send-email-monstr@seznam.cz>
 <1214483429-32360-11-git-send-email-monstr@seznam.cz>
 <1214483429-32360-12-git-send-email-monstr@seznam.cz>
 <1214483429-32360-13-git-send-email-monstr@seznam.cz>
 <1214483429-32360-14-git-send-email-monstr@seznam.cz>
 <1214483429-32360-15-git-send-email-monstr@seznam.cz>
 <1214483429-32360-16-git-send-email-monstr@seznam.cz>
 <1214483429-32360-17-git-send-email-monstr@seznam.cz>
 <1214483429-32360-18-git-send-email-monstr@seznam.cz>
 <1214483429-32360-19-git-send-email-monstr@seznam.cz>
 <1214483429-32360-20-git-send-email-monstr@seznam.cz>
 <1214483429-32360-21-git-send-email-monstr@seznam.cz>
 <1214483429-32360-22-git-send-email-monstr@seznam.cz>
 <1214483429-32360-23-git-send-email-monstr@seznam.cz>
 <1214483429-32360-24-git-send-email-monstr@seznam.cz>
 <1214483429-32360-25-git-send-email-monstr@seznam.cz>
 <1214483429-32360-26-git-send-email-monstr@seznam.cz>
 <1214483429-32360-27-git-send-email-monstr@seznam.cz>
 <1214483429-32360-28-git-send-email-monstr@seznam.cz>
 <1214483429-32360-29-git-send-email-monstr@seznam.cz>
 <1214483429-32360-30-git-send-email-monstr@seznam.cz>
 <1214483429-32360-31-git-send-email-monstr@seznam.cz>
 <1214483429-32360-32-git-send-email-monstr@seznam.cz>
 <1214483429-32360-33-git-send-email-monstr@seznam.cz>
 <1214483429-32360-34-git-send-email-monstr@seznam.cz>
 <1214483429-32360-35-git-send-email-monstr@seznam.cz>
 <1214483429-32360-36-git-send-email-monstr@seznam.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-microblaze/ioctl.h  |    1 +
 include/asm-microblaze/ioctls.h |   91 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 92 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-microblaze/ioctl.h
 create mode 100644 include/asm-microblaze/ioctls.h

diff --git a/include/asm-microblaze/ioctl.h b/include/asm-microblaze/ioctl.h
new file mode 100644
index 0000000..b279fe0
--- /dev/null
+++ b/include/asm-microblaze/ioctl.h
@@ -0,0 +1 @@
+#include <asm-generic/ioctl.h>
diff --git a/include/asm-microblaze/ioctls.h b/include/asm-microblaze/ioctls.h
new file mode 100644
index 0000000..76c963f
--- /dev/null
+++ b/include/asm-microblaze/ioctls.h
@@ -0,0 +1,91 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_IOCTLS_H
+#define _ASM_MICROBLAZE_IOCTLS_H
+
+#include <asm/ioctl.h>
+
+/* 0x54 is just a magic number to make these relatively unique ('T') */
+
+#define TCGETS		0x5401
+#define TCSETS		0x5402
+#define TCSETSW		0x5403
+#define TCSETSF		0x5404
+#define TCGETA		0x5405
+#define TCSETA		0x5406
+#define TCSETAW		0x5407
+#define TCSETAF		0x5408
+#define TCSBRK		0x5409
+#define TCXONC		0x540A
+#define TCFLSH		0x540B
+#define TIOCEXCL	0x540C
+#define TIOCNXCL	0x540D
+#define TIOCSCTTY	0x540E
+#define TIOCGPGRP	0x540F
+#define TIOCSPGRP	0x5410
+#define TIOCOUTQ	0x5411
+#define TIOCSTI		0x5412
+#define TIOCGWINSZ	0x5413
+#define TIOCSWINSZ	0x5414
+#define TIOCMGET	0x5415
+#define TIOCMBIS	0x5416
+#define TIOCMBIC	0x5417
+#define TIOCMSET	0x5418
+#define TIOCGSOFTCAR	0x5419
+#define TIOCSSOFTCAR	0x541A
+#define FIONREAD	0x541B
+#define TIOCINQ		FIONREAD
+#define TIOCLINUX	0x541C
+#define TIOCCONS	0x541D
+#define TIOCGSERIAL	0x541E
+#define TIOCSSERIAL	0x541F
+#define TIOCPKT		0x5420
+#define FIONBIO		0x5421
+#define TIOCNOTTY	0x5422
+#define TIOCSETD	0x5423
+#define TIOCGETD	0x5424
+#define TCSBRKP		0x5425 /* Needed for POSIX tcsendbreak() */
+#define TIOCTTYGSTRUCT	0x5426 /* For debugging only */
+#define TIOCSBRK	0x5427 /* BSD compatibility */
+#define TIOCCBRK	0x5428 /* BSD compatibility */
+#define TIOCGSID	0x5429 /* Return the session ID of FD */
+/* Get Pty Number (of pty-mux device) */
+#define TIOCGPTN	_IOR('T', 0x30, unsigned int)
+#define TIOCSPTLCK	_IOW('T', 0x31, int) /* Lock/unlock Pty */
+
+#define FIONCLEX	0x5450 /* these numbers need to be adjusted. */
+#define FIOCLEX		0x5451
+#define FIOASYNC	0x5452
+#define TIOCSERCONFIG	0x5453
+#define TIOCSERGWILD	0x5454
+#define TIOCSERSWILD	0x5455
+#define TIOCGLCKTRMIOS	0x5456
+#define TIOCSLCKTRMIOS	0x5457
+#define TIOCSERGSTRUCT	0x5458 /* For debugging only */
+#define TIOCSERGETLSR	0x5459 /* Get line status register */
+#define TIOCSERGETMULTI 0x545A /* Get multiport config */
+#define TIOCSERSETMULTI 0x545B /* Set multiport config */
+
+#define TIOCMIWAIT	0x545C /* wait for a change on serial input line(s) */
+#define TIOCGICOUNT	0x545D /* read serial port inline interrupt counts */
+
+#define	FIOQSIZE	0x545E
+
+/* Used for packet mode */
+#define TIOCPKT_DATA		0
+#define TIOCPKT_FLUSHREAD	1
+#define TIOCPKT_FLUSHWRITE	2
+#define TIOCPKT_STOP		4
+#define TIOCPKT_START		8
+#define TIOCPKT_NOSTOP		16
+#define TIOCPKT_DOSTOP		32
+
+#define TIOCSER_TEMT	0x01 /* Transmitter physically empty */
+
+#endif /* _ASM_MICROBLAZE_IOCTLS_H */
-- 
1.5.4.GIT

