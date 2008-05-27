Return-Path: <linux-kernel-owner+w=401wt.eu-S1756581AbYE0Fvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581AbYE0Fvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 01:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754110AbYE0Fvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 01:51:43 -0400
Received: from mis011-2.exch011.intermedia.net ([64.78.21.129]:28440 "EHLO
	mis011-2.exch011.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753768AbYE0Fvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 01:51:42 -0400
From: Amit Shah <amit.shah@qumranet.com>
Organization: Qumranet Inc.
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH v2 -mm 0/2] x86: per-device dma_mapping_ops
Date: Tue, 27 May 2008 11:24:08 +0530
User-Agent: KMail/1.9.9
Cc: muli@il.ibm.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       alexisb@us.ibm.com, andi@firstfloor.org, kvm@vger.kernel.org,
       avi@qumranet.com
References: <200805262214.35397.amit.shah@qumranet.com> <200805271023.22574.amit.shah@qumranet.com> <20080527142406Y.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080527142406Y.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805271124.09453.amit.shah@qumranet.com>
X-OriginalArrivalTime: 27 May 2008 05:51:41.0452 (UTC) FILETIME=[BCA20CC0:01C8BFBD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 May 2008 10:54:06 FUJITA Tomonori wrote:

> > An example with per-device dma_ops and stacking will look like this:
> >
> > pvdma->hardware->nommu/swiotlb
> >     ^             ^
> >
> >  e1000     rtl8139
> >
> > And this scheme is going to suit everyone, agreed?
> >
> > This is simple and doesn't need too many changes all around.
>
> Sorry, I'm not sure what this picture represents.

It meant to show just e1000 needs to go through the pvdma translations. 
rtl8139 goes via the other iommus. e1000 also goes through the other iommus 
(mainly if it's going to be the swiotlb that a guest might need).

> BTW, without pvdma, there is no need to hardware->nommu/swiotlb
> stacking for IOMMUs like Calgary. Per-device dma_ops wor for them.

Hmm, ok. Then this argument doesn't count.

> > I was suggesting something more than this that can handle cases like an
> > iommu wanting to have each device behind a bus to pass through it (it's
> > still possible, but needs a per-device walk). Also, in the scenario
> > depicted above, each device will start by pointing to the first iommu in
> > the chain (pvdma in this case) and the iommu will then determine if that
> > device needs to be passed via its translations.
>
> No, IOMMUs doesn't need to do that. We need to put a stacking
> mechanism in dma-mapping.h. A stacking mechanism should not be visible
> to IOMMUs.

OK; then just per-device dma_ops will work and for the pvdma case, we'll have 
to have the stacking. Since this is a special case, any kind of generic APIs 
shouldn't be needed as well.

What is the plan with this patch then? When do you plan to ask for mainline 
merging?
