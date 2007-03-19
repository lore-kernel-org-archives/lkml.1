Return-Path: <linux-kernel-owner+w=401wt.eu-S1030609AbXCSV46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030609AbXCSV46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030688AbXCSV45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:56:57 -0400
Received: from waste.org ([66.93.16.53]:52075 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030587AbXCSV44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:56:56 -0400
Date: Mon, 19 Mar 2007 16:44:14 -0500
From: Matt Mackall <mpm@selenic.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       ast@domdv.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: deal with NULL pointers passed to kmem_cache_free
Message-ID: <20070319214414.GX4892@waste.org>
References: <Pine.LNX.4.64.0703191022310.8671@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0703191007230.23929@schroedinger.engr.sgi.com> <20070319204945.GJ10459@waste.org> <Pine.LNX.4.64.0703191414330.8328@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703191414330.8328@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2007 at 02:16:01PM -0700, Christoph Lameter wrote:
> On Mon, 19 Mar 2007, Matt Mackall wrote:
> 
> > I think this sort of thing should work:
> > 
> > a = kmalloc(...)
> > b = kmem_cache_alloc(..)
> > c = allocate_some_id(...)
> > if (!a || !b || !c) {
> >    free_some_id(c)
> >    kmem_cache_free(c)
> 
> ^^^^ this requires the specification of a kmem_cache structure and the 
> object must be allocated by that cache.

Yes, omitted for brevity.

> >    kfree(a);
> 
> Here we dynamically determine the slab cache and do not verify even which 
> slab it came from.

That's an implementation detail that you shouldn't rely on and that
SLOB in fact breaks. kfree(kmem_cache_alloc(...)) is bad style to the
point of being a bug.

In my opinion:

xxxfree(xxxalloc(...)); /* should always work, even if allocation fails */
yyyfree(xxxalloc(...)); /* should never be expected to work */

-- 
Mathematics is the supreme nostalgia of our time.
