Return-Path: <linux-kernel-owner+w=401wt.eu-S1755252AbYJCDlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbYJCDlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 23:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754179AbYJCDlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 23:41:45 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41712 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165AbYJCDlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 23:41:44 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 4/4] capture pages freed during direct reclaim for	allocation by the reclaimer
Cc: kosaki.motohiro@jp.fujitsu.com, Andy Whitcroft <apw@shadowen.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <48E4F6EC.7010500@linux-foundation.org>
References: <20081002143508.GE11089@brain> <48E4F6EC.7010500@linux-foundation.org>
Message-Id: <20081003123545.EF5B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Fri,  3 Oct 2008 12:41:41 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cristoph,

> >> At the beginning of reclaim just flush all pcp pages and then do not allow pcp
> >> refills again until reclaim is finished?
> > 
> > Not entirely, some pages could get trapped there for sure.  But it is
> > parallel allocations we are trying to guard against.  Plus we already flush
> > the pcp during reclaim for higher orders.
> 
> So we just would need to forbid refilling the pcp.
> 
> Parallel allocations are less a problem if the freed order 0 pages get merged
> immediately into the order 1 freelist. Of course that will only work 50% of
> the time but it will have a similar effect to this patch.

Ah, Right.
Could we hear why you like pcp disabling than Andy's patch?

Honestly, I think pcp has some problem.
But I avoid to change pcp because I don't understand its design.

Maybe, we should discuss currect pcp behavior?



