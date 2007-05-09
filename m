Return-Path: <linux-kernel-owner+w=401wt.eu-S969026AbXEID1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969026AbXEID1I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 23:27:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968836AbXEID0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 23:26:53 -0400
Received: from waste.org ([66.93.16.53]:57575 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968875AbXEID0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 23:26:52 -0400
Date: Tue, 8 May 2007 22:25:52 -0500
From: Matt Mackall <mpm@selenic.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, akpm@linux-foundation.org,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: + fix-spellings-of-slab-allocator-section-in-init-kconfig.patch added to -mm tree
Message-ID: <20070509032552.GE11115@waste.org>
References: <200705082302.l48N2KrZ004229@shell0.pdx.osdl.net> <20070509002307.GV11115@waste.org> <Pine.LNX.4.64.0705081746500.16914@schroedinger.engr.sgi.com> <20070509012725.GZ11115@waste.org> <Pine.LNX.4.64.0705081828300.17376@schroedinger.engr.sgi.com> <20070509021911.GB11115@waste.org> <Pine.LNX.4.64.0705081920250.17931@schroedinger.engr.sgi.com> <4641353F.2000408@yahoo.com.au> <Pine.LNX.4.64.0705081954300.19976@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705081954300.19976@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 07:57:37PM -0700, Christoph Lameter wrote:
> On Wed, 9 May 2007, Nick Piggin wrote:
> 
> > > Exactly. That overhead does not exist in SLUB. Thus SLOB is less efficient
> > > than SLUB.
> > 
> > What you trade for that is that one page page can only serve one slab.
> 
> Right.
> 
> > For small systems, I would not be surprised if that was less space
> > efficient, even just looking at kmalloc caches in isolation. Or do you
> > have numbers to support your conclusion?
> 
> No I do not have any number beyond the efficiency calculations based on 
> whole slabs. We would have to do some experiments to figure out how much 
> space is actually wasted through partial slabs.

The expectation would be (PAGE_SIZE + (PAGE_SIZE % size))/2 on average
per cache.
 
> The situation becomes different with allocation and frees. Then we may 
> have lots of partial slabs that we allocate from. But the SLOB approach 
> also will have holes to manage. So I do not see how this could be a 
> benefit unless you only have a few precious pages and you need to put 
> multiple object sizes into it. A 4M system still has 1000 pages.

A 4M system has approximately zero pages free once you've actually got
stuff running in userspace. The marginal utility of each page is very
high.

-- 
Mathematics is the supreme nostalgia of our time.
