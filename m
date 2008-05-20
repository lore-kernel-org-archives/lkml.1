Return-Path: <linux-kernel-owner+w=401wt.eu-S1761276AbYETAZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761276AbYETAZv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 20:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755942AbYETAZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 20:25:40 -0400
Received: from relay2.sgi.com ([192.48.171.30]:59955 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752213AbYETAZj (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 20:25:39 -0400
Date: Tue, 20 May 2008 10:25:03 +1000
From: David Chinner <dgc@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: David Chinner <dgc@sgi.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, andi@firstfloor.org,
       Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       mpm@selenic.com
Subject: Re: [patch 10/21] buffer heads: Support slab defrag
Message-ID: <20080520002503.GC173056135@sgi.com>
References: <20080510030831.796641881@sgi.com> <20080510030916.935905242@sgi.com> <20080512002403.GP103491721@sgi.com> <Pine.LNX.4.64.0805151041230.18708@schroedinger.engr.sgi.com> <20080515231045.GY155679365@sgi.com> <Pine.LNX.4.64.0805161000390.29603@schroedinger.engr.sgi.com> <20080519054554.GY103491721@sgi.com> <Pine.LNX.4.64.0805190942530.18431@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805190942530.18431@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 09:44:11AM -0700, Christoph Lameter wrote:
> On Mon, 19 May 2008, David Chinner wrote:
> 
> > Defragmentation is triggered as part of the usual memory reclaim
> > process. Which implies we've run out of free memory, correct?
> 
> Yes but we have already reclaimed some memory.
> 
> > > How do you trigger such a special writeout?
> > 
> > filemap_fdatawrite_range() perhaps?
> 
> Could you provide me such a patch? I would not know how much to writeout. 
> If we had such a method then we could also use that for the swap case 
> where we also write out single pages?

How hard is it? I don't have time right now to do this, but it's essentially:

	mapping = page->mapping;
	......
-	mapping->aops->writepage();
+	filemap_fdatawrite_range(mapping, start, end);

Where [start,end] span page->index and are is large enough
to get a substantial sized I/O to disk (say at least SWAP_CLUSTER_MAX
pages, preferrably larger for 4k page size machines).

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
