Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbXEGIpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbXEGIpO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 04:45:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbXEGIpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 04:45:14 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33904 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754094AbXEGIpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 04:45:11 -0400
Date: Mon, 7 May 2007 18:45:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Consolidate asm/poll.h
Message-Id: <20070507184510.60742ae3.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.0 (GTK+ 2.10.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These files are almost all the same.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/asm-alpha/poll.h   |   26 +-------------------------
 include/asm-arm/poll.h     |   28 +---------------------------
 include/asm-arm26/poll.h   |   22 ++--------------------
 include/asm-avr32/poll.h   |   28 +---------------------------
 include/asm-cris/poll.h    |   27 +--------------------------
 include/asm-frv/poll.h     |   18 +++---------------
 include/asm-generic/Kbuild |    1 +
 include/asm-generic/poll.h |   37 +++++++++++++++++++++++++++++++++++++
 include/asm-h8300/poll.h   |   18 +++---------------
 include/asm-i386/poll.h    |   28 +---------------------------
 include/asm-ia64/poll.h    |   33 +--------------------------------
 include/asm-m32r/poll.h    |   33 +--------------------------------
 include/asm-m68k/poll.h    |   17 +----------------
 include/asm-mips/poll.h    |   21 +--------------------
 include/asm-parisc/poll.h  |   28 +---------------------------
 include/asm-powerpc/poll.h |   25 +------------------------
 include/asm-s390/poll.h    |   36 +-----------------------------------
 include/asm-sh/poll.h      |   28 +---------------------------
 include/asm-sh64/poll.h    |   33 ++-------------------------------
 include/asm-sparc/poll.h   |   14 +-------------
 include/asm-sparc64/poll.h |   14 +-------------
 include/asm-v850/poll.h    |   17 +----------------
 include/asm-x86_64/poll.h  |   28 +---------------------------
 include/asm-xtensa/poll.h  |   20 +-------------------
 24 files changed, 66 insertions(+), 514 deletions(-)
 create mode 100644 include/asm-generic/poll.h

This patch could be made even simpler if we don't mind POLLREMOVE turning
up in a few architectures that didn't have it previously (which should be
OK as POLLREMOVE is not used anywhere in the current tree).

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/include/asm-alpha/poll.h b/include/asm-alpha/poll.h
index 76f8935..c98509d 100644
--- a/include/asm-alpha/poll.h
+++ b/include/asm-alpha/poll.h
@@ -1,25 +1 @@
-#ifndef __ALPHA_POLL_H
-#define __ALPHA_POLL_H
-
-#define POLLIN		(1 << 0)
-#define POLLPRI		(1 << 1)
-#define POLLOUT		(1 << 2)
-#define POLLERR		(1 << 3)
-#define POLLHUP		(1 << 4)
-#define POLLNVAL	(1 << 5)
-#define POLLRDNORM	(1 << 6)
-#define POLLRDBAND	(1 << 7)
-#define POLLWRNORM	(1 << 8)
-#define POLLWRBAND	(1 << 9)
-#define POLLMSG		(1 << 10)
-#define POLLREMOVE	(1 << 12)
-#define POLLRDHUP       (1 << 13)
-
-
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
-
-#endif
+#include <asm-generic/poll.h>
diff --git a/include/asm-arm/poll.h b/include/asm-arm/poll.h
index 5030b2b..c98509d 100644
--- a/include/asm-arm/poll.h
+++ b/include/asm-arm/poll.h
@@ -1,27 +1 @@
-#ifndef __ASMARM_POLL_H
-#define __ASMARM_POLL_H
-
-/* These are specified by iBCS2 */
-#define POLLIN		0x0001
-#define POLLPRI		0x0002
-#define POLLOUT		0x0004
-#define POLLERR		0x0008
-#define POLLHUP		0x0010
-#define POLLNVAL	0x0020
-
-/* The rest seem to be more-or-less nonstandard. Check them! */
-#define POLLRDNORM	0x0040
-#define POLLRDBAND	0x0080
-#define POLLWRNORM	0x0100
-#define POLLWRBAND	0x0200
-#define POLLMSG		0x0400
-#define POLLREMOVE	0x1000
-#define POLLRDHUP       0x2000
-
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
-
-#endif
+#include <asm-generic/poll.h>
diff --git a/include/asm-arm26/poll.h b/include/asm-arm26/poll.h
index 9ccb7f4..1170e70 100644
--- a/include/asm-arm26/poll.h
+++ b/include/asm-arm26/poll.h
@@ -1,26 +1,8 @@
 #ifndef __ASMARM_POLL_H
 #define __ASMARM_POLL_H
 
