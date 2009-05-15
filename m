Return-Path: <linux-kernel-owner+w=401wt.eu-S1761608AbZEOOw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761608AbZEOOw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 10:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752745AbZEOOwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 10:52:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38632 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200AbZEOOws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 10:52:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 5/6] PM/Hibernate: Do not release preallocated memory unnecessarily (rev. 2)
Date: Fri, 15 May 2009 16:52:16 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc5-rjw; KDE/4.2.2; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@tuxonice.net>,
       David Rientjes <rientjes@google.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
References: <200905070040.08561.rjw@sisk.pl> <200905141952.21267.rjw@sisk.pl> <20090515131115.GC1976@elf.ucw.cz>
In-Reply-To: <20090515131115.GC1976@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905151652.17418.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 May 2009, Pavel Machek wrote:
> On Thu 2009-05-14 19:52:20, Rafael J. Wysocki wrote:
> > On Thursday 14 May 2009, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > Since the hibernation code is now going to use allocations of memory
> > > > to make enough room for the image, it can also use the page frames
> > > > allocated at this stage as image page frames.  The low-level
> > > > hibernation code needs to be rearranged for this purpose, but it
> > > > allows us to avoid freeing a great number of pages and allocating
> > > > these same pages once again later, so it generally is worth doing.
> > > > 
> > > > [rev. 2: Take highmem into account correctly.]
> > > 
> > > I don't get it. What is advantage of this patch? It makes the code
> > > more complex... Is it supposed to be faster?
> > 
> > Yes, in some test cases it is reported to be faster (along with [4/6],
> > actually).
> > 
> > Besides, we'd like to get rid of shrink_all_memory() eventually and it is a
> > step in this direction.
> 
> Ok, but maybe we should wait with applying this until we have patches
> that actually get us rid of shrink_all_memory?

Well, the $subject patch is only an optimization of top of [4/6] that you've
just acked. ;-)

In fact [4/6] changes the approach to the memory shrinking and the $subject
one is only to avoid freeing all of the memory we've allocated and allocating
it once again later.

> Maybe it will not be feasible for speed reasons after all, or something...

At least it allows us to drop shrink_all_memory() easily for the sake of
experimentation (it's sufficient to comment out just one line of code for this
purpose).

Besides, after this patchset shrink_all_memory() is _only_ needed for
performance, so it should be possible to get rid of it relatively quckly.

Thanks,
Rafael
