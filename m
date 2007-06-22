Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978AbXFVFhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbXFVFhx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 01:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbXFVFhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 01:37:46 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:57586 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbXFVFhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 01:37:45 -0400
Date: Fri, 22 Jun 2007 06:37:03 +0100 (BST)
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
In-Reply-To: <Pine.LNX.4.64.0706212206430.12278@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0706220628420.6142@blonde.wat.veritas.com>
References: <467A4532.40301@rfo.atmel.com> <Pine.LNX.4.64.0706212244090.19755@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706211835070.11608@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706220539050.11131@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706212206430.12278@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAACmluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAY2xhbWV0ZXJAc2dpLmNvbQBhbmRyZXdAc2FucGVvcGxlLmNvbQBuaWNvbGFzLmZlcnJlQHJmby5hdG1lbC5jb20AbGludXgtYXJtLWtlcm5lbEBsaXN0cy5hcm0ubGludXgub3JnLnVrAGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmcAdG9ydmFsZHNAbGludXgtZm91bmRhdGlvbi5vcmcAbWFyYy5waWduYXRAaGV2cy5jaABkcnpldXNAZHJ6ZXVzLmN4AHJta0Bhcm0ubGludXgub3JnLnVrAA==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2007, Christoph Lameter wrote:
> On Fri, 22 Jun 2007, Hugh Dickins wrote:
> 
> > However... what gives you confidence that flush_dcache_page is
> > never applied to other slab pages?
> 
> Flush dcache page is supposed to run on pages not objects of varying 
> length. It is suprising that this has not lead to earlier problems.
> Objects allocated this way may straddle a page boundary under some 
> conditions and in that case virt_to_page may not lead to a page that 
> covers the complete object that is supposed to be flushed. Hopefully the 
> "size" of the allocated object were whole pages.

No, that's the wrong way round.  Neither ARM nor PA-RISC expects
flush_dcache_page to flush any dcache when given a slab allocation:
they just expect it to pass through, not to oops.

Hugh
