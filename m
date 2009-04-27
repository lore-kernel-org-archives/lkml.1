Return-Path: <linux-kernel-owner+w=401wt.eu-S1760502AbZD0TMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760502AbZD0TMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 15:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760443AbZD0TKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 15:10:30 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:38607 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760313AbZD0TKZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 15:10:25 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
Date: Mon, 27 Apr 2009 15:10:22 -0400
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3; KDE/4.2.2; i686; ; )
MIME-version: 1.0
Subject: Fwd:
To: linux-kernel@vger.kernel.org
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-disposition: inline
Message-id: <200904271510.23045.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----------  Forwarded Message  ----------

Subject: 
Date: Monday 27 April 2009
From: arnd@arndb.de
To: "no To-header on input" <unlisted-recipients:; @gmail-pop.l.google.com>

>From arnd@arndb.de Mon Apr 27 16:28:40 2009
References: <20090427142010.587518220@arndb.de>
User-Agent: quilt/0.46-1
Date: Mon, 27 Apr 2009 16:20:19 +0200
From: arnd@arndb.de
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com,
 monstr@monstr.eu,
 linux-api@vger.kernel.org,
 linux-arch@vger.kernel.org,
 liqin.chen@sunplusct.com,
 Sam Ravnborg <sam@ravnborg.org>,
 Remis Lima Baima <remis.developer@googlemail.com>
Subject: [RFC 09/17] asm-generic: provide a common types.h
Content-Disposition: inline; filename=0005-asm-generic-provide-a-common-
types.h.patch
X-Provags-ID: V01U2FsdGVkX18CtpQVZB8+uYG04E5Ehl7KULQiGraPHHFdOjH
 5fDYksm+c91dCkXzqZf6HH7oArMpWHrsQddsvgiX1UIVuP/D0R
 ZINN5yOdm9bONtZja8VfA==

Practically all 32 bit architectures can use the same definitions in
asm/types.h, so make that the default.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Remis Lima Baima <remis.developer@googlemail.com>
---
 include/asm-generic/Kbuild  |    1 	1 +	0 -	0 !
 include/asm-generic/types.h |   42 	42 +	0 -	0 !
 2 files changed, 43 insertions(+)
 create mode 100644 include/asm-generic/types.h

Index: linux-2.6/include/asm-generic/Kbuild
===================================================================
--- linux-2.6.orig/include/asm-generic/Kbuild
+++ linux-2.6/include/asm-generic/Kbuild
@@ -14,6 +14,7 @@ header-y += signal-defs.h
 header-y += signal.h
 header-y += statfs.h
 header-y += termios.h
+header-y += types.h
 
 unifdef-y += int-l64.h
 unifdef-y += int-ll64.h
Index: linux-2.6/include/asm-generic/types.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-generic/types.h
@@ -0,0 +1,42 @@
+#ifndef _ASM_GENERIC_TYPES_H
+#define _ASM_GENERIC_TYPES_H
+/*
+ * int-ll64 is used practically everywhere now,
+ * so use it as a reasonable default.
+ */
+#include <asm-generic/int-ll64.h>
+
+#ifndef __ASSEMBLY__
+
+typedef unsigned short umode_t;
+
+#endif /* __ASSEMBLY__ */
+
+/*
+ * These aren't exported outside the kernel to avoid name space clashes
+ */
+#ifdef __KERNEL__
+#ifndef __ASSEMBLY__
+/*
+ * DMA addresses may be very different from physical addresses
+ * and pointers. i386 and powerpc may have 64 bit DMA on 32 bit
+ * systems, while sparc64 uses 32 bit DMA addresses for 64 bit
+ * physical addresses.
+ * This default defines dma_addr_t to have the same size as
+ * phys_addr_t, which is the most common way.
+ * Do not define the dma64_addr_t type, which never really
+ * worked.
+ */
+#ifndef dma_addr_t
+#ifdef CONFIG_PHYS_ADDR_T_64BIT
+typedef u64 dma_addr_t;
+#else
+typedef u32 dma_addr_t;
+#endif /* CONFIG_PHYS_ADDR_T_64BIT */
+#endif /* dma_addr_t */
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_GENERIC_TYPES_H */

-- 

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/


-------------------------------------------------------

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Backed up the system lately?

