Return-Path: <linux-kernel-owner+w=401wt.eu-S1755811AbZKDM3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811AbZKDM3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 07:29:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755784AbZKDM3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 07:29:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47433 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755559AbZKDM27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 07:28:59 -0500
Date: Wed, 4 Nov 2009 13:28:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>, Joerg Roedel <joerg.roedel@amd.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Woodhouse <dwmw2@infradead.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       athena@fftw.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix iommu=nodac parameter handling
Message-ID: <20091104122827.GB11968@elte.hu>
References: <4AE5B52A.4050408@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE5B52A.4050408@kernel.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> nodac should forbid dac instead of enabling it.  Fix it.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Matteo Frigo <athena@fftw.org>
> Cc: stable@kernel.org
> ---
> This was posted several months ago in a two patch series.  The second
> one was rejected by Alan and with that the first one got lost too
> although it's an apparent bug fix.  Matteo hit this bug recently and
> reminded me about this patch.  So, regenerated and reposting.
> 
> Thanks.
> 
>  arch/x86/kernel/pci-dma.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
> index d20009b..8cf3996 100644
> --- a/arch/x86/kernel/pci-dma.c
> +++ b/arch/x86/kernel/pci-dma.c
> @@ -216,7 +216,7 @@ static __init int iommu_setup(char *p)
>  		if (!strncmp(p, "allowdac", 8))
>  			forbid_dac = 0;
>  		if (!strncmp(p, "nodac", 5))
> -			forbid_dac = -1;
> +			forbid_dac = 1;
>  		if (!strncmp(p, "usedac", 6)) {
>  			forbid_dac = -1;
>  			return 1;

(Cc:-ed more interested parties.)

	Ingo
