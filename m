Return-Path: <linux-kernel-owner+w=401wt.eu-S933327AbZLKBEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933327AbZLKBEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 20:04:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933265AbZLKBEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 20:04:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55344 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762050AbZLKBEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 20:04:33 -0500
Message-ID: <4B219A6F.1060801@zytor.com>
Date: Thu, 10 Dec 2009 17:03:43 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Andreas Herrmann <herrmann.der.user@googlemail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] x86, amd: Make check_c1e_idle explicit
References: <20091210133232.GA5471@alberich.amd.com>
In-Reply-To: <20091210133232.GA5471@alberich.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch needs a lot better documentation.  For one thing, it needs an
explicit patch comment!

In particular, is this a contract that fam 0x12+ will behave differently?

	-hpa

On 12/10/2009 05:32 AM, Andreas Herrmann wrote:
> 
> CC: stable@kernel.org
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---
>  arch/x86/kernel/process.c |   14 ++++++--------
>  1 files changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index ea54ce8..1bf98b1 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -494,21 +494,19 @@ static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
>  }
>  
>  /*
> - * Check for AMD CPUs, which have potentially C1E support
> + * Check for AMD CPUs, which potentially use SMI or hardware initiated C1E
>   */
>  static int __cpuinit check_c1e_idle(const struct cpuinfo_x86 *c)
>  {
>  	if (c->x86_vendor != X86_VENDOR_AMD)
>  		return 0;
>  
> -	if (c->x86 < 0x0F)
> -		return 0;
> -
> -	/* Family 0x0f models < rev F do not have C1E */
> -	if (c->x86 == 0x0f && c->x86_model < 0x40)
> -		return 0;
> +	if ((c->x86 == 0x0F && c->x86_model >= 0x40) ||
> +	    (c->x86 == 0x10) ||
> +	    (c->x86 == 0x11))
> +		return 1;
>  
> -	return 1;
> +	return 0;
>  }
>  
>  static cpumask_var_t c1e_mask;

