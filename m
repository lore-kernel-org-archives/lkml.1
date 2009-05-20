Return-Path: <linux-kernel-owner+w=401wt.eu-S1756412AbZETRG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412AbZETRG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 13:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbZETRGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 13:06:20 -0400
Received: from claw.goop.org ([74.207.240.146]:47007 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217AbZETRGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 13:06:20 -0400
Message-ID: <4A143885.1050502@goop.org>
Date: Wed, 20 May 2009 10:06:13 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ian Campbell <ijc@hellion.org.uk>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, mingo@elte.hu,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, gregkh@suse.de, okir@suse.de,
       Becky Bruce <beckyb@kernel.crashing.org>
Subject: Re: Where do we stand with the Xen patches?
References: <20090518084052.GD10687@elte.hu>	 <20090519142626X.fujita.tomonori@lab.ntt.co.jp>	 <20090519130300.GB6238@elte.hu>	 <20090520002955R.fujita.tomonori@lab.ntt.co.jp> <1242748597.22654.44.camel@zakaz.uk.xensource.com>
In-Reply-To: <1242748597.22654.44.camel@zakaz.uk.xensource.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
> On Wed, 2009-05-20 at 00:30 +0900, FUJITA Tomonori wrote:
>   
>> We need these hooks but as I wrote above, they are
>> architecture-specific and we should handle them with the architecture
>> abstraction (as we handle similar problems) however we can't due to
>> dom0 support.
>>     
>
> I don't understand this. What exactly about the dom0 support patch
> prevents future abstraction here?
>
> The dom0 hooks would simply move into the per-arch abstractions as
> appropriate, wouldn't they?

Fujita-san's suggestion to me was that swiotlb could just use the normal 
(albeit deprecated) phys_to_bus()/bus_to_phys() interfaces rather than 
defining its own.  That would be perfectly OK for Xen; we have a single 
global translation which is unaffected by the target device, etc.

But I'm not sure it would work for powerpc; Becky's patches which added 
swiotlb_bus_to_phys/phys_bus made them take a device argument, because 
(apparently) the bus/phys offset can differ on a per-device or per-bus 
basis.  The powerpc side of swiotlb doesn't seem to be in mainline yet, 
so I'm not sure what the details are here (maybe it can be handled with 
a single big runtime switch, if the offset is always constant on a given 
machine).

(Hm, now that I look I see that they're defined as 
virt_to_bus/bus_to_virt, which doesn't work for highmem at all; it would 
need to be phys.)

But I may have misinterpreted what he meant. 

    J
