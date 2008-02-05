Return-Path: <linux-kernel-owner+w=401wt.eu-S1760712AbYBEUNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760712AbYBEUNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 15:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757856AbYBEUNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 15:13:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38523 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585AbYBEUNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 15:13:09 -0500
Message-ID: <47A8C336.1010107@zytor.com>
Date: Tue, 05 Feb 2008 12:12:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] x86 updates
References: <20080204161219.GA8092@elte.hu> <alpine.LFD.1.00.0802051043550.9374@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802051043550.9374@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> Ingo, Thomas,
>  should we not do this?
> 
> Otherwise, it seems we generate a section that isn't allocated?
> 
> I think toolchain should add the right flags automatically for sections 
> that start with ".[ro]data" and ".text", but not for the kernel-specific 
> ".init.*" sections.
> 
> 		Linus
> 
> ---
>  arch/x86/kernel/head_64.S |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
> index 4f283ad..d16d7b8 100644
> --- a/arch/x86/kernel/head_64.S
> +++ b/arch/x86/kernel/head_64.S
> @@ -251,7 +251,7 @@ ENTRY(secondary_startup_64)
>  
>  	/* SMP bootup changes these two */
>  #ifndef CONFIG_HOTPLUG_CPU
> -	.pushsection .init.data
> +	.pushsection .init.data,"aw"
>  #endif
>  	.align	8
>  	.globl	initial_code

I definitely think we should add flags where applicable.

	-hpa
