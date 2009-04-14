Return-Path: <linux-kernel-owner+w=401wt.eu-S1755100AbZDNCHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbZDNCHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 22:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754745AbZDNCF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 22:05:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42009 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754677AbZDNCF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 22:05:57 -0400
Date: Tue, 14 Apr 2009 04:05:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
Message-ID: <20090414020544.GA3738@elte.hu>
References: <200904140159.n3E1x1K1014705@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904140159.n3E1x1K1014705@hera.kernel.org>
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


* Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:

> Gitweb:     http://git.kernel.org/linus/1c98aa7424ff163637d8321674ec58dee28152d4
> Commit:     1c98aa7424ff163637d8321674ec58dee28152d4
> Parent:     2e1c63b7ed36532b68f0eddd6a184d7ba1013b89
> Author:     Linus Torvalds <torvalds@linux-foundation.org>
> AuthorDate: Mon Apr 13 18:09:20 2009 -0700
> Committer:  Linus Torvalds <torvalds@linux-foundation.org>
> CommitDate: Mon Apr 13 18:09:20 2009 -0700
> 
>     Fix quilt merge error in acpi-cpufreq.c
>     
>     We ended up incorrectly using '&cur' instead of '&readin' in the
>     work_on_cpu() -> smp_call_function_single() transformation in commit
>     01599fca6758d2cd133e78f87426fc851c9ea725 ("cpufreq: use
>     smp_call_function_[single|many]() in acpi-cpufreq.c").
>     
>     Andrew explains:
>      "OK, the acpi tree went and had conflicting changes merged into it after
>       I'd written the patch and it appears that I incorrectly reverted part
>       of 18b2646fe3babeb40b34a0c1751e0bf5adfdc64c while fixing the resulting
>       rejects.
>     
>       Switching it to `readin' looks correct."
>     
>     Acked-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> ---
>  arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> index 3e3cd3d..837c2c4 100644
> --- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> +++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> @@ -277,7 +277,7 @@ static unsigned int get_measured_perf(struct cpufreq_policy *policy,
>  	unsigned int perf_percent;
>  	unsigned int retval;
>  
> -	if (smp_call_function_single(cpu, read_measured_perf_ctrs, &cur, 1))
> +	if (smp_call_function_single(cpu, read_measured_perf_ctrs, &readin, 1))
>  		return 0;

Ah, this might explain a few weird smp_processor_id() runtime 
warnings i got a few hours ago in that area of code (but didnt track 
it down at that time) when i updated to at around ~80a04d3.

(Never noticed the build warning - there's still too many of them.)

	Ingo
