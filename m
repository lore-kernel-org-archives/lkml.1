Return-Path: <linux-kernel-owner+w=401wt.eu-S1756466AbXFOG44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466AbXFOG44 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 02:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbXFOG4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 02:56:49 -0400
Received: from mail2.iitk.ac.in ([203.197.196.2]:59805 "EHLO mail2.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561AbXFOG4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 02:56:48 -0400
X-Greylist: delayed 1959 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jun 2007 02:56:47 EDT
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Message-ID: <4672307B.1030008@cse.iitk.ac.in>
Date: Fri, 15 Jun 2007 11:53:55 +0530
From: Arun Raghavan <arunsr@cse.iitk.ac.in>
User-Agent: Thunderbird 2.0.0.0 (X11/20070425)
MIME-Version: 1.0
To: jdike@karaya.com
CC: linux-kernel@vger.kernel.org
Subject: UML - Compilation problem on 2.6.22-rc4
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------070202020204080806060700"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070202020204080806060700
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello,
I ran into some compilations problems with UML on the 2.6.22-rc4 kernel.
The problem turns up because "paravirt.h" is included in a couple of
headers in asm-i386 without being protected by a "#ifdef CONFIG_PARAVIRT".

I've attached a patch to fix this (i.e. UML compiles and runs fine for
me with these changes). I don't know if this is sufficient for all cases
though (most other uses of the #ifdef include a lengthy #else).

Please keep me in CC as I'm not on the mailing list.

-- Arun

--------------070202020204080806060700
Content-Type: text/x-patch;
 name="uml-paravirt-compile-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="uml-paravirt-compile-fix.patch"

diff -uprN -X /usr/src/linux-2.6.22-rc4/Documentation/dontdiff /usr/src/linux-2.6.22-rc4/include/asm-i386/highmem.h linux-2.6.22-rc4-uml-fix/include/asm-i386/highmem.h
--- /usr/src/linux-2.6.22-rc4/include/asm-i386/highmem.h	2007-06-14 12:12:58.000000000 +0530
+++ linux-2.6.22-rc4-uml-fix/include/asm-i386/highmem.h	2007-06-15 11:34:10.000000000 +0530
@@ -24,7 +24,9 @@
 #include <linux/threads.h>
 #include <asm/kmap_types.h>
 #include <asm/tlbflush.h>
+#ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
+#endif
 
 /* declarations for highmem.c */
 extern unsigned long highstart_pfn, highend_pfn;
diff -uprN -X /usr/src/linux-2.6.22-rc4/Documentation/dontdiff /usr/src/linux-2.6.22-rc4/include/asm-i386/mmu_context.h linux-2.6.22-rc4-uml-fix/include/asm-i386/mmu_context.h
--- /usr/src/linux-2.6.22-rc4/include/asm-i386/mmu_context.h	2007-06-14 12:12:58.000000000 +0530
+++ linux-2.6.22-rc4-uml-fix/include/asm-i386/mmu_context.h	2007-06-15 11:34:24.000000000 +0530
@@ -5,8 +5,9 @@
 #include <asm/atomic.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
+#ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
-#ifndef CONFIG_PARAVIRT
+#else
 #include <asm-generic/mm_hooks.h>
 
 static inline void paravirt_activate_mm(struct mm_struct *prev,

--------------070202020204080806060700--
