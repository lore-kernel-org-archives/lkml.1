Return-Path: <linux-kernel-owner+w=401wt.eu-S1753241Ab0AGSK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab0AGSK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 13:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192Ab0AGSKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 13:10:23 -0500
Received: from waste.org ([173.11.57.241]:35270 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138Ab0AGSKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 13:10:19 -0500
Subject: Re: [PATCH v3] slab: initialize unused alien cache entry as NULL
 at alloc_alien_cache().
From: Matt Mackall <mpm@selenic.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Haicheng Li <haicheng.li@linux.intel.com>,
       Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org,
       Andi Kleen <andi@firstfloor.org>, Eric Dumazet <eric.dumazet@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <4B45CF8E.7000707@cs.helsinki.fi>
References: <4B443AE3.2080800@linux.intel.com>
	 <4B45CF8E.7000707@cs.helsinki.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jan 2010 12:10:11 -0600
Message-ID: <1262887811.29868.241.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 14:11 +0200, Pekka Enberg wrote:
> Haicheng Li kirjoitti:
> > Comparing with existing code, it's a simpler way to use kzalloc_node()
> > to ensure that each unused alien cache entry is NULL.
> > 
> > CC: Pekka Enberg <penberg@cs.helsinki.fi>
> > CC: Eric Dumazet <eric.dumazet@gmail.com>
> > ---
> >  mm/slab.c |    6 ++----
> >  1 files changed, 2 insertions(+), 4 deletions(-)
> > 
> > diff --git a/mm/slab.c b/mm/slab.c
> > index 7dfa481..5d1a782 100644
> > --- a/mm/slab.c
> > +++ b/mm/slab.c
> > @@ -971,13 +971,11 @@ static struct array_cache **alloc_alien_cache(int 
> > node, int limit, gfp_t gfp)
> > 
> >      if (limit > 1)
> >          limit = 12;
> > -    ac_ptr = kmalloc_node(memsize, gfp, node);
> > +    ac_ptr = kzalloc_node(memsize, gfp, node);
> >      if (ac_ptr) {
> >          for_each_node(i) {
> > -            if (i == node || !node_online(i)) {
> > -                ac_ptr[i] = NULL;
> > +            if (i == node || !node_online(i))
> >                  continue;
> > -            }
> >              ac_ptr[i] = alloc_arraycache(node, limit, 0xbaadf00d, gfp);
> >              if (!ac_ptr[i]) {
> >                  for (i--; i >= 0; i--)
> 
> Christoph? Matt?

Looks like a fine cleanup.

Acked-by: Matt Mackall <mpm@selenic.com>

-- 
http://selenic.com : development and support for Mercurial and Linux


