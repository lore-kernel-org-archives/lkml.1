Return-Path: <linux-kernel-owner+w=401wt.eu-S933158AbYAaMI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933158AbYAaMI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 07:08:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764428AbYAaMIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 07:08:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56868 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764372AbYAaMIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 07:08:49 -0500
Date: Thu, 31 Jan 2008 13:08:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] x86: c_p_a clflush_cache_range fix
Message-ID: <20080131120829.GB12571@elte.hu>
References: <1201764962.12950.23.camel@caritas-dev.intel.com> <200801310840.25221.ak@suse.de> <1201768073.21226.2.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201768073.21226.2.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Huang, Ying <ying.huang@intel.com> wrote:

> +++ b/arch/x86/kernel/cpu/common.c
> @@ -274,8 +274,10 @@ void __init cpu_detect(struct cpuinfo_x8
>  		if (c->x86 >= 0x6)
>  			c->x86_model += ((tfms >> 16) & 0xF) << 4;
>  		c->x86_mask = tfms & 15;
> -		if (cap0 & (1<<19))
> +		if (cap0 & (1<<19)) {
>  			c->x86_cache_alignment = ((misc >> 8) & 0xff) * 8;
> +			c->x86_clflush_size = ((misc >> 8) & 0xff) * 8;
> +		}

thanks!

> @@ -317,6 +319,7 @@ static void __init early_cpu_detect(void
>  	struct cpuinfo_x86 *c = &boot_cpu_data;
>  
>  	c->x86_cache_alignment = 32;
> +	c->x86_clflush_size = 32;

i suspect 32 is a good lower limit (it's not a big issue to do too 
finegrained flushes, and CLFLUSH is valid with arbitrary alignment) - 
and this will be overriden with 64 later on.

	Ingo
