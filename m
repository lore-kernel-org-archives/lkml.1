Return-Path: <linux-kernel-owner+w=401wt.eu-S1759427AbZEFLpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427AbZEFLpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 07:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759144AbZEFLon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 07:44:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56045 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759137AbZEFLom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 07:44:42 -0400
Date: Wed, 6 May 2009 13:44:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: introduce cpuinfo->cpu_node_id to reflect
	topology of multi-node CPU
Message-ID: <20090506114423.GM25203@elte.hu>
References: <20090504173330.GF28728@alberich.amd.com> <20090504173450.GG28728@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090504173450.GG28728@alberich.amd.com>
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

> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---
>  arch/x86/include/asm/processor.h |    2 ++
>  arch/x86/kernel/cpu/common.c     |    2 ++
>  arch/x86/kernel/cpu/proc.c       |    1 +
>  arch/x86/kernel/smpboot.c        |    5 ++++-
>  4 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index 0b2fab0..b49d72b 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -106,6 +106,8 @@ struct cpuinfo_x86 {
>  	u16			booted_cores;
>  	/* Physical processor id: */
>  	u16			phys_proc_id;
> +	/* Node id in case of multi-node processor: */
> +	u16			cpu_node_id;

btw., do you have any plans to propagate this information into the 
scheduler domains tree?

Another level of domains, to cover the two internal nodes, would do 
the trick nicely and automatically. This would work even if the BIOS 
does not provide information and we have to go to lowlevel registers 
or CPUID to recover it.

This can be done even if there's no SRAT. (there's no SRAT because 
say due to interleaving there's no real NUMA structure of memory. 
But there's still CPU scheduling differences worth expressing.)

	Ingo
