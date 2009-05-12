Return-Path: <linux-kernel-owner+w=401wt.eu-S1754078AbZELEfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbZELEfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 00:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751064AbZELEfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 00:35:44 -0400
Received: from mga03.intel.com ([143.182.124.21]:37678 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbZELEfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 00:35:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,179,1241420400"; 
   d="scan'208";a="141735651"
Date: Tue, 12 May 2009 12:35:22 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "riel@redhat.com" <riel@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "cl@linux-foundation.org" <cl@linux-foundation.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
Subject: Re: [PATCH -mm] vmscan: make mapped executable pages the first
	class citizen
Message-ID: <20090512043522.GA17079@localhost>
References: <49FB01C1.6050204@redhat.com> <20090501123541.7983a8ae.akpm@linux-foundation.org> <20090503031539.GC5702@localhost> <1241432635.7620.4732.camel@twins> <20090507121101.GB20934@localhost> <20090507151039.GA2413@cmpxchg.org> <20090507134410.0618b308.akpm@linux-foundation.org> <20090508081608.GA25117@localhost> <20090508125859.210a2a25.akpm@linux-foundation.org> <20090512025058.GA7518@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090512025058.GA7518@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 10:50:58AM +0800, Wu Fengguang wrote:
> > Now.  How do we know that this patch improves Linux?
> 
> Hmm, it seems hard to get measurable performance numbers.
> 
> But we know that the running executable code is precious and shall be
> protected, and the patch protects them in this way:
> 
>         before patch: will be reclaimed if not referenced in I
>         after  patch: will be reclaimed if not referenced in I+A

s/will/may/, to be more exact.

> where
>         A = time to fully scan the active   file LRU
>         I = time to fully scan the inactive file LRU
> 
> Note that normally A >> I.
> 
> Therefore this patch greatly prolongs the in-cache time of executable code,
> when there are moderate memory pressures.

Thanks,
Fengguang

