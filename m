Return-Path: <linux-kernel-owner+w=401wt.eu-S1762681AbXGJKfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762681AbXGJKfl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 06:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757265AbXGJKff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 06:35:35 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:38397 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757229AbXGJKfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 06:35:34 -0400
X-Originating-Ip: 72.143.66.27
Date: Tue, 10 Jul 2007 06:33:26 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Make asm-generic/ioctl.h more generic using conditionals.
Message-ID: <Pine.LNX.4.64.0707100629070.11966@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Allow individual architectures to override a small set of macros
before including asm-generic/ioctl.h, in order to greatly simplify a
number of existing ioctl.h files.

The overrideable macros would be:

	_IOC_SIZEBITS
	_IOC_DIRBITS
	_IOC_NONE
	_IOC_WRITE
	_IOC_READ

---

  i've submitted this once before, and it didn't seem to garner a lot
of attention one way or the other.  this patch can be applied
standalone and shouldn't affect anything, but it would subsequently
allow at least a few ioctl.h files to be shortened considerably.

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

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
