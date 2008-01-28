Return-Path: <linux-kernel-owner+w=401wt.eu-S1762858AbYA1XKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762858AbYA1XKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:10:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763708AbYA1XH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:07:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:30734 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758903AbYA1XHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:07:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=tXigrDne7oqdtjP4eIOLtFCICGxvgTgTZ2o8xgRV2Xa11Roqwxj0H884wkc1kc6162RrHWSeHYaeiijuJVMMgRtUmrYxTWGxCoK+VPK+JfdyvsJBwshW+JnyckYHJtmM1xiG9Ob0xE5Ge0ZjYlafqZwliDOPj4p9e0/J8Rj6kl0=
Date: Tue, 29 Jan 2008 00:07:50 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/7] X86: Fix space related errors
Message-ID: <20080129000750.65c272a2@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix space related errors

Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/math-emu/errors.c |  134 ++++++++++++++++++++++----------------------
 1 files changed, 67 insertions(+), 67 deletions(-)

diff --git a/arch/x86/math-emu/errors.c b/arch/x86/math-emu/errors.c
index 4419339..b3c12db 100644
--- a/arch/x86/math-emu/errors.c
+++ b/arch/x86/math-emu/errors.c
@@ -42,7 +42,7 @@
    */
 void FPU_illegal(void)
 {
-  math_abort(FPU_info,SIGILL);
+  math_abort(FPU_info, SIGILL);
 }
 
 
@@ -51,20 +51,20 @@ void FPU_printall(void)
 {
   int i;
   static const char *tag_desc[] = { "Valid", "Zero", "ERROR", "Empty",
-                              "DeNorm", "Inf", "NaN" };
+				"DeNorm", "Inf", "NaN" };
   u_char byte1, FPU_modrm;
   unsigned long address = FPU_ORIG_EIP;
 
   RE_ENTRANT_CHECK_OFF;
   /* No need to check access_ok(), we have previously fetched these bytes. */
   printk("At %p:", (void *) address);
