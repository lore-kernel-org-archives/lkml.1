Return-Path: <linux-kernel-owner+w=401wt.eu-S1752121AbYLWOoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbYLWOoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 09:44:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750945AbYLWOo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 09:44:29 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51068 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbYLWOo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 09:44:28 -0500
Subject: Re: [PATCH] failslab for SLUB
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org,
       akpm@linux-foundation.org
In-Reply-To: <20081223144307.GA3215@cmpxchg.org>
References: <20081223103616.GA7217@localhost.localdomain>
	 <Pine.LNX.4.64.0812231459580.18017@melkki.cs.Helsinki.FI>
	 <20081223144307.GA3215@cmpxchg.org>
Date: Tue, 23 Dec 2008 16:44:26 +0200
Message-Id: <1230043466.11073.0.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hannes,

On Tue, 2008-12-23 at 15:43 +0100, Johannes Weiner wrote:
> >  static inline void *____cache_alloc(struct kmem_cache *cachep,
> gfp_t flags)
> >  {
> >  	void *objp;
> > @@ -3381,7 +3316,7 @@ __cache_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid,
> >  	unsigned long save_flags;
> >  	void *ptr;
> >  
> > -	if (should_failslab(cachep, flags))
> > +	if (slab_should_failslab(cachep, flags))
> 
> should_failslab()?

No, look at what slab_should_failslab() does. We need to exclude
cache_cache in SLAB but not in SLUB.

