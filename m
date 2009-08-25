Return-Path: <linux-kernel-owner+w=401wt.eu-S1755924AbZHYStI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbZHYStI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 14:49:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbZHYStH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 14:49:07 -0400
Received: from outbound-mail-144.bluehost.com ([67.222.38.34]:40663 "HELO
	outbound-mail-144.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754900AbZHYStG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 14:49:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=OWbS1ZdI37viftqzuoqDTpwKpKGVsCkWNuPa6Sc7+OMwPVY1l9xupacYAaBZz7gBLL+F94GzE0u4A1O5MAu6aG3TnXPxxvBxx38AScyubBf0T+8n9ph6CRz8yIcLznJz;
Date: Tue, 25 Aug 2009 11:48:59 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH] pci/intr_remapping: allocate irq_iommu on node -v3
Message-ID: <20090825114859.777be874@jbarnes-g45>
In-Reply-To: <4A84C21A.4000705@kernel.org>
References: <4A84C13E.5050606@kernel.org>
	<4A84C190.1060005@kernel.org>
	<4A84C21A.4000705@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, I assume you took these two?

Thanks,
Jesse

On Thu, 13 Aug 2009 18:47:06 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> 
> make it use node from irq_desc.
> v3: use irq_node
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  drivers/pci/intr_remapping.c |   14 +++-----------
>  1 file changed, 3 insertions(+), 11 deletions(-)
> 
> Index: linux-2.6/drivers/pci/intr_remapping.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/intr_remapping.c
> +++ linux-2.6/drivers/pci/intr_remapping.c
> @@ -55,15 +55,12 @@ static struct irq_2_iommu *irq_2_iommu(u
>  	return desc->irq_2_iommu;
>  }
>  
> -static struct irq_2_iommu *irq_2_iommu_alloc_node(unsigned int irq,
> int node) +static struct irq_2_iommu *irq_2_iommu_alloc(unsigned int
> irq) {
>  	struct irq_desc *desc;
>  	struct irq_2_iommu *irq_iommu;
>  
> -	/*
> -	 * alloc irq desc if not allocated already.
> -	 */
> -	desc = irq_to_desc_alloc_node(irq, node);
> +	desc = irq_to_desc(irq);
>  	if (!desc) {
>  		printk(KERN_INFO "can not get irq_desc for %d\n",
> irq); return NULL;
> @@ -72,16 +69,11 @@ static struct irq_2_iommu *irq_2_iommu_a
>  	irq_iommu = desc->irq_2_iommu;
>  
>  	if (!irq_iommu)
> -		desc->irq_2_iommu = get_one_free_irq_2_iommu(node);
> +		desc->irq_2_iommu =
> get_one_free_irq_2_iommu(irq_node(irq)); 
>  	return desc->irq_2_iommu;
>  }
>  
> -static struct irq_2_iommu *irq_2_iommu_alloc(unsigned int irq)
> -{
> -	return irq_2_iommu_alloc_node(irq, cpu_to_node(boot_cpu_id));
> -}
> -
>  #else /* !CONFIG_SPARSE_IRQ */
>  
>  static struct irq_2_iommu irq_2_iommuX[NR_IRQS];
> 


-- 
Jesse Barnes, Intel Open Source Technology Center
