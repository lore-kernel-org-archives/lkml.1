Return-Path: <linux-kernel-owner+w=401wt.eu-S966490AbXHIQqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966490AbXHIQqy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 12:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965952AbXHIQqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 12:46:44 -0400
Received: from livid.absolutedigital.net ([66.92.46.173]:53472 "EHLO
	mx2.absolutedigital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965672AbXHIQqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 12:46:42 -0400
Date: Thu, 9 Aug 2007 12:46:01 -0400 (EDT)
From: Cal Peake <cp@absolutedigital.net>
To: Andi Kleen <ak@suse.de>
cc: tglx@linutronix.de, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [8/12] x86_64: Use global flag to disable broken local
 apic timer on AMD CPUs.
In-Reply-To: <20070809124136.00A6C14F3B@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0708091245070.31931@lancer.cnet.absolutedigital.net>
References: <20070809241.425881000@suse.de> <20070809124136.00A6C14F3B@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2007, Andi Kleen wrote:

> Index: linux/arch/i386/kernel/apic.c
> ===================================================================
> --- linux.orig/arch/i386/kernel/apic.c
> +++ linux/arch/i386/kernel/apic.c
> @@ -61,8 +61,9 @@ static int enable_local_apic __initdata 
>  
>  /* Local APIC timer verification ok */
>  static int local_apic_timer_verify_ok;
> -/* Disable local APIC timer from the kernel commandline or via dmi quirk */
> -static int local_apic_timer_disabled;
> +/* Disable local APIC timer from the kernel commandline or via dmi quirk
> +   or using CPU MSR check */
> +int local_apic_timer_disabled;
>  /* Local APIC timer works in C2 */
>  int local_apic_timer_c2_ok;
>  EXPORT_SYMBOL_GPL(local_apic_timer_c2_ok);
> @@ -370,9 +371,6 @@ void __init setup_boot_APIC_clock(void)
>  	long delta, deltapm;
>  	int pm_referenced = 0;
>  
> -	if (boot_cpu_has(X86_FEATURE_LAPIC_TIMER_BROKEN))
> -		local_apic_timer_disabled = 1;
> -
>  	/*
>  	 * The local apic timer can be disabled via the kernel
>  	 * commandline or from the test above. Register the lapic

Andi, just noticed that the comment above needs to be updated now.

-- 
Cal Peake

