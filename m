Return-Path: <linux-kernel-owner+w=401wt.eu-S1755927AbZDHXiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbZDHXiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 19:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755552AbZDHXiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 19:38:03 -0400
Received: from sh.osrg.net ([192.16.179.4]:60291 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755502AbZDHXiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 19:38:01 -0400
Date: Thu, 9 Apr 2009 08:37:29 +0900
To: jeremy@goop.org
Cc: fujita.tomonori@lab.ntt.co.jp, galak@kernel.crashing.org,
       hch@infradead.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       ian.campbell@citrix.com, beckyb@kernel.crashing.org
Subject: Re: [PATCH 4/7] swiotlb: Allow arch override of
 address_needs_mapping
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <49DD3041.8020808@goop.org>
References: <49DD270A.6060506@goop.org>
	<20090409080143C.fujita.tomonori@lab.ntt.co.jp>
	<49DD3041.8020808@goop.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090409083752I.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 09 Apr 2009 08:37:29 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Apr 2009 16:16:17 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> FUJITA Tomonori wrote:
> >> Becky's patches of last week also added __weak annotations to 
> >> swiotlb_bus_to_virt, virt_to_bus and bus_to_phys; added the hwdev 
> >> parameter to swiotlb_bus_to_phys; and added a weak 
> >> swiotlb_arch_address_needs_mapping.  I assume that was needed because 
> >> powerpc needs non-trivial implementations for those functions.
> >>     
> >
> > Hmm, what she added are wrappers of virt_to_bus and bus_to_virt. We
> > can remove these and directly use virt_to_bus and bus_to_virt.
> >   
> 
> In general those interfaces are deprecated.  Are we un-deprecating 
> them?  Or do you mean adding virt<->bus to dma_ops?

Hmm, these interfaces are wrong for drivers surely because they can't
handle dma mapping properly. However, they are exactly what swiotlb
needs (swiotlb doesn't need to care about dma mapping). Until 2.6.28,
swiotlb has used them. They are with IA64, X86_64 and PPC_32, I think.


> > About __weak address_needs_mapping function, as I said, removing it
> > and using dma_map_ops is a proper solution.
> >   
> 
> Fine.  Could swiotlb_alloc() just call dma_alloc_coherent() too?

I'm not sure what you mean. And I don't think ppc wants swiotlb_alloc.
