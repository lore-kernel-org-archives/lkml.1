Return-Path: <linux-kernel-owner+w=401wt.eu-S1764868AbXHWUtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764868AbXHWUtG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 16:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760304AbXHWUsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 16:48:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33341 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757650AbXHWUsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 16:48:53 -0400
Date: Thu, 23 Aug 2007 13:47:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ego@in.ibm.com
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Ingo Molnar <mingo@elte.hu>, johnstul@us.ibm.com
Subject: Re: x86_64-dynticks-disable-hpet_id_legsup-hpets.patch hangs the
 system
Message-Id: <20070823134726.8f2c508a.akpm@linux-foundation.org>
In-Reply-To: <20070823112423.GA26084@in.ibm.com>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	<20070823112423.GA26084@in.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Aug 2007 16:54:23 +0530
Gautham R Shenoy <ego@in.ibm.com> wrote:

> 2.6.23-rc3-mm1 renders my machine unresponsive during bootup.
> I've been observing this problem in 2.6.22-rc2-mm2 as well.
> The boot log, the cpuinfo and .config have been appened at the
> end
> 
> After embedding a few debug printk's in start_kernel, I noticed that
> the last function to be executed was calibrate_delay()
> 
> Further, from the mm-bisect, the following patch turned out to be the
> culprit:
> 
> x86_64-dynticks-disable-hpet_id_legsup-hpets.patch 
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: john stultz <johnstul@us.ibm.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  arch/i386/kernel/hpet.c |    2 +-
>  1 files changed, 1 insertion(+), 1 deletion(-)
> 
> diff -puN arch/i386/kernel/hpet.c~x86_64-dynticks-disable-hpet_id_legsup-hpets arch/i386/kernel/hpet.c
> --- a/arch/i386/kernel/hpet.c~x86_64-dynticks-disable-hpet_id_legsup-hpets
> +++ a/arch/i386/kernel/hpet.c
> @@ -336,7 +336,7 @@ int __init hpet_enable(void)
>  
>  	clocksource_register(&clocksource_hpet);
>  
> -	if (id & HPET_ID_LEGSUP) {
> +	if (0 && (id & HPET_ID_LEGSUP)) {
>  		hpet_enable_int();
>  		hpet_reserve_platform_timers(id);
>  		/*
> 
> Any particular reason for this patch [There is no changelog :-)]? 
> Without this patch the mm-kernel seems to behave just fine for me.

Oh damn.  That patch is required to prevent a boot-time div-by-zero
on my old nocona machine.

I have a new set of x86_64-dynticks patches from Thomas to look at
so I guess it's reset-and-start-again time on that front.
