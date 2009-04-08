Return-Path: <linux-kernel-owner+w=401wt.eu-S1756069AbZDHXCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbZDHXCU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 19:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755848AbZDHXBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 19:01:45 -0400
Received: from sh.osrg.net ([192.16.179.4]:41584 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755885AbZDHXBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 19:01:44 -0400
Date: Thu, 9 Apr 2009 08:01:18 +0900
To: jeremy@goop.org
Cc: fujita.tomonori@lab.ntt.co.jp, galak@kernel.crashing.org,
       hch@infradead.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       ian.campbell@citrix.com, beckyb@kernel.crashing.org
Subject: Re: [PATCH 4/7] swiotlb: Allow arch override of
 address_needs_mapping
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <49DD270A.6060506@goop.org>
References: <49DD1D6B.6030001@goop.org>
	<20090409071032M.fujita.tomonori@lab.ntt.co.jp>
	<49DD270A.6060506@goop.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090409080143C.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 09 Apr 2009 08:01:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Apr 2009 15:36:58 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> FUJITA Tomonori wrote:
> >> Some architectures need non-trivial bus<->phys conversion routines, etc, 
> >>     
> >
> > Only Xen needs such conversion for swiotlb.
> >   
> 
> Becky's patches of last week also added __weak annotations to 
> swiotlb_bus_to_virt, virt_to_bus and bus_to_phys; added the hwdev 
> parameter to swiotlb_bus_to_phys; and added a weak 
> swiotlb_arch_address_needs_mapping.  I assume that was needed because 
> powerpc needs non-trivial implementations for those functions.

Hmm, what she added are wrappers of virt_to_bus and bus_to_virt. We
can remove these and directly use virt_to_bus and bus_to_virt.

About __weak address_needs_mapping function, as I said, removing it
and using dma_map_ops is a proper solution.


> >> so either we can require it that all architectures wishing to use 
> >> swiotlb define these functions, or have weak default functions that can 
> >> be overridden by architectures where necessary.
> >>     
> >
> > Can you give an example? I don't think IA64, X86_64 or POWER (which
> > will use swiotlb) need any __weak functions. If you say other archs
> > could use swiotlb, please tell me how they need these __weak.
> >   
> 
> As I said, Becky's patches added hooks in many of the places we added 
> them for Xen.  I assume that's because powerpc needs them; I have not 
> seen the arch/powerpc side of those changes.
> 
>     J
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
