Return-Path: <linux-kernel-owner+w=401wt.eu-S1760204AbZCPLq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760204AbZCPLq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 07:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756293AbZCPLqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 07:46:47 -0400
Received: from mx1.suse.de ([195.135.220.2]:45852 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244AbZCPLqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 07:46:46 -0400
Date: Mon, 16 Mar 2009 12:46:44 +0100
From: Nick Piggin <npiggin@suse.de>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Mel Gorman <mel@csn.ul.ie>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 20/35] Use a pre-calculated value for num_online_nodes()
Message-ID: <20090316114644.GC30802@wotan.suse.de>
References: <1237196790-7268-1-git-send-email-mel@csn.ul.ie> <1237196790-7268-21-git-send-email-mel@csn.ul.ie> <200903162242.35341.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903162242.35341.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 10:42:34PM +1100, Nick Piggin wrote:
> On Monday 16 March 2009 20:46:15 Mel Gorman wrote:
> > num_online_nodes() is called by the page allocator to decide whether the
> > zonelist needs to be filtered based on cpusets or the zonelist cache.
> > This is actually a heavy function and touches a number of cache lines.
> > This patch stores the number of online nodes at boot time and when
> > nodes get onlined and offlined.
> >
> > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> > ---
> >  include/linux/nodemask.h |   16 ++++++++++++++--
> >  mm/page_alloc.c          |    6 ++++--
> >  2 files changed, 18 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
> > index 848025c..4749e30 100644
> > --- a/include/linux/nodemask.h
> > +++ b/include/linux/nodemask.h
> > @@ -449,13 +449,25 @@ static inline int num_node_state(enum node_states
> > state) node;					\
> >  })
> >
> > +/* Recorded value for num_online_nodes() */
> > +extern int static_num_online_nodes;
> 
> __read_mostly, please. Check this for any other place you've added
> global cachelines that are referenced by the allocator.

OK I'm blind, sorry ignore that :P
