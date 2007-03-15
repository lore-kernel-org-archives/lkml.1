Return-Path: <linux-kernel-owner+w=401wt.eu-S1753430AbXCOXFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbXCOXFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 19:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbXCOXFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 19:05:52 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37022 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753430AbXCOXFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 19:05:51 -0400
Date: Fri, 16 Mar 2007 00:05:41 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] swsusp: Do not use page flags
Message-ID: <20070315230541.GD20656@elf.ucw.cz>
References: <200703122214.02657.rjw@sisk.pl> <200703122219.21171.rjw@sisk.pl> <20070315110816.8b4102b3.akpm@linux-foundation.org> <200703152205.54639.rjw@sisk.pl> <20070315142955.7cbe62c1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070315142955.7cbe62c1.akpm@linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > On Mon, 12 Mar 2007 22:19:20 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > > +int create_basic_memory_bitmaps(void)
> > > > +{
> > > > +	struct memory_bitmap *bm1, *bm2;
> > > > +	int error = 0;
> > > > +
> > > > +	BUG_ON(forbidden_pages_map || free_pages_map);
> > > > +
> > > > +	bm1 = kzalloc(sizeof(struct memory_bitmap), GFP_ATOMIC);
> > > > +	if (!bm1)
> > > > +		return -ENOMEM;
> > > > +
> > > > +	error = memory_bm_create(bm1, GFP_ATOMIC | __GFP_COLD, PG_ANY);
> > > > +	if (error)
> > > > +		goto Free_first_object;
> > > > +
> > > > +	bm2 = kzalloc(sizeof(struct memory_bitmap), GFP_ATOMIC);
> > > > +	if (!bm2)
> > > > +		goto Free_first_bitmap;
> > > > +
> > > > +	error = memory_bm_create(bm2, GFP_ATOMIC | __GFP_COLD, PG_ANY);
> > > > +	if (error)
> > > 
> > > What is the risk that we'll go OOM here?  GFP_ATOMIC is rather unreliable.
> > 
> > Well, this can be called after processes (including kswapd) has been frozen.
> > We can't go to sleep at this point.
> 
> So it _is_ unreliable?

We are careful to leave some memory aside for suspend... We actually
free memory at beggining of suspend, and there's some simple "add few
percent for our overhead" there.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
