Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbXFVUWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbXFVUWV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 16:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbXFVUWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 16:22:13 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:56582 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbXFVUWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 16:22:12 -0400
Date: Fri, 22 Jun 2007 21:21:25 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Christoph Lameter <clameter@sgi.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Marc Pignat <marc.pignat@hevs.ch>, Andrew Victor <andrew@sanpeople.com>,
       Pierre Ossman <drzeus@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: Oops in a driver while using SLUB as a SLAB allocator
In-Reply-To: <Pine.LNX.4.64.0706221206130.18210@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0706222110250.13850@blonde.wat.veritas.com>
References: <467A4532.40301@rfo.atmel.com> <Pine.LNX.4.64.0706212244090.19755@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706211835070.11608@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706220539050.11131@blonde.wat.veritas.com>
 <alpine.LFD.0.98.0706220937271.3593@woody.linux-foundation.org>
 <Pine.LNX.4.64.0706221040310.17139@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706221931370.4699@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706221143190.17958@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706221955360.9081@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706221206130.18210@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAACmluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAY2xhbWV0ZXJAc2dpLmNvbQBhbmRyZXdAc2FucGVvcGxlLmNvbQBuaWNvbGFzLmZlcnJlQHJmby5hdG1lbC5jb20AbGludXgtYXJtLWtlcm5lbEBsaXN0cy5hcm0ubGludXgub3JnLnVrAGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmcAdG9ydmFsZHNAbGludXgtZm91bmRhdGlvbi5vcmcAbWFyYy5waWduYXRAaGV2cy5jaABkcnpldXNAZHJ6ZXVzLmN4AHJta0Bhcm0ubGludXgub3JnLnVrAA==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2007, Christoph Lameter wrote:
> 
> We need to fix any remaining weird slab object uses right now. Your check 
> leaves a lot of holes open. 2.6.22 removes all other such strange slab 
> uses in other arches. It would be inconsistent if we left these things in 
> ARM (and maybe PA-RISC).

As I understand it, that driver used to work right with SLAB, then
oopsed with SLUB, and now works okay again with the page_mapping patch?

I'm unclear how it comes about that you removed "all other such strange
slab uses in other arches", yet missed this?  That suggests there may
be further unexpected uses.

It worries me that any use which catches you by surprise has to be
fixed up in the caller, rather than in slub itself: slab/slub is a
service, not a master.  But I'm rather repeating myself.

Hugh
