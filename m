Return-Path: <linux-kernel-owner+w=401wt.eu-S1761329AbXIUUnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761329AbXIUUnV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757631AbXIUUnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:43:09 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:34524 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757956AbXIUUnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:43:07 -0400
Date: Fri, 21 Sep 2007 21:41:04 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Christoph Lameter <clameter@sgi.com>
cc: David Chinner <dgc@sgi.com>, Andrea Arcangeli <andrea@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nathan Scott <nscott@aconex.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Mel Gorman <mel@skynet.ie>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
In-Reply-To: <Pine.LNX.4.64.0709201105350.8626@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0709212044280.6532@blonde.wat.veritas.com>
References: <200709161853.12050.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0709171510280.29993@schroedinger.engr.sgi.com>
 <200709181116.22573.nickpiggin@yahoo.com.au>
 <alpine.LFD.0.999.0709181126330.16478@woody.linux-foundation.org>
 <20070918191853.GB7541@v2.random> <alpine.LFD.0.999.0709181239320.16478@woody.linux-foundation.org>
 <1190163523.24970.378.camel@edge.yarra.acx>
 <alpine.LFD.0.999.0709181803020.16478@woody.linux-foundation.org>
 <20070919050910.GK995458@sgi.com> <20070919140430.GJ4608@v2.random>
 <20070920013821.GR995458@sgi.com> <Pine.LNX.4.64.0709201105350.8626@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2007, Christoph Lameter wrote:
> On Thu, 20 Sep 2007, David Chinner wrote:
> > > Disagree, the mmap side is not a little change.
> > 
> > That's not in the filesystem, though. ;)
> 
> And its really only a minimal change for some function to loop over all 
> 4k pages and elsewhere index the right 4k subpage.

I agree with you on that: the changes you had to make to support mmap
were _much_ less bothersome than I'd been fearing, and I'm surprised
some people still see that side of it as a sticking point.

But I've kept very quiet because I remain quite ambivalent about the
patchset: I'm somewhere on the spectrum between you and Nick, shifting
my position from hour to hour.  Don't expect any decisiveness from me.

In some senses I'm even further off the scale away from you: I'm
dubious even of Nick and Andrew's belief in opportunistic contiguity.  
Just how hard should we trying for contiguity?  How far should we
go in sacrificing our earlier "LRU" principles?  It's easy to bump
up PAGE_ALLOC_COSTLY_ORDER, but what price do we pay when we do?

I agree with those who want to see how the competing approaches
work out in practice: which is frustrating for you, yes, because
you are so close to ready.  (I've not glanced at virtual compound,
but had been wondering in that direction before you suggested it.)

I do think your patchset is, for the time being at least, a nice
out-of-tree set, and it's grand to be able to bring a filesystem
from another arch with larger pagesize and get at the data from it.

I've found some fixes needed on top of your Large Blocksize Support
patches: I'll send those to you in a moment.  Looks like you didn't
try much swapping!

I only managed to get ext2 working with larger blocksizes:
reiserfs -b 8192 wouldn't mount ("reiserfs_fill_super: can not find
reiserfs on /dev/sdb1"); ext3 gave me mysterious errors ("JBD: tar
wants too many credits", even after adding JBD patches that you
turned out to be depending on); and I didn't try ext4 or xfs
(I'm guessing the latter has been quite well tested ;)

Hugh
