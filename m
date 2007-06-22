Return-Path: <linux-kernel-owner+w=401wt.eu-S1753493AbXFVBBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbXFVBBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 21:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbXFVBBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 21:01:37 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60305 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751031AbXFVBBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 21:01:36 -0400
Date: Thu, 21 Jun 2007 18:01:32 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Marc Pignat <marc.pignat@hevs.ch>, Andrew Victor <andrew@sanpeople.com>,
       Pierre Ossman <drzeus@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Oops in a driver while using SLUB as a SLAB allocator
In-Reply-To: <Pine.LNX.4.64.0706212244090.19755@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0706211759550.11554@schroedinger.engr.sgi.com>
References: <467A4532.40301@rfo.atmel.com> <Pine.LNX.4.64.0706212244090.19755@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2007, Hugh Dickins wrote:

> > The oops seems to occur after a page unmapping using dma_unmap_page() followed
> > by a flush_dcache_page() (in at91mci_post_dma_read()).

Was the page allocated using slab calls?

> Seems a little odd that it's gone throughout 2.6.22-rc unnoticed
> until now - nobody else trying SLUB on ARM or PA-RISC yet perhaps.
> As I understand it, you're not doing anything wrong (disclaimer:
> I'm no expert on dma_mapping things), but SLUB's reuse of struct
> page fields has collided with what flush_dcache_page is expecting.
> 
> Here's a patch: I'm not convinced it's necessarily the best one
> (most uses of page_mapping will never see a slab page, it's a pity
> to be cluttering up that inline even further); but in case nobody
> else can provide a better...

Well one may be better off allocating pages using the page allocator 
instead of the slab allocator. I removed these things from i386 but I did 
not check ARM.

