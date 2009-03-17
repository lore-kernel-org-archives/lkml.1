Return-Path: <linux-kernel-owner+w=401wt.eu-S1760875AbZCQMIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760875AbZCQMIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 08:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754914AbZCQMIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 08:08:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753268AbZCQMIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 08:08:12 -0400
Date: Tue, 17 Mar 2009 08:08:08 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: David Miller <davem@davemloft.net>
cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crash with /proc/iomem on sparc64
In-Reply-To: <Pine.LNX.4.64.0903170758060.24107@hs20-bc2-1.build.redhat.com>
Message-ID: <Pine.LNX.4.64.0903170807440.25109@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0903170758060.24107@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Mar 2009, Mikulas Patocka wrote:

> Hi
> 
> When you compile kernel on Sparc64 with heap memory checking and type
> "cat /proc/iomem", you get a crash, because pointers in struct resource 
> are uninitialized.
> 
> Most code fills struct resource with zeros, so I assume that it is 
> responsibility of the caller of request_resource to initialized it, not 
> the responsibility of request_resource functuion.
> 
> After 2.6.29 is out, there could be a check for uninitialized fields added 
> to request_resource to avoid crashes like this.
> 
> Mikulas

I forgot to add:

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

> ---
>  arch/sparc/kernel/pci_common.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.29-rc8-devel/arch/sparc/kernel/pci_common.c
> ===================================================================
> --- linux-2.6.29-rc8-devel.orig/arch/sparc/kernel/pci_common.c	2009-03-17 12:49:51.000000000 +0100
> +++ linux-2.6.29-rc8-devel/arch/sparc/kernel/pci_common.c	2009-03-17 12:50:16.000000000 +0100
> @@ -368,7 +368,7 @@ static void pci_register_iommu_region(st
>  	const u32 *vdma = of_get_property(pbm->op->node, "virtual-dma", NULL);
>  
>  	if (vdma) {
> -		struct resource *rp = kmalloc(sizeof(*rp), GFP_KERNEL);
> +		struct resource *rp = kzalloc(sizeof(*rp), GFP_KERNEL);
>  
>  		if (!rp) {
>  			prom_printf("Cannot allocate IOMMU resource.\n");
> 
