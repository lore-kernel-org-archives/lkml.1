Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbZF3KJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbZF3KJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 06:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbZF3KIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 06:08:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56798 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295AbZF3KIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 06:08:53 -0400
Date: Tue, 30 Jun 2009 12:08:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf stat: define CHECK_ATTRS for easy attrs
	checking
Message-ID: <20090630100835.GE6942@elte.hu>
References: <1246274348.3018.3.camel@hpdv5.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246274348.3018.3.camel@hpdv5.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0014]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> CHECK_ATTRS is useful :
>  1. for multiple attrs checking
>  2. avoid repetition of PERF_TYPE_ and PERF_COUNT_ and save space
>  3. avoids line breakage
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  tools/perf/builtin-stat.c |   18 ++++++++----------
>  1 files changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> index 3e5ea4e..6231b39 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -96,6 +96,10 @@ static u64			walltime_nsecs_noise;
>  static u64			runtime_cycles_avg;
>  static u64			runtime_cycles_noise;
>  
> +#define CHECK_ATTRS(t, c, counter)			\
> +	(attrs[counter].type == PERF_TYPE_##t &&	\
> +	 attrs[counter].config == PERF_COUNT_##c)

looks good except that the name should be something like 
MATCH_EVENT() not CHECK_ATTRS().

	Ingo
