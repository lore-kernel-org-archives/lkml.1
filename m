Return-Path: <linux-kernel-owner+w=401wt.eu-S1031070AbXDQFJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031070AbXDQFJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 01:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031094AbXDQFJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 01:09:15 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:5416 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031070AbXDQFJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 01:09:15 -0400
Date: Mon, 16 Apr 2007 23:08:53 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Memory Allocation
In-reply-to: <fa.BkbRyK9fXhgijRwEDN4ejyJhMRQ@ifi.uio.no>
To: "Brian D. McGrew" <brian@visionpro.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <46245665.2050402@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.BkbRyK9fXhgijRwEDN4ejyJhMRQ@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Brian D. McGrew wrote:
> Good evening gents!
> 
> I need some help in allocating memory and understanding how the system
> allocates memory with physical versus virtual page tables.  Please
> consider the following snippet of code.  Please, no wisecracks about bad
> code; it was written in 30 seconds in haste :-)

(snip)

> My test machine is a Dell Precision 490 with dual 5140 processors and
> 3GB of RAM.  If I reduced kMaxSize to (2048 * 2048 * 236) is works.
> However, I need to allocate an array of char that is (2048 * 2048 * 256)
> and maybe even as large at (2048 * 2048 * 512).
> 
> Obviously I have enough physical memory in the box to do this.  However,
> I suspect that I'm running out of page table entries.  Please, correct
> me if I'm wrong; but if I allocate (2048 * 2048 * 236) it work.  When I

Pretty sure you're wrong.

> increment to 256 or 512 it fails and it is my suspicion that I just
> don't have enough more in kernel memory to allocate this much memory in
> user space.  

Are you using a 32-bit kernel? If so, most likely you're hitting a limit 
of the address space layout - there's just not enough room in the 
address space for an allocation of this size.

> 
> Because of a piece of 3rd party hardware, I'm forced to run the kernel
> in the 4GB memory model.  What I need to be able to do is allocate an
> array of char (2048 * 2048 * (up to 512)) in user space *** AND *** I
> need the addresses that I get back to be contiguous, that's just the way
> my 3rd party hardware works.
> 
> I'm inclined to believe that this in not specifically a Linux problem
> but maybe an architecture problem???  But maybe there is some kind of
> work around in the kernel for it???  I'd find it hard to believe that
> I'm the first one that ever needed to use this much memory.
> 
> I ran this same code on two difference Macs.  One of them a Powerbook G4
> with 4GB of RAM and it was successful.  The other was a Macbook Pro with
> 4GB of RAM and it failed.  Both running OS 10.4.9.  And of course it
> runs just lovely on my Sun workstation with Solaris.  Thus, I'm thinking
> it's an Intel/X86 issue!
> 
> How the heck to I get past this problem in Linux on the X86 plateform???

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

