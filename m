Return-Path: <linux-kernel-owner+w=401wt.eu-S1754122AbXFVFNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbXFVFNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 01:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751111AbXFVFNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 01:13:33 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:56299 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbXFVFNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 01:13:32 -0400
Date: Fri, 22 Jun 2007 05:46:42 +0100 (BST)
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
       Russell King <rmk@arm.linux.org.uk>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: Oops in a driver while using SLUB as a SLAB allocator
In-Reply-To: <Pine.LNX.4.64.0706211839440.11717@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0706220540150.11131@blonde.wat.veritas.com>
References: <467A4532.40301@rfo.atmel.com> <Pine.LNX.4.64.0706212244090.19755@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706211839440.11717@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAAC2luYm94AG1hdHRoZXdAd2lsLmN4AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAY2xhbWV0ZXJAc2dpLmNvbQBhbmRyZXdAc2FucGVvcGxlLmNvbQBuaWNvbGFzLmZlcnJlQHJmby5hdG1lbC5jb20AbGludXgtYXJtLWtlcm5lbEBsaXN0cy5hcm0ubGludXgub3JnLnVrAGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmcAdG9ydmFsZHNAbGludXgtZm91bmRhdGlvbi5vcmcAbWFyYy5waWduYXRAaGV2cy5jaABkcnpldXNAZHJ6ZXVzLmN4AHJta0Bhcm0ubGludXgub3JnLnVrAA==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2007, Christoph Lameter wrote:
> On Thu, 21 Jun 2007, Hugh Dickins wrote:
> 
> > Seems a little odd that it's gone throughout 2.6.22-rc unnoticed
> > until now - nobody else trying SLUB on ARM or PA-RISC yet perhaps.
> 
> The impact is only on a subset of ARM machines.
> 
> PA_RISC? It looks like they run their own flushing function for byte 
> ranges called flush_kernel_dache_range. That does not use the page struct.

PA-RISC does have a function of that name, and I'm guessing that
you came across it in looking at the PA-RISC dma_map_single.

But PA-RISC also has a function called flush_dcache_page, which uses
page_mapping and expects a struct address_space * from it.  If that
can ever be get applied to a SLOB page (which is not so clear as in
the ARM case, but cannot easily be ruled out completely), we're
in trouble without a PageSlab test within page_mapping.

Hugh
