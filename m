Return-Path: <linux-kernel-owner+w=401wt.eu-S1751037AbXCBSZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751037AbXCBSZk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 13:25:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751036AbXCBSZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 13:25:39 -0500
Received: from smtp.osdl.org ([65.172.181.24]:37004 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034AbXCBSZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 13:25:39 -0500
Date: Fri, 2 Mar 2007 10:23:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@engr.sgi.com>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mel@skynet.ie>,
       npiggin@suse.de, mingo@elte.hu, jschopp@austin.ibm.com,
       arjan@infradead.org, torvalds@linux-foundation.org, mbligh@mbligh.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: The performance and behaviour of the anti-fragmentation related
 patches
Message-Id: <20070302102315.e0728a42.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703021012170.17676@schroedinger.engr.sgi.com>
References: <20070301101249.GA29351@skynet.ie>
	<20070301160915.6da876c5.akpm@linux-foundation.org>
	<45E842F6.5010105@redhat.com>
	<20070302085838.bcf9099e.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0703020919350.16719@schroedinger.engr.sgi.com>
	<20070302093501.34c6ef2a.akpm@linux-foundation.org>
	<45E8624E.2080001@redhat.com>
	<20070302100619.cec06d6a.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0703021012170.17676@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2007 10:15:36 -0800 (PST)
Christoph Lameter <clameter@engr.sgi.com> wrote:

> On Fri, 2 Mar 2007, Andrew Morton wrote:
> 
> > > One particular case is a 32GB system with a database that takes most
> > > of memory.  The amount of actually freeable page cache memory is in
> > > the hundreds of MB.
> > 
> > Where's the rest of the memory? tmpfs?  mlocked?  hugetlb?
> 
> The memory is likely in use but there is enough memory free in unmapped 
> clean pagecache pages so that we occasionally are able to free pages. Then 
> the app is reading more from disk replenishing that ...
> Thus we are forever cycling through the LRU lists moving pages between 
> the lists aging etc etc. Can lead to a livelock.

Guys, with this level of detail thses problems will never be fixed.

> > > A third scenario is where a system has way more RAM than swap, and not
> > > a whole lot of freeable page cache.  In this case, the VM ends up
> > > spending WAY too much CPU time scanning and shuffling around essentially
> > > unswappable anonymous memory and tmpfs files.
> > 
> > Well we've allegedly fixed that, but it isn't going anywhere without
> > testing.
> 
> We have fixed the case in which we compile the kernel without swap. Then 
> anonymous pages behave like mlocked pages. Did we do more than that?

oh yeah, we took the ran-out-of-swapcache code out.  But if we're going to
do this thing, we should find some way to bring it back.

