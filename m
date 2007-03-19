Return-Path: <linux-kernel-owner+w=401wt.eu-S1753160AbXCSVCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbXCSVCl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753447AbXCSVCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:02:40 -0400
Received: from waste.org ([66.93.16.53]:44475 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160AbXCSVCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:02:40 -0400
Date: Mon, 19 Mar 2007 15:49:46 -0500
From: Matt Mackall <mpm@selenic.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       ast@domdv.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: deal with NULL pointers passed to kmem_cache_free
Message-ID: <20070319204945.GJ10459@waste.org>
References: <Pine.LNX.4.64.0703191022310.8671@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0703191007230.23929@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703191007230.23929@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2007 at 10:08:03AM -0700, Christoph Lameter wrote:
> On Mon, 19 Mar 2007, Pekka J Enberg wrote:
> 
> > This changes kmem_cache_free() to deal with NULL objects passed to it. The 
> > current behavior is inconsistent with kfree() so there are callers 
> > passing NULL to kmem_cache_free().
> 
> Hmmm.. kmem_cache_free is significantly different. One also needs to 
> specify the slab cache.

I think this sort of thing should work:

a = kmalloc(...)
b = kmem_cache_alloc(..)
c = allocate_some_id(...)
if (!a || !b || !c) {
   free_some_id(c)
   kmem_cache_free(c)
   kfree(a);
   return -ENOMEM;
}

-- 
Mathematics is the supreme nostalgia of our time.
