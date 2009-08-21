Return-Path: <linux-kernel-owner+w=401wt.eu-S932318AbZHUOjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318AbZHUOjw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 10:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932289AbZHUOjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 10:39:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46557 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932213AbZHUOjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 10:39:51 -0400
Date: Fri, 21 Aug 2009 16:39:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       yinghai@kernel.org
Subject: Re: [Patch] x86: fix a wrong argument of reserve_bootmem()
Message-ID: <20090821143918.GI11098@elte.hu>
References: <20090821083709.5098.52505.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090821083709.5098.52505.sendpatchset@localhost.localdomain>
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


* Amerigo Wang <amwang@redhat.com> wrote:

> This line looks suspicious, because if this is true, then the 
> 'flags' parameter of function reserve_bootmem_generic() will be 
> unused when !CONFIG_NUMA. I don't think this is what we want.
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Yinghai Lu <yinghai@kernel.org>
> 
> ---
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 6176fe8..ea56b8c 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -796,7 +796,7 @@ int __init reserve_bootmem_generic(unsigned long phys, unsigned long len,
>  		return ret;
>  
>  #else
> -	reserve_bootmem(phys, len, BOOTMEM_DEFAULT);
> +	reserve_bootmem(phys, len, flags);

Yes, this looks like an oversight. Since it only affected 32-bit 
NUMA materially, which is quite rare, it probably didnt matter that 
much but should be fixed ...

	Ingo
