Return-Path: <linux-kernel-owner+w=401wt.eu-S1757755AbZA2KhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755AbZA2KhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 05:37:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbZA2KhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 05:37:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38790 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176AbZA2KhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 05:37:02 -0500
Date: Thu, 29 Jan 2009 11:36:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: steiner@sgi.com, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Patch 01/14] Add definitions of x86_64 GRU MMRs.
Message-ID: <20090129103649.GA4262@elte.hu>
References: <20090122174917.563627000@sgi.com> <20090122175025.475956000@sgi.com> <20090128013527.005648cc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090128013527.005648cc.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 22 Jan 2009 11:49:18 -0600 steiner@sgi.com wrote:
> 
> > Add definitions for x86_64 GRU MMRs.
> 
> Breaks x86_32:
> 
> arch/x86/include/asm/uv/uv_mmrs.h:409: error: width of 'real_time_cmpb' exceeds its type
> arch/x86/include/asm/uv/uv_mmrs.h:425: error: width of 'real_time_cmpc' exceeds its type
> arch/x86/include/asm/uv/uv_mmrs.h:441: error: width of 'real_time_cmpd' exceeds its type
> arch/x86/include/asm/uv/uv_mmrs.h:491: error: width of 'address' exceeds its type
> <etc>
> 
> due to stuff flike
> 
> 	unsigned long	real_time_cmpb : 56;  /* RW */
> 
> 
> this:
> 
> --- a/arch/x86/kernel/io_apic.c~a
> +++ a/arch/x86/kernel/io_apic.c
> @@ -59,8 +59,11 @@
>  #include <asm/setup.h>
>  #include <asm/irq_remapping.h>
>  #include <asm/hpet.h>
> +
> +#ifdef CONFIG_X86_64
>  #include <asm/uv/uv_hub.h>
>  #include <asm/uv/uv_irq.h>
> +#endif
>  
>  #include <mach_ipi.h>
>  #include <mach_apic.h>
> _
> 
> seems sufficient, but perhaps it'd be better if it was done within the
> header?

Modifications to this file should be submitted to the x86 tree in any 
case.

	Ingo