-/* These are specified by iBCS2 */
-#define POLLIN		0x0001
-#define POLLPRI		0x0002
-#define POLLOUT		0x0004
-#define POLLERR		0x0008
-#define POLLHUP		0x0010
-#define POLLNVAL	0x0020
+#include <asm-generic/poll.h>
 
-/* The rest seem to be more-or-less nonstandard. Check them! */
-#define POLLRDNORM	0x0040
-#define POLLRDBAND	0x0080
-#define POLLWRNORM	0x0100
-#define POLLWRBAND	0x0200
-#define POLLMSG		0x0400
-#define POLLRDHUP       0x2000
-
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
+#undef POLLREMOVE
 
 #endif
diff --git a/include/asm-avr32/poll.h b/include/asm-avr32/poll.h
index 736e297..c98509d 100644
--- a/include/asm-avr32/poll.h
+++ b/include/asm-avr32/poll.h
@@ -1,27 +1 @@
-#ifndef __ASM_AVR32_POLL_H
-#define __ASM_AVR32_POLL_H
-
-/* These are specified by iBCS2 */
-#define POLLIN		0x0001
-#define POLLPRI		0x0002
-#define POLLOUT		0x0004
-#define POLLERR		0x0008
-#define POLLHUP		0x0010
-#define POLLNVAL	0x0020
-
-/* The rest seem to be more-or-less nonstandard. Check them! */
-#define POLLRDNORM	0x0040
-#define POLLRDBAND	0x0080
-#define POLLWRNORM	0x0100
-#define POLLWRBAND	0x0200
-#define POLLMSG		0x0400
-#define POLLREMOVE	0x1000
-#define POLLRDHUP	0x2000
-
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
-
-#endif /* __ASM_AVR32_POLL_H */
+#include <asm-generic/poll.h>
diff --git a/include/asm-cris/poll.h b/include/asm-cris/poll.h
index 1b25d4c..c98509d 100644
--- a/include/asm-cris/poll.h
+++ b/include/asm-cris/poll.h
@@ -1,26 +1 @@
-#ifndef __ASM_CRIS_POLL_H
-#define __ASM_CRIS_POLL_H
-
-/* taken from asm-alpha */
-
-#define POLLIN		1
-#define POLLPRI		2
-#define POLLOUT		4
-#define POLLERR		8
-#define POLLHUP		16
-#define POLLNVAL	32
-#define POLLRDNORM	64
-#define POLLRDBAND	128
-#define POLLWRNORM	256
-#define POLLWRBAND	512
-#define POLLMSG		1024
-#define POLLREMOVE	4096
-#define POLLRDHUP       8192
-
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
-
-#endif
+#include <asm-generic/poll.h>
diff --git a/include/asm-frv/poll.h b/include/asm-frv/poll.h
index c8fe880..0d01479 100644
--- a/include/asm-frv/poll.h
+++ b/include/asm-frv/poll.h
@@ -1,24 +1,12 @@
 #ifndef _ASM_POLL_H
 #define _ASM_POLL_H
 
-#define POLLIN		  1
-#define POLLPRI		  2
-#define POLLOUT		  4
-#define POLLERR		  8
-#define POLLHUP		 16
-#define POLLNVAL	 32
-#define POLLRDNORM	 64
 #define POLLWRNORM	POLLOUT
-#define POLLRDBAND	128
 #define POLLWRBAND	256
-#define POLLMSG		0x0400
-#define POLLRDHUP       0x2000
 
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
+#include <asm-generic/poll.h>
+
+#undef POLLREMOVE
 
 #endif
 
diff --git a/include/asm-generic/Kbuild b/include/asm-generic/Kbuild
index fa14f8c..5bfeef7 100644
--- a/include/asm-generic/Kbuild
+++ b/include/asm-generic/Kbuild
@@ -4,6 +4,7 @@ header-y += fcntl.h
 header-y += ioctl.h
 header-y += ipc.h
 header-y += mman.h
+header-y += poll.h
 header-y += signal.h
 header-y += statfs.h
 
