Return-Path: <linux-kernel-owner+w=401wt.eu-S1759113AbZFLMSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759113AbZFLMSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 08:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbZFLMSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:18:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55728 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbZFLMSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:18:02 -0400
Date: Fri, 12 Jun 2009 14:17:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/checksyscalls.sh: only whine perf_counter_open
	when supported
Message-ID: <20090612121757.GD31845@elte.hu>
References: <1244806169-12232-1-git-send-email-vapier@gentoo.org> <20090612120507.GH16044@elte.hu> <8bd0f97a0906120513u4e823460t8192f00fd0460ab@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a0906120513u4e823460t8192f00fd0460ab@mail.gmail.com>
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


* Mike Frysinger <vapier.adi@gmail.com> wrote:

> On Fri, Jun 12, 2009 at 08:05, Ingo Molnar wrote:
> > * Mike Frysinger <vapier@gentoo.org> wrote:
> >> If the port does not support HAVE_PERF_COUNTERS, then they can't
> >> support the perf_counter_open syscall either.  Rather than forcing
> >> everyone to add an ignore (or suffer the warning until they get
> >> around to implementing support), only whine about the syscall when
> >> applicable.
> >
> > No, this patch is wrong - it's really easy to add support: just hook
> > up the syscall. This should happen for every architecture really, so
> > the warning is correct and it should not be patched out.
> >
> > PMU support is not required to get perfcounters support: if an
> > architecture hooks up the syscall it will get generic software
> > counters and the tools will work as well.
> >
> > Profiling falls back to a hrtimer-based sampling method - this is a
> > much better fallback than oprofile's fall-back to the timer tick.
> > This hrtimer based sampling is dynticks/nohz-correct and can go
> > beyond HZ if the architecture supports hrtimers.
> 
> if there is generic support available, why must every arch select 
> HAVE_PERF_COUNTERS in their Kconfig ?

Because we only want to enable it on architectures that have tested 
it. It should only need a syscall addition, but nothing beats having 
tested things, hence we have that additional Kconfig symbol.

Thanks,

	Ingo
