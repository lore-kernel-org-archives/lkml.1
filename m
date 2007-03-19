Return-Path: <linux-kernel-owner+w=401wt.eu-S1030671AbXCSWCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030671AbXCSWCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 18:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030624AbXCSWCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 18:02:15 -0400
Received: from waste.org ([66.93.16.53]:54393 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030671AbXCSWCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 18:02:14 -0400
Date: Mon, 19 Mar 2007 16:49:35 -0500
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, "ast@domdv.de" <ast@domdv.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slab: deal with NULL pointers passed to kmem_cache_free
Message-ID: <20070319214935.GY4892@waste.org>
References: <20070319141038.212d4ac9.akpm@linux-foundation.org> <az5Ytbv5.1174339536.7416370.penberg@cs.helsinki.fi> <20070319144100.8a87f288.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070319144100.8a87f288.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2007 at 02:41:00PM -0700, Andrew Morton wrote:
> On Mon, 19 Mar 2007 23:25:36 +0200 (EET)
> "Pekka Enberg" <penberg@cs.helsinki.fi> wrote:
> 
> > 
> > On 3/19/2007, "Andrew Morton" <akpm@linux-foundation.org> wrote:
> > > Would prefer to do:
> > > 
> > > static inline void kmem_cache_free_if_not_null(struct kmem_cache *cachep,
> > > 						void *objp)
> > > {
> > > 	if (objp)
> > > 		kmem_cache_free(cachep, objp);
> > > }
> > > 
> > > so that we don't add extra overhead to all the thousands of existing,
> > > well-behaved callsites.
> > 
> > That bloats kernel text all the same
> 
> But only for those callsites which choose to use it!  We avoid adding a
> test-and-branch to those thousands of callsite which don't need it.
> 
> This is a super-hot path.

You're right about that. Perhaps there's some clever exception
handling thing we can do to eliminate the hot-path overhead.

-- 
Mathematics is the supreme nostalgia of our time.
