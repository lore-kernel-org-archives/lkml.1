Return-Path: <linux-kernel-owner+w=401wt.eu-S1759628AbYG1QxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759628AbYG1QxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 12:53:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752909AbYG1Qww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 12:52:52 -0400
Received: from waste.org ([66.93.16.53]:52538 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760AbYG1Qwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 12:52:51 -0400
Subject: Re: [PATCH 12/30] mm: memory reserve management
From: Matt Mackall <mpm@selenic.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no,
       Daniel Lezcano <dlezcano@fr.ibm.com>, Neil Brown <neilb@suse.de>,
       cl@linux-foundation.org
In-Reply-To: <1217239564.7813.36.camel@penberg-laptop>
References: <20080724140042.408642539@chello.nl>
	 <20080724141530.127530749@chello.nl>
	 <1217239564.7813.36.camel@penberg-laptop>
Content-Type: text/plain
Date: Mon, 28 Jul 2008 11:49:29 -0500
Message-Id: <1217263769.15724.32.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-07-28 at 13:06 +0300, Pekka Enberg wrote:
> We're trying to get rid of kfree() so I'd __kfree_reserve() could to
> mm/sl?b.c. Matt, thoughts?

I think you mean ksize there. My big issue is that we need to make it
clear that ksize pairs -only- with kmalloc and that
ksize(kmem_cache_alloc(...)) is a categorical error. Preferably, we do
this by giving it a distinct name, like kmalloc_size(). We can stick an
underbar in front of it to suggest you ought not be using it too.

> > +	/*
> > +	 * ksize gives the full allocated size vs the requested size we
> used to
> > +	 * charge; however since we round up to the nearest power of two,
> this
> > +	 * should all work nicely.
> > +	 */

SLOB doesn't do this, of course. But does that matter? I think you want
to charge the actual allocation size to the reserve in all cases, no?
That probably means calling ksize() on both alloc and free.

-- 
Mathematics is the supreme nostalgia of our time.

