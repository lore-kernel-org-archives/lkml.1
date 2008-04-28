Return-Path: <linux-kernel-owner+w=401wt.eu-S1763548AbYD1F7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763548AbYD1F7L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 01:59:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbYD1F65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 01:58:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43478 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbYD1F65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 01:58:57 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] frv si_addr annotations
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Message-Id: <E1JqMO8-0004kV-0E@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Mon, 28 Apr 2008 06:58:56 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/frv/kernel/traps.c |   31 ++++++++++++++++---------------
 1 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/arch/frv/kernel/traps.c b/arch/frv/kernel/traps.c
index 7089c24..a40df80 100644
--- a/arch/frv/kernel/traps.c
+++ b/arch/frv/kernel/traps.c
@@ -49,7 +49,7 @@ asmlinkage void insn_access_error(unsigned long esfr1, unsigned long epcr0, unsi
 	info.si_signo	= SIGSEGV;
 	info.si_code	= SEGV_ACCERR;
 	info.si_errno	= 0;
-	info.si_addr	= (void *) ((epcr0 & EPCR0_V) ? (epcr0 & EPCR0_PC) : __frame->pc);
+	info.si_addr	= (void __user *) ((epcr0 & EPCR0_V) ? (epcr0 & EPCR0_PC) : __frame->pc);
 
 	force_sig_info(info.si_signo, &info, current);
 } /* end insn_access_error() */
@@ -73,7 +73,7 @@ asmlinkage void illegal_instruction(unsigned long esfr1, unsigned long epcr0, un
 		      epcr0, esr0, esfr1);
 
 	info.si_errno	= 0;
