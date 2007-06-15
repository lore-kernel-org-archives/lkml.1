Return-Path: <linux-kernel-owner+w=401wt.eu-S1754515AbXFOJDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbXFOJDg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 05:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbXFOJDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 05:03:17 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:55338 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753250AbXFOJDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 05:03:16 -0400
Date: Fri, 15 Jun 2007 19:03:05 +1000
From: David Chinner <dgc@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       hch@infradead.org
Subject: Re: [patch 00/14] Page cache cleanup in anticipation of Large Blocksize support
Message-ID: <20070615090305.GP86004887@sgi.com>
References: <Pine.LNX.4.64.0706141411180.1579@schroedinger.engr.sgi.com> <20070614143248.736312f8.akpm@linux-foundation.org> <Pine.LNX.4.64.0706141436030.1797@schroedinger.engr.sgi.com> <20070614150417.c73fb6b9.akpm@linux-foundation.org> <Pine.LNX.4.64.0706141517120.2240@schroedinger.engr.sgi.com> <20070614154939.c94b097f.akpm@linux-foundation.org> <Pine.LNX.4.64.0706141742580.3220@schroedinger.engr.sgi.com> <20070614184013.1ff51d34.akpm@linux-foundation.org> <Pine.LNX.4.64.0706141855570.3571@schroedinger.engr.sgi.com> <20070614192340.13d99e84.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070614192340.13d99e84.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 07:23:40PM -0700, Andrew Morton wrote:
> On Thu, 14 Jun 2007 19:04:27 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:
> > > > Of course there is. The seeks are reduced since there are an factor 
> > > > of 16 less metadata blocks. fsck does not read files. It just reads 
> > > > metadata structures. And the larger contiguous areas the faster.
> > > 
> > > Some metadata is contiguous: inode tables, some directories (if they got
> > > lucky), bitmap tables.  But fsck surely reads them in a single swoop
> > > anyway, so there's no gain there.
> > 
> > The metadata needs to refer to 1/16th of the earlier pages that need to be 
> > tracked. metadata is shrunk significantly.
> 
> Only if the filesystems are altered to use larger blocksizes and if the
> operator then chooses to use that feature.  Then they suck for small-sized
> (and even medium-sized) files.

Devil's Advocate:

In that case, we should remove support for block sizes smaller than
a page because they suck for large-sized (and even medium sized)
files and we shouldn't allow people to use them.

> So you're still talking about corner cases: specialised applications which
> require careful setup and administrator intervention.

Yes, like 512 byte block size filesystems using large directory
block sizes for dedicated mail servers. i.e. optimised for large
numbers of small files in each directory.

> What can we do to optimise the common case?

The common case is pretty good already for common case workloads.

What we need to do is provide options for workloads where tuning the
common case config is simply not sufficient. We already provide the
option to optimise for small file sizes, but we have no option to
optimise for large file sizes....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
