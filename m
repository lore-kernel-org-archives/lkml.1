Return-Path: <linux-kernel-owner+w=401wt.eu-S1754979AbYHMMvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979AbYHMMvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 08:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbYHMMvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 08:51:37 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:23566 "EHLO
	WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbYHMMvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 08:51:37 -0400
X-BigFish: VPS-24(zz1432R98dR1805M936fQ873fnzz10d3izzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0K5JIDG-04-021-01
Date: Wed, 13 Aug 2008 14:51:14 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       muli@il.ibm.com
Subject: Re: [PATCH 6/7] x86: cleanup dma_*_coherent functions
Message-ID: <20080813125114.GJ14993@amd.com>
References: <1218554657-16070-1-git-send-email-joerg.roedel@amd.com> <1218554657-16070-7-git-send-email-joerg.roedel@amd.com> <20080813093727Y.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080813093727Y.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 13 Aug 2008 12:51:14.0706 (UTC) FILETIME=[45484720:01C8FD43]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 09:45:51AM +0900, FUJITA Tomonori wrote:
> On Tue, 12 Aug 2008 17:24:16 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > All dma_ops implementations support the alloc_coherent and free_coherent
> > callbacks now. This allows a big simplification of the dma_alloc_coherent
> > function which is done with this patch. The dma_free_coherent functions is also
> > cleaned up and calls now the free_coherent callback of the dma_ops
> > implementation.
> > 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> >  arch/x86/kernel/pci-dma.c |  116 ++++-----------------------------------------
> >  1 files changed, 10 insertions(+), 106 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
> > index f704cb5..60fa80d 100644
> > --- a/arch/x86/kernel/pci-dma.c
> > +++ b/arch/x86/kernel/pci-dma.c
> 
> How about moving dma_free_coherent and dma_alloc_coherent to
> asm-x86/dma-mapping.h? It would be nice to have all the dma operations
> in one place.

Actually I thought about the other direction. Having these functions not
inlined should not add a big overhead but reduces kernel code size.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

