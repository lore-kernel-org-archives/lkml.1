Return-Path: <linux-kernel-owner+w=401wt.eu-S1754538AbYE1Ktr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbYE1Ktr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 06:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbYE1Kti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 06:49:38 -0400
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:47815 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbYE1Kth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 06:49:37 -0400
To: amit.shah@qumranet.com
Cc: fujita.tomonori@lab.ntt.co.jp, muli@il.ibm.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       alexisb@us.ibm.com, andi@firstfloor.org, kvm@vger.kernel.org,
       avi@qumranet.com
Subject: Re: [PATCH v2 -mm 0/2] x86: per-device dma_mapping_ops
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <200805271124.09453.amit.shah@qumranet.com>
References: <200805271023.22574.amit.shah@qumranet.com>
	<20080527142406Y.fujita.tomonori@lab.ntt.co.jp>
	<200805271124.09453.amit.shah@qumranet.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080528191932Z.fujita.tomonori@lab.ntt.co.jp>
Date: Wed, 28 May 2008 19:19:32 +0900
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2008 11:24:08 +0530
Amit Shah <amit.shah@qumranet.com> wrote:

> On Tuesday 27 May 2008 10:54:06 FUJITA Tomonori wrote:
> 
> > > An example with per-device dma_ops and stacking will look like this:
> > >
> > > pvdma->hardware->nommu/swiotlb
> > >     ^             ^
> > >
> > >  e1000     rtl8139
> > >
> > > And this scheme is going to suit everyone, agreed?
> > >
> > > This is simple and doesn't need too many changes all around.
> >
> > Sorry, I'm not sure what this picture represents.
> 
> It meant to show just e1000 needs to go through the pvdma translations. 
> rtl8139 goes via the other iommus. e1000 also goes through the other iommus 
> (mainly if it's going to be the swiotlb that a guest might need).
> 
> > BTW, without pvdma, there is no need to hardware->nommu/swiotlb
> > stacking for IOMMUs like Calgary. Per-device dma_ops wor for them.
> 
> Hmm, ok. Then this argument doesn't count.
> 
> > > I was suggesting something more than this that can handle cases like an
> > > iommu wanting to have each device behind a bus to pass through it (it's
> > > still possible, but needs a per-device walk). Also, in the scenario
> > > depicted above, each device will start by pointing to the first iommu in
> > > the chain (pvdma in this case) and the iommu will then determine if that
> > > device needs to be passed via its translations.
> >
> > No, IOMMUs doesn't need to do that. We need to put a stacking
> > mechanism in dma-mapping.h. A stacking mechanism should not be visible
> > to IOMMUs.
> 
> OK; then just per-device dma_ops will work and for the pvdma case, we'll have 
> to have the stacking. Since this is a special case, any kind of generic APIs 
> shouldn't be needed as well.

I'm not sure what you mean exactly, but there might be other people
who want to use the dma_ops stacking though I'm not sure yet how they
use it:

http://lkml.org/lkml/2008/5/15/79


> What is the plan with this patch then? When do you plan to ask for mainline 
> merging?

Andrew already put this patchset in -mm. Unless someone comes with a
new reason against this patchset, it will be merged, I think.

BTW, Andrew, really sorry about several compile bugs due to the first
patch (changing dma_mapping_error) in this patchset. And thanks a lot
for fixing them.
