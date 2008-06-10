Return-Path: <linux-kernel-owner+w=401wt.eu-S1759896AbYFJVqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759896AbYFJVqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 17:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755847AbYFJVqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 17:46:09 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:60446 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755953AbYFJVqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 17:46:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=jDVupv6C/n2BMLjRwlLVInrkzHVkVPUo6eacvraR7em7cZEUU/pN+qAy/b+BuJ3B7R
         JQuIF+ZU3f+cH3ErR73LnINFekv+UyHPtp0YQsMRYQROnwwY1do8dVtekeFflrWVMKTL
         XtYjDvbuEZ0XmMbhdQepiLwjhNE2xehj0Juj0=
Date: Tue, 10 Jun 2008 23:45:45 +0200
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: more header fixes
Message-ID: <20080610214544.GA14824@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Summary: Add missing include guards for some x86 headers.

This has only had the most rudimentary testing, but is hopefully obviously
correct. (That's just doomed to generate some sort of build failure, isn't
it?)

Thanks.


Vegard

PS: I now have a pretty cool framework in Perl for parsing and checking
headers. And it can be used to transform them automatically too. So if you
want to standardize the guard format of all the headers in one go, we have
the means to do it quickly and efficiently...


diff --git a/include/asm-x86/seccomp_64.h b/include/asm-x86/seccomp_64.h
index 553af65..76cfe69 100644
--- a/include/asm-x86/seccomp_64.h
+++ b/include/asm-x86/seccomp_64.h
@@ -1,4 +1,5 @@
 #ifndef _ASM_SECCOMP_H
+#define _ASM_SECCOMP_H
 
 #include <linux/thread_info.h>
 
diff --git a/include/asm-x86/suspend_32.h b/include/asm-x86/suspend_32.h
index 24e1c08..8675c67 100644
--- a/include/asm-x86/suspend_32.h
+++ b/include/asm-x86/suspend_32.h
@@ -3,6 +3,9 @@
  * Based on code
  * Copyright 2001 Patrick Mochel <mochel@osdl.org>
  */
+#ifndef __ASM_X86_32_SUSPEND_H
+#define __ASM_X86_32_SUSPEND_H
+
 #include <asm/desc.h>
 #include <asm/i387.h>
 
@@ -44,3 +47,5 @@ static inline void acpi_save_register_state(unsigned long return_point)
 /* routines for saving/restoring kernel state */
 extern int acpi_save_state_mem(void);
 #endif
+
+#endif /* __ASM_X86_32_SUSPEND_H */
diff --git a/include/asm-x86/xor_32.h b/include/asm-x86/xor_32.h
index 067b5c1..921b458 100644
--- a/include/asm-x86/xor_32.h
+++ b/include/asm-x86/xor_32.h
@@ -1,3 +1,6 @@
+#ifndef ASM_X86__XOR_32_H
+#define ASM_X86__XOR_32_H
+
 /*
  * Optimized RAID-5 checksumming functions for MMX and SSE.
  *
@@ -881,3 +884,5 @@ do {							\
    deals with a load to a line that is being prefetched.  */
 #define XOR_SELECT_TEMPLATE(FASTEST)			\
 	(cpu_has_xmm ? &xor_block_pIII_sse : FASTEST)
+
+#endif /* ASM_X86__XOR_32_H */
diff --git a/include/asm-x86/xor_64.h b/include/asm-x86/xor_64.h
index 24957e3..2d3a18d 100644
--- a/include/asm-x86/xor_64.h
+++ b/include/asm-x86/xor_64.h
@@ -1,3 +1,6 @@
+#ifndef ASM_X86__XOR_64_H
+#define ASM_X86__XOR_64_H
+
 /*
  * Optimized RAID-5 checksumming functions for MMX and SSE.
  *
@@ -354,3 +357,5 @@ do {						\
    We may also be able to load into the L1 only depending on how the cpu
    deals with a load to a line that is being prefetched.  */
 #define XOR_SELECT_TEMPLATE(FASTEST) (&xor_block_sse)
+
+#endif /* ASM_X86__XOR_64_H */
