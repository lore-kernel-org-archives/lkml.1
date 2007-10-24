Return-Path: <linux-kernel-owner+w=401wt.eu-S1759918AbXJXUho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759918AbXJXUho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 16:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757233AbXJXUh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 16:37:28 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:60795 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756644AbXJXUh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 16:37:26 -0400
Date: Wed, 24 Oct 2007 16:37:26 -0400
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Rajkumar S <rajkumars@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: HIGHMEM64G Kernel (2.6.23.1) makes system crawl
Message-ID: <20071024203726.GA4000@csclub.uwaterloo.ca>
References: <64de5c8b0710240326q709ca7fbq4b365bcaf6e89fb9@mail.gmail.com> <471F598C.5030903@panasas.com> <20071024163520.GM4003@csclub.uwaterloo.ca> <471F873C.6010002@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471F873C.6010002@panasas.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 07:56:12PM +0200, Boaz Harrosh wrote:
> So one thing I don't understand is the difference between CONFIG_HIGHMEM4G
> and regular 32-bit. I always thought that 32 bit means 4GB address space
> and that the HIGHMEM4G is using your above trick but with 32-bit dma_addr_t
> since there is only actual 4GB of real memory and the rest is mapping tricks.
> But I guess I was wrong.

For efficiency reasons the kernel only supports about 900MB of ram on
i386, unless you enable the support for a full 4GB address space which
is what CONFIG_HIGHMEM4G does.  What exactly changes in the memory
management and mapping I am not sure of, but it made some difference.
It only gives 4GB of address space and does not enable PAE, which means
if the system has more ram than it can map in the first 4GB of address
space, then the remaining ram is simply invisible to the system.  So you
might have 4GB ram, and only see 3GB or 2.5GB of it with a 4GB kernel.
If you want the kernel to have access to the rest of the ram then you
need a kernel capable of addressing physical ram at addresses higher
than 4GB, which means either PAE (CONFIG_HIGHMEM64G) or a 64bit kernel.
I believe the comments for the CONFIG_HIGHMEM* options was recently
updated to me correct rather than the rather misleading messages they
have had for years.  Unfortunately it would appear those nice updates
have not gone tp Linus' tree so we are still stuck with the old awful
descriptions.  I wonder what happened to them.

> The other point I was making is why use 36 bit trickery when you have a machine
> that is capable of the full 64-bit, and runs much faster at that? Just a waste of
> a good machine, wont you say? Perhaps we learn to use x86_64 ARCHs before Intel
> fixes their BIOS, and they where right all along?

Because the 36bit trickery works with an i386 system and kernel.  Not
everyone wants to run 64bit and deal with the (few) programs that don't
yet work on 64bit systems.

Personally I run a 64bit kernel with a 32bit user space on any 64bit
capable machines I deal with.  That seems to work fine, and it lets me
play with 64bit programs in a 64bit chroot when I want to.

--
Len Sorensen
