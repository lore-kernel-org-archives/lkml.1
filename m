Return-Path: <linux-kernel-owner+w=401wt.eu-S1759572AbYGRMXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572AbYGRMXA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 08:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758987AbYGRMWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 08:22:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47801 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758957AbYGRMWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 08:22:41 -0400
Date: Fri, 18 Jul 2008 14:22:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: I/O APIC: Always report how the timer has been
	set up
Message-ID: <20080718122227.GN6875@elte.hu>
References: <Pine.LNX.4.55.0807141845120.17431@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0807141845120.17431@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Maciej W. Rozycki <macro@linux-mips.org> wrote:

>  Following recent (and less so) issues with the 8254 timer when routed 
> through the I/O or local APIC, always report which configurations have 
> been tried and which one has been set up eventually.  This is so that 
> logs posted by people for some other reason can be used as a 
> cross-reference when investigating any possible future problems.
> 
>  The change unifies messages printed on 32-bit and 64-bit platforms 
> and adds trailing newlines (removes leading ones), so that proper log 
> level annotation can be used and any possible interspersed output will 
> not cause a mess.
> 
>  I have chosen to use apic_printk(APIC_QUIET, ...) rather than 
> printk(...) so that the distinction of these messages is maintained 
> making possible future decisions about changes in this area easier.  A 
> change posted separately making apic_verbosity unsigned removes any 
> extra code that would otherwise be generated as a result of this 
> design decision.
> 
> Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>

applied to tip/x86/apic, thanks Maciej.

ported this portion ontop of the write-around-removal patch:

>  	apic_write_around(APIC_LVT0, APIC_DM_FIXED | vector);	/* Fixed mode */
>  	enable_8259A_irq(0);
>  
>  	if (timer_irq_works()) {
> -		printk(" works.\n");
> +		apic_printk(APIC_QUIET, KERN_INFO "..... works.\n");
>  		goto out;
>  	}
>  	disable_8259A_irq(0);
>  	apic_write_around(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_FIXED | vector);
> -	printk(" failed.\n");
> +	apic_printk(APIC_QUIET, KERN_INFO "..... failed.\n");
>  
> -	printk(KERN_INFO "...trying to set up timer as ExtINT IRQ...");
> +	apic_printk(APIC_QUIET, KERN_INFO
> +		    "...trying to set up timer as ExtINT IRQ...\n");
>  
>  	init_8259A(0);
>  	make_8259A_irq(0);

	Ingo