-  if ( FPU_CS == __USER_CS )
+  if (FPU_CS == __USER_CS)
     {
 #define MAX_PRINTED_BYTES 20
-      for ( i = 0; i < MAX_PRINTED_BYTES; i++ )
+      for (i = 0; i < MAX_PRINTED_BYTES; i++)
 	{
 	  FPU_get_user(byte1, (u_char __user *) address);
-	  if ( (byte1 & 0xf8) == 0xd8 )
+	  if ((byte1 & 0xf8) == 0xd8)
 	    {
 	      printk(" %02x", byte1);
 	      break;
@@ -72,12 +72,12 @@ void FPU_printall(void)
 	  printk(" [%02x]", byte1);
 	  address++;
 	}
-      if ( i == MAX_PRINTED_BYTES )
+      if (i == MAX_PRINTED_BYTES)
 	printk(" [more..]\n");
       else
 	{
 	  FPU_get_user(FPU_modrm, 1 + (u_char __user *) address);
-	  
+
 	  if (FPU_modrm >= 0300)
 	    printk(" %02x (%02x+%d)\n", FPU_modrm, FPU_modrm & 0xf8, FPU_modrm & 7);
 	  else
@@ -93,31 +93,31 @@ void FPU_printall(void)
   partial_status = status_word();
 
 #ifdef DEBUGGING
-if ( partial_status & SW_Backward )
+if (partial_status & SW_Backward)
 printk("SW: backward compatibility\n");
-if ( partial_status & SW_C3 )
+if (partial_status & SW_C3)
 printk("SW: condition bit 3\n");
-if ( partial_status & SW_C2 )
+if (partial_status & SW_C2)
 printk("SW: condition bit 2\n");
-if ( partial_status & SW_C1 )
+if (partial_status & SW_C1)
 printk("SW: condition bit 1\n");
-if ( partial_status & SW_C0 )
+if (partial_status & SW_C0)
 printk("SW: condition bit 0\n");
-if ( partial_status & SW_Summary )
+if (partial_status & SW_Summary)
 printk("SW: exception summary\n");
-if ( partial_status & SW_Stack_Fault )
+if (partial_status & SW_Stack_Fault)
 printk("SW: stack fault\n");
-if ( partial_status & SW_Precision )
+if (partial_status & SW_Precision)
 printk("SW: loss of precision\n");
-if ( partial_status & SW_Underflow )
+if (partial_status & SW_Underflow)
 printk("SW: underflow\n");
-if ( partial_status & SW_Overflow )
+if (partial_status & SW_Overflow)
 printk("SW: overflow\n");
-if ( partial_status & SW_Zero_Div )
+if (partial_status & SW_Zero_Div)
 printk("SW: divide by zero\n");
-if ( partial_status & SW_Denorm_Op )
+if (partial_status & SW_Denorm_Op)
 printk("SW: denormalized operand\n");
-if ( partial_status & SW_Invalid )
+if (partial_status & SW_Invalid)
 printk("SW: invalid operation\n");
 #endif /* DEBUGGING */
 
@@ -131,7 +131,7 @@ printk("SW: invalid operation\n");
 	 partial_status & SW_Precision?1:0, partial_status & SW_Underflow?1:0,
 	 partial_status & SW_Overflow?1:0, partial_status & SW_Zero_Div?1:0,
 	 partial_status & SW_Denorm_Op?1:0, partial_status & SW_Invalid?1:0);
-  
+
 printk(" CW: ic=%d rc=%ld%ld pc=%ld%ld iem=%d     ef=%d%d%d%d%d%d\n",
 	 control_word & 0x1000 ? 1 : 0,
 	 (control_word & 0x800) >> 11, (control_word & 0x400) >> 10,
@@ -141,7 +141,7 @@ printk(" CW: ic=%d rc=%ld%ld pc=%ld%ld iem=%d     ef=%d%d%d%d%d%d\n",
 	 control_word & SW_Overflow?1:0, control_word & SW_Zero_Div?1:0,
 	 control_word & SW_Denorm_Op?1:0, control_word & SW_Invalid?1:0);
 
-  for ( i = 0; i < 8; i++ )
+  for (i = 0; i < 8; i++)
     {
       FPU_REG *r = &st(i);
       u_char tagi = FPU_gettagi(i);
@@ -274,7 +274,7 @@ asmlinkage void FPU_exception(int n)
   int i, int_type;
 
   int_type = 0;         /* Needed only to stop compiler warnings */
-  if ( n & EX_INTERNAL )
+  if (n & EX_INTERNAL)
     {
       int_type = n - EX_INTERNAL;
       n = EX_INTERNAL;
@@ -288,11 +288,11 @@ asmlinkage void FPU_exception(int n)
       /* Set the corresponding exception bit */
       partial_status |= n;
       /* Set summary bits iff exception isn't masked */
-      if ( partial_status & ~control_word & CW_Exceptions )
+      if (partial_status & ~control_word & CW_Exceptions)
 	partial_status |= (SW_Summary | SW_Backward);
-      if ( n & (SW_Stack_Fault | EX_Precision) )
+      if (n & (SW_Stack_Fault | EX_Precision))
 	{
-	  if ( !(n & SW_C1) )
+	  if (!(n & SW_C1))
 	    /* This bit distinguishes over- from underflow for a stack fault,
 	       and roundup from round-down for precision loss. */
 	    partial_status &= ~SW_C1;
@@ -300,18 +300,18 @@ asmlinkage void FPU_exception(int n)
     }
 
   RE_ENTRANT_CHECK_OFF;
-  if ( (~control_word & n & CW_Exceptions) || (n == EX_INTERNAL) )
+  if ((~control_word & n & CW_Exceptions) || (n == EX_INTERNAL))
     {
 #ifdef PRINT_MESSAGES
       /* My message from the sponsor */
       printk(FPU_VERSION" "__DATE__" (C) W. Metzenthen.\n");
 #endif /* PRINT_MESSAGES */
-      
+
       /* Get a name string for error reporting */
-      for (i=0; exception_names[i].type; i++)
-	if ( (exception_names[i].type & n) == exception_names[i].type )
+      for (i = 0; exception_names[i].type; i++)
+	if ((exception_names[i].type & n) == exception_names[i].type)
 	  break;
-      
+
       if (exception_names[i].type)
 	{
 #ifdef PRINT_MESSAGES
@@ -320,8 +320,8 @@ asmlinkage void FPU_exception(int n)
 	}
       else
 	printk("FPU emulator: Unknown Exception: 0x%04x!\n", n);
-      
-      if ( n == EX_INTERNAL )
+
+      if (n == EX_INTERNAL)
 	{
 	  printk("FPU emulator: Internal error type 0x%04x\n", int_type);
 	  FPU_printall();
@@ -340,7 +340,7 @@ asmlinkage void FPU_exception(int n)
   RE_ENTRANT_CHECK_ON;
 
 #ifdef __DEBUG__
-  math_abort(FPU_info,SIGFPE);
+  math_abort(FPU_info, SIGFPE);
 #endif /* __DEBUG__ */
 
 }
@@ -358,11 +358,11 @@ int real_1op_NaN(FPU_REG *a)
      differ) is chosen to reproduce 80486 behaviour */
   signalling = isNaN && !(a->sigh & 0x40000000);
 
-  if ( !signalling )
+  if (!signalling)
     {
-      if ( !isNaN )  /* pseudo-NaN, or other unsupported? */
+      if (!isNaN)  /* pseudo-NaN, or other unsupported? */
 	{
-	  if ( control_word & CW_Invalid )
+	  if (control_word & CW_Invalid)
 	    {
 	      /* Masked response */
 	      reg_copy(&CONST_QNaN, a);
@@ -373,10 +373,10 @@ int real_1op_NaN(FPU_REG *a)
       return TAG_Special;
     }
 
-  if ( control_word & CW_Invalid )
+  if (control_word & CW_Invalid)
     {
       /* The masked response */
-      if ( !(a->sigh & 0x80000000) )  /* pseudo-NaN ? */
+      if (!(a->sigh & 0x80000000))  /* pseudo-NaN ? */
 	{
 	  reg_copy(&CONST_QNaN, a);
 	}
@@ -402,9 +402,9 @@ int real_2op_NaN(FPU_REG const *b, u_char tagb,
   FPU_REG const *x;
   int signalling, unsupported;
 
-  if ( taga == TAG_Special )
+  if (taga == TAG_Special)
     taga = FPU_Special(a);
-  if ( tagb == TAG_Special )
+  if (tagb == TAG_Special)
     tagb = FPU_Special(b);
 
   /* TW_NaN is also used for unsupported data types. */
@@ -412,9 +412,9 @@ int real_2op_NaN(FPU_REG const *b, u_char tagb,
 		 && !((exponent(a) == EXP_OVER) && (a->sigh & 0x80000000)))
     || ((tagb == TW_NaN)
 	&& !((exponent(b) == EXP_OVER) && (b->sigh & 0x80000000)));
-  if ( unsupported )
+  if (unsupported)
     {
-      if ( control_word & CW_Invalid )
+      if (control_word & CW_Invalid)
 	{
 	  /* Masked response */
 	  FPU_copy_to_regi(&CONST_QNaN, TAG_Special, deststnr);
@@ -429,9 +429,9 @@ int real_2op_NaN(FPU_REG const *b, u_char tagb,
       if (tagb == TW_NaN)
 	{
 	  signalling = !(a->sigh & b->sigh & 0x40000000);
-	  if ( significand(b) > significand(a) )
+	  if (significand(b) > significand(a))
 	    x = b;
-	  else if ( significand(b) == significand(a) )
+	  else if (significand(b) == significand(a))
 	    {
 	      /* The default result for the case of two "equal" NaNs (signs may
 		 differ) is chosen to reproduce 80486 behaviour */
@@ -461,17 +461,17 @@ int real_2op_NaN(FPU_REG const *b, u_char tagb,
     }
 #endif /* PARANOID */
 
-  if ( (!signalling) || (control_word & CW_Invalid) )
+  if ((!signalling) || (control_word & CW_Invalid))
     {
-      if ( ! x )
+      if (!x)
 	x = b;
 
-      if ( !(x->sigh & 0x80000000) )  /* pseudo-NaN ? */
+      if (!(x->sigh & 0x80000000))  /* pseudo-NaN ? */
 	x = &CONST_QNaN;
 
       FPU_copy_to_regi(x, TAG_Special, deststnr);
 
-      if ( !signalling )
+      if (!signalling)
 	return TAG_Special;
 
       /* ensure a Quiet NaN */
@@ -490,13 +490,13 @@ asmlinkage int arith_invalid(int deststnr)
 {
 
   EXCEPTION(EX_Invalid);
-  
-  if ( control_word & CW_Invalid )
+
+  if (control_word & CW_Invalid)
     {
       /* The masked response */
       FPU_copy_to_regi(&CONST_QNaN, TAG_Special, deststnr);
     }
-  
+
   return (!(control_word & CW_Invalid) ? FPU_Exception : 0) | TAG_Valid;
 
 }
@@ -508,14 +508,14 @@ asmlinkage int FPU_divide_by_zero(int deststnr, u_char sign)
   FPU_REG *dest = &st(deststnr);
   int tag = TAG_Valid;
 
-  if ( control_word & CW_ZeroDiv )
+  if (control_word & CW_ZeroDiv)
     {
       /* The masked response */
       FPU_copy_to_regi(&CONST_INF, TAG_Special, deststnr);
       setsign(dest, sign);
       tag = TAG_Special;
     }
- 
+
   EXCEPTION(EX_ZeroDiv);
 
   return (!(control_word & CW_ZeroDiv) ? FPU_Exception : 0) | tag;
@@ -526,7 +526,7 @@ asmlinkage int FPU_divide_by_zero(int deststnr, u_char sign)
 /* This may be called often, so keep it lean */
 int set_precision_flag(int flags)
 {
-  if ( control_word & CW_Precision )
+  if (control_word & CW_Precision)
     {
       partial_status &= ~(SW_C1 & flags);
       partial_status |= flags;   /* The masked response */
@@ -543,7 +543,7 @@ int set_precision_flag(int flags)
 /* This may be called often, so keep it lean */
 asmlinkage void set_precision_flag_up(void)
 {
-  if ( control_word & CW_Precision )
+  if (control_word & CW_Precision)
     partial_status |= (SW_Precision | SW_C1);   /* The masked response */
   else
     EXCEPTION(EX_Precision | SW_C1);
@@ -553,7 +553,7 @@ asmlinkage void set_precision_flag_up(void)
 /* This may be called often, so keep it lean */
 asmlinkage void set_precision_flag_down(void)
 {
-  if ( control_word & CW_Precision )
+  if (control_word & CW_Precision)
     {   /* The masked response */
       partial_status &= ~SW_C1;
       partial_status |= SW_Precision;
@@ -565,7 +565,7 @@ asmlinkage void set_precision_flag_down(void)
 
 asmlinkage int denormal_operand(void)
 {
-  if ( control_word & CW_Denormal )
+  if (control_word & CW_Denormal)
     {   /* The masked response */
       partial_status |= SW_Denorm_Op;
       return TAG_Special;
@@ -582,7 +582,7 @@ asmlinkage int arith_overflow(FPU_REG *dest)
 {
   int tag = TAG_Valid;
 
-  if ( control_word & CW_Overflow )
+  if (control_word & CW_Overflow)
     {
       /* The masked response */
 /* ###### The response here depends upon the rounding mode */
@@ -596,7 +596,7 @@ asmlinkage int arith_overflow(FPU_REG *dest)
     }
 
   EXCEPTION(EX_Overflow);
-  if ( control_word & CW_Overflow )
+  if (control_word & CW_Overflow)
     {
       /* The overflow exception is masked. */
       /* By definition, precision is lost.
@@ -615,10 +615,10 @@ asmlinkage int arith_underflow(FPU_REG *dest)
 {
   int tag = TAG_Valid;
 
-  if ( control_word & CW_Underflow )
+  if (control_word & CW_Underflow)
     {
       /* The masked response */
-      if ( exponent16(dest) <= EXP_UNDER - 63 )
+      if (exponent16(dest) <= EXP_UNDER - 63)
 	{
 	  reg_copy(&CONST_Z, dest);
 	  partial_status &= ~SW_C1;       /* Round down. */
@@ -636,7 +636,7 @@ asmlinkage int arith_underflow(FPU_REG *dest)
     }
 
   EXCEPTION(EX_Underflow);
-  if ( control_word & CW_Underflow )
+  if (control_word & CW_Underflow)
     {
       /* The underflow exception is masked. */
       EXCEPTION(EX_Precision);
@@ -651,7 +651,7 @@ asmlinkage int arith_underflow(FPU_REG *dest)
 void FPU_stack_overflow(void)
 {
 
- if ( control_word & CW_Invalid )
+ if (control_word & CW_Invalid)
     {
       /* The masked response */
       top--;
@@ -668,7 +668,7 @@ void FPU_stack_overflow(void)
 void FPU_stack_underflow(void)
 {
 
- if ( control_word & CW_Invalid )
+ if (control_word & CW_Invalid)
     {
       /* The masked response */
       FPU_copy_to_reg0(&CONST_QNaN, TAG_Special);
@@ -684,7 +684,7 @@ void FPU_stack_underflow(void)
 void FPU_stack_underflow_i(int i)
 {
 
- if ( control_word & CW_Invalid )
+ if (control_word & CW_Invalid)
     {
       /* The masked response */
       FPU_copy_to_regi(&CONST_QNaN, TAG_Special, i);
@@ -700,7 +700,7 @@ void FPU_stack_underflow_i(int i)
 void FPU_stack_underflow_pop(int i)
 {
 
- if ( control_word & CW_Invalid )
+ if (control_word & CW_Invalid)
     {
       /* The masked response */
       FPU_copy_to_regi(&CONST_QNaN, TAG_Special, i);
-- 
1.5.4.rc3

