Return-Path: <linux-kernel-owner+w=401wt.eu-S1757496AbYAJXAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496AbYAJXAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 18:00:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbYAJXAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 18:00:11 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:15073 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbYAJXAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 18:00:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=Uk1RoFqlopQYDfLG5pUDhqVfJIxbLauerKmHalDSS28HELAGlsSZD8GOT3kYpUGVEmGzl3JjQz8D0DFlAD4kJpz7SndHiDWh1xThpMbBAQRMvTVeLN3IIwakTD/L8QYC85VBzR2VviHbG5cOfy8CSf+uWfPFKghA9EteSr4nQG8=
Date: Fri, 11 Jan 2008 00:00:02 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: codying style fixes in ./arch/x86/math-emu/
Message-ID: <20080111000002.009b3760@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some codying style errors in ./arch/x86/math-emu/reg_ld_str.c

total: 4 errors, 31 warnings, 1223 lines checked

patch is against a x86 which I pulled a few minutes ago.

Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/math-emu/reg_ld_str.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/x86/math-emu/reg_ld_str.c b/arch/x86/math-emu/reg_ld_str.c
index 799d4af..04a84d8 100644
--- a/arch/x86/math-emu/reg_ld_str.c
+++ b/arch/x86/math-emu/reg_ld_str.c
@@ -55,9 +55,8 @@ int FPU_tagof(FPU_REG *ptr)
 
 	exp = exponent16(ptr) & 0x7fff;
 	if (exp == 0) {
-		if (!(ptr->sigh | ptr->sigl)) {
+		if (!(ptr->sigh | ptr->sigl))
 			return TAG_Zero;
-		}
 		/* The number is a de-normal or pseudodenormal. */
 		return TAG_Special;
 	}
@@ -334,7 +333,7 @@ int FPU_load_bcd(u_char __user *s)
 
 /* Put a long double into user memory */
 int FPU_store_extended(FPU_REG *st0_ptr, u_char st0_tag,
-		       long double __user * d)
+		       long double __user *d)
 {
 	/*
 	   The only exception raised by an attempt to store to an
@@ -390,7 +389,7 @@ int FPU_store_double(FPU_REG *st0_ptr, u_char st0_tag, double __user *dfloat)
 		if (exp < DOUBLE_Emin) {	/* It may be a denormal */
 			addexponent(&tmp, -DOUBLE_Emin + 52);	/* largest exp to be 51 */
 
-		      denormal_arg:
+denormal_arg:
 
 			if ((precision_loss = FPU_round_to_int(&tmp, st0_tag))) {
 #ifdef PECULIAR_486
@@ -467,7 +466,7 @@ int FPU_store_double(FPU_REG *st0_ptr, u_char st0_tag, double __user *dfloat)
 			l[1] = ((tmp.sigh >> 11) & 0xfffff);
 
 			if (exp > DOUBLE_Emax) {
-			      overflow:
+overflow:
 				EXCEPTION(EX_Overflow);
 				if (!(control_word & CW_Overflow))
 					return 0;
@@ -581,7 +580,7 @@ int FPU_store_single(FPU_REG *st0_ptr, u_char st0_tag, float __user *single)
 		if (exp < SINGLE_Emin) {
 			addexponent(&tmp, -SINGLE_Emin + 23);	/* largest exp to be 22 */
 
-		      denormal_arg:
+denormal_arg:
 
 			if ((precision_loss = FPU_round_to_int(&tmp, st0_tag))) {
 #ifdef PECULIAR_486
@@ -614,8 +613,8 @@ int FPU_store_single(FPU_REG *st0_ptr, u_char st0_tag, float __user *single)
 				switch (control_word & CW_RC) {
 				case RC_RND:
 					increment = ((sigh & 0xff) > 0x80)	/* more than half */
-					    ||(((sigh & 0xff) == 0x80) && sigl)	/* more than half */
-					    ||((sigh & 0x180) == 0x180);	/* round to even */
+					    || (((sigh & 0xff) == 0x80) && sigl)	/* more than half */
+					    || ((sigh & 0x180) == 0x180);	/* round to even */
 					break;
 				case RC_DOWN:	/* towards -infinity */
 					increment = signpositive(&tmp)
@@ -781,7 +780,7 @@ int FPU_store_int64(FPU_REG *st0_ptr, u_char st0_tag, long long __user *d)
 	     !((t.sigh == 0x80000000) && (t.sigl == 0) && signnegative(&t)))) {
 		EXCEPTION(EX_Invalid);
 		/* This is a special case: see sec 16.2.5.1 of the 80486 book */
-	      invalid_operand:
+invalid_operand:
 		if (control_word & EX_Invalid) {
 			/* Produce something like QNaN "indefinite" */
 			tll = 0x8000000000000000LL;
@@ -828,7 +827,7 @@ int FPU_store_int32(FPU_REG *st0_ptr, u_char st0_tag, long __user *d)
 	     !((t.sigl == 0x80000000) && signnegative(&t)))) {
 		EXCEPTION(EX_Invalid);
 		/* This is a special case: see sec 16.2.5.1 of the 80486 book */
-	      invalid_operand:
+invalid_operand:
 		if (control_word & EX_Invalid) {
 			/* Produce something like QNaN "indefinite" */
 			t.sigl = 0x80000000;
@@ -874,7 +873,7 @@ int FPU_store_int16(FPU_REG *st0_ptr, u_char st0_tag, short __user *d)
 	     !((t.sigl == 0x8000) && signnegative(&t)))) {
 		EXCEPTION(EX_Invalid);
 		/* This is a special case: see sec 16.2.5.1 of the 80486 book */
-	      invalid_operand:
+invalid_operand:
 		if (control_word & EX_Invalid) {
 			/* Produce something like QNaN "indefinite" */
 			t.sigl = 0x8000;
@@ -925,7 +924,7 @@ int FPU_store_bcd(FPU_REG *st0_ptr, u_char st0_tag, u_char __user *d)
 	    ((t.sigh == 0x0de0b6b3) && (t.sigl > 0xa763ffff))) {
 		EXCEPTION(EX_Invalid);
 		/* This is a special case: see sec 16.2.5.1 of the 80486 book */
-	      invalid_operand:
+invalid_operand:
 		if (control_word & CW_Invalid) {
 			/* Produce the QNaN "indefinite" */
 			RE_ENTRANT_CHECK_OFF;
@@ -963,7 +962,7 @@ int FPU_store_bcd(FPU_REG *st0_ptr, u_char st0_tag, u_char __user *d)
 
 /*===========================================================================*/
 
-/* r gets mangled such that sig is int, sign: 
+/* r gets mangled such that sig is int, sign:
    it is NOT normalized */
 /* The return value (in eax) is zero if the result is exact,
    if bits are changed due to rounding, truncation, etc, then
-- 
1.5.4.rc2.17.g257f

