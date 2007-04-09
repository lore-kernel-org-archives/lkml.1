Return-Path: <linux-kernel-owner+w=401wt.eu-S1030519AbXDJOQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030519AbXDJOQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 10:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030522AbXDJOQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 10:16:51 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2112 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030519AbXDJOQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 10:16:50 -0400
Date: Mon, 9 Apr 2007 12:39:20 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nigel Cunningham <ncunningham@linuxmail.org>
Subject: Re: [RFC][PATCH -mm] swsusp: Use rbtree for tracking allocated swap
Message-ID: <20070409123920.GA4251@ucw.cz>
References: <200704072320.40238.rjw@sisk.pl> <20070408125636.GB4404@ucw.cz> <200704081902.35857.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704081902.35857.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Some time ago we discussed the possibility of simplifying the swsusp's approach
> > > towards tracking the swap pages allocated by it for saving the image (so that
> > > they can be freed if there's an error).
> > > 
> > > I think we can get back to it now, as it is a nice optimization that should
> > > allow us to use less memory (almost always) and improve performance a bit.
> > > 
> > 
> > Well, I do not think you can measure the difference, but...
> 
> As far as the memory usage is concerned, I can. :-)  Usually, it takes 1 extent
> (40 B on x86_64) to register all of the allocated swap pages.  If bitmaps are
> used, we need as many bits as there are swap pages available (for 1 GB swap
> and 4 KB pages that would be ~250000 bits, which gives ~8 pages, and we can
> save more than 800 extents using that much memory).

Well... obviously it works for the best case. OTOH, for the worst, it
needs 40bytes for every 2 bits. That's 16000% worse. And for that
nightmare-fragmented 1GB swap, you'll need 5000000bytes... which is
pretty bad.

OTOH 5MB RAM per 1GB swap is not _too_ bad... so we can do it...

> > >  kernel/power/power.h  |   27 +---------
> > >  kernel/power/swap.c   |   18 +-----
> > >  kernel/power/swsusp.c |  135 ++++++++++++++++++++++++++------------------------
> > >  kernel/power/user.c   |   22 +-------
> > >  4 files changed, 85 insertions(+), 117 deletions(-)

...and call it 'cleanup' not 'speedup'.


> > ....as it removes code... I think we can do that. But it is 2.6.23+
> > material.
> 
> Yes, I think so, but still we can ask Andrew to include it into -mm earlier? ;-)

Yes, that's okay with me.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
