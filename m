Return-Path: <linux-kernel-owner+w=401wt.eu-S1757495AbXGMLIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495AbXGMLIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 07:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753736AbXGMLIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 07:08:36 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:48964 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbXGMLIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 07:08:35 -0400
X-Originating-Ip: 72.143.66.27
Date: Fri, 13 Jul 2007 07:05:31 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Ralf Baechle <ralf@linux-mips.org>, Andrew Morton <akpm@osdl.org>
Subject: [PATCH][RFC] MIPS:  Simplify ioctl.h header file.
Message-ID: <Pine.LNX.4.64.0707130700520.9634@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, UPPERCASE_25_50 0.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  given the application of the patch for the enhanced
<asm-generic/ioctl.h> header file I submitted yesterday, this would be
a patch against the MIPS ioctl.h file to shorter it considerably.

  similar trivial patches would be available for alpha, parisc and
powerpc.


diff --git a/include/asm-mips/ioctl.h b/include/asm-mips/ioctl.h
index 2036fcb..ff6c7e0 100644
--- a/include/asm-mips/ioctl.h
+++ b/include/asm-mips/ioctl.h
@@ -8,87 +8,22 @@
 #ifndef _ASM_IOCTL_H
 #define _ASM_IOCTL_H

-/*
- * The original linux ioctl numbering scheme was just a general
- * "anything goes" setup, where more or less random numbers were
- * assigned.  Sorry, I was clueless when I started out on this.
- *
- * On the alpha, we'll try to clean it up a bit, using a more sane
- * ioctl numbering, and also trying to be compatible with OSF/1 in
- * the process. I'd like to clean it up for the i386 as well, but
- * it's so painful recognizing both the new and the old numbers..
- *
- * The same applies for for the MIPS ABI; in fact even the macros
- * from Linux/Alpha fit almost perfectly.
- */
-
-#define _IOC_NRBITS	8
-#define _IOC_TYPEBITS	8
 #define _IOC_SIZEBITS	13
 #define _IOC_DIRBITS	3

-#define _IOC_NRMASK	((1 << _IOC_NRBITS)-1)
-#define _IOC_TYPEMASK	((1 << _IOC_TYPEBITS)-1)
-#define _IOC_SIZEMASK	((1 << _IOC_SIZEBITS)-1)
-#define _IOC_DIRMASK	((1 << _IOC_DIRBITS)-1)
-
-#define _IOC_NRSHIFT	0
-#define _IOC_TYPESHIFT	(_IOC_NRSHIFT+_IOC_NRBITS)
-#define _IOC_SIZESHIFT	(_IOC_TYPESHIFT+_IOC_TYPEBITS)
-#define _IOC_DIRSHIFT	(_IOC_SIZESHIFT+_IOC_SIZEBITS)
-
-/*
- * Direction bits _IOC_NONE could be 0, but OSF/1 gives it a bit.
- * And this turns out useful to catch old ioctl numbers in header
- * files for us.
- */
 #define _IOC_NONE	1U
 #define _IOC_READ	2U
 #define _IOC_WRITE	4U

+#include <asm-generic/ioctl.h>
+
 /*
  * The following are included for compatibility
  */
+
 #define _IOC_VOID	0x20000000
 #define _IOC_OUT	0x40000000
 #define _IOC_IN		0x80000000
 #define _IOC_INOUT	(IOC_IN|IOC_OUT)

-#define _IOC(dir,type,nr,size) \
-	(((dir)  << _IOC_DIRSHIFT) | \
-	 ((type) << _IOC_TYPESHIFT) | \
-	 ((nr)   << _IOC_NRSHIFT) | \
-	 ((size) << _IOC_SIZESHIFT))
-
-/* provoke compile error for invalid uses of size argument */
-extern unsigned int __invalid_size_argument_for_IOC;
-#define _IOC_TYPECHECK(t) \
-	((sizeof(t) == sizeof(t[1]) && \
-	  sizeof(t) < (1 << _IOC_SIZEBITS)) ? \
-	  sizeof(t) : __invalid_size_argument_for_IOC)
-
-/* used to create numbers */
-#define _IO(type,nr)		_IOC(_IOC_NONE,(type),(nr),0)
-#define _IOR(type,nr,size)	_IOC(_IOC_READ,(type),(nr),(_IOC_TYPECHECK(size)))
-#define _IOW(type,nr,size)	_IOC(_IOC_WRITE,(type),(nr),(_IOC_TYPECHECK(size)))
-#define _IOWR(type,nr,size)	_IOC(_IOC_READ|_IOC_WRITE,(type),(nr),(_IOC_TYPECHECK(size)))
-#define _IOR_BAD(type,nr,size)	_IOC(_IOC_READ,(type),(nr),sizeof(size))
-#define _IOW_BAD(type,nr,size)	_IOC(_IOC_WRITE,(type),(nr),sizeof(size))
-#define _IOWR_BAD(type,nr,size)	_IOC(_IOC_READ|_IOC_WRITE,(type),(nr),sizeof(size))
-
-
-/* used to decode them.. */
-#define _IOC_DIR(nr)		(((nr) >> _IOC_DIRSHIFT) & _IOC_DIRMASK)
-#define _IOC_TYPE(nr)		(((nr) >> _IOC_TYPESHIFT) & _IOC_TYPEMASK)
-#define _IOC_NR(nr)		(((nr) >> _IOC_NRSHIFT) & _IOC_NRMASK)
-#define _IOC_SIZE(nr)		(((nr) >> _IOC_SIZESHIFT) & _IOC_SIZEMASK)
-
-/* ...and for the drivers/sound files... */
-
-#define IOC_IN		(_IOC_WRITE << _IOC_DIRSHIFT)
-#define IOC_OUT		(_IOC_READ << _IOC_DIRSHIFT)
-#define IOC_INOUT	((_IOC_WRITE|_IOC_READ) << _IOC_DIRSHIFT)
-#define IOCSIZE_MASK	(_IOC_SIZEMASK << _IOC_SIZESHIFT)
-#define IOCSIZE_SHIFT	(_IOC_SIZESHIFT)
-
 #endif /* _ASM_IOCTL_H */
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
