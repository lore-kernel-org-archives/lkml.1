Return-Path: <linux-kernel-owner+w=401wt.eu-S1760758AbXJYDrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760758AbXJYDrL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 23:47:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760383AbXJYDq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 23:46:29 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41647 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760008AbXJYDq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 23:46:28 -0400
Message-ID: <4720118F.5050906@garzik.org>
Date: Wed, 24 Oct 2007 23:46:23 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
Subject: Re: [patch 2.6.24-rc1] resource_len() utility function
References: <200710241820.52376.david-b@pacbell.net> <20071025024405.3e960e9c@the-village.bc.nu> <471FFA91.3040306@garzik.org> <200710241947.15129.david-b@pacbell.net>
In-Reply-To: <200710241947.15129.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> On Wednesday 24 October 2007, Jeff Garzik wrote:
>> With regards to resource reservation...  IMO we should mimic struct 
>> pci_dev and add struct resource[] to struct device.
> 
> One minor difficulty:  PCI has a limit on the number of BARs,
> but other busses don't.  It'd be better as a "struct resource *".
> 
> 
>> Just like we have pci_request_regions(), we should also be able to 
>> easily to a dev_request_regions().  the implementation should be very 
>> close to pci_request_region() and pci_release_region().
> 
> Wouldn't it be nicer to have PCI use those dev_*() calls?
> Ideally pci_request_region() wraps dev_request_region()...

Absolutely...


>> Then a dev_iomap() analogue to pci_iomap() should be pretty 
>> straightforward to create.
> 
> Another minor nit:  addressing the various resource types.
> The platform bus code has multiple lookup schemes. 
> 
> Calls like resource_iomap() might be more flexible, so that
> lookup schemes can stay flexible.

I figured that, in the absence of a true, defined BAR concept, the 
struct device version would simply index into the discussed array of 
struct resource.  That means any ordering or layout of resources should 
work, presuming (the usual case) that both driver and platform agree on 
the resource layout.

	Jeff



