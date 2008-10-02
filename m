Return-Path: <linux-kernel-owner+w=401wt.eu-S1754914AbYJBOfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbYJBOfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 10:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbYJBOfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 10:35:46 -0400
Received: from tallyho.bytemark.co.uk ([80.68.81.166]:38011 "EHLO
	tallyho.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747AbYJBOfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 10:35:46 -0400
Date: Thu, 2 Oct 2008 15:35:08 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] capture pages freed during direct reclaim for
	allocation by the reclaimer
Message-ID: <20081002143508.GE11089@brain>
References: <1222864261-22570-1-git-send-email-apw@shadowen.org> <1222864261-22570-5-git-send-email-apw@shadowen.org> <48E390DA.9060109@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E390DA.9060109@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2008 at 10:01:46AM -0500, Christoph Lameter wrote:
> Andy Whitcroft wrote:
> > When a process enters direct reclaim it will expend effort identifying
> > and releasing pages in the hope of obtaining a page.  However as these
> > pages are released asynchronously there is every possibility that the
> > pages will have been consumed by other allocators before the reclaimer
> > gets a look in.  This is particularly problematic where the reclaimer is
> > attempting to allocate a higher order page.  It is highly likely that
> > a parallel allocation will consume lower order constituent pages as we
> > release them preventing them coelescing into the higher order page the
> > reclaimer desires.
> 
> The reclaim problem is due to the pcp queueing right? Could we disable pcp
> queueing during reclaim? pcp processing is not necessarily a gain, so
> temporarily disabling it should not be a problem.
>
> At the beginning of reclaim just flush all pcp pages and then do not allow pcp
> refills again until reclaim is finished?

Not entirely, some pages could get trapped there for sure.  But it is
parallel allocations we are trying to guard against.  Plus we already flush
the pcp during reclaim for higher orders.

-apw

