Return-Path: <linux-kernel-owner+w=401wt.eu-S1757292AbYHaSrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbYHaSrl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 14:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755537AbYHaSrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 14:47:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43119 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755503AbYHaSrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 14:47:33 -0400
Date: Sun, 31 Aug 2008 11:47:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Sanders <linux@sandersweb.net>
cc: linux-kernel@vger.kernel.org, Jan Beulich <jbeulich@novell.com>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
In-Reply-To: <200808311422.12525.linux@sandersweb.net>
Message-ID: <alpine.LFD.1.10.0808311140060.12958@nehalem.linux-foundation.org>
References: <200808311422.12525.linux@sandersweb.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 31 Aug 2008, David Sanders wrote:
>
> I recently discovered that x86 kernels won't boot under Virtual PC.

What CPU does Virtual PC emulate? As far as Wikipedia is concerned (not 
that I'd take it on complete faith) it emulates a 32-bit Intel Pentium II.

And that commit makes the kernel use the "P6 nops" for such hardware. 
Maybe Virtual PC doesn't support the newer intel nop things?

Intel docs say that it should be available on any intel CPU that has 
CPUID.01H.EAX[11:8] = 0110B or 1111B. That's the "family ID", and Pentium 
II should have a family ID of 6 (ie that 0110B case).

So it sounds like a Virtual PC bug, but I dunno. And maybe we should just 
use the legcay nops for anything that isn't modern (ie P4+ or Core)?

		Linus
