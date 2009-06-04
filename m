Return-Path: <linux-kernel-owner+w=401wt.eu-S1757233AbZFDPps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233AbZFDPps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 11:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755223AbZFDPpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 11:45:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:57960 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756123AbZFDPpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 11:45:13 -0400
Subject: Re: [PATCH 1/6] headers_check fix: arm, hwcap.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <20090604125306.GC24491@flint.arm.linux.org.uk>
References: <1244118232.5172.26.camel@ht.satnam>
	 <1244118476.5172.29.camel@ht.satnam>
	 <20090604125306.GC24491@flint.arm.linux.org.uk>
Content-Type: text/plain
Date: Thu, 04 Jun 2009 21:15:43 +0530
Message-Id: <1244130343.2470.6.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Russell,

On Thu, 2009-06-04 at 13:53 +0100, Russell King wrote:
> On Thu, Jun 04, 2009 at 05:57:56PM +0530, Jaswinder Singh Rajput wrote:
> > fix the following 'make headers_check' warning:
> 
> I think headers_check needs fixing - there's nothing wrong with the
> code as it presently stands except the tools obviously can't properly
> parse C preprocessor statements.
> 

You are right.

But if we can keep things simpler why we make it complex ?

This is almost used in all header files :
#ifdef __KERNEL__
#ifndef __ASSEMBLY__

Earlier it was also used like this :

commit f884b1cf578e079f01682514ae1ae64c74586602
Author: Catalin Marinas <catalin.marinas@arm.com>
Date:   Thu Jul 12 16:10:22 2007 +0100

    [ARM] 4473/2:  Take the HWCAP definitions out of the elf.h file
    
    The patch moves the HWCAP definitions and the extern elf_hwcap
    declaration to the hwcap.h header file.
    
    Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

diff --git a/include/asm-arm/Kbuild b/include/asm-arm/Kbuild
index c68e168..73237bd 100644
--- a/include/asm-arm/Kbuild
+++ b/include/asm-arm/Kbuild
@@ -1 +1,3 @@
 include include/asm-generic/Kbuild.asm
+
+unifdef-y += hwcap.h
diff --git a/include/asm-arm/elf.h b/include/asm-arm/elf.h
index 3679a8a..d7a777f 100644
--- a/include/asm-arm/elf.h
+++ b/include/asm-arm/elf.h
@@ -7,6 +7,7 @@
  */
 #include <asm/ptrace.h>
 #include <asm/user.h>
+#include <asm/hwcap.h>
 
 typedef unsigned long elf_greg_t;
 typedef unsigned long elf_freg_t[3];
@@ -39,31 +40,9 @@ typedef struct user_fp elf_fpregset_t;
 #endif
 #define ELF_ARCH       EM_ARM
 
-/*
- * HWCAP flags - for elf_hwcap (in kernel) and AT_HWCAP
- */
-#define HWCAP_SWP      1
-#define HWCAP_HALF     2
-#define HWCAP_THUMB    4
-#define HWCAP_26BIT    8       /* Play it safe */
-#define HWCAP_FAST_MULT        16
-#define HWCAP_FPA      32
-#define HWCAP_VFP      64
-#define HWCAP_EDSP     128
-#define HWCAP_JAVA     256
-#define HWCAP_IWMMXT   512
-#define HWCAP_CRUNCH   1024
-
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 /*
- * This yields a mask that user programs can use to figure out what
- * instruction set this cpu supports.
- */
-#define ELF_HWCAP      (elf_hwcap)
-extern unsigned int elf_hwcap;
-
-/*
  * This yields a string that ld.so will use to load implementation
  * specific libraries for optimization.  This is more specific in
  * intent than poking at uname or /proc/cpuinfo.
diff --git a/include/asm-arm/hwcap.h b/include/asm-arm/hwcap.h
new file mode 100644
index 0000000..01a1391
--- /dev/null
+++ b/include/asm-arm/hwcap.h
@@ -0,0 +1,28 @@
+#ifndef __ASMARM_HWCAP_H
+#define __ASMARM_HWCAP_H
+
+/*
+ * HWCAP flags - for elf_hwcap (in kernel) and AT_HWCAP
+ */
+#define HWCAP_SWP      1
+#define HWCAP_HALF     2
+#define HWCAP_THUMB    4
+#define HWCAP_26BIT    8       /* Play it safe */
+#define HWCAP_FAST_MULT        16
+#define HWCAP_FPA      32
+#define HWCAP_VFP      64
+#define HWCAP_EDSP     128
+#define HWCAP_JAVA     256
+#define HWCAP_IWMMXT   512
+#define HWCAP_CRUNCH   1024
+
+#if defined(__KERNEL__) && !defined(__ASSEMBLY__)
+/*
+ * This yields a mask that user programs can use to figure out what
+ * instruction set this cpu supports.
+ */
+#define ELF_HWCAP      (elf_hwcap)
+extern unsigned int elf_hwcap;
+#endif
+
+#endif


