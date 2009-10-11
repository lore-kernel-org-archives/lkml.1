Return-Path: <linux-kernel-owner+w=401wt.eu-S1755730AbZJKBKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730AbZJKBKx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 21:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755605AbZJKBKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 21:10:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:34073 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755507AbZJKBKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 21:10:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,539,1249282800"; 
   d="scan'208";a="197519815"
Date: Sun, 11 Oct 2009 09:10:06 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ehrhardt Christian <ehrhardt@linux.vnet.ibm.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: make VM_MAX_READAHEAD configurable
Message-ID: <20091011011006.GA20205@localhost>
References: <1255087175-21200-1-git-send-email-ehrhardt@linux.vnet.ibm.com> <1255090830.8802.60.camel@laptop> <20091009122952.GI9228@kernel.dk> <20091009154950.43f01784@mschwide.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091009154950.43f01784@mschwide.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin,

On Fri, Oct 09, 2009 at 09:49:50PM +0800, Martin Schwidefsky wrote:
> On Fri, 9 Oct 2009 14:29:52 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Fri, Oct 09 2009, Peter Zijlstra wrote:
> > > On Fri, 2009-10-09 at 13:19 +0200, Ehrhardt Christian wrote:
> > > > From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
> > > > 
> > > > On one hand the define VM_MAX_READAHEAD in include/linux/mm.h is just a default
> > > > and can be configured per block device queue.
> > > > On the other hand a lot of admins do not use it, therefore it is reasonable to
> > > > set a wise default.
> > > > 
> > > > This path allows to configure the value via Kconfig mechanisms and therefore
> > > > allow the assignment of different defaults dependent on other Kconfig symbols.
> > > > 
> > > > Using this, the patch increases the default max readahead for s390 improving
> > > > sequential throughput in a lot of scenarios with almost no drawbacks (only
> > > > theoretical workloads with a lot concurrent sequential read patterns on a very
> > > > low memory system suffer due to page cache trashing as expected).
[snip]
> 
> The patch from Christian fixes a performance regression in the latest
> distributions for s390. So we would opt for a larger value, 512KB seems
> to be a good one. I have no idea what that will do to the embedded
> space which is why Christian choose to make it configurable. Clearly
> the better solution would be some sort of system control that can be
> modified at runtime. 

May I ask for more details about your performance regression and why
it is related to readahead size? (we didn't change VM_MAX_READAHEAD..)

Thanks,
Fengguang
