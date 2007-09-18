Return-Path: <linux-kernel-owner+w=401wt.eu-S1757845AbXIRMcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845AbXIRMcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 08:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755326AbXIRMcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 08:32:00 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:55192 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756361AbXIRMb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 08:31:59 -0400
Date: Tue, 18 Sep 2007 22:31:07 +1000
From: David Chinner <dgc@sgi.com>
To: Mel Gorman <mel@skynet.ie>
Cc: Christoph Lameter <clameter@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joern Engel <joern@logfs.org>, andrea@suse.de,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Message-ID: <20070918123107.GW23367404@sgi.com>
References: <20070911060349.993975297@sgi.com> <87ir6c3z2l.fsf@informatik.uni-tuebingen.de> <20070916181313.GA16406@skynet.ie> <200709161903.37295.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709171458541.29993@schroedinger.engr.sgi.com> <20070918100040.GB2035@skynet.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070918100040.GB2035@skynet.ie>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 11:00:40AM +0100, Mel Gorman wrote:
> We still lack data on what sort of workloads really benefit from large
> blocks (assuming there are any that cannot also be solved by improving
> order-0).

No we don't. All workloads benefit from larger block sizes when
you've got a btree tracking 20 million inodes and a create has to
search that tree for a free inode.  The tree gets much wider and
hence we take fewer disk seeks to traverse the tree. Same for large
directories, btree's tracking free space, etc - everything goes
faster with a larger filesystem block size because we spent less
time doing metadata I/O.

And the other advantage is that sequential I/O speeds also tend to
increase with larger block sizes. e.g. XFS on an Altix (16k pages)
using 16k block size is about 20-25% faster on writes than 4k block
size. See the graphs at the top of page 12:

http://oss.sgi.com/projects/xfs/papers/ols2006/ols-2006-paper.pdf

The benefits are really about scalability and with terabyte sized
disks on the market.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