diff --git a/include/asm-generic/poll.h b/include/asm-generic/poll.h
new file mode 100644
index 0000000..44bce83
--- /dev/null
+++ b/include/asm-generic/poll.h
@@ -0,0 +1,37 @@
+#ifndef __ASM_GENERIC_POLL_H
+#define __ASM_GENERIC_POLL_H
+
+/* These are specified by iBCS2 */
+#define POLLIN		0x0001
+#define POLLPRI		0x0002
+#define POLLOUT		0x0004
+#define POLLERR		0x0008
+#define POLLHUP		0x0010
+#define POLLNVAL	0x0020
+
+/* The rest seem to be more-or-less nonstandard. Check them! */
+#define POLLRDNORM	0x0040
+#define POLLRDBAND	0x0080
+#ifndef POLLWRNORM
+#define POLLWRNORM	0x0100
+#endif
+#ifndef POLLWRBAND
+#define POLLWRBAND	0x0200
+#endif
+#ifndef POLLMSG
+#define POLLMSG		0x0400
+#endif
+#ifndef POLLREMOVE
+#define POLLREMOVE	0x1000
+#endif
+#ifndef POLLRDHUP
+#define POLLRDHUP       0x2000
+#endif
+
+struct pollfd {
+	int fd;
+	short events;
+	short revents;
+};
+
+#endif	/* __ASM_GENERIC_POLL_H */
diff --git a/include/asm-h8300/poll.h b/include/asm-h8300/poll.h
index fc52103..f61540c 100644
--- a/include/asm-h8300/poll.h
+++ b/include/asm-h8300/poll.h
@@ -1,23 +1,11 @@
 #ifndef __H8300_POLL_H
 #define __H8300_POLL_H
 
-#define POLLIN		  1
-#define POLLPRI		  2
-#define POLLOUT		  4
-#define POLLERR		  8
-#define POLLHUP		 16
-#define POLLNVAL	 32
-#define POLLRDNORM	 64
 #define POLLWRNORM	POLLOUT
-#define POLLRDBAND	128
 #define POLLWRBAND	256
-#define POLLMSG		0x0400
-#define POLLRDHUP       0x2000
 
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
+#include <asm-generic/poll.h>
+
+#undef POLLREMOVE
 
 #endif
diff --git a/include/asm-i386/poll.h b/include/asm-i386/poll.h
index 2cd4929..c98509d 100644
--- a/include/asm-i386/poll.h
+++ b/include/asm-i386/poll.h
@@ -1,27 +1 @@
-#ifndef __i386_POLL_H
-#define __i386_POLL_H
-
-/* These are specified by iBCS2 */
-#define POLLIN		0x0001
-#define POLLPRI		0x0002
-#define POLLOUT		0x0004
-#define POLLERR		0x0008
-#define POLLHUP		0x0010
-#define POLLNVAL	0x0020
-
-/* The rest seem to be more-or-less nonstandard. Check them! */
-#define POLLRDNORM	0x0040
-#define POLLRDBAND	0x0080
-#define POLLWRNORM	0x0100
-#define POLLWRBAND	0x0200
-#define POLLMSG		0x0400
-#define POLLREMOVE	0x1000
-#define POLLRDHUP       0x2000
-
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
-
-#endif
+#include <asm-generic/poll.h>
diff --git a/include/asm-ia64/poll.h b/include/asm-ia64/poll.h
index bcaf9f1..c98509d 100644
--- a/include/asm-ia64/poll.h
+++ b/include/asm-ia64/poll.h
@@ -1,32 +1 @@
-#ifndef _ASM_IA64_POLL_H
-#define _ASM_IA64_POLL_H
-
-/*
- * poll(2) bit definitions.  Based on <asm-i386/poll.h>.
- *
- * Modified 1998, 1999, 2002
- *	David Mosberger-Tang <davidm@hpl.hp.com>, Hewlett-Packard Co
- */
-
-#define POLLIN		0x0001
-#define POLLPRI		0x0002
-#define POLLOUT		0x0004
-#define POLLERR		0x0008
-#define POLLHUP		0x0010
-#define POLLNVAL	0x0020
-
-#define POLLRDNORM	0x0040
-#define POLLRDBAND	0x0080
-#define POLLWRNORM	0x0100
-#define POLLWRBAND	0x0200
-#define POLLMSG		0x0400
-#define POLLREMOVE	0x1000
-#define POLLRDHUP       0x2000
-
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
-
-#endif /* _ASM_IA64_POLL_H */
+#include <asm-generic/poll.h>
diff --git a/include/asm-m32r/poll.h b/include/asm-m32r/poll.h
index 9e0e700..c98509d 100644
--- a/include/asm-m32r/poll.h
+++ b/include/asm-m32r/poll.h
@@ -1,32 +1 @@
-#ifndef _ASM_M32R_POLL_H
-#define _ASM_M32R_POLL_H
-
-/*
- * poll(2) bit definitions.  Based on <asm-i386/poll.h>.
- *
- * Modified 2004
- *      Hirokazu Takata <takata at linux-m32r.org>
- */
-
-#define POLLIN		0x0001
-#define POLLPRI		0x0002
-#define POLLOUT		0x0004
-#define POLLERR		0x0008
-#define POLLHUP		0x0010
-#define POLLNVAL	0x0020
-
-#define POLLRDNORM	0x0040
-#define POLLRDBAND	0x0080
-#define POLLWRNORM	0x0100
-#define POLLWRBAND	0x0200
-#define POLLMSG		0x0400
-#define POLLREMOVE	0x1000
-#define POLLRDHUP       0x2000
-
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
-
-#endif  /* _ASM_M32R_POLL_H */
+#include <asm-generic/poll.h>
diff --git a/include/asm-m68k/poll.h b/include/asm-m68k/poll.h
index 0fb8843..f080fcd 100644
--- a/include/asm-m68k/poll.h
+++ b/include/asm-m68k/poll.h
@@ -1,24 +1,9 @@
 #ifndef __m68k_POLL_H
 #define __m68k_POLL_H
 
