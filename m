Return-Path: <linux-kernel-owner+w=401wt.eu-S1759415AbYG0WVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415AbYG0WVS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 18:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757727AbYG0WVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 18:21:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32930 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758151AbYG0WVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 18:21:05 -0400
Date: Sun, 27 Jul 2008 15:17:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mike Travis <travis@sgi.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [git pull] cpus4096 fixes
In-Reply-To: <20080727210547.GC28946@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.1.10.0807271511120.3486@nehalem.linux-foundation.org>
References: <20080727190601.GA764@elte.hu> <alpine.LFD.1.10.0807271242260.3486@nehalem.linux-foundation.org> <20080727210547.GC28946@ZenIV.linux.org.uk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 27 Jul 2008, Al Viro wrote:
> 
> ITYM "one 32.5kB array" -
> (u64[65][64]){[1][0] = 1, [2][0] = 2, [3][0] = 4, ..., [64][0] = 1ULL<<63}
> would work just fine.  You were saying...?

Yeah, you can optimize it even more, I agree. But even the _trivial_ one 
gets you to linear memory use (rather than something that is O(n^2) in 
number of CPU's) and makes the thing a non-issue. But yes, there's another 
almost-factor-of-two that you can get by being clever.

But in fact, I think your optimization would not just use less memory, but 
yes, it's also easier to write the initializer for (with just a couple of 
levels of macros to avoid having to do 64 entries by hand).

So yes, make it so. Please.

		Linus


