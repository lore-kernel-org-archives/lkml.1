Return-Path: <linux-kernel-owner+w=401wt.eu-S1759073AbZD2LW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759073AbZD2LW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 07:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757387AbZD2LWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 07:22:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55880 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754930AbZD2LWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 07:22:09 -0400
Date: Wed, 29 Apr 2009 13:21:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/29] x86: perfcounter: remove
	X86_FEATURE_ARCH_PERFMON flag for AMD cpus
Message-ID: <20090429112150.GB8298@elte.hu>
References: <1241002046-8832-1-git-send-email-robert.richter@amd.com> <1241002046-8832-2-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241002046-8832-2-git-send-email-robert.richter@amd.com>
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

> X86_FEATURE_ARCH_PERFMON is an Intel hardware feature that does not
> work on AMD CPUs. The flag is now only used in Intel specific code
> (especially initialization).
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  arch/x86/kernel/cpu/amd.c          |    4 ----
>  arch/x86/kernel/cpu/perf_counter.c |    6 +++---
>  2 files changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index fd69c51..7e4a459 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -420,10 +420,6 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
>  	if (c->x86 >= 6)
>  		set_cpu_cap(c, X86_FEATURE_FXSAVE_LEAK);
>  
> -	/* Enable Performance counter for K7 and later */
> -	if (c->x86 > 6 && c->x86 <= 0x11)
> -		set_cpu_cap(c, X86_FEATURE_ARCH_PERFMON);

might make sense to introduce a 'virtual CPU ID flag' for it like we 
do it in other cases, to signal that we support perfcounters on this 
CPU.

	Ingo
