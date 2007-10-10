Return-Path: <linux-kernel-owner+w=401wt.eu-S1756808AbXJJQFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808AbXJJQFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 12:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755157AbXJJQFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 12:05:36 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:53219 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754878AbXJJQFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 12:05:35 -0400
Date: Wed, 10 Oct 2007 09:05:08 -0700
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Mel Gorman <mel@skynet.ie>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, rientjes@google.com,
       kamezawa.hiroyu@jp.fujitsu.com, clameter@sgi.com
Subject: Re: [PATCH 6/6] Use one zonelist that is filtered by nodemask
Message-ID: <20071010160508.GE26472@us.ibm.com>
References: <20070928142326.16783.98817.sendpatchset@skynet.skynet.ie> <20070928142526.16783.97067.sendpatchset@skynet.skynet.ie> <20071009011143.GC14670@us.ibm.com> <20071009154052.GC12632@skynet.ie> <1192031620.5617.39.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1192031620.5617.39.camel@localhost>
X-Operating-System: Linux 2.6.22.6 (x86_64)
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.10.2007 [11:53:40 -0400], Lee Schermerhorn wrote:
> On Tue, 2007-10-09 at 16:40 +0100, Mel Gorman wrote:
> <snip>
> > ====
> > Subject: Use specified node ID with GFP_THISNODE if available
> > 
> > It had been assumed that __GFP_THISNODE meant allocating from the local
> > node and only the local node. However, users of alloc_pages_node() may also
> > specify GFP_THISNODE. In this case, only the specified node should be used.
> > This patch will allocate pages only from the requested node when GFP_THISNODE
> > is used with alloc_pages_node().
> > 
> > [nacc@us.ibm.com: Detailed analysis of problem]
> > Found-by: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
> > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> > 
> <snip>
> 
> Mel:  I applied this patch [to your v8 series--the most recent, I
> think?] and it does fix the problem.  However, now I'm tripping over
> this warning in __alloc_pages_nodemask:
> 
> 	/* Specifying both __GFP_THISNODE and nodemask is stupid. Warn user */
> 	WARN_ON(gfp_mask & __GFP_THISNODE);
> 
> for each huge page allocated.  Rather slow as my console is a virtual
> serial line and the warning includes the stack traceback.
> 
> I think we want to just drop this warning, but maybe you have a tighter
> condition that you want to warn about?

Sigh, sorry Mel. I see this too on my box. I purely checked the
functionality and didn't think to check the logs, as the tests worked :/

I think it's quite clear that the WARN_ON() makes no sense now, since
alloc_pages_node() now calls __alloc_pages_nodemask().

-Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center
