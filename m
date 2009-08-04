Return-Path: <linux-kernel-owner+w=401wt.eu-S932953AbZHDRXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953AbZHDRXg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 13:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932896AbZHDRXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 13:23:35 -0400
Received: from mga14.intel.com ([143.182.124.37]:47252 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933094AbZHDRXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 13:23:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,322,1246863600"; 
   d="scan'208";a="172210557"
Subject: Re: [PATCH] pci/intr_remapping: allocate irq_iommu on node
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
In-Reply-To: <4A785C17.3030104@kernel.org>
References: <4A785C17.3030104@kernel.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 04 Aug 2009 10:19:28 -0700
Message-Id: <1249406368.27006.10789.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-04 at 09:04 -0700, Yinghai Lu wrote:
> make it use node from irq_desc.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  drivers/pci/intr_remapping.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/drivers/pci/intr_remapping.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/intr_remapping.c
> +++ linux-2.6/drivers/pci/intr_remapping.c
> @@ -201,7 +201,7 @@ int alloc_irte(struct intel_iommu *iommu
>  	for (i = index; i < index + count; i++)
>  		table->base[i].present = 1;
>  
> -	irq_iommu = irq_2_iommu_alloc(irq);
> +	irq_iommu = irq_2_iommu_alloc_node(irq, irq_to_desc(irq)->node);

As far as I can see, this node will always be boot_cpu_id's node. We
allocate the IRTE at the time of the create_irq() and at that time,
desc->node will always be of the boot_cpu_id's.

Can you please elaborate when this node will be different to make this
an effective patch?

thanks,
suresh

