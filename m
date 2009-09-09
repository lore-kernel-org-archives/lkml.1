Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549AbZIIXaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbZIIXaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 19:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbZIIXaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 19:30:04 -0400
Received: from thunk.org ([69.25.196.29]:51868 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810AbZIIXaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 19:30:03 -0400
Date: Wed, 9 Sep 2009 19:29:38 -0400
From: Theodore Tso <tytso@mit.edu>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>, jack@suse.cz,
       Artem Bityutskiy <dedekind1@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC][PATCH 5/7] writeback: use 64MB MAX_WRITEBACK_PAGES
Message-ID: <20090909232938.GD24951@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Wu Fengguang <fengguang.wu@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	Dave Chinner <david@fromorbit.com>,
	Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Christoph Hellwig <hch@infradead.org>, jack@suse.cz,
	Artem Bityutskiy <dedekind1@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
References: <20090909145141.293229693@intel.com> <20090909150600.874037375@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090909150600.874037375@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 09, 2009 at 10:51:46PM +0800, Wu Fengguang wrote:
> + * The maximum number of pages to writeout in a single periodic/background
> + * writeback operation. 64MB means I_SYNC may be hold for up to 1 second.
> + * This is not a big problem since we normally do kind of trylock on I_SYNC
> + * for non-data-integrity writes.  Userspace tasks doing throttled writeback
> + * do not use this value.

What's your justification for using 64MB?  Where are you getting 1
second from?  On a fast RAID array 64MB can be written in much less
than 1 second.

More generally, I assume your patches conflict with Jens' per-bdi patches?

     		  	      	      	       - Ted
