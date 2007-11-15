Return-Path: <linux-kernel-owner+w=401wt.eu-S933870AbXKOWNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933870AbXKOWNp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 17:13:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765775AbXKOWNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 17:13:14 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49111 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764110AbXKOWNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 17:13:12 -0500
Date: Thu, 15 Nov 2007 14:12:14 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: William Lee Irwin III <wli@holomorphy.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Why preallocate pmd in x86 32-bit PAE?
In-Reply-To: <473CC0AC.3020500@goop.org>
Message-ID: <alpine.LFD.0.9999.0711151403000.4260@woody.linux-foundation.org>
References: <473CC0AC.3020500@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 Nov 2007, Jeremy Fitzhardinge wrote:
> 
> Once difference is that 64-bit incrementally allocates all levels of the
> pagetable, whereas 32-bit PAE preallocates the 4 pmds when it allocates
> the pgd.  What's the rationale for this?  What pitfalls would there be
> in making them incrementally allocated?

IIRC, the present bit is ignored in the magic 4-entry PGD.  All entries 
have to be present.

What earlier CPU's did was to basically load all four values into the CPU 
when you loaded %cr3. There was no "three-level page table walker" at all: 
it was still a two-level page table walker, there were just for magic 
internal page tables that were indexed off the two high bits.

		Linus
