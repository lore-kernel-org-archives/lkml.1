Return-Path: <linux-kernel-owner+w=401wt.eu-S1751769AbXISBbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbXISBbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 21:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751009AbXISBbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 21:31:06 -0400
Received: from mail.app.aconex.com ([203.89.192.138]:33828 "EHLO
	postoffice.aconex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750983AbXISBbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 21:31:05 -0400
X-Greylist: delayed 2054 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Sep 2007 21:31:04 EDT
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrea Arcangeli <andrea@suse.de>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, Mel Gorman <mel@skynet.ie>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
In-Reply-To: <alpine.LFD.0.999.0709181239320.16478@woody.linux-foundation.org>
References: <20070911060349.993975297@sgi.com>
	 <200709161853.12050.nickpiggin@yahoo.com.au>
	 <Pine.LNX.4.64.0709171510280.29993@schroedinger.engr.sgi.com>
	 <200709181116.22573.nickpiggin@yahoo.com.au>
	 <alpine.LFD.0.999.0709181126330.16478@woody.linux-foundation.org>
	 <20070918191853.GB7541@v2.random>
	 <alpine.LFD.0.999.0709181239320.16478@woody.linux-foundation.org>
Content-Type: text/plain
Organization: Aconex
Date: Wed, 19 Sep 2007 10:58:42 +1000
Message-Id: <1190163523.24970.378.camel@edge.yarra.acx>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-18 at 12:44 -0700, Linus Torvalds wrote:
> This is not about performance. Never has been. It's about SGI wanting a 
> way out of their current 16kB mess.

Pass the crack pipe, Linus?

> The way to fix performance is to move to x86-64, and use 4kB pages and be 
> happy. However, the SGI people want a 16kB (and possibly bigger) 
> crap-option for their people who are (often _already_) running some 
> special case situation that nobody else cares about.

FWIW (and I hate to let reality get in the way of a good conspiracy) -
all SGI systems have always defaulted to using 4K blocksize filesystems;
there's very few customers who would use larger, especially as the Linux
kernel limitations in this area are well known.  There's no "16K mess"
that SGI is trying to clean up here (and SGI have offered both IA64 and
x86_64 systems for some time now, so not sure how you came up with that
whacko theory).

> It's not about "performance". If it was, they would never have used ia64

For SGI it really is about optimising ondisk layouts for some workloads
and large filesystems, and has nothing to do with IA64.  Read the paper
Dave sent out earlier, it's quite interesting.

For other people, like AntonA, who has also been asking for this
functionality literally for years (and ended up trying to do his own
thing inside NTFS IIRC) it's to be able to access existing filesystems
from other operating systems.  Here's a more recent discussion, I know
Anton had discussed it several times on fsdevel before this 2005 post
too:   http://oss.sgi.com/archives/xfs/2005-01/msg00126.html

Although I'm sure others exist, I've never worked on any platform other
than Linux that doesn't support filesystem block sizes larger than the
pagesize.  Its one thing to stick your head in the sand about the need
for this feature, its another thing entirely to try pass it off as an
"SGI mess", sorry.

I do entirely support the sentiment to stop this pissing match and get
on with fixing the problem though.

cheers.

--
Nathan

