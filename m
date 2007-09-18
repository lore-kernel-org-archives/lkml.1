Return-Path: <linux-kernel-owner+w=401wt.eu-S1756180AbXIRKAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbXIRKAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 06:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbXIRKAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 06:00:45 -0400
Received: from gir.skynet.ie ([193.1.99.77]:48332 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556AbXIRKAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 06:00:44 -0400
Date: Tue, 18 Sep 2007 11:00:40 +0100
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
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
Message-ID: <20070918100040.GB2035@skynet.ie>
References: <20070911060349.993975297@sgi.com> <87ir6c3z2l.fsf@informatik.uni-tuebingen.de> <20070916181313.GA16406@skynet.ie> <200709161903.37295.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709171458541.29993@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709171458541.29993@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (17/09/07 15:00), Christoph Lameter didst pronounce:
> On Sun, 16 Sep 2007, Nick Piggin wrote:
> 
> > I don't know how it would prevent fragmentation from building up
> > anyway. It's commonly the case that potentially unmovable objects
> > are allowed to fill up all of ram (dentries, inodes, etc).
> 
> Not in 2.6.23 with ZONE_MOVABLE. Unmovable objects are not allocated from 
> ZONE_MOVABLE and thus the memory that can be allocated for them is 
> limited.
> 

As Nick points out, having to configure something makes it a #2
solution. However, I at least am ok with that. ZONE_MOVABLE is a get-out
clause to be able to control fragmentation no matter what the workload is
as it gives hard guarantees. Even when ZONE_MOVABLE is replaced by some
mechanism in grouping pages by mobility to force a number of blocks to be
MIGRATE_MOVABLE_ONLY, the emergency option will exist,

We still lack data on what sort of workloads really benefit from large
blocks (assuming there are any that cannot also be solved by improving
order-0). With Christophs approach + grouping pages by mobility +
ZONE_MOVABLE-if-it-screws-up, people can start collecting that data over the
course of the next few months while we're waiting for fsblock or software
pagesize to mature.

Do we really need to keep discussing this as no new point has been made ina
while? Can we at least take out the non-contentious parts of Christoph's
patches such as the page cache macros and do something with them?

-- 
Mel "tired of typing" Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
