Return-Path: <linux-kernel-owner+w=401wt.eu-S1755956AbXKKOQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbXKKOQV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 09:16:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbXKKOQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 09:16:14 -0500
Received: from gir.skynet.ie ([193.1.99.77]:34991 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033AbXKKOQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 09:16:13 -0500
Date: Sun, 11 Nov 2007 14:16:10 +0000
To: Christoph Lameter <clameter@sgi.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nishanth Aravamudan <nacc@us.ibm.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, rientjes@google.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 6/6] Use one zonelist that is filtered by nodemask
Message-ID: <20071111141609.GA6967@skynet.ie>
References: <20071109143226.23540.12907.sendpatchset@skynet.skynet.ie> <20071109143426.23540.44459.sendpatchset@skynet.skynet.ie> <Pine.LNX.4.64.0711090741120.13932@schroedinger.engr.sgi.com> <20071109161455.GB32088@skynet.ie> <20071109164537.GG7507@us.ibm.com> <1194628732.5296.14.camel@localhost> <Pine.LNX.4.64.0711090924210.14572@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711090924210.14572@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (09/11/07 09:26), Christoph Lameter didst pronounce:
> On Fri, 9 Nov 2007, Lee Schermerhorn wrote:
> 
> > > On the other hand, if we call alloc_pages() with GFP_THISNODE set, there
> > > is no nid to base the allocation on, so we "fallback" to numa_node_id()
> > > [ almost like the nid had been specified as -1 ].
> > > 
> > > So I guess this is logical -- but I wonder, do we have any callers of
> > > alloc_pages(GFP_THISNODE) ? It seems like an odd thing to do, when
> > > alloc_pages_node() exists?
> > 
> > I don't know if we have any current callers that do this, but absent any
> > documentation specifying otherwise, Mel's implementation matches what
> > I'd expect the behavior to be if I DID call alloc_pages with 'THISNODE.
> > However, we could specify that THISNODE is ignored in __alloc_pages()
> > and recommend the use of alloc_pages_node() passing numa_node_id() as
> > the nid parameter to achieve the behavior.  This would eliminate the
> > check for 'THISNODE in __alloc_pages().  Just mask it off before calling
> > down to __alloc_pages_internal().
> > 
> > Does this make sense?
> 
> I like consistency. If someone absolutely wants a local page then 
> specifying GFP_THISNODE to __alloc_pages is okay. Leave as is I guess. 
> 

Agreed.

> What happens though if an MPOL_BIND policy is in effect? The node used 
> must then be the nearest node from the policy mask....
> 

If MPOL_BIND is in effect, the allocation will be filtered based on the
current allowed nodemask. If they specify THISNODE and the specified
node or current node is not in the mask, I would expect the allocation
to fail. Is that unexpected to anybody?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
