Return-Path: <linux-kernel-owner+w=401wt.eu-S932451AbXDFHCD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451AbXDFHCD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 03:02:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932469AbXDFHCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 03:02:03 -0400
Received: from amsfep16-int.chello.nl ([62.179.120.11]:41204 "EHLO
	amsfep16-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932451AbXDFHCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 03:02:01 -0400
Subject: Re: [PATCH 12/12] mm: per BDI congestion feedback
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       neilb@suse.de, dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com,
       nikita@clusterfs.com
In-Reply-To: <20070405162425.eb78c701.akpm@linux-foundation.org>
References: <20070405174209.498059336@programming.kicks-ass.net>
	 <20070405174320.649550491@programming.kicks-ass.net>
	 <20070405162425.eb78c701.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 06 Apr 2007 09:01:57 +0200
Message-Id: <1175842917.6483.130.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-05 at 16:24 -0700, Andrew Morton wrote:
> On Thu, 05 Apr 2007 19:42:21 +0200
> root@programming.kicks-ass.net wrote:
> 
> > Now that we have per BDI dirty throttling is makes sense to also have oer BDI
> > congestion feedback; why wait on another device if the current one is not
> > congested.
> 
> Similar comments apply.  congestion_wait() should be called
> throttle_at_a_rate_proportional_to_the_speed_of_presently_uncongested_queues().
> 
> If a process is throttled in the page allocator waiting for pages to become
> reclaimable, that process absolutely does not care whether those pages were
> previously dirty against /dev/sda or against /dev/sdb.  It wants to be woken
> up for writeout completion against any queue.

OK, so you disagree with Miklos' 2nd point here:
  http://lkml.org/lkml/2007/4/4/137

And in the light of clear_bdi_congestion() being called for each
writeout completion under the threshold this does make sense.

So this whole 8-12/12 series is not needed and just served as an
learning experience :-/


