Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbZESINP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbZESINP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 04:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbZESINE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 04:13:04 -0400
Received: from mga14.intel.com ([143.182.124.37]:31591 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbZESIND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 04:13:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,214,1241420400"; 
   d="scan'208";a="144385181"
Date: Tue, 19 May 2009 16:12:38 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Elladan <elladan@eskimo.com>,
       Nick Piggin <npiggin@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
Subject: Re: [PATCH 2/3] vmscan: make mapped executable pages the first
	class  citizen
Message-ID: <20090519081238.GA2121@localhost>
References: <20090516090005.916779788@intel.com> <20090516090448.410032840@intel.com> <84144f020905182339o5fb1e78eved95c4c20fd9ffa7@mail.gmail.com> <1242719063.26820.457.camel@twins> <1242720351.20986.0.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242720351.20986.0.camel@penberg-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19, 2009 at 04:05:51PM +0800, Pekka Enberg wrote:
> Hi Peter,
> 
> On Tue, 2009-05-19 at 09:44 +0200, Peter Zijlstra wrote:
> > Its a sekrit conspiracy against bloat by making JIT'd crap run
> > slower :-)
> > 
> > <rant>
> > Anyway, I just checked, we install tons of mono junk for _2_
> > applications, f-spot and tomboy, both are shite and both have
> > alternatives not requiring this disease.
> > </rant>
> 
> :-)
> 
> On Tue, 2009-05-19 at 09:44 +0200, Peter Zijlstra wrote:
> > But seriously, like Kosaka-san already said, anonymous pages are treated
> > differently from file pages and should not suffer the same problems.
> 
> OK, thanks for the explanation. The comment is a little bit misleading
> because I got the impression that we don't care about anon exec pages.

Ah yes!  Will this one dismiss the possible mis-interception?

                        /*
                         * Identify referenced, file-backed active pages and
                         * give them one more trip around the active list. So
                         * that executable code get better chances to stay in
                         * memory under moderate memory pressure.  Anon pages
modified ==>             * are not likely to be evicted by use-once streaming
modified ==>             * IO, plus JVM can create lots of anon VM_EXEC pages,
modified ==>             * so we ignore them here.
                         */
                        if ((vm_flags & VM_EXEC) && !PageAnon(page)) {
                                list_add(&page->lru, &l_active);
                                continue;
                        }

