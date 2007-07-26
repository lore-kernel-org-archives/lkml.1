Return-Path: <linux-kernel-owner+w=401wt.eu-S1758833AbXGZCHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758833AbXGZCHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 22:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754872AbXGZCHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 22:07:07 -0400
Received: from ns.suse.de ([195.135.220.2]:46208 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbXGZCHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 22:07:06 -0400
Date: Thu, 26 Jul 2007 04:07:04 +0200
From: Nick Piggin <npiggin@suse.de>
To: Dave Airlie <airlied@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       magnade@gmail.com, davej@codemonkey.org.uk
Subject: Re: [patch] agp: don't lock pages
Message-ID: <20070726020704.GC20727@wotan.suse.de>
References: <20070725111922.GF29011@wotan.suse.de> <1185398813.5439.342.camel@localhost.localdomain> <20070726004114.GA17294@wotan.suse.de> <21d7e9970707251844p5c0243d6q7366ab8fa3738f62@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9970707251844p5c0243d6q7366ab8fa3738f62@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2007 at 11:44:22AM +1000, Dave Airlie wrote:
> >
> >Yeah I had a bit of a look around, and it seems OK (but would
> >appreciate an ack from someone who knows the code).
> >
> >These pages will never get seen by page reclaim, so we're OK
> >there. There is a get_page before the SetPageLocked and a put_page
> >right before the unlock_page, so refcounting should not be broken
> >if it wasn't already: note that the lock_page doesn't pin a
> >reference on a page in general -- we can use it as such for pagecache
> >(although it isn't very clean), because the lock pins the page in
> >pagecache and the pagecache holds a ref.
> >
> >Anyway, if Dave or David can take a look, that would be appreciated.
> >We'll need this for 2.6.23.
> 
> I talked with Ben earlier and I can't see anything inherently wrong
> with removing the lock_page, I assume it was put there to stop things
> getting swapped but if the get/put does that then I'd be happy to
> remove it.

Well it is prevented from being swapped out because it never gets
put on swapout lists, but the get/put certainly doesn't hurt :)
 

> I'm just a bit confused how this didn't get picked up in -mm at all.

Beats me. It was in there for nearly 5 months. Mustn't have been
tested or reported.