-#define POLLIN		  1
-#define POLLPRI		  2
-#define POLLOUT		  4
-#define POLLERR		  8
-#define POLLHUP		 16
-#define POLLNVAL	 32
-#define POLLRDNORM	 64
 #define POLLWRNORM	POLLOUT
-#define POLLRDBAND	128
 #define POLLWRBAND	256
-#define POLLMSG		0x0400
-#define POLLREMOVE	0x1000
-#define POLLRDHUP       0x2000
 
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
+#include <asm-generic/poll.h>
 
 #endif
diff --git a/include/asm-mips/poll.h b/include/asm-mips/poll.h
index 70881f8..47b9520 100644
--- a/include/asm-mips/poll.h
+++ b/include/asm-mips/poll.h
@@ -1,28 +1,9 @@
 #ifndef __ASM_POLL_H
 #define __ASM_POLL_H
 
-#define POLLIN		0x0001
-#define POLLPRI		0x0002
-#define POLLOUT		0x0004
-
-#define POLLERR		0x0008
-#define POLLHUP		0x0010
-#define POLLNVAL	0x0020
-
-#define POLLRDNORM	0x0040
-#define POLLRDBAND	0x0080
 #define POLLWRNORM	POLLOUT
 #define POLLWRBAND	0x0100
 
-/* These seem to be more or less nonstandard ...  */
-#define POLLMSG		0x0400
-#define POLLREMOVE	0x1000
-#define POLLRDHUP       0x2000
-
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
+#include <asm-generic/poll.h>
 
 #endif /* __ASM_POLL_H */
