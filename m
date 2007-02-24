Return-Path: <linux-kernel-owner+w=401wt.eu-S1752244AbXBXLra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244AbXBXLra (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 06:47:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbXBXLra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 06:47:30 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:60100 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbXBXLra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 06:47:30 -0500
X-Originating-Ip: 74.109.98.130
Date: Sat, 24 Feb 2007 06:45:20 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][RFC] Make asm-generic/ioctl.h extensible by adding conditionals.
Message-ID: <Pine.LNX.4.64.0702240641520.15087@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Add some preprocessor checking to asm-generic/ioctl.h to allow other
ioctl.h headers to simply override what are normally trivial
differences.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  as a followup to my earlier post, is it worth making this change to
allow at least a couple arch-specific ioctl.h files to be massively
simplified?


diff --git a/include/asm-generic/ioctl.h b/include/asm-generic/ioctl.h
index cd02729..e035e6d 100644
--- a/include/asm-generic/ioctl.h
+++ b/include/asm-generic/ioctl.h
@@ -21,8 +21,15 @@
  */
 #define _IOC_NRBITS	8
 #define _IOC_TYPEBITS	8
-#define _IOC_SIZEBITS	14
-#define _IOC_DIRBITS	2
+/*
+ *  Let any architecture override either of the following.
+ */
+#ifndef _IOC_SIZEBITS
+# define _IOC_SIZEBITS	14
+#endif
+#ifndef _IOC_DIRBITS
+# define _IOC_DIRBITS	2
+#endif

 #define _IOC_NRMASK	((1 << _IOC_NRBITS)-1)
 #define _IOC_TYPEMASK	((1 << _IOC_TYPEBITS)-1)
@@ -35,11 +42,17 @@
 #define _IOC_DIRSHIFT	(_IOC_SIZESHIFT+_IOC_SIZEBITS)

 /*
- * Direction bits.
+ * Direction bits, which any architecture can choose to override.
  */
-#define _IOC_NONE	0U
-#define _IOC_WRITE	1U
-#define _IOC_READ	2U
+#ifndef _IOC_NONE
+# define _IOC_NONE	0U
+#endif
+#ifndef _IOC_WRITE
+# define _IOC_WRITE	1U
+#endif
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