-	info.si_addr	= (void *) ((epcr0 & EPCR0_V) ? (epcr0 & EPCR0_PC) : __frame->pc);
+	info.si_addr	= (void __user *) ((epcr0 & EPCR0_V) ? (epcr0 & EPCR0_PC) : __frame->pc);
 
 	switch (__frame->tbr & TBR_TT) {
 	case TBR_TT_ILLEGAL_INSTR:
@@ -111,7 +111,8 @@ asmlinkage void atomic_operation(unsigned long esfr1, unsigned long epcr0,
 				 unsigned long esr0)
 {
 	static DEFINE_SPINLOCK(atomic_op_lock);
-	unsigned long x, y, z, *p;
+	unsigned long x, y, z;
+	unsigned long __user *p;
 	mm_segment_t oldfs;
 	siginfo_t info;
 	int ret;
@@ -128,7 +129,7 @@ asmlinkage void atomic_operation(unsigned long esfr1, unsigned long epcr0,
 		 * u32 __atomic_user_cmpxchg32(u32 *ptr, u32 test, u32 new)
 		 */
 	case TBR_TT_ATOMIC_CMPXCHG32:
-		p = (unsigned long *) __frame->gr8;
+		p = (unsigned long __user *) __frame->gr8;
 		x = __frame->gr9;
 		y = __frame->gr10;
 
@@ -158,7 +159,7 @@ asmlinkage void atomic_operation(unsigned long esfr1, unsigned long epcr0,
 		 * u32 __atomic_kernel_xchg32(void *v, u32 new)
 		 */
 	case TBR_TT_ATOMIC_XCHG32:
-		p = (unsigned long *) __frame->gr8;
+		p = (unsigned long __user *) __frame->gr8;
 		y = __frame->gr9;
 
 		for (;;) {
@@ -181,7 +182,7 @@ asmlinkage void atomic_operation(unsigned long esfr1, unsigned long epcr0,
 		 * ulong __atomic_kernel_XOR_return(ulong i, ulong *v)
 		 */
 	case TBR_TT_ATOMIC_XOR:
-		p = (unsigned long *) __frame->gr8;
+		p = (unsigned long __user *) __frame->gr8;
 		x = __frame->gr9;
 
 		for (;;) {
@@ -205,7 +206,7 @@ asmlinkage void atomic_operation(unsigned long esfr1, unsigned long epcr0,
 		 * ulong __atomic_kernel_OR_return(ulong i, ulong *v)
 		 */
 	case TBR_TT_ATOMIC_OR:
-		p = (unsigned long *) __frame->gr8;
+		p = (unsigned long __user *) __frame->gr8;
 		x = __frame->gr9;
 
 		for (;;) {
@@ -229,7 +230,7 @@ asmlinkage void atomic_operation(unsigned long esfr1, unsigned long epcr0,
 		 * ulong __atomic_kernel_AND_return(ulong i, ulong *v)
 		 */
 	case TBR_TT_ATOMIC_AND:
-		p = (unsigned long *) __frame->gr8;
+		p = (unsigned long __user *) __frame->gr8;
 		x = __frame->gr9;
 
 		for (;;) {
@@ -253,7 +254,7 @@ asmlinkage void atomic_operation(unsigned long esfr1, unsigned long epcr0,
 		 * int __atomic_user_sub_return(atomic_t *v, int i)
 		 */
 	case TBR_TT_ATOMIC_SUB:
-		p = (unsigned long *) __frame->gr8;
+		p = (unsigned long __user *) __frame->gr8;
 		x = __frame->gr9;
 
 		for (;;) {
@@ -277,7 +278,7 @@ asmlinkage void atomic_operation(unsigned long esfr1, unsigned long epcr0,
 		 * int __atomic_user_add_return(atomic_t *v, int i)
 		 */
 	case TBR_TT_ATOMIC_ADD:
-		p = (unsigned long *) __frame->gr8;
+		p = (unsigned long __user *) __frame->gr8;
 		x = __frame->gr9;
 
 		for (;;) {
@@ -322,7 +323,7 @@ error:
 	info.si_signo	= SIGSEGV;
 	info.si_code	= SEGV_ACCERR;
 	info.si_errno	= 0;
-	info.si_addr	= (void *) __frame->pc;
+	info.si_addr	= (void __user *) __frame->pc;
 
 	force_sig_info(info.si_signo, &info, current);
 }
@@ -343,7 +344,7 @@ asmlinkage void media_exception(unsigned long msr0, unsigned long msr1)
 	info.si_signo	= SIGFPE;
 	info.si_code	= FPE_MDAOVF;
 	info.si_errno	= 0;
-	info.si_addr	= (void *) __frame->pc;
+	info.si_addr	= (void __user *) __frame->pc;
 
 	force_sig_info(info.si_signo, &info, current);
 } /* end media_exception() */
@@ -383,7 +384,7 @@ asmlinkage void memory_access_exception(unsigned long esr0,
 	info.si_addr	= NULL;
 
 	if ((esr0 & (ESRx_VALID | ESR0_EAV)) == (ESRx_VALID | ESR0_EAV))
-		info.si_addr = (void *) ear0;
+		info.si_addr = (void __user *) ear0;
 
 	force_sig_info(info.si_signo, &info, current);
 
@@ -412,7 +413,7 @@ asmlinkage void data_access_error(unsigned long esfr1, unsigned long esr15, unsi
 	info.si_signo	= SIGSEGV;
 	info.si_code	= SEGV_ACCERR;
 	info.si_errno	= 0;
-	info.si_addr	= (void *)
+	info.si_addr	= (void __user *)
 		(((esr15 & (ESRx_VALID|ESR15_EAV)) == (ESRx_VALID|ESR15_EAV)) ? ear15 : 0);
 
 	force_sig_info(info.si_signo, &info, current);
@@ -446,7 +447,7 @@ asmlinkage void division_exception(unsigned long esfr1, unsigned long esr0, unsi
 	info.si_signo	= SIGFPE;
 	info.si_code	= FPE_INTDIV;
 	info.si_errno	= 0;
-	info.si_addr	= (void *) __frame->pc;
+	info.si_addr	= (void __user *) __frame->pc;
 
 	force_sig_info(info.si_signo, &info, current);
 } /* end division_exception() */
-- 
1.5.3.GIT


