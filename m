Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657AbZICGre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbZICGre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 02:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754675AbZICGre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 02:47:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37729 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754528AbZICGrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 02:47:33 -0400
Date: Thu, 3 Sep 2009 08:47:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: Introduce new
	(non-)paranoia level to allow raw tracepoint access
Message-ID: <20090903064716.GA14911@elte.hu>
References: <tip-5380c1056d267eff49854c1fa03399bfe761da1e@git.kernel.org> <4A9F17DD.4050807@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9F17DD.4050807@cn.fujitsu.com>
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


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> >  static inline bool perf_paranoid_cpu(void)
> >  {
> >  	return sysctl_perf_counter_paranoid > 0;
> > @@ -3971,6 +3977,7 @@ static const struct pmu *tp_perf_counter_init(struct perf_counter *counter)
> >  	 * have these.
> >  	 */
> >  	if ((counter->attr.sample_type & PERF_SAMPLE_RAW) &&
> > +			&& perf_paranoid_tracepoint_raw() &&
> 
> "&& &&"
> 
> This leads to build failure.

Yeah - fixed that yesterday, forgot to push out :-/

	Ingo
