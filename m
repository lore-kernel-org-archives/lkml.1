Return-Path: <linux-kernel-owner+w=401wt.eu-S1756980AbYAZQCH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980AbYAZQCH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 11:02:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756237AbYAZPze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 10:55:34 -0500
Received: from 206-47-31-89.wifiinternet.cz ([89.31.47.206]:1177 "EHLO
	monstr.monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755391AbYAZPza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 10:55:30 -0500
From: monstr@monstr.eu
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH 35/52] [microblaze] ioctl support
Date: Thu, 24 Jan 2008 16:03:10 +0100
Message-Id: <43f77bd3045d72346eb39d3170de727050c835c1.1201107832.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.rc4.14.g6fc74
In-Reply-To: <b501d439bdfabddbdef5935db86b6f64c83d55c4.1201107832.git.monstr@monstr.eu>
References: <1201187014-3979-1-git-send-email-monstr@monstr.eu>
 <dbff6b883dbcb108db53e5093994c473946e1240.1201107832.git.monstr@monstr.eu>
 <ac0947adfe718fcb4c0dc5f6f7ab64f8155541fb.1201107832.git.monstr@monstr.eu>
 <873c2bf1f67696aa11014886470f6ba46f04e8d2.1201107832.git.monstr@monstr.eu>
 <516d173b1789ea533431e8f5ad05751c6a353c88.1201107832.git.monstr@monstr.eu>
 <068508828aac6298b4cc65b0cd7b2737a61c466c.1201107832.git.monstr@monstr.eu>
 <010fc233f82a8f7a591c9f8315ae03f9951139aa.1201107832.git.monstr@monstr.eu>
 <68faaf69ea03196d4a56a263707355e7e7eb5c6a.1201107832.git.monstr@monstr.eu>
 <4b7d90fc1b9bcb3c0b1b308c6460390f7bdf3824.1201107832.git.monstr@monstr.eu>
 <eb28582e845efb4f2f26054630895f26fa69866e.1201107832.git.monstr@monstr.eu>
 <64e6e541db30cc4f1ee5cd85da4bdea6024f75b8.1201107832.git.monstr@monstr.eu>
 <90badb264d0e4ec49fdaa76842a5e5f259681299.1201107832.git.monstr@monstr.eu>
 <a013a2b7044186c64d55cdafc8c9b29bc73a7fc5.1201107832.git.monstr@monstr.eu>
 <60642f04ebcf9f76da50a1d40191755f258edcc5.1201107832.git.monstr@monstr.eu>
 <240998be1af3774635995fd19248f8b3a9e8a702.1201107832.git.monstr@monstr.eu>
 <3bcb9581bc512fdd0a124ac8322af9e2a8adc975.1201107832.git.monstr@monstr.eu>
 <db7f441df21cfe296a44744747b28f379e75fd49.1201107832.git.monstr@monstr.eu>
 <e6309af7cc6550ef5b399fc0902f1926f9e52e58.1201107832.git.monstr@monstr.eu>
 <2d11eef3abada1f41658a532a483c6121ded8054.1201107832.git.monstr@monstr.eu>
 <48db19662b808ab6f5455dd7f2116e6544c50e95.1201107832.git.monstr@monstr.eu>
 <7b0cfa6ae11749e20c941d0a4f03577141e022f8.1201107832.git.monstr@monstr.eu>
 <2f3db7ba4fe41cb9888adabf0e4e052d4da5c37c.1201107832.git.monstr@monstr.eu>
 <d67010417928d04766e6dd74820b12c249d61814.1201107832.git.monstr@monstr.eu>
 <37627293f081fa40f21234944ddb878d5e711740.1201107832.git.monstr@monstr.eu>
 <105791d33ea12564c70be0dd3fafef386f8e1b55.1201107832.git.monstr@monstr.eu>
 <b501d439bdfabddbdef5935db86b6f64c83d55c4.1201107832.git.monstr@monstr.eu>
In-Reply-To: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
References: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-microblaze/ioctl.h  |   84 +++++++++++++++++++++++++++++++++++
 include/asm-microblaze/ioctls.h |   93 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 177 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-microblaze/ioctl.h
 create mode 100644 include/asm-microblaze/ioctls.h

