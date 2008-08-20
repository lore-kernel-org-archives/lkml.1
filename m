Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbYHTM6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbYHTM6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 08:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753823AbYHTM6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 08:58:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59130 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436AbYHTM6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 08:58:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: Use X86_CR4_PGE in x86/power/hibernate_asm_32.S
Date: Wed, 20 Aug 2008 15:01:28 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Uros Bizjak <ubizjak@gmail.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Pavel Machek <pavel@ucw.cz>
References: <5787cf470808200144ta2f28b4nd9b2922cbec73d78@mail.gmail.com> <20080820095353.GB28492@elte.hu>
In-Reply-To: <20080820095353.GB28492@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808201501.29606.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 20 of August 2008, Ingo Molnar wrote:
> 
> * Uros Bizjak <ubizjak@gmail.com> wrote:
> 
> > Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> 
> applied the commit below to tip/x86/cleanups - thanks Uros.
> 
> i did a small change: i moved the .text to after the include files. 
> While include files are not supposed to change section attributes, it 
> looks logically more consistent to have the .text right before the code.
> 
> 	Ingo
> 
> ----------------->
> From c171f465b7281f2d3b03e9145ec763d6a8bab176 Mon Sep 17 00:00:00 2001
> From: Uros Bizjak <ubizjak@gmail.com>
> Date: Wed, 20 Aug 2008 10:44:47 +0200
> Subject: [PATCH] x86, cleanup: use X86_CR4_PGE in x86/power/hibernate_asm_32.S
> 
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

> ---
>  arch/x86/power/hibernate_asm_32.S |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/power/hibernate_asm_32.S b/arch/x86/power/hibernate_asm_32.S
> index 4fc7e87..d1e9b53 100644
> --- a/arch/x86/power/hibernate_asm_32.S
> +++ b/arch/x86/power/hibernate_asm_32.S
> @@ -1,5 +1,3 @@
> -.text
> -
>  /*
>   * This may not use any stack, nor any variable that is not "NoSave":
>   *
> @@ -12,17 +10,18 @@
>  #include <asm/segment.h>
>  #include <asm/page.h>
>  #include <asm/asm-offsets.h>
> +#include <asm/processor-flags.h>
>  
> -	.text
> +.text
>  
>  ENTRY(swsusp_arch_suspend)
> -
>  	movl %esp, saved_context_esp
>  	movl %ebx, saved_context_ebx
>  	movl %ebp, saved_context_ebp
>  	movl %esi, saved_context_esi
>  	movl %edi, saved_context_edi
> -	pushfl ; popl saved_context_eflags
> +	pushfl
> +	popl saved_context_eflags
>  
>  	call swsusp_save
>  	ret
> @@ -59,7 +58,7 @@ done:
>  	movl	mmu_cr4_features, %ecx
>  	jecxz	1f	# cr4 Pentium and higher, skip if zero
>  	movl	%ecx, %edx
> -	andl	$~(1<<7), %edx;  # PGE
> +	andl	$~(X86_CR4_PGE), %edx
>  	movl	%edx, %cr4;  # turn off PGE
>  1:
>  	movl	%cr3, %eax;  # flush TLB
> @@ -74,7 +73,8 @@ done:
>  	movl saved_context_esi, %esi
>  	movl saved_context_edi, %edi
>  
> -	pushl saved_context_eflags ; popfl
> +	pushl saved_context_eflags
> +	popfl
>  
>  	xorl	%eax, %eax
>  
> 
> 


