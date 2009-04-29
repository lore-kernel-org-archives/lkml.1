Return-Path: <linux-kernel-owner+w=401wt.eu-S1754192AbZD2LYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbZD2LYs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 07:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751853AbZD2LYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 07:24:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55648 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099AbZD2LYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 07:24:37 -0400
Date: Wed, 29 Apr 2009 13:24:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 18/29] x86/perfcounters: rename cpuc->active_mask
Message-ID: <20090429112423.GA8813@elte.hu>
References: <1241002046-8832-1-git-send-email-robert.richter@amd.com> <1241002046-8832-19-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241002046-8832-19-git-send-email-robert.richter@amd.com>
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


* Robert Richter <robert.richter@amd.com> wrote:

> This is to have a consistent naming scheme with cpuc->used.
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  arch/x86/kernel/cpu/perf_counter.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
> index 3f3ae47..9ec51a6 100644
> --- a/arch/x86/kernel/cpu/perf_counter.c
> +++ b/arch/x86/kernel/cpu/perf_counter.c
> @@ -29,9 +29,9 @@ static u64 perf_counter_mask __read_mostly;
>  struct cpu_hw_counters {
>  	struct perf_counter	*counters[X86_PMC_IDX_MAX];
>  	unsigned long		used[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
> +	unsigned long		active[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
>  	unsigned long		interrupts;
>  	u64			throttle_ctrl;
> -	unsigned long		active_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
>  	int			enabled;

better would be to change ->used to ->used_mask. That makes it sure 
nobody does this typo:

	if (cpuc->used)

it's a lot harder to typo this:

	if (cpuc->used_mask)

	Ingo
