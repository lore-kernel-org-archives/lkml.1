Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbYCYBbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbYCYBbB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 21:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbYCYBay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 21:30:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48911 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbYCYBax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 21:30:53 -0400
Message-ID: <47E85593.4030104@zytor.com>
Date: Mon, 24 Mar 2008 18:29:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: yhlu.kernel@gmail.com
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: enable PAT for amd k8 and fam10h
References: <200803241602.01957.yhlu.kernel@gmail.com>
In-Reply-To: <200803241602.01957.yhlu.kernel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> [PATCH] x86: enable PAT for amd k8 and fam10h
> 
> make known_pat_cpu to think amd k8 and fam10h is ok too.
> 
> also make tom2 below to be WRBACK
> 
> diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
> index f74505f..a9e1a27 100644
> --- a/arch/x86/mm/pat.c
> +++ b/arch/x86/mm/pat.c
> @@ -49,6 +49,12 @@ static int pat_known_cpu(void)
>  			return 1;
>  		}
>  	}
> +	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
> +	     boot_cpu_data.x86 >= 0xf && boot_cpu_data.x86 <= 0x11) {
> +		if (cpu_has_pat) {
> +			return 1;
> +		}
> +	}
>  
>  	pat_wc_enabled = 0;
>  	printk(KERN_INFO "CPU and/or kernel does not support PAT.\n");

This really should be handled through a CPU flag.  Specifically, it 
should be handled by disabling the PAT flag if PAT is unusable or 
suspect of being unusable; it should *NOT* be stashed away in a 
completely separate piece of code.

	-hpa
