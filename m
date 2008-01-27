Return-Path: <linux-kernel-owner+w=401wt.eu-S1758934AbYA0VvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934AbYA0VvY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 16:51:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbYA0VvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 16:51:09 -0500
Received: from hs-out-0708.google.com ([64.233.178.240]:40244 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758289AbYA0VvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 16:51:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jyIaRvWap3dPizWYrrgF2AVZQVDEu1LPph4hQNdpnypiHGn66RiZkbftm8KT7d3YaCVNQvv4uiSEg16GYUirVB72okG/u0y/kNpafpe4CeC/CHHoidJDL8ZbOnhBLHQ/gIFPHn085tKI65MAxlGYgO1hvD63PTRTlp39N8JSxBA=
Message-ID: <4d8e3fd30801271351p44818f64p27ca4ae897efbb81@mail.gmail.com>
Date: Sun, 27 Jan 2008 22:51:00 +0100
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Dmitri Vorobiev" <dmitri.vorobiev@gmail.com>
Subject: Re: [PATCH] X86: coding style fixes to arch/x86/math-errors.c
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <479CFB62.1010808@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080127223451.79718183@paolo-desktop>
	 <479CFB62.1010808@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 27, 2008 10:45 PM, Dmitri Vorobiev <dmitri.vorobiev@gmail.com> wrote:
> > -  math_abort(FPU_info,SIGILL);
> > +  math_abort(FPU_info , SIGILL);
>
> Looks like you're trading bad for worse here.

Should I make it read like math_abort(FPU_info, SIGILL); ?

>
> >  }
> >
> >
> > @@ -88,61 +86,69 @@ void FPU_printall(void)
> >  {
> >    int i;
> >    static const char *tag_desc[] = { "Valid", "Zero", "ERROR", "Empty",
> > -                              "DeNorm", "Inf", "NaN" };
> > +                                     "DeNorm", "Inf", "NaN" };
> >    u_char byte1, FPU_modrm;
> >    unsigned long address = FPU_ORIG_EIP;
> >
> >    RE_ENTRANT_CHECK_OFF;
> >    /* No need to check access_ok(), we have previously fetched these bytes. */
> >    printk("At %p:", (void *) address);
> > -  if ( FPU_CS == __USER_CS )
> > -    {
> > +  if (FPU_CS == __USER_CS) {
> >  #define MAX_PRINTED_BYTES 20
> > -      for ( i = 0; i < MAX_PRINTED_BYTES; i++ )
> > -     {
> > +      for (i = 0; i < MAX_PRINTED_BYTES; i++) {
> >         FPU_get_user(byte1, (u_char __user *) address);
> > -       if ( (byte1 & 0xf8) == 0xd8 )
> > -         {
> > +       if ((byte1 & 0xf8) == 0xd8) {
> >             printk(" %02x", byte1);
> >             break;
> >           }
> >         printk(" [%02x]", byte1);
> >         address++;
> >       }
> > -      if ( i == MAX_PRINTED_BYTES )
> > +      if (i == MAX_PRINTED_BYTES)
> >       printk(" [more..]\n");
> > -      else
> > -     {
> > +      else {
> >         FPU_get_user(FPU_modrm, 1 + (u_char __user *) address);
> > -
> > +
> >         if (FPU_modrm >= 0300)
> > -         printk(" %02x (%02x+%d)\n", FPU_modrm, FPU_modrm & 0xf8, FPU_modrm & 7);
> > +         printk(" %02x (%02x+%d)\n", FPU_modrm, FPU_modrm & 0xf8,
> > +                     FPU_modrm & 7);
> >         else
> >           printk(" /%d, mod=%d rm=%d\n",
> >                  (FPU_modrm >> 3) & 7, (FPU_modrm >> 6) & 3, FPU_modrm & 7);
> >       }
> >      }
> >    else
> > -    {
> >        printk("%04x\n", FPU_CS);
> > -    }
> >
> >    partial_status = status_word();
> >
> >  #ifdef DEBUGGING
> > -if ( partial_status & SW_Backward )    printk("SW: backward compatibility\n");
> > -if ( partial_status & SW_C3 )          printk("SW: condition bit 3\n");
> > -if ( partial_status & SW_C2 )          printk("SW: condition bit 2\n");
> > -if ( partial_status & SW_C1 )          printk("SW: condition bit 1\n");
> > -if ( partial_status & SW_C0 )          printk("SW: condition bit 0\n");
> > -if ( partial_status & SW_Summary )     printk("SW: exception summary\n");
> > -if ( partial_status & SW_Stack_Fault ) printk("SW: stack fault\n");
> > -if ( partial_status & SW_Precision )   printk("SW: loss of precision\n");
> > -if ( partial_status & SW_Underflow )   printk("SW: underflow\n");
> > -if ( partial_status & SW_Overflow )    printk("SW: overflow\n");
> > -if ( partial_status & SW_Zero_Div )    printk("SW: divide by zero\n");
> > -if ( partial_status & SW_Denorm_Op )   printk("SW: denormalized operand\n");
> > -if ( partial_status & SW_Invalid )     printk("SW: invalid operation\n");
> > +if (partial_status & SW_Backward)
> > +  printk("SW: backward compatibility\n");
> > +if (partial_status & SW_C3)
> > +  printk("SW: condition bit 3\n");
> > +if (partial_status & SW_C2)
> > +  printk("SW: condition bit 2\n");
> > +if (partial_status & SW_C1)
> > +  printk("SW: condition bit 1\n");
> > +if (partial_status & SW_C0)
> > +  printk("SW: condition bit 0\n");
> > +if (partial_status & SW_Summary)
> > +  printk("SW: exception summary\n");
> > +if (partial_status & SW_Stack_Fault)
> > +  printk("SW: stack fault\n");
> > +if (partial_status & SW_Precision)
> > +  printk("SW: loss of precision\n");
> > +if (partial_status & SW_Underflow)
> > +  printk("SW: underflow\n");
> > +if (partial_status & SW_Overflow)
> > +  printk("SW: overflow\n");
> > +if (partial_status & SW_Zero_Div)
> > +  printk("SW: divide by zero\n");
> > +if (partial_status & SW_Denorm_Op)
> > +  printk("SW: denormalized operand\n");
> > +if (partial_status & SW_Invalid)
> > +  printk("SW: invalid operation\n");
>
> While you're at it, please think about adding proper KERN_ facility to these printk() calls.

Yes, basically all the warnings are about missing KERN_.
Do you want me to add KERN_ERR  to all the above printk?

> >  #endif /* DEBUGGING */
> >
> >    printk(" SW: b=%d st=%ld es=%d sf=%d cc=%d%d%d%d ef=%d%d%d%d%d%d\n",
>
> Ditto.
>
> > @@ -155,7 +161,7 @@ if ( partial_status & SW_Invalid )     printk("SW: invalid operation\n");
> >        partial_status & SW_Precision?1:0, partial_status & SW_Underflow?1:0,
> >        partial_status & SW_Overflow?1:0, partial_status & SW_Zero_Div?1:0,
> >        partial_status & SW_Denorm_Op?1:0, partial_status & SW_Invalid?1:0);
> > -
> > +
> >  printk(" CW: ic=%d rc=%ld%ld pc=%ld%ld iem=%d     ef=%d%d%d%d%d%d\n",
>
> Ditto.
>
[...]

> >  #ifdef __DEBUG__
> > -  math_abort(FPU_info,SIGFPE);
> > +  math_abort(FPU_info , SIGFPE);
>
> Why do you need this extra space before the comma?

My mistake.

> This file seems to be in need of formatting lines to use tabs instead of spaces.
>

Ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