diff --git a/include/asm-parisc/poll.h b/include/asm-parisc/poll.h
index 20e4d03..c98509d 100644
--- a/include/asm-parisc/poll.h
+++ b/include/asm-parisc/poll.h
@@ -1,27 +1 @@
-#ifndef __PARISC_POLL_H
-#define __PARISC_POLL_H
-
-/* These are specified by iBCS2 */
-#define POLLIN		0x0001
-#define POLLPRI		0x0002
-#define POLLOUT		0x0004
-#define POLLERR		0x0008
-#define POLLHUP		0x0010
-#define POLLNVAL	0x0020
-
-/* The rest seem to be more-or-less nonstandard. Check them! */
-#define POLLRDNORM	0x0040
-#define POLLRDBAND	0x0080
-#define POLLWRNORM	0x0100
-#define POLLWRBAND	0x0200
-#define POLLMSG		0x0400
-#define POLLREMOVE	0x1000
-#define POLLRDHUP       0x2000
-
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
-
-#endif
+#include <asm-generic/poll.h>
diff --git a/include/asm-powerpc/poll.h b/include/asm-powerpc/poll.h
index 9c7d126..c98509d 100644
--- a/include/asm-powerpc/poll.h
+++ b/include/asm-powerpc/poll.h
@@ -1,24 +1 @@
-#ifndef _ASM_POWERPC_POLL_H
-#define _ASM_POWERPC_POLL_H
-
-#define POLLIN		0x0001
-#define POLLPRI		0x0002
-#define POLLOUT		0x0004
-#define POLLERR		0x0008
-#define POLLHUP		0x0010
-#define POLLNVAL	0x0020
-#define POLLRDNORM	0x0040
-#define POLLRDBAND	0x0080
-#define POLLWRNORM	0x0100
-#define POLLWRBAND	0x0200
-#define POLLMSG		0x0400
-#define POLLREMOVE	0x1000
-#define POLLRDHUP       0x2000
-
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
-
-#endif	/* _ASM_POWERPC_POLL_H */
+#include <asm-generic/poll.h>
diff --git a/include/asm-s390/poll.h b/include/asm-s390/poll.h
index 6f7f65a..c98509d 100644
--- a/include/asm-s390/poll.h
+++ b/include/asm-s390/poll.h
@@ -1,35 +1 @@
-/*
- *  include/asm-s390/poll.h
- *
- *  S390 version
- *
- *  Derived from "include/asm-i386/poll.h"
- */
-
-#ifndef __S390_POLL_H
-#define __S390_POLL_H
-
-/* These are specified by iBCS2 */
-#define POLLIN          0x0001
-#define POLLPRI         0x0002
-#define POLLOUT         0x0004
-#define POLLERR         0x0008
-#define POLLHUP         0x0010
-#define POLLNVAL        0x0020
-
-/* The rest seem to be more-or-less nonstandard. Check them! */
-#define POLLRDNORM	0x0040
-#define POLLRDBAND	0x0080
-#define POLLWRNORM	0x0100
-#define POLLWRBAND	0x0200
-#define POLLMSG		0x0400
-#define POLLREMOVE	0x1000
-#define POLLRDHUP       0x2000
-
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
-
-#endif
+#include <asm-generic/poll.h>
diff --git a/include/asm-sh/poll.h b/include/asm-sh/poll.h
index dbca9b3..c98509d 100644
--- a/include/asm-sh/poll.h
+++ b/include/asm-sh/poll.h
@@ -1,27 +1 @@
-#ifndef __ASM_SH_POLL_H
-#define __ASM_SH_POLL_H
-
-/* These are specified by iBCS2 */
-#define POLLIN		0x0001
-#define POLLPRI		0x0002
-#define POLLOUT		0x0004
-#define POLLERR		0x0008
-#define POLLHUP		0x0010
-#define POLLNVAL	0x0020
-
-/* The rest seem to be more-or-less nonstandard. Check them! */
-#define POLLRDNORM	0x0040
-#define POLLRDBAND	0x0080
-#define POLLWRNORM	0x0100
-#define POLLWRBAND	0x0200
-#define POLLMSG		0x0400
-#define POLLREMOVE	0x1000
-#define POLLRDHUP       0x2000
-
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
-
-#endif /* __ASM_SH_POLL_H */
+#include <asm-generic/poll.h>
diff --git a/include/asm-sh64/poll.h b/include/asm-sh64/poll.h
index 3a6cbad..ca29502 100644
--- a/include/asm-sh64/poll.h
+++ b/include/asm-sh64/poll.h
@@ -1,37 +1,8 @@
 #ifndef __ASM_SH64_POLL_H
 #define __ASM_SH64_POLL_H
 
-/*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * include/asm-sh64/poll.h
- *
- * Copyright (C) 2000, 2001  Paolo Alberelli
- *
- */
+#include <asm-generic/poll.h>
 
-/* These are specified by iBCS2 */
-#define POLLIN		0x0001
-#define POLLPRI		0x0002
-#define POLLOUT		0x0004
-#define POLLERR		0x0008
-#define POLLHUP		0x0010
-#define POLLNVAL	0x0020
-
-/* The rest seem to be more-or-less nonstandard. Check them! */
-#define POLLRDNORM	0x0040
-#define POLLRDBAND	0x0080
-#define POLLWRNORM	0x0100
-#define POLLWRBAND	0x0200
-#define POLLMSG		0x0400
-#define POLLRDHUP       0x2000
-
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
+#undef POLLREMOVE
 
 #endif /* __ASM_SH64_POLL_H */
diff --git a/include/asm-sparc/poll.h b/include/asm-sparc/poll.h
index 26f13fb..091d3ad 100644
--- a/include/asm-sparc/poll.h
+++ b/include/asm-sparc/poll.h
@@ -1,24 +1,12 @@
 #ifndef __SPARC_POLL_H
 #define __SPARC_POLL_H
 
