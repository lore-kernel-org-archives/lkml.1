Return-Path: <linux-kernel-owner+w=401wt.eu-S1759260AbZJGOZC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260AbZJGOZC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 10:25:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759246AbZJGOZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 10:25:01 -0400
Received: from mga03.intel.com ([143.182.124.21]:61637 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758310AbZJGOZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 10:25:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,519,1249282800"; 
   d="scan'208";a="196083550"
Date: Wed, 7 Oct 2009 22:23:30 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       Myklebust Trond <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/45] writeback: quit on wrap for .range_cyclic
	(pohmelfs)
Message-ID: <20091007142330.GA8622@localhost>
References: <20091007073818.318088777@intel.com> <20091007074902.268825252@intel.com> <20091007123211.GA29371@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091007123211.GA29371@ioremap.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 08:32:11PM +0800, Evgeniy Polyakov wrote:
> Hi.
> 
> On Wed, Oct 07, 2009 at 03:38:27PM +0800, Wu Fengguang (fengguang.wu@intel.com) wrote:
> > Convert wbc.range_cyclic to new behavior: when past EOF, abort writeback
> > of the inode, which instructs writeback_single_inode() to delay it for 
> > a while if necessary.
> > 
> > It removes one inefficient .range_cyclic IO pattern when writeback_index
> > wraps:
> > 	submit [10000-10100], (wrap), submit [0-100]
> > In which the submitted pages may be consisted of two distant ranges.
> > 
> > It also prevents submitting pointless IO for busy overwriters.
> 
> I have no objections against this patchset, since I followed the
> upstream writeback behaviour and did not personally observe such wraps
> which would be otherwise handled in a single run.

OK, thanks!

Fengguang
