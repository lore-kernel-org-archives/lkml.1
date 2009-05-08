Return-Path: <linux-kernel-owner+w=401wt.eu-S1758756AbZEHDnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756AbZEHDnL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 23:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbZEHDm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 23:42:56 -0400
Received: from ultra7.eskimo.com ([204.122.16.70]:3647 "EHLO ultra7.eskimo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787AbZEHDmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 23:42:55 -0400
Date: Thu, 7 May 2009 20:40:54 -0700
From: Elladan <elladan@eskimo.com>
To: Rik van Riel <riel@redhat.com>
Cc: Christoph Lameter <cl@linux.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, Elladan <elladan@eskimo.com>,
       Nick Piggin <npiggin@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH -mm] vmscan: make mapped executable pages the first
	class citizen
Message-ID: <20090508034054.GB1202@eskimo.com>
References: <20090501123541.7983a8ae.akpm@linux-foundation.org> <20090503031539.GC5702@localhost> <1241432635.7620.4732.camel@twins> <20090507121101.GB20934@localhost> <alpine.DEB.1.10.0905070935530.24528@qirst.com> <1241705702.11251.156.camel@twins> <alpine.DEB.1.10.0905071016410.24528@qirst.com> <1241712000.18617.7.camel@lts-notebook> <alpine.DEB.1.10.0905071231090.10171@qirst.com> <4A03164D.90203@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A03164D.90203@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 01:11:41PM -0400, Rik van Riel wrote:
> Christoph Lameter wrote:
>
>> We need some way to control this. If there would be a way to simply switch
>> off eviction of exec pages (via /proc/sys/vm/never_reclaim_exec_pages or
>> so) I'd use it.
>
> Nobody (except you) is proposing that we completely disable
> the eviction of executable pages.  I believe that your idea
> could easily lead to a denial of service attack, with a user
> creating a very large executable file and mmaping it.
>
> Giving executable pages some priority over other file cache
> pages is nowhere near as dangerous wrt. unexpected side effects
> and should work just as well.

I don't think this sort of DOS is relevant for a single user or trusted user
system.  

I don't know of any distro that applies default ulimits, so desktops are
already susceptible to the far more trivial "call malloc a lot" or "fork bomb"
attacks.  Plus, ulimits don't help, since they only apply per process - you'd
need a default mem cgroup before this mattered, I think.

Thanks,
Elladan

