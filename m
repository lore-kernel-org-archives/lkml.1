Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbZBWLmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbZBWLmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 06:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753534AbZBWLmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 06:42:24 -0500
Received: from gir.skynet.ie ([193.1.99.77]:54248 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456AbZBWLmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 06:42:23 -0500
Date: Mon, 23 Feb 2009 11:42:21 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH 11/20] Inline get_page_from_freelist() in the fast-path
Message-ID: <20090223114221.GD6740@csn.ul.ie>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie> <1235344649-18265-12-git-send-email-mel@csn.ul.ie> <84144f020902222321q12f54ed8wae3865064bb6e43@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <84144f020902222321q12f54ed8wae3865064bb6e43@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 09:21:09AM +0200, Pekka Enberg wrote:
> On Mon, Feb 23, 2009 at 1:17 AM, Mel Gorman <mel@csn.ul.ie> wrote:
> > In the best-case scenario, use an inlined version of
> > get_page_from_freelist(). This increases the size of the text but avoids
> > time spent pushing arguments onto the stack.
> >
> > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> 
> It's not obvious to me why this would be a huge win so I suppose this
> patch description could use numbers.

I don't have the exact numbers from the profiles any more but the
function entry and exit was about 1/20th of the cost of the path when
zeroing pages is not taken into account.

> Note: we used to do tricks like
> these in slab.c but got rid of most of them to reduce kernel text size
> which is probably why the patch seems bit backwards to me.
> 

I'll be rechecking this patch in particular because it's likely the
biggest text bloat in the entire series.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
