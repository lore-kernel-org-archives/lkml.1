Return-Path: <linux-kernel-owner+w=401wt.eu-S1761132AbXEJUuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761132AbXEJUuh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 16:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755547AbXEJUub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 16:50:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34931
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755344AbXEJUua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 16:50:30 -0400
Date: Thu, 10 May 2007 13:50:32 -0700 (PDT)
Message-Id: <20070510.135032.68041531.davem@davemloft.net>
To: clameter@sgi.com
Cc: akpm@linux-foundation.org, hugh@veritas.com, torvalds@linux-foundation.org,
       ak@suse.de, wli@holomorphy.com, linux-kernel@vger.kernel.org
Subject: Re: slub-i386-support.patch
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0705101328110.11759@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0705102028550.25681@blonde.wat.veritas.com>
	<20070510131724.150e1e99.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705101328110.11759@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Thu, 10 May 2007 13:31:21 -0700 (PDT)

> On Thu, 10 May 2007, Andrew Morton wrote:
> 
> > > Though when I look at the patchset (copied below), I do wonder why
> > > it puts a quicklist_trim() into i386's cpu_idle() and flush_tlb_mm():
> > > neither is where I'd expect us to be secretly freeing pages.  Ah,
> > > several arches do it in cpu_idle(): how odd, oh well.
> > 
> > Christoph, could you please check that this is justified?
> 
> This has been that way for years for ia64 and sparc64. quicklist page 
> freeing needs to be synced with the tlb flushing since page table pages 
> may be flushed with the pages gathered in the tlb_mm struct. Dave Miller 
> set this up initially as far as I can tell. He could probably give more 
> details on why this was done historically.
> 
> ccing Dave.

I think it was just a convenient place to get it trimmed.

There could be some implications for platforms using virtual
page tables like IA64 et al. (sparc64 is no longer using
virtual page table mappings for TLB misses although it used to).

But I can't figure out a reason in that area for this stuff
either.

