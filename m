Return-Path: <linux-kernel-owner+w=401wt.eu-S1754893AbYIKNhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbYIKNhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 09:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbYIKNh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 09:37:28 -0400
Received: from sh.osrg.net ([192.16.179.4]:35208 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041AbYIKNh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 09:37:27 -0400
Date: Thu, 11 Sep 2008 22:36:59 +0900
To: joerg.roedel@amd.com
Cc: fujita.tomonori@lab.ntt.co.jp, joro@8bytes.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] x86: avoid unnecessary low zone allocation in AMD
 IOMMU's alloc_coherent
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080911091000.GI24392@amd.com>
References: <20080910143818.GA31506@8bytes.org>
	<20080910234510S.fujita.tomonori@lab.ntt.co.jp>
	<20080911091000.GI24392@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080911223647D.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2008 11:10:00 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Wed, Sep 10, 2008 at 11:45:34PM +0900, FUJITA Tomonori wrote:
> > On Wed, 10 Sep 2008 16:38:18 +0200
> > Joerg Roedel <joro@8bytes.org> wrote:
> > > Ok, thats a valid point. I queue your patch with the AMD IOMMU updates
> > > for 2.6.28. Thanks.
> > 
> > Ingo already has queued it his tree, I think.
> 
> I asked Ingo to remove it from his tree to avoid merge conflicts with
> updates I am currently preparing. Here is the patch I queued into my
> 2.6.28 update chain.
> 
> Joerg
> 
> ===
> commit 42a7fa8d8a7f1680cba76e4824dba30bfd1c9d70
> Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Date:   Wed Sep 10 20:19:40 2008 +0900
> 
>     x86: avoid unnecessary low zone allocation in AMD IOMMU's alloc_coherent
>     
>     x86's common alloc_coherent (dma_alloc_coherent in dma-mapping.h) sets
>     up the gfp flag according to the device dma_mask but AMD IOMMU doesn't
>     need it for devices that the IOMMU can do virtual mappings for. This
>     patch avoids unnecessary low zone allocation.
>     
>     Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>     Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> 
> diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
> index ae38b24..09261dc 100644
> --- a/arch/x86/kernel/amd_iommu.c
> +++ b/arch/x86/kernel/amd_iommu.c

I see, thanks.
