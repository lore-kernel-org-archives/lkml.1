Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752270AbYLQUxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270AbYLQUxk (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 15:53:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbYLQUxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 15:53:30 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:54627 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbYLQUx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 15:53:29 -0500
X-BigFish: VPS-29(zz1432R98dR1805M936fOzzzzz32i6bh43j62h)
X-FB-SS: 5,
X-WSS-ID: 0KC1GOD-04-BU6-01
Date: Wed, 17 Dec 2008 21:53:08 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: iommu@lists.linux-foundation.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 gart: don't complain if no AMD GART found
Message-ID: <20081217205308.GA11528@amd.com>
References: <20081217195234.13603.96737.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081217195234.13603.96737.stgit@bob.kio>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 17 Dec 2008 20:53:08.0249 (UTC) FILETIME=[77255090:01C96089]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 12:52:34PM -0700, Bjorn Helgaas wrote:
> It's perfectly normal for no AMD GART to be present, e.g., if you have
> Intel CPUs.  None of the other iommu_init() functions makes noise when
> it finds nothing.

True, there are even 64bit AMD processors without GART.

Ingo,

do you want to pick this patch up or should I do it?

> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Acked-by: Joerg Roedel <joerg.roedel@amd.com>

> ---
>  arch/x86/kernel/pci-gart_64.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
> index ba7ad83..a35eaa3 100644
> --- a/arch/x86/kernel/pci-gart_64.c
> +++ b/arch/x86/kernel/pci-gart_64.c
> @@ -745,10 +745,8 @@ void __init gart_iommu_init(void)
>  	unsigned long scratch;
>  	long i;
>  
> -	if (cache_k8_northbridges() < 0 || num_k8_northbridges == 0) {
> -		printk(KERN_INFO "PCI-GART: No AMD GART found.\n");
> +	if (cache_k8_northbridges() < 0 || num_k8_northbridges == 0)
>  		return;
> -	}
>  
>  #ifndef CONFIG_AGP_AMD64
>  	no_agp = 1;
> 
> 

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

