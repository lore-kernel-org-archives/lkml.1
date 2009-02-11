Return-Path: <linux-kernel-owner+w=401wt.eu-S1755655AbZBKKoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655AbZBKKoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 05:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbZBKKnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 05:43:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44998 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827AbZBKKnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 05:43:51 -0500
Date: Wed, 11 Feb 2009 11:43:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Morten P.D. Stevens" <mstevens@win-professional.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: warning in arch/x86/kernel/cpu/mtrr/generic.c:400 with
	2.6.29-rc3 on IBM x3400
Message-ID: <20090211104332.GM20518@elte.hu>
References: <B4ED8DE8E195E84A872496A085BC07822F18@exchange01.corp.win-professional.com> <B4ED8DE8E195E84A872496A085BC07822F1D@exchange01.corp.win-professional.com> <20090209234528.GA862@elte.hu> <4990E90D.30005@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4990E90D.30005@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> Ingo Molnar wrote:
> > * Morten P.D. Stevens <mstevens@win-professional.com> wrote:
> > 
> >> Hi,
> >>
> >> Update:
> >>
> >> the same issue with a linux 2.6.28.4 kernel.
> >>
> >> [    0.000000] ------------[ cut here ]------------
> >> [    0.000000] WARNING: at arch/x86/kernel/cpu/mtrr/generic.c:404 generic_get_mtrr+0xdf/0x119()
> >> [    0.000000] mtrr: your BIOS has set up an incorrect mask, fixing it up.
> > 
> > buggy BIOS most likely. Had the kernel not fixed up the MTRRs you'd have
> > a very slow and unhappy system now.
> 
> please try:
> diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
> index 0c0a455..7a359ce 100644
> --- a/arch/x86/kernel/cpu/mtrr/generic.c
> +++ b/arch/x86/kernel/cpu/mtrr/generic.c
> @@ -397,7 +397,8 @@ static void generic_get_mtrr(unsigned int reg, unsigned long *base,
>  		tmp |= ~((1<<(hi - 1)) - 1);
>  
>  		if (tmp != mask_lo) {
> -			WARN_ONCE(1, KERN_INFO "mtrr: your BIOS has set up an incorrect mask, fixing it up.\n");
> +			printk(KERN_INFO "mtrr: BIOS set mask_lo: %x should be %x, fixing it up\n", mask_lo, tmp);
> +			WARN_ONCE(1, KERN_INFO "mtrr: your BIOS has set up an incorrect mask.\n");
>  			mask_lo = tmp;
>  		}
>  	}

Could you please embedd this info in the WARN_ONCE() itself please, so that it gets 
reported as one unit? (and send a proper changelogged patch, etc.) WARN_ONCE() is a 
full printk as well so you can add anything to it.

Thanks,

	Ingo
