Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123AbZF2CYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbZF2CYT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 22:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbZF2CYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 22:24:10 -0400
Received: from complete.lackof.org ([198.49.126.79]:50181 "EHLO
	complete.lackof.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbZF2CYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 22:24:09 -0400
Date: Sun, 28 Jun 2009 20:24:11 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Grant Grundler <grundler@parisc-linux.org>,
       Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [BUG 2.6.31-rc1] HIGHMEM64G causes hang in PCI init on 32-bit
	x86
Message-ID: <20090629022411.GB20297@lackof.org>
References: <200906261559.n5QFxJH8027336@pilspetsen.it.uu.se> <19013.29264.623540.275538@pilspetsen.it.uu.se> <20090627042556.GA31085@lackof.org> <4A45AEC5.3060407@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A45AEC5.3060407@zytor.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26, 2009 at 10:31:49PM -0700, H. Peter Anvin wrote:
> Grant Grundler wrote:
>>>> +
>>>> +	/* Cap the iomem address space to what is addressable on all CPUs */
>>>> +	iomem_resource.end &= (1ULL << c->x86_phys_bits) - 1;
>>
>> Does x86_phys_bits represent the number of address lines/bits handled by
>> the memory controller, coming out of the CPU, or handled by the
>> "north bridge" (IO controller)?
>>
>
> x86_phys_bits represents the top end of what the processor can address.

Ok - I interpret that to mean the number of physical address bits
the processor can deal with regardless of the memory controller
or IO Controller.


>> I was assuming all three are the same thing but that might not be true
>> with "QPI" or whatever Intel is calling it's serial interconnect these days.
>> I'm wondering if the addressing capability of the CPU->memory controller
>> might be different than CPU->IO Controller.
>>
>> Parallel interconnects are limited by the number of lines wired to
>> transmit address data and I expect that's where x86_phys_bits originally
>> came from. Chipsets _were_ all designed around those limits.
>
> Serial interconnects behave the same way, it's just that the address  
> bits are sent in serial order.

The bits going across the wire are the protocol for the interconnect
and not necessarily what the CPU has implemented.  

> Something is seriously goofy here, and  
> it's probably reasonably straightforward to figure out what.

Ok - just tracking it down will be difficult...really need to know
the state of the machine (MCE dump?) when it wedges and can then
determine which code is trying to access the range.

thanks,
grant
