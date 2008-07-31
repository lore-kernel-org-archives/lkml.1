Return-Path: <linux-kernel-owner+w=401wt.eu-S1755646AbYGaQvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646AbYGaQvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 12:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbYGaQva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 12:51:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50328 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbYGaQv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 12:51:29 -0400
Date: Thu, 31 Jul 2008 18:51:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Glauber Costa <gcosta@redhat.com>, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [GIT-PULL] time.c integration
Message-ID: <20080731165113.GI26393@elte.hu>
References: <200807290103.m6T13vt3000862@file.rdu.redhat.com> <20080730185007.GB26389@elte.hu> <20080730185148.GA12336@elte.hu> <86802c440807301500t17108f4el2f4178154b8b164f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807301500t17108f4el2f4178154b8b164f@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> On Wed, Jul 30, 2008 at 11:51 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Ingo Molnar <mingo@elte.hu> wrote:
> >
> >> Also, please do smaller steps while bringing both time_32.c and
> >> time_64.c up into their final forms (and do it in multiple commits),
> >> and make sure each step compiles on their respective defconfig. time.c
> >> details are historically fragile, i'd not be surprised if this series
> >> was the target of bisection efforts.
> >
> > i briefly put your current variant into tip/master, but it has build
> > problems as well:
> >
> > arch/x86/kernel/io_apic_64.c: In function 'check_timer':
> > arch/x86/kernel/io_apic_64.c:2016: error: 'timer_ack' undeclared (first use in this function)
> > arch/x86/kernel/io_apic_64.c:2016: error: (Each undeclared identifier is reported only once
> > arch/x86/kernel/io_apic_64.c:2016: error: for each function it appears in.)
> >
> > with:
> >
> >  http://redhat.com/~mingo/misc/config-Wed_Jul_30_20_50_17_CEST_2008.bad
> >
> >        Ingo
> > --
> diff --git a/include/asm-x86/timer.h b/include/asm-x86/timer.h
> index d0babce..e4eb6ab 100644
> --- a/include/asm-x86/timer.h
> +++ b/include/asm-x86/timer.h
> @@ -9,8 +9,8 @@
>  unsigned long long native_sched_clock(void);
>  unsigned long native_calibrate_tsc(void);
> 
> -#ifdef CONFIG_X86_32
>  extern int timer_ack;
> +#ifdef CONFIG_X86_32
>  extern int recalibrate_cpu_khz(void);
>  #endif /* CONFIG_X86_32 */

thanks - but i'll wait for Glauber's new, more finegrained series. I 
think regarding time.c one cannot be over-cautious enough.

	Ingo
