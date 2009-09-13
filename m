Return-Path: <linux-kernel-owner+w=401wt.eu-S1754723AbZIMPr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbZIMPr4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 11:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754185AbZIMPrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 11:47:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53025 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753294AbZIMPrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 11:47:51 -0400
Date: Sun, 13 Sep 2009 17:47:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Serge Belyshev <belyshev@depni.sinp.msu.ru>
Cc: Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: Epic regression in throughput since v2.6.23
Message-ID: <20090913154744.GA27066@elte.hu>
References: <20090906205952.GA6516@elte.hu> <87hbvdiogq.fsf@depni.sinp.msu.ru> <873a6xdqwq.fsf@depni.sinp.msu.ru> <20090909155223.GA12065@elte.hu> <87my53vo6d.fsf@depni.sinp.msu.ru> <20090910065306.GB3920@elte.hu> <87ljkm9yew.fsf@depni.sinp.msu.ru> <20090911061024.GA27833@elte.hu> <87iqfmx3tr.fsf@depni.sinp.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87iqfmx3tr.fsf@depni.sinp.msu.ru>
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


* Serge Belyshev <belyshev@depni.sinp.msu.ru> wrote:

> Note that the disabling NEW_FAIR_SLEEPERS doesn't fix 3% 
> regression from v2.6.23, but instead makes "make -j4" runtime 
> another 2% worse (27.05 -> 27.72).

ok - thanks for the numbers, will have a look.

> ---
>  tools/perf/builtin-stat.c |   18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)

> +	// quick ugly hack: if a "--" appears in the command, treat is as
> +	// a delimiter and use remaining part as a "cleanup command",
> +	// not affecting performance counters.
> +	cleanup = cleanup_argc = 0;
> +	for (j = 1; j < (argc-1); j ++) {
> +		if (!strcmp (argv[j], "--")) {
> +			cleanup = j + 1;
> +			cleanup_argc = argc - j - 1;
> +			argv[j] = NULL;
> +			argc = j;
> +		}
> +	}

Nice feature!

How about doing it a bit cleaner, as '--repeat-prepare' and 
'--repeat-cleanup' options, to allow both pre-repeat and post-repeat 
cleanup ops to be done outside of the measured period?

	Ingo
