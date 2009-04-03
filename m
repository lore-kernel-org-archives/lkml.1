Return-Path: <linux-kernel-owner+w=401wt.eu-S936583AbZDCQQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936583AbZDCQQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935290AbZDCP7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:59:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57696 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935263AbZDCP7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:59:41 -0400
Date: Fri, 3 Apr 2009 17:59:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Mark Langsdorf <mark.langsdorf@amd.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [PATCH] x86: cacheinfo: fix build error in
	cache_disable
Message-ID: <20090403155920.GA18237@elte.hu>
References: <20090402100756.GN5740@alberich.amd.com> <20090402103008.GA10828@elte.hu> <20090403160721.GC6466@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090403160721.GC6466@alberich.amd.com>
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


* Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> Impact: fix build error
> 
> Commit 45ca863 (x86, cpu: conform L3 Cache Index Disable to Linux standard)
> introduced following build error with CONFIG_K8_NB=n
>   ...
>   arch/x86/mm/built-in.o:(.bss+0x5c0): multiple definition of `k8_northbridges'
>   arch/x86/kernel/built-in.o:(.bss+0x18c8): first defined here
>   ...
> 
> The patch deactivates cache_disable functionality for kernels with
> CONFIG_K8_NB=n.
> 
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---
>  arch/x86/include/asm/k8.h             |    4 ----
>  arch/x86/kernel/cpu/intel_cacheinfo.c |   19 ++++++++++++++++---
>  2 files changed, 16 insertions(+), 7 deletions(-)
> 
> The real fix would be to enable cache index disable functionality also
> for kernels with CONFIG_K8_NB=n but I don't have time to provide such
> a patch today.
> 
> Ingo, please either apply this (compile tested) patch or revert Mark's
> patch to avoid further blocking of tip/x86/cpu branch.
> 
> 
> Thanks,
> 
> Andreas
> 
> 
> diff --git a/arch/x86/include/asm/k8.h b/arch/x86/include/asm/k8.h
> index 0d619c3..54c8cc5 100644
> --- a/arch/x86/include/asm/k8.h
> +++ b/arch/x86/include/asm/k8.h
> @@ -6,11 +6,7 @@
>  extern struct pci_device_id k8_nb_ids[];
>  
>  extern int early_is_k8_nb(u32 value);
> -#ifdef CONFIG_K8_NB
>  extern struct pci_dev **k8_northbridges;
> -#else
> -struct pci_dev **k8_northbridges;
> -#endif

hm, what's wrong with the node_to_k8_dev() suggestion i made?

That would be a pretty clean interface, private to k8.c - and it 
would map a 'return NULL' inline function in the !CONFIG_K8_NB case.

	Ingo
