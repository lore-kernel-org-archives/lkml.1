Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbXJLC6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbXJLC6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 22:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbXJLC6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 22:58:42 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33175 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752896AbXJLC6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 22:58:41 -0400
Date: Thu, 11 Oct 2007 19:58:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: rdreier@cisco.com, general@lists.openfabrics.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jeff@garzik.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [GIT PULL] please pull infiniband.git for-linus
In-Reply-To: <20071011.181719.78707713.davem@davemloft.net>
Message-ID: <alpine.LFD.0.999.0710111944120.6887@woody.linux-foundation.org>
References: <aday7e9b0m3.fsf@cisco.com>
 <20071011.181719.78707713.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 11 Oct 2007, David Miller wrote:
> 
> Even if you're confident there won't be merge issues, could you just
> wait for the net-2.6 stuff to go in first?

I pulled the net stuff first, and merged the IB stuff afterwards. No 
conflicts in IB, but there *were* conflicts with the networking pull for 
other reasons.

That horrid, horrid mess that is called include/linux/mod_devicetable.h 
and scripts/mod/file2alias.c must go at some point. The thing is 
unmaintainable. Different maintainers add their own structures to both, 
and functions to both, and it's just messy. That's not how maintainable 
and modularized code should be written.

Now it broke on sdio vs ssb, but there was actually a conflict earlier 
with the Kbuild merge (which I aborted for other reasons), so this file 
really is starting to be a problem.

The merge was fairly straightforward and stupid - it's not like the code 
added is *complicated*, but all those small functions and structrues are 
set up to be a maze of very similar lines, so the merge is actually much 
worse than it should be - because there is inherent similarity, some lines 
are automatically auto-merged, making the result just harder to visualize.

So I merged it all, and I don't expect any problems, but I'm hoping 
somebody is thinking about that mod_devicetable.h/file2alias.c mess.

I'm not entirely sure who to blame on that thing. I'm adding Greg to the 
Cc, on the assumption that blaming him is usually the right thing to do ;)

Oh, and obviously, the NAPI changes may well have resulted in a merge that 
had no actual *conflicts* in it, but whether the end result works or not 
(and whether any IB drivers need updating due to the NAPI changes), I 
cannot tell. I've pushed out my tree, so people who are competent or just 
morbidly curious should start looking at it: it's got the following things 
merged now:

 - x86 merge
 - mmc
 - v4l-dvb
 - blackfin
 - avr32
 - block layer updates
 - Jeff's dmi-const
 - Purdie's blacklight and led trees
 - ide
 - mips
 - net
 - infiniband

and it all builds for me, but hey, I don't use half of it.

Oh, btw, one final note: because of just a *ton* of renames, if you 
actually want git to do rename-detection for you and do automatic merges 
across those x86 renames, you should likely add

	[diff]
	        renamelimit=0

to your .gitconfig file. Otherwise, the rename detection heuristics may 
end up saying "I'm not going to even bother finding renames in that mess".

(That final note really shouldn't affect any normal users, but I thought 
I'd mention it in case somebody is going to want git to merge things 
across the x86 merge, and gets stuck not realizing why some versions of 
git might not notice the renames).

			Linus
