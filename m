Return-Path: <linux-kernel-owner+w=401wt.eu-S933392AbXKOWoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933392AbXKOWoh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 17:44:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762230AbXKOWo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 17:44:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58608 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759439AbXKOWo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 17:44:27 -0500
Message-ID: <473CCB66.2080601@zytor.com>
Date: Thu, 15 Nov 2007 14:42:46 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       William Lee Irwin III <wli@holomorphy.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Why preallocate pmd in x86 32-bit PAE?
References: <473CC0AC.3020500@goop.org> <alpine.LFD.0.9999.0711151403000.4260@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0711151403000.4260@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> IIRC, the present bit is ignored in the magic 4-entry PGD.  All entries 
> have to be present.
> 

This is true, although you could point a PGD to an all-zero page if you 
really wanted to.  You have to re-load CR3 after modifying the top-level 
entries.

> What earlier CPU's did was to basically load all four values into the CPU 
> when you loaded %cr3. There was no "three-level page table walker" at all: 
> it was still a two-level page table walker, there were just for magic 
> internal page tables that were indexed off the two high bits.

They still are.  Loading CR3 in PAE really loads four registers from 
memory.  x86-64 is different, of course.

	-hpa
