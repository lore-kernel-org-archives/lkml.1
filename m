Return-Path: <linux-kernel-owner+w=401wt.eu-S933198AbXKPRsD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933198AbXKPRsD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 12:48:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762607AbXKPRrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 12:47:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37604 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762194AbXKPRrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 12:47:41 -0500
Message-ID: <473DD74F.60800@zytor.com>
Date: Fri, 16 Nov 2007 09:45:51 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       William Lee Irwin III <wli@holomorphy.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Why preallocate pmd in x86 32-bit PAE?
References: <473CC0AC.3020500@goop.org> <alpine.LFD.0.9999.0711151403000.4260@woody.linux-foundation.org> <473DCF73.4070401@goop.org>
In-Reply-To: <473DCF73.4070401@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> Hm, do you recall what processors that might affect?  As far as I know,
> current processors will ignore non-present top-level entries.  Anyway,
> we can point them not present to empty_zero_page, so testing the present
> bit will still be sufficient to tell if we need to allocate a new pmd,
> but if the hardware decides to follow the page reference there's no harm
> done.  (Hm, unless the hardware decides it wants to set A or D bits in
> empty_zero_page for some reason...)
> 

PDPTR is documented to have P bits but none of the other control bits, 
unlike other levels of the hierarchy.

The hardware never sets A or D bits on non-present pages, since all the 
bits except P are reserved for the operating systems (and, besides, they 
can never be accessed or dirty.)

>> What earlier CPU's did was to basically load all four values into the CPU 
>> when you loaded %cr3. There was no "three-level page table walker" at all: 
>> it was still a two-level page table walker, there were just for magic 
>> internal page tables that were indexed off the two high bits.
> 
> That just means we need to reload cr3 after populating the pgd with a
> new pmd, right?

Yes.  And as Linus said, it would be a new special case.

	-hpa

