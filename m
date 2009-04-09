Return-Path: <linux-kernel-owner+w=401wt.eu-S1753027AbZDIKTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027AbZDIKTd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 06:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752736AbZDIKTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 06:19:21 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:52786 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752257AbZDIKTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 06:19:20 -0400
X-Sasl-enc: diQtBKS6l+LxDFEzvp/3wA0yOyTUv7lgUj+ALSlOAqMq 1239272359
Message-ID: <49DDCBA3.6020208@fastmail.fm>
Date: Thu, 09 Apr 2009 11:19:15 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: jeff@garzik.org, kernel-janitors@vger.kernel.org, jbarnes@virtuousgeek.org
Subject: Re: [PATCH 38/56] pci: Remove void casts
References: <> <1239189748-11703-24-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-25-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-26-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-27-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-28-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-29-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-30-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-31-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-32-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-33-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-34-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-35-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-36-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-37-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-38-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-39-git-send-email-jwjstone@fastmail.fm>
In-Reply-To: <1239189748-11703-39-git-send-email-jwjstone@fastmail.fm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added maintainer CC]
Jack Stone wrote:
> Remove uneeded void casts
>
> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
> ---
>  drivers/pci/intel-iommu.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
> index fb3a3f3..c0dd267 100644
> --- a/drivers/pci/intel-iommu.c
> +++ b/drivers/pci/intel-iommu.c
> @@ -519,7 +519,7 @@ static struct context_entry * device_to_context_entry(struct intel_iommu *iommu,
>  	root = &iommu->root_entry[bus];
>  	context = get_context_addr_from_root(root);
>  	if (!context) {
> -		context = (struct context_entry *)alloc_pgtable_page();
> +		context = alloc_pgtable_page();
>  		if (!context) {
>  			spin_unlock_irqrestore(&iommu->lock, flags);
>  			return NULL;
> @@ -789,7 +789,7 @@ static int iommu_alloc_root_entry(struct intel_iommu *iommu)
>  	struct root_entry *root;
>  	unsigned long flags;
>  
> -	root = (struct root_entry *)alloc_pgtable_page();
> +	root = alloc_pgtable_page();
>  	if (!root)
>  		return -ENOMEM;
>  
> @@ -1290,7 +1290,7 @@ static int domain_init(struct dmar_domain *domain, int guest_width)
>  	domain->iommu_count = 1;
>  
>  	/* always allocate the top pgd */
> -	domain->pgd = (struct dma_pte *)alloc_pgtable_page();
> +	domain->pgd = alloc_pgtable_page();
>  	if (!domain->pgd)
>  		return -ENOMEM;
>  	__iommu_flush_cache(iommu, domain->pgd, PAGE_SIZE);
> @@ -3019,7 +3019,7 @@ static int vm_domain_init(struct dmar_domain *domain, int guest_width)
>  	domain->max_addr = 0;
>  
>  	/* always allocate the top pgd */
> -	domain->pgd = (struct dma_pte *)alloc_pgtable_page();
> +	domain->pgd = alloc_pgtable_page();
>  	if (!domain->pgd)
>  		return -ENOMEM;
>  	domain_flush_cache(domain, domain->pgd, PAGE_SIZE);
>   

