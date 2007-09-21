Return-Path: <linux-kernel-owner+w=401wt.eu-S932861AbXIUWpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861AbXIUWpj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764081AbXIUWcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:43 -0400
Received: from cantor.suse.de ([195.135.220.2]:57085 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763857AbXIUWcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:35 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: satyam@infradead.org, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [34/50] i386: Fix argument signedness warnings
Message-Id: <20070921223234.0A71513DCD@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:33 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Satyam Sharma <satyam@infradead.org>


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
Signed-off-by: Andi Kleen <ak@suse.de>

---

 include/asm-i386/processor.h |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: linux/include/asm-i386/processor.h
===================================================================
--- linux.orig/include/asm-i386/processor.h
+++ linux/include/asm-i386/processor.h
@@ -595,7 +595,9 @@ static inline void load_esp0(struct tss_
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
@@ -603,8 +605,9 @@ static inline void cpuid(unsigned int op
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
