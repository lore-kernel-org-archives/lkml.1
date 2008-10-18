Return-Path: <linux-kernel-owner+w=401wt.eu-S1751748AbYJRSoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748AbYJRSoc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 14:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbYJRSoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 14:44:23 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:54892 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbYJRSoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 14:44:22 -0400
Date: Sat, 18 Oct 2008 12:44:05 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, Paul Mackerras <paulus@samba.org>,
       Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-arch@vger.kernel.org
Subject: Re: [patch] mm: fix anon_vma races
Message-ID: <20081018184405.GA26184@parisc-linux.org>
References: <20081016041033.GB10371@wotan.suse.de> <Pine.LNX.4.64.0810172300280.30871@blonde.site> <alpine.LFD.2.00.0810171549310.3438@nehalem.linux-foundation.org> <Pine.LNX.4.64.0810180045370.8995@blonde.site> <20081018015323.GA11149@wotan.suse.de> <18681.20241.347889.843669@cargo.ozlabs.ibm.com> <20081018054916.GB26472@wotan.suse.de> <alpine.LFD.2.00.0810180921140.3438@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0810180921140.3438@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2008 at 10:00:30AM -0700, Linus Torvalds wrote:
> > Apparently pairwise ordering is more interesting than just a theoretical
> > thing, and not just restricted to Alpha's funny caches.
> 
> Nobody does just pairwise ordering, afaik. It's an insane model. Everybody 
> does some form of transitive ordering.

I assume you're talking about CPUs in particular here, and I don't know
of any counterexamples.

If you're talking about PCI devices, the model is not transitive.
Here's the exact text from Appendix E of PCI 3.0:

  A system may have multiple Producer-Consumer pairs operating
  simultaneously, with different data - flag-status sets located all
  around the system. But since only one Producer can write to a single
  data-flag set, there are no ordering requirements between different
  masters. Writes from one master on one bus may occur in one order on
  one bus, with respect to another master's writes, and occur in another
  order on another bus. In this case, the rules allow for some writes
  to be rearranged; for example, an agent on Bus 1 may see Transaction
  A from a master on Bus 1 complete first, followed by Transaction B
  from another master on Bus 0. An agent on Bus 0 may see Transaction
  B complete first followed by Transaction A. Even though the actual
  transactions complete in a different order, this causes no problem
  since the different masters must be addressing different data-flag sets.

I seem to remember earlier versions of the spec having more clear
language about A happening before B and B happening before C didn't
mean that A happened before C from the perspective of a third device,
but I can't find it right now.

Anyway, as the spec says, you're not supposed to use PCI like that,
so it doesn't matter.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
