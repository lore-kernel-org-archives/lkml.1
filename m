Return-Path: <linux-kernel-owner+w=401wt.eu-S1758689AbYD2N6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689AbYD2N6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 09:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754636AbYD2N6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 09:58:03 -0400
Received: from mis011-2.exch011.intermedia.net ([64.78.21.129]:3315 "EHLO
	mis011-2.exch011.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750981AbYD2N6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 09:58:01 -0400
From: Amit Shah <amit.shah@qumranet.com>
Organization: Qumranet Inc.
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] KVM PV Guest: Implement paravirtualized DMA
Date: Tue, 29 Apr 2008 19:29:17 +0530
User-Agent: KMail/1.9.9
Cc: kvm-devel@lists.sourceforge.net, chrisw@redhat.com, allen.m.kay@intel.com,
       linux-kernel@vger.kernel.org, gcosta@redhat.com, avi@qumranet.com,
       virtualization@lists.linux-foundation.org, BENAMI@il.ibm.com,
       "Muli Ben-Yehuda" <muli@il.ibm.com>
References: <1209465451-3758-1-git-send-email-amit.shah@qumranet.com> <1209465451-3758-4-git-send-email-amit.shah@qumranet.com> <87od7shjnv.fsf@basil.nowhere.org>
In-Reply-To: <87od7shjnv.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804291929.18733.amit.shah@qumranet.com>
X-OriginalArrivalTime: 29 Apr 2008 13:58:00.0314 (UTC) FILETIME=[09060DA0:01C8AA01]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 April 2008 19:01:32 Andi Kleen wrote:
> Amit Shah <amit.shah@qumranet.com> writes:

> > +const struct dma_mapping_ops *orig_dma_ops;
>
> I suspect real dma ops stacking will need some further thought than
> your simple hacks

Yes; that's something we're planning to do.

> Haven't read further, but to be honest the code doesn't seem to be anywhere
> near merging quality.

I'm basically using these patches to test the PCI passthrough functionality 
(by which we can assign host PCI devices to a guest OS via KVM). While other 
methods of handling DMA operations are being worked on (1-1 mapping of the 
guest in the host address space and virtualization-aware IOMMU translations), 
this patchset provides a quick way to check if things indeed work.

However, if some version of this patch can be useful upstream, I'll be glad to 
work on that. That said, as you point out, we need stackable dma ops as well 
as getting rid of the is_pv_device() function in dma_ops and that's something 
that can be done right away.

Thanks for the review!

Amit
