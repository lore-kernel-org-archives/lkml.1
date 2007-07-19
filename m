Return-Path: <linux-kernel-owner+w=401wt.eu-S964989AbXGSOrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964989AbXGSOrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760346AbXGSOrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 10:47:10 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39867 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786AbXGSOrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 10:47:08 -0400
Message-ID: <469F7962.6020108@garzik.org>
Date: Thu, 19 Jul 2007 10:46:58 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: jbeulich@novell.com, patches@x86-64.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] [34/58] x86_64: ia32entry adjustments
References: <200707191154.642492000@suse.de> <20070719095520.2124414E06@wotan.suse.de>
In-Reply-To: <20070719095520.2124414E06@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> From: "Jan Beulich" <jbeulich@novell.com>
> Consolidate the three 32-bit system call entry points so that they all
> treat registers in similar ways.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
>  arch/x86_64/ia32/ia32entry.S |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> Index: linux/arch/x86_64/ia32/ia32entry.S
> ===================================================================
> --- linux.orig/arch/x86_64/ia32/ia32entry.S
> +++ linux/arch/x86_64/ia32/ia32entry.S
> @@ -104,7 +104,7 @@ ENTRY(ia32_sysenter_target)
>  	pushq	%rax
>  	CFI_ADJUST_CFA_OFFSET 8
>  	cld
> -	SAVE_ARGS 0,0,0
> +	SAVE_ARGS 0,0,1
>   	/* no need to do an access_ok check here because rbp has been
>   	   32bit zero extended */ 
>  1:	movl	(%rbp),%r9d
> @@ -294,7 +294,7 @@ ia32_badarg:
>   */ 				
>  
>  ENTRY(ia32_syscall)
> -	CFI_STARTPROC	simple
> +	CFI_STARTPROC32	simple
>  	CFI_SIGNAL_FRAME
>  	CFI_DEF_CFA	rsp,SS+8-RIP
>  	/*CFI_REL_OFFSET	ss,SS-RIP*/
> @@ -330,6 +330,7 @@ ia32_sysret:
>  
>  ia32_tracesys:			 
>  	SAVE_REST
> +	CLEAR_RREGS
>  	movq $-ENOSYS,RAX(%rsp)	/* really needed? */
>  	movq %rsp,%rdi        /* &pt_regs -> arg1 */
>  	call syscall_trace_enter

More comments and/or a less vague patch description would be nice.

What registers?  What behavior is being made common?  Why?

	Jeff


