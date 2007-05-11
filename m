Return-Path: <linux-kernel-owner+w=401wt.eu-S1759955AbXEKBlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759955AbXEKBlj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 21:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754744AbXEKBlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 21:41:32 -0400
Received: from holomorphy.com ([66.93.40.71]:52761 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642AbXEKBlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 21:41:32 -0400
Date: Thu, 10 May 2007 18:42:02 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: slub-i386-support.patch
Message-ID: <20070511014202.GR19966@holomorphy.com>
References: <Pine.LNX.4.64.0705102028550.25681@blonde.wat.veritas.com> <20070510203102.GO19966@holomorphy.com> <Pine.LNX.4.64.0705102349150.24200@blonde.wat.veritas.com> <20070511000702.GI31925@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070511000702.GI31925@holomorphy.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 05:07:02PM -0700, William Lee Irwin III wrote:
> I described it as motivated by such, not really correctly handling it.
> I didn't bother analyzing it for correctness. I'm not surprised at all
> that the TLB flush can be missed where it now stands in the patch. I
> wanted to move it to tlb_finish_mmu() all along, along with quicklist
> management of lower levels of hierarchy.
> quicklist_free() with unflushed TLB entries admits speculation through
> the pagetable entries corresponding to the list links. So tlb_finish_mmu()
> is the place to call quicklist_free() on pagetables. This requires
> distinguishing preconstructed pagetables from freed user pages, which
> is not done in include/asm-generic/tlb.h (and core callers may need
> to be adjusted, pending the results of audits).
> To clarify, upper levels of pagetables are indeed cached by x86 TLB's.
> The same kind of deferral of freeing until the TLB is flushed required
> for leaf pagetables is required for the upper levels as well.

Never mind. The present bit ends up unset because all the vaddrs are
page-aligned, and PDPTE entries (which lack present bits) aren't ever
internally updated until explicit reloads. I'm still not wild about it,
but can't be arsed to deal with it unless it actually breaks.


-- wli
