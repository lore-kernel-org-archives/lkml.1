Return-Path: <linux-kernel-owner+w=401wt.eu-S1758113AbXFOApx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113AbXFOApx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 20:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbXFOApp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 20:45:45 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:38309 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753091AbXFOApo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 20:45:44 -0400
Date: Thu, 14 Jun 2007 17:45:43 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [patch 00/14] Page cache cleanup in anticipation of Large
 Blocksize support
In-Reply-To: <20070614154939.c94b097f.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706141742580.3220@schroedinger.engr.sgi.com>
References: <20070614193839.878721298@sgi.com> <20070614130645.cabdff1b.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706141411180.1579@schroedinger.engr.sgi.com>
 <20070614143248.736312f8.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706141436030.1797@schroedinger.engr.sgi.com>
 <20070614150417.c73fb6b9.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706141517120.2240@schroedinger.engr.sgi.com>
 <20070614154939.c94b097f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2007, Andrew Morton wrote:

> > I do not think that the 100% users will do kernel compiles all day like 
> > we do. We likely would prefer 4k page size for our small text files.
> 
> There are many, many applications which use small files.

There is no problem with them using 4k page size concurrently to a higher 
page size for other files.

> > I never understood the point of that exercise. If you have variable page 
> > size then the 64k page size can be used specific to files that benefit 
> > from it. Typically usage scenarios are video audio streaming I/O, large 
> > picture files, large documents with embedded images. These are the major
> > usage scenarioes today and we suck the. Our DVD/CD subsystems are 
> > currently not capable of directly reading from these devices into the page 
> > cache since they do not do I/O in 4k chunks.
> 
> So with sufficient magical kernel heuristics or operator intervention, some
> people will gain some benefit from 64k pagesize.  Most people with most
> workloads will remain where they are: shoving zillions of physically
> discontiguous pages into fixed-size sg lists.

Magical? There is nothing magical about doing transfers in the size that 
is supported by a device. That is good sense.

> > Every 64k block contains more information and the number of pages managed
> > is reduced by a factor of 16. Less seeks , less tlb pressure , less reads, 
> > more cpu cache and cpu cache prefetch friendly behavior.
> 
> argh.  Everything you say is just wrong.  A fsck involves zillions of
> discontiguous small reads.  It is largely seek-bound, so there is no
> benefit to be had here.  Your proposed change will introduce regressions by
> causing larger amounts of physical reading and large amounts of memory
> consumption.

Of course there is. The seeks are reduced since there are an factor 
of 16 less metadata blocks. fsck does not read files. It just reads 
metadata structures. And the larger contiguous areas the faster.

