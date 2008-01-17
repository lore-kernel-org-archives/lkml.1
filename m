Return-Path: <linux-kernel-owner+w=401wt.eu-S1756896AbYAQS7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896AbYAQS7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 13:59:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbYAQS64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 13:58:56 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49237 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754343AbYAQS6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 13:58:55 -0500
Date: Thu, 17 Jan 2008 10:58:53 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Olaf Hering <olaf@aepfle.de>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Linux MM <linux-mm@kvack.org>
Subject: Re: crash in kmem_cache_init
In-Reply-To: <20080117181222.GA24411@aepfle.de>
Message-ID: <Pine.LNX.4.64.0801171049190.21058@schroedinger.engr.sgi.com>
References: <20080115150949.GA14089@aepfle.de>
 <84144f020801170414q7d408a74uf47a84b777c36a4a@mail.gmail.com>
 <Pine.LNX.4.64.0801170628580.19208@schroedinger.engr.sgi.com>
 <20080117181222.GA24411@aepfle.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2008, Olaf Hering wrote:

> The patch does not help.

Duh. We need to know more about the problem.

> > --- linux-2.6.orig/mm/slab.c	2008-01-03 12:26:42.000000000 -0800
> > +++ linux-2.6/mm/slab.c	2008-01-09 15:59:49.000000000 -0800
> > @@ -2977,7 +2977,10 @@ retry:
> >  	}
> >  	l3 = cachep->nodelists[node];
> >  
> > -	BUG_ON(ac->avail > 0 || !l3);
> > +	if (!l3)
> > +		return NULL;
> > +
> > +	BUG_ON(ac->avail > 0);
> >  	spin_lock(&l3->list_lock);
> >  
> >  	/* See if we can refill from the shared array */
> 
> Is this hsupposed to go into cache_grow()? There is no NULL check
> for l3.

No its for cache_alloc_refill. cache_grow should only be called for
nodes that have memory. l3 is always used before cache_grow is called.

> freeing bootmem node 1
> Memory: 3496632k/3571712k available (6188k kernel code, 75080k reserved, 1324k data, 1220k bss, 304k init)
> cache_grow(2781) swapper(0):c0,j4294937299 cp c0000000006a4fb8 !l3

Is there more backtrace information? What function called cache_grow?

