Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbYAQMWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbYAQMWB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 07:22:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbYAQMVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 07:21:54 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43826 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbYAQMVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 07:21:53 -0500
Subject: Re: 2.6.24-rc7: memory leak?
From: Peter Zijlstra <peterz@infradead.org>
To: CaT <cat@zip.com.au>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080117121408.GS3940@zip.com.au>
References: <20080117063410.GQ3940@zip.com.au>
	 <1200568923.28661.9.camel@twins> <20080117114050.GR3940@zip.com.au>
	 <1200571632.28661.13.camel@twins>  <20080117121408.GS3940@zip.com.au>
Content-Type: text/plain
Date: Thu, 17 Jan 2008 13:21:51 +0100
Message-Id: <1200572511.28661.20.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-17 at 23:14 +1100, CaT wrote:
> On Thu, Jan 17, 2008 at 01:07:12PM +0100, Peter Zijlstra wrote:
> > On Thu, 2008-01-17 at 22:40 +1100, CaT wrote:
> > > > How much memory does:
> > > > 
> > > >   echo 3 > /proc/sys/vm/drop_caches
> > > > 
> > > > gain you?
> > > 
> > > 56M used now. 
> > 
> > Good :-)
> 
> Indeed. :)
> 
> > > Should all this cache usage not be counted towards the
> > > 'Cached' entry in meminfo rather then getting counted as part of used
> > > ram. 
> > 
> > Cached is only the page-cache, not all the other caches we have..
> > This someones confuses people, but one gets used to it. slabinfo allows
> > one to easily view others.
> 
> So what would I have to do to find out the real amount of memory free?
> Would that be the MemFree field in /proc/meminfo plus, from
> /proc/slabinfo, *_cache and size-*?

MemFree is the actual amount of free memory. Page reclaim and such
might, on memory pressure, free memory from cached, buffered and some
slabs that have shrinkers.

> If that's the case it would seem to be somewhat of a pain to get and
> kind of out of left field as I'd say most people would expect MemFree to
> indicate the amount of memory that's no longer freely available
> (ignoring swapping it out for simplicities sake).

I'm somewhat confused as to what you're saying. How would anyone expect
MemFree to be memory that is _not_ freely available?

Or are you asking how to compute the amount of freeable memory, that is
memory that isn't currently free, but could be freed up under pressure?

If that is indeed your question, then yes, thats rather hard as slabinfo
and the like don't indicate which buckets have shrinkers (but even if
they would have shrinkers there is no guarantee they'd be able to shrink
100%)


