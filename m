Return-Path: <linux-kernel-owner+w=401wt.eu-S1763449AbYA1XKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763449AbYA1XKx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:10:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763765AbYA1XIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:08:07 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:30734 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763755AbYA1XIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:08:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=TYex3Z6Lm2Z6hGV1MKpU0DjXGND096EtdzVA/LL5NITm1JbSMBBDC00Q0YfIbzqWUnn3IkZ/6jPDRcN9wpE3H29XXBwRu0YO0DNqURlVJdpztDl+fGkROAJ3oot/gDxJXgts+e0yVV2O7iS6kGhOLdH6eDekh67MlKbT52Ao3Mw=
Date: Tue, 29 Jan 2008 00:07:57 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/7] X86: Fix plenty of "That open brace { should be on the
 previous line"
Message-ID: <20080129000757.7fefd328@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix plenty of "That open brace { should be on the previous line"

Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/math-emu/errors.c |  137 +++++++++++++++-----------------------------
 1 files changed, 47 insertions(+), 90 deletions(-)

diff --git a/arch/x86/math-emu/errors.c b/arch/x86/math-emu/errors.c
index b3c12db..6102fe0 100644
--- a/arch/x86/math-emu/errors.c
+++ b/arch/x86/math-emu/errors.c
@@ -58,14 +58,11 @@ void FPU_printall(void)
   RE_ENTRANT_CHECK_OFF;
   /* No need to check access_ok(), we have previously fetched these bytes. */
   printk("At %p:", (void *) address);
