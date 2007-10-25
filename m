Return-Path: <linux-kernel-owner+w=401wt.eu-S1757526AbXJYCIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526AbXJYCIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 22:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753562AbXJYCIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 22:08:24 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39248 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391AbXJYCIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 22:08:23 -0400
Message-ID: <471FFA91.3040306@garzik.org>
Date: Wed, 24 Oct 2007 22:08:17 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: David Brownell <david-b@pacbell.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
Subject: Re: [patch 2.6.24-rc1] resource_len() utility function
References: <200710241820.52376.david-b@pacbell.net> <20071025024405.3e960e9c@the-village.bc.nu>
In-Reply-To: <20071025024405.3e960e9c@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Wed, 24 Oct 2007 18:20:52 -0700
> David Brownell <david-b@pacbell.net> wrote:
> 
>> Add a new resource_len() function, so drivers can start using this
>> instead of driver-private code for a common idiom.  The call can be
>> useful with at least:
>>
>>  - request_region(), release_region()
>>  - request_mem_region(), release_mem_region()
>>  - ioremap()
>>
>> Candidate drivers include those using platform or PNP busses, and
>> maybe some others.  PCI already has a similar function.
>>
>> This patch also updates a representative set of drivers in two
>> subsystems to use this call (SPI, and USB peripheral/gadget).
> 
> PCI also increasingly is using functions that allow the user to choose to
> map a resource as a resource (eg pci_iomap). So is it better to have
> functions request_mem_resource(res)  free_mem_resource(res) and similar
> instead or as well ?


With regards to resource reservation...  IMO we should mimic struct 
pci_dev and add struct resource[] to struct device.

Just like we have pci_request_regions(), we should also be able to 
easily to a dev_request_regions().  the implementation should be very 
close to pci_request_region() and pci_release_region().

Then a dev_iomap() analogue to pci_iomap() should be pretty 
straightforward to create.

	Jeff


