Return-Path: <linux-kernel-owner+w=401wt.eu-S1422809AbXCBDnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422809AbXCBDnG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 22:43:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422817AbXCBDnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 22:43:06 -0500
Received: from fgwnews.fujitsu.co.jp ([164.71.1.134]:60472 "EHLO
	fgwnews.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422809AbXCBDnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 22:43:05 -0500
X-Greylist: delayed 4031 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Mar 2007 22:43:04 EST
Date: Fri, 2 Mar 2007 11:34:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mel@skynet.ie, npiggin@suse.de, clameter@engr.sgi.com, mingo@elte.hu,
       jschopp@austin.ibm.com, arjan@infradead.org,
       torvalds@linux-foundation.org, mbligh@mbligh.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: The performance and behaviour of the anti-fragmentation related
 patches
Message-Id: <20070302113412.eeacb60d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070301160915.6da876c5.akpm@linux-foundation.org>
References: <20070301101249.GA29351@skynet.ie>
	<20070301160915.6da876c5.akpm@linux-foundation.org>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Mar 2007 16:09:15 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 1 Mar 2007 10:12:50 +0000
> mel@skynet.ie (Mel Gorman) wrote:
> 
> > Any opinion on merging these patches into -mm
> > for wider testing?
> 
> I'm a little reluctant to make changes to -mm's core mm unless those
> changes are reasonably certain to be on track for mainline, so let's talk
> about that.
> 
> What worries me is memory hot-unplug and per-container RSS limits.  We
> don't know how we're going to do either of these yet, and it could well be
> that the anti-frag work significantly complexicates whatever we end up
> doing there.
> 
> For prioritisation purposes I'd judge that memory hot-unplug is of similar
> value to the antifrag work (because memory hot-unplug permits DIMM
> poweroff).

About memory-hot-unplug, I'm now writing a new patch-set for memory-unplug for
showing my overview and roadmap. I'm now debugging it. I think I will be able to
post them as RFC in a week.

At least, ZONE_MOVABLE(or something partitioning memory) is necessary for
memory-hot-unplug like DIMM-poweroff. (I'm now using my own ZONE_MOVABLE patch, but
It is O.K. to migrate to Mel's one if it's ready to be merged.)


> Our basic unit of memory management is the zone.  Right now, a zone maps
> onto some hardware-imposed thing.  But the zone-based MM works *well*.  I
> suspect that a good way to solve both per-container RSS and mem hotunplug
> is to split the zone concept away from its hardware limitations: create a
> "software zone" and a "hardware zone".  All the existing page allocator and
> reclaim code remains basically unchanged, and it operates on "software
> zones".  Each software zones always lies within a single hardware zone. 
> The software zones are resizeable.  For per-container RSS we give each
> container one (or perhaps multiple) resizeable software zones.
> 
> For memory hotunplug, some of the hardware zone's software zones are marked
> reclaimable and some are not; DIMMs which are wholly within reclaimable
> zones can be depopulated and powered off or removed.
> 
Hmm...software-zone seems attractive.
I remember someone posted pesuedo-zone(pzone) patch in past.

-Kame

