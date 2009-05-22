Return-Path: <linux-kernel-owner+w=401wt.eu-S1758458AbZEVXzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458AbZEVXzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 19:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757575AbZEVXza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 19:55:30 -0400
Received: from claw.goop.org ([74.207.240.146]:51591 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757542AbZEVXza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 19:55:30 -0400
Message-ID: <4A173B72.5000201@goop.org>
Date: Fri, 22 May 2009 16:55:30 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
CC: Becky Bruce <beckyb@kernel.crashing.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 2/3] powerpc: Add support for swiotlb on 32-bit
References: <1242340949-16369-1-git-send-email-beckyb@kernel.crashing.org>	 <1242340949-16369-2-git-send-email-beckyb@kernel.crashing.org>	 <20090519142656T.fujita.tomonori@lab.ntt.co.jp>	 <19E48A70-3332-423C-ACAD-390F940EE81C@kernel.crashing.org>	 <4A1592CF.8000208@goop.org>	 <E6DAA792-9923-4B76-9759-6955AABE3EAB@kernel.crashing.org> <1242990702.22654.253.camel@zakaz.uk.xensource.com>
In-Reply-To: <1242990702.22654.253.camel@zakaz.uk.xensource.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
> On Thu, 2009-05-21 at 14:27 -0400, Becky Bruce wrote:
>   
>> I can work with that, but it's going to be a bit inefficient, as I  
>> actually need the dma_addr_t, not the phys_addr_t, so I'll have to  
>> convert.  In every case, this is a conversion I've already done and  
>> that I need in the calling code as well. 
>>     
>
> Does
>
>     dma_addr_t dma_map_range(struct device *hwdev, phys_addr_t addr,
>     size_t size);
>
> work for you?
>
> If the range does not need mapping then it returns the dma address, if
> you needed to calculate the dma address anyway to figure out if mapping
> is required then this is fine. If the range does need mapping then it
> returns NULL.
>   

My only concern is whether dma_addr_t == 0 is actually equivalent to 
NULL.  That is, can we be sure that address 0 will never be used?

Taking dma_alloc_coherent as a model, we could have something like:

    int dma_map_range(struct device *hwdev, phys_addr_t addr, size_t size, dma_addr_t *dma_addrp);
      

where *dma_addrp is set if the function returns success (bool return 
type might be clearer).

    J