-#define POLLIN		  1
-#define POLLPRI		  2
-#define POLLOUT		  4
-#define POLLERR		  8
-#define POLLHUP		 16
-#define POLLNVAL	 32
-#define POLLRDNORM	 64
 #define POLLWRNORM	POLLOUT
-#define POLLRDBAND	128
 #define POLLWRBAND	256
 #define POLLMSG		512
 #define POLLREMOVE	1024
 #define POLLRDHUP       2048
 
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
+#include <asm-generic/poll.h>
 
 #endif
diff --git a/include/asm-sparc64/poll.h b/include/asm-sparc64/poll.h
index ab6b0d1..ebeeb38 100644
--- a/include/asm-sparc64/poll.h
+++ b/include/asm-sparc64/poll.h
@@ -1,24 +1,12 @@
 #ifndef __SPARC64_POLL_H
 #define __SPARC64_POLL_H
 
-#define POLLIN		  1
-#define POLLPRI		  2
-#define POLLOUT		  4
-#define POLLERR		  8
-#define POLLHUP		 16
-#define POLLNVAL	 32
-#define POLLRDNORM	 64
 #define POLLWRNORM	POLLOUT
-#define POLLRDBAND	128
 #define POLLWRBAND	256
 #define POLLMSG		512
 #define POLLREMOVE	1024
 #define POLLRDHUP       2048
 
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
+#include <asm-generic/poll.h>
 
 #endif
diff --git a/include/asm-v850/poll.h b/include/asm-v850/poll.h
index c10176c..803cad0 100644
--- a/include/asm-v850/poll.h
+++ b/include/asm-v850/poll.h
@@ -1,24 +1,9 @@
 #ifndef __V850_POLL_H__
 #define __V850_POLL_H__
 
-#define POLLIN		0x0001
-#define POLLPRI		0x0002
-#define POLLOUT		0x0004
-#define POLLERR		0x0008
-#define POLLHUP		0x0010
-#define POLLNVAL	0x0020
-#define POLLRDNORM	0x0040
 #define POLLWRNORM	POLLOUT
-#define POLLRDBAND	0x0080
 #define POLLWRBAND	0x0100
-#define POLLMSG		0x0400
-#define POLLREMOVE	0x1000
-#define POLLRDHUP       0x2000
 
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
+#include <asm-generic/poll.h>
 
 #endif /* __V850_POLL_H__ */
diff --git a/include/asm-x86_64/poll.h b/include/asm-x86_64/poll.h
index c0475a9..c98509d 100644
--- a/include/asm-x86_64/poll.h
+++ b/include/asm-x86_64/poll.h
@@ -1,27 +1 @@
-#ifndef __x86_64_POLL_H
-#define __x86_64_POLL_H
-
-/* These are specified by iBCS2 */
-#define POLLIN		0x0001
-#define POLLPRI		0x0002
-#define POLLOUT		0x0004
-#define POLLERR		0x0008
-#define POLLHUP		0x0010
-#define POLLNVAL	0x0020
-
-/* The rest seem to be more-or-less nonstandard. Check them! */
-#define POLLRDNORM	0x0040
-#define POLLRDBAND	0x0080
-#define POLLWRNORM	0x0100
-#define POLLWRBAND	0x0200
-#define POLLMSG		0x0400
-#define POLLREMOVE	0x1000
-#define POLLRDHUP       0x2000
-
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
-
-#endif
+#include <asm-generic/poll.h>
diff --git a/include/asm-xtensa/poll.h b/include/asm-xtensa/poll.h
index 6fd9477..9d2d599 100644
--- a/include/asm-xtensa/poll.h
+++ b/include/asm-xtensa/poll.h
@@ -11,28 +11,10 @@
 #ifndef _XTENSA_POLL_H
 #define _XTENSA_POLL_H
 
-
-#define POLLIN		0x0001
-#define POLLPRI		0x0002
-#define POLLOUT		0x0004
-
-#define POLLERR		0x0008
-#define POLLHUP		0x0010
-#define POLLNVAL	0x0020
-
-#define POLLRDNORM	0x0040
-#define POLLRDBAND	0x0080
 #define POLLWRNORM	POLLOUT
 #define POLLWRBAND	0x0100
-
-#define POLLMSG		0x0400
 #define POLLREMOVE	0x0800
-#define POLLRDHUP       0x2000
 
-struct pollfd {
-	int fd;
-	short events;
-	short revents;
-};
+#include <asm-generic/poll.h>
 
 #endif /* _XTENSA_POLL_H */
-- 
1.5.1.3

