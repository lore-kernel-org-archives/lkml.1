Return-Path: <linux-kernel-owner+w=401wt.eu-S1759362AbZCSXFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759362AbZCSXFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 19:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754012AbZCSXEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 19:04:49 -0400
Received: from gir.skynet.ie ([193.1.99.77]:33833 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670AbZCSXEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 19:04:48 -0400
Date: Thu, 19 Mar 2009 23:04:45 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 20/35] Use a pre-calculated value for num_online_nodes()
Message-ID: <20090319230445.GG24586@csn.ul.ie>
References: <alpine.DEB.1.10.0903161207500.32577@qirst.com> <20090316163626.GJ24293@csn.ul.ie> <alpine.DEB.1.10.0903161247170.17730@qirst.com> <20090318150833.GC4629@csn.ul.ie> <alpine.DEB.1.10.0903181256440.15570@qirst.com> <20090318180152.GB24462@csn.ul.ie> <alpine.DEB.1.10.0903181508030.10154@qirst.com> <alpine.DEB.1.10.0903191642160.22425@qirst.com> <20090319222106.GD24586@csn.ul.ie> <alpine.DEB.1.10.0903191823320.31984@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0903191823320.31984@qirst.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 06:24:02PM -0400, Christoph Lameter wrote:
> On Thu, 19 Mar 2009, Mel Gorman wrote:
> 
> > On Thu, Mar 19, 2009 at 04:43:55PM -0400, Christoph Lameter wrote:
> > > Trying to the same in the style of nr_node_ids etc.
> > >
> >
> > Because of some issues with the patch and what it does for possible
> > nodes, I reworked the patch slightly into the following and is what I'm
> > actually testing.
> 
> Ok. It also removes the slab bits etc.
> 

Well ... yes.

One of the slab changes removed a variable called numa_platform. From your
patch, this appears to have some relation to nr_possible_nodes but it's not
obvious at all if that is true or not.

The second change replaced num_possible_nodes() with nr_possible_nodes()
but it wasn't clear this was equivalent because nr_possible_nodes()
doesn't get updated from the call sites affecting the "possible" bitmap.

Both of those changes belong in a different patch and need explaination.
The bits left alter just nr_online_nodes and use it where it's
important.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
