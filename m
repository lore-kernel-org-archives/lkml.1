Return-Path: <linux-kernel-owner+w=401wt.eu-S1754053AbXD0Dri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbXD0Dri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 23:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755226AbXD0Dri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 23:47:38 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:33896 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053AbXD0Drg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 23:47:36 -0400
Date: Thu, 26 Apr 2007 20:50:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, ak@suse.de, davem@davemloft.net
Subject: [PATCH -mm] consolidate asm/const.h to linux/const.h
Message-Id: <20070426205008.73a4075e.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Make a global linux/const.h header file instead of having multiple,
per-arch files, and convert current users of asm/const.h to use
linux/const.h.

Built on x86_64 and sparc64.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/asm-sparc64/Kbuild    |    1 -
 include/asm-sparc64/const.h   |   19 -------------------
 include/asm-sparc64/lsu.h     |    2 +-
 include/asm-sparc64/mmu.h     |    2 +-
 include/asm-sparc64/page.h    |    2 +-
 include/asm-sparc64/pgtable.h |    2 +-
 include/asm-sparc64/pstate.h  |    2 +-
 include/asm-sparc64/sfafsr.h  |    2 +-
 include/asm-x86_64/const.h    |   20 --------------------
 include/asm-x86_64/page.h     |    2 +-
 include/asm-x86_64/pgtable.h  |    2 +-
 include/linux/Kbuild          |    1 +
 include/linux/const.h         |   19 +++++++++++++++++++
 13 files changed, 28 insertions(+), 48 deletions(-)

--- linux-2.6.21-rc7-mm2.orig/include/asm-sparc64/const.h
+++ /dev/null
@@ -1,19 +0,0 @@
-/* const.h: Macros for dealing with constants.  */
-
-#ifndef _SPARC64_CONST_H
-#define _SPARC64_CONST_H
-
-/* Some constant macros are used in both assembler and
- * C code.  Therefore we cannot annotate them always with
- * 'UL' and other type specificers unilaterally.  We
- * use the following macros to deal with this.
- */
-
-#ifdef __ASSEMBLY__
-#define _AC(X,Y)	X
-#else
-#define _AC(X,Y)	(X##Y)
-#endif
-
-
-#endif /* !(_SPARC64_CONST_H) */
--- linux-2.6.21-rc7-mm2.orig/include/asm-x86_64/const.h
+++ /dev/null
@@ -1,20 +0,0 @@
-/* const.h: Macros for dealing with constants.  */
-
-#ifndef _X86_64_CONST_H
-#define _X86_64_CONST_H
-
-/* Some constant macros are used in both assembler and
- * C code.  Therefore we cannot annotate them always with
- * 'UL' and other type specificers unilaterally.  We
- * use the following macros to deal with this.
- */
-
-#ifdef __ASSEMBLY__
-#define _AC(X,Y)	X
-#else
-#define __AC(X,Y)	(X##Y)
-#define _AC(X,Y)	__AC(X,Y)
-#endif
-
-
-#endif /* !(_X86_64_CONST_H) */
--- /dev/null
+++ linux-2.6.21-rc7-mm2/include/linux/const.h
@@ -0,0 +1,19 @@
+/* const.h: Macros for dealing with constants.  */
+
+#ifndef _LINUX_CONST_H
+#define _LINUX_CONST_H
+
+/* Some constant macros are used in both assembler and
+ * C code.  Therefore we cannot annotate them always with
+ * 'UL' and other type specifiers unilaterally.  We
+ * use the following macros to deal with this.
+ */
+
+#ifdef __ASSEMBLY__
+#define _AC(X,Y)	X
+#else
+#define __AC(X,Y)	(X##Y)
+#define _AC(X,Y)	__AC(X,Y)
+#endif
+
+#endif /* !(_LINUX_CONST_H) */
--- linux-2.6.21-rc7-mm2.orig/include/asm-x86_64/page.h
+++ linux-2.6.21-rc7-mm2/include/asm-x86_64/page.h
@@ -1,7 +1,7 @@
 #ifndef _X86_64_PAGE_H
 #define _X86_64_PAGE_H
 
-#include <asm/const.h>
+#include <linux/const.h>
 
 /* PAGE_SHIFT determines the page size */
 #define PAGE_SHIFT	12
