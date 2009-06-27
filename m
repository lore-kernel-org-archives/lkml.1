Return-Path: <linux-kernel-owner+w=401wt.eu-S1757656AbZF0FfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656AbZF0FfP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 01:35:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbZF0FfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 01:35:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57101 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbZF0FfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 01:35:02 -0400
Message-ID: <4A45AEC5.3060407@zytor.com>
Date: Fri, 26 Jun 2009 22:31:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Grant Grundler <grundler@parisc-linux.org>
CC: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [BUG 2.6.31-rc1] HIGHMEM64G causes hang in PCI init on 32-bit
 x86
References: <200906261559.n5QFxJH8027336@pilspetsen.it.uu.se> <19013.29264.623540.275538@pilspetsen.it.uu.se> <20090627042556.GA31085@lackof.org>
In-Reply-To: <20090627042556.GA31085@lackof.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Grundler wrote:
>>> +
>>> +	/* Cap the iomem address space to what is addressable on all CPUs */
>>> +	iomem_resource.end &= (1ULL << c->x86_phys_bits) - 1;
> 
> Does x86_phys_bits represent the number of address lines/bits handled by
> the memory controller, coming out of the CPU, or handled by the
> "north bridge" (IO controller)?
> 

x86_phys_bits represents the top end of what the processor can address.

> I was assuming all three are the same thing but that might not be true
> with "QPI" or whatever Intel is calling it's serial interconnect these days.
> I'm wondering if the addressing capability of the CPU->memory controller
> might be different than CPU->IO Controller.
> 
> Parallel interconnects are limited by the number of lines wired to
> transmit address data and I expect that's where x86_phys_bits originally
> came from. Chipsets _were_ all designed around those limits.

Serial interconnects behave the same way, it's just that the address 
bits are sent in serial order.  Something is seriously goofy here, and 
it's probably reasonably straightforward to figure out what.

	-hpa

