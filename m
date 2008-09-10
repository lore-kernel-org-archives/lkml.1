Return-Path: <linux-kernel-owner+w=401wt.eu-S1753600AbYIJMs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbYIJMs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 08:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751744AbYIJMss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 08:48:48 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:41314 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbYIJMss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 08:48:48 -0400
X-BigFish: VPS-24(zz1432R98dR1805M936fQ873fnzz10d3izzz32i6bh43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0K6ZCWM-03-6ZK-01
Date: Wed, 10 Sep 2008 14:48:22 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] x86: avoid unnecessary low zone allocation in AMD IOMMU's alloc_coherent
Message-ID: <20080910124822.GG6329@amd.com>
References: <20080910201851R.fujita.tomonori@lab.ntt.co.jp> <20080910120310.GD6329@amd.com> <20080910213155M.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080910213155M.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 10 Sep 2008 12:48:22.0395 (UTC) FILETIME=[8224B4B0:01C91343]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 09:38:11PM +0900, FUJITA Tomonori wrote:
> On Wed, 10 Sep 2008 14:03:10 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> > It needs a fix anyway and the
> > right solution here is to fall back to one of the software iommu
> > implementations. The stackable dma_ops patches I have currently in work
> > will do exactly that.
> 
> I'm not sure you need the stackable dma_ops support. Calgary IOMMU had
> the same problem and already solved it with dma_ops-per-device option.

We need stackable dma_ops anyway for paravirt IOMMU support in KVM. And
they will fix this issue too.

> > These flags are already removed in the dma_alloc_coherent function which
> > calls this one. Further I think in the case of a remapping IOMMU like
> 
> Not true about x86/tip/iommu. dma_alloc_coherent in dma-mapping.h does
> that so that swiotlb and pci-nommu don't need the gfp hack. Clearing
> the gfp flags is much simpler than setting up the flags correctly
> mainly because of the fallback device, setting up the flags is really
> difficult.

Yes, dma_alloc_coherent in dma-mapping.h clears the flags. And this
function also calls ops->alloc_coherent which points to the AMD IOMMUs
alloc_coherent function if the driver is in place.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

