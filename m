Return-Path: <linux-kernel-owner+w=401wt.eu-S1756076AbXD0Qgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbXD0Qgq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 12:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756074AbXD0Qgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 12:36:46 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:34455 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756073AbXD0Qgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 12:36:42 -0400
Date: Sat, 28 Apr 2007 02:36:20 +1000
From: David Chinner <dgc@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070427163620.GI32602149@melbourne.sgi.com>
References: <20070424222105.883597089@sgi.com> <20070426190438.3a856220.akpm@linux-foundation.org> <20070427022731.GF65285596@melbourne.sgi.com> <20070426195357.597ffd7e.akpm@linux-foundation.org> <20070427042046.GI65285596@melbourne.sgi.com> <20070426221528.655d79cb.akpm@linux-foundation.org> <Pine.LNX.4.64.0704262239580.4758@schroedinger.engr.sgi.com> <20070426235542.bad7035a.akpm@linux-foundation.org> <Pine.LNX.4.64.0704270007100.5388@schroedinger.engr.sgi.com> <20070427002640.22a71d06.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427002640.22a71d06.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 12:26:40AM -0700, Andrew Morton wrote:
> On Fri, 27 Apr 2007 00:19:49 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:
> 
> > The page cache handling in the various layers is significantly 
> > simplified which reduces maintenance cost.
> 
> How on earth can the *addition* of variable pagecache size simplify the
> existing code?
> 
> What cleanups are in this patchset which cannot be made *without* the
> addition of variable pagecache size?

I think this is the cleanup of all the open coded masking and offset
to index type of operations that get done over and over again everywhere.

> > Dave, where are we with the performance tests?
> 
> Well yes.

Backed up behind real work ;)

The test was writing a single 50GB file to a fresh filesystem, and
then reading it back. Run on two different dm stripes - a 4-disk
RAID) and a 8disk RAID0 stripe, with a stripe unit of 512k.  Disks
are 10krpm SAS, external jbod on PCI-X good for ~850MB/s read and
~750MB/s write.  Server is 4p intel x86_64 with 16GB RAM.

                    READ            WRITE
blksz  disks     tput   sys       tput    sys
-----  -----    -----   ----      -----  ----
 4k      4       332     35s      203     76s
64k      4       173     20s      273     21s
 4k      8       403     35s      443     76s
64k      8       634     21s      540     21s

Throughput in MB/s.

So, there's some interaction between reads and large block size;
may be related to readahead but i haven't looked into I/O
patterns at this stage.

More results soonish.....

Cheers,

Dave.

-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
