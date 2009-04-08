Return-Path: <linux-kernel-owner+w=401wt.eu-S1756551AbZDHXSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551AbZDHXSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 19:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754565AbZDHXR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 19:17:56 -0400
Received: from gw.goop.org ([64.81.55.164]:36400 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371AbZDHXRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 19:17:55 -0400
Message-ID: <49DD3041.8020808@goop.org>
Date: Wed, 08 Apr 2009 16:16:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: galak@kernel.crashing.org, hch@infradead.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, ian.campbell@citrix.com, beckyb@kernel.crashing.org
Subject: Re: [PATCH 4/7] swiotlb: Allow arch override of address_needs_mapping
References: <49DD1D6B.6030001@goop.org>	<20090409071032M.fujita.tomonori@lab.ntt.co.jp>	<49DD270A.6060506@goop.org> <20090409080143C.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090409080143C.fujita.tomonori@lab.ntt.co.jp>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
>> Becky's patches of last week also added __weak annotations to 
>> swiotlb_bus_to_virt, virt_to_bus and bus_to_phys; added the hwdev 
>> parameter to swiotlb_bus_to_phys; and added a weak 
>> swiotlb_arch_address_needs_mapping.  I assume that was needed because 
>> powerpc needs non-trivial implementations for those functions.
>>     
>
> Hmm, what she added are wrappers of virt_to_bus and bus_to_virt. We
> can remove these and directly use virt_to_bus and bus_to_virt.
>   

In general those interfaces are deprecated.  Are we un-deprecating 
them?  Or do you mean adding virt<->bus to dma_ops?

> About __weak address_needs_mapping function, as I said, removing it
> and using dma_map_ops is a proper solution.
>   

Fine.  Could swiotlb_alloc() just call dma_alloc_coherent() too?

    J
