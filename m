Return-Path: <linux-kernel-owner+w=401wt.eu-S1758314AbYGHMoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758314AbYGHMoH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 08:44:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757792AbYGHMnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 08:43:22 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:27528 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757009AbYGHMnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 08:43:19 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: monstr@seznam.cz, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, vapier.adi@gmail.com,
       alan@lxorguk.ukuu.org.uk, hpa@zytor.com, lethal@linux-sh.org,
       florian@openwrt.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 34/58] microblaze_v5: ioctl support
Date: Tue,  8 Jul 2008 13:59:34 +0200
Message-Id: <d1d33c18956829ec9ac7daf8d0516b17e85ed190.1215517976.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <c7120d8a6379cb1a18af5330997e30ec974acc2f.1215517976.git.monstr@monstr.eu>
References: <1215518398-5057-1-git-send-email-monstr@monstr.eu>
 <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
 <c03d29cbccaef8aed8a2911c2a259fbd79ad23d9.1215517976.git.monstr@monstr.eu>
 <58f35f498bac29e7105c589c06567e86c5a42dd5.1215517976.git.monstr@monstr.eu>
 <810775b1bb678003923039726a9153ee34fb67b4.1215517976.git.monstr@monstr.eu>
 <2a24e5bc2cfbd349613ef10c716a28f04ce24a9f.1215517976.git.monstr@monstr.eu>
 <3171c5cf21eefc79665165f4a14bc5b68dd03f95.1215517976.git.monstr@monstr.eu>
 <9be4eff2f4d015023c453eaec3b3473a44380491.1215517976.git.monstr@monstr.eu>
 <f8e331ed9432719f3c0555c840cbbb7bbc1a6322.1215517976.git.monstr@monstr.eu>
 <4409daf2ac356e902a8f091bb5908eb8a90218bc.1215517976.git.monstr@monstr.eu>
 <f7458acb0252f72b5620d19c76104408ecc2e451.1215517976.git.monstr@monstr.eu>
 <dbd9df742cdd9eb3355d7bc8e39f9dfef6c545e4.1215517976.git.monstr@monstr.eu>
 <1f9a1f345caa749cb630cf85f95f217366395069.1215517976.git.monstr@monstr.eu>
 <fe3686f0f70d838b33642bcbcd7185fc2180b366.1215517976.git.monstr@monstr.eu>
 <e61f5a8579570cf7cd18a22e4106b7f85518928e.1215517976.git.monstr@monstr.eu>
 <59d7e0a5f38b8d38f01f357a071fc93eed36f3a8.1215517976.git.monstr@monstr.eu>
 <143afcf84af583ab66da7e8acfc9eb03b7f3eaa0.1215517976.git.monstr@monstr.eu>
 <a967ee4e5a60b410e2810ce0475e8fd04f99e3ae.1215517976.git.monstr@monstr.eu>
 <c5f0730287365c845746467a9917dbc07d2fca3c.1215517976.git.monstr@monstr.eu>
 <2aa1ac7891af57959237aae3addf4bbe607f55d7.1215517976.git.monstr@monstr.eu>
 <875ba2708f6cd3c585e4d965142e2feb07c39a0e.1215517976.git.monstr@monstr.eu>
 <eb0e741f891335df37c3cd19f1a3ce2f7ce8652a.1215517976.git.monstr@monstr.eu>
 <b28df2ea2419cbda26f9089ed6edcc175c009688.1215517976.git.monstr@monstr.eu>
 <5da1d8f069f18f14faee8c4bff736791179ef6f1.1215517976.git.monstr@monstr.eu>
 <9a32168fe72b772f301216a7090670474af78e49.1215517976.git.monstr@monstr.eu>
 <7ada4bceefc1806a2c8ef73676b7aabd8ac1cad6.1215517976.git.monstr@monstr.eu>
 <701c1dac442ac09f5010cb5356cc1a12bb0abfe1.1215517976.git.monstr@monstr.eu>
 <9b48e9d85b4a5a6dcffce8eef62b232b6bfac8e8.1215517976.git.monstr@monstr.eu>
 <04b0b222b84ba9cfe2507a9081f4d715f2323733.1215517976.git.monstr@monstr.eu>
 <d4c1b3ecfec1bf37ca0ecea6909ad25bbc945630.1215517976.git.monstr@monstr.eu>
 <6e5687d37386334cf122d1eafcca0c6649c955be.1215517976.git.monstr@monstr.eu>
 <689cff1b6d98f60d8f8abc4472193688b524284d.1215517976.git.monstr@monstr.eu>
 <9664f18e7e86af4332018549b29bf0797d6afcd5.1215517976.git.monstr@monstr.eu>
 <c7120d8a6379cb1a18af5330997e30ec974acc2f.1215517976.git.monstr@monstr.eu>
In-Reply-To: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
References: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Acked-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
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

