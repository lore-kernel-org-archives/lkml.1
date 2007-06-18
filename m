Return-Path: <linux-kernel-owner+w=401wt.eu-S933014AbXFRVzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014AbXFRVzh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 17:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764215AbXFRVza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 17:55:30 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54654 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763687AbXFRVz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 17:55:29 -0400
Date: Mon, 18 Jun 2007 14:55:27 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, suresh.b.siddha@intel.com
Subject: Re: [patch 05/26] Slab allocators: Cleanup zeroing allocations
In-Reply-To: <84144f020706181316u70145db2i786641d265e5bc42@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706181454370.14261@schroedinger.engr.sgi.com>
References: <20070618095838.238615343@sgi.com>  <20070618095914.622685354@sgi.com>
 <84144f020706181316u70145db2i786641d265e5bc42@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007, Pekka Enberg wrote:

> On 6/18/07, clameter@sgi.com <clameter@sgi.com> wrote:
> > +static inline void *kmem_cache_zalloc(struct kmem_cache *k, gfp_t flags)
> > +{
> > +       return kmem_cache_alloc(k, flags | __GFP_ZERO);
> > +}
> > +
> > +static inline void *__kzalloc(int size, gfp_t flags)
> > +{
> > +       return kmalloc(size, flags | __GFP_ZERO);
> > +}
> 
> Hmm, did you check kernel text size before and after this change?
> Setting the __GFP_ZERO flag at every kzalloc call-site seems like a
> bad idea.

I did not check but the flags are usually constant. Compiler does the |.

