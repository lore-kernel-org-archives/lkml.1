Return-Path: <linux-kernel-owner+w=401wt.eu-S1754284AbXFOCho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284AbXFOCho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 22:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbXFOChh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 22:37:37 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:42332 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751016AbXFOChg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 22:37:36 -0400
Date: Thu, 14 Jun 2007 19:37:35 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [patch 00/14] Page cache cleanup in anticipation of Large
 Blocksize support
In-Reply-To: <20070614192340.13d99e84.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706141931510.3749@schroedinger.engr.sgi.com>
References: <20070614193839.878721298@sgi.com> <20070614130645.cabdff1b.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706141411180.1579@schroedinger.engr.sgi.com>
 <20070614143248.736312f8.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706141436030.1797@schroedinger.engr.sgi.com>
 <20070614150417.c73fb6b9.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706141517120.2240@schroedinger.engr.sgi.com>
 <20070614154939.c94b097f.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706141742580.3220@schroedinger.engr.sgi.com>
 <20070614184013.1ff51d34.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706141855570.3571@schroedinger.engr.sgi.com>
 <20070614192340.13d99e84.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2007, Andrew Morton wrote:

> > The metadata needs to refer to 1/16th of the earlier pages that need to be 
> > tracked. metadata is shrunk significantly.
> 
> Only if the filesystems are altered to use larger blocksizes and if the
> operator then chooses to use that feature.  Then they suck for small-sized
> (and even medium-sized) files.

Nope. File systems already support that. The changes to XFS and ext2 are 
basically just doing the cleanups that we are discussing here plus some 
changes to set_blocksize.
 
> So you're still talking about corner cases: specialised applications which
> require careful setup and administrator intervention.
> 
> What can we do to optimise the common case?

The common filesystem will be able to support large block sizes easily. 
Most filesystems already run on 16k and 64k page size platforms and do 
just fine. All the work is already done. Just the VM needs to give them 
support for lager page sizes on smaller page size platforms.

This is optimizing the common case.

> The alleged fsck benefit is also unrelated to variable PAGE_CACHE_SIZE. 
> It's a feature of larger (unweildy?) blocksize, and xfs already has that
> working (doesn't it?)

It has a hack with severe limitations like we have done in many other 
components of the kernel. These hacks can be removed if the large 
blocksize support is merged. XFS still has the problem that the block 
layer without page cache support for higher pages cannot easily deal with 
large contiguous pages.

> There may be some benefits to some future version of ext4.

I have already run ext4 with 64k blocksize on x86_64 with 4k. It has been 
done for years with 64k page size on IA64 and powerpc and there is no fs 
issue with running it on 4k platforms with the large blocksize patchset.
The filesystems work reliably. The core linux code is the issue that we 
need to solve and this is the beginning of doing so.
 
