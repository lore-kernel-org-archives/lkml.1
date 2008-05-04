Return-Path: <linux-kernel-owner+w=401wt.eu-S1756509AbYEEMYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbYEEMYr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 08:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752604AbYEEMYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 08:24:35 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:59580 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751413AbYEEMYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 08:24:34 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH 33/56] microblaze_v2: ioctl support
Date: Sun,  4 May 2008 13:41:22 +0200
Message-Id: <c4000ff625bd217f9bb683e3bf8c7193a82bd744.1209897266.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <8aba2d82c85cd1d5b56de328c1fd080ee51f0211.1209897266.git.monstr@monstr.eu>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>
 <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
 <c805caeb1dd7f6d1349c4a463cb88a5342a170d2.1209897266.git.monstr@monstr.eu>
 <f120ababf2bade9aab7199bffb3014aa606e5a1c.1209897266.git.monstr@monstr.eu>
 <684c36e5ad3f598e5079e88ec195545c4a7150c2.1209897266.git.monstr@monstr.eu>
 <ed3695121faf485d491cecdd96d5d4dcc498411d.1209897266.git.monstr@monstr.eu>
 <0674b1f7abb9a3d564b68c95bc28adc2c2fe9551.1209897266.git.monstr@monstr.eu>
 <9a7c6646e5dd9724c1cf34767adec181481fa3ef.1209897266.git.monstr@monstr.eu>
 <932956128c9c655a218a940eaf02017a5dd0bdf9.1209897266.git.monstr@monstr.eu>
 <2f801c33caee22e112af51ae927c264ce99ead01.1209897266.git.monstr@monstr.eu>
 <2391e49379fb6639f57d9d6e5811f3d49a4c6fda.1209897266.git.monstr@monstr.eu>
 <0873f3a1f3b72591735c6461b51964693cac52e5.1209897266.git.monstr@monstr.eu>
 <0ba1f259d3c17eba54e334622493577493f5065f.1209897266.git.monstr@monstr.eu>
 <694451053534fea7b78fb9d618b53a2b5ebeb602.1209897266.git.monstr@monstr.eu>
 <f0c837df4106a31c1a81917596603918f722ea7b.1209897266.git.monstr@monstr.eu>
 <d883a8d8da812d77fefd47730d28d0bdb7b504e0.1209897266.git.monstr@monstr.eu>
 <625ef466cf121d655539eedc919dd39166087e0c.1209897266.git.monstr@monstr.eu>
 <b5067a1846075ddd1035966ea1edc908579e2e88.1209897266.git.monstr@monstr.eu>
 <378157891bac535dbc55e658d5f03fdd332e85cf.1209897266.git.monstr@monstr.eu>
 <eadcc6f4754df78b69d6d54c404624d0390c8558.1209897266.git.monstr@monstr.eu>
 <4df4022e06b9056202cc2fdf0b99deb01563a0fa.1209897266.git.monstr@monstr.eu>
 <6b0c9864dc80776ae48d6488a6892e5d698751b7.1209897266.git.monstr@monstr.eu>
 <ea5cbbca49c38c506960fddba29cbd8cb24e1a8d.1209897266.git.monstr@monstr.eu>
 <4f4d6ed3fce9b21cdd6dcacb2d72fff7e9830628.1209897266.git.monstr@monstr.eu>
 <35e662a81eb86c7ffb2aaa6141ca38a07789f382.1209897266.git.monstr@monstr.eu>
 <b41fcf3dd830f4ba82692a9bec2406ed0c290e7e.1209897266.git.monstr@monstr.eu>
 <14acb31da2794d2d5916da3db3d75fe2285ac055.1209897266.git.monstr@monstr.eu>
 <598221ce2159046614d7b158ea62d5af51907af3.1209897266.git.monstr@monstr.eu>
 <41c1f410eaafd875246362d10ef9866d8cc2a934.1209897266.git.monstr@monstr.eu>
 <09ce2baf0c8308d3fbca98e7eb36a6aab59112a7.1209897266.git.monstr@monstr.eu>
 <c9418c683be99ae12abb89575c362d586c026bad.1209897266.git.monstr@monstr.eu>
 <cfde3796e95bdd17c32e4fd7762d0aee55967707.1209897266.git.monstr@monstr.eu>
 <8aba2d82c85cd1d5b56de328c1fd080ee51f0211.1209897266.git.monstr@monstr.eu>
In-Reply-To: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
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
index 0000000..7cfaaea
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
+#ifndef _ASM_MICROBLAZE_IOCTL_H
+#define _ASM_MICROBLAZE_IOCTL_H
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
+#endif /* _ASM_MICROBLAZE_IOCTL_H */
diff --git a/include/asm-microblaze/ioctls.h b/include/asm-microblaze/ioctls.h
new file mode 100644
index 0000000..4bc5fd4
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

