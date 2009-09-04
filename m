Return-Path: <linux-kernel-owner+w=401wt.eu-S933064AbZIDHty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064AbZIDHty (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 03:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932840AbZIDHtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 03:49:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48716 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932973AbZIDHtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 03:49:51 -0400
Date: Fri, 4 Sep 2009 09:49:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alok Kataria <akataria@vmware.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH: x86] Print the hypervisor returned tsc_khz during boot.
Message-ID: <20090904074938.GE20598@elte.hu>
References: <1251076103.29422.32.camel@ank32.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251076103.29422.32.camel@ank32.eng.vmware.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alok Kataria <akataria@vmware.com> wrote:

> On an AMD-64 system the processor frequency that is printed during 
> system boot, may be different than the tsc frequency that was 
> returned by the hypervisor, due to value returned from 
> calibrate_cpu. For debugging timekeeping or other related issues 
> it might be better to get the tsc_khz value returned by the 
> hypervisor.
> 
> The patch below now prints the tsc frequency that the hypervisor 
> returned. Please consider for tip.
> 
> --
> Signed-off-by: Alok N Kataria <akataria@vmware.com>
> 
> Index: linux-tip-master/arch/x86/kernel/tsc.c
> ===================================================================
> --- linux-tip-master.orig/arch/x86/kernel/tsc.c	2009-08-23 17:53:44.000000000 -0700
> +++ linux-tip-master/arch/x86/kernel/tsc.c	2009-08-23 17:55:08.000000000 -0700
> @@ -405,7 +405,10 @@ unsigned long native_calibrate_tsc(void)
>  
>  	hv_tsc_khz = get_hypervisor_tsc_freq();
>  	if (hv_tsc_khz) {
> -		printk(KERN_INFO "TSC: Frequency read from the hypervisor\n");
> +		printk(KERN_INFO "TSC: Frequency read from the hypervisor : "
> +				"%lu.%03lu MHz\n",
> +				(unsigned long) hv_tsc_khz / 1000,
> +				(unsigned long) hv_tsc_khz % 1000);
>  		return hv_tsc_khz;
>  	}

Makes sense. Note, arch/x86/kernel/tsc.c changed recently so this 
patch does not apply anymore - mind merging it on top of that and 
re-send it?

Thanks,

	Ingo
