Return-Path: <linux-kernel-owner+w=401wt.eu-S1757451AbXIMNEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451AbXIMNEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 09:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbXIMNEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 09:04:25 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53348 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753034AbXIMNEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 09:04:24 -0400
Date: Thu, 13 Sep 2007 23:03:42 +1000
From: David Chinner <dgc@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: David Chinner <dgc@sgi.com>, Mel Gorman <mel@skynet.ie>,
       Christoph Lameter <clameter@sgi.com>, andrea@suse.de,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Message-ID: <20070913130342.GT734179@sgi.com>
References: <20070911060349.993975297@sgi.com> <200709120127.33832.nickpiggin@yahoo.com.au> <20070913014905.GV995458@sgi.com> <200709130323.22534.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709130323.22534.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2007 at 03:23:21AM +1000, Nick Piggin wrote:
> On Thursday 13 September 2007 11:49, David Chinner wrote:
> > On Wed, Sep 12, 2007 at 01:27:33AM +1000, Nick Piggin wrote:
> 
> > > I just gave 4 things which combined might easily reduce xfs vmap overhead
> > > by several orders of magnitude, all without changing much code at all.
> >
> > Patches would be greatly appreciately. You obviously understand this
> > vm code much better than I do, so if it's easy to fix by adding some
> > generic vmap cache thingy, please do.
> 
> Well, it may not be easy to _fix_, but it's easy to try a few improvements ;)
> 
> How do I make an image and run a workload that will coerce XFS into
> doing a significant number of vmaps?

# mkfs.xfs -n size=16384 <dev>

to create a filesystem with a 16k directory block size on a 4k page
machine.

Then just do operations on directories with lots of files in them
(tens of thousands). Every directory operation will require at
least one vmap in this situation - e.g. a traversal will result in
lots and lots of blocks being read that will require vmap() for every
directory block read from disk and an unmap almost immediately
afterwards when the reference is dropped....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
