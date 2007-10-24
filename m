Return-Path: <linux-kernel-owner+w=401wt.eu-S1760887AbXJXQwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760887AbXJXQwa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760268AbXJXQfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:35:23 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:37384 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761259AbXJXQfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:35:21 -0400
Date: Wed, 24 Oct 2007 12:35:20 -0400
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Rajkumar S <rajkumars@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: HIGHMEM64G Kernel (2.6.23.1) makes system crawl
Message-ID: <20071024163520.GM4003@csclub.uwaterloo.ca>
References: <64de5c8b0710240326q709ca7fbq4b365bcaf6e89fb9@mail.gmail.com> <471F598C.5030903@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471F598C.5030903@panasas.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 04:41:16PM +0200, Boaz Harrosh wrote:
> I thought that for 4GB of memory the CONFIG_HIGHMEM4G=y CONFIG_HIGHMEM64G is not set
> would be enough.
> 
> From looking in source code the CONFIG_HIGHMEM64G is broken in many respects,
> in my opinion. It's really a 64-bit with 32-bit quirks enabled. Does it even
> run on None 64-bit machines? Not many! 
> 
> You have a magnificent 64-bit Machine, why?

CONFIG_HIGHMEM4G means 4GB address space.  Since PCI and BIOS use some
of the first 4GB address space, a machine with 4GB of actual RAM must
map some of that RAM above the 4GB address space, so you access it all
you need to enable PAE (address space extensions intel invented to give
36bit addressing on 32bit machines), which lets the OS map memory above
4GB (up to 64GB), to let applications use it.  Applications are still
limited to a 32bit address space.  64bit machines of course just use all
memory directly without any silly extensions.

The common intel BIOS bug relating to configuring the MTRR and such for
caching of memory makes the top portion of memory uncached and hence
very slow, which means any code placed in the top part of memory gets
slow.  The kernel likes to place itself at the top of memory which means
the kernel gets slow and hence the whole system gets slow.  Holefully
intel will learn to make proper BIOSes real soon so that people with
intel boards can stop having such slow machines when they have lots of
ram.

--
Len Sorensen
