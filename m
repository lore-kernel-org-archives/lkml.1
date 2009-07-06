Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbZGFUYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbZGFUYA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 16:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbZGFUXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 16:23:49 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:64896 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbZGFUXt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 16:23:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=yC3r0/hMTFyo/XwISQHGAYZoYLa8aPvCW6YS6Lt7cMI1TDVRUxw4t7w4vRrpmpMWxv
         IJZVgW4yUx5Qp+abJKgIciDN7OZQEGbn2XBs/H8uylL4hw6cgaqWRVeDEY2UBRNbQ2VD
         aIIwHdcLZhhQeftJ3eMITLrAF5IKLIQ8zvAQg=
MIME-Version: 1.0
In-Reply-To: <1246910740.4643.10.camel@Joe-Laptop.home>
References: <4A4C3410.8080704@kernel.org> <alpine.LFD.2.01.0907012119370.3380@localhost.localdomain> 
	<1246513356.28915.62.camel@Joe-Laptop.home> <alpine.LFD.2.01.0907021020200.4830@localhost.localdomain> 
	<1246556320.28915.92.camel@Joe-Laptop.home> <alpine.LFD.2.01.0907021043160.4830@localhost.localdomain> 
	<1246910740.4643.10.camel@Joe-Laptop.home>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 6 Jul 2009 16:23:31 -0400
Message-ID: <8bd0f97a0907061323j3480fa61sa7f44d71819a076d@mail.gmail.com>
Subject: Re: [PATCH] Remove multiple KERN_ prefixes from printk formats
To: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 6, 2009 at 16:05, Joe Perches wrote:
> commit 5fd29d6ccbc98884569d6f3105aeca70858b3e0f changed
> printk semantics.  printk lines with multiple KERN_<level>
> prefixes are no longer emitted as before the patch.
>
> <level> is now included in the output on each additional use.
>
> Remove all uses of multiple KERN_<level>s in formats.

thanks, i had started this in the Blackfin code a little, but your
patch includes what i did and more, so the Blackfin stuff should be
mostly fine (pending comments below).

> --- a/arch/blackfin/kernel/traps.c
> +++ b/arch/blackfin/kernel/traps.c
> @@ -212,7 +212,7 @@ asmlinkage void double_fault_c(struct pt_regs *fp)
>        console_verbose();
>        oops_in_progress = 1;
>  #ifdef CONFIG_DEBUG_VERBOSE
> -       printk(KERN_EMERG "\n" KERN_EMERG "Double Fault\n");
> +       printk(KERN_EMERG "Double Fault\n");

dropped a newline.  we've largely made sure the newlines and such were
as we want in the output ... in this case, it is not a matter of
adding a newline where one did not exist before

> -                       verbose_printk(KERN_NOTICE "\n" KERN_NOTICE "Kernel Stack\n");
> +                       verbose_printk(KERN_NOTICE "Kernel Stack\n");

and here

> -               verbose_printk(KERN_NOTICE "\n" KERN_NOTICE
> -                    "No Valid process in current context\n");
> +               verbose_printk(KERN_NOTICE
> +                              "No Valid process in current context\n");

and here

> -       verbose_printk(KERN_NOTICE "\n" KERN_NOTICE "SEQUENCER STATUS:\t\t%s\n", print_tainted());
> +       verbose_printk(KERN_NOTICE "\nSEQUENCER STATUS:\t\t%s\n",
> +                      print_tainted());

and here

> -       verbose_printk(KERN_NOTICE "\n" KERN_NOTICE "PROCESSOR STATE:\n");
> +       verbose_printk(KERN_NOTICE "PROCESSOR STATE:\n");

and here
-mike
