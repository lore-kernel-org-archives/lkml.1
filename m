Return-Path: <linux-kernel-owner+w=401wt.eu-S1762794AbYAaPWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762794AbYAaPWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 10:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755959AbYAaPWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 10:22:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59697 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046AbYAaPWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 10:22:10 -0500
Date: Thu, 31 Jan 2008 16:21:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: remove unused code in set_cyc2ns_scale()
Message-ID: <20080131152158.GB26963@elte.hu>
References: <1201641301-9288-1-git-send-email-guichaz@yahoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201641301-9288-1-git-send-email-guichaz@yahoo.fr>
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


* Guillaume Chazarain <guichaz@yahoo.fr> wrote:

>  arch/x86/kernel/tsc_32.c |   14 +++++---------
>  arch/x86/kernel/tsc_64.c |   14 +++++---------
>  2 files changed, 10 insertions(+), 18 deletions(-)

>  static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
>  {
> -	unsigned long flags, prev_scale, *scale;
> -	unsigned long long tsc_now, ns_now;
> +	unsigned long flags, *scale;
> +
> +	if (!cpu_khz)
> +		return;
>  
>  	local_irq_save(flags);
>  	sched_clock_idle_sleep_event();
>  
>  	scale = &per_cpu(cyc2ns, cpu);
> -
> -	rdtscll(tsc_now);
> -	ns_now = __cycles_2_ns(tsc_now);
> -
> -	prev_scale = *scale;
> -	if (cpu_khz)
> -		*scale = (NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR)/cpu_khz;
> +	*scale = (NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR)/cpu_khz;

hm, this is not a pure elimination of dead code, this will change 
behavior. For example we wont call sched_clock_idle_sleep_event() on 
!cpu_khz now. Hm?

	Ingo
