Return-Path: <linux-kernel-owner+w=401wt.eu-S1030685AbXDJOgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030685AbXDJOgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 10:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030723AbXDJOgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 10:36:38 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:35839 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030685AbXDJOgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 10:36:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tAsXEC78XcinllcIkSecxPgoyZbC5SigN83gPsrEG8SWPptafx+5YxT5VZQbAMSIXh2ZFXhprlCmLUzBXl8dPH/hJGyGRlMDQLBon9WnLqi8OtKdpKcw1s7NJq6hS75TQwUgWz27eFC1VFNdExotRImIpI80wAbXGYjwrcetyng=
Message-ID: <9a8748490704100736l49b0a7c6t49d21900f4f23e33@mail.gmail.com>
Date: Tue, 10 Apr 2007 16:36:36 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Zachary Amsden" <zach@vmware.com>
Subject: Re: [PATCH 3/10] I386 mcheck p4 grotesque and needless warning fix.patch
Cc: "Andrew Morton" <akpm@osdl.org>, "Andi Kleen" <ak@muc.de>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Rusty Russell" <rusty@rustcorp.com.au>,
       "Chris Wright" <chrisw@sous-sol.org>,
       "Virtualization Mailing List" <virtualization@lists.osdl.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200704100006.l3A068Xk020608@zach-dev.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200704100006.l3A068Xk020608@zach-dev.vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/07, Zachary Amsden <zach@vmware.com> wrote:
> No, just no.  You do not use goto to skip a code block.  You do not
> return an obvious variable from a singly-inlined function and give
> the function a return value.  You don't put unexplained comments
> about kmalloc in code which doesn't do dynamic allocation.  And
> you don't leave stray warnings around for no good reason.
>
> Also, when possible, it is better to use block scoped variables
> because gcc can sometime generate better code.
>
> Signed-off-by: Zachary Amsden <zach@vmware.com>
>
> diff -r ed741f57dae8 arch/i386/kernel/cpu/mcheck/p4.c
> --- a/arch/i386/kernel/cpu/mcheck/p4.c  Fri Apr 06 14:29:52 2007 -0700
> +++ b/arch/i386/kernel/cpu/mcheck/p4.c  Fri Apr 06 14:43:24 2007 -0700
[...]
>  static fastcall void intel_machine_check(struct pt_regs * regs, long error_code)
> @@ -155,7 +146,6 @@ static fastcall void intel_machine_check
>         u32 alow, ahigh, high, low;
>         u32 mcgstl, mcgsth;
>         int i;
> -       struct intel_mce_extended_msrs dbg;
>
>         rdmsr (MSR_IA32_MCG_STATUS, mcgstl, mcgsth);
>         if (mcgstl & (1<<0))    /* Recoverable ? */
> @@ -164,7 +154,9 @@ static fastcall void intel_machine_check
>         printk (KERN_EMERG "CPU %d: Machine Check Exception: %08x%08x\n",
>                 smp_processor_id(), mcgsth, mcgstl);
>
> -       if (intel_get_extended_msrs(&dbg)) {
> +       if (mce_num_extended_msrs > 0) {
> +               struct intel_mce_extended_msrs dbg;

shouldn't there be a blank line here?

> +               intel_get_extended_msrs(&dbg);
>                 printk (KERN_DEBUG "CPU %d: EIP: %08x EFLAGS: %08x\n",
>                         smp_processor_id(), dbg.eip, dbg.eflags);
>                 printk (KERN_DEBUG "\teax: %08x ebx: %08x ecx: %08x edx: %08x\n",


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
