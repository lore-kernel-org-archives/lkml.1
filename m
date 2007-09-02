Return-Path: <linux-kernel-owner+w=401wt.eu-S1759922AbXIBULJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759922AbXIBULJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 16:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbXIBUKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 16:10:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56906 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbXIBUKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 16:10:53 -0400
Date: Mon, 3 Sep 2007 01:54:02 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm] i386 cpuid_count: Fix argument signedness warnings
In-Reply-To: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.in>
Message-ID: <alpine.LFD.0.999.0709030153190.29617@enigma.security.iitk.ac.in>
References: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.i
 n>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="464262402-1442443271-1188764645=:29617"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--464262402-1442443271-1188764645=:29617
Content-Type: TEXT/PLAIN; charset=iso-2022-jp


These build warnings:

In file included from include/asm/thread_info.h:16,
from include/linux/thread_info.h:21,
from include/linux/preempt.h:9,
from include/linux/spinlock.h:49,
from include/linux/vmalloc.h:4,
from arch/i386/boot/compressed/misc.c:14:
include/asm/processor.h: In function ‘cpuid_count’:
include/asm/processor.h:615: warning: pointer targets in passing argument 1 of ‘native_cpuid’ differ in signedness
include/asm/processor.h:615: warning: pointer targets in passing argument 2 of ‘native_cpuid’ differ in signedness
include/asm/processor.h:615: warning: pointer targets in passing argument 3 of ‘native_cpuid’ differ in signedness
include/asm/processor.h:615: warning: pointer targets in passing argument 4 of ‘native_cpuid’ differ in signedness

come because the arguments have been specified as pointers to (signed) int
types, not unsigned. So let's specify those as unsigned. Do some codingstyle
here and there while at it.

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 include/asm-i386/processor.h |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- linux-2.6.23-rc4-mm1/include/asm-i386/processor.h~fix	2007-09-02 23:54:23.000000000 +0530
+++ linux-2.6.23-rc4-mm1/include/asm-i386/processor.h	2007-09-02 23:57:46.000000000 +0530
@@ -599,7 +599,9 @@ static inline void load_esp0(struct tss_
  * clear %ecx since some cpus (Cyrix MII) do not set or clear %ecx
  * resulting in stale register contents being returned.
  */
-static inline void cpuid(unsigned int op, unsigned int *eax, unsigned int *ebx, unsigned int *ecx, unsigned int *edx)
+static inline void cpuid(unsigned int op,
+			 unsigned int *eax, unsigned int *ebx,
+			 unsigned int *ecx, unsigned int *edx)
 {
 	*eax = op;
 	*ecx = 0;
@@ -607,8 +609,9 @@ static inline void cpuid(unsigned int op
 }
 
 /* Some CPUID calls want 'count' to be placed in ecx */
-static inline void cpuid_count(int op, int count, int *eax, int *ebx, int *ecx,
-			       int *edx)
+static inline void cpuid_count(unsigned int op, int count,
+			       unsigned int *eax, unsigned int *ebx,
+			       unsigned int *ecx, unsigned int *edx)
 {
 	*eax = op;
 	*ecx = count;
--464262402-1442443271-1188764645=:29617--
