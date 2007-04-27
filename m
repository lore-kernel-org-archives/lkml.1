Return-Path: <linux-kernel-owner+w=401wt.eu-S1755447AbXD0IhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbXD0IhX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 04:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755472AbXD0IhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 04:37:23 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34406 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755447AbXD0IhW (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 04:37:22 -0400
Date: Fri, 27 Apr 2007 18:37:01 +1000
From: David Chinner <dgc@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070427083701.GH32602149@melbourne.sgi.com>
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

Sure they can - but then the variable size page cache becomes even
more trivial to implement. ;)

> > Dave, where are we with the performance tests?
> 
> Well yes.

Backed up behind real work. :/

Hopefully I'll have something tonight from my small test box.
it'll be some time next week before I get a chance to do anything
on a hardware raid array.

> Do note that if the numbers are good, we also need to look at how generally
> useful this work is.  For example, if it only benefits one particular
> arguably-crippled present-generation adapter then that of course weakens the
> case.

I think you mistook my "hw RAID" as a "HW RAID adapter". I was
talking about "HW RAID arrays" as in rack mounted controllers on the
other end of multiple FC HCAs.

What I'm talking about is the difference in perfomrance when we can
do large enough I/Os to be able to do full-stripe writes on this
sort of hardware.  Modern HW raid arrays go much faster when you do
aligned, full-stripe width writes and right now x86_64 linux is
not able to do this....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
