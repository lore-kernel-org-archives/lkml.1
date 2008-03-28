Return-Path: <linux-kernel-owner+w=401wt.eu-S1755273AbYC1Nl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbYC1Nl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 09:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754517AbYC1NlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 09:41:19 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4728 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754108AbYC1NlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 09:41:18 -0400
Date: Fri, 28 Mar 2008 14:41:02 +0100
From: Pavel Machek <pavel@ucw.cz>
To: yhlu.kernel@gmail.com
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: pat cpu feature bit setting for known cpus
Message-ID: <20080328134102.GA4404@ucw.cz>
References: <200803242324.35357.yhlu.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803242324.35357.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon 2008-03-24 23:24:34, Yinghai Lu wrote:
> [PATCH] x86: pat cpu feature bit setting for known cpus
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index eb94460..b186047 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -309,6 +309,19 @@ static void __cpuinit early_get_cap(struct cpuinfo_x86 *c)
>  
>  	}
>  
> +	clear_cpu_cap(c, X86_FEATURE_PAT);
> +
> +	switch (c->x86_vendor) {
> +	case X86_VENDOR_AMD:
> +		if (c->x86 >= 0xf && c->x86 <= 0x11)
> +			set_cpu_cap(c, X86_FEATURE_PAT);
> +		break;
> +	case X86_VENDOR_INTEL:
> +		if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))
> +			set_cpu_cap(c, X86_FEATURE_PAT);
> +		break;
> +	}
> +
>  }
>  
>  /*
> @@ -397,6 +410,18 @@ static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
>  		init_scattered_cpuid_features(c);
>  	}
>  
> +	clear_cpu_cap(c, X86_FEATURE_PAT);
> +
> +	switch (c->x86_vendor) {
> +	case X86_VENDOR_AMD:
> +		if (c->x86 >= 0xf && c->x86 <= 0x11)
> +			set_cpu_cap(c, X86_FEATURE_PAT);
> +		break;
> +	case X86_VENDOR_INTEL:
> +		if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))
> +			set_cpu_cap(c, X86_FEATURE_PAT);
> +		break;
> +	}
>  }
>  

Cut&paste programming? Can you make it a function?

> diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
> index 3f1dc97..ddaaaaa 100644
> --- a/arch/x86/kernel/setup_64.c
> +++ b/arch/x86/kernel/setup_64.c
> @@ -979,12 +979,19 @@ static void __cpuinit early_identify_cpu(struct cpuinfo_x86 *c)
>  	if (c->extended_cpuid_level >= 0x80000007)
>  		c->x86_power = cpuid_edx(0x80000007);
>  
> +
> +	clear_cpu_cap(c, X86_FEATURE_PAT);



>  	switch (c->x86_vendor) {
>  	case X86_VENDOR_AMD:
>  		early_init_amd(c);
> +		if (c->x86 >= 0xf && c->x86 <= 0x11)
> +			set_cpu_cap(c, X86_FEATURE_PAT);
>  		break;
>  	case X86_VENDOR_INTEL:
>  		early_init_intel(c);
> +		if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))
> +			set_cpu_cap(c, X86_FEATURE_PAT);
>  		break;
>  	}

one more copy...
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
