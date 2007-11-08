Return-Path: <linux-kernel-owner+w=401wt.eu-S1761650AbXKHVUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761650AbXKHVUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 16:20:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759323AbXKHVUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 16:20:32 -0500
Received: from palrel13.hp.com ([156.153.255.238]:46225 "EHLO palrel13.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516AbXKHVUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 16:20:31 -0500
X-Greylist: delayed 1332 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Nov 2007 16:20:31 EST
Subject: Re: [patch 00/23] Slab defragmentation V6
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Mel Gorman <mel@csn.ul.ie>, akpm@linux-foundatin.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <Pine.LNX.4.64.0711081103360.8954@schroedinger.engr.sgi.com>
References: <20071107011130.382244340@sgi.com>
	 <1194535612.6214.9.camel@localhost>
	 <Pine.LNX.4.64.0711081103360.8954@schroedinger.engr.sgi.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Thu, 08 Nov 2007 15:58:15 -0500
Message-Id: <1194555495.5295.27.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-11-08 at 11:12 -0800, Christoph Lameter wrote:
> On Thu, 8 Nov 2007, Mel Gorman wrote:
> 
> > On Tue, 2007-11-06 at 17:11 -0800, Christoph Lameter wrote:
> > > Slab defragmentation is mainly an issue if Linux is used as a fileserver
> > 
> > Was hoping this would get renamed to SLUB Targetted Reclaim from
> > discussions at VM Summit. As no copying is taking place, it's confusing
> > to call it defragmentation to me anyway. Not a major deal but it made
> > reading the patches a little confusing.
> 
> The problem is that people are focusing on one feature here and forget 
> about the rest. Targetted reclaim is one feature that was added later when 
> lumpy reclaim was added to the kernel. The primary intend of this patchset 
> was always to reduce the fragmentation. The name is appropriate and the 
> patchset will support copying of objects as soon as support for that is 
> added to the kick(). In that case the copying you are looking for will be 
> there. The simple implementation for the kick() methods is to simply copy
> pieces of the reclaim code. That is what is included here.
> 
> > > With lumpy reclaim slab defragmentation can be used to enhance the
> > > ability to recover larger contiguous areas of memory. Lumpy reclaim currently
> > > cannot do anything if a slab page is encountered. With slab defragmentation
> > > that slab page can be removed and a large contiguous page freed. It may
> > > be possible to have slab pages also part of ZONE_MOVABLE (Mel's defrag
> > > scheme in 2.6.23)
> > 
> > More terminology nit-pick - ZONE_MOVABLE is not defragmenting anything.
> > It's just partitioning memory. The slab pages need to be 100%
> > reclaimable or movable for that to happen but even with targetted
> > reclaim, some dentries such as the root directory one cannot be
> > reclaimed, right?
> 
> 100%? I am so fond of these categorical statements ....
> 
> ZONE_MOVABLE also contains mlocked pages that are also not reclaimable. 
> The question is at what level would it be possible to make them MOVABLE? 
> It may take some improvements to the kick() methods to make eviction more 
> reliable. Allowing the moving of objects in the kick() methods will 
> likely get usthere.

Christoph:  Although mlocked pages are not reclaimable, they ARE
migratable.  You fixed that a long time ago.  [And I just verified with
memtoy.]  Doesn't this make them "movable"?

Lee

