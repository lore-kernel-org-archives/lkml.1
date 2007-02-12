Return-Path: <linux-kernel-owner+w=401wt.eu-S964900AbXBLMnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964900AbXBLMnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 07:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964904AbXBLMnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 07:43:18 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:47977 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964901AbXBLMnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 07:43:17 -0500
X-Originating-Ip: 74.109.98.130
Date: Mon, 12 Feb 2007 07:41:32 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [PATCH] Remove "#include <linux/rwsem.h>" from semaphore headers.
Message-ID: <Pine.LNX.4.64.0702120732500.23120@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, ALL_TRUSTED -1.80, BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Remove all inclusions of "linux/rwsem.h" from the standard semaphore
header files, since anyone who needs R/W semaphores should be
including that header file directly.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  it *seems* fairly obvious that the numerous
include/asm-*/semaphore.h header files shouldn't be including
"rwsem.h".  if someone needs a R/W semaphore, they should be including
that header file explicitly, and a couple semaphore.h files even spell
this out in a comment (which this patch removes):

/*
 * Remove spinlock-based RW semaphores; RW semaphore definitions are
 * now in rwsem.h and we use the generic lib/rwsem.c implementation.
 * Rework semaphores to use atomic_dec_if_positive.
 * -- Paul Mackerras (paulus@samba.org)
 */

  the only issue this might introduce is breakage if any header file
*has* needed R/W semaphores and has been getting that header info
through semaphore.h by coincidence.  the only file that seems to have
had that problem is "include/linux/quota.h", for which i've already
submitted a patch to add the necessary inclusion of "rwsem.h".


 include/asm-alpha/semaphore.h     |    1 -
 include/asm-arm/semaphore.h       |    1 -
 include/asm-arm26/semaphore.h     |    1 -
 include/asm-avr32/semaphore.h     |    1 -
 include/asm-cris/semaphore.h      |    3 ---
 include/asm-frv/semaphore.h       |    3 ---
 include/asm-h8300/semaphore.h     |    1 -
 include/asm-i386/semaphore.h      |    1 -
 include/asm-ia64/semaphore.h      |    1 -
 include/asm-m32r/semaphore.h      |    1 -
 include/asm-m68k/semaphore.h      |    1 -
 include/asm-m68knommu/semaphore.h |    1 -
 include/asm-mips/semaphore.h      |    8 --------
 include/asm-parisc/semaphore.h    |    1 -
 include/asm-powerpc/semaphore.h   |    8 --------
 include/asm-s390/semaphore.h      |    1 -
 include/asm-sh/semaphore.h        |    1 -
 include/asm-sh64/semaphore.h      |    1 -
 include/asm-sparc/semaphore.h     |    1 -
 include/asm-sparc64/semaphore.h   |    1 -
 include/asm-v850/semaphore.h      |    1 -
 include/asm-x86_64/semaphore.h    |    2 --
 include/asm-xtensa/semaphore.h    |    1 -
 23 files changed, 42 deletions(-)

diff --git a/include/asm-alpha/semaphore.h b/include/asm-alpha/semaphore.h
index 1a6295f..9f2db03 100644
--- a/include/asm-alpha/semaphore.h
+++ b/include/asm-alpha/semaphore.h
@@ -13,7 +13,6 @@
 #include <asm/atomic.h>
 #include <linux/compiler.h>
 #include <linux/wait.h>
