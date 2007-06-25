Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996AbXFYTFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbXFYTFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 15:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbXFYTE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 15:04:57 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:28190 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbXFYTE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 15:04:56 -0400
Date: Mon, 25 Jun 2007 20:04:16 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Christoph Lameter <clameter@sgi.com>
cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Marc Pignat <marc.pignat@hevs.ch>, Andrew Victor <andrew@sanpeople.com>,
       Pierre Ossman <drzeus@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Oops in a driver while using SLUB as a SLAB allocator
In-Reply-To: <Pine.LNX.4.64.0706251147400.9332@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0706251953530.15624@blonde.wat.veritas.com>
References: <467A4532.40301@rfo.atmel.com> <Pine.LNX.4.64.0706220539050.11131@blonde.wat.veritas.com>
 <alpine.LFD.0.98.0706220937271.3593@woody.linux-foundation.org>
 <Pine.LNX.4.64.0706221040310.17139@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706221931370.4699@blonde.wat.veritas.com>
 <20070624083849.GA19079@flint.arm.linux.org.uk>
 <Pine.LNX.4.64.0706241122030.27778@blonde.wat.veritas.com>
 <20070624105152.GB14099@flint.arm.linux.org.uk>
 <Pine.LNX.4.64.0706250120560.28286@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706250607260.5191@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706251729250.4911@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706250952490.8320@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706251804420.7592@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706251108180.8907@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706251933540.13382@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706251147400.9332@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAACmluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAY2xhbWV0ZXJAc2dpLmNvbQBhbmRyZXdAc2FucGVvcGxlLmNvbQBuaWNvbGFzLmZlcnJlQHJmby5hdG1lbC5jb20AbGludXgtYXJtLWtlcm5lbEBsaXN0cy5hcm0ubGludXgub3JnLnVrAHRvcnZhbGRzQGxpbnV4LWZvdW5kYXRpb24ub3JnAGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmcAbWFyYy5waWduYXRAaGV2cy5jaABkcnpldXNAZHJ6ZXVzLmN4AHJtaytsa21sQGFybS5saW51eC5vcmcudWsA
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2007, Christoph Lameter wrote:
> On Mon, 25 Jun 2007, Hugh Dickins wrote:
> 
> > > The "sometimes we have kmalloced buffers" locations need to be fixed.
> > 
> > I've said enough, I'd better leave it to others to deter you or not
> > from fiddling around pointlessly here.
> 
> Are there any locations left after the two fixes to pa-risc and arm?
> 
> If the ARM fix solves the issue then we may not need that special casing 
> anymore. Maybe the sometimes has become never?

Please reread mails of the last 20 hours.  Your "ARM fix" may or may not
be a good thing, I don't know.  But it had nothing to do with this oops,
which (we believe) came from a kmalloc in drivers/mmc/core/sd.c.  There
are likely to be many other drivers which pass down kmalloc'ed buffers
to routines which handle both kmalloc'ed buffers and page buffers.
Though very few of those needing to flush_dcache_page.

Hugh
