Return-Path: <linux-kernel-owner+w=401wt.eu-S970175AbXEIC6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970175AbXEIC6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 22:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032832AbXEIC5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 22:57:40 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53207 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1032773AbXEIC5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 22:57:38 -0400
Date: Tue, 8 May 2007 19:57:37 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Matt Mackall <mpm@selenic.com>, akpm@linux-foundation.org,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: + fix-spellings-of-slab-allocator-section-in-init-kconfig.patch
 added to -mm tree
In-Reply-To: <4641353F.2000408@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0705081954300.19976@schroedinger.engr.sgi.com>
References: <200705082302.l48N2KrZ004229@shell0.pdx.osdl.net>
 <20070509002307.GV11115@waste.org> <Pine.LNX.4.64.0705081746500.16914@schroedinger.engr.sgi.com>
 <20070509012725.GZ11115@waste.org> <Pine.LNX.4.64.0705081828300.17376@schroedinger.engr.sgi.com>
 <20070509021911.GB11115@waste.org> <Pine.LNX.4.64.0705081920250.17931@schroedinger.engr.sgi.com>
 <4641353F.2000408@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007, Nick Piggin wrote:

> > Exactly. That overhead does not exist in SLUB. Thus SLOB is less efficient
> > than SLUB.
> 
> What you trade for that is that one page page can only serve one slab.

Right.

> For small systems, I would not be surprised if that was less space
> efficient, even just looking at kmalloc caches in isolation. Or do you
> have numbers to support your conclusion?

No I do not have any number beyond the efficiency calculations based on 
whole slabs. We would have to do some experiments to figure out how much 
space is actually wasted through partial slabs.

If you just do straight allocation on a UP system then there is at maximum 
one partial slab per slabcache with SLUB.

The situation becomes different with allocation and frees. Then we may 
have lots of partial slabs that we allocate from. But the SLOB approach 
also will have holes to manage. So I do not see how this could be a 
benefit unless you only have a few precious pages and you need to put 
multiple object sizes into it. A 4M system still has 1000 pages.

