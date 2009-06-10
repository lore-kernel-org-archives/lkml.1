Return-Path: <linux-kernel-owner+w=401wt.eu-S1760142AbZFJJyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760142AbZFJJyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 05:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbZFJJyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 05:54:11 -0400
Received: from gir.skynet.ie ([193.1.99.77]:35206 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbZFJJyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 05:54:10 -0400
Date: Wed, 10 Jun 2009 10:54:09 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       "linuxram@us.ibm.com" <linuxram@us.ibm.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] Reintroduce zone_reclaim_interval for when
	zone_reclaim() scans and fails to avoid CPU spinning at 100% on NUMA
Message-ID: <20090610095409.GC25943@csn.ul.ie>
References: <1244466090-10711-2-git-send-email-mel@csn.ul.ie> <20090609015822.GA6740@localhost> <20090609081424.GD18380@csn.ul.ie> <20090609082539.GA6897@localhost> <20090609083153.GG18380@csn.ul.ie> <20090609090735.GC7108@localhost> <20090609094050.GL18380@csn.ul.ie> <20090609133804.GB6583@localhost> <20090609150619.GT18380@csn.ul.ie> <20090610021440.GB6597@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090610021440.GB6597@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 10:14:40AM +0800, Wu Fengguang wrote:
> On Tue, Jun 09, 2009 at 11:06:19PM +0800, Mel Gorman wrote:
> > On Tue, Jun 09, 2009 at 09:38:04PM +0800, Wu Fengguang wrote:
> > > On Tue, Jun 09, 2009 at 05:40:50PM +0800, Mel Gorman wrote:
> > > > 
> > > > Conceivably though, zone_reclaim_interval could automatically tune
> > > > itself based on a heuristic like this if the administrator does not give
> > > > a specific value. I think that would be an interesting follow on once
> > > > we've brought back zone_reclaim_interval and get a feeling for how often
> > > > it is actually used.
> > > 
> > > Well I don't think that's good practice. There are heuristic
> > > calculations all over the kernel. Shall we exporting parameters to
> > > user space just because we are not absolutely sure? Or shall we ship
> > > the heuristics and do adjustments based on feedbacks and only export
> > > parameters when we find _known cases_ that cannot be covered by pure
> > > heuristics?
> > > 
> > 
> > Good question - I don't have a satisfactory answer but I intuitively find
> > the zone_reclaim_interval easier to deal with than the heuristic.  That said,
> > I would prefer if neither was required.
> 
> Yes - can we rely on the (improved) accounting to make our "failure feedback"
> patches unnecessary? :)
> 

Am awaiting test results to answer that question :)

> Thanks,
> Fengguang
> 
> > In the patchset, I've added a counter for the number of times that the
> > scan-avoidance heuristic fails. If the tmpfs problem has been resolved
> > (patch with bug reporter, am awaiting test), I'll drop zone_reclaim_interval
> > altogether and we'll use the counter to detect if/when this situation
> > occurs again.
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
