Return-Path: <linux-kernel-owner+w=401wt.eu-S1753088AbYIZMjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbYIZMjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 08:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751383AbYIZMjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 08:39:12 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:35876 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750894AbYIZMjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 08:39:12 -0400
Message-Id: <1222432751.13247.1276111293@webmail.messagingengine.com>
X-Sasl-Enc: mVeGCTnFHIRK5mHaGyM/dJWa6Q99I5MIwu6LYK2JfWbq 1222432751
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Ingo Molnar" <mingo@elte.hu>, "lkml" <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1222430588-29072-1-git-send-email-heukelum@fastmail.fm>
 <1222430588-29072-2-git-send-email-heukelum@fastmail.fm>
Subject: Re: [PATCH 1/7] traps: x86_64: add TRACE_IRQS_OFF in error_entry
In-Reply-To: <1222430588-29072-2-git-send-email-heukelum@fastmail.fm>
Date: Fri, 26 Sep 2008 14:39:11 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 26 Sep 2008 14:03:02 +0200, "Alexander van Heukelum"
<heukelum@fastmail.fm> said:
> Add TRACE_IRQS_OFF just before entering the C code.
> 
> All exceptions are taken via interrupt gates. If irq tracing is
> enabled, it should be notified as soon as possible. Interrupts
> are only (conditionally) re-enabled in C code.
> 
> Signed-off-by: Alexander van Heukelum <fastmail.fm>

That should be: <heukelum@fastmail.fm> ---^^^
Same for patch 2/7. How did that happen?

> ---
>  arch/x86/kernel/entry_64.S |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index 89434d4..78fa552 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -1058,7 +1058,8 @@ KPROBE_ENTRY(error_entry)
>  	je  error_kernelspace
>  error_swapgs:	
>  	SWAPGS
> -error_sti:	
> +error_sti:
> +	TRACE_IRQS_OFF
>  	movq %rdi,RDI(%rsp) 	
>  	CFI_REL_OFFSET	rdi,RDI
>  	movq %rsp,%rdi
> -- 
> 1.5.4.3
> 
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - Or how I learned to stop worrying and
                          love email again

