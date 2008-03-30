Return-Path: <linux-kernel-owner+w=401wt.eu-S1753326AbYC3Lnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbYC3Lnf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 07:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbYC3Ln2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 07:43:28 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:39847 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbYC3Ln1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 07:43:27 -0400
Date: Sun, 30 Mar 2008 04:43:26 -0700 (PDT)
From: dean gaudet <dean@arctic.org>
To: yhlu.kernel@gmail.com
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: pat cpu feature bit setting for known cpus
In-Reply-To: <200803242324.35357.yhlu.kernel@gmail.com>
Message-ID: <alpine.DEB.1.00.0803300442130.11059@twinlark.arctic.org>
References: <200803242324.35357.yhlu.kernel@gmail.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Mar 2008, Yinghai Lu wrote:

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

just a general comment on things like this... "x->x86 <= 0x11" ensures 
this file will have to be updated every time a new AMD CPU is released.


> +		break;
> +	case X86_VENDOR_INTEL:
> +		if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))

note that you didn't limit intel the same way... at least for the numerous 
core2 processor models.

-dean
