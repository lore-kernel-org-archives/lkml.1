Return-Path: <linux-kernel-owner+w=401wt.eu-S1762066AbYD2NsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762066AbYD2NsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 09:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbYD2NsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 09:48:11 -0400
Received: from mis011-1.exch011.intermedia.net ([64.78.21.128]:33841 "EHLO
	mis011-1.exch011.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751170AbYD2NsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 09:48:10 -0400
From: Amit Shah <amit.shah@qumranet.com>
Organization: Qumranet Inc.
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] x86 DMA: Handle devices assigned to the guest by the host
Date: Tue, 29 Apr 2008 19:19:23 +0530
User-Agent: KMail/1.9.9
Cc: kvm-devel@lists.sourceforge.net, chrisw@redhat.com, allen.m.kay@intel.com,
       linux-kernel@vger.kernel.org, gcosta@redhat.com, avi@qumranet.com,
       virtualization@lists.linux-foundation.org, BENAMI@il.ibm.com,
       "Muli Ben-Yehuda" <muli@il.ibm.com>
References: <1209465451-3758-1-git-send-email-amit.shah@qumranet.com> <1209465451-3758-2-git-send-email-amit.shah@qumranet.com> <87wsmghkgg.fsf@basil.nowhere.org>
In-Reply-To: <87wsmghkgg.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804291919.23853.amit.shah@qumranet.com>
X-OriginalArrivalTime: 29 Apr 2008 13:48:06.0874 (UTC) FILETIME=[A74E4BA0:01C8A9FF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 April 2008 18:44:23 Andi Kleen wrote:
> Amit Shah <amit.shah@qumranet.com> writes:
> > diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
> > index 388b113..678cafb 100644
> > --- a/arch/x86/kernel/pci-dma.c
> > +++ b/arch/x86/kernel/pci-dma.c
> > @@ -443,6 +443,17 @@ dma_alloc_coherent(struct device *dev, size_t size,
> > dma_addr_t *dma_handle, memset(memory, 0, size);
> >  		if (!mmu) {
> >  			*dma_handle = bus;
> > +			if (unlikely(dma_ops->is_pv_device) &&
> > +			    unlikely(dma_ops->is_pv_device(dev, dev->bus_id))) {
>
> First double unlikely in a condition is useless. Just drop them.
>
> And then ->is_xyz() in a generic vops interface is about as ugly
> and non generic as you can get. dma_alloc_coherent is not performance
> critical, so you should rather change the interface that ->alloc_coherent
> is always called and the other handlers handle the !mmu case correctly.
> In fact they need that already I guess (e.g. on DMAR there is not really
> a nommu case)

This point came up the last time I sent out the patch; we should do this as 
well as implement stackable dma_ops (the need for that is evident in the next 
patch).

Thanks for the observation; this should be the next step.

Amit.
