Return-Path: <linux-kernel-owner+w=401wt.eu-S1757075AbXF3S5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075AbXF3S5b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 14:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754229AbXF3S5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 14:57:09 -0400
Received: from science.horizon.com ([192.35.100.1]:13611 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751330AbXF3S5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 14:57:08 -0400
Date: 30 Jun 2007 14:57:06 -0400
Message-ID: <20070630185706.3979.qmail@science.horizon.com>
From: linux@horizon.com
To: ak@suse.de, akpm@linux-foundation.org, linux@horizon.com
Subject: Re: 2.6.22-rcX Transmeta/APM regression
Cc: bk@suse.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, michal.k.k.piotrowski@gmail.com
In-Reply-To: <200706301126.41179.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Responding to various proposed fixes:

> Index: linux/arch/i386/kernel/cpu/mtrr/main.c
> ===================================================================
> --- linux.orig/arch/i386/kernel/cpu/mtrr/main.c
> +++ linux/arch/i386/kernel/cpu/mtrr/main.c
> @@ -734,8 +734,11 @@ void mtrr_ap_init(void)
>   */
>  void mtrr_save_state(void)
>  {
> -	int cpu = get_cpu();
> +	int cpu;
>  
> +	if (!cpu_has_mtrr)
> +		return;
> +	cpu  = get_cpu();
>  	if (cpu == 0)
>  		mtrr_save_fixed_ranges(NULL);
>  	else

This does not change the symptoms in any way.

> --- a/arch/i386/kernel/cpu/mtrr/generic.c~i386-mtrr-crash-fix
> +++ a/arch/i386/kernel/cpu/mtrr/generic.c
> @@ -65,7 +65,8 @@ get_fixed_ranges(mtrr_type * frs)
>  
>  void mtrr_save_fixed_ranges(void *info)
>  {
> -	get_fixed_ranges(mtrr_state.fixed_ranges);
> +	if (cpu_has_mtrr)
> +		get_fixed_ranges(mtrr_state.fixed_ranges);
>  }
>  
>  static void print_fixed(unsigned base, unsigned step, const mtrr_type*types)

This works great, thanks!  Please consider the regression diagnosed and fixed.