-#include <linux/rwsem.h>

 struct semaphore {
 	atomic_t count;
diff --git a/include/asm-arm/semaphore.h b/include/asm-arm/semaphore.h
index d5dc624..619dd52 100644
--- a/include/asm-arm/semaphore.h
+++ b/include/asm-arm/semaphore.h
@@ -7,7 +7,6 @@
 #include <linux/linkage.h>
 #include <linux/spinlock.h>
 #include <linux/wait.h>
-#include <linux/rwsem.h>

 #include <asm/atomic.h>
 #include <asm/locks.h>
diff --git a/include/asm-arm26/semaphore.h b/include/asm-arm26/semaphore.h
index 1fda543..cdd878b 100644
--- a/include/asm-arm26/semaphore.h
+++ b/include/asm-arm26/semaphore.h
@@ -7,7 +7,6 @@
 #include <linux/linkage.h>
 #include <linux/spinlock.h>
 #include <linux/wait.h>
-#include <linux/rwsem.h>

 #include <asm/atomic.h>
 #include <asm/locks.h>
diff --git a/include/asm-avr32/semaphore.h b/include/asm-avr32/semaphore.h
index ef99ddc..9320a12 100644
--- a/include/asm-avr32/semaphore.h
+++ b/include/asm-avr32/semaphore.h
@@ -18,7 +18,6 @@
 #include <asm/system.h>
 #include <asm/atomic.h>
 #include <linux/wait.h>
-#include <linux/rwsem.h>

 struct semaphore {
 	atomic_t count;
diff --git a/include/asm-cris/semaphore.h b/include/asm-cris/semaphore.h
index 53f548b..0555595 100644
--- a/include/asm-cris/semaphore.h
+++ b/include/asm-cris/semaphore.h
@@ -5,11 +5,8 @@
 #ifndef _CRIS_SEMAPHORE_H
 #define _CRIS_SEMAPHORE_H

-#define RW_LOCK_BIAS             0x01000000
-
 #include <linux/wait.h>
 #include <linux/spinlock.h>
-#include <linux/rwsem.h>

 #include <asm/system.h>
 #include <asm/atomic.h>
diff --git a/include/asm-frv/semaphore.h b/include/asm-frv/semaphore.h
index 907c5c3..0bbfc34 100644
--- a/include/asm-frv/semaphore.h
+++ b/include/asm-frv/semaphore.h
@@ -11,14 +11,11 @@
 #ifndef _ASM_SEMAPHORE_H
 #define _ASM_SEMAPHORE_H

-#define RW_LOCK_BIAS		 0x01000000
-
 #ifndef __ASSEMBLY__

 #include <linux/linkage.h>
 #include <linux/wait.h>
 #include <linux/spinlock.h>
-#include <linux/rwsem.h>

 #define SEMAPHORE_DEBUG		0

diff --git a/include/asm-h8300/semaphore.h b/include/asm-h8300/semaphore.h
index 81bae2a..15021cc 100644
--- a/include/asm-h8300/semaphore.h
+++ b/include/asm-h8300/semaphore.h
@@ -8,7 +8,6 @@
 #include <linux/linkage.h>
 #include <linux/wait.h>
 #include <linux/spinlock.h>
-#include <linux/rwsem.h>

 #include <asm/system.h>
 #include <asm/atomic.h>
diff --git a/include/asm-i386/semaphore.h b/include/asm-i386/semaphore.h
index 4e34a46..9519808 100644
--- a/include/asm-i386/semaphore.h
+++ b/include/asm-i386/semaphore.h
@@ -39,7 +39,6 @@
 #include <asm/system.h>
 #include <asm/atomic.h>
 #include <linux/wait.h>
-#include <linux/rwsem.h>

 struct semaphore {
 	atomic_t count;
diff --git a/include/asm-ia64/semaphore.h b/include/asm-ia64/semaphore.h
index f483eeb..cc78532 100644
--- a/include/asm-ia64/semaphore.h
+++ b/include/asm-ia64/semaphore.h
@@ -7,7 +7,6 @@
  */

 #include <linux/wait.h>
-#include <linux/rwsem.h>

 #include <asm/atomic.h>

diff --git a/include/asm-m32r/semaphore.h b/include/asm-m32r/semaphore.h
index 41e45d7..34f22d3 100644
--- a/include/asm-m32r/semaphore.h
+++ b/include/asm-m32r/semaphore.h
@@ -13,7 +13,6 @@
  */

 #include <linux/wait.h>
-#include <linux/rwsem.h>
 #include <asm/assembler.h>
 #include <asm/system.h>
 #include <asm/atomic.h>
diff --git a/include/asm-m68k/semaphore.h b/include/asm-m68k/semaphore.h
index fd4c7cc..5bf8af0 100644
--- a/include/asm-m68k/semaphore.h
+++ b/include/asm-m68k/semaphore.h
@@ -8,7 +8,6 @@
 #include <linux/linkage.h>
 #include <linux/wait.h>
 #include <linux/spinlock.h>
-#include <linux/rwsem.h>
 #include <linux/stringify.h>

 #include <asm/system.h>
diff --git a/include/asm-m68knommu/semaphore.h b/include/asm-m68knommu/semaphore.h
index 5cc1fdd..b9fe03c 100644
--- a/include/asm-m68knommu/semaphore.h
+++ b/include/asm-m68knommu/semaphore.h
@@ -8,7 +8,6 @@
 #include <linux/linkage.h>
 #include <linux/wait.h>
 #include <linux/spinlock.h>
-#include <linux/rwsem.h>

 #include <asm/system.h>
 #include <asm/atomic.h>
diff --git a/include/asm-mips/semaphore.h b/include/asm-mips/semaphore.h
index 3d6aa7c..1e598b4 100644
--- a/include/asm-mips/semaphore.h
+++ b/include/asm-mips/semaphore.h
@@ -15,19 +15,11 @@
 #ifndef __ASM_SEMAPHORE_H
 #define __ASM_SEMAPHORE_H

-/*
- * Remove spinlock-based RW semaphores; RW semaphore definitions are
- * now in rwsem.h and we use the generic lib/rwsem.c implementation.
- * Rework semaphores to use atomic_dec_if_positive.
- * -- Paul Mackerras (paulus@samba.org)
- */
-
 #ifdef __KERNEL__

 #include <asm/atomic.h>
 #include <asm/system.h>
 #include <linux/wait.h>
-#include <linux/rwsem.h>

 struct semaphore {
 	/*
diff --git a/include/asm-parisc/semaphore.h b/include/asm-parisc/semaphore.h
index d45827a..ad4ddd5 100644
--- a/include/asm-parisc/semaphore.h
+++ b/include/asm-parisc/semaphore.h
@@ -26,7 +26,6 @@

 #include <linux/spinlock.h>
 #include <linux/wait.h>
-#include <linux/rwsem.h>

 #include <asm/system.h>

diff --git a/include/asm-powerpc/semaphore.h b/include/asm-powerpc/semaphore.h
index 57369d2..37e4cb0 100644
--- a/include/asm-powerpc/semaphore.h
+++ b/include/asm-powerpc/semaphore.h
@@ -1,19 +1,11 @@
 #ifndef _ASM_POWERPC_SEMAPHORE_H
 #define _ASM_POWERPC_SEMAPHORE_H

-/*
- * Remove spinlock-based RW semaphores; RW semaphore definitions are
- * now in rwsem.h and we use the generic lib/rwsem.c implementation.
- * Rework semaphores to use atomic_dec_if_positive.
- * -- Paul Mackerras (paulus@samba.org)
- */
-
 #ifdef __KERNEL__

 #include <asm/atomic.h>
 #include <asm/system.h>
 #include <linux/wait.h>
-#include <linux/rwsem.h>

 struct semaphore {
 	/*
diff --git a/include/asm-s390/semaphore.h b/include/asm-s390/semaphore.h
index dbce058..77f21c3 100644
--- a/include/asm-s390/semaphore.h
+++ b/include/asm-s390/semaphore.h
@@ -14,7 +14,6 @@
 #include <asm/system.h>
 #include <asm/atomic.h>
 #include <linux/wait.h>
-#include <linux/rwsem.h>

 struct semaphore {
 	/*
diff --git a/include/asm-sh/semaphore.h b/include/asm-sh/semaphore.h
index 489f784..ca15c26 100644
--- a/include/asm-sh/semaphore.h
+++ b/include/asm-sh/semaphore.h
@@ -14,7 +14,6 @@
  */

 #include <linux/spinlock.h>
-#include <linux/rwsem.h>
 #include <linux/wait.h>

 #include <asm/system.h>
diff --git a/include/asm-sh64/semaphore.h b/include/asm-sh64/semaphore.h
index 4695264..36de2f2 100644
--- a/include/asm-sh64/semaphore.h
+++ b/include/asm-sh64/semaphore.h
@@ -22,7 +22,6 @@
 #include <linux/linkage.h>
 #include <linux/spinlock.h>
 #include <linux/wait.h>
-#include <linux/rwsem.h>

 #include <asm/system.h>
 #include <asm/atomic.h>
diff --git a/include/asm-sparc/semaphore.h b/include/asm-sparc/semaphore.h
index f74ba31..8943ef6 100644
--- a/include/asm-sparc/semaphore.h
+++ b/include/asm-sparc/semaphore.h
@@ -7,7 +7,6 @@

 #include <asm/atomic.h>
 #include <linux/wait.h>
-#include <linux/rwsem.h>

 struct semaphore {
 	atomic24_t count;
diff --git a/include/asm-sparc64/semaphore.h b/include/asm-sparc64/semaphore.h
index 093dcc6..869caa1 100644
--- a/include/asm-sparc64/semaphore.h
+++ b/include/asm-sparc64/semaphore.h
@@ -11,7 +11,6 @@
 #include <asm/atomic.h>
 #include <asm/system.h>
 #include <linux/wait.h>
-#include <linux/rwsem.h>

 struct semaphore {
 	atomic_t count;
diff --git a/include/asm-v850/semaphore.h b/include/asm-v850/semaphore.h
index 735baaf..f03edff 100644
--- a/include/asm-v850/semaphore.h
+++ b/include/asm-v850/semaphore.h
@@ -4,7 +4,6 @@
 #include <linux/linkage.h>
 #include <linux/spinlock.h>
 #include <linux/wait.h>
-#include <linux/rwsem.h>

 #include <asm/atomic.h>

diff --git a/include/asm-x86_64/semaphore.h b/include/asm-x86_64/semaphore.h
index 1194888..f5fed78 100644
--- a/include/asm-x86_64/semaphore.h
+++ b/include/asm-x86_64/semaphore.h
@@ -38,9 +38,7 @@

 #include <asm/system.h>
 #include <asm/atomic.h>
-#include <asm/rwlock.h>
 #include <linux/wait.h>
-#include <linux/rwsem.h>
 #include <linux/stringify.h>

 struct semaphore {
diff --git a/include/asm-xtensa/semaphore.h b/include/asm-xtensa/semaphore.h
index f10c348..4a75abc 100644
--- a/include/asm-xtensa/semaphore.h
+++ b/include/asm-xtensa/semaphore.h
@@ -14,7 +14,6 @@
 #include <asm/atomic.h>
 #include <asm/system.h>
 #include <linux/wait.h>
-#include <linux/rwsem.h>

 struct semaphore {
 	atomic_t count;

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
