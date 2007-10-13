Return-Path: <linux-kernel-owner+w=401wt.eu-S1763006AbXJMUss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763006AbXJMUss (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 16:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758493AbXJMUsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 16:48:40 -0400
Received: from sccrmhc14.comcast.net ([204.127.200.84]:62198 "EHLO
	sccrmhc14.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758026AbXJMUsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 16:48:39 -0400
To: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: x86: merge some trivially mergeable headers
X-Message-Flag: Warning: May contain useful information
X-Priority: 1
X-MSMail-Priority: High
From: Roland Dreier <roland@digitalvampire.org>
Date: Sat, 13 Oct 2007 13:48:36 -0700
Message-ID: <87bqb2u4ez.fsf@shaolin.home.digitalvampire.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Merge errno.h, resource.h, rtc.h, sections.h, serial.h and sockios.h,
where i386 and x86_64 have no or only trivial comment/include guard
differences.

Build tested on both 32-bit and 64-bit, and booted on 64-bit.

Signed-off-by: Roland Dreier <roland@digitalvampire.org>
---
Not sure who's merging this type of stuff so I just picked a grab bag
of people to put on the To: line.

Also I'm not sure if someone else is already working on this, so I'm
just sending out about 15 minutes of work.  If this is helpful I'll do
more of the easy ones...

 include/asm-x86/errno.h       |   19 ++++++++-----------
 include/asm-x86/errno_32.h    |    6 ------
 include/asm-x86/errno_64.h    |    6 ------
 include/asm-x86/resource.h    |   19 ++++++++-----------
 include/asm-x86/resource_32.h |    6 ------
 include/asm-x86/resource_64.h |    6 ------
 include/asm-x86/rtc.h         |   15 ++++++++++-----
 include/asm-x86/rtc_32.h      |   10 ----------
 include/asm-x86/rtc_64.h      |   10 ----------
 include/asm-x86/sections.h    |    9 +++++----
 include/asm-x86/sections_32.h |    7 -------
 include/asm-x86/sections_64.h |    7 -------
 include/asm-x86/serial.h      |   30 +++++++++++++++++++++++++++---
 include/asm-x86/serial_32.h   |   29 -----------------------------
 include/asm-x86/serial_64.h   |   29 -----------------------------
 include/asm-x86/sockios.h     |   26 +++++++++++++++-----------
 include/asm-x86/sockios_32.h  |   13 -------------
 include/asm-x86/sockios_64.h  |   13 -------------
 18 files changed, 73 insertions(+), 187 deletions(-)
 delete mode 100644 include/asm-x86/errno_32.h
 delete mode 100644 include/asm-x86/errno_64.h
 delete mode 100644 include/asm-x86/resource_32.h
 delete mode 100644 include/asm-x86/resource_64.h
 delete mode 100644 include/asm-x86/rtc_32.h
 delete mode 100644 include/asm-x86/rtc_64.h
 delete mode 100644 include/asm-x86/sections_32.h
 delete mode 100644 include/asm-x86/sections_64.h
 delete mode 100644 include/asm-x86/serial_32.h
 delete mode 100644 include/asm-x86/serial_64.h
 delete mode 100644 include/asm-x86/sockios_32.h
 delete mode 100644 include/asm-x86/sockios_64.h

diff --git a/include/asm-x86/errno.h b/include/asm-x86/errno.h
index 9d511be..e06fe53 100644
--- a/include/asm-x86/errno.h
+++ b/include/asm-x86/errno.h
@@ -1,13 +1,10 @@
 #ifdef __KERNEL__
-# ifdef CONFIG_X86_32
-#  include "errno_32.h"
-# else
-#  include "errno_64.h"
-# endif
-#else
-# ifdef __i386__
-#  include "errno_32.h"
-# else
-#  include "errno_64.h"
-# endif
+
+#ifndef _ASM_X86_ERRNO_H
+#define _ASM_X86_ERRNO_H
+
+#include <asm-generic/errno.h>
+
+#endif /* _ASM_X86_ERRNO_H */
+
 #endif
diff --git a/include/asm-x86/errno_32.h b/include/asm-x86/errno_32.h
deleted file mode 100644
index 969b343..0000000
--- a/include/asm-x86/errno_32.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _I386_ERRNO_H
-#define _I386_ERRNO_H
-
-#include <asm-generic/errno.h>
-
-#endif
diff --git a/include/asm-x86/errno_64.h b/include/asm-x86/errno_64.h
deleted file mode 100644
index 3111821..0000000
--- a/include/asm-x86/errno_64.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _X8664_ERRNO_H
-#define _X8664_ERRNO_H
-
-#include <asm-generic/errno.h>
-
-#endif
diff --git a/include/asm-x86/resource.h b/include/asm-x86/resource.h
index 732410a..df20199 100644
--- a/include/asm-x86/resource.h
+++ b/include/asm-x86/resource.h
@@ -1,13 +1,10 @@
 #ifdef __KERNEL__
-# ifdef CONFIG_X86_32
-#  include "resource_32.h"
-# else
-#  include "resource_64.h"
-# endif
-#else
-# ifdef __i386__
-#  include "resource_32.h"
-# else
-#  include "resource_64.h"
-# endif
+
+#ifndef _ASM_X86_RESOURCE_H
+#define _ASM_X86_RESOURCE_H
+
+#include <asm-generic/resource.h>
+
+#endif /* _ASM_X86_RESOURCE_H */
+
 #endif
diff --git a/include/asm-x86/resource_32.h b/include/asm-x86/resource_32.h
deleted file mode 100644
index 6c1ea37..0000000
--- a/include/asm-x86/resource_32.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _I386_RESOURCE_H
-#define _I386_RESOURCE_H
-
-#include <asm-generic/resource.h>
-
-#endif
diff --git a/include/asm-x86/resource_64.h b/include/asm-x86/resource_64.h
deleted file mode 100644
index f40b406..0000000
--- a/include/asm-x86/resource_64.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _X8664_RESOURCE_H
-#define _X8664_RESOURCE_H
-
-#include <asm-generic/resource.h>
-
-#endif
diff --git a/include/asm-x86/rtc.h b/include/asm-x86/rtc.h
index 1f0c98e..70838ea 100644
--- a/include/asm-x86/rtc.h
+++ b/include/asm-x86/rtc.h
@@ -1,5 +1,10 @@
-#ifdef CONFIG_X86_32
-# include "rtc_32.h"
-#else
-# include "rtc_64.h"
-#endif
+#ifndef _ASM_X86_RTC_H
+#define _ASM_X86_RTC_H
+
+/*
+ * x86 uses the default access methods for the RTC.
+ */
+
+#include <asm-generic/rtc.h>
+
+#endif /* _ASM_X86_RTC_H */
diff --git a/include/asm-x86/rtc_32.h b/include/asm-x86/rtc_32.h
deleted file mode 100644
index ffd0210..0000000
--- a/include/asm-x86/rtc_32.h
+++ /dev/null
@@ -1,10 +0,0 @@
-#ifndef _I386_RTC_H
-#define _I386_RTC_H
-
-/*
- * x86 uses the default access methods for the RTC.
- */
-
-#include <asm-generic/rtc.h>
-
-#endif
diff --git a/include/asm-x86/rtc_64.h b/include/asm-x86/rtc_64.h
deleted file mode 100644
index 18ed713..0000000
--- a/include/asm-x86/rtc_64.h
+++ /dev/null
@@ -1,10 +0,0 @@
-#ifndef _X86_64_RTC_H
-#define _X86_64_RTC_H
-
-/*
- * x86 uses the default access methods for the RTC.
- */
-
-#include <asm-generic/rtc.h>
-
-#endif
diff --git a/include/asm-x86/sections.h b/include/asm-x86/sections.h
index ae6c69d..bf0f2b2 100644
--- a/include/asm-x86/sections.h
+++ b/include/asm-x86/sections.h
@@ -1,5 +1,6 @@
-#ifdef CONFIG_X86_32
-# include "sections_32.h"
-#else
-# include "sections_64.h"
+#ifndef _ASM_X86_SECTIONS_H
+#define _ASM_X86_SECTIONS_H
+
+#include <asm-generic/sections.h>
+
 #endif
diff --git a/include/asm-x86/sections_32.h b/include/asm-x86/sections_32.h
deleted file mode 100644
index 2dcbb92..0000000
--- a/include/asm-x86/sections_32.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef _I386_SECTIONS_H
-#define _I386_SECTIONS_H
-
-/* nothing to see, move along */
-#include <asm-generic/sections.h>
-
-#endif
diff --git a/include/asm-x86/sections_64.h b/include/asm-x86/sections_64.h
deleted file mode 100644
index c746d9f..0000000
--- a/include/asm-x86/sections_64.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef _X8664_SECTIONS_H
-#define _X8664_SECTIONS_H
-
-/* nothing to see, move along */
-#include <asm-generic/sections.h>
-
-#endif
diff --git a/include/asm-x86/serial.h b/include/asm-x86/serial.h
index cf1b052..628c801 100644
--- a/include/asm-x86/serial.h
+++ b/include/asm-x86/serial.h
@@ -1,5 +1,29 @@
-#ifdef CONFIG_X86_32
-# include "serial_32.h"
+#ifndef _ASM_X86_SERIAL_H
+#define _ASM_X86_SERIAL_H
+
+/*
+ * This assumes you have a 1.8432 MHz clock for your UART.
+ *
+ * It'd be nice if someone built a serial card with a 24.576 MHz
+ * clock, since the 16550A is capable of handling a top speed of 1.5
+ * megabits/second; but this requires the faster clock.
+ */
+#define BASE_BAUD ( 1843200 / 16 )
+
+/* Standard COM flags (except for COM4, because of the 8514 problem) */
+#ifdef CONFIG_SERIAL_DETECT_IRQ
+#define STD_COM_FLAGS (ASYNC_BOOT_AUTOCONF | ASYNC_SKIP_TEST | ASYNC_AUTO_IRQ)
+#define STD_COM4_FLAGS (ASYNC_BOOT_AUTOCONF | ASYNC_AUTO_IRQ)
 #else
-# include "serial_64.h"
+#define STD_COM_FLAGS (ASYNC_BOOT_AUTOCONF | ASYNC_SKIP_TEST)
+#define STD_COM4_FLAGS ASYNC_BOOT_AUTOCONF
 #endif
+
+#define SERIAL_PORT_DFNS			\
+	/* UART CLK   PORT IRQ     FLAGS        */			\
+	{ 0, BASE_BAUD, 0x3F8, 4, STD_COM_FLAGS },	/* ttyS0 */	\
+	{ 0, BASE_BAUD, 0x2F8, 3, STD_COM_FLAGS },	/* ttyS1 */	\
+	{ 0, BASE_BAUD, 0x3E8, 4, STD_COM_FLAGS },	/* ttyS2 */	\
+	{ 0, BASE_BAUD, 0x2E8, 3, STD_COM4_FLAGS },	/* ttyS3 */
+
+#endif /* _ASM_X86_SERIAL_H */
diff --git a/include/asm-x86/serial_32.h b/include/asm-x86/serial_32.h
deleted file mode 100644
index bd67480..0000000
--- a/include/asm-x86/serial_32.h
+++ /dev/null
@@ -1,29 +0,0 @@
-/*
- * include/asm-i386/serial.h
- */
-
-
-/*
- * This assumes you have a 1.8432 MHz clock for your UART.
- *
- * It'd be nice if someone built a serial card with a 24.576 MHz
- * clock, since the 16550A is capable of handling a top speed of 1.5
- * megabits/second; but this requires the faster clock.
- */
-#define BASE_BAUD ( 1843200 / 16 )
-
-/* Standard COM flags (except for COM4, because of the 8514 problem) */
-#ifdef CONFIG_SERIAL_DETECT_IRQ
-#define STD_COM_FLAGS (ASYNC_BOOT_AUTOCONF | ASYNC_SKIP_TEST | ASYNC_AUTO_IRQ)
-#define STD_COM4_FLAGS (ASYNC_BOOT_AUTOCONF | ASYNC_AUTO_IRQ)
-#else
-#define STD_COM_FLAGS (ASYNC_BOOT_AUTOCONF | ASYNC_SKIP_TEST)
-#define STD_COM4_FLAGS ASYNC_BOOT_AUTOCONF
-#endif
-
-#define SERIAL_PORT_DFNS			\
-	/* UART CLK   PORT IRQ     FLAGS        */			\
-	{ 0, BASE_BAUD, 0x3F8, 4, STD_COM_FLAGS },	/* ttyS0 */	\
-	{ 0, BASE_BAUD, 0x2F8, 3, STD_COM_FLAGS },	/* ttyS1 */	\
-	{ 0, BASE_BAUD, 0x3E8, 4, STD_COM_FLAGS },	/* ttyS2 */	\
-	{ 0, BASE_BAUD, 0x2E8, 3, STD_COM4_FLAGS },	/* ttyS3 */
diff --git a/include/asm-x86/serial_64.h b/include/asm-x86/serial_64.h
deleted file mode 100644
index b0496e0..0000000
--- a/include/asm-x86/serial_64.h
+++ /dev/null
@@ -1,29 +0,0 @@
-/*
- * include/asm-x86_64/serial.h
- */
-
-
-/*
- * This assumes you have a 1.8432 MHz clock for your UART.
- *
- * It'd be nice if someone built a serial card with a 24.576 MHz
- * clock, since the 16550A is capable of handling a top speed of 1.5
- * megabits/second; but this requires the faster clock.
- */
-#define BASE_BAUD ( 1843200 / 16 )
-
-/* Standard COM flags (except for COM4, because of the 8514 problem) */
-#ifdef CONFIG_SERIAL_DETECT_IRQ
-#define STD_COM_FLAGS (ASYNC_BOOT_AUTOCONF | ASYNC_SKIP_TEST | ASYNC_AUTO_IRQ)
-#define STD_COM4_FLAGS (ASYNC_BOOT_AUTOCONF | ASYNC_AUTO_IRQ)
-#else
-#define STD_COM_FLAGS (ASYNC_BOOT_AUTOCONF | ASYNC_SKIP_TEST)
-#define STD_COM4_FLAGS ASYNC_BOOT_AUTOCONF
-#endif
-
-#define SERIAL_PORT_DFNS			\
-	/* UART CLK   PORT IRQ     FLAGS        */			\
-	{ 0, BASE_BAUD, 0x3F8, 4, STD_COM_FLAGS },	/* ttyS0 */	\
-	{ 0, BASE_BAUD, 0x2F8, 3, STD_COM_FLAGS },	/* ttyS1 */	\
-	{ 0, BASE_BAUD, 0x3E8, 4, STD_COM_FLAGS },	/* ttyS2 */	\
-	{ 0, BASE_BAUD, 0x2E8, 3, STD_COM4_FLAGS },	/* ttyS3 */
diff --git a/include/asm-x86/sockios.h b/include/asm-x86/sockios.h
index 5a134fc..f3b46d0 100644
--- a/include/asm-x86/sockios.h
+++ b/include/asm-x86/sockios.h
@@ -1,13 +1,17 @@
 #ifdef __KERNEL__
-# ifdef CONFIG_X86_32
-#  include "sockios_32.h"
-# else
-#  include "sockios_64.h"
-# endif
-#else
-# ifdef __i386__
-#  include "sockios_32.h"
-# else
-#  include "sockios_64.h"
-# endif
+
+#ifndef _ASM_X86_SOCKIOS_H
+#define _ASM_X86_SOCKIOS_H
+
+/* Socket-level I/O control calls. */
+#define FIOSETOWN	0x8901
+#define SIOCSPGRP	0x8902
+#define FIOGETOWN	0x8903
+#define SIOCGPGRP	0x8904
+#define SIOCATMARK	0x8905
+#define SIOCGSTAMP	0x8906		/* Get stamp (timeval) */
+#define SIOCGSTAMPNS	0x8907		/* Get stamp (timespec) */
+
+#endif /* _ASM_X86_SOCKIOS_H */
+
 #endif
diff --git a/include/asm-x86/sockios_32.h b/include/asm-x86/sockios_32.h
deleted file mode 100644
index ff528c7..0000000
--- a/include/asm-x86/sockios_32.h
+++ /dev/null
@@ -1,13 +0,0 @@
-#ifndef __ARCH_I386_SOCKIOS__
-#define __ARCH_I386_SOCKIOS__
-
-/* Socket-level I/O control calls. */
-#define FIOSETOWN 	0x8901
-#define SIOCSPGRP	0x8902
-#define FIOGETOWN	0x8903
-#define SIOCGPGRP	0x8904
-#define SIOCATMARK	0x8905
-#define SIOCGSTAMP	0x8906		/* Get stamp (timeval) */
-#define SIOCGSTAMPNS	0x8907		/* Get stamp (timespec) */
-
-#endif
diff --git a/include/asm-x86/sockios_64.h b/include/asm-x86/sockios_64.h
deleted file mode 100644
index d726ba2..0000000
--- a/include/asm-x86/sockios_64.h
+++ /dev/null
@@ -1,13 +0,0 @@
-#ifndef __ARCH_X8664_SOCKIOS__
-#define __ARCH_X8664_SOCKIOS__
-
-/* Socket-level I/O control calls. */
-#define FIOSETOWN 	0x8901
-#define SIOCSPGRP	0x8902
-#define FIOGETOWN	0x8903
-#define SIOCGPGRP	0x8904
-#define SIOCATMARK	0x8905
-#define SIOCGSTAMP	0x8906		/* Get stamp (timeval) */
-#define SIOCGSTAMPNS	0x8907		/* Get stamp (timespec) */
-
-#endif
-- 
1.5.3.2

