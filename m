Return-Path: <linux-kernel-owner+w=401wt.eu-S932145AbYHUPT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145AbYHUPT3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 11:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759980AbYHUPSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 11:18:42 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:10214 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760623AbYHUPSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 11:18:40 -0400
X-BigFish: VPS-29(zz1418M1432R98dR1805M936fQ873fnzz10d3izzz32i6bh43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0K5YIIE-03-MBU-01
Date: Thu, 21 Aug 2008 17:17:24 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       muli@il.ibm.com
Subject: Re: [PATCH 1/8] x86: add alloc_coherent dma_ops callback to GART driver
Message-ID: <20080821151724.GB3189@amd.com>
References: <1219156366-32498-1-git-send-email-joerg.roedel@amd.com> <1219156366-32498-2-git-send-email-joerg.roedel@amd.com> <20080821225038E.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080821225038E.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 21 Aug 2008 15:17:25.0423 (UTC) FILETIME=[04577BF0:01C903A1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 11:16:49PM +0900, FUJITA Tomonori wrote:
> On Tue, 19 Aug 2008 16:32:39 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> >  arch/x86/kernel/pci-gart_64.c |   21 +++++++++++++++++++++
> >  1 files changed, 21 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
> > index 4d8efb0..44a75a6 100644
> > --- a/arch/x86/kernel/pci-gart_64.c
> > +++ b/arch/x86/kernel/pci-gart_64.c
> > @@ -506,6 +506,26 @@ error:
> >  	return 0;
> >  }
> >  
> > +/* allocate and map a coherent mapping */
> > +static void *
> > +gart_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_addr,
> > +		    gfp_t flag)
> > +{
> > +	void *vaddr;
> > +
> > +	vaddr = (void *)__get_free_pages(flag, get_order(size));
> > +	if (!vaddr)
> > +		return NULL;
> > +
> > +	*dma_addr = gart_map_single(dev, __pa(vaddr), size, DMA_BIDIRECTIONAL);
> > +	if (*dma_addr != bad_dma_address)
> > +		return vaddr;
> 
> I'm not sure a rule is documented or not, but I think that IOMMUs
> return zeroed memory wrt dma_alloc_coherent. The current pci-dma.c
> does, so I think that it would be better to keep the current behavior.

Ok, true. I will send and update patch to add this. Thanks.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

