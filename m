Return-Path: <linux-kernel-owner+w=401wt.eu-S1751940AbZISEnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbZISEnt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 00:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751105AbZISEns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 00:43:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:35803 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbZISEns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 00:43:48 -0400
Subject: Re: [PATCH] x86: fix section mismatch kernel/time.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1252146555.4969.1.camel@ht.satnam>
References: <1252146555.4969.1.camel@ht.satnam>
Content-Type: text/plain
Date: Sat, 19 Sep 2009 10:12:42 +0530
Message-Id: <1253335362.3309.6.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[RESENDING]

On Sat, 2009-09-05 at 15:59 +0530, Jaswinder Singh Rajput wrote:
> Commit dd0a70c8 move tsc_init to late_time_init which leads to :
> 
> WARNING: arch/x86/built-in.o(.text+0x397f): Section mismatch in reference from the function x86_late_time_init() to the function .init.text:tsc_init()
> The function x86_late_time_init() references
> the function __init tsc_init().
> This is often because x86_late_time_init lacks a __init
> 
> So adding __init to x86_late_time_init() fixes this mismatch.
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/kernel/time.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
> index fcece00..8c6d692 100644
> --- a/arch/x86/kernel/time.c
> +++ b/arch/x86/kernel/time.c
> @@ -105,7 +105,7 @@ void __init hpet_time_init(void)
>  	setup_default_timer_irq();
>  }
>  
> -static void x86_late_time_init(void)
> +static void __init x86_late_time_init(void)
>  {
>  	x86_init.timers.timer_init();
>  	tsc_init();

