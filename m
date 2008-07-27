Return-Path: <linux-kernel-owner+w=401wt.eu-S1759322AbYG0VGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759322AbYG0VGG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 17:06:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758328AbYG0VFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 17:05:55 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38503 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758170AbYG0VFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 17:05:54 -0400
Date: Sun, 27 Jul 2008 22:05:47 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mike Travis <travis@sgi.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [git pull] cpus4096 fixes
Message-ID: <20080727210547.GC28946@ZenIV.linux.org.uk>
References: <20080727190601.GA764@elte.hu> <alpine.LFD.1.10.0807271242260.3486@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807271242260.3486@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2008 at 01:15:26PM -0700, Linus Torvalds wrote:

> So when you have 4k CPU's, instead of having 4k arrays (of 4k bits each, 
> with one bit set in each array - 2MB memory total), you have exactly 64 
> arrays instead, each 8k bits in size (64kB total). 

> And once you're not being a total idiot about wasting memory that is just 
> filled with a single bit in various different places, you don't need all 
> those games to re-create the arrays in some dense format, because they're 
> already going to be dense enough. If you compile a kernel for up to 4k 
> CPU's, "wasting" that 64kB of memory is a non-issue (especially since by 
> doing this "overlapping" trick you probbaly get better cache behaviour 
> anyway).
> 
> Ok, so now that I've insulted you and your pets (they're ugly!), show me 
> wrong, and then call me a d*ckhead. ("Linus - you're a d*ckhead, and you 
> didn't understand the problem, so you're a _stupid_ d*ckhead. And my 
> pet may be ugly, but yours _smells_ bad!").
> 
> Or say "Uh, yeah, we're morons, and here's the much better patch, and we 
> won't do that again".

ITYM "one 32.5kB array" -
(u64[65][64]){[1][0] = 1, [2][0] = 2, [3][0] = 4, ..., [64][0] = 1ULL<<63}
would work just fine.  You were saying...?