-  if (FPU_CS == __USER_CS)
-    {
+  if (FPU_CS == __USER_CS) {
 #define MAX_PRINTED_BYTES 20
-      for (i = 0; i < MAX_PRINTED_BYTES; i++)
-	{
+      for (i = 0; i < MAX_PRINTED_BYTES; i++) {
 	  FPU_get_user(byte1, (u_char __user *) address);
-	  if ((byte1 & 0xf8) == 0xd8)
-	    {
+	  if ((byte1 & 0xf8) == 0xd8) {
 	      printk(" %02x", byte1);
 	      break;
 	    }
@@ -74,8 +71,7 @@ void FPU_printall(void)
 	}
       if (i == MAX_PRINTED_BYTES)
 	printk(" [more..]\n");
-      else
-	{
+      else {
 	  FPU_get_user(FPU_modrm, 1 + (u_char __user *) address);
 
 	  if (FPU_modrm >= 0300)
@@ -86,9 +82,7 @@ void FPU_printall(void)
 	}
     }
   else
-    {
       printk("%04x\n", FPU_CS);
-    }
 
   partial_status = status_word();
 
@@ -141,12 +135,10 @@ printk(" CW: ic=%d rc=%ld%ld pc=%ld%ld iem=%d     ef=%d%d%d%d%d%d\n",
 	 control_word & SW_Overflow?1:0, control_word & SW_Zero_Div?1:0,
 	 control_word & SW_Denorm_Op?1:0, control_word & SW_Invalid?1:0);
 
-  for (i = 0; i < 8; i++)
-    {
+  for (i = 0; i < 8; i++) {
       FPU_REG *r = &st(i);
       u_char tagi = FPU_gettagi(i);
-      switch (tagi)
-	{
+	switch (tagi) {
 	case TAG_Empty:
 	  continue;
 	  break;
@@ -274,15 +266,13 @@ asmlinkage void FPU_exception(int n)
   int i, int_type;
 
   int_type = 0;         /* Needed only to stop compiler warnings */
-  if (n & EX_INTERNAL)
-    {
+  if (n & EX_INTERNAL) {
       int_type = n - EX_INTERNAL;
       n = EX_INTERNAL;
       /* Set lots of exception bits! */
       partial_status |= (SW_Exc_Mask | SW_Summary | SW_Backward);
     }
-  else
-    {
+  else {
       /* Extract only the bits which we use to set the status word */
       n &= (SW_Exc_Mask);
       /* Set the corresponding exception bit */
@@ -290,8 +280,7 @@ asmlinkage void FPU_exception(int n)
       /* Set summary bits iff exception isn't masked */
       if (partial_status & ~control_word & CW_Exceptions)
 	partial_status |= (SW_Summary | SW_Backward);
-      if (n & (SW_Stack_Fault | EX_Precision))
-	{
+      if (n & (SW_Stack_Fault | EX_Precision)) {
 	  if (!(n & SW_C1))
 	    /* This bit distinguishes over- from underflow for a stack fault,
 	       and roundup from round-down for precision loss. */
@@ -300,8 +289,7 @@ asmlinkage void FPU_exception(int n)
     }
 
   RE_ENTRANT_CHECK_OFF;
-  if ((~control_word & n & CW_Exceptions) || (n == EX_INTERNAL))
-    {
+  if ((~control_word & n & CW_Exceptions) || (n == EX_INTERNAL)) {
 #ifdef PRINT_MESSAGES
       /* My message from the sponsor */
       printk(FPU_VERSION" "__DATE__" (C) W. Metzenthen.\n");
@@ -312,8 +300,7 @@ asmlinkage void FPU_exception(int n)
 	if ((exception_names[i].type & n) == exception_names[i].type)
 	  break;
 
-      if (exception_names[i].type)
-	{
+      if (exception_names[i].type) {
 #ifdef PRINT_MESSAGES
 	  printk("FP Exception: %s!\n", exception_names[i].name);
 #endif /* PRINT_MESSAGES */
@@ -321,8 +308,7 @@ asmlinkage void FPU_exception(int n)
       else
 	printk("FPU emulator: Unknown Exception: 0x%04x!\n", n);
 
-      if (n == EX_INTERNAL)
-	{
+      if (n == EX_INTERNAL) {
 	  printk("FPU emulator: Internal error type 0x%04x\n", int_type);
 	  FPU_printall();
 	}
@@ -358,12 +344,10 @@ int real_1op_NaN(FPU_REG *a)
      differ) is chosen to reproduce 80486 behaviour */
   signalling = isNaN && !(a->sigh & 0x40000000);
 
-  if (!signalling)
-    {
-      if (!isNaN)  /* pseudo-NaN, or other unsupported? */
-	{
-	  if (control_word & CW_Invalid)
-	    {
+  if (!signalling) {
+      if (!isNaN) {
+	/* pseudo-NaN, or other unsupported? */
+	  if (control_word & CW_Invalid) {
 	      /* Masked response */
 	      reg_copy(&CONST_QNaN, a);
 	    }
@@ -373,11 +357,10 @@ int real_1op_NaN(FPU_REG *a)
       return TAG_Special;
     }
 
-  if (control_word & CW_Invalid)
-    {
+  if (control_word & CW_Invalid) {
       /* The masked response */
-      if (!(a->sigh & 0x80000000))  /* pseudo-NaN ? */
-	{
+      if (!(a->sigh & 0x80000000)) {
+	/* pseudo-NaN ? */
 	  reg_copy(&CONST_QNaN, a);
 	}
       /* ensure a Quiet NaN */
@@ -412,10 +395,8 @@ int real_2op_NaN(FPU_REG const *b, u_char tagb,
 		 && !((exponent(a) == EXP_OVER) && (a->sigh & 0x80000000)))
     || ((tagb == TW_NaN)
 	&& !((exponent(b) == EXP_OVER) && (b->sigh & 0x80000000)));
-  if (unsupported)
-    {
-      if (control_word & CW_Invalid)
-	{
+  if (unsupported) {
+      if (control_word & CW_Invalid) {
 	  /* Masked response */
 	  FPU_copy_to_regi(&CONST_QNaN, TAG_Special, deststnr);
 	}
@@ -423,23 +404,19 @@ int real_2op_NaN(FPU_REG const *b, u_char tagb,
       return (!(control_word & CW_Invalid) ? FPU_Exception : 0) | TAG_Special;
     }
 
-  if (taga == TW_NaN)
-    {
+  if (taga == TW_NaN) {
       x = a;
-      if (tagb == TW_NaN)
-	{
+      if (tagb == TW_NaN) {
 	  signalling = !(a->sigh & b->sigh & 0x40000000);
 	  if (significand(b) > significand(a))
 	    x = b;
-	  else if (significand(b) == significand(a))
-	    {
+	  else if (significand(b) == significand(a)) {
 	      /* The default result for the case of two "equal" NaNs (signs may
 		 differ) is chosen to reproduce 80486 behaviour */
 	      x = defaultNaN;
 	    }
 	}
-      else
-	{
+      else {
 	  /* return the quiet version of the NaN in a */
 	  signalling = !(a->sigh & 0x40000000);
 	}
@@ -453,16 +430,14 @@ int real_2op_NaN(FPU_REG const *b, u_char tagb,
       x = b;
     }
 #ifdef PARANOID
-  else
-    {
+  else {
       signalling = 0;
       EXCEPTION(EX_INTERNAL|0x113);
       x = &CONST_QNaN;
     }
 #endif /* PARANOID */
 
-  if ((!signalling) || (control_word & CW_Invalid))
-    {
+  if ((!signalling) || (control_word & CW_Invalid)) {
       if (!x)
 	x = b;
 
@@ -491,8 +466,7 @@ asmlinkage int arith_invalid(int deststnr)
 
   EXCEPTION(EX_Invalid);
 
-  if (control_word & CW_Invalid)
-    {
+  if (control_word & CW_Invalid) {
       /* The masked response */
       FPU_copy_to_regi(&CONST_QNaN, TAG_Special, deststnr);
     }
@@ -508,8 +482,7 @@ asmlinkage int FPU_divide_by_zero(int deststnr, u_char sign)
   FPU_REG *dest = &st(deststnr);
   int tag = TAG_Valid;
 
-  if (control_word & CW_ZeroDiv)
-    {
+  if (control_word & CW_ZeroDiv) {
       /* The masked response */
       FPU_copy_to_regi(&CONST_INF, TAG_Special, deststnr);
       setsign(dest, sign);
@@ -526,14 +499,12 @@ asmlinkage int FPU_divide_by_zero(int deststnr, u_char sign)
 /* This may be called often, so keep it lean */
 int set_precision_flag(int flags)
 {
-  if (control_word & CW_Precision)
-    {
+  if (control_word & CW_Precision) {
       partial_status &= ~(SW_C1 & flags);
       partial_status |= flags;   /* The masked response */
       return 0;
     }
-  else
-    {
+  else {
       EXCEPTION(flags);
       return 1;
     }
@@ -553,8 +524,8 @@ asmlinkage void set_precision_flag_up(void)
 /* This may be called often, so keep it lean */
 asmlinkage void set_precision_flag_down(void)
 {
-  if (control_word & CW_Precision)
-    {   /* The masked response */
+  if (control_word & CW_Precision) {
+	/* The masked response */
       partial_status &= ~SW_C1;
       partial_status |= SW_Precision;
     }
@@ -565,13 +536,12 @@ asmlinkage void set_precision_flag_down(void)
 
 asmlinkage int denormal_operand(void)
 {
-  if (control_word & CW_Denormal)
-    {   /* The masked response */
+  if (control_word & CW_Denormal) {
+	/* The masked response */
       partial_status |= SW_Denorm_Op;
       return TAG_Special;
     }
-  else
-    {
+  else {
       EXCEPTION(EX_Denormal);
       return TAG_Special | FPU_Exception;
     }
@@ -582,22 +552,19 @@ asmlinkage int arith_overflow(FPU_REG *dest)
 {
   int tag = TAG_Valid;
 
-  if (control_word & CW_Overflow)
-    {
+  if (control_word & CW_Overflow) {
       /* The masked response */
 /* ###### The response here depends upon the rounding mode */
       reg_copy(&CONST_INF, dest);
       tag = TAG_Special;
     }
-  else
-    {
+  else {
       /* Subtract the magic number from the exponent */
       addexponent(dest, (-3 * (1 << 13)));
     }
 
   EXCEPTION(EX_Overflow);
-  if (control_word & CW_Overflow)
-    {
+  if (control_word & CW_Overflow) {
       /* The overflow exception is masked. */
       /* By definition, precision is lost.
 	 The roundup bit (C1) is also set because we have
@@ -615,29 +582,23 @@ asmlinkage int arith_underflow(FPU_REG *dest)
 {
   int tag = TAG_Valid;
 
-  if (control_word & CW_Underflow)
-    {
+  if (control_word & CW_Underflow) {
       /* The masked response */
-      if (exponent16(dest) <= EXP_UNDER - 63)
-	{
+      if (exponent16(dest) <= EXP_UNDER - 63) {
 	  reg_copy(&CONST_Z, dest);
 	  partial_status &= ~SW_C1;       /* Round down. */
 	  tag = TAG_Zero;
 	}
       else
-	{
 	  stdexp(dest);
-	}
     }
-  else
-    {
+  else {
       /* Add the magic number to the exponent. */
       addexponent(dest, (3 * (1 << 13)) + EXTENDED_Ebias);
     }
 
   EXCEPTION(EX_Underflow);
-  if (control_word & CW_Underflow)
-    {
+  if (control_word & CW_Underflow) {
       /* The underflow exception is masked. */
       EXCEPTION(EX_Precision);
       return tag;
@@ -651,8 +612,7 @@ asmlinkage int arith_underflow(FPU_REG *dest)
 void FPU_stack_overflow(void)
 {
 
- if (control_word & CW_Invalid)
-    {
+ if (control_word & CW_Invalid) {
       /* The masked response */
       top--;
       FPU_copy_to_reg0(&CONST_QNaN, TAG_Special);
@@ -668,8 +628,7 @@ void FPU_stack_overflow(void)
 void FPU_stack_underflow(void)
 {
 
- if (control_word & CW_Invalid)
-    {
+ if (control_word & CW_Invalid) {
       /* The masked response */
       FPU_copy_to_reg0(&CONST_QNaN, TAG_Special);
     }
@@ -684,8 +643,7 @@ void FPU_stack_underflow(void)
 void FPU_stack_underflow_i(int i)
 {
 
- if (control_word & CW_Invalid)
-    {
+ if (control_word & CW_Invalid) {
       /* The masked response */
       FPU_copy_to_regi(&CONST_QNaN, TAG_Special, i);
     }
@@ -700,8 +658,7 @@ void FPU_stack_underflow_i(int i)
 void FPU_stack_underflow_pop(int i)
 {
 
- if (control_word & CW_Invalid)
-    {
+ if (control_word & CW_Invalid) {
       /* The masked response */
       FPU_copy_to_regi(&CONST_QNaN, TAG_Special, i);
       FPU_pop();
-- 
1.5.4.rc3

