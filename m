Return-Path: <linux-kernel-owner+w=401wt.eu-S1753110AbZIWOJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbZIWOJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 10:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbZIWOJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 10:09:21 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:17870 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbZIWOJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 10:09:20 -0400
Date: Wed, 23 Sep 2009 10:08:40 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
       Christoph Hellwig <hch@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "jack@suse.cz" <jack@suse.cz>
Subject: Re: [PATCH 0/7] Per-bdi writeback flusher threads v20
Message-ID: <20090923140840.GB2794@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Wu Fengguang <fengguang.wu@intel.com>, Theodore Tso <tytso@mit.edu>,
	Jens Axboe <jens.axboe@oracle.com>,
	Christoph Hellwig <hch@infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"jack@suse.cz" <jack@suse.cz>
References: <20090918175252.GF26991@mit.edu>
 <20090919035835.GA9921@localhost>
 <20090919040051.GA10245@localhost>
 <20090919042607.GA19752@localhost>
 <20090921135321.GD6259@think>
 <20090922101335.GA27432@localhost>
 <20090922113055.GI10825@think>
 <20090922131832.GB7675@localhost>
 <20090922155941.GM10825@think>
 <20090923010541.GB6382@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090923010541.GB6382@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: abhmt001.oracle.com [141.146.116.10]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4ABA2BEC.007C:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 09:05:41AM +0800, Wu Fengguang wrote:

[ timeslice based limits on number of pages sent by the bdi threads ]

> > 
> > The reason I prefer the timeslice idea is that we don't need the
> > hardware to tell us how fast it is.  We just write for a while and move
> > on.
> 
> That makes sense.  Note that the triple (pages, page segments,
> submission time) can somehow adapt to hardware capabilities
> (and at least won't hurt fast arrays).
> 
> - max pages are set to large enough number for big arrays
> - max page segments could be based on the existing blk_queue_nonrot()
> - submission time = 1s, which is mainly a safeguard for slow devices
>   (ie. usb stick), to prevent one single inode from taking too much
>   time. This time limit has little performance impacts.
> 
> Possible merits are
> - these parameters are concrete ones and easy to handle
> - it's natural to implement related logics in the VFS level
> - file systems can do nothing to get most benefits
> 
> Also the (now necessary) per-invocation limit could be somehow
> eliminated when balance_dirty_pages() does not do IO itself.

I think there are probably a lot of good ways to improve on our single
max number of pages metric from today, but I'm worried about the
calculation time finding page segments.  The radix tree
isn't all that well suited to it.

But, if you've got a patch I'd be happy to run a comparison against it.
Jens' box will be better at showing any CPU cost to the radix walking.

-chris

