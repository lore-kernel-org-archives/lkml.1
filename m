Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbZBRNqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbZBRNqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 08:46:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbZBRNqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 08:46:36 -0500
Received: from mx2.redhat.com ([66.187.237.31]:32896 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbZBRNqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 08:46:36 -0500
Message-ID: <499C1158.7020401@redhat.com>
Date: Wed, 18 Feb 2009 13:47:04 +0000
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] kvm mmu: alloc shadow pages with __GFP_ZERO
References: <1234962540-7131-1-git-send-email-joerg.roedel@amd.com> <1234962540-7131-4-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1234962540-7131-4-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> Not using __GFP_ZERO when allocating shadow pages triggers the
> assertion in the kvm_mmu_alloc_page() when MMU debugging is enabled.
>
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kvm/mmu.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index c90b4b2..d93ecec 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -301,7 +301,7 @@ static int mmu_topup_memory_cache_page(struct kvm_mmu_memory_cache *cache,
>  	if (cache->nobjs >= min)
>  		return 0;
>  	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
> -		page = alloc_page(GFP_KERNEL);
> +		page = alloc_page(GFP_KERNEL | __GFP_ZERO);
>  		if (!page)
>  			return -ENOMEM;
>  		set_page_private(page, 0);
>   

What is the warning?

Adding __GFP_ZERO here will cause us to clear the page twice, which is 
wasteful.


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