diff --git a/include/asm-microblaze/ioctl.h b/include/asm-microblaze/ioctl.h
new file mode 100644
index 0000000..c65a664
--- /dev/null
+++ b/include/asm-microblaze/ioctl.h
@@ -0,0 +1,84 @@
+/*
+ * include/asm-microblaze/ioctl.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _MICROBLAZE_IOCTL_H
+#define _MICROBLAZE_IOCTL_H
+
+/*
+ * this was copied from the alpha as it's a bit cleaner there.
+ * -- Cort
+ */
+
+#define _IOC_NRBITS	8
+#define _IOC_TYPEBITS	8
+#define _IOC_SIZEBITS	13
+#define _IOC_DIRBITS	3
+
+#define _IOC_NRMASK	((1 << _IOC_NRBITS)-1)
+#define _IOC_TYPEMASK	((1 << _IOC_TYPEBITS)-1)
+#define _IOC_SIZEMASK	((1 << _IOC_SIZEBITS)-1)
+#define _IOC_DIRMASK	((1 << _IOC_DIRBITS)-1)
+
+#define _IOC_NRSHIFT	0
+#define _IOC_TYPESHIFT	(_IOC_NRSHIFT+_IOC_NRBITS)
+#define _IOC_SIZESHIFT	(_IOC_TYPESHIFT+_IOC_TYPEBITS)
+#define _IOC_DIRSHIFT	(_IOC_SIZESHIFT+_IOC_SIZEBITS)
+
+/*
+ * Direction bits _IOC_NONE could be 0, but OSF/1 gives it a bit.
+ * And this turns out useful to catch old ioctl numbers in header
+ * files for us.
+ */
+#define _IOC_NONE	1U
+#define _IOC_READ	2U
+#define _IOC_WRITE	4U
+
+#define _IOC(dir, type, nr, size) \
+	(((dir) << _IOC_DIRSHIFT) | \
+	((type) << _IOC_TYPESHIFT) | \
+	((nr) << _IOC_NRSHIFT) | \
+	((size) << _IOC_SIZESHIFT))
+
+/* provoke compile error for invalid uses of size argument */
+extern unsigned int __invalid_size_argument_for_IOC;
+#define _IOC_TYPECHECK(t) \
+	((sizeof(t) == sizeof(t[1]) && \
+	sizeof(t) < (1 << _IOC_SIZEBITS)) ? \
+	sizeof(t) : __invalid_size_argument_for_IOC)
+
+/* used to create numbers */
+#define _IO(type, nr)		_IOC(_IOC_NONE, (type), (nr), 0)
+#define _IOR(type, nr, size) \
+			_IOC(_IOC_READ, (type), (nr), (_IOC_TYPECHECK(size)))
+#define _IOW(type, nr, size) \
+			_IOC(_IOC_WRITE, (type), (nr), (_IOC_TYPECHECK(size)))
+#define _IOWR(type, nr, size) \
+		_IOC(_IOC_READ|_IOC_WRITE, (type), (nr), (_IOC_TYPECHECK(size)))
+#define _IOR_BAD(type, nr, size) \
+			_IOC(_IOC_READ, (type), (nr), sizeof(size))
+#define _IOW_BAD(type, nr, size) \
+			_IOC(_IOC_WRITE, (type), (nr), sizeof(size))
+#define _IOWR_BAD(type, nr, size) \
+			_IOC(_IOC_READ|_IOC_WRITE, (type), (nr), sizeof(size))
+
+/* used to decode them.. */
+#define _IOC_DIR(nr)		(((nr) >> _IOC_DIRSHIFT) & _IOC_DIRMASK)
+#define _IOC_TYPE(nr)		(((nr) >> _IOC_TYPESHIFT) & _IOC_TYPEMASK)
+#define _IOC_NR(nr)		(((nr) >> _IOC_NRSHIFT) & _IOC_NRMASK)
+#define _IOC_SIZE(nr)		(((nr) >> _IOC_SIZESHIFT) & _IOC_SIZEMASK)
+
+/* various drivers, such as the pcmcia stuff, need these... */
+#define IOC_IN		(_IOC_WRITE << _IOC_DIRSHIFT)
+#define IOC_OUT		(_IOC_READ << _IOC_DIRSHIFT)
+#define IOC_INOUT	((_IOC_WRITE|_IOC_READ) << _IOC_DIRSHIFT)
+#define IOCSIZE_MASK	(_IOC_SIZEMASK << _IOC_SIZESHIFT)
+#define IOCSIZE_SHIFT	(_IOC_SIZESHIFT)
+
+#endif /* _MICROBLAZE_IOCTL_H */
diff --git a/include/asm-microblaze/ioctls.h b/include/asm-microblaze/ioctls.h
new file mode 100644
index 0000000..2ea08e0
--- /dev/null
+++ b/include/asm-microblaze/ioctls.h
@@ -0,0 +1,93 @@
+/*
+ * include/asm-microblaze/ioctls.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_IOCTLS_H
+#define _ASM_IOCTLS_H
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
+#endif /* _ASM_IOCTLS_H */
-- 
1.5.4.rc4.14.g6fc74

