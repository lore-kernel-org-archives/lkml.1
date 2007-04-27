Return-Path: <linux-kernel-owner+w=401wt.eu-S1756075AbXD0Qpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbXD0Qpp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 12:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756077AbXD0Qpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 12:45:45 -0400
Received: from thunk.org ([69.25.196.29]:39759 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756075AbXD0Qpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 12:45:44 -0400
Date: Fri, 27 Apr 2007 12:45:35 -0400
From: Theodore Tso <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Chinner <dgc@sgi.com>, clameter@sgi.com,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070427164535.GH24852@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Chinner <dgc@sgi.com>, clameter@sgi.com,
	linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
	William Lee Irwin III <wli@holomorphy.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	Badari Pulavarty <pbadari@gmail.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>
References: <20070424222105.883597089@sgi.com> <20070426190438.3a856220.akpm@linux-foundation.org> <20070427022731.GF65285596@melbourne.sgi.com> <20070426195357.597ffd7e.akpm@linux-foundation.org> <20070427042046.GI65285596@melbourne.sgi.com> <20070426221528.655d79cb.akpm@linux-foundation.org> <20070427060921.GA77450368@melbourne.sgi.com> <20070427000403.6013d1fa.akpm@linux-foundation.org> <20070427080321.GG32602149@melbourne.sgi.com> <20070427014849.41f383f7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427014849.41f383f7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 01:48:49AM -0700, Andrew Morton wrote:
> And other filesystems (ie: ext4) _might_ use it.  But ext4 is extent-based,
> so perhaps it's not work churning the on-disk format to get a bit of a
> boost in the block allocator.

Well, ext3 could definitely use it; there are people using 8k and 16k
blocksizes on ia64 systems today.  Those filesystems can't be mounted
on x86 or x86_64 systems because our pagesize is 4k, though.

And I imagine that ext4 might want to use a large blocksize too ---
after all, XFS is extent based as well, and not _all_ of the
advantages of using a larger blocksize are related to brain-damaged
storage subsystems with short SG list support.  Whether the advantages
offset the internal fragmentation overhead or the complexity of adding
fragments support is a different question, of course.

So while the jury is out about how many other filesystems might use
it, I suspect it's more than you might think.  At the very least,
there may be some IA64 users who might be trying to transition their
way to x86_64, and have existing filesystems using a 8k or 16k
block filesystems.  :-)

						- Ted
