Return-Path: <linux-kernel-owner+w=401wt.eu-S1751952AbYLWSYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbYLWSYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 13:24:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbYLWSYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 13:24:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57999 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbYLWSYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 13:24:13 -0500
Message-ID: <49512BF5.2010705@kernel.org>
Date: Tue, 23 Dec 2008 10:20:37 -0800
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jaswinder Singh <jaswinder@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: traps.c replace #if CONFIG_X86_32 with #ifdef	CONFIG_X86_32
References: <1230049211.14358.2.camel@jaswinder.satnam>
In-Reply-To: <1230049211.14358.2.camel@jaswinder.satnam>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh wrote:
> Impact: cleanup, avoid warning in X86_64
> 
> Fixes this warning in X86_64:
>   CC      arch/x86/kernel/traps.o
> arch/x86/kernel/traps.c:695:5: warning: "CONFIG_X86_32" is not defined
> 
> Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
> ---
>  arch/x86/kernel/traps.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index d327b53..2c00412 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -692,7 +692,7 @@ void math_error(void __user *ip)
>  
>  	err = swd & ~cwd & 0x3f;
>  
> -#if CONFIG_X86_32
> +#ifdef CONFIG_X86_32
>  	if (!err)
>  		return;
>  #endif

Applied to tip:x86/fpu, thanks.

Andi: you might have a perspective on this: in math_error() we bail out
if there is no error on i386, but not on x86-64.  I am rather assuming
that is because it simply can't happen on x86-64 (no IRQ 13 bullshit) so
it wasn't necessary?

Thanks,

	-hpa
