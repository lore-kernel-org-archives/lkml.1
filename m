Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbXKIR0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbXKIR0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 12:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754484AbXKIR0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 12:26:05 -0500
Received: from relay1.corp.sgi.com ([192.48.171.29]:45233 "EHLO relay.sgi.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754195AbXKIR0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 12:26:05 -0500
Date: Fri, 9 Nov 2007 09:26:01 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: Nishanth Aravamudan <nacc@us.ibm.com>, Mel Gorman <mel@skynet.ie>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 6/6] Use one zonelist that is filtered by nodemask
In-Reply-To: <1194628732.5296.14.camel@localhost>
Message-ID: <Pine.LNX.4.64.0711090924210.14572@schroedinger.engr.sgi.com>
References: <20071109143226.23540.12907.sendpatchset@skynet.skynet.ie> 
 <20071109143426.23540.44459.sendpatchset@skynet.skynet.ie> 
 <Pine.LNX.4.64.0711090741120.13932@schroedinger.engr.sgi.com> 
 <20071109161455.GB32088@skynet.ie>  <20071109164537.GG7507@us.ibm.com>
 <1194628732.5296.14.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Nov 2007, Lee Schermerhorn wrote:

> > On the other hand, if we call alloc_pages() with GFP_THISNODE set, there
> > is no nid to base the allocation on, so we "fallback" to numa_node_id()
> > [ almost like the nid had been specified as -1 ].
> > 
> > So I guess this is logical -- but I wonder, do we have any callers of
> > alloc_pages(GFP_THISNODE) ? It seems like an odd thing to do, when
> > alloc_pages_node() exists?
> 
> I don't know if we have any current callers that do this, but absent any
> documentation specifying otherwise, Mel's implementation matches what
> I'd expect the behavior to be if I DID call alloc_pages with 'THISNODE.
> However, we could specify that THISNODE is ignored in __alloc_pages()
> and recommend the use of alloc_pages_node() passing numa_node_id() as
> the nid parameter to achieve the behavior.  This would eliminate the
> check for 'THISNODE in __alloc_pages().  Just mask it off before calling
> down to __alloc_pages_internal().
> 
> Does this make sense?

I like consistency. If someone absolutely wants a local page then 
specifying GFP_THISNODE to __alloc_pages is okay. Leave as is I guess. 

What happens though if an MPOL_BIND policy is in effect? The node used 
must then be the nearest node from the policy mask....


