Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112Ab0CDVNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 16:13:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38436 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756437Ab0CDVNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 16:13:53 -0500
Date: Thu, 4 Mar 2010 22:13:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, paulus@samba.org,
       fweisbec@gmail.com, perfmon2-devel@lists.sf.net, robert.richter@amd.com,
       eranian@gmail.com, davem@davemloft.net,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perf_events: add sampling period randomization support
 (v2)
Message-ID: <20100304211332.GA3643@elte.hu>
References: <1267575705-10054-1-git-send-email-eranian@google.com>
 <20100304113212.GG21977@elte.hu>
 <bd4cb8901003040925t28ddcc5bmfce11dcfa8b9b0ba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd4cb8901003040925t28ddcc5bmfce11dcfa8b9b0ba@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> On Thu, Mar 4, 2010 at 3:32 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * eranian@google.com <eranian@google.com> wrote:
> >
> >> This patch adds support for randomizing the sampling period. ??Randomization
> >> is very useful to mitigate the bias that exists with sampling. The random
> >> number generator does not need to be sophisticated. This patch uses the
> >> builtin random32() generator.
> >
> >> + ?? ?? if (width > 63 || attr->freq)
> >> + ?? ?? ?? ?? ?? ?? return -EINVAL;
> >
> > Why not for freq counters? Those are semi-randomized already, but it might
> > make sense to make them 'more' randomized in special circumstances. That would
> > also allow us to enable the randomization in perf top and perf record, by
> > default.
> >
>
> What's the goal of freq?
> Achieve and maintain the target interrupt/rate.
> In doing so, it has to adjust the period (not randomly).

No, the goal of auto-freq is to keep a steady average rate of sampling.

There is no requirement to keep it 'steady' - each sample comes with a 
specific weight.

> Randomization may prevent achieving the rate, or it may slow
> it down. What's the value add of that?

Why do you assume that the two are incompatible? We can randomize auto-freq 
and still have a perfectly stable average rate.

We know how long each sample takes so the result is precise, via 
PERF_SAMPLE_PERIOD.

> > Without that we'd have no immediate usecase and no way to ensure that this 
> > code works as intended.
>
> Why?
>
> With perf you also have fixed sampling period (-c option), you simply need 
> to express the fact you want it randomized.

-c is legacy in essence. The default is auto-freq and i doubt anyone uses -c 
anymore.

Why would they use it? Auto-freq is so much more convenient - it adapts to the 
workload and achieves a steady state of sampling, regardless of how frequent 
the hardware events are and regardless of how dynamic the workload itself is.

	Ingo
