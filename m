Return-Path: <linux-kernel-owner+w=401wt.eu-S1752296AbXFVE1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296AbXFVE1X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 00:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750868AbXFVE1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 00:27:14 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:54123 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbXFVE1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 00:27:13 -0400
Date: Fri, 22 Jun 2007 05:26:33 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Christoph Lameter <clameter@sgi.com>
cc: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Marc Pignat <marc.pignat@hevs.ch>, Andrew Victor <andrew@sanpeople.com>,
       Pierre Ossman <drzeus@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: Oops in a driver while using SLUB as a SLAB allocator
In-Reply-To: <Pine.LNX.4.64.0706211759550.11554@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0706220513140.8870@blonde.wat.veritas.com>
References: <467A4532.40301@rfo.atmel.com> <Pine.LNX.4.64.0706212244090.19755@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706211759550.11554@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAACmluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAY2xhbWV0ZXJAc2dpLmNvbQBhbmRyZXdAc2FucGVvcGxlLmNvbQBuaWNvbGFzLmZlcnJlQHJmby5hdG1lbC5jb20AbGludXgtYXJtLWtlcm5lbEBsaXN0cy5hcm0ubGludXgub3JnLnVrAGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmcAdG9ydmFsZHNAbGludXgtZm91bmRhdGlvbi5vcmcAbWFyYy5waWduYXRAaGV2cy5jaABkcnpldXNAZHJ6ZXVzLmN4AHJta0Bhcm0ubGludXgub3JnLnVrAA==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2007, Christoph Lameter wrote:
> On Thu, 21 Jun 2007, Hugh Dickins wrote:
> 
> > > The oops seems to occur after a page unmapping using dma_unmap_page() followed
> > > by a flush_dcache_page() (in at91mci_post_dma_read()).
> 
> Was the page allocated using slab calls?

You've found yes (in the ARM case).

> Well one may be better off allocating pages using the page allocator 
> instead of the slab allocator. I removed these things from i386 but I did 
> not check ARM.

They may or may not be: I think that's a matter to discuss with rmk.

You keep on forcing the outside world to revolve around your needs
within slub.c: that is a good way to keep slub lean, and may be
justified; but it's at least questionable to be enforcing such
restrictions years after people have grown accustomed to more
freedom from their slabs.

Hugh
