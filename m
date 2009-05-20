Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbZETOdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbZETOdr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 10:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbZETOdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 10:33:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:25838 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217AbZETOdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 10:33:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,221,1241420400"; 
   d="scan'208";a="144992003"
Date: Wed, 20 May 2009 22:32:58 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Elladan <elladan@eskimo.com>,
       Nick Piggin <npiggin@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
       Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
Subject: Re: [PATCH 2/3] vmscan: make mapped executable pages the first
	class citizen
Message-ID: <20090520143258.GA5706@localhost>
References: <alpine.DEB.1.10.0905181045340.20244@qirst.com> <20090519032759.GA7608@localhost> <20090519133422.4ECC.A69D9226@jp.fujitsu.com> <20090519062503.GA9580@localhost> <87pre4nhqf.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pre4nhqf.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 20, 2009 at 07:20:24PM +0800, Andi Kleen wrote:
> Wu Fengguang <fengguang.wu@intel.com> writes:
> >
> > 2.6.30-rc4-mm, VM_EXEC protection ON
> > ------------------------------------
> > begin:       2444             6652            50021              207                0           619959
> > end:          284           231752           233394              210           773879         20890132
> > restore:      399           231973           234352              251           776879         20960568
> >
> > We can reach basically the same conclusion from the above data.
> 
> One scenario that might be useful to test is what happens when some
> very large processes, all mapped and executable exceed memory and

Good idea. Too bad I may have to install some bloated desktop in order
to test this out ;) I guess the pgmajfault+pswpin numbers can serve as
negative scores in that case?

> fight each other for the working set. Do you have regressions then
> compared to without the patches?

No regressions for the above test. IMHO it can hardly create
regressions if there are no one to aggressively abuse it. Rik and
Christoph's ratio based logics are more likely to achieve better
protections as well as regressions.

Thanks,
Fengguang