--- linux-2.6.21-rc7-mm2.orig/include/asm-x86_64/pgtable.h
+++ linux-2.6.21-rc7-mm2/include/asm-x86_64/pgtable.h
@@ -1,7 +1,7 @@
 #ifndef _X86_64_PGTABLE_H
 #define _X86_64_PGTABLE_H
 
-#include <asm/const.h>
+#include <linux/const.h>
 #ifndef __ASSEMBLY__
 
 /*
--- linux-2.6.21-rc7-mm2.orig/include/asm-sparc64/lsu.h
+++ linux-2.6.21-rc7-mm2/include/asm-sparc64/lsu.h
@@ -2,7 +2,7 @@
 #ifndef _SPARC64_LSU_H
 #define _SPARC64_LSU_H
 
-#include <asm/const.h>
+#include <linux/const.h>
 
 /* LSU Control Register */
 #define LSU_CONTROL_PM _AC(0x000001fe00000000,UL) /* Phys-watchpoint byte mask*/
--- linux-2.6.21-rc7-mm2.orig/include/asm-sparc64/mmu.h
+++ linux-2.6.21-rc7-mm2/include/asm-sparc64/mmu.h
@@ -1,8 +1,8 @@
 #ifndef __MMU_H
 #define __MMU_H
 
+#include <linux/const.h>
 #include <asm/page.h>
-#include <asm/const.h>
 #include <asm/hypervisor.h>
 
 #define CTX_NR_BITS		13
--- linux-2.6.21-rc7-mm2.orig/include/asm-sparc64/page.h
+++ linux-2.6.21-rc7-mm2/include/asm-sparc64/page.h
@@ -5,7 +5,7 @@
 
 #ifdef __KERNEL__
 
-#include <asm/const.h>
+#include <linux/const.h>
 
 #if defined(CONFIG_SPARC64_PAGE_SIZE_8KB)
 #define PAGE_SHIFT   13
--- linux-2.6.21-rc7-mm2.orig/include/asm-sparc64/pgtable.h
+++ linux-2.6.21-rc7-mm2/include/asm-sparc64/pgtable.h
@@ -15,13 +15,13 @@
 #include <asm-generic/pgtable-nopud.h>
 
 #include <linux/compiler.h>
+#include <linux/const.h>
 #include <asm/types.h>
 #include <asm/spitfire.h>
 #include <asm/asi.h>
 #include <asm/system.h>
 #include <asm/page.h>
 #include <asm/processor.h>
-#include <asm/const.h>
 
 /* The kernel image occupies 0x4000000 to 0x1000000 (4MB --> 32MB).
  * The page copy blockops can use 0x2000000 to 0x4000000.
--- linux-2.6.21-rc7-mm2.orig/include/asm-sparc64/pstate.h
+++ linux-2.6.21-rc7-mm2/include/asm-sparc64/pstate.h
@@ -2,7 +2,7 @@
 #ifndef _SPARC64_PSTATE_H
 #define _SPARC64_PSTATE_H
 
-#include <asm/const.h>
+#include <linux/const.h>
 
 /* The V9 PSTATE Register (with SpitFire extensions).
  *
--- linux-2.6.21-rc7-mm2.orig/include/asm-sparc64/sfafsr.h
+++ linux-2.6.21-rc7-mm2/include/asm-sparc64/sfafsr.h
@@ -1,7 +1,7 @@
 #ifndef _SPARC64_SFAFSR_H
 #define _SPARC64_SFAFSR_H
 
-#include <asm/const.h>
+#include <linux/const.h>
 
 /* Spitfire Asynchronous Fault Status register, ASI=0x4C VA<63:0>=0x0 */
 
--- linux-2.6.21-rc7-mm2.orig/include/asm-sparc64/Kbuild
+++ linux-2.6.21-rc7-mm2/include/asm-sparc64/Kbuild
@@ -8,7 +8,6 @@ header-y += apb.h
 header-y += asi.h
 header-y += bbc.h
 header-y += bpp.h
-header-y += const.h
 header-y += display7seg.h
 header-y += envctrl.h
 header-y += ipc.h
--- linux-2.6.21-rc7-mm2.orig/include/linux/Kbuild
+++ linux-2.6.21-rc7-mm2/include/linux/Kbuild
@@ -46,6 +46,7 @@ header-y += coda_psdev.h
 header-y += coff.h
 header-y += comstats.h
 header-y += consolemap.h
+header-y += const.h
 header-y += cycx_cfm.h
 header-y += dlm_device.h
 header-y += dm-ioctl.h
