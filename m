Return-Path: <linux-kernel-owner+w=401wt.eu-S1753026AbZDNJSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbZDNJSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 05:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750942AbZDNJSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 05:18:44 -0400
Received: from gir.skynet.ie ([193.1.99.77]:33986 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbZDNJSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 05:18:43 -0400
Date: Tue, 14 Apr 2009 10:18:39 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Ed Tomlinson <edt@aei.ca>
Cc: linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: How movable is zone movable?
Message-ID: <20090414091839.GA1772@csn.ul.ie>
References: <200904121129.09851.edt@aei.ca> <20090413095924.GA15333@csn.ul.ie> <20090413100440.GB15333@csn.ul.ie> <200904130810.59230.edt@aei.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200904130810.59230.edt@aei.ca>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 13, 2009 at 08:10:58AM -0400, Ed Tomlinson wrote:
> On Monday 13 April 2009 06:04:40 you wrote:
> > On Mon, Apr 13, 2009 at 10:59:25AM +0100, Mel Gorman wrote:
> > > > # huge_pages with movablecore set to 3G
> > > 
> > > How big did you make the movable zone and what is the hugepage size?
> > 
> > Scratch that question, I missed you said it was 3G. Are pages being
> > mlocked()?
> 
> Looks like there are mlocked pages.  What stopped the patches to allow these pages
> to be migrated?
> 

My recollection is fuzzy but it was mainly down to three points.

1. I could occasionally lock up the system if under enough load using
   page migration. I didn't have a reliable reproduction case to pin down
   whether it was something in page migration or something wrong with the
   way I was using it. There have been fixes in page migration since though
   so it's possible that got fixed along the way.

2. At the time, memory partitioning and anti-fragmentation were not long in
   mainline and dynamic hugepage pool resizing was very new. It was not clear
   there were going to be users of dynamic hugepage pool resizing that would
   need memory compaction as well. I was reasonasbly confident but that's
   not users.

3. There were significant problems in hugetlbfs that needed fixing up
   such as the reliability of MAP_PRIVATE. It was more important to chase
   down the stuff people certainly needed than complete features that they
   might need.

The patches weren't downright rejected as such but I didn't push hard as there
were almost zero users of dynamic hugepage pool resizing to be complaining
about mlock(). Improving hugetlbfs was more important and of obvious benefit
and I reckoned I'd wait and see who complained about mlock.

This has changed now. hugetlbfs is in way better state than it was and it
sounds like KVM is a user that is both interested in using dynamic pool
resizing and has mlocked pages. How much demand is there do you think?

There is someone currently working on helping the pool resizing from userspace
by temporarily adding a swap device during pool resize that will take a
while to complete. The plan was that they would revisit memory compaction
based on the prototype patches I did ages ago later in the year but maybe
that can be pushed along a bit harder if there was enough interest.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
