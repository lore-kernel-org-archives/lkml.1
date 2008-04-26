Return-Path: <linux-kernel-owner+w=401wt.eu-S1759696AbYDZREj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759696AbYDZREj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 13:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758504AbYDZREa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 13:04:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38106 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758379AbYDZRE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 13:04:29 -0400
Date: Sat, 26 Apr 2008 10:03:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@mailshack.com>
Subject: Re: [git pull] generic bitops, take 2
In-Reply-To: <20080426151516.GA27894@elte.hu>
Message-ID: <alpine.LFD.1.10.0804260955300.2813@woody.linux-foundation.org>
References: <20080424215739.GA32378@elte.hu> <alpine.LFD.1.10.0804241510420.2779@woody.linux-foundation.org> <20080426151516.GA27894@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 26 Apr 2008, Ingo Molnar wrote:
> 
> i've added Alexander's patch that does the cleanup suggested by you

Well.. Not really:

> diff --git a/arch/um/Kconfig.x86_64 b/arch/um/Kconfig.x86_64
> index 3fbe69e..7a75043 100644
> --- a/arch/um/Kconfig.x86_64
> +++ b/arch/um/Kconfig.x86_64
> @@ -27,6 +27,14 @@ config SMP_BROKEN
>  	bool
>  	default y
>  
> +config GENERIC_FIND_FIRST_BIT
> +	bool
> +	default y
> +
> +config GENERIC_FIND_NEXT_BIT
> +	bool
> +	default y
> +

It still declares this GENERIC_FIND_*_BIT thing separately for UM.

Yes, that may _work_, but it's wrong to define it in two different places. 

It also makes me wonder why Kconfig.i386 can just include 
arch/x86/Kconfig.cpu, but x86_64 cannot?

		Linus
