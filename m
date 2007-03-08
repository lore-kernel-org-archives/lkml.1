Return-Path: <linux-kernel-owner+w=401wt.eu-S933322AbXCHVFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933322AbXCHVFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 16:05:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933327AbXCHVFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 16:05:49 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:50793 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933322AbXCHVFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 16:05:48 -0500
X-Originating-Ip: 74.109.98.130
Date: Thu, 8 Mar 2007 16:03:10 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: any thoughts yet on a "generic" ioctl.h?
Message-ID: <Pine.LNX.4.64.0703081556260.9349@CPE00045a9c397f-CM001225dbafb6>
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


  i asked about this a while back, but i still haven't heard a
definitive response as to whether it's acceptable.  that is, extending
the header file "asm-generic/ioctl.h" to allow arch-specific ioctl.h
header files to override what little might need to be changed from the
generic file:

==================================================
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
========================================

  from just a cursory examination, the only values that seem to ever
need to be different are the ones mentioned above, which would make
some of those arch-specific ioctl.h files *way* shorter than they are
now.

  is this considered an acceptable kernel programming practise?  or is
it understood that, if an arch-specific header file differs *at* *all*
from the generic one, it will be a *complete* replacement for that
generic version?

rday

p.s.  i haven't looked but i'd have to guess that there are some other
header files that could be modified the same way.

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
