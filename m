Return-Path: <linux-kernel-owner+w=401wt.eu-S1763612AbXIKMRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763612AbXIKMRh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 08:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbXIKMR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 08:17:27 -0400
Received: from lazybastard.de ([212.112.238.170]:59174 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbXIKMRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 08:17:25 -0400
Date: Tue, 11 Sep 2007 14:12:26 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <clameter@sgi.com>, andrea@suse.de,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Message-ID: <20070911121225.GE13132@lazybastard.org>
References: <20070911060349.993975297@sgi.com> <200709110452.20363.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200709110452.20363.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 September 2007 04:52:19 +1000, Nick Piggin wrote:
> On Tuesday 11 September 2007 16:03, Christoph Lameter wrote:
> 
> > 5. VM scalability
> >    Large block sizes mean less state keeping for the information being
> >    transferred. For a 1TB file one needs to handle 256 million page
> >    structs in the VM if one uses 4k page size. A 64k page size reduces
> >    that amount to 16 million. If the limitation in existing filesystems
> >    are removed then even higher reductions become possible. For very
> >    large files like that a page size of 2 MB may be beneficial which
> >    will reduce the number of page struct to handle to 512k. The variable
> >    nature of the block size means that the size can be tuned at file
> >    system creation time for the anticipated needs on a volume.
> 
> The idea that there even _is_ a bug to fail when higher order pages
> cannot be allocated was also brushed aside by some people at the
> vm/fs summit. I don't know if those people had gone through the
> math about this, but it goes somewhat like this: if you use a 64K
> page size, you can "run out of memory" with 93% of your pages free.
> If you use a 2MB page size, you can fail with 99.8% of your pages
> still free. That's 64GB of memory used on a 32TB Altix.

While I agree with your concern, those numbers are quite silly.  The
chances of 99.8% of pages being free and the remaining 0.2% being
perfectly spread across all 2MB large_pages are lower than those of SHA1
creating a collision.  I don't see anyone abandoning git or rsync, so
your extreme example clearly is the wrong one.

Again, I agree with your concern, even though your example makes it look
silly.

Jörn

-- 
You can't tell where a program is going to spend its time. Bottlenecks
occur in surprising places, so don't try to second guess and put in a
speed hack until you've proven that's where the bottleneck is.
-- Rob Pike
