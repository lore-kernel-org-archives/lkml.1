Return-Path: <linux-kernel-owner+w=401wt.eu-S1762978AbYBLUOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762978AbYBLUOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 15:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009AbYBLUOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 15:14:06 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37181 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbYBLUOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 15:14:04 -0500
Date: Tue, 12 Feb 2008 20:03:54 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
       arjan@infradead.org, greg@kroah.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080212200354.GB16885@flint.arm.linux.org.uk>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
	arjan@infradead.org, greg@kroah.com, sfr@canb.auug.org.au,
	linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
	linux-arch@vger.kernel.org, akpm@linux-foundation.org
References: <20080211203146.3d28d1a0@laptopd505.fenrus.org> <20080212044314.GA4888@kroah.com> <20080211211751.3e265754@laptopd505.fenrus.org> <20080211.221126.230471463.davem@davemloft.net> <47B1CB08.4020101@garzik.org> <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 09:09:34AM -0800, Linus Torvalds wrote:
> I also don't think rebasing helps the particular problem under discussion 
> (ie conflicts due to having to sort out dependencies between different 
> trees), and in some ways hurts it.

How do you suggest that we fix the problems we had with the initial
merge with the ARM tree.

We were in the situation where, had I asked you to pull my tree, you'd
have had a fair number of conflicts to resolve - I tested this by trying
to merge your tree into my 'devel' head.

The result wasn't pleasant - even I didn't know how to fix up a lot of
those conflicts, so the only way I could move forward was to reconstruct
the 'devel' head (which is just merges of other branches) omitting the
problem branches.

This then posed something of a problem - of which I saw three solutions:

1. ask the original authors of changes in those problem branches to come
   up with patches or fixes in their git trees (in the rare case that
   they have git trees) to bring the branch into line with the conflicting
   changes in mainline.  The resulting branch with that change applied
   probably won't build, which means bisect pain for people who happen
   to bisect to that point.

2. botch the merge, publish the tree, and then hit heads together to try
   and get the problem resolved - again resulting in a commit point (the
   merge) which is nonsense and unbuildable.

3. rebase the branch on top of the conflicting change, throw out the
   patches which prove to be a problem and ask the original author of
   those patches to fix them up for the conflicting change.  The result
   is a completely bisectable tree.

(3) is the solution which I chose, and it worked _extremely_ well.

(3) is effectively what akpm does with his tree - when a patch conflicts
with other changes, he throws the changes out and bangs peoples heads
together to get a new set of patches generated which work together.  In
that respect, it's no different, and it's been proven there to work well.
So I see git as being no different.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
