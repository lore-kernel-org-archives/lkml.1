Return-Path: <linux-kernel-owner+w=401wt.eu-S1757929AbYA0Vp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929AbYA0Vp3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 16:45:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528AbYA0VpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 16:45:18 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:49940 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466AbYA0VpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 16:45:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=UOWlEWVivK7MUzum0rwpAkK9S5MImRD9N+Q2HLqF+joHESL7qkXlT23Ckn9s1gSexUHImQSRQLCJ80KyaSBz2q3jfov4Hx7PI1hoOFNWLgMBUn1vKGjyvkxeM62rIoBuC0JSajlaNWAE59ZKCrAXh4srQo0ueE1sZWJo83qWFzE=
Message-ID: <479CFB62.1010808@gmail.com>
Date: Mon, 28 Jan 2008 00:45:06 +0300
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] X86: coding style fixes to arch/x86/math-errors.c
References: <20080127223451.79718183@paolo-desktop>
In-Reply-To: <20080127223451.79718183@paolo-desktop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Ciarrocchi пишет:
> This file has not been modified since October so should be 
> easy to integrate the following patch.
> 
> Before:
> total: 214 errors, 28 warnings, 739 lines checked
> 
> After:
> total: 4 errors, 28 warnings, 708 lines checked
> 
> Compile tested:
> 
> paolo@paolo-desktop:/tmp$ size error.o.*
>    text    data     bss     dec     hex filename
>    3476       0       0    3476     d94 error.o.after
>    3476       0       0    3476     d94 error.o.before
> 
> Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
> ---
> 
> The only remaining errors are like the following:
> 
> ERROR: need consistent spacing around '*' (ctx:WxB)
> #110: FILE: errors.c:110:
> +         FPU_get_user(FPU_modrm, 1 + (u_char __user *) address);
>                                                      ^
> Any hint on how to fix them?
> 
> 
>  arch/x86/math-emu/errors.c |  405 ++++++++++++++++++++------------------------
>  1 files changed, 187 insertions(+), 218 deletions(-)
> 
> diff --git a/arch/x86/math-emu/errors.c b/arch/x86/math-emu/errors.c
> index a1b0d22..3510abe 100644
> --- a/arch/x86/math-emu/errors.c
> +++ b/arch/x86/math-emu/errors.c
> @@ -43,25 +43,23 @@ void Un_impl(void)
>    RE_ENTRANT_CHECK_OFF;
>    /* No need to check access_ok(), we have previously fetched these bytes. */
>    printk("Unimplemented FPU Opcode at eip=%p : ", (void __user *) address);
> -  if ( FPU_CS == __USER_CS )
> -    {
> -      while ( 1 )
> -	{
> +  if (FPU_CS == __USER_CS) {
> +      while (1) {
>  	  FPU_get_user(byte1, (u_char __user *) address);
> -	  if ( (byte1 & 0xf8) == 0xd8 ) break;
> +	  if ((byte1 & 0xf8) == 0xd8)
> +	    break;
>  	  printk("[%02x]", byte1);
>  	  address++;
>  	}
>        printk("%02x ", byte1);
>        FPU_get_user(FPU_modrm, 1 + (u_char __user *) address);
> -      
> +
>        if (FPU_modrm >= 0300)
>  	printk("%02x (%02x+%d)\n", FPU_modrm, FPU_modrm & 0xf8, FPU_modrm & 7);
>        else
>  	printk("/%d\n", (FPU_modrm >> 3) & 7);
>      }
> -  else
> -    {
> +  else {
>        printk("cs selector = %04x\n", FPU_CS);
>      }
>  
> @@ -76,10 +74,10 @@ void Un_impl(void)
>  /*
>     Called for opcodes which are illegal and which are known to result in a
>     SIGILL with a real 80486.
> -   */
> +*/
>  void FPU_illegal(void)
>  {
> -  math_abort(FPU_info,SIGILL);
> +  math_abort(FPU_info , SIGILL);

Looks like you're trading bad for worse here.

>  }
>  
>  
> @@ -88,61 +86,69 @@ void FPU_printall(void)
>  {
>    int i;
>    static const char *tag_desc[] = { "Valid", "Zero", "ERROR", "Empty",
> -                              "DeNorm", "Inf", "NaN" };
> +					"DeNorm", "Inf", "NaN" };
>    u_char byte1, FPU_modrm;
>    unsigned long address = FPU_ORIG_EIP;
>  
>    RE_ENTRANT_CHECK_OFF;
>    /* No need to check access_ok(), we have previously fetched these bytes. */
>    printk("At %p:", (void *) address);
> -  if ( FPU_CS == __USER_CS )
> -    {
> +  if (FPU_CS == __USER_CS) {
>  #define MAX_PRINTED_BYTES 20
> -      for ( i = 0; i < MAX_PRINTED_BYTES; i++ )
> -	{
> +      for (i = 0; i < MAX_PRINTED_BYTES; i++) {
>  	  FPU_get_user(byte1, (u_char __user *) address);
> -	  if ( (byte1 & 0xf8) == 0xd8 )
> -	    {
> +	  if ((byte1 & 0xf8) == 0xd8) {
>  	      printk(" %02x", byte1);
>  	      break;
>  	    }
>  	  printk(" [%02x]", byte1);
>  	  address++;
>  	}
> -      if ( i == MAX_PRINTED_BYTES )
> +      if (i == MAX_PRINTED_BYTES)
>  	printk(" [more..]\n");
> -      else
> -	{
> +      else {
>  	  FPU_get_user(FPU_modrm, 1 + (u_char __user *) address);
> -	  
> +
>  	  if (FPU_modrm >= 0300)
> -	    printk(" %02x (%02x+%d)\n", FPU_modrm, FPU_modrm & 0xf8, FPU_modrm & 7);
> +	    printk(" %02x (%02x+%d)\n", FPU_modrm, FPU_modrm & 0xf8,
> +			FPU_modrm & 7);
>  	  else
>  	    printk(" /%d, mod=%d rm=%d\n",
>  		   (FPU_modrm >> 3) & 7, (FPU_modrm >> 6) & 3, FPU_modrm & 7);
>  	}
>      }
>    else
> -    {
>        printk("%04x\n", FPU_CS);
> -    }
>  
>    partial_status = status_word();
>  
>  #ifdef DEBUGGING
> -if ( partial_status & SW_Backward )    printk("SW: backward compatibility\n");
> -if ( partial_status & SW_C3 )          printk("SW: condition bit 3\n");
> -if ( partial_status & SW_C2 )          printk("SW: condition bit 2\n");
> -if ( partial_status & SW_C1 )          printk("SW: condition bit 1\n");
> -if ( partial_status & SW_C0 )          printk("SW: condition bit 0\n");
> -if ( partial_status & SW_Summary )     printk("SW: exception summary\n");
> -if ( partial_status & SW_Stack_Fault ) printk("SW: stack fault\n");
> -if ( partial_status & SW_Precision )   printk("SW: loss of precision\n");
> -if ( partial_status & SW_Underflow )   printk("SW: underflow\n");
> -if ( partial_status & SW_Overflow )    printk("SW: overflow\n");
> -if ( partial_status & SW_Zero_Div )    printk("SW: divide by zero\n");
> -if ( partial_status & SW_Denorm_Op )   printk("SW: denormalized operand\n");
> -if ( partial_status & SW_Invalid )     printk("SW: invalid operation\n");
> +if (partial_status & SW_Backward)
> +  printk("SW: backward compatibility\n");
> +if (partial_status & SW_C3)
> +  printk("SW: condition bit 3\n");
> +if (partial_status & SW_C2)
> +  printk("SW: condition bit 2\n");
> +if (partial_status & SW_C1)
> +  printk("SW: condition bit 1\n");
> +if (partial_status & SW_C0)
> +  printk("SW: condition bit 0\n");
> +if (partial_status & SW_Summary)
> +  printk("SW: exception summary\n");
> +if (partial_status & SW_Stack_Fault)
> +  printk("SW: stack fault\n");
> +if (partial_status & SW_Precision)
> +  printk("SW: loss of precision\n");
> +if (partial_status & SW_Underflow)
> +  printk("SW: underflow\n");
> +if (partial_status & SW_Overflow)
> +  printk("SW: overflow\n");
> +if (partial_status & SW_Zero_Div)
> +  printk("SW: divide by zero\n");
> +if (partial_status & SW_Denorm_Op)
> +  printk("SW: denormalized operand\n");
> +if (partial_status & SW_Invalid)
> +  printk("SW: invalid operation\n");

While you're at it, please think about adding proper KERN_ facility to these printk() calls.

>  #endif /* DEBUGGING */
>  
>    printk(" SW: b=%d st=%ld es=%d sf=%d cc=%d%d%d%d ef=%d%d%d%d%d%d\n",

Ditto.

> @@ -155,7 +161,7 @@ if ( partial_status & SW_Invalid )     printk("SW: invalid operation\n");
>  	 partial_status & SW_Precision?1:0, partial_status & SW_Underflow?1:0,
>  	 partial_status & SW_Overflow?1:0, partial_status & SW_Zero_Div?1:0,
>  	 partial_status & SW_Denorm_Op?1:0, partial_status & SW_Invalid?1:0);
> -  
> +
>  printk(" CW: ic=%d rc=%ld%ld pc=%ld%ld iem=%d     ef=%d%d%d%d%d%d\n",

Ditto.

>  	 control_word & 0x1000 ? 1 : 0,
>  	 (control_word & 0x800) >> 11, (control_word & 0x400) >> 10,
> @@ -165,12 +171,10 @@ printk(" CW: ic=%d rc=%ld%ld pc=%ld%ld iem=%d     ef=%d%d%d%d%d%d\n",
>  	 control_word & SW_Overflow?1:0, control_word & SW_Zero_Div?1:0,
>  	 control_word & SW_Denorm_Op?1:0, control_word & SW_Invalid?1:0);
>  
> -  for ( i = 0; i < 8; i++ )
> -    {
> +  for (i = 0; i < 8; i++) {
>        FPU_REG *r = &st(i);
>        u_char tagi = FPU_gettagi(i);
> -      switch (tagi)
> -	{
> +	switch (tagi) {
>  	case TAG_Empty:
>  	  continue;
>  	  break;
> @@ -219,78 +223,78 @@ static struct {
>   error was detected.
>  
>   Internal error types:
> -       0x14   in fpu_etc.c
> -       0x1nn  in a *.c file:
> -              0x101  in reg_add_sub.c
> -              0x102  in reg_mul.c
> -              0x104  in poly_atan.c
> -              0x105  in reg_mul.c
> -              0x107  in fpu_trig.c
> -	      0x108  in reg_compare.c
> -	      0x109  in reg_compare.c
> -	      0x110  in reg_add_sub.c
> -	      0x111  in fpe_entry.c
> -	      0x112  in fpu_trig.c
> -	      0x113  in errors.c
> -	      0x115  in fpu_trig.c
> -	      0x116  in fpu_trig.c
> -	      0x117  in fpu_trig.c
> -	      0x118  in fpu_trig.c
> -	      0x119  in fpu_trig.c
> -	      0x120  in poly_atan.c
> -	      0x121  in reg_compare.c
> -	      0x122  in reg_compare.c
> -	      0x123  in reg_compare.c
> -	      0x125  in fpu_trig.c
> -	      0x126  in fpu_entry.c
> -	      0x127  in poly_2xm1.c
> -	      0x128  in fpu_entry.c
> -	      0x129  in fpu_entry.c
> -	      0x130  in get_address.c
> -	      0x131  in get_address.c
> -	      0x132  in get_address.c
> -	      0x133  in get_address.c
> -	      0x140  in load_store.c
> -	      0x141  in load_store.c
> -              0x150  in poly_sin.c
> -              0x151  in poly_sin.c
> -	      0x160  in reg_ld_str.c
> -	      0x161  in reg_ld_str.c
> -	      0x162  in reg_ld_str.c
> -	      0x163  in reg_ld_str.c
> -	      0x164  in reg_ld_str.c
> -	      0x170  in fpu_tags.c
> -	      0x171  in fpu_tags.c
> -	      0x172  in fpu_tags.c
> -	      0x180  in reg_convert.c
> -       0x2nn  in an *.S file:
> -              0x201  in reg_u_add.S
> -              0x202  in reg_u_div.S
> -              0x203  in reg_u_div.S
> -              0x204  in reg_u_div.S
> -              0x205  in reg_u_mul.S
> -              0x206  in reg_u_sub.S
> -              0x207  in wm_sqrt.S
> -	      0x208  in reg_div.S
> -              0x209  in reg_u_sub.S
> -              0x210  in reg_u_sub.S
> -              0x211  in reg_u_sub.S
> -              0x212  in reg_u_sub.S
> -	      0x213  in wm_sqrt.S
> -	      0x214  in wm_sqrt.S
> -	      0x215  in wm_sqrt.S
> -	      0x220  in reg_norm.S
> -	      0x221  in reg_norm.S
> -	      0x230  in reg_round.S
> -	      0x231  in reg_round.S
> -	      0x232  in reg_round.S
> -	      0x233  in reg_round.S
> -	      0x234  in reg_round.S
> -	      0x235  in reg_round.S
> -	      0x236  in reg_round.S
> -	      0x240  in div_Xsig.S
> -	      0x241  in div_Xsig.S
> -	      0x242  in div_Xsig.S
> +	0x14   in fpu_etc.c
> +	0x1nn  in a *.c file:
> +	0x101  in reg_add_sub.c
> +	0x102  in reg_mul.c
> +	0x104  in poly_atan.c
> +	0x105  in reg_mul.c
> +	0x107  in fpu_trig.c
> +	0x108  in reg_compare.c
> +	0x109  in reg_compare.c
> +	0x110  in reg_add_sub.c
> +	0x111  in fpe_entry.c
> +	0x112  in fpu_trig.c
> +	0x113  in errors.c
> +	0x115  in fpu_trig.c
> +	0x116  in fpu_trig.c
> +	0x117  in fpu_trig.c
> +	0x118  in fpu_trig.c
> +	0x119  in fpu_trig.c
> +	0x120  in poly_atan.c
> +	0x121  in reg_compare.c
> +	0x122  in reg_compare.c
> +	0x123  in reg_compare.c
> +	0x125  in fpu_trig.c
> +	0x126  in fpu_entry.c
> +	0x127  in poly_2xm1.c
> +	0x128  in fpu_entry.c
> +	0x129  in fpu_entry.c
> +	0x130  in get_address.c
> +	0x131  in get_address.c
> +	0x132  in get_address.c
> +	0x133  in get_address.c
> +	0x140  in load_store.c
> +	0x141  in load_store.c
> +	0x150  in poly_sin.c
> +	0x151  in poly_sin.c
> +	0x160  in reg_ld_str.c
> +	0x161  in reg_ld_str.c
> +	0x162  in reg_ld_str.c
> +	0x163  in reg_ld_str.c
> +	0x164  in reg_ld_str.c
> +	0x170  in fpu_tags.c
> +	0x171  in fpu_tags.c
> +	0x172  in fpu_tags.c
> +	0x180  in reg_convert.c
> +	0x2nn  in an *.S file:
> +	0x201  in reg_u_add.S
> +	0x202  in reg_u_div.S
> +	0x203  in reg_u_div.S
> +	0x204  in reg_u_div.S
> +	0x205  in reg_u_mul.S
> +	0x206  in reg_u_sub.S
> +	0x207  in wm_sqrt.S
> +	0x208  in reg_div.S
> +	0x209  in reg_u_sub.S
> +	0x210  in reg_u_sub.S
> +	0x211  in reg_u_sub.S
> +	0x212  in reg_u_sub.S
> +	0x213  in wm_sqrt.S
> +	0x214  in wm_sqrt.S
> +	0x215  in wm_sqrt.S
> +	0x220  in reg_norm.S
> +	0x221  in reg_norm.S
> +	0x230  in reg_round.S
> +	0x231  in reg_round.S
> +	0x232  in reg_round.S
> +	0x233  in reg_round.S
> +	0x234  in reg_round.S
> +	0x235  in reg_round.S
> +	0x236  in reg_round.S
> +	0x240  in div_Xsig.S
> +	0x241  in div_Xsig.S
> +	0x242  in div_Xsig.S
>   */
>  
>  asmlinkage void FPU_exception(int n)
> @@ -298,25 +302,22 @@ asmlinkage void FPU_exception(int n)
>    int i, int_type;
>  
>    int_type = 0;         /* Needed only to stop compiler warnings */
> -  if ( n & EX_INTERNAL )
> -    {
> +  if (n & EX_INTERNAL) {
>        int_type = n - EX_INTERNAL;
>        n = EX_INTERNAL;
>        /* Set lots of exception bits! */
>        partial_status |= (SW_Exc_Mask | SW_Summary | SW_Backward);
>      }
> -  else
> -    {
> +  else {
>        /* Extract only the bits which we use to set the status word */
>        n &= (SW_Exc_Mask);
>        /* Set the corresponding exception bit */
>        partial_status |= n;
>        /* Set summary bits iff exception isn't masked */
> -      if ( partial_status & ~control_word & CW_Exceptions )
> +      if (partial_status & ~control_word & CW_Exceptions)
>  	partial_status |= (SW_Summary | SW_Backward);
> -      if ( n & (SW_Stack_Fault | EX_Precision) )
> -	{
> -	  if ( !(n & SW_C1) )
> +      if (n & (SW_Stack_Fault | EX_Precision)) {
> +	  if (!(n & SW_C1))
>  	    /* This bit distinguishes over- from underflow for a stack fault,
>  	       and roundup from round-down for precision loss. */
>  	    partial_status &= ~SW_C1;
> @@ -324,29 +325,26 @@ asmlinkage void FPU_exception(int n)
>      }
>  
>    RE_ENTRANT_CHECK_OFF;
> -  if ( (~control_word & n & CW_Exceptions) || (n == EX_INTERNAL) )
> -    {
> +  if ((~control_word & n & CW_Exceptions) || (n == EX_INTERNAL)) {
>  #ifdef PRINT_MESSAGES
>        /* My message from the sponsor */
>        printk(FPU_VERSION" "__DATE__" (C) W. Metzenthen.\n");
>  #endif /* PRINT_MESSAGES */
> -      
> +
>        /* Get a name string for error reporting */
> -      for (i=0; exception_names[i].type; i++)
> -	if ( (exception_names[i].type & n) == exception_names[i].type )
> +      for (i = 0; exception_names[i].type; i++)
> +	if ((exception_names[i].type & n) == exception_names[i].type)
>  	  break;
> -      
> -      if (exception_names[i].type)
> -	{
> +
> +      if (exception_names[i].type) {
>  #ifdef PRINT_MESSAGES
>  	  printk("FP Exception: %s!\n", exception_names[i].name);
>  #endif /* PRINT_MESSAGES */
>  	}
>        else
>  	printk("FPU emulator: Unknown Exception: 0x%04x!\n", n);
> -      
> -      if ( n == EX_INTERNAL )
> -	{
> +
> +      if (n == EX_INTERNAL) {
>  	  printk("FPU emulator: Internal error type 0x%04x\n", int_type);
>  	  FPU_printall();
>  	}
> @@ -364,7 +362,7 @@ asmlinkage void FPU_exception(int n)
>    RE_ENTRANT_CHECK_ON;
>  
>  #ifdef __DEBUG__
> -  math_abort(FPU_info,SIGFPE);
> +  math_abort(FPU_info , SIGFPE);

Why do you need this extra space before the comma?

This file seems to be in need of formatting lines to use tabs instead of spaces.

Thanks,

Dmitri
