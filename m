Return-Path: <linux-kernel-owner+w=401wt.eu-S1758300AbYABWwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300AbYABWwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 17:52:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbYABWwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 17:52:37 -0500
Received: from waste.org ([66.93.16.53]:39117 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118AbYABWwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 17:52:36 -0500
Subject: Re: [PATCH] procfs: provide slub's /proc/slabinfo
From: Matt Mackall <mpm@selenic.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Hugh Dickins <hugh@veritas.com>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com>
	 <84144f020801021109v78e06c6k10d26af0e330fc85@mail.gmail.com>
	 <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 02 Jan 2008 16:50:18 -0600
Message-Id: <1199314218.4497.109.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-02 at 11:35 -0800, Linus Torvalds wrote:
> 
> On Wed, 2 Jan 2008, Pekka Enberg wrote:
> > 
> > I already sent the remaining bits to Linus but this looks much
> > cleaner. Thanks Hugh!
> > 
> > Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> Actually, I'd much rather just do this instead (on top of your patch)
> 
> It just creates a new CONFIG_SLABINFO that automatically has the right 
> dependencies (ie depends on PROC being on, and either SLAB or SLUB), and 
> then both SLAB and SLUB just have the exact same interfaces.
> 
> Which means that SLOB could also trivially implement the same thing, with 
> no new #ifdef'fery or other crud.

Except SLOB's emulation of slabs is so thin, it doesn't have the
relevant information. We have a very small struct kmem_cache, which I
suppose could contain a counter. But we don't have anything like the
kmalloc slabs, so you'd only be getting half the picture anyway.
The output of slabtop would simply be misleading because there are no
underlying "slabs" in the first place.

-- 
Mathematics is the supreme nostalgia of our time.

