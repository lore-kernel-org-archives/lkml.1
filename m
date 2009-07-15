Return-Path: <linux-kernel-owner+w=401wt.eu-S1754801AbZGON4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbZGON4Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 09:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754784AbZGON4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 09:56:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36824 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754780AbZGON4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 09:56:22 -0400
Date: Wed, 15 Jul 2009 15:56:20 +0200
From: Nick Piggin <npiggin@suse.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linux Memory Management <linux-mm@kvack.org>,
       Linux-Arch <linux-arch@vger.kernel.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Hugh Dickins <hugh@tiscali.co.uk>
Subject: Re: [RFC/PATCH] mm: Pass virtual address to [__]p{te,ud,md}_free_tlb()
Message-ID: <20090715135620.GD7298@wotan.suse.de>
References: <20090715074952.A36C7DDDB2@ozlabs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090715074952.A36C7DDDB2@ozlabs.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 05:49:47PM +1000, Benjamin Herrenschmidt wrote:
> Upcoming paches to support the new 64-bit "BookE" powerpc architecture
> will need to have the virtual address corresponding to PTE page when
> freeing it, due to the way the HW table walker works.
> 
> Basically, the TLB can be loaded with "large" pages that cover the whole
> virtual space (well, sort-of, half of it actually) represented by a PTE
> page, and which contain an "indirect" bit indicating that this TLB entry
> RPN points to an array of PTEs from which the TLB can then create direct
> entries.

RPN is PFN in ppc speak, right?


> Thus, in order to invalidate those when PTE pages are deleted,
> we need the virtual address to pass to tlbilx or tlbivax instructions.

Interesting arrangement. So are these last level ptes modifieable
from userspace or something? If not, I wonder if you could manage
them as another level of pointers with the existing pagetable
functions?
 

> The old trick of sticking it somewhere in the PTE page struct page sucks
> too much, the address is almost readily available in all call sites and
> almost everybody implemets these as macros, so we may as well add the
> argument everywhere. I added it to the pmd and pud variants for consistency.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
> 
> I would like to merge the new support that depends on this in 2.6.32,
> so unless there's major objections, I'd like this to go in early during
> the merge window. We can sort out separately how to carry the patch
> around in -next until then since the powerpc tree will have a dependency
> on it.

Can't see any problem with that.

