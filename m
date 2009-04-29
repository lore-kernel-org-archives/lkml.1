Return-Path: <linux-kernel-owner+w=401wt.eu-S1753825AbZD2NRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbZD2NRl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759987AbZD2NKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:10:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44034 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759927AbZD2NKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:10:47 -0400
Date: Wed, 29 Apr 2009 15:10:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, robert.richter@amd.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter, x86: rename
	cpuc->active_mask
Message-ID: <20090429131029.GA24485@elte.hu>
References: <1241002046-8832-19-git-send-email-robert.richter@amd.com> <tip-93904966934193204ad08e951f806d5631c29eb3@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-93904966934193204ad08e951f806d5631c29eb3@git.kernel.org>
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


* tip-bot for Robert Richter <robert.richter@amd.com> wrote:

> Commit-ID:  93904966934193204ad08e951f806d5631c29eb3
> Gitweb:     http://git.kernel.org/tip/93904966934193204ad08e951f806d5631c29eb3
> Author:     Robert Richter <robert.richter@amd.com>
> AuthorDate: Wed, 29 Apr 2009 12:47:15 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed, 29 Apr 2009 14:51:09 +0200
> 
> perf_counter, x86: rename cpuc->active_mask
> 
> This is to have a consistent naming scheme with cpuc->used.
> 
> [ Impact: cleanup ]
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <1241002046-8832-19-git-send-email-robert.richter@amd.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
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
>  };

Note, i applied this because later patches had dependencies - but 
could you please send a followup patch that renames both ->used and 
->active to ->used_mask and ->active_mask?

Thanks,

	Ingo
