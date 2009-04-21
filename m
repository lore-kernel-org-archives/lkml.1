Return-Path: <linux-kernel-owner+w=401wt.eu-S1756866AbZDUJ11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866AbZDUJ11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 05:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754187AbZDUJ1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 05:27:17 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45141 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbZDUJ1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 05:27:17 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [patch 3/3][rfc] vmscan: batched swap slot allocation
Cc: kosaki.motohiro@jp.fujitsu.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
       Hugh Dickins <hugh@veritas.com>
In-Reply-To: <20090421085231.GB2527@cmpxchg.org>
References: <20090421095857.b989ce44.kamezawa.hiroyu@jp.fujitsu.com> <20090421085231.GB2527@cmpxchg.org>
Message-Id: <20090421182427.F14D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 21 Apr 2009 18:27:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > -		cond_resched();
> > > +		if (list_empty(&swap_pages))
> > > +			cond_resched();
> > >  
> > Why this ?
> 
> It shouldn't schedule anymore when it's allocated the first swap slot.
> Another reclaimer could e.g. sleep on the cond_resched() before the
> loop and when we schedule while having swap slots allocated, we might
> continue further allocations multiple slots ahead.

Oops, It seems regression. this cond_resched() intent to

cond_resched();
pageout();
cond_resched();
pageout();
cond_resched();
pageout();



