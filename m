Return-Path: <linux-kernel-owner+w=401wt.eu-S1758922AbZFJLF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922AbZFJLF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 07:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754081AbZFJLFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 07:05:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35050 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633AbZFJLFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 07:05:51 -0400
Date: Wed, 10 Jun 2009 13:05:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnd Bergmann <arnd@arndb.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Yong Wang <yong.y.wang@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] perf_counter/x86: Fix the model number of Intel
	Core2 processors
Message-ID: <20090610110544.GF27724@elte.hu>
References: <20090610090612.GA26580@ywang-moblin2.bj.intel.com> <200906101301.08483.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906101301.08483.arnd@arndb.de>
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


* Arnd Bergmann <arnd@arndb.de> wrote:

> On Wednesday 10 June 2009, Yong Wang wrote:
> > diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
> > index 40978aa..a49a82c 100644
> > --- a/arch/x86/kernel/cpu/perf_counter.c
> > +++ b/arch/x86/kernel/cpu/perf_counter.c
> > @@ -1407,7 +1407,8 @@ static int intel_pmu_init(void)
> >          * Install the hw-cache-events table:
> >          */
> >         switch (boot_cpu_data.x86_model) {
> > -       case 17:
> > +       case 15:
> > +       case 23:
> >                 memcpy(hw_cache_event_ids, core2_hw_cache_event_ids,
> >                        sizeof(hw_cache_event_ids));
> 
> There are actually four model numbers that refer to the same
> core microarchitecture:
> 
> model 15: original 65 nm celeron/pentium/core2/xeon, "Merom"/"Conroe"
> model 22: single-core 65 nm celeron/core2solo "Merom-L"/"Conroe-L"
> model 23: current 45 nm celeron/core2/xeon "Penryn"/"Wolfdale"
> model 29: six-core 45 nm xeon "Dunnington"
> 
> You should probably list all of them here.

Yeah - i've amended the commit with your suggestions - thanks Arnd!

	Ingo
