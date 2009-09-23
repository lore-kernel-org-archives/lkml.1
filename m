Return-Path: <linux-kernel-owner+w=401wt.eu-S1752507AbZIWN6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbZIWN6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 09:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbZIWN6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 09:58:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:7603 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425AbZIWN6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 09:58:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,438,1249282800"; 
   d="scan'208";a="190759713"
Date: Wed, 23 Sep 2009 21:58:07 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6 -v2] writeback: balance_dirty_pages() shall write
	more than dirtied pages
Message-ID: <20090923135807.GA11607@localhost>
References: <20090923123337.990689487@intel.com> <20090923124027.456325340@intel.com> <20090923135600.GA11463@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090923135600.GA11463@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 09:56:00PM +0800, Wu Fengguang wrote:
> -static inline long sync_writeback_pages(void)
> +static inline long sync_writeback_pages(unsigned long dirtied)
>  {
> -	return ratelimit_pages + ratelimit_pages / 2;
> +	if (dirtied < ratelimit_pages)
> +		dirtied = ratelimit_pages;

Just added the above checks. Now balance_dirty_pages() for XFS 
works in a much larger 1536 chunk size :)

[   40.374081] redirty_tail() +516: inode=131
[   40.374951] mm/page-writeback.c +543 balance_dirty_pages(): comm=cp pid=3296 n=1536
[   40.377001] global dirty=49818 writeback=17027 nfs=0 flags=CM towrite=0 skipped=0

> +
> +	return dirtied + dirtied / 2;
>  }

Thanks,
Fengguang

