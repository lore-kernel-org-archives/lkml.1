Return-Path: <linux-kernel-owner+w=401wt.eu-S1757693AbZCDTvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757693AbZCDTvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 14:51:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756563AbZCDTvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 14:51:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35926 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756578AbZCDTvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 14:51:21 -0500
Date: Wed, 4 Mar 2009 20:51:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: reserve exact size of mptable
Message-ID: <20090304195105.GB21488@elte.hu>
References: <49AE485B.8000902@kernel.org> <49AE4901.3090801@kernel.org> <49AE4922.605@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49AE4922.605@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> 
> Impact: cleanup
> 
> get the exact size for reserve_bootmem
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/kernel/mpparse.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/arch/x86/kernel/mpparse.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/mpparse.c
> +++ linux-2.6/arch/x86/kernel/mpparse.c
> @@ -716,10 +716,10 @@ static int __init smp_scan_config(unsign
>  
>  			if (!reserve)
>  				return 1;
> -			reserve_bootmem_generic(virt_to_phys(mpf), PAGE_SIZE,
> +			reserve_bootmem_generic(virt_to_phys(mpf), sizeof(*mpf),
>  					BOOTMEM_DEFAULT);
>  			if (mpf->physptr) {
> -				unsigned long size = PAGE_SIZE;
> +				unsigned long size = get_mpc_size(mpf->physptr);

I see we use get_mpc_size() here - that function can stay too.

	Ingo
