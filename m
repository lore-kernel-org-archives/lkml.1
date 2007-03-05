Return-Path: <linux-kernel-owner+w=401wt.eu-S1752195AbXCEMio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbXCEMio (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 07:38:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbXCEMio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 07:38:44 -0500
Received: from il.qumranet.com ([82.166.9.18]:54523 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195AbXCEMio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 07:38:44 -0500
Message-ID: <45EC0EB7.7080300@qumranet.com>
Date: Mon, 05 Mar 2007 14:36:07 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>, Andi Kleen <ak@suse.de>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch] paravirt: VDSO page is essential
References: <20070305120631.GA14105@elte.hu>
In-Reply-To: <20070305120631.GA14105@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Subject: [patch] paravirt: VDSO page is essential
> From: Ingo Molnar <mingo@elte.hu>
>
> commit 3bbf54725467d604698721384d858b5983b87e8f disables the VDSO for 
> CONFIG_PARAVIRT kernels. This #ifdeffery was a bad change: the VDSO is 
> an essential component of Linux, and this change forces all of them to 
> use int $0x80 - including sane ones like KVM. (If a hypervisor does not 
> handle the VDSO properly then it can work things around via the vdso=0 
> boot option. Or CONFIG_PARAVIRT should not have been merged. But in any 
> case, it is a basic taste issue: we DO NOT #ifdef around core features 
> like this!)
>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/i386/kernel/sysenter.c |    4 ----
>  1 file changed, 4 deletions(-)
>
> Index: linux/arch/i386/kernel/sysenter.c
> ===================================================================
> --- linux.orig/arch/i386/kernel/sysenter.c
> +++ linux/arch/i386/kernel/sysenter.c
> @@ -27,11 +27,7 @@
>   * Should the kernel map a VDSO page into processes and pass its
>   * address down to glibc upon exec()?
>   */
> -#ifdef CONFIG_PARAVIRT
> -unsigned int __read_mostly vdso_enabled = 0;
> -#else
>  unsigned int __read_mostly vdso_enabled = 1;
> -#endif
>  
>  EXPORT_SYMBOL_GPL(vdso_enabled);
>  
>   

Can't paravirt patch the syscall instruction like it does the rest of 
the kernel?

[is someone keeping track of the number of patchsites? e.g. at what date 
will the entire kernel be generated at boot time?]


-- 
error compiling committee.c: too many arguments to function

