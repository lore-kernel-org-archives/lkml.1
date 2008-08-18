Return-Path: <linux-kernel-owner+w=401wt.eu-S1752544AbYHRHSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbYHRHSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 03:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751051AbYHRHSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 03:18:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58908 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbYHRHSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 03:18:37 -0400
Date: Mon, 18 Aug 2008 09:18:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, hpa@zytor.com, tglx@linutronix.de,
       macro@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] -tip/apic merging one more series
Message-ID: <20080818071820.GB17961@elte.hu>
References: <1219002107-21832-1-git-send-email-gorcunov@gmail.com> <86802c440808171453i2869a7f3x1db27307dbec4db7@mail.gmail.com> <aa79d98a0808172122sfab2336ldfcccc88e4316712@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa79d98a0808172122sfab2336ldfcccc88e4316712@mail.gmail.com>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> On Mon, Aug 18, 2008 at 1:53 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> > please check if you need { } otherwise you broke 64 bit
> >
> >
> > static int lapic_resume(struct sys_device *dev)
> > {
> >        unsigned int l, h;
> >        unsigned long flags;
> >        int maxlvt;
> >
> >        if (!apic_pm_state.active)
> >                return 0;
> >
> >        maxlvt = lapic_get_maxlvt();
> >
> >        local_irq_save(flags);
> >
> > #ifdef CONFIG_X86_64
> >        if (x2apic)
> >                enable_x2apic();
> >        else
> > #endif
> >                /*
> >                 * Make sure the APICBASE points to the right address
> >                 *
> >                 * FIXME! This will be wrong if we ever support suspend on
> >                 * SMP! We'll need to do this as part of the CPU restore!
> >                 */
> >                rdmsr(MSR_IA32_APICBASE, l, h);
> >                l &= ~MSR_IA32_APICBASE_BASE;
> >                l |= MSR_IA32_APICBASE_ENABLE | mp_lapic_addr;
> >                wrmsr(MSR_IA32_APICBASE, l, h);
> >
> >
> > YH
> >
> 
> Oh...indeed. Thanks Yinghai! - will fix it today evening.
> Ingo drop this patch please (if it was applied).

hm, none of these patches has lapic_resume mentioned and current 
tip/master's version doesnt seem broken so there's nothing to drop.

plus 1/9 doesnt apply to tip/master. (nor tip/x86/apic, nor -git)

I'll wait for this to be sorted out.

	Ingo
