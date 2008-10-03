Return-Path: <linux-kernel-owner+w=401wt.eu-S1754720AbYJCD0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbYJCD0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 23:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbYJCD0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 23:26:00 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56655 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbYJCDZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 23:25:59 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH 0/4] Reclaim page capture v4
Cc: kosaki.motohiro@jp.fujitsu.com, MinChan Kim <minchan.kim@gmail.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20081002150423.GG11089@brain>
References: <28c262360810011946p443350d3hcb271720892e7b85@mail.gmail.com> <20081002150423.GG11089@brain>
Message-Id: <20081003122332.EF58.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Fri,  3 Oct 2008 12:25:56 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I tested your patch in my desktop.
> > The test is just kernel compile with single thread.
> > My system environment is as follows.
> > 
> > model name	: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz
> > MemTotal:        2065856 kB
> > 
> > When I tested vanilla, compile time is as follows.
> > 
> > 2433.53user 187.96system 42:05.99elapsed 103%CPU (0avgtext+0avgdata
> > 0maxresident)k
> > 588752inputs+4503408outputs (127major+55456246minor)pagefaults 0swaps
> > 
> > When I tested your patch, as follows.
> > 
> > 2489.63user 202.41system 44:47.71elapsed 100%CPU (0avgtext+0avgdata
> > 0maxresident)k
> > 538608inputs+4503928outputs (130major+55531561minor)pagefaults 0swaps
> > 
> > Regresstion almost is above 2 minutes.
> > Do you think It is a trivial?
> > 
> > I know your patch is good to allocate hugepage.
> > But, I think many users don't need it, including embedded system and
> > desktop users yet.
> > 
> > So I suggest you made it enable optionally.
> 
> Hmmm.  I would not expect to see any significant impact for this kind of
> workload as we should not be triggering capture for the lower order
> allocations at all.  Something screwey must be occuring.  I will go and
> reproduce this here and see if I can figure out just what causes this.

yup.
I also think this is significant regression.

if this is reproduced, that patch shouldn't be merged to -mm, IMHO.




