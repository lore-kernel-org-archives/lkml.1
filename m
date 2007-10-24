Return-Path: <linux-kernel-owner+w=401wt.eu-S1756060AbXJXR4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbXJXR4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 13:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbXJXR4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 13:56:22 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:21292 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754039AbXJXR4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 13:56:21 -0400
Message-ID: <471F873C.6010002@panasas.com>
Date: Wed, 24 Oct 2007 19:56:12 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Rajkumar S <rajkumars@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: HIGHMEM64G Kernel (2.6.23.1) makes system crawl
References: <64de5c8b0710240326q709ca7fbq4b365bcaf6e89fb9@mail.gmail.com> <471F598C.5030903@panasas.com> <20071024163520.GM4003@csclub.uwaterloo.ca>
In-Reply-To: <20071024163520.GM4003@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Oct 2007 17:55:35.0903 (UTC) FILETIME=[145B4EF0:01C81667]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24 2007 at 18:35 +0200, lsorense@csclub.uwaterloo.ca (Lennart Sorensen) wrote:
> On Wed, Oct 24, 2007 at 04:41:16PM +0200, Boaz Harrosh wrote:
>> I thought that for 4GB of memory the CONFIG_HIGHMEM4G=y CONFIG_HIGHMEM64G is not set
>> would be enough.
>>
>> From looking in source code the CONFIG_HIGHMEM64G is broken in many respects,
>> in my opinion. It's really a 64-bit with 32-bit quirks enabled. Does it even
>> run on None 64-bit machines? Not many! 
>>
>> You have a magnificent 64-bit Machine, why?
> 
> CONFIG_HIGHMEM4G means 4GB address space.  Since PCI and BIOS use some
> of the first 4GB address space, a machine with 4GB of actual RAM must
> map some of that RAM above the 4GB address space, so you access it all
> you need to enable PAE (address space extensions intel invented to give
> 36bit addressing on 32bit machines), which lets the OS map memory above
> 4GB (up to 64GB), to let applications use it.  Applications are still
> limited to a 32bit address space.  64bit machines of course just use all
> memory directly without any silly extensions.
> 
> The common intel BIOS bug relating to configuring the MTRR and such for
> caching of memory makes the top portion of memory uncached and hence
> very slow, which means any code placed in the top part of memory gets
> slow.  The kernel likes to place itself at the top of memory which means
> the kernel gets slow and hence the whole system gets slow.  Holefully
> intel will learn to make proper BIOSes real soon so that people with
> intel boards can stop having such slow machines when they have lots of
> ram.
> 
> --
> Len Sorensen

So one thing I don't understand is the difference between CONFIG_HIGHMEM4G
and regular 32-bit. I always thought that 32 bit means 4GB address space
and that the HIGHMEM4G is using your above trick but with 32-bit dma_addr_t
since there is only actual 4GB of real memory and the rest is mapping tricks.
But I guess I was wrong.

The other point I was making is why use 36 bit trickery when you have a machine
that is capable of the full 64-bit, and runs much faster at that? Just a waste of
a good machine, wont you say? Perhaps we learn to use x86_64 ARCHs before Intel
fixes their BIOS, and they where right all along?

Boaz

