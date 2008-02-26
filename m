Return-Path: <linux-kernel-owner+w=401wt.eu-S1762576AbYBZJ0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762576AbYBZJ0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 04:26:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761377AbYBZJ0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 04:26:35 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:53905 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762085AbYBZJ0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 04:26:34 -0500
Date: Tue, 26 Feb 2008 04:26:09 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Generalize asm-generic/ioctl.h to allow overriding values.
Message-ID: <alpine.LFD.1.00.0802260421550.27115@localhost.localdomain>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In the spirit of a number of other asm-generic header files,
generalize asm-generic/ioctl.h to allow arch-specific ioctl.h headers
to simply override _IOC_SIZEBITS and/or _IOC_DIRBITS before including
this header file, allowing a number of ioctl.h header files to be
shortened considerably.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  i'm not sure what kernel subsystem this falls under.  this change
should not affect anything in the kernel, and the corresponding
ioctl.h headers can be tweaked sometime down the road.


diff --git a/include/asm-generic/ioctl.h b/include/asm-generic/ioctl.h
index cd02729..4fb087a 100644
--- a/include/asm-generic/ioctl.h
+++ b/include/asm-generic/ioctl.h
@@ -21,8 +21,19 @@
  */
 #define _IOC_NRBITS	8
 #define _IOC_TYPEBITS	8
-#define _IOC_SIZEBITS	14
-#define _IOC_DIRBITS	2
+
+/*
+ * Let any architecture override either of the following before
+ * including this file.
+ */
+
+#ifndef _IOC_SIZEBITS
+# define _IOC_SIZEBITS	14
+#endif
+
+#ifndef _IOC_DIRBITS
+# define _IOC_DIRBITS	2
+#endif

 #define _IOC_NRMASK	((1 << _IOC_NRBITS)-1)
 #define _IOC_TYPEMASK	((1 << _IOC_TYPEBITS)-1)
@@ -35,11 +46,21 @@
 #define _IOC_DIRSHIFT	(_IOC_SIZESHIFT+_IOC_SIZEBITS)

 /*
- * Direction bits.
+ * Direction bits, which any architecture can choose to override
+ * before including this file.
  */
-#define _IOC_NONE	0U
-#define _IOC_WRITE	1U
-#define _IOC_READ	2U
+
+#ifndef _IOC_NONE
+# define _IOC_NONE	0U
+#endif
+
+#ifndef _IOC_WRITE
+# define _IOC_WRITE	1U
+#endif
+
+#ifndef _IOC_READ
+# define _IOC_READ	2U
+#endif

 #define _IOC(dir,type,nr,size) \
 	(((dir)  << _IOC_DIRSHIFT) | \
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
