Return-Path: <linux-kernel-owner+w=401wt.eu-S1760609AbZEONLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760609AbZEONLb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 09:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756223AbZEONLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 09:11:23 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36539 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbZEONLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 09:11:22 -0400
Date: Fri, 15 May 2009 15:11:16 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@tuxonice.net>,
       David Rientjes <rientjes@google.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 5/6] PM/Hibernate: Do not release preallocated memory
	unnecessarily (rev. 2)
Message-ID: <20090515131115.GC1976@elf.ucw.cz>
References: <200905070040.08561.rjw@sisk.pl> <200905131040.37831.rjw@sisk.pl> <20090514110958.GA8871@elf.ucw.cz> <200905141952.21267.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905141952.21267.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-05-14 19:52:20, Rafael J. Wysocki wrote:
> On Thursday 14 May 2009, Pavel Machek wrote:
> > Hi!
> > 
> > > Since the hibernation code is now going to use allocations of memory
> > > to make enough room for the image, it can also use the page frames
> > > allocated at this stage as image page frames.  The low-level
> > > hibernation code needs to be rearranged for this purpose, but it
> > > allows us to avoid freeing a great number of pages and allocating
> > > these same pages once again later, so it generally is worth doing.
> > > 
> > > [rev. 2: Take highmem into account correctly.]
> > 
> > I don't get it. What is advantage of this patch? It makes the code
> > more complex... Is it supposed to be faster?
> 
> Yes, in some test cases it is reported to be faster (along with [4/6],
> actually).
> 
> Besides, we'd like to get rid of shrink_all_memory() eventually and it is a
> step in this direction.

Ok, but maybe we should wait with applying this until we have patches
that actually get us rid of shrink_all_memory? Maybe it will not be
feasible for speed reasons after all, or something...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
