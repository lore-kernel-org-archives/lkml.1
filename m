Return-Path: <linux-kernel-owner+w=401wt.eu-S1756576AbYDXWOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbYDXWOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 18:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754755AbYDXWOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 18:14:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37319 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754767AbYDXWOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 18:14:37 -0400
Date: Thu, 24 Apr 2008 15:14:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@mailshack.com>
Subject: Re: [git pull] generic bitops
In-Reply-To: <20080424215739.GA32378@elte.hu>
Message-ID: <alpine.LFD.1.10.0804241510420.2779@woody.linux-foundation.org>
References: <20080424215739.GA32378@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 24 Apr 2008, Ingo Molnar wrote:
>
> this started out as improvements/generalizations to x86 bitops, but grew 
> generic impact (and generic optimizations) as well, so it's offered as a 
> separate tree.

Can you do the config thing differently?

> diff --git a/arch/um/Kconfig.i386 b/arch/um/Kconfig.i386
> index e09edfa..49990ea 100644
> --- a/arch/um/Kconfig.i386
> +++ b/arch/um/Kconfig.i386
> @@ -39,6 +39,14 @@ config ARCH_REUSE_HOST_VSYSCALL_AREA
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

.. because instead of having each architecture do these kinds of things, 
we're trying to make the *generic* code (ie lib/Kconfig) do

	config GENERIC_FIND_FIRST_BIT
		bool
		default n

so that you only have one single declaration (close to where the code 
actually exists), and then the architectures would just do

	select GENERIC_FIND_FIRST_BIT
	select GENERIC_FIND_NEXT_BIT

in their architecture settings. That's how we're now doing things like 
HAVE_IDE, HAVE_OPROFILE, etc etc.

Hmm?

		Linus
