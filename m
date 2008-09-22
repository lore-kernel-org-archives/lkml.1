Return-Path: <linux-kernel-owner+w=401wt.eu-S1753476AbYIVPAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbYIVPAV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 11:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbYIVPAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 11:00:09 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:5506 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbYIVPAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 11:00:07 -0400
X-BigFish: VPS-30(zz1432R98dR1805M936fQzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K7LQZQ-03-PIH-01
Date: Mon, 22 Sep 2008 16:59:53 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AMD IOMMU: revert "x86, AMD IOMMU: honor iommu=off instead of amd_iommu=off"
Message-ID: <20080922145953.GB24392@amd.com>
References: <20080922223457W.fujita.tomonori@lab.ntt.co.jp> <20080922140749.GY24392@amd.com> <20080922144601.GA27956@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080922144601.GA27956@elte.hu>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 22 Sep 2008 14:59:53.0387 (UTC) FILETIME=[DE7F87B0:01C91CC3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 04:46:01PM +0200, Ingo Molnar wrote:
> 
> * Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > >     x86, AMD IOMMU: honor iommu=off instead of amd_iommu=off
> > > 
> > >     This patch removes the amd_iommu=off kernel parameter and honors 
> > >     the generic
> > > 
> > >     iommu=off parameter for the same purpose.
> > > 
> > > 
> > > The above commit is wrong.
> > 
> > It isn't. The user normally don't care about the type of IOMMU in the 
> > system. So disabling it with iommu=off is the right way. To achieve 
> > what you want its better to add iommu=gart and iommu=amd to the option 
> > parser. This will be consistent with Calgary and SWIOTLB too.
> 
> well, what matters in the end is to have a consistent set of exclusion 
> options:
> 
>   gart_iommu=off     # disable the GART (and only that one)
>   intel_iommu=off    # disable the Intel IOMMU (and only that one)
>   amd_iommu=off      # disable AMD-IOMMU (and only that one)
> 
> then there's the all-off option:
> 
>   iommu=off          # wildcard: disable all IOMMUs
> 
> [ whether iommu=off also disables the swiotlb is a detail. ]
> 
> and we could also do the inclusive options in addition:
> 
>   iommu=gart         # use the GART as the primary IOMMU [if available]
>   iommu=amd          # use the AMD-IOMMU as the primary IOMMU [if available]
>   iommu=intel        # use the Intel IOMMU [if available]
> 
> so could we please first agree on such a specific list of generic 
> options, and then implement them consistently, while keeping legacies 
> (the ones that matter) intact as well?

Ok, having $(type)_iommu=off in addition to iommu=$type is surely a good
thing.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

