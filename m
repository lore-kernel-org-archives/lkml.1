Return-Path: <linux-kernel-owner+w=401wt.eu-S1760703AbZJINP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760703AbZJINP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 09:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757298AbZJINP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 09:15:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:56425 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbZJINP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 09:15:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,532,1249282800"; 
   d="scan'208";a="197027867"
Date: Fri, 9 Oct 2009 21:14:36 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ehrhardt Christian <ehrhardt@linux.vnet.ibm.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] mm: make VM_MAX_READAHEAD configurable
Message-ID: <20091009131436.GA23774@localhost>
References: <1255087175-21200-1-git-send-email-ehrhardt@linux.vnet.ibm.com> <1255090830.8802.60.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255090830.8802.60.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09, 2009 at 02:20:30PM +0200, Peter Zijlstra wrote:
> On Fri, 2009-10-09 at 13:19 +0200, Ehrhardt Christian wrote:
> > From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
> > 
> > On one hand the define VM_MAX_READAHEAD in include/linux/mm.h is just a default
> > and can be configured per block device queue.
> > On the other hand a lot of admins do not use it, therefore it is reasonable to
> > set a wise default.
> > 
> > This path allows to configure the value via Kconfig mechanisms and therefore
> > allow the assignment of different defaults dependent on other Kconfig symbols.
> > 
> > Using this, the patch increases the default max readahead for s390 improving
> > sequential throughput in a lot of scenarios with almost no drawbacks (only
> > theoretical workloads with a lot concurrent sequential read patterns on a very
> > low memory system suffer due to page cache trashing as expected).
> 
> Why can't this be solved in userspace?
> 
> Also, can't we simply raise this number if appropriate? Wu did some

Agreed, and Ehrhardt's 512KB readahead size looks like a good default :)

> read-ahead trashing detection bits a long while back which should scale
> the read-ahead window back when we're low on memory, not sure that ever
> made it in, but that sounds like a better option than having different
> magic numbers for each platform.

The current kernel could roughly estimate the thrashing safe size (the
context readahead). However that's not enough. Context readahead is
normally active only for interleaved reads. The normal behavior is to
scale up readahead size aggressively. For better support for embedded
systems, we may need a flag/mode which tells: "we recently experienced
thrashing, so estimate and stick to the thrashing safe size instead of
keep scaling up readahead size and thus risk thrashing again".

Thanks,
Fengguang
